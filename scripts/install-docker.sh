#!/bin/bash

set -e

echo "Обновление системы..."
apt-get update -y -qq > /dev/null 2>&1
apt-get upgrade -y -qq > /dev/null 2>&1
echo "Обновление системы завершено"

echo "Установка curl..."
apt-get install -y -qq curl git > /dev/null 2>&1
echo "Готово"

echo "Установка docker..."
curl -fsSL https://get.docker.com -o get-docker.sh > /dev/null 2>&1
bash get-docker.sh > /dev/null 2>&1

if command -v docker > /dev/null 2>&1; then
    echo -n "Готово"
else
    echo -n "Ошибка"
    echo "Docker не был установлен"
    exit 1
fi

usermod -aG docker vagrant