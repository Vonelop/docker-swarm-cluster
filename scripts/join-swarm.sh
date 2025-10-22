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

if [ -f /app/tmp/swarm-worker-token ]; then
    SWARM_TOKEN=$(cat /app/tmp/swarm-worker-token)
else
    echo "Не найден файл с Swarm токеном"
    exit 1
fi

if docker swarm join --token $SWARM_TOKEN 192.168.56.10:2377 > /dev/null 2>&1; then
    echo "Виртуальная машина $(hostname) присоединена к кластеру"
else
    echo "Ошибка при инициализации swarm кластера"
fi