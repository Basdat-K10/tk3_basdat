from django.urls import path, include
from .views import index, create_ulasan

urlpatterns = [
    path("", index),
    path("create_ulasan/", create_ulasan, name="create_ulasan")
]