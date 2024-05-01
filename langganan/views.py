from django.shortcuts import render
from utils.query import query
# Create your views here.

def show_paket(request):
    
   
    context = {}
    return render(request, "langganan.html", context)