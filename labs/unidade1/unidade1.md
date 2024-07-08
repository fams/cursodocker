# LABS Unidade 1

Utilize o [Docker Cheat-sheet](https://docs.docker.com/get-started/docker_cheatsheet.pdf) para ajudar com os comandos:

## LAB 1

### Objetivo: Executar um container utilizando todos os comandos do ciclo de vida

1. Fazer o download da imagem e criar o container

    ```bash
    # Download da imagem
    $ docker image pull bash:latest
    
    # Lista imagens locais
    $ docker image ls
    
    # Cria um container de nome mybash a partir da imagem bash:latest
    $ docker container create --name mybash bash:latest
    ```

2. Verificar so containers  do seu sistema. Observe que o container criado não está em execução

    ```bash
    # Mostrar os containers em execução
    $ docker ps 
    
    # Mostrar todos os containers criados
    $ docker ps –a
    ```

3. Iniciando o container

    ```bash
    # Inicar  o container mybash
    $ docker start mybash
    
    # Verifique novamente se o container está em exeução
    $ docker ps
    ```

4. O container criado não ficou em execução. Vamos agora criar e executá-lo no modo interativo

    ```bash
    # Criar o container em modo interativo.
    # -i indica o modo interativo, o -t cria um tty para o container
    $ docker container create -i -t --name mybash bash:latest
    
    # Iniciar no modo interativo e attached
    $ docker start -ai mybash
    bash-5.2# 
     
    # Sair do container com ele anexado
    # (Ctrl+P Ctrl+Q)         # <- sequencia de dettach
    $ docker ps               # mostra os containers em execução
    ```

5. Executar todos os passos com o comando run

    ```bash
    # Executa o comando ps -ef no container a partir da imagem bash:latest
    $ docker run bash:latest ps –ef
    $ docker ps -a
    # Executar um container com --rm, solicitando remoção apos o fim da execução
    $ docker run --rm bash:latest ps –ef
    $ docker ps -a
    ```

## LAB 2

### Objetivo: interação com o container em execução

1. Iniciando o container interativo e deixando-o em execução

    ```bash
    # Criar o container em modo interativo
    $ docker container create -it --name mybash bash:latest
    
    # Iniciar o container no modo interativo e anexar-se a ele
    $ docker start -ai mybash
    bash-5.2#
    
    # Sair do container com ele anexado
    # (Ctrl+P Ctrl+Q)           # <- sequencia de dettach
    $ docker ps               # mostra os containers em execução
    ```

2. Anexar ao container em execução

    ```bash
    # Anexar ao container
    $ docker attach mybash
    bash-5.2$#
    
    # dettach
    # (Ctrl+P Ctrl+Q)
    $
    ```

3. Anexar ao container em execução

    ```bash
    $ docker attach mybash      # anexa ao container
    # Ctrl+P Ctrl+Q
    ```

4. Executar um segundo processo no container

    ```bash
    # Executar outro processo no container
    $ docker exec -it mybash /usr/local/bin/bash
    bash-5.2#
    # Listar os processos no container 
    bash-5.2# ps –ef 
    bash-5.2# exit
    ```

5. Executando um comando com variáveis de ambiente

    ```bash
    # -e indica a criação da variável POSGRAD com valor PUC no container
    $ docker run -it --rm -e POSGRAD=PUC --name mybash bash:latest
    # Verifique o conteúdo da variável no container
    bash-5.2# echo $POSGRAD
    bash-5.2# exit
    $ 
    ```

6. Iniciando um container desanexado, retornando o controle para o shell do host

    ```bash
    # -d inicia o comando desanexado do console
    $ docker run -d --name mynginx nginx:latest
    $ docker ps
    ```

## LAB 3

### Objetivo: Verificar a separação do sistema de arquivos do container para o host

1. Criar um arquivo no host e verificar sua existência no container

    ```bash
    # Criando um arquivo no /tmp do sistema host
    $ touch /tmp/hostfile.txt
    # Executar um container
    $ docker run -it bash
    # Verificar a não existência no sistema rais
    bash-5.2$ ls /tmp
    ```

2. Criar um arquivo no container e verificar sua não existência no host

    ```bash
    # Criar um arquivo no /tmp do container
    bash-5.2$# touch /tmp/containerfile.txt
    # Ctrl+P Ctrl+Q (dettash)
    
    # Verificar a inexistência do arquivo containerfile.txt no nost
    $ ls /tmp
    ```

3. Montando arquivos locais no container (bind Mount)

   ```bash
   # Diretorio mydir no host
   $ mkdir mydir
   $ touch mydir/myhostfile.txt
   # -v monta o diretorio mydir do host no /mydir do container
   $ docker run –it --rm –v ./mydir:/mydir bash
   # ls /mydir
   # touch /mydir/mycontainerfile.txt
   # exit
   # Verifique que agora existe o arquivo no host
   $ ls ./mydir
   ```

## LAB 4

### Objetivo: Utilizando rede no container

1. Criando um container com uma imagem nginx. A imagem com o nome nginx puro, ira utilizar uma imagem do hub.docker.com, sem namespace e o tag será o default _latest_.
   Parâmetro -d inicia o container desanexado do console do docker client. A imagem ser

    ```bash
    docker run –d --name mynginx nginx
    docker ps
    ```

    Você verá algo semelhante a:

    ```bash
    CONTAINER ID  IMAGE  COMMAND                        CREATED             STATUS                 PORTS              NAMES
    fdd7c763a066  nginx     "/docker-entrypoint.…"   11 minutes ago   Up 11 minutes   80/tcp 
    ```

2. Veja que o container declara servir algo na porta 80/tcp. vamos tentar aceçá-lo

    ```bash
    curl http://localhost
    ```

    Como vc pode ver não está acessível. O motivo é que apesar de exposta a porta, ela não está _publicada_     para o host

3. Faca a mesma chamada curl de dentro do container

    ```bash
    # Iniciando um processo /bin/bash (-i) com um terminal (-t) no container mynginx criado anteriormente
    $ docker exec --it mynginx -- /bin/bash
    # Acessando a porta 80 local
    bash-5.2$# curl http://localhost
    bash-5.2$# exit 
    # Pare e remova o container
    docker stop mynginx
    docker rm mynginx
    ```

4. Publicando a porta exposta pelo container para o host

    ```bash
    # Iniciando um container nginx publicando a porta 80 do container atravéz da porta 8080 do host.
    $  docker run -d --publish 8080:80 nginx
    # Acessando o container externament
    $ curl http://localhost:8080
    # Parando e removendo o container
    docker stop mynginx
    docker rm mynginx
    ```

## LAB 5

### Objetivo: Servir paginas locais com o NGINX

1. no lab5

    ```bash
    # Mount Read0Only
    $  docker run --name my-nginx -v ./www:/usr/share/nginx/html:ro -d -p 8080:80 nginx 
    $ curl localhost:8080
    ```

## LAB 6

### Objetivo: Utilizando uma imagem de banco mysql

1. Instale o cliente mysql

    ```bash
    apt install -y mysql-client
    ```

2. Execute o banco mysql com diretório local e iniciando o banco

    ```bash
    # utilize os sqls do lab6 como scripts de inicio do mysql
    docker run --rm -d  -v ./db:/var/lib/mysql -v./lab6/:/docker-entrypoint-initdb.d/  --name mysql-container -e MYSQL_ROOT_PASSWORD=my-secret-pw -p 3306:3306 mysql:latest
    # Conecte no banco 
    mysql -pmy-secret-pw -uroot -h 127.0.0.1 <<EOF
    use guess_game;
    select * from jogos;
    EOF
    ```

3. Interrompa o mysql, ele será removido devido ao --rm

    ```bash
    docker stop mysql-container
    docker rm mysql-container
    ```

4. Inicie o mysql utilizando o mesmo container de dados

## LAB 7

### Objetivo: Criar uma imagem e executar um container a partir da imagem criada

1. Criando uma imagem docker

    ```bash
    $ cd labs/lab7
    $ cat Dockerfile
    # -t <imagename>:<version>
    $ docker build . -t py-web:01
    ```

2. Executando a imagem

    ```bash
    docker run --rm –d --publish 8080:80 --name my-py-web-01 py-web:01
    curl http://localhost:8080
    docker stop my-py-web-01
    ```

3. Edite o Dockerfile e re-construa a imagem. Altere a porta do webserver para 8080

    ```Dockerfile
    FROM ubuntu:22.04
    LABEL mantainer=fams@linuxplace.com.br
    SHELL [ "/bin/bash", "-c" ]
    ENV FAMS=FERNANDO
    WORKDIR  /var/www/html
    EXPOSE 80
    RUN apt-get update -y && apt-get install --no-install-recommends python3 -y
    COPY ./www/ /var/www/html
    # Alterando porta de 80 para 8080                           |
    #                                               V
    ENTRYPOINT [ "python3", "-m", "http.server", "8080" ] 
    ```

4. Construindo a imagem com tag 02

    ```bash
    docker build . -t py-web:02
    ```

5. Executando e testando a conexão:

    ```bash
    docker run –d --publish 8080:8080 --rm --name my-py-web-02 py-web:02
    curl http://localhost:8080
    docker stop my-py-web-02
    ```

6. Depois de verificar a falha, edite o Dockerfile novamente e altere a diretiva EXPOSE e reconstrua a imagem

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
    docker docker build . -t py-web:03
    ```

7. Execute a imagem e teste

    ```bash
    docker run –d --publish 8080:8080 py-web:03
    curl http://localhost:8080
    ```

## LAB 8

### Objetivo: Utilizando uma imagem a partir de outra e um repositório remoto

1. Liste a imagem do lab7 e vc vai econtrar algo como abaixo

    ```bash
    $ docker image ls
    
    REPOSITORY    TAG       IMAGE ID       CREATED         SIZE
    py-web        03        fe2b3c002799   2 hours ago     160MB
    ```

2. Crie outro tag para a imagem

    ```bash
    docker tag -t py-web:04 py-web:03
    ```

3. Crie a imagem do lab8 a partir da imagem do lab7

    ```Dockerfile
    FROM fams/py-web:04
    COPY ./www-2/ /var/www/html
    ```

    ```bash
    $ docker build . –t lab8:01
    $ docker image ls
    
    REPOSITORY    TAG       IMAGE ID       CREATED         SIZE
    py-web        04        fe2b3c002799   1 hours ago     160MB
    Lab8:01       01        fcd86ff8ce8c   1 minute ago    160MB
    ```

4. Crie uma tag para envio para o repositório.
   Aqui você deve ter acesso ao seu namespace no docker Hub Cadastrado na aula de instalação. Troque o mynamespace para o seu namespace do docker HUB.

    ```bash
    docker tag mynamespace/py-web:04 py-web
    docker push
    ```

5. Faça login no repositório. Se você estiver usando o docker desktop, o login já estará feito.

    ```bash
    $ docker login
    Username: meuemail@dominio.com
    Password: ************
    WARNING! Your password will be stored unencrypted in 
    Login Succeeded
    ```

6. Apague a imagem local

    ```bash
    docker rm py-web:04
    docker rm mynamespace/py-web:04
    docker image ls
    ```

7. Edite o Dockerfile para utilizar a imagem do docker hub e recrie a imagem

    ```Dockerfile
    FROM fams/py-web:04
    COPY ./www /var/www/html
    ```

    ```bash
    $ docker build . –t lab8:02
    $ docker image ls
    
    REPOSITORY           TAG       IMAGE ID       CREATED         SIZE
    mynamespace/py-web   04        fe2b3c002799   1 hours ago     160MB
    lab8:01              02        d2c94e258dcb   1 minute ago    160MB
    ```

    Perceba que você foi capaz de recriar a imagem usando a fonte do repositório

## LAB 9

### Objetivo: Otimizando a construção da imagem

1. Construa a imagem do lab9. Nesse lab utilizaremos mais de um Dockerfile

    ```bash
    cd labs/lab9
    docker build . -t lab9:01 -f Dockerfile-1
    ```

2. Execute a imagem e teste o funcionamento. Você pode utiliar o browser no lugar do curl se quiser visulizar a páginas

    ```bash
    docker run -p 8080:8000 --rm -d --name lab9-01 lab9:01
    curl http://localhost:8080
    docker stop lab9-01
    ```

3. Edite o index.hml em www, troque a linha 45 de 9 para 9.1 e recrie a imagem

    ```html
    ...
            <h1>Bem-vindo ao LAB 9 - Docker</h1>
    ...
    ```

    ```bash
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
    WORKDIR  /src
    COPY main.go /src
    COPY go.mod /src
    RUN go mod tidy
    RUN go build -o httpserver main.go
    RUN cp httpserver /usr/local/sbin
    ENV PATH=$PATH:/usr/local/bin
    COPY ./www/ /var/www/html
    WORKDIR  /var/www/html
    EXPOSE 8000
    ENTRYPOINT [ "httpserver" ]
    ```

    ```bash
    docker build -f Dockerfile-2 -t lab9:02 .
    ```

    Veja as camadas que foram geradas com o novo dockerfile

    ```bash
    $ docker history lab9:02
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
    [+] Building 0.4s (16/16) FINISHED                                                                             docker:default
     => [internal] load build definition from Dockerfile-2                                                                   0.0s
     => => transferring dockerfile: 423B                                                                                     0.0s
     => [internal] load .dockerignore                                                                                        0.0s
     => => transferring context: 2B                                                                                          0.0s
     => [internal] load metadata for docker.io/library/ubuntu:22.04                                                          0.2s
     => [ 1/11] FROM docker.io/library/ubuntu:22.04@sha256:19478ce7fc2ffbce89df29fea5725a8d12e57de52eb9ea570890dc5852aac1ac  0.0s
     => [internal] load build context                                                                                        0.0s
     => => transferring context: 1.96kB                                                                                      0.0s
     => CACHED [ 2/11] RUN apt update -y                                                                                     0.0s
     => CACHED [ 3/11] RUN apt install --no-install-recommends -y golang-go                                                  0.0s
     => CACHED [ 4/11] WORKDIR  /src                                                                                         0.0s
     => CACHED [ 5/11] COPY main.go /src                                                                                     0.0s
     => CACHED [ 6/11] COPY go.mod /src                                                                                      0.0s
     => CACHED [ 7/11] RUN go mod tidy                                                                                       0.0s
     => CACHED [ 8/11] RUN go build -o httpserver main.go                                                                    0.0s
     => CACHED [ 9/11] RUN cp httpserver /usr/local/sbin                                                                     0.0s
     => [10/11] COPY ./www/ /var/www/html                                                                                    0.0s
     => [11/11] WORKDIR  /var/www/html                                                                                       0.0s
     => exporting to image                                                                                                   0.1s
     => => exporting layers                                                                                                  0.1s
     => => writing image sha256:275ab47b99eacf423020e0bcf5a8913875e3e5d141143c6e598a63a58d5647d2                             0.0s
     => => naming to docker.io/library/lab9:02                                                                               0.0s
    ```

    Repare que somente as camadas da copia foram recriadas

7. Vamos otimizar o Dockerfile para ter menos camadas.
   1. Concatene comandos shell seguidos com && para que sejam um único comando

        ```Dockerfile
        FROM ubuntu:22.04
        LABEL mantainer=fams@linuxplace.com.br
        RUN apt update -y && apt install --no-install-recommends -y golang-go
        WORKDIR  /src
        COPY src/ /src
        COPY go.mod /src
        RUN go mod tidy && go build -o httpserver main.go && cp httpserver /usr/local/sbin
        ENV PATH=$PATH:/usr/local/bin
        COPY ./www/ /var/www/html
        WORKDIR  /var/www/html
        EXPOSE 8000
        ENTRYPOINT [ "httpserver" ]
        ```

   2. Mova os arquivos do programa go para um diretório src.

        ```bash
        mkdir src
        mv main.go go.mod src
        ```

   3. Edite o Dockerfile para fazer uma única cópia. Estamos intencionalmente separando a cópia do programa go para a copia da pagina html

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
        docker build . -t lab9:3
        docker history -t lab9:3
        ```

## LAB 10

### Objetivo Uso do multi-stage Build

Uma das preocupações que devemos ter é diminuir o tamanho da imagem. No lab anterior criamos imagens com o ubuntu

1. Veja o Dockerfile do LAB10

    ```Dockerfile
    # Primeiro estágio
    FROM ubuntu:22.04 AS build
    LABEL mantainer=fams@linuxplace.com.br
    RUN apt update -y && apt install --no-install-recommends -y golang-go
    WORKDIR  /src
    COPY src/ /src
    RUN  go mod tidy && CGO_ENABLED=0 GOOS=linux go build -o httpserver main.go
    
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
    docker build . -t lab10:01
    ```

3. Liste as imagens e veja a diferença de tamanho

    ```bash
    $ docker images
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

    Veja que a imagem lab10 é significamente menor que a imagem lab9. Isso acontece porque usamos uma imagem _scratch_ como base para nossa imagem. Uma imagem scratch não tem bibliotecas, somente os arquivos mínimos como /etc/passwd e /etc/hosts.

     O sistema operacional e toda a suite de compilação só foram usadas no primeiro estágio com nome de _build_. No segundo estágio, somente o binário foi copiado para a imagem.

    Esse procedimento com imagem _scratch_ é possível porque o _GO_ possui uma compilaçõ estática, isso é, não depende de bibliotecas. É possivel fazer algo semelhante para outras linguagens, como por exemplo _java_ onde no primeiro estágio _build_ temos a _JDK_ e no segundo estágio somente a _JRE_.
