from typing import List, Optional
from pydantic import BaseModel


class OCRResult(BaseModel):
    filename: str
    text: str
    confidence: float
    error: Optional[str] = None


class BatchOCRResponse(BaseModel):
    results: List[OCRResult]
    failed_count: int
    success_count: int
