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

- Adicionados Labs 3 a 8 sobre recursos avançados do Docker Compose: healthcheck com dependência condicional (`depends_on: condition`), `.env`/`env_file`, overrides de ambiente (dev/prod), `profiles`, `secrets`, e políticas de `restart`.

### Fixed

unidade1.md (fecha #11)

- Lab 7, item 9: adicionado `--name` ao `docker run` e corrigido o `docker stop` subsequente, que tentava parar pelo nome da imagem em vez do nome do container.
- Lab 9: padronizada a ordem dos argumentos do `docker build` (flags antes do contexto `.`) em todas as ocorrências do lab.
- Lab 7, itens 7 e 9: substituído en-dash (`–`) por hífen (`-`) em `docker run` (ex.: `–P` virou `-P`), que fazia o Docker interpretar a flag como nome de imagem e falhar com "invalid reference format". Encontrado ao validar o fix do #11 em ambiente real.

unidade3.md

- Lab 8: adicionado `sh -c` em torno dos comandos `kill`/`kill -9` executados via `docker compose exec`, já que a imagem `python:3.9-slim` do serviço `flask` não tem o binário `kill` — sem isso o comando falha com "executable file not found in $PATH".
- Lab 8, item 4: corrigida a afirmação de que `restart: always` reinicia o container automaticamente após um `docker stop` manual. Pelo comportamento documentado do Docker, uma parada manual (`docker stop`/`docker kill`) suspende a política de restart em **qualquer** modo, até o daemon reiniciar ou o container ser reiniciado manualmente. O lab agora demonstra e explica esse comportamento corretamente, com um novo item 5 mostrando o caso em que `always` de fato reinicia (processo terminando sozinho).
