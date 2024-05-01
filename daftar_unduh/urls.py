from django.urls import path, include
from .views import show_daftar_unduh

urlpatterns = [
    path('', show_daftar_unduh, name='show_daftar_unduh'),
]