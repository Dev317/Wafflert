import pytest
import os
from telethon import TelegramClient
from telethon.sessions import StringSession
import pytest_asyncio
from telethon.tl.custom.conversation import Conversation
import requests_mock

api_id = 9851818
api_hash = "fe7e1711f4ec47b6ee44993acbd279fb"
session_str = "1BVtsOKcBuyA4UEzpsavHmrPM1D8RAz0ruzG0LNYjGzcIlUiNtctzeYv539SO4K-rNsqIcUBGHj9FRMD6EDIg8FBT858MVZUFXiuDKe5kbu50kvuMV-gCHw1Vn4AnAR3HmPQZu9A9pLGxazy138tM0zHJ1YZCJSx_ku-OUh9F8lEOSU3_ZpiImH6Qr1ErdCe4GUXmhaJ_PhTEwjsKc8wDtkiTlUiCsA-aTh0WskopG4VUI1G9QxwyCIpxFUaFIMYcNVWAwvE0F5Oc4hZdO3bd1dSArPouflBv-vP4AXqnXw_EmnXWlLuofHYHkPurXfCyYoJERDS4Awqn0apCQwg-KNlPNC8lnrk="


@pytest.fixture(scope="session")
def anyio_backend():
    return "asyncio"


@pytest.fixture(scope="session")
async def conv():
    client = TelegramClient(
        StringSession(session_str), api_id, api_hash,
        sequential_updates=True
    )
    await client.connect()
    async with client.conversation("@wafbotdev_bot", timeout=5) as conv:
        yield conv


@pytest.fixture
def client():
    from src import app
    app.app.config['TESTING'] = True
    return app.app.test_client()
