from django.shortcuts import render
from daftar_favorit.models import Favorit

def show_daftar_favorit(request):
    daftar_favorit = Favorit.objects.all()

    return render(request, 'daftar_favorit.html', {'daftar_favorit': daftar_favorit})
