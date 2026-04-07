#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
. ${SCRIPT_DIR}/config.sh

ISTIO_VERSION="${ISTIO_VERSION:-1.26.0}"
ARCH="${ARCH:-x86_64}"
CACHE_DIR="${CACHE_DIR:-/opt/course/cache/istio}"
ISTIO_INSTALL_DIR="${ISTIO_INSTALL_DIR:-/opt/istio}"


SRC_DIR="${CACHE_DIR}/istio-${ISTIO_VERSION}"

if [[ ! -d "${SRC_DIR}" ]]; then
  echo "Istio não encontrado no cache: ${SRC_DIR}"
  exit 1
fi

sudo mkdir -p "${ISTIO_INSTALL_DIR}"
sudo rm -rf "${ISTIO_INSTALL_DIR}/istio-${ISTIO_VERSION}"
sudo cp -a "${SRC_DIR}" "${ISTIO_INSTALL_DIR}/"

sudo ln -sfn "${ISTIO_INSTALL_DIR}/istio-${ISTIO_VERSION}" "${ISTIO_INSTALL_DIR}/current"
sudo ln -sfn "${ISTIO_INSTALL_DIR}/current/bin/istioctl" ${INSTALL_DIR}/istioctl

echo "Istio instalado em ${ISTIO_INSTALL_DIR}/istio-${ISTIO_VERSION}"
istioctl version --remote=false