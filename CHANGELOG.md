# Change Log

## v1.1.2 - 2026-08-29

### Added

unidade2.md

- Lab 1: marcado com um comentário HTML `<!--console:ubuntu-->` (invisível em qualquer visualização Markdown, inclusive no GitHub) sinalizando que o lab inteiro precisa de um ambiente Debian/Ubuntu de verdade (`chroot`/`pivot_root`/`debootstrap` não usam Docker em nenhum momento) — usado por ferramentas de apoio ao curso para abrir um console alternativo nesse lab.
- Lab 1, item 1 (variante Fedora/`dnf`): marcado com um comentário HTML `<!--send:off-->` sinalizando pras ferramentas de apoio ao curso que esse caminho não se aplica ao console delas (baseado em Ubuntu).
- Início do arquivo: comentário HTML explicando a convenção dos marcadores invisíveis (`console`, `send:off`, `term:split-h`) usados nesse arquivo, pra quem for editar não removê-los sem querer.

## v1.1.1 - 2026-08-29

### Added

unidade1.md

- Lab 1, item 3: adicionado `docker ps -a` após o `docker ps`, pra contrastar o switch de mostrar todos os containers com o de mostrar só os em execução.

unidade2.md

- Lab 3: preenchida a lacuna de numeração (o arquivo pulava do lab 2 pro lab 4) com um novo lab sobre o namespace de UTS — isolamento de hostname com `unshare --uts`/`nsenter --uts`.

### Fixed

unidade1.md

- Lab 10: adicionado o `:` que faltava em `### Objetivo`, que quebrava a extração automática do objetivo do lab em ferramentas que dependem desse padrão.
- Lab 7, item 10: corrigida numeração duplicada (`8.` repetido em vez de `10.`).

unidade2.md

- Corrigido `## Laboratório 13` para `## Lab 13`, alinhando com os labs vizinhos (9-18 usam "Lab N").
- Corrigida tag de linguagem `docker` (não é uma linguagem) para `bash` num bloco de código do Lab 10.

unidade3.md

- Corrigida tag de linguagem `dockerfile` (minúsculo) para `Dockerfile`, igual ao resto do arquivo.

### Changed

unidade1.md

- Lab 4: piloto da padronização de comando/output (Fase 3) — bloco de output marcado com a tag ` ```output `; separado em blocos o fluxo "entra no container / roda comando lá dentro / volta pro host", que antes misturava tudo com um prompt de container inconsistente (`bash-5.2$#`). Regra final do `$` (após pesquisa de boas práticas): usado só quando há output no bloco, ou quando a sequência muda de contexto de execução (host → dentro do container → host, como no passo 3); removido de blocos de comando puro sem troca de contexto, mesmo com vários comandos (passos 2 e 4).
- Labs 1, 2 e 3: continuação da padronização de comando/output. Removido `$` de blocos de comando puro no host (sem output, sem troca de contexto). Mantido/adicionado `$` nas sequências que entram e saem de um container (`docker start -ai`, `docker attach`, `docker exec`, e os comandos digitados enquanto anexado). Removidos prompts de container inconsistentes (`bash-5.2#`, `bash-5.2$#`) — separados em blocos com uma frase de transição ("Agora você está dentro do container...") no lugar.
- Labs 5 a 10: conclui a padronização de comando/output da unidade1.md. `$` removido de blocos de comando puro sem output/troca de contexto (Labs 5, 6, 7, 9, 10). Blocos que misturavam comando e output no mesmo trecho (`docker image ls`, `docker login`, `docker history`, `docker images`) separados em bloco de comando (com `$`, já que o output associado justifica) + bloco `` ```output `` (Labs 8, 9, 10). Labs 11-15 (BuildKit) já seguiam a convenção desde a criação, sem mudanças.

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
