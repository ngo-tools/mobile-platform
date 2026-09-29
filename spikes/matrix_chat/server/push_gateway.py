#!/usr/bin/env python3
"""Minimal Sygnal stand-in for the spike.

POST /_matrix/push/v1/notify  records the payload (format event_id_only)
GET  /pushes                  returns all recorded notifications as JSON
"""
import json
import sys
import threading
from http.server import BaseHTTPRequestHandler, ThreadingHTTPServer

PORT = int(sys.argv[1]) if len(sys.argv) > 1 else 28451
pushes = []
lock = threading.Lock()


class Handler(BaseHTTPRequestHandler):
    def do_POST(self):
        body = self.rfile.read(int(self.headers.get("Content-Length", 0)))
        payload = json.loads(body or b"{}")
        with lock:
            pushes.append(payload)
        print(json.dumps(payload), flush=True)
        self._json({"rejected": []})

    def do_GET(self):
        with lock:
            self._json(pushes)

    def _json(self, data):
        encoded = json.dumps(data).encode()
        self.send_response(200)
        self.send_header("Content-Type", "application/json")
        self.send_header("Content-Length", str(len(encoded)))
        self.end_headers()
        self.wfile.write(encoded)

    def log_message(self, *args):
        pass


ThreadingHTTPServer(("0.0.0.0", PORT), Handler).serve_forever()
