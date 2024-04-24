-- Penggguna
CREATE TABLE PENGGUNA (
    username VARCHAR(50) PRIMARY KEY,
    password VARCHAR(50) NOT NULL,
    id_tayangan UUID REFERENCES TAYANGAN(id)
);

-- Paket
CREATE TABLE PAKET (
    nama VARCHAR(50) PRIMARY KEY,
    harga INT NOT NULL CHECK (harga >= 0),
    resolusi_layar VARCHAR(50) NOT NULL
);

-- Cukungan Perangkat
CREATE TABLE DUKUNGAN_PERANGKAT (
    nama_paket VARCHAR(50) REFERENCES PAKET(nama),
    dukungan_perangkat VARCHAR(50),
    PRIMARY KEY (nama_paket, dukungan_perangkat)
);

-- Transaksi 
CREATE TABLE TRANSACTION (
    username VARCHAR(50) REFERENCES PENGGUNA(username),
    start_date_time DATE,
    end_date_time DATE,
    nama_paket VARCHAR(50) REFERENCES PAKET(nama),
    metode_pembayaran VARCHAR(50) NOT NULL,
    timestamp_pembayaran TIMESTAMP NOT NULL,
    PRIMARY KEY (username, start_date_time)
);

-- Contributor
CREATE TABLE CONTRIBUTORS (
    id UUID PRIMARY KEY,
    nama VARCHAR(50) NOT NULL,
    jenis_kelamin INT NOT NULL CHECK (jenis_kelamin IN (0, 1)),
    kewarganegaraan VARCHAR(50) NOT NULL
);


-- Penulis Skenario
CREATE TABLE PENULIS_SKENARIO (
    id UUID PRIMARY KEY,
    FOREIGN KEY (id) REFERENCES CONTRIBUTORS(id)
);


-- Pemain
CREATE TABLE PEMAIN (
    id UUID PRIMARY KEY,
    FOREIGN KEY (id) REFERENCES CONTRIBUTORS(id)
);

-- Sutradara
CREATE TABLE SUTRADARA (
    id UUID PRIMARY KEY,
    FOREIGN KEY (id) REFERENCES CONTRIBUTORS(id)
);

-- Tayangan
CREATE TABLE TAYANGAN (
    id UUID PRIMARY KEY,
    judul VARCHAR(100) NOT NULL,
    sinopsis VARCHAR(255) NOT NULL,
    asal_negara VARCHAR(50) NOT NULL,
    sinopsis_trailer VARCHAR(255) NOT NULL,
    url_video_trailer VARCHAR(255) NOT NULL,
    release_date_trailer DATE NOT NULL,
    id_sutradara UUID REFERENCES CONTRIBUTORS(id)
);

-- Memainkan Tayangan
CREATE TABLE MEMAINKAN_TAYANGAN (
    id_tayangan UUID,
    id_pemain UUID,
    PRIMARY KEY (id_tayangan, id_pemain),
    FOREIGN KEY (id_tayangan) REFERENCES TAYANGAN(id),
    FOREIGN KEY (id_pemain) REFERENCES CONTRIBUTORS(id)
);


-- Menulis Skenario Tayangan
CREATE TABLE MENULIS_SKENARIO_TAYANGAN (
    id_tayangan UUID,
    id_penulis_skenario UUID,
    PRIMARY KEY (id_tayangan, id_penulis_skenario),
    FOREIGN KEY (id_tayangan) REFERENCES TAYANGAN(id),
    FOREIGN KEY (id_penulis_skenario) REFERENCES CONTRIBUTORS(id)
);

-- Genre Tayangan 
CREATE TABLE GENRE_TAYANGAN (
    id_tayangan UUID,
    genre VARCHAR(50),
    PRIMARY KEY (id_tayangan, genre),
    FOREIGN KEY (id_tayangan) REFERENCES TAYANGAN(id)
);

