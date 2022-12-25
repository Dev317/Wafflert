from django.db import models
from django.contrib.auth.models import AbstractUser, UserManager
import uuid

class WaffleUser(AbstractUser):   
    id = models.UUIDField(primary_key=True, default=uuid.uuid4, editable=False, unique=True)
    telegram_username = models.TextField(blank=True, null=True)
    telegram_id = models.TextField(default=None,blank=True,null=True)
    
    userManager = UserManager()
     
    def __str__(self):
        return f"{str(self.id)} - {self.username}"