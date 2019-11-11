from django.shortcuts import render
from django.http import JsonResponse
from datetime import date

import json

from api.models import People
from api.serializers import PeopleSerializer

from rest_framework import status, generics
from rest_framework.response import Response
from rest_framework.generics import RetrieveUpdateDestroyAPIView, ListCreateAPIView, GenericAPIView
from rest_framework.mixins import ListModelMixin, CreateModelMixin

# Create your views here.
class PeopleView(ListCreateAPIView):

    serializer_class = PeopleSerializer

    def get_all_queryset(self):
        person = People.objects.all()
        return person   

    def get(self, request):
        people = self.get_all_queryset()
        serializer = PeopleSerializer(people, many=True)
        return Response(serializer.data, status=status.HTTP_200_OK)

    def post(self, request):
        serializer = PeopleSerializer(data=request.data)

        # Get date of Birth from Request
        date_of_birth = Helpers().get_date_from(request.data['date_of_birth'], 0)

        # Convert Date of birth from String to Date
        is_user_born_today_or_in_future = Helpers().is_born_today_or_in_future(date_of_birth)
        
        # Check if data is valid
        # and Date of Birth is not today or in the Fuute
        if serializer.is_valid() and not is_user_born_today_or_in_future:
            serializer.save() # Save the data
            return Response(status=status.HTTP_204_NO_CONTENT) # Return No Content
        else:
            error_message = {
                "Error" : "Date of Birth cannot be Today or in the Future"
            }
            return Response(error_message, status=status.HTTP_400_BAD_REQUEST)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)


class PersonView(ListCreateAPIView):
    serializer_class = PeopleSerializer
    lookup_field = 'username'

    def get_queryset(self, *args, **kwargs):
        try:
            username = self.kwargs.get('username')
            person = People.objects.get(username=username)
        except People.DoesNotExist:
            content = {
                'status': 'Username Not Found'
            }
            return Response(content, status=status.HTTP_404_NOT_FOUND)
        return person

    def get(self, *args, **kwargs):
        username = self.kwargs.get('username')
        person = People.objects.get(username=username)
        serializer = PeopleSerializer(person)

        days_to_birthday = Helpers().birthday_due_in(person)

        message = Helpers().birthday_message(person.username, days_to_birthday)

        return Response(message, status=status.HTTP_200_OK)

    def put(self, request):
        serializer = PeopleSerializer(data=request.data)

        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data, status=status.HTTP_201_CREATED)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)


class Helpers():
    def birthday_due_in(self, person_object):
        today = date.today()

        born_on = person_object.date_of_birth
        birthday_this_year = self.get_this_year_birthday_from(born_on)
        birthday_next_year = self.date_increment_year_by(birthday_this_year, 1)

        if today < birthday_this_year: # birthday is in N days this year
            remaining_days = (birthday_this_year - today).days
            return remaining_days
        elif today > birthday_this_year: # birthday is in future
            remaining_days = (birthday_next_year - today).days
            return remaining_days
        else: #birthday today
            return 0
            
    def birthday_message(self, username, number_of_days):
        if number_of_days == 0: # check if birthday us today
            content = '{{"message": "Hello, {0}! Happy birthday!"}}'.format(username)
            return content
        else: # otherwise its in N days
            content = '{{"message": "Hello, {0}! Your birthday is in {1} day(s)"}}'.format(username, number_of_days)
            return content

    def get_date_from_string(self, date_string):
        date_data = self.split_date(date_string)
        date_year = int(date_data[0])
        date_month = int(date_data[1])
        date_day = int(date_data[2])
        formatted_date = self.get_date_from_int(date_year, date_month, date_day)
        return formatted_date

    def get_date_from_int(self, date_year, date_month, date_day):
        return date(date_year, date_month, date_day)

    def split_date(self, date_string):
        return str(date_string).split("-")

    def get_next_birthday_from(self, date_string):
        return self.date_increment_year_by(date_string, 1) # increase year by 1

    def get_this_year_birthday_from(self, date_string):
        date_data = self.split_date(date_string)
        date_month = int(date_data[1])
        date_day = int(date_data[2])
        return self.get_date_from_int(date.today().year, date_month, date_day) # pass in date.today().year for current year

    def date_increment_year_by(self, date_string, increase_by_int):
        date_data = self.split_date(date_string)
        date_year = int(date_data[0])
        date_month = int(date_data[1])
        date_day = int(date_data[2])
        return self.get_date_from_int(date_year + increase_by_int, date_month, date_day) # increament this year and return date

    def is_born_today_or_in_future(self, born_on):
        today = date.today()
        # date_of_birth = Helpers().get_date_from(born_on)
        if born_on >= today:
            return True
        else:
            return False
