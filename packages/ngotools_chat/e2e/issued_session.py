#!/usr/bin/env python3
"""Runs the issued-session test against the local e2e server.

Issues a MAS personal session with a fixed device (like NGO.Tools does for
the apps) and hands it to the ignored Rust test `issued_session_tests`,
which regenerates it while the client runs.
"""
import json
import os
import ssl
import subprocess
import time
import urllib.request
from base64 import b64encode
from pathlib import Path

HERE = Path(__file__).resolve().parent
SERVER = HERE / "server"
GEN = SERVER / "generated"
ENV = dict(line.strip().split("=", 1) for line in open(GEN / "secrets.env") if "=" in line)
MAS = "https://localhost:28449"
HOMESERVER = "https://localhost:28448"
CA = GEN / "caddy-root.crt"
CONTEXT = ssl.create_default_context(cafile=str(CA))


def call(method, url, token=None, body=None, basic=None, form=None):
    headers = {}
    data = None
    if token:
        headers["Authorization"] = f"Bearer {token}"
    if basic:
        headers["Authorization"] = "Basic " + b64encode(basic.encode()).decode()
    if body is not None:
        data = json.dumps(body).encode()
        headers["Content-Type"] = "application/json"
    if form is not None:
        data = form.encode()
        headers["Content-Type"] = "application/x-www-form-urlencoded"
    request = urllib.request.Request(url, data=data, method=method, headers=headers)
    with urllib.request.urlopen(request, context=CONTEXT) as response:
        return json.loads(response.read() or b"null")


admin = call(
    "POST", f"{MAS}/oauth2/token",
    basic=f"{ENV['MAS_ADMIN_CLIENT_ID']}:{ENV['MAS_ADMIN_CLIENT_SECRET']}",
    form="grant_type=client_credentials&scope=urn:mas:admin",
)["access_token"]

username = f"issued{int(time.time())}"
subprocess.run(
    ["docker", "compose", "--project-directory", str(SERVER), "--env-file", str(GEN / ".env"),
     "exec", "-T", "mas", "mas-cli", "manage", "register-user", "--yes",
     "--ignore-password-complexity", "--password", "e2e-password-1", username],
    check=True, capture_output=True,
)
user = call("GET", f"{MAS}/api/admin/v1/users/by-username/{username}", admin)["data"]
device = f"NGOAPP{int(time.time())}"
session = call("POST", f"{MAS}/api/admin/v1/personal-sessions", admin, {
    "actor_user_id": user["id"],
    "human_name": "NGO.Tools App (e2e)",
    "scope": f"urn:matrix:client:api:* urn:matrix:client:device:{device}",
    "expires_in": 3600,
})["data"]

env = dict(os.environ)
env.update({
    "CHAT_E2E_HOMESERVER": HOMESERVER,
    "CHAT_E2E_CA": str(CA),
    "CHAT_E2E_USER_ID": f"@{username}:chat-e2e.test",
    "CHAT_E2E_DEVICE_ID": device,
    "CHAT_E2E_TOKEN": session["attributes"]["access_token"],
    "CHAT_E2E_MAS": MAS,
    "CHAT_E2E_MAS_ADMIN_CLIENT": f"{ENV['MAS_ADMIN_CLIENT_ID']}:{ENV['MAS_ADMIN_CLIENT_SECRET']}",
    "CHAT_E2E_SESSION_ID": session["id"],
})
raise SystemExit(subprocess.run(
    ["cargo", "test", "--quiet", "--", "--ignored", "issued_session", "--nocapture"],
    cwd=HERE.parent / "rust", env=env,
).returncode)
