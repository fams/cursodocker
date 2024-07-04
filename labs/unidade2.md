# LABS Unidade 2

Utilize o [Docker Cheat-sheet](https://docs.docker.com/get-started/docker_cheatsheet.pdf) para ajudar com os comandos:

Você vai precisar de uma máquina Linux para esses LABS.

## LAB 1

### Objetivo: Entender o uso do chroot e pivot_root


1. Inicialize um diretório com o conteúdo de um sistema base linux
   1. Se você estiver em uma distribuição baseada em debian, como o ubuntu, siga esses passos:

       ```bash
       sudo apt install debootstrap
       sudo debootstrap --variant=buildd --arch=i386 stable ./rootfs
       ```

   2. Se estiver em uma distribuição baseada em rpm, como o fedora, siga os seguintes passos:

       ```bash
        sudo dnf -y \
        --installroot=$PWD/rootfs \
        --releasever=24 install \
        @development-tools \
        procps-ng \
        python3 \
        which \
        iproute \
        net-tools
       ```

2.  Teste o funcionamento do chroot com o novo diretório

    ```bash
    touch /tmp/host.txt
    touch rootfs/tmp/rootfs.txt
    sudo chroot rootfs

    hash -r
    ls /tmp/host.txt
    ls /tmp/rootfs.txt
    exit
    ls /tmp/host.txt
    ```

3. Executando o pivot_root
    ```bash
    # Crie um ponto de montagem para o container
    mkdir new_root
    # Crie uma namespace de mountpoints para ser usada daqui em diante
    sudo unshare -m
    # monte o rootfs para o novo mountpoint new_root
    mount --bind ./rootfs/ new_root
    # Verifique que o rootfs agora está montado no new_root
    ls new_root/tmp/rootfs.txt
    # crie um ponto de montagem para abrigar o atual root da máquina no novo namespace de montagem
    mkdir new_root/old_root
    # execute o pivot_root trocando os mount points raiz atual para old_root e movendo o raiz para new_root
    cd new_root
    pivot_root . old_root
    # Verifique que o / atual é o montado em rootfs
    ls /tmp/rootfs.txt
    # monte o /proc no novo namespace
    mount -t proc none /proc/
    # verifique que os pontos de montagem do sistema host ainda estão disponíveis
    mount
    # Remova a referência para os mount points do host
    umount -l /old_root
    # verifique o atual mtab
    mount
    ```

## lab 2

### Objetivo: Testar os namespaces de PID REDE e IPC

Continuando do anterior

1. Execute o unshare criando uma nova namespace de PID

    ```bash
    unshare -pf --mount-proc=/proc /bin/bash
    # execute o ps -ef para verificar a nova arvore de processos
    ps -ef
    ```
    
        
       
   