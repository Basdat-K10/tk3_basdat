from django.shortcuts import render, redirect
from django.db import connection
from django.contrib.auth.decorators import login_required

def execute_sql(query, params=None):
    with connection.cursor() as cursor:
        cursor.execute(query, params)
        if query.strip().lower().startswith('select'):
            return cursor.fetchall()
        else:
            return None

def show_daftar_favorit(request):
    return render(request, "daftar_favorit.html")

def show_daftar(request):
    return render(request, "daftar.html")

# READ list daftar favorit
def list_daftar_favorit(request):
    logged_in_user = request.session["username"]
    query = 'SELECT timestamp, username, judul FROM daftar_favorit WHERE username = %s'
    daftar_favorit = execute_sql(query, [logged_in_user])
    print(logged_in_user)
    return render(request, 'daftar.html', {'daftar_favorit': daftar_favorit})

# @login_required
# def list_daftar_favorit(request):
#     print(request.session.username)
#     logged_in_user = request.user.username
#     query = 'SELECT timestamp, username, judul FROM daftar_favorit WHERE username = %s'
#     daftar_favorit = execute_sql(query, [logged_in_user])
#     return render(request, 'daftar.html', {'daftar_favorit': daftar_favorit})

# DELETE list daftar favorit
def delete_daftar_favorit(request, timestamp, username):
    query = 'DELETE FROM daftar_favorit WHERE timestamp = %s AND username = %s'
    execute_sql(query, [timestamp, username])
    return redirect('list_daftar_favorit')

# READ isi daftar favorit (judul tayangan)
def list_isi_daftar_favorit(request, timestamp, username):
    query = '''
    SELECT t.judul 
    FROM tayangan t
    JOIN tayangan_memiliki_daftar_favorit tf ON t.id = tf.id_tayangan
    WHERE tf.timestamp = %s AND tf.username = %s
    '''
    isi_daftar_favorit = execute_sql(query, [timestamp, username])
    return render(request, 'daftar_favorit.html', {'isi_daftar_favorit': isi_daftar_favorit})

# DELETE isi daftar favorit
def delete_isi_daftar_favorit(request, id_tayangan, timestamp, username):
    query = 'DELETE FROM tayangan_memiliki_daftar_favorit WHERE id_tayangan = %s AND timestamp = %s AND username = %s'
    execute_sql(query, [id_tayangan, timestamp, username])
    return redirect('list_isi_daftar_favorit', timestamp=timestamp, username=username)
