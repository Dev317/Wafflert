from rest_framework import serializers
from rest_framework_simplejwt.tokens import RefreshToken
from .models import *


class WaffleUserSerializer(serializers.ModelSerializer):
    class Meta:
        model = WaffleUser
        fields = [
            "id",
            "telegram_username",
            "telegram_id",
            "username",
            "first_name",
            "last_name",
        ]


class WaffleUserSerializerWithToken(WaffleUserSerializer):
    token = serializers.SerializerMethodField(read_only=True)

    class Meta:
        model = WaffleUser
        fields = [
            "id",
            "token",
            "telegram_username",
            "telegram_id",
            "username",
            "first_name",
            "last_name",
        ]

    def get_token(self, obj):
        token = RefreshToken.for_user(obj)
        return str(token.access_token)
