from django import forms

class CustomRegistrationForm(forms.Form):
    username = forms.CharField(max_length=50)
    password = forms.CharField(widget=forms.PasswordInput, max_length=50) 
    negara_asal = forms.CharField(max_length=50)