-- Perusahaan Produksi
CREATE TABLE PERUSAHAAN_PRODUKSI (
    nama VARCHAR(100) PRIMARY KEY
);

-- Persetujuan
CREATE TABLE PERSETUJUAN (
    nama VARCHAR(100),
    id_tayangan UUID,
    tanggal_persetujuan DATE,
    durasi INT NOT NULL CHECK (durasi >= 0),
    biaya INT NOT NULL CHECK (biaya >= 0),
    tanggal_mulai_penayangan DATE,
    PRIMARY KEY (nama, id_tayangan, tanggal_persetujuan),
    FOREIGN KEY (nama) REFERENCES PERUSAHAAN_PRODUKSI(nama),
    FOREIGN KEY (id_tayangan) REFERENCES TAYANGAN(id)
);

-- Series
CREATE TABLE SERIES (
    id_tayangan UUID PRIMARY KEY,
    FOREIGN KEY (id_tayangan) REFERENCES TAYANGAN(id)
);

-- Film
CREATE TABLE FILM (
    id_tayangan UUID PRIMARY KEY REFERENCES TAYANGAN(id),
    url_video_film VARCHAR(255) NOT NULL,
    release_date_film DATE NOT NULL,
    durasi_film INT NOT NULL DEFAULT 0
);

-- Episode
CREATE TABLE EPISODE (
    id_series UUID,
    sub_judul VARCHAR(100),
    sinopsis VARCHAR(255) NOT NULL,
    durasi INT NOT NULL DEFAULT 0,
    url_video VARCHAR(255) NOT NULL,
    release_date DATE NOT NULL,
    PRIMARY KEY (id_series, sub_judul),
    FOREIGN KEY (id_series) REFERENCES SERIES(id)
);

-- Ulasan
CREATE TABLE ULASAN (
    id_tayangan UUID,
    username VARCHAR(50),
    timestamp TIMESTAMP,
    rating INT NOT NULL DEFAULT 0,
    deskripsi VARCHAR(255),
    PRIMARY KEY (id_tayangan, username, timestamp),
    FOREIGN KEY (id_tayangan) REFERENCES TAYANGAN(id),
    FOREIGN KEY (username) REFERENCES PENGGUNA(username)
);

-- Tayangan Memiliki Daftar Favorit
CREATE TABLE TAYANGAN_MEMILIKI_DAFTAR_FAVORIT (
    id_tayangan UUID,
    timestamp TIMESTAMP,
    username VARCHAR(50),
    PRIMARY KEY (id_tayangan, timestamp, username),
    FOREIGN KEY (id_tayangan) REFERENCES TAYANGAN(id),
    FOREIGN KEY (timestamp, username) REFERENCES DAFTAR_FAVORIT(timestamp, username)
);

-- Daftar Favorit
CREATE TABLE DAFTAR_FAVORIT (
    timestamp TIMESTAMP,
    username VARCHAR(50),
    judul VARCHAR(50) NOT NULL,
    PRIMARY KEY (timestamp, username),
    FOREIGN KEY (username) REFERENCES PENGGUNA(username)
);

-- Riwayat Nonton
CREATE TABLE RIWAYAT_NONTON (
    id_tayangan UUID,
    username VARCHAR(50),
    start_date_time TIMESTAMP,
    end_date_time TIMESTAMP NOT NULL,
    PRIMARY KEY (username, id_tayangan, start_date_time),
    FOREIGN KEY (id_tayangan) REFERENCES TAYANGAN(id),
    FOREIGN KEY (username) REFERENCES PENGGUNA(username)
);

-- Tayangan Terunduh
CREATE TABLE TAYANGAN_TERUNDUH (
    id_tayangan UUID,
    username VARCHAR(50),
    timestamp TIMESTAMP,
    PRIMARY KEY (id_tayangan, username, timestamp),
    FOREIGN KEY (id_tayangan) REFERENCES TAYANGAN(id),
    FOREIGN KEY (username) REFERENCES PENGGUNA(username)
);
