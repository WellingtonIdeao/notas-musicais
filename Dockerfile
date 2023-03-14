# Builder stage
FROM python:3.11.2-slim-buster AS builder

RUN python -m venv /opt/venv

ENV PATH="/opt/venv/bin:$PATH"

COPY requirements.txt .
RUN pip install -r requirements.txt
    
# Operational stage
FROM python:3.11.2-slim-buster

COPY --from=builder /opt/venv/ /opt/venv

ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    PATH="/opt/venv/bin:$PATH"

WORKDIR /app
COPY . .
 


