 Лабораторная работа №11: Docker контейнеризация

Студент: Сидяк Никита Андреевич  
**Группа:** 221331  
**Вариант:** 4

Выполненные задания

 Базовые задания
- Задание 4: Собраны образы и сравнены размеры
- Задание 6: Настроена сеть между контейнерами
- Задание 8: Добавлен healthcheck для каждого сервиса

 Задания повышенной сложности
- Задание 4: Кросс-платформенная сборка (amd64/arm64) — скрипт `buildx.sh`
- **Задание 6: Graceful shutdown и проброс сигналов


# Запуск всех сервисов
docker-compose up -d

# Проверка статуса
docker ps

# Остановка всех сервисов
docker-compose down
🌐 Эндпоинты сервисов
Сервис	Порт	Healthcheck	Эндпоинты

Go (scratch)	8080	✅	/health, /ping

Go (alpine)	8081	✅	/health, /ping

Python (slim)	8000	✅	/health, /ping

Python (regular)	8001	✅	/health, /ping

Rust (alpine)	3000	✅	/health, /ping

Rust (regular)	3001	✅	/health, /ping

📊 Сравнение размеров образов
Образ	Размер	Оптимизация

go-scratch	~6 MB	Минимальный (scratch)

go-alpine	~12 MB	Стандартный (alpine)

python-slim	~95 MB	Оптимизированный (slim)

python-regular	~120 MB	Стандартный

rust-alpine	~8 MB	Минимальный (alpine)

rust-regular	~45 MB	Стандартный (debian)

Выводы
Go scratch — самый маленький (~6 MB) за счёт статической компиляции

Rust alpine — близок к Go (~8 MB)

Python — самый тяжёлый из-за интерпретатора и зависимостей

🔧 Healthcheck
Все сервисы имеют healthcheck с параметрами:

Интервал: 30 секунд

Таймаут: 3 секунды

Start period: 5-10 секунд

Retries: 3

# Проверка healthcheck
curl http://localhost:8080/health
curl http://localhost:8081/health
curl http://localhost:8000/health
curl http://localhost:8001/health
curl http://localhost:3000/health
curl http://localhost:3001/health
🏗️ Сборка образов
Сборка всех образов

./build-and-compare.sh
Кросс-платформенная сборка (amd64/arm64)

./buildx.sh
Анализ размеров

python compare_sizes.py
🔄 Graceful Shutdown
Все сервисы корректно обрабатывают сигналы завершения:

# Проверка graceful shutdown
docker stop go-scratch-service
# Сервер завершится через 10 секунд, завершив текущие запросы
Go: обработка SIGINT и SIGTERM

Python: lifespan менеджер с graceful shutdown

Rust: tokio graceful shutdown с обработкой сигналов

📈 CI/CD (GitHub Actions)
Автоматическая сборка и тестирование при push и pull request:

Сборка всех 6 образов

Проверка healthcheck

Сравнение размеров

Отчёт в GitHub Actions Summary

📝 Принципы SOLID в реализации
Принцип	Реализация
S (Single Responsibility)	Каждый Dockerfile отвечает за один образ
O (Open/Closed)	Легко добавить новый образ через новый Dockerfile
L (Liskov Substitution)	Все образы имеют одинаковые эндпоинты
I (Interface Segregation)	Разные Dockerfile для разных целей
D (Dependency Inversion)	Зависимости через базовые образы

Структура проекта
lab11-docker-comparison/
├── go-service/ # Go микросервис
│ ├── main.go # Точка входа
│ ├── go.mod # Зависимости
│ ├── handler/ # HTTP обработчики
│ │ ├── handler.go
│ │ └── handler_test.go # Unit-тесты
│ ├── websocket/ # WebSocket чат
│ │ └── chat.go
│ └── middleware/ # Middleware
│ └── metrics.go
│
├── python-service/ # Python сервис
│ ├── main.py # FastAPI приложение
│ ├── client.py # Go клиент
│ ├── websocket_client.py # WebSocket клиент
│ ├── requirements.txt # Зависимости
│ └── tests/ # Python тесты
│ ├── test_client.py
│ └── test_basic.py
│
├── rust-service/ # Rust сервис
│ ├── src/
│ │ └── main.rs
│ └── Cargo.toml
│
├── benchmarks/ # Тесты производительности
│ ├── load_test.sh # wrk скрипт
│ └── memory_test.py # Профилирование памяти
│
├── docker-compose.yml # Docker оркестрация
├── compare_sizes.py # Сравнение размеров образов
├── buildx.sh # Кросс-платформенная сборка
├── build-and-compare.sh # Сборка и сравнение
├── .gitignore
├── PROMPT_LOG.md
└── README.md

Полезные команды

# Просмотр логов
docker-compose logs -f

# Пересборка конкретного сервиса
docker-compose build go-scratch

# Проверка использования ресурсов
docker stats

# Очистка неиспользуемых образов
docker system prune -f
