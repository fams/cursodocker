#!/usr/bin/env bash
set -euo pipefail

VERSION="${ISTIO_VERSION:-1.29.1}"
ARCH="${ARCH:-amd64}"
ISTIO_ROOT="${ISTIO_INSTALL_DIR:-/opt/istio}"
BIN_DIR="${COURSE_BIN_DIR:-/usr/local/bin}"

case "$ARCH" in
  amd64) FILE_ARCH="amd64" ;;
  arm64) FILE_ARCH="arm64" ;;
  *)
    echo "Arquitetura não suportada: $ARCH"
    exit 1
    ;;
esac

TMP_DIR="$(mktemp -d)"
trap 'rm -rf "$TMP_DIR"' EXIT

TARBALL="istio-${VERSION}-linux-${FILE_ARCH}.tar.gz"
URL="https://github.com/istio/istio/releases/download/${VERSION}/${TARBALL}"

curl -fsSL "$URL" -o "${TMP_DIR}/${TARBALL}"

sudo mkdir -p "$ISTIO_ROOT"
sudo tar -xzf "${TMP_DIR}/${TARBALL}" -C "$ISTIO_ROOT"

sudo find ${ISTIO_ROOT} -type d -exec chmod +x {} \;

sudo ln -sfn "${ISTIO_ROOT}/istio-${VERSION}" "${ISTIO_ROOT}/current"
sudo ln -sfn "${ISTIO_ROOT}/current/bin/istioctl" "${BIN_DIR}/istioctl"

istioctl version --remote=false