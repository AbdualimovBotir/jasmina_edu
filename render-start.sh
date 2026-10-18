#!/usr/bin/env bash
set -o errexit
set -o pipefail
set -o nounset

python manage.py migrate --noinput

# Avtomatik admin yaratish
python manage.py shell -c "
from django.contrib.auth import get_user_model;
User = get_user_model();
if not User.objects.filter(username='admin').exists():
    User.objects.create_superuser('admin', 'admin@example.com', 'AdminPass123!')
"

exec daphne -b 0.0.0.0 -p "${PORT:?PORT not set}" managementProject.asgi:application
