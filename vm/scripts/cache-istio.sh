#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
. ${SCRIPT_DIR}/config.sh

ISTIO_VERSION="${ISTIO_VERSION:-1.26.0}"
ARCH="${ARCH:-x86_64}"
CACHE_DIR="${CACHE_DIR:-/opt/course/cache/istio}"

mkdir -p "${CACHE_DIR}"

case "${ARCH}" in
  amd64) FILE_ARCH="amd64" ;;
  x86_64) FILE_ARCH="amd64" ;;
  arm64) FILE_ARCH="arm64" ;;
  aarch64) FILE_ARCH="arm64" ;;
  *)
    echo "Arquitetura não suportada: ${ARCH}"
    exit 1
    ;;
esac

TARBALL="istio-${ISTIO_VERSION}-linux-${FILE_ARCH}.tar.gz"
TARBALL_PATH="${CACHE_DIR}/${TARBALL}"
EXTRACTED_DIR="${CACHE_DIR}/istio-${ISTIO_VERSION}"

if [[ -f "${TARBALL_PATH}" && -d "${EXTRACTED_DIR}" ]]; then
  echo "Istio já está em cache: ${TARBALL_PATH}"
  exit 0
fi

URL="https://github.com/istio/istio/releases/download/${ISTIO_VERSION}/${TARBALL}"
    #  https://github.com/istio/istio/releases/download/1.29.1/istioctl-1.29.1-linux-amd64.tar.gz

echo "Baixando Istio ${ISTIO_VERSION} para linux/${FILE_ARCH}..."
curl -fL "${URL}" -o "${TARBALL_PATH}"

if [[ ! -d "${EXTRACTED_DIR}" ]]; then
  tar -xzf "${TARBALL_PATH}" -C "${CACHE_DIR}"
fi

ln -sfn "istio-${ISTIO_VERSION}" "${CACHE_DIR}/current"

echo "Istio cacheado com sucesso em ${TARBALL_PATH}"
echo "Diretório extraído: ${EXTRACTED_DIR}"