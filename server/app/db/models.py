import uuid
from datetime import datetime, timezone
from sqlalchemy import Column, String, Integer, Float, DateTime, Boolean, ForeignKey, JSON
from sqlalchemy.orm import relationship
from pgvector.sqlalchemy import Vector
from .database import Base

class User(Base):
    __tablename__ = "users"

    id = Column(String, primary_key=True, default=lambda: str(uuid.uuid4()))
    email = Column(String, unique=True, index=True, nullable=True)
    device_id = Column(String, unique=True, index=True, nullable=True)
    created_at = Column(DateTime, default=lambda: datetime.now(timezone.utc))
    updated_at = Column(DateTime, default=lambda: datetime.now(timezone.utc), onupdate=lambda: datetime.now(timezone.utc))

    profile = relationship("UserProfile", back_populates="user", uselist=False)
    craving_events = relationship("CravingEvent", back_populates="user")
    money_accounts = relationship("MoneyAccount", back_populates="user")

class UserProfile(Base):
    __tablename__ = "user_profiles"

    id = Column(String, primary_key=True, default=lambda: str(uuid.uuid4()))
    user_id = Column(String, ForeignKey("users.id"), unique=True, nullable=False)
    
    # 基础画像
    smoking_years = Column(Integer, default=0)
    cigarettes_per_day = Column(Float, default=0.0)
    pack_price = Column(Float, default=0.0)
    dependence_level = Column(String, default="medium")
    
    # 动态分析结果 (JSONB)
    user_types = Column(JSON, default=list)  # ["工作休息触发型", ...]
    motivation_weights = Column(JSON, default=dict)  # {"baby": 0.8, "health": 0.5}
    trigger_weights = Column(JSON, default=dict) # {"work_break": 0.9}
    belief_tags = Column(JSON, default=list) # ["放松幻觉"]
    
    # AI 向量检索使用的 Context
    # 维度需与使用的 embedding 模型一致 (例如 text-embedding-3-small 通常是 1536)
    context_embedding = Column(Vector(1536), nullable=True)
    
    quit_date = Column(DateTime, nullable=True)
    stage = Column(String, default="preparing")
    
    created_at = Column(DateTime, default=lambda: datetime.now(timezone.utc))
    updated_at = Column(DateTime, default=lambda: datetime.now(timezone.utc), onupdate=lambda: datetime.now(timezone.utc))

    user = relationship("User", back_populates="profile")

class CravingEvent(Base):
    __tablename__ = "craving_events"

    id = Column(String, primary_key=True, default=lambda: str(uuid.uuid4()))
    user_id = Column(String, ForeignKey("users.id"), nullable=False)
    trigger_type = Column(String, index=True, nullable=False) # e.g., 'work_break'
    intensity = Column(Integer, default=5)
    
    started_at = Column(DateTime, default=lambda: datetime.now(timezone.utc))
    resolved_at = Column(DateTime, nullable=True)
    
    intervention_used = Column(String, nullable=True) # e.g., 'ai_rescue_90s'
    outcome = Column(String, default="unknown") # resisted, smoked, skipped
    
    ai_context = Column(JSON, default=dict) # AI 急救时的完整上下文

    user = relationship("User", back_populates="craving_events")

class MoneyAccount(Base):
    __tablename__ = "money_accounts"

    id = Column(String, primary_key=True, default=lambda: str(uuid.uuid4()))
    user_id = Column(String, ForeignKey("users.id"), nullable=False)
    account_type = Column(String, nullable=False) # selfReward, baby, etc.
    name = Column(String, nullable=False)
    target_amount = Column(Float, default=0.0)
    saved_amount = Column(Float, default=0.0)

    user = relationship("User", back_populates="money_accounts")
