from django.shortcuts import render
from daftar_favorit.models import Favorit, Daftar

def show_daftar_favorit(request):
    daftar_favorit = Favorit.objects.all()

    return render(request, 'daftar_favorit.html', {'daftar_favorit': daftar_favorit})

def show_daftar(request):
    daftar = Daftar.objects.all()

    return render(request, 'daftar.html', {'daftar_favorit': daftar})