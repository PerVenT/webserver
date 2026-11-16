#!/bin/sh
while true; do { echo -e 'HTTP/1.1 200 OK\r\n\r\nv1.1.0'; } | nc -l -p 8888; done
