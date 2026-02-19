# FastAPI Test Project

Безопасное приложение FastAPI с поддержкой `.env` для хранения конфиденциальных данных.

## Функционал
- Запуск сервера FastAPI
- Поддержка конфигурации через `.env`
- Пример CRUD-операций

## Установка
```bash
git clone https://github.com/Igorz161024/Fast-api-test.git
cd Fast-api-test
pip install -r requirements.txt
uvicorn main_safe:app --reload
