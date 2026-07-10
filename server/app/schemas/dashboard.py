from pydantic import BaseModel
from typing import Optional
from datetime import datetime

class DashboardResponse(BaseModel):
    quit_date: Optional[datetime] = None
    cravings_defeated: int = 0
    money_saved: float = 0.0
    
    # 也可以返回一些其他的基本信息用于前端展示
    stage: str = "preparing"
    user_types: list[str] = []
