from django.test import TestCase, RequestFactory
from django.contrib.auth.hashers import make_password
from .models import *
from .views import *

class WaffleUserTests(TestCase):
    def setUp(self):
        self.factory = RequestFactory()
        self.user = WaffleUser.userManager.create(username="testcase@testcase.com", email="testcase@testcase.com", password=make_password("testP@ssword123"), telegram_username='testelegram')
    
    # Database Testing
    def test_create_user(self):
        WaffleUser.userManager.create(username="testcase2@testcase.com", email="testcase2@testcase.com", password=make_password("testP@ssword123"), telegram_username='testelegram')
        user_retrieve = WaffleUser.objects.get(username='testcase2@testcase.com')
        if user_retrieve:
            self.assertEqual(user_retrieve.username, "testcase2@testcase.com")

    def test_retrieve_user(self):
        user_retrieve = WaffleUser.objects.get(username='testcase@testcase.com')
        self.assertEqual(user_retrieve.username, "testcase@testcase.com")


    def test_delete_user(self):
        user_retrieve = WaffleUser.objects.get(username='testcase@testcase.com')
        user_retrieve.delete()
        user_retrieve = WaffleUser.objects.filter(username='testcase@testcase.com')
        self.assertEqual(user_retrieve.exists(), False)
    
    # API Tests
 