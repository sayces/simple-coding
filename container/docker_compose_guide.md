### Что такое Docker Compose и зачем он нужен

Docker Compose — это инструмент для определения и запуска многоконтейнерных приложений Docker с помощью простого YAML-файла. Он упрощает управление несколькими контейнерами, сетями и томами, делая разработку и развертывание более удобными. Исследования показывают, что он особенно полезен для локальной разработки, где нужно быстро поднимать стек сервисов, хотя для production рекомендуется осторожность с настройками.

**Ключевые моменты:**

- **Цель**: Оркестрация нескольких контейнеров как единого приложения; идеален для микросервисов или приложений с зависимостями (например, веб-сервер + база данных).
- **Преимущества**: Упрощает команды (вместо множества `docker run` — один `docker compose up`), обеспечивает воспроизводимость и масштабируемость.
- **Когда использовать**: Для проектов с одним контейнером (как в вашем примере с asm-study) он добавляет удобство, но особенно полезен при расширении до нескольких сервисов. Не обязателен для простых случаев, но рекомендуется для командной работы.
- **Ограничения**: Не предназначен для оркестрации в кластерах (для этого — Kubernetes); в production учитывайте безопасность и обновления.

#### Установка Docker Compose

Docker Compose входит в Docker Desktop для Windows/Mac (установите с https://www.docker.com/products/docker-desktop/). Для Linux/Ubuntu: `sudo apt install docker-compose-plugin` или скачайте с GitHub (https://github.com/docker/compose). Проверьте: `docker compose version`.

#### Создание файла docker-compose.yml

Создайте файл `docker-compose.yml` (или `compose.yaml`) в директории с Dockerfile. Для вашего примера asm-study (один сервис с томом, ресурсами):

```yaml
version: "3.8" # Рекомендуемая версия для совместимости
services:
  asm-study:
    build: . # Строит образ из Dockerfile в текущей директории
    image: asm-study-image # Имя образа
    container_name: asm-study # Имя контейнера
    volumes:
      - "C:/Users/sayce/Desktop/study/assembly/vols:/mnt/code" # Подключение тома для редактирования в VS Code
    mem_limit: 4g # Ограничение памяти
    cpus: 1 # Ограничение CPU
    stdin_open: true # Для интерактивности
    tty: true # Для терминала
```

Это определяет сервис `asm-study`, строит из вашего Dockerfile, подключает том и задает ресурсы.

#### Сборка и запуск

- **Сборка**: `docker compose build` — строит образ(ы) из Dockerfile.
- **Запуск**: `docker compose up` — запускает контейнеры (в foreground; добавьте `-d` для background). Для вашего примера: это эквивалентно `docker run` с флагами, но проще.
- **Остановка**: `docker compose down` — останавливает и удаляет контейнеры (сохраняет тома).
- **Другие команды**: `docker compose ps` (статус), `docker compose logs` (логи), `docker compose exec asm-study /bin/bash` (вход в контейнер).

В вашем случае после `docker compose up` вы окажетесь в интерактивной оболочке bash для работы с ассемблером.

---

Docker Compose представляет собой мощный инструмент от Docker, предназначенный для упрощения работы с многоконтейнерными приложениями. В отличие от базового Docker, где каждый контейнер управляется отдельными командами вроде `docker build` и `docker run`, Compose позволяет описать весь стек услуг (services), сетей (networks) и томов (volumes) в одном декларативном YAML-файле. Это делает его незаменимым для разработчиков, тестировщиков и DevOps-специалистов, стремящихся к воспроизводимым окружениям. Согласно официальной документации, Compose фокусируется на локальной разработке и тестировании, хотя его можно адаптировать для production с дополнительными настройками, такими как секреты и внешние оркестраторы. В контексте вашего примера с контейнером для изучения ассемблера (asm-study), Compose может преобразовать одиночный контейнер в масштабируемую структуру, добавив, например, сервис для отладки или базы данных, если проект вырастет.

### Определение и назначение Docker Compose

Docker Compose — это CLI-инструмент, интегрированный в Docker CLI (начиная с версии 1.27 как плагин `docker compose`). Его основная цель — автоматизировать запуск и управление несколькими контейнерами как единым приложением. Вместо ручного создания сетей, томов и контейнеров, вы определяете конфигурацию в файле `docker-compose.yml`, и Compose обрабатывает остальное: создает сеть по умолчанию, запускает сервисы в правильном порядке (учитывая зависимости) и обеспечивает коммуникацию между ними. Например, в типичном веб-приложении Compose может запустить контейнер с Node.js для backend, Redis для кэша и Nginx для фронтенда — все из одного файла.

Сравнивая с plain Docker: базовый Docker подходит для одиночных контейнеров, как в вашем исходном `docker run --name asm-study ...`. Compose добавляет уровень абстракции, делая код инфраструктуры (IaC) более читаемым и переносимым. Он особенно полезен в сценариях, где:

- Несколько сервисов зависят друг от друга (например, приложение + база данных).
- Нужно масштабирование (scaling) сервисов, как `docker compose up --scale web=3`.
- Локальная разработка с горячей перезагрузкой (hot reload) через Compose Watch.

Однако Compose не предназначен для крупных продакшн-кластеров — для этого лучше Swarm или Kubernetes. В production рекомендуется использовать `docker compose up --build` с переменными окружения для секретов, избегать root-пользователей в контейнерах и мониторить ресурсы.

### Установка и базовая настройка

Установка проста и зависит от платформы. На Windows и Mac Compose входит в Docker Desktop — скачайте и установите с официального сайта (https://www.docker.com/products/docker-desktop/). Для Linux (например, Ubuntu) используйте пакетный менеджер: `sudo apt update && sudo apt install docker-compose-plugin`. Альтернатива — скачать бинарник с GitHub: `sudo curl -L "https://github.com/docker/compose/releases/download/v2.29.1/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose && sudo chmod +x /usr/local/bin/docker-compose`. После установки проверьте версию: `docker compose version` — должна быть не ниже v2 для современных фич.

Для вашего примера с asm-study (Ubuntu-based контейнер с NASM/ld), убедитесь, что Docker установлен, и создайте проектную директорию с Dockerfile и `docker-compose.yml`.

### Структура файла docker-compose.yml

Файл Compose — это YAML с топ-уровневыми ключами: `version` (рекомендуется '3.8' для совместимости), `services` (основной раздел для контейнеров), `networks`, `volumes` и `configs/secrets` для продвинутых настроек. Каждый сервис в `services` может включать:

- `build: .` — путь к Dockerfile для сборки.
- `image: имя` — готовый образ из Docker Hub.
- `ports: ["8000:5000"]` — маппинг портов (host:container).
- `volumes: ["./host/path:/container/path"]` — подключение томов.
- `environment: {VAR: value}` — переменные окружения.
- `depends_on: [другой_сервис]` — порядок запуска.
- `mem_limit: 4g`, `cpus: 1` — ограничения ресурсов (как в вашем случае).

Для вашего asm-study примера расширенный файл может выглядеть так, если добавить сервис для отладки (например, с GDB в отдельном контейнере):

```yaml
version: "3.8"
services:
  asm-study:
    build:
      context: . # Директория с Dockerfile
      dockerfile: Dockerfile
    image: asm-study-image
    container_name: asm-study
    volumes:
      - "C:/Users/sayce/Desktop/study/assembly/vols:/mnt/code"
    mem_limit: 4g
    cpus: 1
    stdin_open: true
    tty: true
    develop: # Для разработки
      watch:
        - action: sync
          path: .
          target: /mnt/code
  debugger: # Дополнительный сервис для отладки
    image: ubuntu:latest
    command: /bin/bash
    volumes:
      - "C:/Users/sayce/Desktop/study/assembly/vols:/mnt/code"
    depends_on:
      - asm-study
```

Это позволяет синхронизировать изменения в коде без перезапуска. Если проект большой, разделите на несколько файлов: `docker-compose.yml` для основных сервисов и `infra.yml` для инфраструктуры, с `include: - infra.yml`.

| Ключ в YAML      | Описание                    | Пример для asm-study               |
| ---------------- | --------------------------- | ---------------------------------- |
| version          | Версия спецификации Compose | '3.8'                              |
| services         | Определение контейнеров     | asm-study: {build: .}              |
| build            | Параметры сборки            | context: ., dockerfile: Dockerfile |
| volumes          | Подключение директорий      | - "C:/path:/mnt/code"              |
| mem_limit / cpus | Ограничения ресурсов        | 4g / 1                             |
| develop.watch    | Горячая перезагрузка        | sync файлов для dev                |

### Сборка, запуск и управление

Сборка начинается с `docker compose build` — Compose читает YAML, находит `build` и использует ваш Dockerfile для создания образов. Для asm-study это эквивалентно `docker build -t asm-study-image .`, но автоматизировано.

Запуск: `docker compose up` создает сеть, тома, тянет образы (если не build) и запускает контейнеры. В вашем случае: контейнер asm-study стартует с bash, том подключен для VS Code. Добавьте `--build` для пересборки: `docker compose up --build`. Для фона: `docker compose up -d`. Чтобы войти: `docker compose exec asm-study /bin/bash`.

Остановка: `docker compose stop` (пауза) или `docker compose down` (полное удаление, кроме томов). Для очистки: `docker compose down -v` (удаляет тома).

Другие команды:

- `docker compose ps` — список контейнеров.
- `docker compose logs -f` — логи в реальном времени.
- `docker compose config` — валидация YAML.
- `docker compose pull` — обновление образов.

В production: используйте `docker compose up -d --no-deps --build` для обновлений без даунтайма, и интегрируйте с CI/CD (GitHub Actions).

### Лучшие практики и продвинутые аспекты

- **Безопасность**: Избегайте root в контейнерах (используйте `user: uid`), храните секреты в `secrets` вместо environment.
- **Масштабирование**: `docker compose up --scale asm-study=2` для нескольких инстансов, но для реального scaling — Swarm.
- **Сети и тома**: По умолчанию Compose создает сеть; явно определяйте `networks: default: {}` для кастомизации.
- **Переменные**: Используйте `.env` файл для переменных: `environment: - VAR=${ENV_VAR}`.
- **Интеграция с инструментами**: В VS Code расширение Docker позволяет запускать Compose из IDE. Для игр/мультимедиа (как в некоторых библиях) или ML (torch) — добавляйте сервисы с GPU: `deploy: resources: reservations: devices: [{driver: nvidia, count: 1}]`.
- **Общие ошибки**: Неправильные пути в volumes (на Windows используйте `/c/path`), конфликты портов, забытые `version`. Всегда проверяйте логи.
- **Альтернативы**: Для простых случаев — plain Docker; для сложных — Kubernetes или Podman Compose.

В вашем asm-study сценарии Compose позволит легко добавить сервис для тестирования (например, с Valgrind) или автоматизировать сборку в CI. Общий размер стека растет минимально, но удобство возрастает exponentially.
