FROM python:3.9-slim-bullseye AS builder

WORKDIR /app
COPY . .

RUN apt update -y && apt upgrade -y && apt install curl -y
RUN curl -sSL https://install.python-poetry.org | POETRY_HOME=/opt/poetry python3 -

RUN cd /usr/local/bin && ln -s /opt/poetry/bin/poetry

RUN poetry config virtualenvs.create false 
RUN poetry install
RUN poetry export -f requirements.txt >> requirements.txt

FROM python:3.9-slim-bullseye AS runtime

RUN mkdir /app
COPY src /app
COPY --from=builder /app/requirements.txt /app
RUN pip install --no-cache-dir -r /app/requirements.txt

EXPOSE 80
