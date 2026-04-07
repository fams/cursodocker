#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
. ${SCRIPT_DIR}/config.sh

KUBECTL_VERSION="${KUBECTL_VERSION:-v1.32.2}"
ARCH="${ARCH:-amd64}"
CACHE_DIR="${CACHE_DIR:-/opt/course/cache/kubectl}"

INSTALL_DIR="${INSTALL_DIR:-/usr/local/bin}"

SRC="${CACHE_DIR}/kubectl-${KUBECTL_VERSION}-linux-${ARCH}"
DST="${INSTALL_DIR}/kubectl"

if [[ ! -f "${SRC}" ]]; then
  echo "kubectl não encontrado no cache: ${SRC}"
  exit 1
fi

sudo install -m 0755 "${SRC}" "${DST}"

echo "kubectl instalado em ${DST}"
kubectl version --client