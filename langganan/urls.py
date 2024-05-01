from django.urls import path, include
from .views import show_paket

urlpatterns = [
    path('', show_paket, name='show_paket'),
]