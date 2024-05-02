from django.urls import path, include
from .views import index, detail_episode, detail_film, detail_series, search

urlpatterns = [
    path("", index),
    path("detail/<int:id>", index, name="detail"),
    path("search/", search, name="search"),
    path("series/<int:id>", detail_series, name="series"),
    path("film/<int:id>", detail_film, name="film"),
    path("series/episode/<int:id>", detail_episode, name="episode")
]