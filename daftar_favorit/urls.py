from django.urls import path, include
from .views import show_daftar_favorit

urlpatterns = [
    path('', show_daftar_favorit, name='show_daftar_favorit'),
]