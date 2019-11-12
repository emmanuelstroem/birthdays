#!/bin/bash

# # Collect static files
# echo "Collect static files"
# python manage.py collectstatic --noinput

set -e

#  Install Requirements
echo "Install Requirements"
pip install -r requirements.txt

until PGPASSWORD=$POSTGRES_PASSWORD psql -h "db" -U "postgres" -c '\q'; do
  >&2 echo "Postgres is unavailable - sleeping"
  sleep 1
done

>&2 echo "Postgres is up - executing command"

# Start server
echo "Starting server"
python manage.py runserver 0.0.0.0:8000