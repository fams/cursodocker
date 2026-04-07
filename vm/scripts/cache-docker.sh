#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
. ${SCRIPT_DIR}/config.sh

ARCH="${ARCH:-x86_64}"
CACHE_DIR="${CACHE_DIR:-/opt/course/cache/istio}"

DOCKER_VERSION_PREFIX="${DOCKER_VERSION_PREFIX:-}"

sudo apt-get update
sudo apt-get install -y ca-certificates curl gnupg apt-transport-https

sudo install -m 0755 -d /etc/apt/keyrings

if [[ ! -f /etc/apt/keyrings/docker.gpg ]]; then
  curl -fsSL https://download.docker.com/linux/ubuntu/gpg \
    | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
fi

echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] \
  https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" \
  | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

sudo apt-get update

mkdir -p "$CACHE_DIR"

resolve_version() {
  local pkg="$1"
  if [[ -n "$DOCKER_VERSION_PREFIX" ]]; then
    apt-cache madison "$pkg" | awk '{print $3}' | grep "^${DOCKER_VERSION_PREFIX}" | head -n1
  else
    apt-cache madison "$pkg" | awk '{print $3}' | head -n1
  fi
}

DOCKER_CE_VER="$(resolve_version docker-ce)"
DOCKER_CE_CLI_VER="$(resolve_version docker-ce-cli)"
BUILDX_VER="$(resolve_version docker-buildx-plugin)"
COMPOSE_VER="$(resolve_version docker-compose-plugin)"
CONTAINERD_VER="$(apt-cache madison containerd.io | awk '{print $3}' | head -n1)"

if [[ -z "$DOCKER_CE_VER" || -z "$DOCKER_CE_CLI_VER" || -z "$CONTAINERD_VER" ]]; then
  echo "Não foi possível resolver versões do Docker no repositório."
  exit 1
fi

echo "Versões selecionadas:"
echo "  docker-ce=${DOCKER_CE_VER}"
echo "  docker-ce-cli=${DOCKER_CE_CLI_VER}"
echo "  containerd.io=${CONTAINERD_VER}"
echo "  docker-buildx-plugin=${BUILDX_VER:-<não encontrado>}"
echo "  docker-compose-plugin=${COMPOSE_VER:-<não encontrado>}"

pushd "$CACHE_DIR" >/dev/null

apt-get download \
  "docker-ce=${DOCKER_CE_VER}" \
  "docker-ce-cli=${DOCKER_CE_CLI_VER}" \
  "containerd.io=${CONTAINERD_VER}"

if [[ -n "${BUILDX_VER:-}" ]]; then
  apt-get download "docker-buildx-plugin=${BUILDX_VER}"
fi

if [[ -n "${COMPOSE_VER:-}" ]]; then
  apt-get download "docker-compose-plugin=${COMPOSE_VER}"
fi

popd >/dev/null

cat > "${CACHE_DIR}/VERSIONS.txt" <<EOF
docker-ce=${DOCKER_CE_VER}
docker-ce-cli=${DOCKER_CE_CLI_VER}
containerd.io=${CONTAINERD_VER}
docker-buildx-plugin=${BUILDX_VER:-}
docker-compose-plugin=${COMPOSE_VER:-}
EOF

echo "Cache do Docker salvo em: ${CACHE_DIR}"