# LABS Unidade 1

Utilize o [Docker Cheat-sheet](https://docs.docker.com/get-started/docker_cheatsheet.pdf) para ajudar com os comandos:

## LAB 1

**Objetivo**: Executar um container utilizando todos os comandos do ciclo de vida

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

**Objetivo**: interação com o container em execução

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

**Objetivo:** Verificar a separação do sistema de arquivos do container para o host

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
**Objetivo:** Utilizando rede no container
1. Criando um container com uma imagem nginx. A imagem com o nome nginx puro, ira utilizar uma imagem do hub.docker.com, sem namespace e o tag será o default _latest_.
   Parâmetro -d inicia o container desanexado do console do docker client. A imagem ser
```bash
$ docker run –d --name mynginx nginx
$ docker ps
```
  Você verá algo semelhante a 
```bash
CONTAINER ID  IMAGE  COMMAND                        CREATED             STATUS                 PORTS              NAMES
fdd7c763a066  nginx     "/docker-entrypoint.…"   11 minutes ago   Up 11 minutes   80/tcp 
```
2.  Veja que o container declara servir algo na porta 80/tcp. vamos tentar aceçá-lo
```bash
$ curl http://localhost
```
Como vc pode ver não está acessível. O motivo é que apesar de exposta a porta, ela não está _publicada_ para o host

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


## LAB 7
**Objetivo:** Criar uma imagem e executar um container a partir da imagem criada
1. Criando uma imagem docker
   
```bash
$ cd labs/lab7
$ cat Dockerfile
# -t <imagename>:<version>
$ docker build . -t py-web:01
```
2. Executando a imagem

```bash
$ docker run --rm –d --publish 8080:80 --name my-py-web-01 py-web:01
$ curl http://localhost:8080
$ docker stop my-py-web-01
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

2. Construindo a imagem com tag 02

```shell
$ docker build . -t py-web:02
```

3. Executando e testando a conexão:

```bash
$ docker run –d --publish 8080:8080 --rm --name my-py-web-02 py-web:02
$ curl http://localhost:8080
$ docker stop my-py-web-02
```

4. Depois de verificar a falha, edite o Dockerfile novamente e altere a diretiva EXPOSE e reconstrua a imagem

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
$ docker docker build . -t py-web:03
```
5. Execute a imagem e teste

```bash
$ docker run –d --publish 8080:8080 py-web:03
$ curl http://localhost:8080
```

##  LAB 8
**Objetivo:** Utilizando uma imagem a partir de outra e um repositório remoto

1. Liste a imagem do lab7 e vc vai econtrar algo como abaixo

```bash
$ docker image ls

REPOSITORY    TAG       IMAGE ID       CREATED         SIZE
py-web        03        fe2b3c002799   2 hours ago     160MB
```
2. Crie outro tag para a imagem
```bash
$ docker tag -t py-web:04 py-web:03
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
$ docker tag mynamespace/py-web:04 py-web
$ docker push
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
$ docker rm py-web:04
$ docker rm mynamespace/py-web:04
$ docker image ls
```

5. Edite o Dockerfile para utilizar a imagem do docker hub e recrie a imagem
```Dockerfile
FROM fams/py-web:04
COPY ./www /var/www/html
```

```bash
$ docker build . –t lab8:02
$ docker image ls

REPOSITORY    TAG       IMAGE ID       CREATED         SIZE
mynamespace/py-web   04        fe2b3c002799   1 hours ago     160MB
lab8:01       02        d2c94e258dcb   1 minute ago    160MB
```

Perceba que vc foi capaz de recriar a imagem usando a fonte do repositório

## LAB 9
**Objetivo:** Otimizando o build 

