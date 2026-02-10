FROM python:3.13-slim AS builder
# sha value is to utilise node:22-slim base image

WORKDIR /app

COPY requirements.txt . 

RUN pip install --no-cache-dir -r requirements.txt

COPY ./src ./src

ENV TABLE_NAME=url-shortener
ENV AWS_DEFAULT_REGION=eu-west-2

EXPOSE 8080

CMD ["uvicorn", "src.main:app", "--host=0.0.0.0", "--port", "8080"]










