from django.shortcuts import render
from utils.query import query
# Create your views here.

def show_user_paket(request):
    context = {}

def show_paket(request):
    context = {}
    return render(request, "langganan.html", context)

def show_beli(request):
    context = {}
    return render(request, "pembelian.html", context)