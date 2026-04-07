# Instalação do Docker

Este documento descreve a instalação do Docker no ambiente utilizado no curso.

O objetivo é garantir que **todos os alunos utilizem a mesma versão do Docker**, evitando incompatibilidades durante a execução dos laboratórios.

A instalação é realizada utilizando o repositório oficial da **Docker**.

---

# Requisitos

Sistema operacional suportado:

* **Ubuntu Server 24.04**

Ferramentas básicas necessárias:

```bash
sudo apt update
sudo apt install -y curl ca-certificates gnupg
```

---

# Remover versões antigas

Caso exista alguma versão anterior instalada:

```bash
sudo apt remove -y docker docker-engine docker.io containerd runc
```

---

# Configurar repositório oficial do Docker

Criar diretório para chave GPG:

```bash
sudo install -m 0755 -d /etc/apt/keyrings
```

Adicionar chave do repositório:

```bash
curl -fsSL https://download.docker.com/linux/ubuntu/gpg \
 | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
```

Adicionar repositório ao APT:

```bash
echo \
"deb [arch=$(dpkg --print-architecture) \
signed-by=/etc/apt/keyrings/docker.gpg] \
https://download.docker.com/linux/ubuntu \
$(. /etc/os-release && echo $VERSION_CODENAME) stable" \
| sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
```

Atualizar lista de pacotes:

```bash
sudo apt update
```

---

# Instalar versão específica do Docker

Para garantir compatibilidade com os laboratórios, utilizamos uma versão fixa do Docker.

Primeiro verifique as versões disponíveis:

```bash
apt-cache madison docker-ce
```

Exemplo de versão disponível:

```
5:26.0.0-1~ubuntu.24.04~noble
```

Instalar Docker utilizando essa versão:

```bash
sudo apt install -y \
docker-ce=5:26.0.0-1~ubuntu.24.04~noble \
docker-ce-cli=5:26.0.0-1~ubuntu.24.04~noble \
containerd.io \
docker-buildx-plugin \
docker-compose-plugin
```

---

# Impedir atualização automática

Para evitar que atualizações do sistema alterem a versão utilizada no curso:

```bash
sudo apt-mark hold docker-ce docker-ce-cli containerd.io
```

---

# Permitir execução sem sudo

Adicionar o usuário atual ao grupo docker:

```bash
sudo usermod -aG docker $USER
```

Depois disso é necessário **encerrar a sessão e entrar novamente**.

---

# Testar instalação

Verificar versão instalada:

```bash
docker version
```

Executar container de teste:

```bash
docker run hello-world
```

Se o container executar corretamente, o Docker está instalado e funcionando.

---

# Testar Docker Compose

O Docker Compose já é instalado como plugin.

Verifique com:

```bash
docker compose version
```

---

# Próximo passo

Após a instalação do Docker, prossiga para os laboratórios do curso.
