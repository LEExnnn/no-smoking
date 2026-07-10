from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from sqlalchemy import func
from datetime import datetime, timezone

from app.db.database import get_db
from app.db.models import User, UserProfile, CravingEvent
from app.schemas.dashboard import DashboardResponse

router = APIRouter()

@router.get("/me", response_model=DashboardResponse)
async def get_dashboard(device_id: str, db: Session = Depends(get_db)):
    user = db.query(User).filter(User.device_id == device_id).first()
    if not user:
        raise HTTPException(status_code=404, detail="User not found")
        
    profile = db.query(UserProfile).filter(UserProfile.user_id == user.id).first()
    if not profile:
        raise HTTPException(status_code=404, detail="Profile not found")

    # 1. 计算击退的烟瘾次数 (outcome == 'resisted')
    cravings_defeated = db.query(func.count(CravingEvent.id)).filter(
        CravingEvent.user_id == user.id,
        CravingEvent.outcome == 'resisted'
    ).scalar() or 0

    # 2. 计算省下的钱
    money_saved = 0.0
    if profile.quit_date:
        now = datetime.now(timezone.utc)
        delta = now - profile.quit_date
        # 假设一包烟 20 支
        pack_price = profile.pack_price or 0.0
        cigs_per_day = profile.cigarettes_per_day or 0.0
        
        # 每天花多少钱
        daily_cost = (cigs_per_day / 20.0) * pack_price
        
        # 总共省了多少钱 = 经过的天数 * 每天花销 (可以精确到浮点天数)
        days_passed = delta.total_seconds() / (24 * 3600)
        if days_passed > 0:
            money_saved = round(days_passed * daily_cost, 2)
            
    return DashboardResponse(
        quit_date=profile.quit_date,
        cravings_defeated=cravings_defeated,
        money_saved=money_saved,
        stage=profile.stage,
        user_types=profile.user_types or [],
    )
