from rest_framework import serializers
from .models import People

class PeopleSerializer(serializers.ModelSerializer):
    class Meta:
        model = People
        fields = [
            'username',
            'date_of_birth'
        ]
        lookup_field = 'username'
        extra_kwargs = {
            'url': {'lookup_field': 'username'}
        }