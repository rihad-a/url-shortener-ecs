FROM python:3.12-slim as builder
# sha value is to utilise node:22-slim base image

WORKDIR /app

ENV TABLE_NAME=table
ENV AWS_DEFAULT_REGION=eu-west-2

COPY requirements.txt . 

RUN pip install --no-cache-dir -r requirements.txt

COPY . . 

EXPOSE 8080

CMD ["uvicorn", "src.main:app", "--host", "0.0.0.0", "--port", "8080"]










