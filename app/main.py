from fastapi import FastAPI
from fastapi.responses import JSONResponse
import logging
from app.api import receipts, users

app = FastAPI(title="Receipt OCR API")

# Register routers
app.include_router(receipts.router)
app.include_router(users.router, prefix="/api")


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
