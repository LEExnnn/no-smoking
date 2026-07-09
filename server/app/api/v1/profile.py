from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.orm import Session
from app.db.database import get_db
from app.db import models
from app.schemas.profile import QuestionnaireSubmit, UserProfileResponse
from app.services.profile_engine import ProfileEngine

router = APIRouter()
profile_engine = ProfileEngine()

@router.post("/submit", response_model=UserProfileResponse)
async def submit_questionnaire(
    answers: QuestionnaireSubmit, 
    # 在真实环境中需要用户身份认证，这里假设传入 device_id 作为临时用户标识
    device_id: str = "temp_device_123", 
    db: Session = Depends(get_db)
):
    # 1. 查找或创建临时用户
    user = db.query(models.User).filter(models.User.device_id == device_id).first()
    if not user:
        user = models.User(device_id=device_id)
        db.add(user)
        db.commit()
        db.refresh(user)

    # 2. 调用 AI 引擎分析问卷
    try:
        ai_result = await profile_engine.generate_profile_data(answers)
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"AI 分析失败: {str(e)}")

    # 3. 保存画像到数据库
    profile = db.query(models.UserProfile).filter(models.UserProfile.user_id == user.id).first()
    if not profile:
        profile = models.UserProfile(user_id=user.id)
        db.add(profile)
        
    profile.smoking_years = ai_result.get("smoking_years", 5)
    profile.cigarettes_per_day = ai_result.get("cigarettes_per_day", 10.0)
    profile.pack_price = ai_result.get("pack_price", 20.0)
    profile.dependence_level = ai_result.get("dependence_level", "medium")
    
    profile.user_types = ai_result.get("user_types", [])
    profile.motivation_weights = ai_result.get("motivation_weights", {})
    profile.trigger_weights = ai_result.get("trigger_weights", {})
    profile.belief_tags = ai_result.get("belief_tags", [])
    
    db.commit()
    db.refresh(profile)
    
    # 4. 构造前端返回数据
    # 计算主要动机和触发场景
    primary_motivation = "health"
    if profile.motivation_weights:
        primary_motivation = max(profile.motivation_weights.items(), key=lambda x: x[1])[0]
        
    primary_trigger = "stress"
    if profile.trigger_weights:
        primary_trigger = max(profile.trigger_weights.items(), key=lambda x: x[1])[0]
        
    recommended_modules = ai_result.get("recommended_modules", ["ai_rescue", "money_bank"])

    return UserProfileResponse(
        id=profile.id,
        user_id=profile.user_id,
        smoking_years=profile.smoking_years,
        cigarettes_per_day=profile.cigarettes_per_day,
        pack_price=profile.pack_price,
        dependence_level=profile.dependence_level,
        user_types=profile.user_types,
        motivation_weights=profile.motivation_weights,
        trigger_weights=profile.trigger_weights,
        belief_tags=profile.belief_tags,
        stage=profile.stage,
        quit_date=profile.quit_date,
        primary_motivation=primary_motivation,
        primary_trigger=primary_trigger,
        recommended_modules=recommended_modules,
        created_at=profile.created_at,
        updated_at=profile.updated_at
    )

@router.get("/me", response_model=UserProfileResponse)
async def get_my_profile(
    device_id: str = "temp_device_123", 
    db: Session = Depends(get_db)
):
    user = db.query(models.User).filter(models.User.device_id == device_id).first()
    if not user or not user.profile:
        raise HTTPException(status_code=404, detail="Profile not found")
        
    profile = user.profile
    
    primary_motivation = "health"
    if profile.motivation_weights:
        primary_motivation = max(profile.motivation_weights.items(), key=lambda x: x[1])[0]
        
    primary_trigger = "stress"
    if profile.trigger_weights:
        primary_trigger = max(profile.trigger_weights.items(), key=lambda x: x[1])[0]

    return UserProfileResponse(
        id=profile.id,
        user_id=profile.user_id,
        smoking_years=profile.smoking_years,
        cigarettes_per_day=profile.cigarettes_per_day,
        pack_price=profile.pack_price,
        dependence_level=profile.dependence_level,
        user_types=profile.user_types,
        motivation_weights=profile.motivation_weights,
        trigger_weights=profile.trigger_weights,
        belief_tags=profile.belief_tags,
        stage=profile.stage,
        quit_date=profile.quit_date,
        primary_motivation=primary_motivation,
        primary_trigger=primary_trigger,
        recommended_modules=["ai_rescue", "money_bank"], # 此处后续可持久化
        created_at=profile.created_at,
        updated_at=profile.updated_at
    )
