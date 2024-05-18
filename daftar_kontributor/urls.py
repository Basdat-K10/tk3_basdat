from django.urls import path, include
from .views import show_contributors

app_name = 'daftar_kontributor'

urlpatterns = [
    path('', show_contributors, name='show_contributor'),
]