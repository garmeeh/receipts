import logging
import asyncio
from typing import List
from fastapi import APIRouter, File, HTTPException, UploadFile
from app.models import OCRResult, BatchOCRResponse
from app.services.document_ai import DocumentAIService
from app.config import settings
from concurrent.futures import ThreadPoolExecutor

router = APIRouter()
docai_service = DocumentAIService(settings)
thread_pool = ThreadPoolExecutor(max_workers=settings.MAX_CONCURRENT_PROCESSES)


@router.post("/upload/receipt", response_model=BatchOCRResponse)
async def upload_receipts(files: List[UploadFile] = File(...)) -> BatchOCRResponse:
    """
    Process multiple receipt images using Document AI OCR.
    """
    if not files:
        raise HTTPException(status_code=400, detail="No files provided")

    async def process_single_file(file: UploadFile) -> OCRResult:
        try:
            content = await file.read()
            mime_type = file.content_type or "image/jpeg"

            document = await asyncio.get_event_loop().run_in_executor(
                thread_pool, docai_service.process_document, content, mime_type
            )

            return OCRResult(
                filename=file.filename or "unnamed_file",
                text=document.text,
                confidence=document.text_styles[0].confidence
                if document.text_styles
                else 0.0,
            )
        except Exception as e:
            logging.error(f"Error processing {file.filename}: {str(e)}")
            return OCRResult(
                filename=file.filename or "unnamed_file",
                text="",
                confidence=0.0,
                error=str(e),
            )

    results: List[OCRResult] = await asyncio.gather(
        *[process_single_file(file) for file in files]
    )

    failed_count: int = sum(1 for result in results if result.error is not None)
    success_count: int = len(results) - failed_count

    return BatchOCRResponse(
        results=results, failed_count=failed_count, success_count=success_count
    )
