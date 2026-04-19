# urls.py
from django.urls import path
from rsvp.views import rsvp

urlpatterns = [
    path('', rsvp),
]