# tk3_basdat

## How to use environment variables in Python
1. Buat file `.env` di root project
2. Isi file `.env` dengan format `user=username buat postgres dan password=password buat postgres`
'''
user=postgres
password=password
'''

ini karena di utils.py kita menggunakan `os.getenv` untuk mengambil nilai dari environment variable `user` dan `password` yang kita buat di file `.env`