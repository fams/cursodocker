#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
. ${SCRIPT_DIR}/config.sh

K3D_VERSION="${K3D_VERSION:-v5.7.5}"
ARCH="${ARCH:-amd64}"
CACHE_DIR="${CACHE_DIR:-/opt/course/cache/k3d}"

mkdir -p "${CACHE_DIR}"

case "${ARCH}" in
  amd64) FILE_ARCH="amd64" ;;
  arm64) FILE_ARCH="arm64" ;;
  *)
    echo "Arquitetura não suportada: ${ARCH}"
    exit 1
    ;;
esac

BIN_PATH="${CACHE_DIR}/k3d-${K3D_VERSION}-linux-${FILE_ARCH}"

if [[ -f "${BIN_PATH}" ]]; then
  echo "k3d já está em cache: ${BIN_PATH}"
  exit 0
fi

URL="https://github.com/k3d-io/k3d/releases/download/${K3D_VERSION}/k3d-linux-${FILE_ARCH}"

echo "Baixando k3d ${K3D_VERSION} para linux/${FILE_ARCH}..."
curl -fL "${URL}" -o "${BIN_PATH}"

chmod +x "${BIN_PATH}"

ln -sfn "$(basename "${BIN_PATH}")" "${CACHE_DIR}/k3d-linux-${FILE_ARCH}"

echo "k3d cacheado com sucesso em ${BIN_PATH}"