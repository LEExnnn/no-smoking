from fastapi import APIRouter
from app.api.v1 import profile, dashboard, craving

api_router = APIRouter()
api_router.include_router(profile.router, prefix="/profile", tags=["profile"])
api_router.include_router(dashboard.router, prefix="/dashboard", tags=["dashboard"])
api_router.include_router(craving.router, prefix="/craving", tags=["craving"])
