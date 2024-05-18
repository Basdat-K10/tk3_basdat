from django.urls import path, include
from .views import index_trailer, search
from django.conf import settings
from django.conf.urls.static import static

app_name = "trailer"

urlpatterns = [
    path("", index_trailer, name="index_trailer"),
    path("search/", search, name="search"),
] + static(settings.STATIC_URL, document_root=settings.STATIC_ROOT)