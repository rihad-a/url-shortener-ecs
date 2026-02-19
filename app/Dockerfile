FROM python:3.13-alpine AS builder
# sha value is to utilise python:3.13-slim base image

WORKDIR /app

COPY requirements.txt . 

RUN pip install --prefix=/install --no-cache-dir -r requirements.txt

COPY . .

FROM python:3.13-alpine AS production
# sha value is to utilise python:3.13-alpine base image

RUN adduser -u 1001 -D rihad

WORKDIR /app

COPY --from=builder ./app/src ./app
COPY --from=builder ./install /usr/local

ENV TABLE_NAME=url-shortener
ENV AWS_DEFAULT_REGION=eu-west-2

USER rihad

EXPOSE 8080

CMD ["uvicorn", "app.main:app", "--host=0.0.0.0", "--port", "8080"]










