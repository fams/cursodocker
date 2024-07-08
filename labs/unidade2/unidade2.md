# LABS Unidade 2

Utilize o [Docker Cheat-sheet](https://docs.docker.com/get-started/docker_cheatsheet.pdf) para ajudar com os comandos:

Você vai precisar de uma máquina Linux para esses LABS.

## LAB 1

### Objetivo: Entender o uso do chroot e pivot_root

1. Inicialize um diretório com o conteúdo de um sistema base linux
   1. Se você estiver em uma distribuição baseada em debian, como o ubuntu, siga esses passos:

       ```bash
       sudo apt install debootstrap
       sudo debootstrap --variant=buildd --include=iputils-ping,python3,procps,net-tool,iproute2 --arch=i386 stable ./rootfs
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

2. Teste o funcionamento do chroot com o novo diretório

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

2. Execute o unshare criando um namespace de rede

    ```bash
    # Listando a tabela de rotas do host
    ip route list
    # Listando as conexões Existentes
    netstat -anp
    # executando um ping para a internet
    ping 8.8.8.8
    # Crie o namespace de rede
    unshare -npf --mount-proc=/proc /bin/bash
    # Listando a tabela de rotas do contêiner
    ip route list
    # Listando as conexões exitestentes
    netstat -anp
    # executando um ping para a internet
    ping 8.8.8.8
    # Saindo do namespace
    exit
    ```

3. Criando um recurso IPCS

    ```bash
    # Crie uma área de memória compartilhada
    ipcmk --shmem 4096
    # Liste os recursos
    ipcs
    # crie a namescpace de IPC
    unshare -ipf --mount-proc=proc /bin/bash
    # Liste os recursos na namespace
    ipcs
    # Saindo da namespace
    ```

## lab 4

### Objetivo: Demonstrar o uso da comunicação entre namespaces

Você precisará de dois terminais. O primeiro na namnespace de rede. o Segundo para executar os comandos

1. _No Terminal 2_, cCrie uma ancora de filesystem para suas namespaces.

   ```bash
   # como root
    sudo su -
    mkdir -p /namespaces/001
    touch /namespaces/001/{net,ipc,mount,pid}
    ```

2. _No Terminal 1_, entre na namespace de rede isolada

   ```bash
    unshare --net=/namespaces/001 /bin/bash
    # verifique as interfaces disponíveis
    ip link ls
    # carregar a interface lo
    ip link set dev lo up
   ```

3. _No Terminal 2_, configurar a rede no namespace 001

   ```bash
    # Criar o par de vethX
    ip link add veth0 type veth peer name veth1
    # Atribuir a veth0 ao namespace
    ip link set veth0 netns /root/namespaces/net
    # Definir um ip para a rede
    ip addr add 10.23.0.1/30 dev veth1
    # Carregar a interface 
    ip link set dev veth1 up
   ```

4. _No Terminal 1_, configurar a rede

   ```bash
    # Atribuir ip à interface
    ip addr add 10.23.0.2/30 dev veth0
    # inicializar a interface
    ip link set veth0 up
    # Teste de rede 
    ping 10.23.0.1

   ```

## lab 5

### Objetivo: Demonstrar o uso de cgroups

1. Compilar o gastador de recursos

    ```bash
    docker run --rm -it -v .:/build golang
    cd src
    go build -o waste-resource
    ```

2. Descubra a versão do cgroup em uso

    ```bash
    $ mount |grep cgroup
     # Se o cgroup for v2, vc verá uma linha para o cgroup semelhante a abaixo
     cgroup2 on /sys/fs/cgroup type cgroup2 (rw,nosuid,nodev,noexec,relatime,nsdelegate,memory_recursiveprot)
     # Se for um cgroup v1 vera uma linha para cada control group, semelhante a abaixo
     tmpfs on /sys/fs/cgroup type tmpfs (rw,nosuid,nodev,noexec,relatime,mode=755)
     cgroup2 on /sys/fs/cgroup/unified type cgroup2 (rw,nosuid,nodev,noexec,relatime)
     cgroup on /sys/fs/cgroup/cpuset type cgroup (rw,nosuid,nodev,noexec,relatime,cpuset)
     cgroup on /sys/fs/cgroup/cpu type cgroup (rw,nosuid,nodev,noexec,relatime,cpu)
     cgroup on /sys/fs/cgroup/cpuacct type cgroup (rw,nosuid,nodev,noexec,relatime,cpuacct)
     cgroup on /sys/fs/cgroup/blkio type cgroup (rw,nosuid,nodev,noexec,relatime,blkio)
     cgroup on /sys/fs/cgroup/memory type cgroup (rw,nosuid,nodev,noexec,relatime,memory)
     cgroup on /sys/fs/cgroup/devices type cgroup (rw,nosuid,nodev,noexec,relatime,devices)
     cgroup on /sys/fs/cgroup/freezer type cgroup (rw,nosuid,nodev,noexec,relatime,freezer)
     cgroup on /sys/fs/cgroup/net_cls type cgroup (rw,nosuid,nodev,noexec,relatime,net_cls)
     cgroup on /sys/fs/cgroup/perf_event type cgroup (rw,nosuid,nodev,noexec,relatime,perf_event)
     cgroup on /sys/fs/cgroup/net_prio type cgroup (rw,nosuid,nodev,noexec,relatime,net_prio)
     cgroup on /sys/fs/cgroup/hugetlb type cgroup (rw,nosuid,nodev,noexec,relatime,hugetlb)
     cgroup on /sys/fs/cgroup/pids type cgroup (rw,nosuid,nodev,noexec,relatime,pids)
     cgroup on /sys/fs/cgroup/rdma type cgroup (rw,nosuid,nodev,noexec,relatime,rdma)
     cgroup on /sys/fs/cgroup/misc type cgroup (rw,nosuid,nodev,noexec,relatime,misc)
    ```

3. Criando um grupo para acomodar a memória limitada

    1. Usando cgroup v1

        ```bash
        # Va para diretório do cgroup de memória
        cd /sys/fs/cgroup/memory
        # crie um subdiretorio para representar o subgrupo de memória
        sudo mkdir grupo-0
        # entre no novo grupo e veja os controles com ls
        cd grupo-0
        ls
        # defina o limite de memória em 20 megas
        echo $((20 * 1024 * 1024 ))| sudo tee memory.limit_in_bytes
        # verifique o limite de memória
        cat memory.limit_in_bytes
        ```

    2. Usando o cgroup v2

       ```bash
        # Va para diretório do cgroup raiz
        cd /sys/fs/cgroup
        # crie um subdiretorio para representar o novo subgrupo 
        sudo mkdir grupo-0
        # entre no novo grupo e veja os controles com ls
        cd grupo-0
        ls
        # defina o limite de memória em 20 megas
        echo $((20 * 1024 * 1024 ))| sudo tee memory.max
        # verifique o limite de memória
        cat memory.max
       ```

4. Testando o limite de memória com o gastador de recursos

    **Método 1**. Adicionando manualmente a task no cgroup, você precisará de dois terminais no mesmo sistema

    1. Obtenha o PID do Terminal 1
       No terminal 1

       ```bash
        # vá para onde está o consumidor de memória
       cd labX
        # crie um novo shell para não limitar o atual
        bash 
        # obtenha o PID do shell utilizado
       echo $$
       ```

    2. No Teminal 2, adicione o PID do Terminal 1 no grupo-0

       1. Usando cgroup v1

          ```bash
          cd /sys/fs/cgroup/memory/grupo-0
          echo {PID} > tasks
          ```

       2. Usando cgroup v2

          ```bash
          cd /sys/fs/cgroup/grupo-0/
          echo {PID} > cgroup.procs
          ```

    3. No Terminal 1. Teste o limite de memória. O $? mostra a saída do último comando utilizado. o 137 é saída por oom-kill

       ```bash
        ./waste-resource -memory-hog 1
        echo $?
        ./waste-resource -memroy-hog 3
        echo $?
        # saia do processo limitado
        exit
       ```

5. Criar um grupo com limite de cpu de 20% de 1 core.
    O cpu é limitado fracionando-o no tempo. Para limitar o grupo em 20%, daremos a ele 20 a cada 100 milisegundos de tempo de cpu.
    A unidade mínima de alocação que o cgroups permite e trabalha é o microsegundo.
    Isso significa que daremos 20000 a cada 100000 microsegundos de CPU.

    1. Utilizando o cgroups v1

       ```bash
        cd /sys/fs/cgroup/cpu
        sudo mkdir grupo-0
        cd grupo-0
        echo 100000 | sudo tee cpu.cfs_period_us
        echo 20000 | sudo tee cpu.cfs_quota_us
       ```

    2. Utilizando o cgroups v2, o grupo já foi criado no lab anterior, iremos somente definir o limite

       ```bash
        cd /sys/fs/cgroup/grupo-0
        echo "20000 100000" | sudo tee cpu.max
       ```

6. Testando o limite de CPU com o gastador de recursos

    **Método 1**. Adicionando manualmente a task no cgroup, você precisará de dois terminais no mesmo sistema

    1. Obtenha o PID do Terminal 1
       No terminal 1

       ```bash
        # vá para onde está o consumidor de recursos
       cd labX
        # crie um novo shell para não limitar o atual
        bash 
        # obtenha o PID do shell utilizado
       echo $$
       ```

    2. No Teminal 2, adicione o PID do Terminal 1 no grupo-0

       1. Usando cgroup v1

          ```bash
          cd /sys/fs/cgroup/cpu/grupo-0
          echo {PID} > tasks
          ```

       2. Usando cgroup v2

          ```bash
          cd /sys/fs/cgroup/grupo-0/
          echo {PID} > cgroup.procs
          ```

    3. No Terminal 1. Teste o limite de cpu

       ```bash
        ./waste-resource -waste-cpu 1 &
        # Verifique o consumo com o comando top
        top
        # Saia do terminal limitado
        exit
       ```
