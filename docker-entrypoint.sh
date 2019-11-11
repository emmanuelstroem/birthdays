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

# python manage.py flush --no-input

#  Make database migrations
echo "Make database migrations"
python manage.py makemigrations

# Apply database migrations
echo "Apply database migrations"
python manage.py migrate

# echo "Create Admin User"
# python manage.py createsuperuser --username admin --password s3cur3 --noinput --email 'info@10lines.eu'
# python manage.py shell -c "from django.contrib.auth.models import User; User.objects.create_superuser('admin', 'info@10lines.com', 'AdminUser')"

# Run Tests
echo "Running Unit Tests"
python manage.py test

# Start server
# echo "Starting server"
python manage.py runserver 0.0.0.0:8000