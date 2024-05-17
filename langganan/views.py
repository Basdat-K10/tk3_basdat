from django.shortcuts import redirect, render
from utils.query import query
# Create your views here.

def show_user_paket(request):
    if "username" not in request.session:
        print("Username not found in session")
        return redirect('/main/login/')
     
    username = request.session["username"]
    print(username)
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
            AND t.nama_paket IS NOT NULL
            AND t.end_date_time > CURRENT_DATE
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


def show_beli(request):
    context = {}
    return render(request, "pembelian.html", context)

def beli(request):

    nama_paket = request.POST.get('nama_paket')
    harga = request.POST.get('harga')
    resolusi_layar = request.POST.get('resolusi_layar')
    dukungan_perangkat = request.POST.get('dukungan_perangkat')
    metode_pembayaran = request.POST.get('metode_pembayaran')
    username = request.session["username"]
    
    subscription_check = query("""
        SELECT EXISTS (
            SELECT 1 FROM TRANSACTION
            WHERE username = %s
            AND DATE(timestamp_pembayaran) = CURRENT_DATE
        ) AS transaction_exists;
                              """, [username])
    
    subscription_exist = subscription_check[0]['transaction_exists']
    message = ""
    if not subscription_exist:
        query(f"""
              INSERT INTO TRANSACTION (username, start_date_time, end_date_time, nama_paket, metode_pembayaran, timestamp_pembayaran) 
                 VALUES ('{username}', CURRENT_DATE, CURRENT_DATE + INTERVAL '1 month', '{nama_paket}', '{metode_pembayaran}', CURRENT_TIMESTAMP);
            """)
        message = "Transaksi Berhasil"
        print(message)
    else:
        message = "Transaksi gagal"
        print(message)
    print(nama_paket)
    print(harga)
    print(resolusi_layar)
    print(dukungan_perangkat)
    print(metode_pembayaran)
    print(subscription_exist)

    context = {"message":message}
    return render(request, "beli.html", context)