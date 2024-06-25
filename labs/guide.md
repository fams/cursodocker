# LABS Unidade 1

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
    # Executar  um container co --rm, solicitando remoção apos o fim da execução
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
    # Criando um arquivo non /tmp do sistema host
    $ touch /tmp/hostfile.txt
    # Executar um container
    $ docker run -it bash
    # Verificar a não existência no sistema rais
    bash-5.2$ ls /tmp
    ```

2. Criar um arquivo no container e verificar sua existência no host

    ```bash
    # Criar um arquivo no /tmp do container
    bash-5.2$# touch /tmp/containerfile.txt
    # Ctrl+P Ctrl+Q (dettash)
    
    # Verificar a inexistência do arquivo containerfile.txt no nost
    $ ls /tmp
    ```
