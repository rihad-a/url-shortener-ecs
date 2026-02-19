FROM python:3.13-alpine AS builder
# sha value is to utilise python:3.13-slim base image

WORKDIR /app

RUN python -m venv /venv 

COPY requirements.txt . 

RUN /venv/bin/pip install -r requirements.txt

COPY . .

FROM python:3.13-alpine AS production
# sha value is to utilise python:3.13-alpine base image

RUN adduser -u 1001 -D rihad

WORKDIR /app

COPY --from=builder ./app/src .
COPY --from=builder /venv/ /venv/

ENV PATH=/venv/bin:$PATH

ENV TABLE_NAME=url-shortener
ENV AWS_DEFAULT_REGION=eu-west-2

USER rihad

EXPOSE 8080

CMD ["uvicorn", "main:app", "--host=0.0.0.0", "--port", "8080"]










