#!/bin/bash

[Unit]
Description=Emacs server
After=network.target

[Service]
Type=simple
ExecStart=/usr/bin/emacs --fg-daemon
Restart=always
RestartSec=2

[Install]
WantedBy=default.target


# create file with .config/systemd/user/emacs.service
# systemctl  --user daemon-reload
# systemctl --user enable --now emacs.service
# systemctl  --user status emacs.service
