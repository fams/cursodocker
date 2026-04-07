#!/usr/bin/env bash
set -euo pipefail

VERSION="${KUBECTL_VERSION:-v1.35.2}"
ARCH="${ARCH:-amd64}"
BIN_DIR="${COURSE_BIN_DIR:-/usr/local/bin}"

TMP_DIR="$(mktemp -d)"
trap 'rm -rf "$TMP_DIR"' EXIT

curl -fsSL "https://dl.k8s.io/release/${VERSION}/bin/linux/${ARCH}/kubectl" \
  -o "${TMP_DIR}/kubectl"

curl -fsSL "https://dl.k8s.io/${VERSION}/bin/linux/${ARCH}/kubectl.sha256" \
  -o "${TMP_DIR}/kubectl.sha256"

EXPECTED="$(cat "${TMP_DIR}/kubectl.sha256")"
ACTUAL="$(sha256sum "${TMP_DIR}/kubectl" | awk '{print $1}')"

if [[ "$EXPECTED" != "$ACTUAL" ]]; then
  echo "Checksum inválido para kubectl ${VERSION}"
  exit 1
fi

chmod +x "${TMP_DIR}/kubectl"
sudo install -m 0755 "${TMP_DIR}/kubectl" "${BIN_DIR}/kubectl"

kubectl version --client