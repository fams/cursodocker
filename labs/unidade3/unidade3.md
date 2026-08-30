# Labs unidade 3

## Observação

**Lembre-se que o Docker Desktop possui o compose integrado ao comando docker, invocando-o com `docker compose`. Antigas instalações utilizarão o `docker-compose`

## Lab 1

### Objetivo: Aprender a usar Docker Compose para definir e gerenciar um ambiente multi-contêiner, incluindo a construção de imagens Docker personalizadas.

1. **Criar um Diretório para o Projeto:**
   - Crie um diretório para o seu projeto.

   ```bash
   mkdir lab1
   cd lab1
   ```

2. **Criar um Arquivo Dockerfile:**
   - Dentro do diretório do projeto, crie um arquivo `Dockerfile` para o serviço `web`:

   ```Dockerfile
   # Use a imagem base do Nginx
   FROM nginx:latest

   # Copie o conteúdo do diretório local 'html' para o diretório padrão do Nginx
   COPY html /usr/share/nginx/html
   ```

3. **Criar Conteúdo HTML:**
   - Crie um diretório `html` dentro do diretório do projeto e adicione um arquivo `index.html` com algum conteúdo.

   ```bash
   mkdir html
   echo "<h1>Bem vindo ao  Docker Compose com Build!</h1>" > html/index.html
   ```

4. **Criar um Arquivo Docker Compose:**
   - Dentro do diretório do projeto, crie um arquivo `docker-compose.yml` com o seguinte conteúdo:

   ```yaml
   version: '3.8'

   services:
     web:
       build: .
       ports:
         - "8080:80"
       networks:
         - webnet

     redis:
       image: redis:latest
       ports:
         - "6379:6379"
       networks:
         - webnet

     db:
       image: mysql:5.7
       environment:
         MYSQL_ROOT_PASSWORD: exemplo
       ports:
         - "3306:3306"
       networks:
         - webnet

   networks:
     webnet:
   ```

5. **Construir e Executar os Serviços com Docker Compose:**
   - No diretório do projeto, use o Docker Compose para construir a imagem personalizada e iniciar os serviços definidos no arquivo `docker-compose.yml`.

   ```bash
   docker compose up --build -d
   ```

6. **Verificar os Serviços:**
   - Liste os contêineres em execução para verificar se os serviços `web`, `redis` e `db` estão em execução.

   ```bash
   docker-compose ps
   ```

7. **Acessar o Serviço Web:**
   - Abra o navegador e acesse `http://localhost:8080` para ver o conteúdo do arquivo `index.html`.

8. **Interagir com o Serviço Redis:**
   - Conecte-se ao contêiner `redis` e execute alguns comandos Redis.

   ```bash
   $ docker-compose exec redis redis-cli
   ```

   No prompt do Redis:

   ```redis
   $ set chave "valor"
   $ get chave
   $ exit
   ```

9. **Adicionar um Banco de Dados (MySQL):**
    - Verifique a conexão ao banco de dados MySQL criado.

    ```bash
    $ docker-compose exec db mysql -u root -p
    ```

    O comando pede a senha — digite `exemplo`.

    No prompt do MySQL:

    ```mysql
    $ SHOW DATABASES;
    ```

10. **Parar e Remover os Serviços:**
    - Pare e remova os serviços e os volumes criados.

    ```bash
    docker-compose down --volumes
    ```

## Lab 2

### Objetivo: Usar dependências de serviços e escalar os containers

1. **Copie o Dockerfile, o compose e o diretório html do lab1 para o diretório do lab2**

   ```bash
    cd lab2
    cp -R ../lab1/{Dockerfile,html,docker-compose.yml} .
    ```

2. **Modifique o Dockerfile do serviço web para adicionar a configuração nginx provida no lab2**

   ```Dockerfile
    # Use a imagem base do Nginx
    FROM nginx:latest
    # Copie o conteúdo do diretório local 'html' para o diretório padrão do Nginx
    COPY html /usr/share/nginx/html
    # config default modificada
    COPY nginx.conf /etc/nginx/conf.d/default.conf
    ```

3. **Modifique o docker-compose.yml para adiconar o serviço contador provido pelo lab2 e adicionar a referência no web**

    ```yaml
    ...
      web:
          build: .
          ports:
             - "8080:80"
          networks:
            - webnet
          # Dependência do contador adicionada
          depends_on:
            - flask

      flask:
          build: contador # diretório onde está o serviço contador
          environment:
            - REDIS_HOST=redis # <- Note o uso de variáveis de ambiente a serem interpretadas pelo serviço
            - REDIS_PORT=6379
          depends_on:
            - redis
          ports:
            - "5000"
          networks: # Adicionado o serviço na mesma rede dos outros
            - webnet
        ...
    ```

4. **Iniciar o novo compose:**

    ```bash
    docker compose up --build
    ```

5. **Acesse os serviços pela porta 8080 no seu browser ou pelo curl**

   ```bash
   curl http://localhost:8080
   curl http://localhost:8080/contador #repita várias vezes
   ```

