# api/urls.py 

from django.urls import path, re_path
from django.conf.urls import url
from . import views
from rest_framework.urlpatterns import format_suffix_patterns

urlpatterns = [
    path('', views.PeopleView.as_view(lookup_field='username')),
    path('<str:username>/', views.PersonView.as_view(lookup_field='username')),
]