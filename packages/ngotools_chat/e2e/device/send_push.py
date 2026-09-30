#!/usr/bin/env python3
"""Sends a Matrix-style push to an iPhone for the notification extension test.

Mimics what Sygnal sends for `event_id_only` pushers: room and event id with
`mutable-content`, so iOS starts the example's notification extension, which
loads and decrypts the event itself.

Needs the APNs key of the Apple team: `APNS_KEY_P8` (contents of the .p8
file), `APNS_KEY_ID` and `APNS_TEAM_ID`, from the environment or the
project key store (`NGO_KEYS_FILE`, default /Users/seb/Herd/ngo/.orchestrator.keys).
Never prints the key or the signed token.
"""
import argparse
import base64
import json
import os
import subprocess
import sys
import time

from cryptography.hazmat.primitives import hashes, serialization
from cryptography.hazmat.primitives.asymmetric import ec
from cryptography.hazmat.primitives.asymmetric.utils import decode_dss_signature

TOPIC = "tools.ngo.mobile.chatExample"


def secret(name):
    if os.environ.get(name):
        return os.environ[name]
    path = os.environ.get("NGO_KEYS_FILE", "/Users/seb/Herd/ngo/.orchestrator.keys")
    try:
        value = json.load(open(path)).get(name)
    except FileNotFoundError:
        value = None
    if not value:
        sys.exit(f"{name} is missing (environment or key store)")
    return value


def b64(data):
    return base64.urlsafe_b64encode(data).rstrip(b"=").decode()


def provider_token():
    key = serialization.load_pem_private_key(secret("APNS_KEY_P8").encode(), password=None)
    header = b64(json.dumps({"alg": "ES256", "kid": secret("APNS_KEY_ID")}).encode())
    claims = b64(json.dumps({"iss": secret("APNS_TEAM_ID"), "iat": int(time.time())}).encode())
    signing_input = f"{header}.{claims}".encode()
    r, s = decode_dss_signature(key.sign(signing_input, ec.ECDSA(hashes.SHA256())))
    return f"{header}.{claims}.{b64(r.to_bytes(32, 'big') + s.to_bytes(32, 'big'))}"


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--token", required=True, help="APNs device token (hex)")
    parser.add_argument("--room", required=True)
    parser.add_argument("--event", required=True)
    parser.add_argument("--production", action="store_true", help="use the production APNs host")
    args = parser.parse_args()

    payload = {
        "aps": {"alert": {"title": "NGO.Tools", "body": "Neue Nachricht"}, "mutable-content": 1},
        "room_id": args.room,
        "event_id": args.event,
        "unread_count": 1,
    }
    host = "api.push.apple.com" if args.production else "api.sandbox.push.apple.com"
    result = subprocess.run(
        [
            "curl", "--http2", "--silent", "--show-error", "--write-out", "%{http_code}",
            "--header", f"authorization: bearer {provider_token()}",
            "--header", f"apns-topic: {TOPIC}",
            "--header", "apns-push-type: alert",
            "--header", "apns-priority: 10",
            "--data", json.dumps(payload),
            f"https://{host}/3/device/{args.token}",
        ],
        capture_output=True,
        text=True,
    )
    status = result.stdout[-3:]
    body = result.stdout[:-3]
    print(f"APNs {status} {body}".strip())
    sys.exit(0 if status == "200" else 1)


if __name__ == "__main__":
    main()
