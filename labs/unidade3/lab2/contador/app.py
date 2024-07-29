from flask import Flask, jsonify
import socket
import redis
import os

app = Flask(__name__)

# Obtendo configurações do Redis a partir de variáveis de ambiente
redis_host = os.getenv('REDIS_HOST', 'localhost')
redis_port = int(os.getenv('REDIS_PORT', 6379))
redis_password = os.getenv('REDIS_PASSWORD', '')

# Conectando ao Redis
r = redis.StrictRedis(host=redis_host, port=redis_port,
                      password=redis_password, decode_responses=True)


@app.route('/')
def home():
    # Obtendo o hostname
    hostname = socket.gethostname()

    # Incrementando o contador no Redis
    total_visits = r.incr('counter')

    # Retornando o hostname e o total de visitas
    return jsonify(hostname=hostname, total_visits=total_visits)


if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)