from django.urls import path, include
from .views import show_daftar_favorit, show_daftar

app_name = 'daftar_favorit'

urlpatterns = [
    path('', show_daftar_favorit, name='show_daftar_favorit'),
    path('all/', show_daftar, name='show_daftar'),
]