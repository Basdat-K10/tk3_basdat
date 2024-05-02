from django.urls import path, include
from .views import index, search
from django.conf import settings
from django.conf.urls.static import static

urlpatterns = [
    path("", index),
    path("search/", search),
] + static(settings.STATIC_URL, document_root=settings.STATIC_ROOT)