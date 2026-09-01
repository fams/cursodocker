# Change Log

## v1.1.17 - 2026-09-01

### Fixed

unidade2.md (achados testando todos os labs com containers reais)

- Lab 5, item "Compilar o gastador de recursos": `cd src` corrigido pra `cd /build` -- destino real do bind mount (`-v .:/build`); não existe `src/` na fixture, o `go build` falhava com "go.mod file not found".
- Lab 5, item "Testando o limite de memória": flag `-memory-hog` corrigida pra `-hog-memory` (ordem certa da flag, confirmada no binário e no Lab 12, que já usava certo).
- Lab 7, item "Acesse os dados de outro contêiner": container renomeado de `lab7_container_2` (mesmo nome já usado no item anterior, ainda vivo) pra `lab7_container_4` -- evita o conflito `Conflict. The container name "/lab7_container_2" is already in use`.

unidade3.md (achados testando todos os labs com containers reais)

- Lab 3, item 1: `cp -R lab2/{Dockerfile,html,contador,compose.yml}` corrigido -- `compose.yml` nunca existiu (os labs 1/2 usam `docker-compose.yml`) e faltava `nginx.conf` (que o Dockerfile do lab2 precisa) na lista. Sem isso, o `docker compose up --build` do lab3 falhava por completo.
- Lab 4: adicionado o passo explícito `mv docker-compose.yml compose.yml` -- o texto já se referia ao arquivo como `compose.yml` a partir daqui (e o Lab 5 depende do nome oficial pro `-f compose.yml` explícito funcionar), mas nada renomeava de fato.
- Lab 8, itens 2 e 3: `docker compose ps flask` trocado por `docker compose ps -a flask` -- sem `-a`, um container parado simplesmente não aparece na lista (fica vazia em vez de mostrar "Exited"), diferente do que o comentário do próprio comando sugere.

## v1.1.16 - 2026-09-01

### Fixed

unidade1.md (achados testando todos os labs com containers reais)

- Labs 1, 2, 3, 7 (itens "Remover os containers"): `docker container prune --force` trocado por `docker rm <nome-do-container>` -- o prune é uma limpeza do Docker INTEIRO da máquina (todo container parado, não só os do lab), destrutivo e sem aviso pra qualquer outro trabalho parado no mesmo host/VM.
- Lab 5: adicionado o passo que cria `./www/index.html` antes do `docker run -v ./www:...` -- o lab nunca teve esse passo nem um fixture, então como estava o bind mount montava um diretório vazio (NGINX respondia 403/vazio em vez de conteúdo customizado).
- Lab 13, itens 3-4: `https://exemplo.com` trocado por `https://httpbin.org/get` -- o domínio de exemplo falha o handshake TLS (reproduzido também fora do ambiente de teste), fazendo o `docker build` falhar por completo e impedindo o próximo comando (`docker history`) de rodar.
- Lab 14, item 4: instrução reescrita -- "altere só o binário final (não o código-fonte)" não fazia sentido (o binário é sempre gerado do código-fonte por esse Dockerfile) e não tinha bloco de comando nenhum. Agora altera `main.go` e reconstrói, com um bloco de comando testável.
- Lab 15, item 1: "reaproveite o build multi-plataforma do Lab 12" corrigido -- o comando desse lab não usa `--platform`, só reaproveita o builder/Dockerfile, não é multi-plataforma.

### Added

unidade1.md

### Added

unidade2.md

- Lab 4: `<!--term:split-h-2-->` movido pra logo após o título do lab (era repetido em todo item) e adicionado `<!--term:ativo-N-->` em cada item, indicando de forma confiável (pra ferramentas de apoio ao curso) qual dos 2 terminais é o alvo dos comandos daquele item -- a prosa ("_No Terminal 1_"/"_No Terminal 2_") continua igual, o marcador é só a versão à prova de interpretação de texto.

## v1.1.14 - 2026-09-01

### Added

unidade2.md

- Lab 1, item 2 (teste do chroot): adicionados comentários explicando o que o aluno deve observar em cada `ls` (arquivo do host some de dentro do chroot, arquivo de dentro do chroot aparece, e volta ao normal depois do `exit`) -- o bloco nunca teve nenhum comentário, ao contrário do item 3 (pivot_root) do mesmo lab.

## v1.1.13 - 2026-08-31

### Fixed

