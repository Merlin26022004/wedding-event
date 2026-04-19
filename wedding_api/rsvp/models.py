# rsvp/models.py
from django.db import models

class Guest(models.Model):
    name = models.CharField(max_length=100)
    attending = models.BooleanField()
    guests_count = models.IntegerField()
    created_at = models.DateTimeField(auto_now_add=True)

    def __str__(self):
        return self.name