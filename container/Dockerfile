FROM ubuntu:latest

# Обновление пакетов и установка NASM и binutils (включает ld)
RUN apt-get update && \
    apt-get install -y nasm binutils && \
    rm -rf /var/lib/apt/lists/*

# Объявление тома для подключения папки с кодом
VOLUME /mnt/code

# Установка рабочей директории
WORKDIR /mnt/code

# Запуск интерактивной оболочки bash
CMD ["/bin/bash"]