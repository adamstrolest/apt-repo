#!/bin/sh
set -eu

REPO="https://adamstrolest.github.io/apt-repo"
KEYRING="/usr/share/keyrings/containermanager.gpg"

detect_distro() {
  if grep -qi "trixie" /etc/os-release 2>/dev/null; then
    echo "trixie"
  elif grep -qi "noble" /etc/os-release 2>/dev/null; then
    echo "noble"
  elif grep -qi "bookworm" /etc/os-release 2>/dev/null; then
    echo "trixie"
  else
    echo "noble"
  fi
}

DISTRO="${1:-$(detect_distro)}"

echo "Installing for $DISTRO..."

curl -fsSL "$REPO/containermanager.gpg.key" | sudo gpg --dearmor -o "$KEYRING"
echo "deb [signed-by=$KEYRING] $REPO $DISTRO main" | sudo tee "/etc/apt/sources.list.d/containermanager.list"
sudo apt update
sudo apt install -y containermanager
