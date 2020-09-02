#!/bin/bash

setup_apt() {
  sudo apt update && sudo apt upgrade
}

echo "  begin setup apt."
setup_apt
echo "  end setup apt."
