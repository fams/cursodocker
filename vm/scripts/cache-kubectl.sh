#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
. ${SCRIPT_DIR}/config.sh

KUBECTL_VERSION="${KUBECTL_VERSION:-v1.32.2}"
ARCH="${ARCH:-amd64}"
CACHE_DIR="${CACHE_DIR:-/opt/course/cache/kubectl}"

mkdir -p "${CACHE_DIR}"

BIN_PATH="${CACHE_DIR}/kubectl-${KUBECTL_VERSION}-linux-${ARCH}"
SHA_PATH="${BIN_PATH}.sha256"

if [[ -f "${BIN_PATH}" ]]; then
  echo "kubectl já está em cache: ${BIN_PATH}"
  exit 0
fi

echo "Baixando kubectl ${KUBECTL_VERSION} para linux/${ARCH}..."
curl -fL "https://dl.k8s.io/release/${KUBECTL_VERSION}/bin/linux/${ARCH}/kubectl" -o "${BIN_PATH}"
curl -fL "https://dl.k8s.io/${KUBECTL_VERSION}/bin/linux/${ARCH}/kubectl.sha256" -o "${SHA_PATH}"

EXPECTED_SHA="$(cat "${SHA_PATH}")"
ACTUAL_SHA="$(sha256sum "${BIN_PATH}" | awk '{print $1}')"

if [[ "${EXPECTED_SHA}" != "${ACTUAL_SHA}" ]]; then
  echo "Erro: checksum do kubectl não confere."
  exit 1
fi

chmod +x "${BIN_PATH}"

ln -sfn "$(basename "${BIN_PATH}")" "${CACHE_DIR}/kubectl-linux-${ARCH}"
ln -sfn "$(basename "${SHA_PATH}")" "${CACHE_DIR}/kubectl-linux-${ARCH}.sha256"

echo "kubectl cacheado com sucesso em ${BIN_PATH}"