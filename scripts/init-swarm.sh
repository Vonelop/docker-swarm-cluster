#!/bin/bash

set -e

if [ ! -d /app ]; then
    echo "Нет папки проекта /app"
    exit 1
fi

if docker info | grep -q "Swarm: active" > /dev/null 2>&1; then
    echo "Swarm инициализирован и работает"
    echo "Текущий статус Swarm:"
    docker node ls
    exit 0
fi

if docker swarm init --advertise-addr 192.168.56.10 > /dev/null 2>&1; then
    echo "Кластер инициализирован"
else
    echo "Ошибка при инициализации swarm кластера"
    exit 1
fi

if docker network create -d overlay app-network > /dev/null 2>&1; then
    echo "Сеть app-network создана"
    docker swarm join-token -q worker > /app/tmp/swarm-worker-token
    echo "Токен сохранен"
else
    echo "Ошибка создания сети app-network"
fi  