# rsvp/views.py
from rest_framework.decorators import api_view
from rest_framework.response import Response
from .models import Guest

@api_view(['POST'])
def rsvp(request):
    data = request.data
    guest = Guest.objects.create(
        name=data.get('name'),
        attending=data.get('attending'),
        guests_count=data.get('guests_count')
    )
    return Response({"message": "Saved successfully"})

from django.http import HttpResponse

def home(request):
    return HttpResponse("Wedding API is running 💍")