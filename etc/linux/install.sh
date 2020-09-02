#!/bin/bash

setup_apt() {
  sudo apt update && sudo apt upgrade
  sudo timedatectl set-timezone Asia/Tokyo
}

echo "  begin setup apt."
setup_apt
echo "  end setup apt."
