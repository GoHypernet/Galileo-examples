#!/bin/bash
echo "Starting ssh server"
/usr/sbin/sshd -D &
/var/run/ngrok/ngrok authtoken <Put your token from ngrok here>
echo "Creating Introspective Tunnel"
/var/run/ngrok/ngrok tcp 22
