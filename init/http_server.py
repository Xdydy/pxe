from http.server import BaseHTTPRequestHandler, HTTPServer
import socket

class SimpleHTTPRequestHandler(BaseHTTPRequestHandler):
    def do_GET(self):
        self.send_response(200)
        self.end_headers()
        hostname = socket.gethostname().split('-')[1]
        self.wfile.write(f'{hostname}'.encode())

httpd = HTTPServer(('0.0.0.0', 80), SimpleHTTPRequestHandler)
httpd.serve_forever()
