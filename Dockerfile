FROM python:3.10.2-bullseye@sha256:083f7050ed966b5e430b5c0ebc439af58094ac59f37861573966121652d2d790  AS base

WORKDIR /app

RUN pip install --upgrade pip==21.3.1

RUN curl -sSL https://install.python-poetry.org | python - --yes --version 1.1.12
ENV PATH="/root/.local/bin:$PATH"

RUN poetry config virtualenvs.create false

COPY pyproject.toml .

RUN poetry lock

RUN poetry install --no-interaction