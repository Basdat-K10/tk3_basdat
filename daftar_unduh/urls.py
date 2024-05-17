from django.urls import path, include
from .views import list_daftar_unduh

urlpatterns = [
    path('', list_daftar_unduh, name='list_daftar_unduh'),
]