unidade2.md (fecha #14)

- Lab 8, item 1: indentação da fence de abertura (4 espaços) corrigida pra bater com o conteúdo e a fence de fechamento (3 espaços).
- Lab 7, itens 1-3: comando de transição (`docker run ... -it`) separado do que é digitado dentro do container, com uma frase indicando a troca de contexto — mesmo padrão já usado no resto do material (ex.: Unidade 1, Lab 1). De brinde, corrigido um espaço duplo no item 1.

## v1.1.12 - 2026-08-30

### Fixed

unidade2.md

- Lab 1, item 1a: os dois comandos (`apt install debootstrap` e `debootstrap`) estavam num bloco sem prefixo `$`, então as ferramentas de apoio ao curso tratavam as duas linhas como um bloco indivisível — o rótulo exibido truncava na primeira linha, escondendo o `debootstrap` por completo. Adicionado `$` em cada linha, igual à convenção usada no resto do arquivo, separando os dois em áreas copiáveis distintas.

## v1.1.11 - 2026-08-30

### Added

unidade1.md

- Labs 8, 11, 12, 14, 15: marcados com `<!--continua:ID-->` sinalizando que reaproveitam ambiente/imagem de um lab anterior (Lab 8 precisa da imagem construída no Lab 7; Lab 11 copia o código-fonte do Lab 10; Lab 12 e 15 reaproveitam o Dockerfile/builder do Lab 11; Lab 14 copia o Dockerfile do Lab 13) em vez de um container novo e isolado.
- Lab 13: criado o fixture `labs/unidade1/lab13/` (`go.mod`/`main.go`) que faltava — o Dockerfile do lab (`COPY . .`, `go build -o app .`) não tinha nenhum código-fonte pra compilar.

### Fixed

unidade1.md

- Labs 7, 9, 10: `cd labs/unidade1/labN` trocado por `cd labN`, alinhando com a convenção já usada pelos Labs 11-15 (necessário pras ferramentas de apoio ao curso conseguirem localizar os arquivos de cada lab de forma consistente).
- Lab 13, item 1: removido o `mkdir` (o diretório já existe, populado com o fixture novo).

## v1.1.10 - 2026-08-30

### Fixed

unidade1.md

- Lab 11, item 2: o `go build` do Dockerfile gerava um binário linkado dinamicamente contra a libc (padrão do Go quando há um compilador C disponível, como na imagem `golang:1.22`), mas a stage final usa `FROM scratch`, que não tem libc nem interpretador de ld — qualquer `docker run` dessa imagem falhava com "exec: no such file or directory". Corrigido com `CGO_ENABLED=0` no `go build`, gerando um binário estaticamente linkado. Encontrado ao validar o Lab 12 (que reaproveita esse Dockerfile e tem um passo de `docker run` que expôs o problema).
- Lab 12, itens 1-2: o builder `buildx` usava o driver padrão (`docker-container`), que roda o BuildKit isolado num container com seu próprio namespace de rede — o `--push` pro registry local (`localhost:5000`) falhava com "connection refused". Corrigido criando o builder com `--driver-opt network=host`. Também trocado o registry reaproveitado do Lab 10 da Unidade 2 (dependência cruzada entre unidades) por um registry local próprio do lab (`docker run registry:2.8.2`), tornando o Lab 12 self-contained. Testado o fluxo completo (registry, build multi-plataforma, push, inspect do manifest list e run) com containers reais.

## v1.1.9 - 2026-08-30

### Fixed

unidade3.md

- Lab 8, itens 2-5: `kill 1`/`kill -9 1` de dentro do container nunca derrubava o PID 1 (`docker compose ps flask` continuava "Up" mesmo depois do comando) — o PID 1 de um container é imune a sinais enviados de dentro do próprio namespace, a menos que tenha um handler instalado, e o processo do Flask (`python app.py`) não instala handler nenhum. Corrigido adicionando `init: true` ao serviço `flask` (item 1) — roda o `tini` como PID 1, que instala handler pra `SIGTERM` — e trocando `kill -9 1` por `kill 1` no item 3 (`SIGKILL` nunca pode ter handler, regra do kernel, então nunca funciona de dentro do namespace, com ou sem `tini`). Testados os 4 cenários (`no`/`on-failure`/`always` com kill interno/`always` com `docker stop` do host) com containers reais, todos batendo com o texto do lab.

## v1.1.7 - 2026-08-30

### Fixed

unidade3.md (lab2/nginx.conf)

- Lab 2, itens 6-9: o `nginx.conf` não balanceava carga entre as réplicas escaladas do serviço `flask` — o nginx resolve o hostname `flask` uma única vez (no load do config) e fixa nesse IP pro resto da vida do worker, então escalar (`--scale flask=3`) não tinha efeito nenhum no balanceamento, mesmo reiniciando o `web`. Corrigido adicionando `resolver 127.0.0.11 valid=10s;` (o DNS embutido do Docker Compose) e trocando `proxy_pass` por uma variável, que força o nginx a resolver o hostname a cada requisição em vez de uma vez só. Testado com 3 réplicas: requisições alternam corretamente entre os 3 hostnames.

## v1.1.6 - 2026-08-30

### Added

unidade1.md

- Lab 6: marcado com um comentário HTML `<!--console:ubuntu-->` (invisível em qualquer visualização Markdown, inclusive no GitHub) sinalizando que o lab precisa de um ambiente Debian/Ubuntu de verdade — o `apt install -y mysql-client` do passo 1 não existe em ambientes Alpine, e o cliente MySQL de distros baseadas em Alpine é na real um cliente MariaDB, incompatível com o plugin de autenticação padrão do MySQL 8+ usado pelo passo 2. Testado com o cliente real (Ubuntu `mysql-client`) conectando com sucesso e retornando os dados esperados.

## v1.1.5 - 2026-08-30

### Added

unidade2.md

- Labs 16 e 18: marcados com um comentário HTML `<!--continua:unidade2-lab15-->` (invisível em qualquer visualização Markdown, inclusive no GitHub) sinalizando pras ferramentas de apoio ao curso que esses labs reaproveitam o mesmo ambiente do Lab 15 (do qual dependem o volume/backup gerado) em vez de um novo isolado.

## v1.1.4 - 2026-08-30

### Added

unidade2.md

- Lab 1: marcado com um comentário HTML `<!--console:ubuntu-->` (invisível em qualquer visualização Markdown, inclusive no GitHub) sinalizando que o lab inteiro precisa de um ambiente Debian/Ubuntu de verdade (`chroot`/`pivot_root`/`debootstrap` não usam Docker em nenhum momento) — usado por ferramentas de apoio ao curso para abrir um console alternativo nesse lab.
- Lab 1, item 1 (variante Fedora/`dnf`): marcado com um comentário HTML `<!--send:off-->` sinalizando pras ferramentas de apoio ao curso que esse caminho não se aplica ao console delas (baseado em Ubuntu).
- Início do arquivo: comentário HTML explicando a convenção dos marcadores invisíveis (`console`, `send:off`, `term:split-h`) usados nesse arquivo, pra quem for editar não removê-los sem querer.

### Fixed

unidade2.md

- Lab 4, item 2: `unshare --net=/namespaces/001` apontava pro diretório em vez do arquivo-âncora criado no item 1 (`/namespaces/001/net`) — `unshare --net` exige um arquivo, não um diretório, e o comando falhava com "Not a directory". Corrigido para `unshare --net=/namespaces/001/net`.
- Lab 4, item 3: `ip link set veth0 netns /root/namespaces/net` referenciava um caminho que não existe em nenhum outro passo do lab — corrigido para `/namespaces/001/net`, o mesmo arquivo-âncora do item 1/2.
- Lab 12, item 2: os dois `docker run` (um pra estourar CPU, outro memória) usavam o mesmo `--name limited_container`, e o segundo sempre falhava com conflito de nome. Renomeados para `limited_container_cpu`/`limited_container_mem`, com os passos seguintes (`docker stats`/`stop`/`rm`) ajustados pros dois nomes.

Todos encontrados rodando os labs de verdade (containers reais, não só revisão do texto).

## v1.1.3 - 2026-08-29

### Fixed

unidade2.md

- Lab 11, item 2: `apt-get install -y sudo` não instala mais o pacote `adduser` no `ubuntu:latest` atual (só `useradd`/`usermod` vêm por padrão) — o `adduser novo_usuario` do passo seguinte falhava com "command not found". Corrigido pra `apt-get install -y sudo adduser`. Encontrado rodando a sequência de comandos de verdade num container.

## v1.1.2 - 2026-08-29

### Added

unidade2.md

- Lab 4, itens 1-4: marcados com um comentário HTML `<!--term:split-h-2-->` (invisível em qualquer visualização Markdown, inclusive no GitHub) sinalizando que esses itens exigem dois terminais simultâneos apontando pro mesmo ambiente — usado por ferramentas de apoio ao curso para abrir dois consoles lado a lado nesses passos.

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
