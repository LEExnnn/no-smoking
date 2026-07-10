from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from datetime import datetime, timezone
import uuid

from app.db.database import get_db
from app.db.models import User, UserProfile, CravingEvent
from app.schemas.craving import CravingSOSRequest, CravingSOSResponse, CravingResolveRequest, CravingResolveResponse
from app.services.craving_engine import engine

router = APIRouter()

@router.post("/sos", response_model=CravingSOSResponse)
async def trigger_sos(request: CravingSOSRequest, db: Session = Depends(get_db)):
    user = db.query(User).filter(User.device_id == request.device_id).first()
    if not user:
        raise HTTPException(status_code=404, detail="User not found")
        
    profile = db.query(UserProfile).filter(UserProfile.user_id == user.id).first()
    
    # 提取画像特征用于生成 Prompt
    motivation = profile.motivation_weights if profile else "健康"
    risk = profile.trigger_weights if profile else "无"
    belief = profile.belief_tags if profile else "无"
    
    # 1. 立即调用 LLM 生成 5 句话术
    messages = engine.generate_sos_messages(
        trigger=request.trigger_type,
        motivation=str(motivation),
        risk=str(risk),
        belief=str(belief)
    )
    
    # 2. 记录一条 CravingEvent 到数据库
    event_id = str(uuid.uuid4())
    event = CravingEvent(
        id=event_id,
        user_id=user.id,
        trigger_type=request.trigger_type,
        intensity=request.intensity,
        started_at=datetime.now(timezone.utc),
        intervention_used="ai_rescue_90s",
        outcome="unknown"
    )
    db.add(event)
    db.commit()
    
    # 3. 返回事件 ID 和话术给前端
    return CravingSOSResponse(
        event_id=event_id,
        messages=messages
    )

@router.post("/resolve", response_model=CravingResolveResponse)
async def resolve_craving(request: CravingResolveRequest, db: Session = Depends(get_db)):
    user = db.query(User).filter(User.device_id == request.device_id).first()
    if not user:
        raise HTTPException(status_code=404, detail="User not found")
        
    event = db.query(CravingEvent).filter(CravingEvent.id == request.event_id).first()
    if not event:
        raise HTTPException(status_code=404, detail="Craving event not found")
        
    # 1. 更新事件结果
    event.outcome = request.outcome
    event.resolved_at = datetime.now(timezone.utc)
    db.commit()
    
    # 2. 重新计算给前端展示的数据
    # 这里也可以单独调用一次 /dashboard/me，为了方便在完成页展示，直接在这里返回增量
    cravings_defeated = db.query(CravingEvent).filter(
        CravingEvent.user_id == user.id,
        CravingEvent.outcome == 'resisted'
    ).count()
    
    profile = db.query(UserProfile).filter(UserProfile.user_id == user.id).first()
    money_saved = 0.0
    if profile and profile.quit_date:
        now = datetime.now(timezone.utc)
        delta = now - profile.quit_date
        pack_price = profile.pack_price or 0.0
        cigs_per_day = profile.cigarettes_per_day or 0.0
        daily_cost = (cigs_per_day / 20.0) * pack_price
        days_passed = delta.total_seconds() / (24 * 3600)
        if days_passed > 0:
            money_saved = round(days_passed * daily_cost, 2)
            
    return CravingResolveResponse(
        status="success",
        cravings_defeated=cravings_defeated,
        money_saved=money_saved
    )
