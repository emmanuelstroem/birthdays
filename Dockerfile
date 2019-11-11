FROM python:3

RUN apt-get update && apt-get install libpq-dev postgresql-client -y

ENV PYTHONUNBUFFERED 1

RUN mkdir /app

WORKDIR /app

COPY requirements.txt /app/

RUN pip install -r requirements.txt

COPY . /app/