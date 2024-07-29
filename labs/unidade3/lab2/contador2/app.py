from flask import Flask, jsonify
import socket
import redis
import time
import os

app = Flask(__name__)

# Obtendo configurações do Redis a partir de variáveis de ambiente
redis_host = os.getenv('REDIS_HOST', 'localhost')
redis_port = int(os.getenv('REDIS_PORT', 6379))
redis_password = os.getenv('REDIS_PASSWORD', '')
max_requests = os.getenv('MAX_REQUESTS', '20')

# Conectando ao Redis
r = redis.StrictRedis(host=redis_host, port=redis_port,
                      password=redis_password, decode_responses=True)

start_time = time.ctime()
local_counts = 0


@app.route('/health')
def health():
    return jsonify(status='UP')


@app.route('/')
def home():
    global local_counts
    # Obtendo o hostname
    hostname = socket.gethostname()

    local_counts += 1
    if local_counts > int(max_requests):
        os._exit(1)
    # Incrementando o contador no Redis
    total_visits = r.incr('counter')

    # Retornando o hostname e o total de visitas
    return jsonify(hostname=hostname, start_time=start_time,
                   local_counts=local_counts, total_visits=total_visits)


if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)