from django import forms

class CustomRegistrationForm(forms.Form):
    username = forms.CharField(required=True)
    password = forms.CharField(widget=forms.PasswordInput, required=True)
    negara_asal = forms.CharField(required=True)
