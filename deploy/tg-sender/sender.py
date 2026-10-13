# -*- coding: utf-8 -*-
"""
MedOnline: sends the patient-bot invitation link from the clinic's own Telegram account.

Only for patients who could not connect to the bot themselves (scan the QR). A nurse presses
"Отправить ссылку в Telegram" on the patient page, fm calls this program on 127.0.0.1.

Limits (tg_sender.ini): at most daily_limit messages per day and one message per min_interval_sec,
so Telegram does not treat the account as a mass mailing.

Usage:
  python sender.py login    - first time: log in to the clinic account (Telegram sends a code)
  python sender.py serve    - run the local HTTP service (autostart, see README.md)

HTTP: POST http://127.0.0.1:<port>/send   header X-Token: <token>
      body JSON {"phone": "998901234567", "name": "Имя", "text": "..."}
      answer JSON {"ok": true} or {"ok": false, "error": "NOT_ON_TELEGRAM" | "LIMIT_DAY" | "LIMIT_WAIT" | ..., "detail": "..."}
"""
import asyncio
import configparser
import json
import os
import random
import sys
import time

from telethon import TelegramClient, errors, functions, types

HERE = os.path.dirname(os.path.abspath(__file__))
cfg = configparser.ConfigParser()
cfg.read(os.path.join(HERE, "tg_sender.ini"), encoding="utf-8")
S = cfg["sender"]

API_ID = int(S["api_id"])
API_HASH = S["api_hash"].strip()
PHONE = S["phone"].strip()
PORT = int(S.get("port", "8791"))
TOKEN = S["token"].strip()
DAILY_LIMIT = int(S.get("daily_limit", "30"))
MIN_INTERVAL = int(S.get("min_interval_sec", "30"))
STATE_FILE = os.path.join(HERE, "sender_state.json")
LOG_FILE = os.path.join(HERE, "sender.log")

client = None  # created inside the running event loop (asyncio.run)
lock = None


def log(msg):
    line = time.strftime("%Y-%m-%d %H:%M:%S ") + msg
    print(line, flush=True)
    with open(LOG_FILE, "a", encoding="utf-8") as f:
        f.write(line + "\n")


def load_state():
    try:
        with open(STATE_FILE, encoding="utf-8") as f:
            return json.load(f)
    except Exception:
        return {"day": "", "count": 0, "last": 0}


def save_state(st):
    with open(STATE_FILE, "w", encoding="utf-8") as f:
        json.dump(st, f)


async def send(phone, name, text):
    phone = "".join(ch for ch in phone if ch.isdigit())
    if len(phone) < 9:
        return {"ok": False, "error": "BAD_PHONE"}
    async with lock:
        st = load_state()
        today = time.strftime("%Y-%m-%d")
        if st.get("day") != today:
            st = {"day": today, "count": 0, "last": 0}
        if st["count"] >= DAILY_LIMIT:
            return {"ok": False, "error": "LIMIT_DAY", "detail": str(DAILY_LIMIT)}
        wait = int(st.get("last", 0) + MIN_INTERVAL - time.time())
        if wait > 0:
            return {"ok": False, "error": "LIMIT_WAIT", "detail": str(wait)}
        try:
            # a number can be messaged only through a contact: import, send, remove the contact again
            res = await client(functions.contacts.ImportContactsRequest([
                types.InputPhoneContact(client_id=random.randrange(1, 2 ** 62), phone="+" + phone,
                                        first_name=(name or "Patient")[:60], last_name="")]))
            if not res.users:
                log("NOT_ON_TELEGRAM +" + phone)
                return {"ok": False, "error": "NOT_ON_TELEGRAM"}
            user = res.users[0]
            await client.send_message(user, text, link_preview=False)
            try:
                await client(functions.contacts.DeleteContactsRequest(id=[user]))
            except Exception:
                pass
            st["count"] += 1
            st["last"] = time.time()
            save_state(st)
            log("SENT +" + phone)
            return {"ok": True}
        except errors.FloodWaitError as e:
            log("FLOOD_WAIT %s s" % e.seconds)
            return {"ok": False, "error": "FLOOD_WAIT", "detail": str(e.seconds)}
        except errors.PeerFloodError:
            log("PEER_FLOOD - Telegram limited messages to strangers for this account")
            return {"ok": False, "error": "PEER_FLOOD"}
        except Exception as e:
            log("ERROR +%s %r" % (phone, e))
            return {"ok": False, "error": "ERROR", "detail": str(e)}


async def handle(reader, writer):
    status, body = 200, {"ok": False, "error": "BAD_REQUEST"}
    try:
        head = await asyncio.wait_for(reader.readuntil(b"\r\n\r\n"), 10)
        lines = head.decode("latin-1").split("\r\n")
        method, path = lines[0].split(" ")[:2]
        headers = {}
        for ln in lines[1:]:
            if ":" in ln:
                k, v = ln.split(":", 1)
                headers[k.strip().lower()] = v.strip()
        data = b""
        n = int(headers.get("content-length", "0"))
        if n:
            data = await asyncio.wait_for(reader.readexactly(n), 10)
        if headers.get("x-token") != TOKEN:
            status, body = 403, {"ok": False, "error": "FORBIDDEN"}
        elif method == "GET" and path == "/ping":
            body = {"ok": True, "authorized": await client.is_user_authorized()}
        elif method == "POST" and path == "/send":
            req = json.loads(data.decode("utf-8"))
            body = await send(req.get("phone", ""), req.get("name", ""), req.get("text", ""))
    except Exception as e:
        status, body = 500, {"ok": False, "error": "ERROR", "detail": str(e)}
    raw = json.dumps(body, ensure_ascii=False).encode("utf-8")
    writer.write(("HTTP/1.1 %d OK\r\nContent-Type: application/json; charset=utf-8\r\nContent-Length: %d\r\nConnection: close\r\n\r\n"
                  % (status, len(raw))).encode("latin-1") + raw)
    await writer.drain()
    writer.close()


async def serve():
    global client, lock
    client = TelegramClient(os.path.join(HERE, "clinic"), API_ID, API_HASH)
    lock = asyncio.Lock()
    await client.connect()
    if not await client.is_user_authorized():
        log("Not logged in. Run: python sender.py login")
        sys.exit(1)
    server = await asyncio.start_server(handle, "127.0.0.1", PORT)
    log("Listening on 127.0.0.1:%d" % PORT)
    async with server:
        await server.serve_forever()


async def login():
    global client
    client = TelegramClient(os.path.join(HERE, "clinic"), API_ID, API_HASH)
    await client.start(phone=PHONE)
    me = await client.get_me()
    print("Logged in as", me.first_name, "+" + str(me.phone))


if __name__ == "__main__":
    mode = sys.argv[1] if len(sys.argv) > 1 else "serve"

    asyncio.run(login() if mode == "login" else serve())
