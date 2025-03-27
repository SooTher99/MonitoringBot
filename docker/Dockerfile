FROM rust:1.85-slim-bullseye AS developer

# Устанавливаем необходимые зависимости
RUN apt-get update && apt-get install -y --no-install-recommends \
    libssl-dev \
    libpq-dev \
    pkg-config \
    && rm -rf /var/lib/apt/lists/*

# Создаём рабочую директорию
WORKDIR /app

# Копируем манифест проекта для кеширования зависимостей
COPY Cargo.toml Cargo.lock ./

# Загружаем зависимости (это кешируется в Docker)
RUN cargo fetch
RUN cargo install diesel_cli --no-default-features --features postgres

# Копируем код проекта
COPY . .

# Этап 1: Сборка приложения
FROM rust:1.85-slim-bullseye AS builder

# Устанавливаем необходимые зависимости
RUN apt-get update && apt-get install -y --no-install-recommends \
    libssl-dev \
    pkg-config \
    && rm -rf /var/lib/apt/lists/*

# Создаём рабочую директорию
WORKDIR /app

# Копируем манифест проекта для кеширования зависимостей
COPY Cargo.toml Cargo.lock ./

# Кешируем зависимости
RUN cargo build --release --locked

# Копируем остальной код и собираем проект
COPY . .
RUN cargo build --release

# Этап 2: Минимальный runtime-образ
FROM debian:bullseye-slim AS production

# Устанавливаем зависимости для работы бинарника
RUN apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

# Создаём пользователя с ограниченными правами
RUN addgroup --system appgroup && adduser --system --ingroup appgroup appuser

# Указываем рабочую директорию
WORKDIR /app

# Копируем только бинарник из builder stage
COPY --from=builder /app/target/release/application /usr/local/bin/application

# Меняем пользователя
USER appuser
