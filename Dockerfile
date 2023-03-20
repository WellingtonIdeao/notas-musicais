FROM python:3.11.2-slim-buster AS base

ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    PYTHONHASHSEED=random

WORKDIR /app    

FROM base AS poetry

ENV POETRY_HOME="/opt/poetry"
ENV POETRY_VERSION=1.4.0 \
    PATH="${POETRY_HOME}/bin:$PATH"


RUN python -m venv ${POETRY_HOME} && \
    pip install "poetry>=$POETRY_VERSION"

COPY poetry.lock pyproject.toml ./

RUN poetry export --with dev --with doc -o requirements.txt     

# Builder stage
FROM base AS builder

ENV VENV_PATH="/opt/venv" 
ENV PIP_DISABLE_PIP_VERSION_CHECK=1 \
    PIP_NO_CACHE_DIR=1 \
    PATH="${VENV_PATH}/bin:$PATH"

COPY --from=poetry /app/requirements.txt /app/requirements.txt

RUN python -m venv ${VENV_PATH} && \
    pip install -r requirements.txt

# Operational stage
FROM base AS development

ENV PATH="/opt/venv/bin:$PATH"

COPY --from=builder /opt/venv/ /opt/venv

COPY . .
 


