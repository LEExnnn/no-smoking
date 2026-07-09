from pydantic import BaseModel, Field
from typing import List, Dict, Optional, Any
from datetime import datetime

class QuestionnaireSubmit(BaseModel):
    # A. 你和烟的关系
    smoke_start_age: Optional[str] = ""
    smoke_identity: Optional[str] = ""
    
    # B. 吸烟信息
    cigarettes_per_day: Optional[str] = ""
    pack_price: Optional[str] = ""
    first_cigarette: Optional[str] = ""
    
    # C. 什么时候想抽
    triggers: List[str] = Field(default_factory=list)
    
    # D. 为什么想戒
    motivations: List[str] = Field(default_factory=list)
    top_motivations: List[str] = Field(default_factory=list)
    
    # E. 你的信念
    beliefs: List[str] = Field(default_factory=list)
    
    # F. 戒烟史
    quit_history: Optional[str] = ""
    quit_fear: List[str] = Field(default_factory=list)
    
    # G. 支持环境
    has_baby: Optional[str] = ""
    support_env: List[str] = Field(default_factory=list)

class UserProfileResponse(BaseModel):
    id: str
    user_id: str
    smoking_years: int
    cigarettes_per_day: float
    pack_price: float
    dependence_level: str
    
    user_types: List[str]
    motivation_weights: Dict[str, float]
    trigger_weights: Dict[str, float]
    belief_tags: List[str]
    
    stage: str
    quit_date: Optional[datetime] = None
    
    # 为了前端展示，提供报告所需字段
    primary_motivation: str
    primary_trigger: str
    recommended_modules: List[str]
    
    created_at: datetime
    updated_at: datetime

    class Config:
        from_attributes = True
