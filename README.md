# MonitoringBot

## 1. Как подготовить переменные окружения

Перед сборкой и запуском проекта создайте файл `.env` на основе шаблона `.env.example`.  
Для этого выполните:

```bash
cp config/.env.example config/.env
```

Отредактируйте значения в файле `config/.env` в соответствии с вашими настройками БД и Telegram-бота.

## 2. Как собрать проект

Для сборки проекта используйте следующую команду:

``` bash
make build
```

## 3. Как запустить проект

Для запуска проекта выполните:

``` bash
make start-dev
```

Или используйте команду для запуска через Docker Compose (если предоставлен docker-compose.yml):

``` bash
docker compose up --build
```

## 4. Как создать миграцию

Чтобы создать новую миграцию с помощью Diesel внутри Docker-контейнера, используйте:

``` bash
docker compose -f docker-compose.yml run -u root --rm web diesel migration generate --diff-schema
```

Можно заменить параметры по необходимости, например, добавить имя миграции.

## 5. Как применить миграции

Для применения миграций используйте команду:

``` bash
docker compose -f docker-compose.yml run -u root --rm web diesel migration run
```
