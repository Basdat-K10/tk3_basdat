from django.shortcuts import render
from utils.query import query

# Create your views here.
def show_main(request):

    result = query("SELECT * FROM ulasan")  # Modify the SQL query as needed
    context = {'result': result} 
    return render(request, "main.html", context)