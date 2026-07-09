from fastapi import FastAPI, Depends, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from sqlalchemy.orm import Session
from app.core.config import settings
from app.db.database import Base, engine, get_db
from app.db.models import User
from app.api.v1.api import api_router

# 创建数据库表（生产环境应该使用 Alembic migration）
# 注意：pgvector 扩展需要在数据库级别预先启用 `CREATE EXTENSION vector;`
# Base.metadata.create_all(bind=engine)

app = FastAPI(
    title=settings.PROJECT_NAME,
    version=settings.VERSION,
    description="后端 API 服务 - 这个APP能让你戒烟",
)

# CORS 配置
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"], # 生产环境应当限制 origins
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

app.include_router(api_router, prefix=settings.API_V1_STR)

@app.get("/")
def read_root():
    return {"message": "Welcome to QuitSmokingApp API", "version": settings.VERSION}

@app.get("/health")
def health_check(db: Session = Depends(get_db)):
    try:
        # 测试数据库连接
        db.execute("SELECT 1")
        db_status = "ok"
    except Exception as e:
        db_status = f"error: {str(e)}"
        
    return {
        "status": "healthy", 
        "database": db_status
    }

if __name__ == "__main__":
    import uvicorn
    uvicorn.run("app.main:app", host="0.0.0.0", port=8000, reload=True)
