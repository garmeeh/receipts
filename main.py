from fastapi import FastAPI, File, UploadFile, HTTPException
from fastapi.responses import JSONResponse
from google.cloud import documentai_v1 as documentai
from google.api_core.client_options import ClientOptions
from typing import List, Optional
import asyncio
from pydantic import BaseModel
from pydantic_settings import BaseSettings
import logging
from concurrent.futures import ThreadPoolExecutor
from google.oauth2 import service_account


# Settings management
class Settings(BaseSettings):
    PROJECT_ID: str = "receipt-uploader-445111"
    PROCESSOR_ID: str = "146fe0b85a5ce8b4"
    LOCATION: str = "eu"
    MAX_CONCURRENT_PROCESSES: int = 3
    GOOGLE_CREDENTIALS_PATH: str = "credentials.json"

    class Config:
        env_file = ".env"


# Response models
class OCRResult(BaseModel):
    filename: str
    text: str
    confidence: float
    error: Optional[str] = None


class BatchOCRResponse(BaseModel):
    results: List[OCRResult]
    failed_count: int
    success_count: int


# Service layer
class DocumentAIService:
    def __init__(self, settings: Settings) -> None:
        self.settings: Settings = settings
        self._setup_client()

    def _setup_client(self) -> None:
        """Initialize Document AI client with proper configuration."""
        opts = ClientOptions(
            api_endpoint=f"{self.settings.LOCATION}-documentai.googleapis.com"
        )

        # Add credentials setup
        credentials = service_account.Credentials.from_service_account_file(
            self.settings.GOOGLE_CREDENTIALS_PATH,
            scopes=["https://www.googleapis.com/auth/cloud-platform"],
        )

        self.client = documentai.DocumentProcessorServiceClient(
            client_options=opts, credentials=credentials
        )
        self.processor_name = self.client.processor_path(
            self.settings.PROJECT_ID, self.settings.LOCATION, self.settings.PROCESSOR_ID
        )

    def process_document(self, content: bytes, mime_type: str) -> documentai.Document:
        """Process a single document through Document AI."""
        request = documentai.ProcessRequest(
            name=self.processor_name,
            raw_document=documentai.RawDocument(content=content, mime_type=mime_type),
        )

        try:
            response = self.client.process_document(request=request)
            return response.document
        except Exception as e:
            logging.error(f"Error processing document: {str(e)}")
            raise HTTPException(status_code=500, detail=str(e))


# Initialize FastAPI app and services
app = FastAPI(title="Receipt OCR API")
settings = Settings()
docai_service = DocumentAIService(settings)

# Thread pool for concurrent processing
thread_pool = ThreadPoolExecutor(max_workers=settings.MAX_CONCURRENT_PROCESSES)


@app.post("/upload/receipt", response_model=BatchOCRResponse)
async def upload_receipts(files: List[UploadFile] = File(...)) -> BatchOCRResponse:
    """
    Process multiple receipt images using Document AI OCR.

    Args:
        files: List of images to process

    Returns:
        BatchOCRResponse containing OCR results and statistics
    """
    if not files:
        raise HTTPException(status_code=400, detail="No files provided")

    results: List[OCRResult] = []

    async def process_single_file(file: UploadFile) -> OCRResult:
        try:
            content = await file.read()
            mime_type = file.content_type or "image/jpeg"

            # Process in thread pool to avoid blocking
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

    # Process files concurrently
    results = await asyncio.gather(*[process_single_file(file) for file in files])

    # Calculate statistics
    failed_count = sum(1 for result in results if result.error is not None)
    success_count = len(results) - failed_count

    return BatchOCRResponse(
        results=results, failed_count=failed_count, success_count=success_count
    )


@app.exception_handler(Exception)
async def global_exception_handler(request, exc) -> JSONResponse:
    """Global exception handler for unhandled errors."""
    logging.error(f"Unhandled error: {str(exc)}")
    return JSONResponse(
        status_code=500, content={"detail": "An unexpected error occurred"}
    )


if __name__ == "__main__":
    import uvicorn

    uvicorn.run(app, host="0.0.0.0", port=8000)
