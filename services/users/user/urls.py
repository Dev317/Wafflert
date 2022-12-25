from django.urls import path
from .views import *

urlpatterns = [
    path("login/", WaffleTokenObtainPairView.as_view(), name="login"),
    path("register/", create_waffle_user, name="register"),
    path("retrieve/<str:uuid>/", retrieve_waffle_user, name="retrieve-user"),
    path(
        "update-password/<str:uuid>/",
        update_waffle_user_password,
        name="update-password",
    ),
    path(
        "update-telegram-id/<str:uuid>/",
        update_waffle_user_telegram_id,
        name="update-telegram-id",
    ),
    path(
        "delete-waffle-user/<str:uuid>/",
        delete_waffle_user,
        name="delete-waffle-user",
    ),
]
