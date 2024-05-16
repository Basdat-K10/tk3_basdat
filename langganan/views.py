from django.shortcuts import redirect, render
from utils.query import query
# Create your views here.

def show_user_paket(request):
    if "username" not in request.session:
        print("Username not found in session")
        return redirect('/main/login/')
     
    username = "SarahJohnson" # JANGAN LUPA DIGANTI
    print('username')
    user_paket = query("""
        SELECT 
            t.nama_paket,
            t.start_date_time,
            t.end_date_time,
            t.metode_pembayaran,
            t.timestamp_pembayaran,
            p.harga,
            p.resolusi_layar,
            STRING_AGG(dp.dukungan_perangkat, ', ') AS dukungan_perangkat
        FROM 
            TRANSACTION t
        JOIN 
            PAKET p ON t.nama_paket = p.nama
        JOIN 
            dukungan_perangkat AS dp ON p.nama = dp.nama_paket 
        WHERE 
            t.username = %s
        GROUP BY
            t.nama_paket,
            t.start_date_time,
            t.end_date_time,
            t.metode_pembayaran,
            t.timestamp_pembayaran,
            p.harga,
            p.resolusi_layar
        ORDER BY 
            t.timestamp_pembayaran DESC 
        LIMIT 1;       
    """, [username])
    
    all_paket = query("""
        SELECT
            p.nama,
            p.harga,
            p.resolusi_layar,
            STRING_AGG(dp.dukungan_perangkat, ', ') AS dukungan_perangkat
        FROM
            paket AS p
        LEFT JOIN
            dukungan_perangkat AS dp ON p.nama = dp.nama_paket
        GROUP BY
            p.nama, 
            p.harga, 
            p.resolusi_layar           
    """)

    transaction_history = query("""
        SELECT
            t.username,
            t.start_date_time,
            t.end_date_time,
            t.nama_paket,
            p.harga,
            t.metode_pembayaran,
            t.timestamp_pembayaran
        FROM
            TRANSACTION t
        JOIN
            PAKET p ON t.nama_paket = p.nama
        WHERE
            t.username = %s
        ORDER BY
            t.start_date_time DESC;
        """, [username])


    context = {"user_paket": user_paket[0] if user_paket else None, "all_paket":all_paket, "transaction_history":transaction_history}
    return render(request, "langganan.html", context)

def show_paket(request):
    context = {}
    return render(request, "langganan.html", context)

def show_beli(request):
    context = {}
    return render(request, "pembelian.html", context)