6. **Escalar o Serviço flask:**
   - Escale o serviço `flask` para ter 3 instâncias.

   ```bash
   docker-compose up -d --scale flask=3
   ```

7. **Verificar as Instâncias:**
   - Liste os contêineres para verificar as 3 instâncias do serviço `flask`.

   ```bash
   docker-compose ps
   ```

8. **Verifique se o serviço web está balanceando a carga entre os flask**

   ```bash
   curl http://localhost:8080/contador #repita várias vezes
   ```

9. **Reinicie o serviço web e repita o teste**

   ```bash
   docker compose restart web
   curl http://localhost:8080/contador #repita várias vezes
   ```

## Lab 3

### Objetivo: Usar healthcheck e dependência condicional para garantir que o serviço web só suba depois que o banco estiver realmente pronto

1. **Copie os arquivos do lab2 para o lab3**

   ```bash
   mkdir lab3
   cp -R lab2/{Dockerfile,html,contador,compose.yml} lab3/
   cd lab3
   ```

2. **Adicione um healthcheck ao serviço `db`**
   - `depends_on: - db` sem condição só espera o container *iniciar*, não o MySQL aceitar conexões. Adicione:

   ```yaml
   db:
     image: mysql:5.7
     environment:
       MYSQL_ROOT_PASSWORD: exemplo
     healthcheck:
       test: ["CMD", "mysqladmin", "ping", "-h", "localhost", "-uroot", "-pexemplo"]
       interval: 5s
       timeout: 3s
       retries: 10
     ports:
       - "3306:3306"
     networks:
       - webnet
   ```

3. **Torne a dependência do `flask` condicional à saúde do `db`**

   ```yaml
   flask:
     build: contador
     environment:
       - REDIS_HOST=redis
       - REDIS_PORT=6379
     depends_on:
       redis:
         condition: service_started
       db:
         condition: service_healthy
     ...
   ```

4. **Suba o ambiente e observe o status**

   ```bash
   docker compose up -d
   docker compose ps
   # Observe a coluna STATUS do db passar de "starting" para "healthy"
   # antes do flask ser criado
   ```

5. **Limpar o ambiente**

   ```bash
   docker compose down --volumes
   ```

## Lab 4

### Objetivo: Externalizar configuração sensível com `.env` e `env_file`

1. **Copie o lab3 para o lab4**

   ```bash
   cp -R ../lab3 ../lab4 && cd ../lab4
   ```

2. **Crie um arquivo `.env` na raiz do projeto**

   ```bash
   cat <<EOF > .env
   MYSQL_ROOT_PASSWORD=exemplo
   REDIS_HOST=redis
   REDIS_PORT=6379
   EOF
   ```

3. **Use interpolação no `compose.yml`, referenciando as variáveis do `.env`**

   ```yaml
   db:
     image: mysql:5.7
     environment:
       MYSQL_ROOT_PASSWORD: ${MYSQL_ROOT_PASSWORD}
   ```

4. **Compare com `env_file`, movendo as variáveis do `flask` para um arquivo dedicado**

   ```bash
   cat <<EOF > contador/flask.env
   REDIS_HOST=redis
   REDIS_PORT=6379
   EOF
   ```

   ```yaml
   flask:
     build: contador
     env_file:
       - contador/flask.env
   ```

5. **Suba o ambiente e confira que as variáveis chegaram aos containers**

   ```bash
   docker compose up -d
   docker compose exec flask env | grep REDIS
   docker compose exec db env | grep MYSQL_ROOT_PASSWORD
   ```

6. **Teste um valor default com `${VAR:-default}`**
   - Remova `MYSQL_ROOT_PASSWORD` do `.env` e ajuste o compose para `${MYSQL_ROOT_PASSWORD:-senha-padrao}`. Suba novamente e confira qual senha foi usada.

7. **Limpar o ambiente**

   ```bash
   docker compose down --volumes
   ```

## Lab 5

### Objetivo: Usar arquivos de override para separar configuração de desenvolvimento e produção

1. **Copie o lab4 para o lab5**

   ```bash
   cp -R ../lab4 ../lab5 && cd ../lab5
   ```

2. **Renomeie o compose base e remova o que for específico de ambiente**
   - Mantenha em `compose.yml` só o que é comum a todos os ambientes (build, rede, dependências).

3. **Crie `compose.override.yml` para desenvolvimento** (é lido automaticamente junto ao `compose.yml`)

   ```yaml
   services:
     web:
       ports:
         - "8080:80"
       volumes:
         - ./html:/usr/share/nginx/html
     db:
       ports:
         - "3306:3306"
   ```

4. **Crie `compose.prod.yml` para produção**

   ```yaml
   services:
     web:
       restart: always
     flask:
       restart: always
     db:
       restart: always
       # Em produção não expomos a porta do banco para o host
   ```

5. **Suba em modo desenvolvimento (override automático)**

   ```bash
   docker compose up -d
   docker compose config  # mostra o resultado do merge dos arquivos
   ```

6. **Suba em modo produção, combinando explicitamente os arquivos**

   ```bash
   docker compose -f compose.yml -f compose.prod.yml up -d
   docker compose -f compose.yml -f compose.prod.yml config
   ```

   Repare que a porta do `db` não aparece publicada nesse modo, e os serviços têm `restart: always`.

