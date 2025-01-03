from pydantic_settings import BaseSettings


class Settings(BaseSettings):
    PROJECT_ID: str = "receipt-uploader-445111"
    PROCESSOR_ID: str = "146fe0b85a5ce8b4"
    LOCATION: str = "eu"
    MAX_CONCURRENT_PROCESSES: int = 3
    GOOGLE_CREDENTIALS_PATH: str = "credentials.json"

    class Config:
        env_file: str = ".env"


settings: Settings = Settings()
