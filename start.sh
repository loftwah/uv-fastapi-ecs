#!/bin/bash

# Start nginx
nginx

# Start FastAPI application
exec python -m uvicorn app.main:app --host 0.0.0.0 --port 8000