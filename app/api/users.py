import logging
from typing import Any, Dict, Optional
from fastapi import APIRouter, HTTPException
from pydantic import BaseModel
from db import Database

router = APIRouter()
db = Database()


class UserCreate(BaseModel):
    """Request model for creating a user"""

    email: Optional[str] = None
    phone: Optional[str] = None


class UserResponse(BaseModel):
    """Response model for user operations"""

    id: str
    email: Optional[str] = None
    phone: Optional[str] = None
    created_at: str


@router.post("/users", response_model=UserResponse)
async def create_user(user: UserCreate) -> UserResponse:
    """
    Create a new user with email and/or phone number.

    Args:
        user: UserCreate object containing email and/or phone

    Returns:
        UserResponse object containing the created user data

    Raises:
        HTTPException: If validation fails or database operation fails
    """
    try:
        if not user.email and not user.phone:
            raise HTTPException(
                status_code=400, detail="Either email or phone must be provided"
            )

        result: Dict[str, Any] = await db.add_user(email=user.email, phone=user.phone)
        return UserResponse(**result)

    except ValueError as e:
        raise HTTPException(status_code=400, detail=str(e))
    except Exception as e:
        logging.error(f"Error creating user: {str(e)}")
        raise HTTPException(status_code=500, detail="Internal server error")
