import logging
from fastapi import HTTPException
from google.cloud import documentai_v1 as documentai
from google.api_core.client_options import ClientOptions
from google.oauth2 import service_account
from app.config import Settings


class DocumentAIService:
    def __init__(self, settings: Settings) -> None:
        self.settings: Settings = settings
        self._setup_client()

    def _setup_client(self) -> None:
        """Initialize Document AI client with proper configuration."""
        opts = ClientOptions(
            api_endpoint=f"{self.settings.LOCATION}-documentai.googleapis.com"
        )

        credentials: service_account.Credentials = (
            service_account.Credentials.from_service_account_file(
                self.settings.GOOGLE_CREDENTIALS_PATH,
                scopes=["https://www.googleapis.com/auth/cloud-platform"],
            )
        )

        self.client = documentai.DocumentProcessorServiceClient(
            client_options=opts, credentials=credentials
        )
        self.processor_name: str = self.client.processor_path(
            self.settings.PROJECT_ID, self.settings.LOCATION, self.settings.PROCESSOR_ID
        )

    def process_document(self, content: bytes, mime_type: str) -> documentai.Document:
        """Process a single document through Document AI."""
        request = documentai.ProcessRequest(
            name=self.processor_name,
            raw_document=documentai.RawDocument(content=content, mime_type=mime_type),
        )

        try:
            response: documentai.ProcessResponse = self.client.process_document(
                request=request
            )
            return response.document
        except Exception as e:
            logging.error(f"Error processing document: {str(e)}")
            raise HTTPException(status_code=500, detail=str(e))
