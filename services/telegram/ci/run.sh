#!/bin/bash

exec python3 ./src/app.py &
exec python3 -m pytest