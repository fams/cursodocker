#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
. ${SCRIPT_DIR}/config.sh

K3D_VERSION="${K3D_VERSION:-v5.7.5}"
ARCH="${ARCH:-amd64}"
CACHE_DIR="${CACHE_DIR:-/opt/course/cache/k3d}"
INSTALL_DIR="${INSTALL_DIR:-/usr/local/bin}"

case "${ARCH}" in
  amd64) FILE_ARCH="amd64" ;;
  arm64) FILE_ARCH="arm64" ;;
  *)
    echo "Arquitetura não suportada: ${ARCH}"
    exit 1
    ;;
esac

SRC="${CACHE_DIR}/k3d-${K3D_VERSION}-linux-${FILE_ARCH}"
DST="${INSTALL_DIR}/k3d"

if [[ ! -f "${SRC}" ]]; then
  echo "k3d não encontrado no cache: ${SRC}"
  exit 1
fi

sudo install -m 0755 "${SRC}" "${DST}"

echo "k3d instalado em ${DST}"
k3d version