7. **Limpar o ambiente**

   ```bash
   docker compose down --volumes
   ```

## Lab 6

### Objetivo: Isolar serviços auxiliares (debug/seed) com `profiles`

1. **Copie o lab5 para o lab6**

   ```bash
   cp -R ../lab5 ../lab6 && cd ../lab6
   ```

2. **Adicione um serviço `adminer` marcado com o profile `debug`**

   ```yaml
   adminer:
     image: adminer
     ports:
       - "8081:8080"
     profiles:
       - debug
     networks:
       - webnet
   ```

3. **Suba o ambiente normalmente e confira que o `adminer` não sobe**

   ```bash
   docker compose up -d
   docker compose ps
   ```

4. **Suba novamente habilitando o profile**

   ```bash
   docker compose --profile debug up -d
   docker compose ps
   # o adminer agora aparece
   curl http://localhost:8081
   ```

5. **Limpar o ambiente**

   ```bash
   docker compose --profile debug down --volumes
   ```

## Lab 7

### Objetivo: Usar `secrets` do Compose para evitar credenciais em texto puro nas variáveis de ambiente

1. **Copie o lab6 para o lab7**

   ```bash
   cp -R ../lab6 ../lab7 && cd ../lab7
   ```

2. **Compare o problema**: liste o processo do `db` e note a senha visível

   ```bash
   docker compose up -d
   docker compose exec db env | grep MYSQL_ROOT_PASSWORD
   docker inspect $(docker compose ps -q db) | grep -A3 Env
   docker compose down --volumes
   ```

3. **Crie o arquivo de secret local**

   ```bash
   mkdir -p secrets
   echo "exemplo" > secrets/db_root_password.txt
   ```

4. **Declare o secret no `compose.yml`**

   ```yaml
   secrets:
     db_root_password:
       file: ./secrets/db_root_password.txt

   services:
     db:
       image: mysql:5.7
       environment:
         MYSQL_ROOT_PASSWORD_FILE: /run/secrets/db_root_password
       secrets:
         - db_root_password
   ```

5. **Suba o ambiente e verifique onde o segredo fica montado**

   ```bash
   docker compose up -d
   docker compose exec db cat /run/secrets/db_root_password
   docker inspect $(docker compose ps -q db) | grep -A3 Env
   # A senha não aparece mais como variável de ambiente
   ```

6. **Limpar o ambiente**

   ```bash
   docker compose down --volumes
   ```

## Lab 8

### Objetivo: Comparar as políticas de restart (`no`, `on-failure`, `always`, `unless-stopped`)

1. **Copie o lab7 para o lab8**

   ```bash
   cp -R ../lab7 ../lab8 && cd ../lab8
   ```

2. **Configure o `flask` sem política de restart (default `no`)**

   ```bash
   docker compose up -d
   docker compose exec flask sh -c "kill 1"
   sleep 5
   docker compose ps flask  # permanece parado
   ```

   A imagem `python:3.9-slim` usada pelo `flask` não tem o binário `kill` — por isso o comando roda via `sh -c`, usando o `kill` embutido do shell. Rodar `docker compose exec flask kill 1` diretamente falha com `executable file not found in $PATH`.

3. **Mude para `on-failure` e derrube o processo com um código de erro**

   ```yaml
   flask:
     ...
     restart: on-failure
   ```

   ```bash
   docker compose up -d
   docker compose exec flask sh -c "kill -9 1"
   sleep 5
   docker compose ps flask  # foi reiniciado
   ```

   Use sempre `docker compose exec` (executa dentro do container) e não `docker kill`/`docker stop` do host para este teste: o Docker trata uma parada feita pelo host como intencional e **não** aciona a política de restart, mesmo com `on-failure`.

4. **Mude para `always` e pare o container manualmente**

   ```yaml
   flask:
     ...
     restart: always
   ```

   ```bash
   docker compose up -d
   docker stop $(docker compose ps -q flask)
   sleep 5
   docker compose ps -a flask  # continua parado (Exited)
   ```

   Mesmo com `restart: always`, um `docker stop`/`docker kill` feito pelo host **não** é revertido automaticamente — o Docker trata isso como uma parada intencional. A política de restart só entra em ação quando o processo principal do container termina sozinho (crash ou saída), ou quando o daemon do Docker é reiniciado.

5. **Compare com o processo terminando sozinho, que `always` reinicia mesmo sem erro**

   ```bash
   docker start $(docker compose ps -aq flask)
   sleep 3
   docker compose exec flask sh -c "kill 1"
   sleep 5
   docker compose ps flask  # foi reiniciado, mesmo com saída "normal" (sem -9)
   ```

6. **Mude para `unless-stopped` e repita o teste, agora reiniciando o daemon do Docker (ou a VM)**
   - Diferente de `always`, um container `unless-stopped` que foi parado manualmente **não** volta a subir após um restart do Docker.

7. **Limpar o ambiente**

   ```bash
   docker compose down --volumes
   ```

