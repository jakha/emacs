#!/bin/bash

[Unit]
Description=Forward remote Emacs Unix socket to localhost
After=network-online.target
Wants=network-online.target

[Service]
Type=simple
# remote server settings 
Environment=HOST=user@remote-host
Environment=REMOTE_SOCKET=/run/user/1000/emacs/server
Environment=LOCAL_SOCKET=%t/emacs-remote

ExecStart=/usr/bin/socat UNIX-LISTEN:${LOCAL_SOCKET},fork,reuseaddr EXEC:"ssh -T ${HOST} socat STDIO UNIX-CONNECT:${REMOTE_SOCKET}"
Restart=always
RestartSec=3

# to remove socket when service stop
ExecStop=/bin/rm -f ${LOCAL_SOCKET}

[Install]
WantedBy=default.target
