import asyncio
import os

from fastapi import FastAPI


PING_DELAY = float(os.getenv('PING_DELAY_MS')) / 1000


app = FastAPI()


@app.get('ping/')
async def ping() -> str:
    await asyncio.sleep(PING_DELAY)
    return 'pong'
