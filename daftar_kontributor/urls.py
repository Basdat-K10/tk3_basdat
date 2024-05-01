from django.urls import path, include
from .views import show_contributors

urlpatterns = [
    path('', show_contributors, name='show_contributor'),
]