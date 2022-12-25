from tkinter import E
from rest_framework_simplejwt.serializers import TokenObtainPairSerializer
from rest_framework_simplejwt.views import TokenObtainPairView
from rest_framework.decorators import api_view, permission_classes
from rest_framework.response import Response
from django.contrib.auth.hashers import make_password
from rest_framework.permissions import IsAuthenticated, IsAdminUser
from .serializers import *
from .models import *

# Helper
def serialise(obj, serializer, is_many: bool) -> dict:
    serialised_data = serializer(obj, many=is_many)
    return serialised_data.data


# Waffle User Login
class WaffleTokenObtainPairSerializer(TokenObtainPairSerializer):
    def validate(self, attrs):
        data = super().validate(attrs)
        user_serialized = WaffleUserSerializerWithToken(self.user)
        data = user_serialized.data
        return data


class WaffleTokenObtainPairView(TokenObtainPairView):
    serializer_class = WaffleTokenObtainPairSerializer


# Waffle User Registration
@api_view(["POST"])
def create_waffle_user(request) -> Response:
    data = request.data
    check_user = WaffleUser.objects.filter(username=data["email"])
    # try:
    if check_user.exists():
        return Response("User with username already exists", status=403)
    else:
        new_user = WaffleUser.objects.create(
            username=data["email"],
            email=data["email"],
            password=make_password(data["password"]),
            telegram_id=None
        )
        new_user.save()
        data = serialise(new_user, WaffleUserSerializer, False)
        return Response(data, status=201)
    # except:
    #     return Response("Error creating user", status=400)


# Retrieve Waffle User
@api_view(["GET"])
@permission_classes([IsAuthenticated])
def retrieve_waffle_user(request, uuid: str) -> Response:
    data = request.data
    try:
        check_user = WaffleUser.objects.filter(id=uuid)
        if not check_user.exists():
            return Response("User does not exists", status=404)
        else:
            retrieve_user = WaffleUser.objects.get(id=uuid)
            data = serialise(retrieve_user, WaffleUserSerializer, False)
            return Response(data, status=200)
    except:
        return Response("Error retrieving user", status=400)


# Update Password
@api_view(["PUT"])
@permission_classes([IsAuthenticated])
def update_waffle_user_password(request, uuid: str) -> Response:
    data = request.data
    try:
        check_user = WaffleUser.objects.filter(id=uuid)
        if not check_user.exists():
            return Response("User does not exists", status=404)
        else:
            update_user = WaffleUser.objects.get(id=uuid)
            update_user.password = make_password(data["password"])
            data = serialise(update_user, WaffleUserSerializer, False)
            return Response(data, status=200)
    except:
        return Response("Error updating user pasword", status=400)


#update telegram ID
@api_view(["PUT"])
@permission_classes([IsAuthenticated])
def update_waffle_user_telegram_id(request, uuid: str) -> Response:
    data = request.data
    try:
        check_user = WaffleUser.objects.filter(id=uuid)
        if not check_user.exists():
            return Response({"error" :"User does not exists"}, status=404)
        else:
            update_user = WaffleUser.objects.get(id=uuid)
            update_user.telegram_id = data["telegram_id"]
            update_user.telegram_username = data["telegram_username"]
            update_user.save()
            user_data = serialise(update_user, WaffleUserSerializer, False)
            return Response(user_data, status=200)
    except:
        return Response({"error":"Error updating telegram id"}, status=400)


#delete user 

@api_view(["DELETE"])
@permission_classes([IsAuthenticated])
def delete_waffle_user(request, uuid: str)-> Response:
    data = request.data
    check_user = WaffleUser.objects.filter(id=uuid)
    if not check_user.exists():
        return Response({"error" :"User does not exists"}, status=404)
    else:
        get_user = WaffleUser.objects.get(id=uuid)
        get_user.delete()
        return Response({"status": "user successfully deleted :D"}, status=204)

