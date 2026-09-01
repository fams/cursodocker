# LABS Unidade 1

Utilize o [Docker Cheat-sheet](https://docs.docker.com/get-started/docker_cheatsheet.pdf) para ajudar com os comandos:

## LAB 1

### Objetivo: Executar um container utilizando todos os comandos do ciclo de vida

1. Fazer o download da imagem e criar o container

    ```bash
    # Download da imagem
    docker image pull bash:latest

    # Lista imagens locais
    docker image ls

    # Cria um container de nome mybash a partir da imagem bash:latest
    docker container create --name mybash bash:latest
    ```

2. Verificar os containers do seu sistema. Observe que o container criado não está em execução

    ```bash
    # Mostrar os containers em execução
    docker ps

    # Mostrar todos os containers criados
    docker ps -a
    ```

3. Iniciando o container

    ```bash
    # Iniciar o container mybash
    docker start mybash

    # Verifique novamente se o container está em execução
    docker ps

    # Verifique agora com o switch de mostrar container em todos os estados
    docker ps -a
    ```

4. O container criado não ficou em execução. Vamos agora criar e executá-lo no modo interativo

    ```bash
    # Remover o container anterior
    docker rm mybash
    # Criar o container em modo interativo.
    # -i indica o modo interativo, o -t cria um tty para o container
    docker container create -i -t --name mybash bash:latest
    ```

    Inicie no modo interativo e anexado — você fica dentro do shell do container:

    ```bash
    $ docker start -ai mybash
    ```

    Dê o detach sem parar o container (`Ctrl+P Ctrl+Q`). De volta no host, confirme que ele continua em execução:

    ```bash
    docker ps
    ```

5. Executar todos os passos com o comando run

    ```bash
    # Executa o comando ps -ef no container a partir da imagem bash:latest
    docker run bash:latest ps -ef
    docker ps -a
    # Executar um container com --rm, solicitando remoção após o fim da execução
    docker run --rm bash:latest ps -ef
    docker ps -a
    ```

6. Remover os containers

    ```bash
    docker stop mybash --timeout 1
    docker rm mybash
    ```

## LAB 2

### Objetivo: interação com o container em execução

1. Iniciando o container interativo e deixando-o em execução

    ```bash
    # Criar o container em modo interativo
    docker container create -it --name mybash bash:latest
    ```

    Inicie no modo interativo, anexado — você fica dentro do shell do container:

    ```bash
    $ docker start -ai mybash
    ```

    Dê o detach sem parar o container (`Ctrl+P Ctrl+Q`). De volta no host:

    ```bash
    docker ps
    ```

2. Anexar ao container em execução

    ```bash
    $ docker attach mybash
    ```

    Dê o detach de novo (`Ctrl+P Ctrl+Q`) pra voltar ao host sem parar o container.

3. Anexar ao container em execução (forma equivalente, com o motivo comentado)

    ```bash
    $ docker attach mybash      # anexa ao container
    # Ctrl+P Ctrl+Q para dar o detach
    ```

4. Executar um segundo processo no container

    ```bash
    # Executar outro processo no container
    $ docker exec -it mybash /usr/local/bin/bash
    ```

    Agora você está num segundo shell dentro do container. Rode:

    ```bash
    # Listar os processos no container
    $ ps -ef
    $ exit
    ```

5. Executando um comando com variáveis de ambiente

    ```bash
    # Parar e remover o container anterior
    docker stop mybash --timeout 1
    docker rm mybash
    ```

    Crie e entre num container novo, já com uma variável de ambiente definida (`-e`):

    ```bash
    $ docker run -it --rm -e POSGRAD=PUC --name mybash bash:latest
    ```

    Dentro do container, verifique o conteúdo da variável e saia:

    ```bash
    $ echo $POSGRAD
    $ exit
    ```

6. Iniciando um container desanexado, retornando o controle para o shell do host

    ```bash
    # -d inicia o comando desanexado do console
    docker run -d --name mynginx nginx:latest
    docker ps
    ```

7. Remover os containers

    ```bash
    docker stop mynginx
    docker rm mynginx
    ```

## LAB 3

### Objetivo: Verificar a separação do sistema de arquivos do container para o host

1. Criar um arquivo no host e verificar sua existência no container

    ```bash
    # Criando um arquivo no /tmp do sistema host
    touch /tmp/hostfile.txt
    ```

    Execute um container e entre nele:

    ```bash
    $ docker run -it --name mybash bash
    ```

    Dentro do container, verifique que o arquivo criado no host não existe ali:

    ```bash
    $ ls /tmp
    ```

2. Criar um arquivo no container e verificar sua não existência no host

    Ainda dentro do container (continuando do passo anterior), crie um arquivo:

    ```bash
    $ touch /tmp/containerfile.txt
    ```

    Dê o detach sem parar o container (`Ctrl+P Ctrl+Q`). De volta no host, verifique que o arquivo criado no container não existe aqui:

    ```bash
    ls /tmp
    ```

3. Montando arquivos locais no container (bind Mount)

    ```bash
    # Diretorio mydir no host
    mkdir mydir
    touch mydir/myhostfile.txt
    ```

    Suba um container com o diretório do host montado dentro dele (`-v`):

    ```bash
    $ docker run -it --rm -v ./mydir:/mydir bash
    ```

    Dentro do container, confirme que o arquivo do host está lá, crie um novo e saia:

    ```bash
    $ ls /mydir
    $ touch /mydir/mycontainerfile.txt
    $ exit
    ```

    De volta no host, verifique que o arquivo criado dentro do container também aparece aqui:

    ```bash
    ls ./mydir
    ```

4. Remover os containers

    ```bash
    docker stop mybash --timeout 1
    docker rm mybash
    ```

## LAB 4

### Objetivo: Utilizando rede no container

1. Criando um container com uma imagem nginx. A imagem com o nome nginx puro, irá utilizar uma imagem do hub.docker.com, sem namespace e o tag será o default _latest_.
   Parâmetro -d inicia o container desanexado do console do docker client.

    ```bash
    $ docker run -d --name mynginx nginx
    $ docker ps
    ```

    Você verá algo semelhante a:

    ```output
    CONTAINER ID  IMAGE  COMMAND                        CREATED             STATUS                 PORTS              NAMES
    fdd7c763a066  nginx     "/docker-entrypoint.…"   11 minutes ago   Up 11 minutes   80/tcp
    ```

2. Veja que o container declara servir algo na porta 80/tcp. vamos tentar acessá-lo

    ```bash
    curl http://localhost
    ```

    Como você pode ver, não está acessível. O motivo é que apesar de exposta a porta, ela não está _publicada_ para o host

3. Faça a mesma chamada curl de dentro do container

    ```bash
    # Iniciando um processo /bin/bash (-i) com um terminal (-t) no container mynginx criado anteriormente
    $ docker exec -it mynginx /bin/bash
    ```

    Agora você está dentro do container. Rode:

    ```bash
    $ curl http://localhost
    $ exit
    ```

    De volta no host, pare e remova o container:

    ```bash
    $ docker stop mynginx
    $ docker rm mynginx
    ```

4. Publicando a porta exposta pelo container para o host

    ```bash
    # Iniciando um container nginx publicando a porta 80 do container através da porta 8080 do host.
    docker run -d --name mynginx --publish 8080:80 nginx
    # Acessando o container externamente
    curl http://localhost:8080
    # Parando e removendo o container
    docker stop mynginx
    docker rm mynginx
    ```

## LAB 5

### Objetivo: Servir páginas locais com o NGINX

1. Crie um diretório `www` com uma página local pra servir

    ```bash
    mkdir www
    echo "<h1>Servido pelo NGINX via bind mount</h1>" > www/index.html
    ```

2. Suba o NGINX montando esse diretório como conteúdo (somente leitura)

    ```bash
    # Mount ReadOnly
    docker run --name mynginx -v ./www:/usr/share/nginx/html:ro -d -p 8080:80 nginx
    curl localhost:8080
    ```

3. Remover os containers

    ```bash
    docker stop mynginx
    docker rm mynginx
    ```

## LAB 6

<!--console:ubuntu-->

### Objetivo: Utilizando uma imagem de banco mysql

1. Instale o cliente mysql

    ```bash
    apt install -y mysql-client
    ```

2. Execute o banco mysql com diretório local e iniciando o banco

    ```bash
    # utilize os SQLs do lab6 como scripts de inicio do mysql
    docker run --rm -d -v ./db:/var/lib/mysql -v./lab6/:/docker-entrypoint-initdb.d/ --name mysql-container -e MYSQL_ROOT_PASSWORD=my-secret-pw -p 3306:3306 mysql:latest
    # Conecte no banco
    mysql -pmy-secret-pw -uroot -h 127.0.0.1 <<EOF
    use guess_game;
    select * from jogos;
    EOF
    ```

3. Interrompa o mysql, ele será removido devido ao --rm

    ```bash
    docker stop mysql-container
    ```

## LAB 7

### Objetivo: Criar uma imagem e executar um container a partir da imagem criada

1. Criando uma imagem docker

    ```bash
    cd lab7
    cat Dockerfile
    # -t <imagename>:<version>
    docker build . -t py-web:01
    ```

2. Executando a imagem

    ```bash
    docker run --rm -d --publish 8080:80 --name my-py-web-01 py-web:01
    curl http://localhost:8080
    docker stop my-py-web-01
    ```

3. Execute agora a imagem, publicando todas as portas -P

    ```bash
    docker run --rm -P -d --name my-py-web-01 py-web:01
    ```

    Verifique a porta publicada

    ```bash
    docker ps --format 'table {{ truncate .Names 15 }}\t{{ .Ports }}'    
    ```

    Na coluna PORTS da linha correspondente ao seu container encontrará algo semelhante a isso:

    0.0.0.0:32768->80/tcp

    A porta Publicada é o que está entre o ":" e o "->"/. Faça o teste na porta publicada

    ```bash
    curl http://localhost:<porta publicada>
    ```

    Encerre o container

    ```bash
    docker stop my-py-web-01
    ```

4. Edite o Dockerfile e reconstrua a imagem. Altere a porta do webserver para 8080

    ```Dockerfile
    FROM ubuntu:22.04
    LABEL mantainer=fams@linuxplace.com.br
    SHELL [ "/bin/bash", "-c" ]
    WORKDIR  /var/www/html
    EXPOSE 80
    RUN apt-get update -y && apt-get install --no-install-recommends python3 -y
    COPY ./www/ /var/www/html
    # Alterando porta de 80 para 8080               |
    #                                               V
    ENTRYPOINT [ "python3", "-m", "http.server", "8080" ]
    ```

5. Construindo a imagem com tag 02

    ```bash
    docker build . -t py-web:02
    ```

6. Executando e testando a conexão:

    ```bash
    docker run -d --publish 8080:8080 --rm --name my-py-web-02 py-web:02
    curl http://localhost:8080
    docker stop my-py-web-02
    ```

    Verá que a conexão funciona normalmete, o EXPOSE não impede que a portaa seja publicada.

7. Tente fazer o mesmo com o -P ou --publish-all

    ```bash
    docker run -d -P --rm --name my-py-web-02 py-web:02
    curl http://localhost:8080
    # Verifique a porta que foi publicada
    docker ps --format 'table {{ truncate .Names 15 }}\t{{ .Ports }}'
    curl http://localhost:<porta publicada>
    docker stop my-py-web-02
    ```

8. Depois de verificar a falha, pois o -P exportou a porta não condizente com o serviço, edite o Dockerfile novamente e altere a diretiva EXPOSE e reconstrua a imagem

    ```Dockerfile
    FROM ubuntu:22.04
    LABEL mantainer=fams@linuxplace.com.br
    SHELL [ "/bin/bash", "-c" ]
    ENV FAMS=FERNANDO
    WORKDIR  /var/www/html
    # Alterando porta de 80 para 8080
    #       V
    EXPOSE 8080
    RUN apt-get update -y && apt-get install --no-install-recommends python3 -y
    COPY ./www/ /var/www/html
    # Alterando porta de 80 para 8080               |
    #                                               V
    ENTRYPOINT [ "python3", "-m", "http.server", "8080" ]
    ```

    ```bash
    docker build . -t py-web:03
    ```

9. Execute a imagem e teste

    ```bash
    docker run -P -d --name my-py-web-03 py-web:03
    # Verifique a porta que foi publicada
    docker ps --format 'table {{ truncate .Names 15 }}\t{{ .Ports }}'
    curl http://localhost:<porta publicada>
    docker stop my-py-web-03
    ```

10. Remover os containers

    ```bash
    docker stop my-py-web-03
    docker rm my-py-web-03
    ```

## LAB 8

<!--continua:unidade1-lab7-->

### Objetivo: Utilizando uma imagem a partir de outra e um repositório remoto

1. Liste a imagem do lab7 e vc vai econtrar algo como abaixo

    ```bash
    $ docker image ls
    ```

    ```output
    REPOSITORY    TAG       IMAGE ID       CREATED         SIZE
    py-web        03        fe2b3c002799   2 hours ago     160MB
    ```

2. Crie outra tag para a imagem

    ```bash
    docker tag py-web:03 py-web:04
    ```

3. Crie a imagem do lab8 a partir da imagem do lab7

    ```bash
    $ cd lab8
    $ docker build . -t lab8:01
    $ docker image ls
    ```

    ```output
    REPOSITORY    TAG       IMAGE ID       CREATED         SIZE
    py-web        04        fe2b3c002799   1 hours ago     160MB
    lab8          01        fcd86ff8ce8c   1 minute ago    160MB
    ```

4. Faça login no repositório. Se você estiver usando o Docker Desktop, o login já estará feito.

    ```bash
    $ docker login
    ```

    ```output
    Username: meuemail@dominio.com
    Password: ************
    WARNING! Your password will be stored unencrypted in
    Login Succeeded
    ```

5. Crie uma tag para envio para o repositório.
   Aqui você deve ter acesso ao seu namespace no Docker Hub cadastrado na aula de instalação. Troque o mynamespace para o seu namespace do Docker Hub.

    ```bash
    docker tag py-web:04 mynamespace/py-web:04
    docker push mynamespace/py-web:04
    ```

6. Apague a imagem local

    ```bash
    docker image rm py-web:04
    docker image rm mynamespace/py-web:04
    docker image ls
    ```

7. Edite o Dockerfile para utilizar a imagem do Docker Hub e recrie a imagem

    ```Dockerfile
    FROM mynamespace/py-web:04
    COPY ./www-2/ /var/www/html
    ```

    ```bash
    $ docker build . -t lab8:02
    $ docker image ls
    ```

    ```output
    REPOSITORY           TAG       IMAGE ID       CREATED         SIZE
    mynamespace/py-web   04        fe2b3c002799   1 hours ago     160MB
    lab8:01              02        d2c94e258dcb   1 minute ago    160MB
    ```

    Perceba que você foi capaz de recriar a imagem usando a fonte do repositório

## LAB 9

### Objetivo: Otimizando a construção da imagem

1. Construa a imagem do lab9. Nesse lab utilizaremos mais de um Dockerfile

    ```bash
    cd lab9
    docker build -f Dockerfile-1 -t lab9:01 .
    ```

2. Execute a imagem e teste o funcionamento. Você pode utilizar o browser no lugar do curl se quiser visulizar a página

    ```bash
    docker run -p 8080:8000 --rm -d --name lab9-01 lab9:01
    curl http://localhost:8080
    docker stop lab9-01
    ```

3. Edite o index.html em www, troque a linha 45 de 9 para 9.1 e recrie a imagem

    ```html
            <h1>Bem-vindo ao LAB 9 - Docker</h1>
    ```

    ```bash
    docker build -f Dockerfile-1 -t lab9:01 .
    docker run -p 8080:8000 --rm -d --name lab9-01 lab9:01
    curl http://localhost:8080
    docker stop lab9-01
    ```

    **Perceba que todos os passos do build foram refeitos, inclusive a instalação do golang.**

4. Vamos agora otimizar o Dockerfile para otimizar o cache. Reorganize o Dockerfile-1 com o nome de Dockerfile-2 com a ordem abaixo

    ```Dockerfile
    FROM ubuntu:22.04
    LABEL mantainer=fams@linuxplace.com.br
    RUN apt update -y
    RUN apt install --no-install-recommends -y golang-go
    WORKDIR /src
    COPY main.go /src
    COPY go.mod /src
    RUN go mod tidy
    RUN go build -o httpserver main.go
    RUN cp httpserver /usr/local/sbin
    ENV PATH=$PATH:/usr/local/bin
    COPY ./www/ /var/www/html
    WORKDIR /var/www/html
    EXPOSE 8000
    ENTRYPOINT [ "httpserver" ]
    ```

    ```bash
    docker build -f Dockerfile-2 -t lab9:02 .
    ```

    Veja as camadas que foram geradas com o novo dockerfile

    ```bash
    $ docker history lab9:02
    ```

    ```output
    IMAGE          CREATED          CREATED BY                                      SIZE      COMMENT
    dd36894cd0e3   43 seconds ago   ENTRYPOINT ["httpserver"]                       0B        buildkit.dockerfile.v0
    <missing>      43 seconds ago   EXPOSE map[8000/tcp:{}]                         0B        buildkit.dockerfile.v0
    <missing>      43 seconds ago   WORKDIR /var/www/html                           0B        buildkit.dockerfile.v0
    <missing>      43 seconds ago   COPY ./www/ /var/www/html # buildkit            1.84kB    buildkit.dockerfile.v0
    <missing>      43 seconds ago   ENV PATH=/usr/local/sbin:/usr/local/bin:/usr…   0B        buildkit.dockerfile.v0
    <missing>      43 seconds ago   RUN /bin/sh -c cp httpserver /usr/local/sbin…   6.42MB    buildkit.dockerfile.v0
    <missing>      43 seconds ago   RUN /bin/sh -c go build -o httpserver main.g…   6.44MB    buildkit.dockerfile.v0
    <missing>      44 seconds ago   RUN /bin/sh -c go mod tidy # buildkit           21B       buildkit.dockerfile.v0
    <missing>      45 seconds ago   COPY go.mod /src # buildkit                     21B       buildkit.dockerfile.v0
    <missing>      45 seconds ago   COPY main.go /src # buildkit                    376B      buildkit.dockerfile.v0
    <missing>      45 seconds ago   WORKDIR /src                                    0B        buildkit.dockerfile.v0
    <missing>      45 seconds ago   RUN /bin/sh -c apt install --no-install-reco…   431MB     buildkit.dockerfile.v0
    <missing>      58 seconds ago   RUN /bin/sh -c apt update -y # buildkit         52.7MB    buildkit.dockerfile.v0
    <missing>      58 seconds ago   LABEL mantainer=fams@linuxplace.com.br          0B        buildkit.dockerfile.v0
    <missing>      3 weeks ago      /bin/sh -c #(nop)  CMD ["/bin/bash"]            0B
    <missing>      3 weeks ago      /bin/sh -c #(nop) ADD file:89847d76d242dea90…   77.9MB
    <missing>      3 weeks ago      /bin/sh -c #(nop)  LABEL org.opencontainers.…   0B
    <missing>      3 weeks ago      /bin/sh -c #(nop)  LABEL org.opencontainers.…   0B
    <missing>      3 weeks ago      /bin/sh -c #(nop)  ARG LAUNCHPAD_BUILD_ARCH     0B
    ```

5. Altere novamente o HTML e recrie a imagem

    ```html
    ...
            <h1>Bem-vindo ao LAB 9:02 - Docker</h1>
    ...
    ```

    ```bash
    docker build -f Dockerfile-2 -t lab9:02 .
    ```

    Repare que somente a cópia dos arquivos foi refeita

6. Use o docker history para ver as camadas criadas na imagem

    ```bash
    $ docker history lab9:02
    ```

    ```output
    IMAGE          CREATED         CREATED BY                                      SIZE      COMMENT
    d92198e67f61   7 seconds ago   ENTRYPOINT ["httpserver"]                       0B        buildkit.dockerfile.v0
    <missing>      7 seconds ago   EXPOSE map[8000/tcp:{}]                         0B        buildkit.dockerfile.v0
    <missing>      7 seconds ago   WORKDIR /var/www/html                           0B        buildkit.dockerfile.v0
    <missing>      7 seconds ago   COPY ./www/ /var/www/html # buildkit            1.84kB    buildkit.dockerfile.v0
    <missing>      2 minutes ago   ENV PATH=/usr/local/sbin:/usr/local/bin:/usr…   0B        buildkit.dockerfile.v0
    <missing>      2 minutes ago   RUN /bin/sh -c cp httpserver /usr/local/sbin…   6.45MB    buildkit.dockerfile.v0
    <missing>      2 minutes ago   RUN /bin/sh -c go build -o httpserver main.g…   6.46MB    buildkit.dockerfile.v0
    <missing>      3 minutes ago   RUN /bin/sh -c go mod tidy # buildkit           21B       buildkit.dockerfile.v0
    <missing>      3 minutes ago   COPY go.mod /src # buildkit                     21B       buildkit.dockerfile.v0
    <missing>      3 minutes ago   COPY main.go /src # buildkit                    376B      buildkit.dockerfile.v0
    <missing>      3 minutes ago   WORKDIR /src                                    0B        buildkit.dockerfile.v0
    <missing>      3 minutes ago   RUN /bin/sh -c apt install --no-install-reco…   431MB     buildkit.dockerfile.v0
    <missing>      3 minutes ago   RUN /bin/sh -c apt update -y # buildkit         63.9MB    buildkit.dockerfile.v0
    <missing>      3 minutes ago   LABEL mantainer=fams@linuxplace.com.br          0B        buildkit.dockerfile.v0
    <missing>      3 weeks ago     /bin/sh -c #(nop)  CMD ["/bin/bash"]            0B
    <missing>      3 weeks ago     /bin/sh -c #(nop) ADD file:82f38ebced7b27563…   77.9MB
    <missing>      3 weeks ago     /bin/sh -c #(nop)  LABEL org.opencontainers.…   0B
    <missing>      3 weeks ago     /bin/sh -c #(nop)  LABEL org.opencontainers.…   0B
    <missing>      3 weeks ago     /bin/sh -c #(nop)  ARG LAUNCHPAD_BUILD_ARCH     0B
    <missing>      3 weeks ago     /bin/sh -c #(nop)  ARG RELEASE                  0B
    ```

    Repare que somente as camadas da cópia foram recriadas

7. Vamos otimizar o Dockerfile-2 para ter menos camadas.
   1. Concatene comandos shell seguidos com && para que sejam um único comando

        ```Dockerfile
        FROM ubuntu:22.04
        LABEL mantainer=fams@linuxplace.com.br
        RUN apt update -y && apt install --no-install-recommends -y golang-go
        WORKDIR /src
        COPY main.go /src
        COPY go.mod /src
        RUN go mod tidy
        RUN go build -o httpserver main.go
        RUN cp httpserver /usr/local/sbin
        ENV PATH=$PATH:/usr/local/bin
        COPY ./www/ /var/www/html
        WORKDIR /var/www/html
        EXPOSE 8000
        ENTRYPOINT [ "httpserver" ]
        ```

   2. Mova os arquivos do programa go para um diretório src.

        ```bash
        mkdir src
        mv main.go go.mod src
        ```

   3. Edite o Dockerfile-2 para fazer uma única cópia. Estamos intencionalmente separando a cópia do programa go para a cópia da pagina html

        ```Dockerfile
        FROM ubuntu:22.04
        LABEL mantainer=fams@linuxplace.com.br
        RUN apt update -y && apt install --no-install-recommends -y golang-go
        WORKDIR  /src
        COPY src/ /src
        RUN go mod tidy && go build -o httpserver main.go && cp httpserver /usr/local/sbin
        ENV PATH=$PATH:/usr/local/bin
        COPY ./www/ /var/www/html
        WORKDIR  /var/www/html
        EXPOSE 8000
        ENTRYPOINT [ "httpserver" ]
        ```

   4. Reconstrua a imagem e veja a diminuição do número de camadas

        ```bash
        docker build -f Dockerfile-2 -t lab9:3 .
        docker history lab9:3
        ```

## LAB 10

### Objetivo: Uso do multi-stage Build

Uma das preocupações que devemos ter é diminuir o tamanho da imagem. No lab anterior criamos imagens com o ubuntu

1. Veja o Dockerfile do LAB10

    ```Dockerfile
    # Primeiro estágio
    FROM ubuntu:22.04 AS build
    LABEL mantainer=fams@linuxplace.com.br
    RUN apt update -y && apt install --no-install-recommends -y golang-go
    WORKDIR /src
    COPY src/ /src
    RUN go mod tidy && CGO_ENABLED=0 GOOS=linux go build -o httpserver main.go

    # Segundo estágio
    FROM scratch
    COPY --from=build /src/httpserver /usr/local/bin/httpserver
    ENV PATH=$PATH:/usr/local/bin
    COPY ./www/ /var/www/html
    WORKDIR  /var/www/html
    EXPOSE 8000
    ENTRYPOINT [ "/usr/local/bin/httpserver" ]
    ```

2. Execute o docker build

    ```bash
    cd lab10
    docker build . -t lab10:01
    ```

3. Liste as imagens e veja a diferença de tamanho

    ```bash
    $ docker images
    ```

    ```output
    REPOSITORY   TAG       IMAGE ID       CREATED          SIZE
    lab10        01        d10b2234bcbf   2 minutes ago    6.37MB
    <none>       <none>    4dbc0d21ff07   20 minutes ago   6.43MB
    <none>       <none>    a8bb29293bf7   20 minutes ago   6.43MB
    <none>       <none>    4c935bfce53a   20 minutes ago   6.43MB
    <none>       <none>    81d17dea5d31   20 minutes ago   6.43MB
    lab9         03        dfbe392f7c1e   26 minutes ago   574MB
    lab9         02        275ab47b99ea   35 minutes ago   574MB
    <none>       <none>    dd36894cd0e3   37 minutes ago   574MB
    ```

    Veja que a imagem lab10 é significamente menor que a imagem lab9. Isso acontece porque usamos uma imagem _scratch_ como base para nossa imagem. Uma imagem scratch é literalmente vazia, na verdade nem mesmo existe uma imagem scratch. Ela é uma palavra reservada que executa uma não operação de tamanho 0.

    O sistema operacional e toda a suite de compilação só foram usados no primeiro estágio com nome de _build_. No segundo estágio, somente o binário foi copiado para a imagem.

    Esse procedimento com imagem _scratch_ é possível porque o _GO_ possui uma compilação estática, isso é, não depende de bibliotecas. É possivel fazer algo semelhante para outras linguagens, como por exemplo _java_, onde no primeiro estágio _build_ temos a _JDK_ e no segundo estágio somente a _JRE_.

## LAB 11

<!--continua:unidade1-lab10-->

### Objetivo: Acelerar builds com cache mounts do BuildKit

1. **Crie o diretório do lab11**

    ```bash
    mkdir lab11 && cd lab11
    cp -R ../lab10/src .
    ```

2. **Escreva um Dockerfile habilitando a sintaxe estendida do BuildKit**

    ```Dockerfile
    # syntax=docker/dockerfile:1
    FROM golang:1.22 AS build
    WORKDIR /src
    COPY src/ /src
    RUN --mount=type=cache,target=/root/go/pkg/mod \
        --mount=type=cache,target=/root/.cache/go-build \
        go mod tidy && CGO_ENABLED=0 go build -o httpserver main.go

    FROM scratch
    COPY --from=build /src/httpserver /usr/local/bin/httpserver
    ENTRYPOINT [ "/usr/local/bin/httpserver" ]
    ```

    `CGO_ENABLED=0` é necessário porque a imagem `golang:1.22` tem um compilador C disponível, e por padrão o Go liga o binário dinamicamente contra a libc do sistema quando isso acontece — um binário assim não roda em `FROM scratch` (que não tem libc nem o interpretador de ld dinâmico). Com `CGO_ENABLED=0`, o binário sai estaticamente linkado.

3. **Faça o primeiro build e cronometre**

    ```bash
    time docker build -t lab11-cache:01 .
    ```

4. **Force a reconstrução (mude um comentário no `main.go`) e cronometre de novo**

    ```bash
    time docker build -t lab11-cache:02 .
    ```

    Compare com o mesmo Dockerfile sem `--mount=type=cache` (baixando módulos do zero a cada build). Note que o cache de módulos/`go build` persiste **entre builds**, mesmo sem aparecer no `docker history` nem inflar a imagem final.

5. **Inspecione os caches do BuildKit**

    ```bash
    docker builder du
    docker builder prune --filter type=exec.cachemount
    ```

## LAB 12

<!--continua:unidade1-lab11-->

### Objetivo: Construir imagens multi-plataforma com `buildx`

1. **Suba um registry local**

    ```bash
    docker run -d --name registry -p 5000:5000 registry:2.8.2
    ```

2. **Crie e ative um builder `buildx` com rede compartilhada com o host**

    ```bash
    docker buildx create --name multiarch --driver-opt network=host --use
    docker buildx inspect --bootstrap
    ```

    O driver padrão (`docker-container`) roda o BuildKit isolado num container com seu próprio namespace de rede — sem `network=host`, o `--push` do próximo passo não alcança o `localhost:5000` do passo anterior.

3. **Reaproveite o Dockerfile do Lab 11**

    ```bash
    cd ../lab11
    ```

4. **Construa para duas arquiteturas e publique no registry local**

    ```bash
    docker buildx build \
      --platform linux/amd64,linux/arm64 \
      -t localhost:5000/lab11-multi:01 \
      --push .
    ```

5. **Inspecione o manifest list gerado**

    ```bash
    docker buildx imagetools inspect localhost:5000/lab11-multi:01
    # Note as duas entradas de plataforma dentro do mesmo tag
    ```

6. **Rode a imagem e confira que o Docker seleciona a plataforma correta automaticamente**

    ```bash
    docker run --rm localhost:5000/lab11-multi:01
    ```

## LAB 13

### Objetivo: Parametrizar builds com `ARG` e injetar credenciais de build sem deixar rastro na imagem

1. **Entre no diretório do lab13**

    ```bash
    cd lab13
    ```

2. **Use `ARG` para parametrizar a versão da imagem base**

    ```Dockerfile
    # syntax=docker/dockerfile:1
    ARG GO_VERSION=1.22
    FROM golang:${GO_VERSION} AS build
    WORKDIR /src
    COPY . .
    RUN go build -o app .
    ```

    ```bash
    docker build --build-arg GO_VERSION=1.23 -t lab13:01 .
    ```

3. **Reproduza o problema clássico: um segredo passado por `ARG`/`ENV` fica gravado na camada e no histórico**

    ```Dockerfile
    ARG API_TOKEN
    ENV API_TOKEN=$API_TOKEN
    RUN curl -H "Authorization: Bearer $API_TOKEN" https://httpbin.org/get
    ```

    ```bash
    docker build --build-arg API_TOKEN=segredo123 -t lab13-inseguro:01 .
    docker history --no-trunc lab13-inseguro:01 | grep segredo123
    # O token aparece exposto no histórico da imagem
    ```

4. **Corrija usando `RUN --mount=type=secret`, que nunca persiste em camada**

    ```Dockerfile
    # syntax=docker/dockerfile:1
    RUN --mount=type=secret,id=api_token \
        curl -H "Authorization: Bearer $(cat /run/secrets/api_token)" https://httpbin.org/get
    ```

    ```bash
    echo "segredo123" > token.txt
    docker build --secret id=api_token,src=token.txt -t lab13-seguro:01 .
    docker history --no-trunc lab13-seguro:01 | grep segredo123
    # Nada é encontrado: o segredo não fica gravado em nenhuma camada
    ```

## LAB 14

<!--continua:unidade1-lab13-->

### Objetivo: Reduzir camadas de build com `COPY --link` e bind mounts de contexto

1. **Copie o lab13 para o lab14**

    ```bash
    cp -R ../lab13 ../lab14 && cd ../lab14
    ```

2. **Compare `COPY` tradicional com `COPY --link`**

    ```Dockerfile
    # syntax=docker/dockerfile:1
    FROM golang:1.22 AS build
    WORKDIR /src
    RUN --mount=type=bind,source=.,target=/src \
        --mount=type=cache,target=/root/go/pkg/mod \
        go build -o /out/app .

    FROM scratch
    COPY --link --from=build /out/app /app
    ENTRYPOINT [ "/app" ]
    ```

3. **Construa a imagem e veja no `docker history` que o `RUN` não precisou de um `COPY` intermediário do código-fonte para o contexto de build**

    ```bash
    docker build -t lab14:01 .
    docker history lab14:01
    ```

4. **Altere o código-fonte (`main.go`) e reconstrua** -- com `--link`, o BuildKit trata a camada final (`COPY --link --from=build /out/app /app`) de forma independente das anteriores, anexando o binário novo sem precisar remontar as camadas de baixo do zero.

    ```bash
    echo 'func init() { println("versão 2 do binário") }' >> main.go
    docker build -t lab14:01 .
    docker run --rm lab14:01
    ```

## LAB 15

<!--continua:unidade1-lab12-->

### Objetivo: Gerar SBOM e proveniência de build (introdução a supply-chain)

1. **Reaproveite o builder (`buildx`) e o Dockerfile do Lab 11/12** -- este build não usa `--platform` aqui, só o mesmo builder e diretório

    ```bash
    cd ../lab11
    ```

2. **Construa habilitando SBOM e provenance**

    ```bash
    docker buildx build \
      --sbom=true \
      --provenance=true \
      -t localhost:5000/lab11-attest:01 \
      --push .
    ```

3. **Inspecione o SBOM (Software Bill of Materials) gerado**

    ```bash
    docker buildx imagetools inspect localhost:5000/lab11-attest:01 --format '{{ json .SBOM }}'
    ```

4. **Inspecione a proveniência (como e onde a imagem foi construída)**

    ```bash
    docker buildx imagetools inspect localhost:5000/lab11-attest:01 --format '{{ json .Provenance }}'
    ```

5. **Discuta**: por que essas informações importam para auditoria e rastreabilidade de uma cadeia de build — o SBOM lista o que foi usado para montar a imagem, a proveniência mostra de onde ela veio.
