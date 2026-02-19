from fastapi import FastAPI, HTTPException, Depends
from pydantic import BaseModel
from typing import List
from sqlalchemy import create_engine, Column, Integer, String, Float, ForeignKey
from sqlalchemy.orm import sessionmaker, declarative_base, Session, relationship
from dotenv import load_dotenv
import os
load_dotenv()  # завантажуємо змінні середовища з файлу .env
DATABASE_URL = os.getenv("DATABASE_URL")  # отримуємо рядок підключення з .env# -----------------------------
# Підключення до PostgreSQL
# -----------------------------

engine = create_engine(DATABASE_URL)
SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)
Base = declarative_base()

# -----------------------------
# Таблиці SQLAlchemy
# -----------------------------
class UserDB(Base):
    __tablename__ = "users"
    id = Column(Integer, primary_key=True, index=True)
    name = Column(String, index=True)
    age = Column(Integer)

class ProductDB(Base):
    __tablename__ = "products"
    id = Column(Integer, primary_key=True, index=True)
    name = Column(String, index=True)
    price = Column(Float)

class TransactionDB(Base):
    __tablename__ = "transactions"
    id = Column(Integer, primary_key=True, index=True)
    product_id = Column(Integer, ForeignKey("products.id"))
    type = Column(String)  # "debit" або "credit"
    amount = Column(Float)

    product = relationship("ProductDB")

# Створення таблиць у БД
Base.metadata.create_all(bind=engine)

# -----------------------------
# FastAPI додаток
# -----------------------------
app = FastAPI(
    title="Financial FastAPI App",
    version="1.0.0",
    description="CRUD приклад для користувачів, продуктів і транзакцій"
)
# Кореневий маршрут
@app.get("/")
def read_root():
    return {"message": "FastAPI + SQLAlchemy + PostgreSQL працює через .env"}
# -----------------------------
# Pydantic-моделі
# -----------------------------
class User(BaseModel):
    id: int
    name: str
    age: int
    class Config:
        from_attributes = True   # заміна orm_mode у Pydantic v2

class UserCreate(BaseModel):
    name: str
    age: int

class Product(BaseModel):
    id: int
    name: str
    price: float
    class Config:
        from_attributes = True

class ProductCreate(BaseModel):
    name: str
    price: float

class Transaction(BaseModel):
    id: int
    product_id: int
    type: str
    amount: float
    class Config:
        from_attributes = True

class TransactionCreate(BaseModel):
    product_id: int
    type: str
    amount: float

# -----------------------------
# Dependency для роботи з БД
# -----------------------------
def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()

# -----------------------------
# CRUD для користувачів
# -----------------------------
@app.post("/users/", response_model=User)
def create_user(user: UserCreate, db: Session = Depends(get_db)):
    new_user = UserDB(name=user.name, age=user.age)
    db.add(new_user)
    db.commit()
    db.refresh(new_user)
    return new_user

@app.get("/users/{user_id}", response_model=User)
def get_user(user_id: int, db: Session = Depends(get_db)):
    user = db.query(UserDB).filter(UserDB.id == user_id).first()
    if not user:
        raise HTTPException(status_code=404, detail="User not found")
    return user

# -----------------------------
# CRUD для продуктів
# -----------------------------
@app.post("/products/", response_model=Product)
def create_product(product: ProductCreate, db: Session = Depends(get_db)):
    new_product = ProductDB(name=product.name, price=product.price)
    db.add(new_product)
    db.commit()
    db.refresh(new_product)
    return new_product

@app.get("/products/", response_model=List[Product])
def get_products(db: Session = Depends(get_db)):
    return db.query(ProductDB).all()

# -----------------------------
# CRUD для транзакцій
# -----------------------------
@app.post("/transactions/", response_model=Transaction)
def create_transaction(transaction: TransactionCreate, db: Session = Depends(get_db)):
    new_transaction = TransactionDB(
        product_id=transaction.product_id,
        type=transaction.type,
        amount=transaction.amount
    )
    db.add(new_transaction)
    db.commit()
    db.refresh(new_transaction)
    return new_transaction

@app.get("/transactions/", response_model=List[Transaction])
def get_transactions(db: Session = Depends(get_db)):
    return db.query(TransactionDB).all()