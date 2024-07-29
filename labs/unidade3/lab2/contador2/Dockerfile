# Use uma imagem base oficial do Python
FROM python:3.9-slim

# Define o diretório de trabalho
WORKDIR /app

# Instala o curl para teste de healthcheck
RUN apt update && apt install -y curl

# Copia os arquivos requirements.txt e app.py para o diretório de trabalho
COPY requirements.txt requirements.txt
COPY app.py app.py

# Instala as dependências necessárias
RUN pip install --no-cache-dir -r requirements.txt

# Define a variável de ambiente para que o Flask não use o modo debug
ENV FLASK_ENV=production

# Expõe a porta em que o Flask estará rodando
EXPOSE 5000

# Define o comando padrão para rodar a aplicação Flask
CMD ["python", "app.py"]
