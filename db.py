from typing import Optional, Dict, Any
from dotenv import load_dotenv
from app.config import settings
from supabase import create_client, Client

load_dotenv()


class Database:
    def __init__(self) -> None:
        """Initialize Supabase client with environment variables."""
        self.supabase: Client = create_client(
            supabase_url=settings.SUPABASE_URL,
            supabase_key=settings.SUPABASE_KEY,
        )

    async def add_user(
        self, email: Optional[str] = None, phone: Optional[str] = None
    ) -> Dict[str, Any]:
        """
        Add a new user to the database.

        Args:
            email: Optional email address for the user
            phone: Optional phone number for the user

        Returns:
            Dict containing the created user data

        Raises:
            Exception: If neither email nor phone is provided
        """
        if not email and not phone:
            raise ValueError("Either email or phone must be provided")

        user_data = {}
        if email:
            user_data["email"] = email
        if phone:
            user_data["phone"] = phone

        try:
            response = self.supabase.table("users").insert(user_data).execute()

            # Return the first user from the response data
            if response.data and len(response.data) > 0:
                return response.data[0]
            else:
                raise Exception("Failed to create user")

        except Exception as e:
            raise Exception(f"Error creating user: {str(e)}")
