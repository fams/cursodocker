# Change Log

## v1.0.1 - 2024-09-30

### Fixed

unidade2.md

- Adicionado comando para limpar o cache de caminho de binarios encontrados no $PATH.
- Corrigido nome do pacote net-tools, previamente net-tool

## v1.0.2 - 2025-06-26

unidade2.md

- Corrigido informação sobre imagens scratchs serem minimas de arquivos, são na verdade literalmente vazias.
- Removidos ENV expúrios nos Dockerfile exemplo.
- Corrigido lab relacionado ao EXPOSE. Serve de informação para o usuário e publish-all

Agradecimentos ao @wandersonwhcr

## v1.1.0 - 2026-08-25

### Added

unidade1.md

- Adicionados Labs 11 a 15 sobre BuildKit moderno: cache mounts, build multi-plataforma com `buildx`, `ARG` e segredos de build (`--secret`), `COPY --link`/bind mounts de contexto, e geração de SBOM/provenance.

unidade2.md

- Adicionado Lab 14 sobre assinatura de imagens com Docker Content Trust (DCT), usando o Docker Hub.
- Adicionados Labs 15 a 18 sobre backup e restore de volumes: backup/restore com container efêmero, `mysqldump` em banco vivo (vs. cópia "a frio" do datadir), e migração de volume entre hosts.

unidade3.md

- Adicionados Labs 3 a 8 sobre recursos avançados do Docker Compose: healthcheck com dependência condicional (`depends_on: condition`), `.env`/`env_file`, overrides de ambiente (dev/prod), `profiles`, `secrets`, e políticas de `restart` (com nota sobre `docker stop`/`kill` manual suspender a política de restart em qualquer modo, e sobre a necessidade de `sh -c` para rodar `kill` dentro da imagem do `flask`).

### Fixed

unidade1.md (fecha #11)

- Lab 7, item 9: adicionado `--name` ao `docker run` e corrigido o `docker stop` subsequente, que tentava parar pelo nome da imagem em vez do nome do container.
- Lab 9: padronizada a ordem dos argumentos do `docker build` (flags antes do contexto `.`) em todas as ocorrências do lab.
- Lab 7, itens 7 e 9: substituído en-dash (`–`) por hífen (`-`) em `docker run` (ex.: `–P` virou `-P`), que fazia o Docker interpretar a flag como nome de imagem e falhar com "invalid reference format". Encontrado ao validar o fix do #11 em ambiente real.
