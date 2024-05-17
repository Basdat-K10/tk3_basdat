from django.shortcuts import render, redirect
from django.contrib.auth import authenticate, login, logout
from django.contrib import messages
from django.http import HttpResponseRedirect
from django.urls import reverse
from django.db import connection
import datetime
from .forms import CustomRegistrationForm
from utils.query import query
        
def show_main(request):
    return render(request, "main.html")

def register(request):
    form = CustomRegistrationForm()

    if request.method == "POST":
        form = CustomRegistrationForm(request.POST)
        if form.is_valid():
            username = form.cleaned_data['username']
            password = form.cleaned_data['password']
            negara_asal = form.cleaned_data['negara_asal']

            try:
                query("INSERT INTO pengguna (username, password, negara_asal) VALUES (%s, %s, %s)", (username, password, negara_asal))
                messages.success(request, 'Your account has been successfully created!')
                return redirect('main:login')
            except Exception as e:
                messages.error(request, 'Register Failed: ' + str(e))

    context = {'form': form}
    return render(request, 'register.html', context)

def login_user(request):
    if request.method == 'POST':
        username = request.POST.get('username')
        password = request.POST.get('password')

        user_record = query("SELECT * FROM pengguna WHERE username = %s AND password = %s", [username, password])

        if user_record:
            request.session['username'] = username
            request.session['last_login'] = str(datetime.datetime.now())
            
            response = HttpResponseRedirect(reverse("main:show_main"))
            response.set_cookie('last_login', str(datetime.datetime.now()))
            return response
        else:
            messages.info(request, 'Sorry, incorrect username or password. Please try again.')

    context = {}
    return render(request, 'login.html', context)

def logout_user(request):
    response = HttpResponseRedirect(reverse('main:show_main'))
    response.delete_cookie('last_login')
    request.session.flush()
    return response
