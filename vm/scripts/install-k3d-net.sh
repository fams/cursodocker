#!/usr/bin/env bash
set -euo pipefail

VERSION="${K3D_VERSION:-v5.8.3}"
ARCH="${ARCH:-amd64}"
BIN_DIR="${COURSE_BIN_DIR:-/usr/local/bin}"

case "$ARCH" in
  amd64|arm64) ;;
  *)
    echo "Arquitetura não suportada: $ARCH"
    exit 1
    ;;
esac

TMP_DIR="$(mktemp -d)"
trap 'rm -rf "$TMP_DIR"' EXIT

curl -fsSL \
  "https://github.com/k3d-io/k3d/releases/download/${VERSION}/k3d-linux-${ARCH}" \
  -o "${TMP_DIR}/k3d"

chmod +x "${TMP_DIR}/k3d"
sudo install -m 0755 "${TMP_DIR}/k3d" "${BIN_DIR}/k3d"

k3d version