from pydantic import BaseModel
from typing import List

class CravingSOSRequest(BaseModel):
    device_id: str
    trigger_type: str  # e.g., 'tired', 'irritated', 'bored'
    intensity: int = 5

class CravingSOSResponse(BaseModel):
    event_id: str
    messages: List[str]  # The 5 sentences from AI

class CravingResolveRequest(BaseModel):
    device_id: str
    event_id: str
    outcome: str  # 'resisted', 'smoked', 'skipped'
    
class CravingResolveResponse(BaseModel):
    status: str
    cravings_defeated: int
    money_saved: float
