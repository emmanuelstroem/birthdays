#!/bin/bash

set -e

#  Install Requirements
echo "Install Requirements"
pip install -r requirements.txt

until PGPASSWORD=$POSTGRES_PASSWORD psql -h "db" -U "postgres" -c '\q'; do
  >&2 echo "Postgres is unavailable - sleeping"
  sleep 1
done

>&2 echo "Postgres is up - executing command"

# Make database migrations
echo "Make database migrations"
python manage.py makemigrations

# Apply database migrations
echo "Apply database migrations"
python manage.py migrate