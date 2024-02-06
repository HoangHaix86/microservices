#!/bin/bash

sudo tee -a /etc/vbox/networks.conf <<EOF
* 0.0.0.0/0 ::/0
EOF
