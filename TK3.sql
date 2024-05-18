
-- Schema
CREATE SCHEMA PACILFLIX;

SET SEARCH_PATH TO PACILFLIX;

-- Pengguna
CREATE TABLE PENGGUNA (
    username VARCHAR(50) PRIMARY KEY,
    password VARCHAR(50) NOT NULL,
negara_asal VARCHAR(50) NOT NULL
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
    FOREIGN KEY (id_series) REFERENCES SERIES(id_tayangan)
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

-- INSERT
INSERT INTO PENGGUNA VALUES ('SarahJohnson','J0hnson!Sarah','Indonesia'),
	('MichaelSmith','Sm1th2024!','Amerika Serikat'),
	('EmilyGarcia','Garcia#Em1ly','Indonesia'),
	('JamesNguyen','Nguy3nP@ssword','Indonesia'),
	('SophiaMartinez','M@rtinez123!','Amerika Serikat'),
	('DavidKim','K1m!David','Amerika Serikat'),
	('OliviaLopez','L0pezPwd456','Jepang'),
	('EthanPatel','P@telEthan007','Jepang');

INSERT INTO PAKET VALUES ('Basic',60000.0,'720p'),
	('Standar',80000.0,'1080p'),
	('Premium',120000.0,'4K');

INSERT INTO DUKUNGAN_PERANGKAT VALUES ('Premium','Televisi'),
	('Premium','Komputer'),
	('Premium','Telepon genggam'),
	('Premium','Tablet'),
	('Standar','Komputer'),
	('Standar','Telepon genggam'),
	('Standar','Tablet'),
	('Basic','Telepon genggam');

INSERT INTO TRANSACTION VALUES ('SarahJohnson','2024-01-01 00:00:00','2024-02-01 00:00:00','Basic','Kartu Kredit','2024-01-01 09:23:47'),
	('MichaelSmith','2024-01-02 00:00:00','2024-02-02 00:00:00','Standar','Transfer Bank','2024-01-02 14:57:32'),
	('EmilyGarcia','2024-01-02 00:00:00','2024-02-02 00:00:00','Premium','Kartu Kredit','2024-01-02 21:10:15'),
	('JamesNguyen','2024-01-03 00:00:00','2024-02-03 00:00:00','Premium','Transfer Bank','2024-01-03 08:45:59'),
	('SophiaMartinez','2024-01-05 00:00:00','2024-02-05 00:00:00','Basic','Transfer Bank','2024-01-05 12:30:28'),
	('DavidKim','2024-01-05 00:00:00','2024-02-05 00:00:00','Basic','Kartu Kredit','2024-01-05 18:02:51'),
	('OliviaLopez','2024-01-07 00:00:00','2024-02-07 00:00:00','Standar','Transfer Bank','2024-01-07 10:11:04'),
	('EthanPatel','2024-01-08 00:00:00','2024-02-08 00:00:00','Premium','Kartu Kredit','2024-01-08 16:49:37'),
	('SarahJohnson','2024-02-02 00:00:00','2024-03-02 00:00:00','Standar','Transfer Bank','2024-02-02 07:58:12'),
	('MichaelSmith','2024-02-03 00:00:00','2024-03-03 00:00:00','Premium','Kartu Kredit','2024-02-03 13:24:59'),
	('EmilyGarcia','2024-02-04 00:00:00','2024-03-04 00:00:00','Standar','Transfer Bank','2024-02-04 19:37:41'),
	('JamesNguyen','2024-02-05 00:00:00','2024-03-05 00:00:00','Premium','Kartu Kredit','2024-02-05 11:05:28'),
	('SophiaMartinez','2024-02-06 00:00:00','2024-03-06 00:00:00','Standar','Transfer Bank','2024-02-06 14:40:53'),
	('DavidKim','2024-02-07 00:00:00','2024-03-07 00:00:00','Premium','Transfer Bank','2024-02-07 20:16:47'),
	('OliviaLopez','2024-02-08 00:00:00','2024-03-08 00:00:00','Basic','Kartu Kredit','2024-02-08 09:29:38'),
	('EthanPatel','2024-02-09 00:00:00','2024-03-09 00:00:00','Standar','Transfer Bank','2024-02-09 17:12:25'),
	('SarahJohnson','2024-03-03 00:00:00','2024-04-03 00:00:00','Premium','Kartu Kredit','2024-03-03 08:21:09'),
	('MichaelSmith','2024-03-04 00:00:00','2024-04-04 00:00:00','Standar','Transfer Bank','2024-03-04 15:03:55'),
	('EmilyGarcia','2024-03-05 00:00:00','2024-04-05 00:00:00','Basic','Transfer Bank','2024-03-05 11:49:26'),
	('JamesNguyen','2024-03-06 00:00:00','2024-04-06 00:00:00','Standar','Kartu Kredit','2024-03-06 17:28:10'),
	('SophiaMartinez','2024-03-07 00:00:00','2024-04-07 00:00:00','Basic','Transfer Bank','2024-03-07 09:04:37'),
	('DavidKim','2024-03-08 00:00:00','2024-04-08 00:00:00','Standar','Kartu Kredit','2024-03-08 14:50:58'),
	('OliviaLopez','2024-03-09 00:00:00','2024-04-09 00:00:00','Premium','Transfer Bank','2024-03-09 19:27:22'),
	('EthanPatel','2024-03-10 00:00:00','2024-04-10 00:00:00','Premium','Kartu Kredit','2024-03-10 12:15:46');

INSERT INTO CONTRIBUTORS VALUES ('a0c56158-0b9a-4959-86a8-f42ebf615f72','Han Jin-won',0.0,'Korea'),
	('8a8e0a4a-e0e8-47a4-8cfa-2f3e5146c9b3','Robert D. Siegel',0.0,'Amerika Serikat'),
	('80fe542a-6419-4cf6-aadc-9e91acd0fb6b','Simon Pegg',0.0,'Inggris'),
	('5a9586c7-6d87-4466-9431-6510b5c6704d','Cassandra Massardi',1.0,'Indonesia'),
	('a67699bb-06fc-4648-91c1-4b8da0423f23','Jenny Jusuf',1.0,'Indonesia'),
	('04942df9-17b5-45e9-bdf5-ba7426d3cb93','Mufti S. Nur Arifin',1.0,'Indonesia'),
	('ea903189-ce73-4a8b-b68a-88d6c6f28b5f','Dono Prasetyo',0.0,'Indonesia'),
	('f04be734-30e7-4c07-ab7a-86996a762737','Gindung Wiradhika',0.0,'Indonesia'),
	('4eb18e01-c4a9-4507-8149-5e6456c68652','Wisnu Sasongko',0.0,'Indonesia'),
	('3e2f882c-b969-4194-ae22-88b49a6c67d4','Kaya Scodelario',1.0,'Austria'),
	('303ee247-b1f0-4c68-8626-69f8ea031020','Daniel Ings',1.0,'Azerbaijan'),
	('0097cea1-ff11-43e0-a55b-c49ff8843cf9','Joely Richardson',0.0,'Bahamas'),
	('d77acf7b-4f3f-4d56-be09-d41c12d51ef6','Vinnie Jones',1.0,'Bahrain'),
	('9ea7d339-3610-4178-a15c-fc759c6a8f1b','Ivan Atkinson',0.0,'Bangladesh'),
	('2116de0f-033d-4d10-bcbf-62f569d7f812','Tatsuya Endo',0.0,'Barbados'),
	('1a55c27c-51e4-47de-8784-843e02f9c5d7','Kwon Hye Joo',0.0,'Belarus'),
	('5be07994-1f75-4bee-9029-488843ed67ef','Jed Mercurio',0.0,'Belgium'),
	('bbde825e-8ffc-48ec-b266-3a4fb083bebd','Anna Winger',1.0,'Belize'),
	('28fb91fb-bdb3-4dc1-84de-68267163a016','Theo James',0.0,'Benin'),
	('ea446bd8-e0d4-4300-9344-215d9b32afe2','Alex Organ',0.0,'Bhutan'),
	('8f1651f7-d958-4f79-8986-400f0dbd3e27','Kim Tae Hee',0.0,'Bolivia'),
	('13862068-0100-442c-abe0-caf4a6df77a9','Richard Madden',0.0,'Bosnia Herzegovina'),
	('0075b1df-3b0e-4a34-a889-9761ebf4e3f6','Shira Haas',1.0,'Botswana'),
	('a39d2976-33ca-4990-b10f-9e1bdb8934b7','Raditya Dika',0.0,'Indonesia'),
	('0b0fe17b-0229-4cdf-965f-463b42a9d78f','Makoto Shinkai',0.0,'Jepang'),
	('538e63b0-175e-4fea-86ed-209eedd6134e','Bong Joon-Ho',0.0,'Korea'),
	('36587951-fcc6-439a-b102-76bf5567500a','Christopher McQuarrie',0.0,'Amerika Serikat'),
	('4660ec2a-7b10-4c34-b70d-a1d4a331a82b','John Lee Hancock',0.0,'Amerika Serikat'),
	('d2800b0a-a4af-4b43-9318-52d7256af100','Guy Ritchie',0.0,'Cambodia'),
	('47a83787-d32a-4199-9c02-1e757abae6b1','Kazuhiro Furuhashi',0.0,'Cameroon'),
	('311b4875-5a52-49a4-adb4-08d8c01baf4e','Yoo Je-won',0.0,'Canada'),
	('d42149b9-56cb-4b70-9c6d-5e79894ff157','John Strickland',0.0,'Indonesia'),
	('9037041b-9f2f-4d5e-a421-5386e102cd0b','Maria Schrader',1.0,'Indonesia'),
	('c85dab44-d745-4a3b-8848-0fc85819f893','Edgar Wright',0.0,'Inggris'),
	('0b111877-06ef-4e42-afe7-42edab9c60df','Angga Dwimas Sasongko',0.0,'Indonesia'),
	('66dbc37b-63fc-4896-8012-185b510e3541','Wregas Bhanuteja',0.0,'Indonesia'),
	('d108615f-8650-4da3-afa3-c640651178e6','Song Kang-ho',0.0,'Korea'),
	('e528daaa-8d6b-4fdd-aad7-4a2737a8d595','Lee Sun-kyun',0.0,'Korea'),
	('edb6a44a-3608-4d05-8b6e-33694b8cfb69','Cho Yeo-jeong',0.0,'Korea'),
	('736a3429-487e-42e4-9ccc-ddc281343b2d','Choi Woo-shik',0.0,'Korea'),
	('8cd7f068-fbfb-4cea-b78e-52a7ec2e3c06','Tom Cruise',0.0,'Amerika Serikat'),
	('cec2653a-42d3-4d0a-b186-d946584b9c15','Rebecca Ferguson',1.0,'Swedia'),
	('218b86d5-6355-4718-80da-c1031ba1547f','Michael Keaton',0.0,'Amerika Serikat'),
	('bdab0a01-bae4-4689-9dea-658fac980837','Nick Offerman',0.0,'Amerika Serikat'),
	('72a99571-ef27-43f4-af61-1767a682e11c','John Carrol Lynch',0.0,'Amerika Serikat'),
	('fe2d97fd-2981-4d08-804f-35eac3a68ea2','Ryunosuke Kamiki',0.0,'Jepang'),
	('bb461b55-2161-40e3-87b4-fac760b61ea3','Masami Nagasawa',1.0,'Jepang'),
	('1e864d4c-7486-405b-85b8-e643e6cf3491','Nana Mori',1.0,'Jepang'),
	('588773b7-1a57-42ab-af61-a31775a783a5','Kotarou Daigo',0.0,'Jepang'),
	('47d158cb-6903-41ba-9b3e-91faf912be91','Ayane Sakura',1.0,'Jepang'),
	('adc03467-0f47-469f-bba9-b71ad7de5310','Nick Frost',0.0,'Inggris'),
	('4a4a288c-04db-45bc-b992-8e9d4787bfce','Ine Febriyanti',1.0,'Indonesia'),
	('1419a6c3-f4a9-4811-bb06-de14bb7bac3c','Angga Yunanda',0.0,'Indonesia'),
	('b2fb8eb5-967f-46eb-8557-cef9423cd8b0','Prilly Latuconsina',1.0,'Indonesia'),
	('08b82aa2-c8c6-45cf-a51e-0c682c4f04d0','Dwi Sasono',0.0,'Indonesia'),
	('1c2dd268-3cf4-4058-ac2b-7221a09acbd5','Sheila Dara Aisha',1.0,'Indonesia'),
	('9a17bb21-3c71-410a-82f0-e002052fe355','Rio Dewanto',0.0,'Indonesia'),
	('1546f5ba-d5ac-447b-84b9-b531c86b5826','Rachel Amanda',1.0,'Indonesia'),
	('94602227-2a68-4ffc-8c70-fbbdccbc0383','Sheryl Sheinafia',1.0,'Indonesia'),
	('3173cb80-438a-4832-a37c-12df4ba1af10','Acha Septriasa',1.0,'Indonesia'),
	('a00fcc18-48f0-4e9c-bbc2-fb2cb9837e0d','Christoffer Nelwan',0.0,'Indonesia'),
	('1d195034-818b-46a2-a8c6-2e0c1e1daf1d','Julian Liberty',0.0,'Indonesia'),
	('c288f5d0-0eb4-4286-ad1b-c5f065d52ae0','Matthew Read',0.0,'Georgia'),
	('545dff8a-6617-47b6-b9b1-943fbbb867ee','Stuart Carolan',1.0,'Germany'),
	('5fd0002b-f9d9-4fc8-8446-a6f0423c1456','John Jackson',1.0,'Ghana'),
	('a8fca10d-f338-45e2-af92-e1b99d62b147','Haleema Mirza',1.0,'Indonesia'),
	('2fe77a60-48f9-47ea-b5df-5cdd15f0932a','Billy Mason Wood',0.0,'Austria'),
	('c2449238-1db5-4964-8568-83eba695efa4','Theo Mason Wood',1.0,'Azerbaijan'),
	('eda9e1a3-4697-457c-beec-2bc988837030','Lee Kyoo hyung',0.0,'Bahamas'),
	('9538fe85-5ff1-4953-9e18-e540c3b89e2d','Ko Bo gyeol',1.0,'Bahrain'),
	('efb93539-acf5-461a-9449-861a2a5017a5','Seo Woo Jin',0.0,'Bangladesh'),
	('3d5f174c-938c-4fff-9544-b4066e5363e1','Shin Dong mi',1.0,'Barbados'),
	('64835e33-dd98-42d4-bc04-19eea3365467','Oh Eui SIk',0.0,'Belarus'),
	('c9a16a5b-8fd4-4bf2-aa08-5605b1560717','Yoon Sa Bong',1.0,'Belgium'),
	('8b64fc11-0567-4951-9961-a38736cfaa88','Kim Mi Kyung',0.0,'Belize'),
	('9cfc1f06-6ba7-41b3-93dc-eb74f54c573f','Sophie Rundle',1.0,'Benin'),
	('9115a51f-67fb-412f-8a9e-296ed15a8f8c','Vincent Franklin',1.0,'Bhutan'),
	('4babda89-8eea-4df9-97ec-083bbe53a7ab','Ash Tandon',1.0,'Bolivia'),
	('52b158f1-f9b2-4450-b7d7-fbcaa860a9b3','Daniel Hendler',0.0,'Bosnia Herzegovina'),
	('ff8b4f1e-9ebb-400c-9232-506f19b65413','Alexa Karolinski',0.0,'Botswana'),
	('15d6d494-2aa8-405b-9003-b097a05b07d9','Deborah Feldman',0.0,'Indonesia'),
	('679ab0d0-a1bd-47f8-9eee-d999e045df96','Ayumu Hisao',1.0,'Jepang'),
	('2d3ec8d1-3c9f-46aa-93db-2992ca65f05b','Tomomi Kawaguchi',1.0,'Jepang'),
	('6d589816-ce75-4886-9fe7-37222dc8e13b','Rino Yamazaki',0.0,'Jepang'),
	('a1127d3b-c1bb-412c-95fa-eff86764f0aa','Kazuhiro Furuhashi',0.0,'Jepang');

INSERT INTO PENULIS_SKENARIO VALUES ('538e63b0-175e-4fea-86ed-209eedd6134e'),
	('a0c56158-0b9a-4959-86a8-f42ebf615f72'),
	('36587951-fcc6-439a-b102-76bf5567500a'),
	('8a8e0a4a-e0e8-47a4-8cfa-2f3e5146c9b3'),
	('0b0fe17b-0229-4cdf-965f-463b42a9d78f'),
	('80fe542a-6419-4cf6-aadc-9e91acd0fb6b'),
	('c85dab44-d745-4a3b-8848-0fc85819f893'),
	('5a9586c7-6d87-4466-9431-6510b5c6704d'),
	('66dbc37b-63fc-4896-8012-185b510e3541'),
	('a67699bb-06fc-4648-91c1-4b8da0423f23'),
	('0b111877-06ef-4e42-afe7-42edab9c60df'),
	('04942df9-17b5-45e9-bdf5-ba7426d3cb93'),
	('ea903189-ce73-4a8b-b68a-88d6c6f28b5f'),
	('a39d2976-33ca-4990-b10f-9e1bdb8934b7'),
	('f04be734-30e7-4c07-ab7a-86996a762737'),
	('4eb18e01-c4a9-4507-8149-5e6456c68652'),
	('9ea7d339-3610-4178-a15c-fc759c6a8f1b'),
	('2116de0f-033d-4d10-bcbf-62f569d7f812'),
	('1a55c27c-51e4-47de-8784-843e02f9c5d7'),
	('5be07994-1f75-4bee-9029-488843ed67ef'),
	('bbde825e-8ffc-48ec-b266-3a4fb083bebd'),
	('c288f5d0-0eb4-4286-ad1b-c5f065d52ae0'),
	('545dff8a-6617-47b6-b9b1-943fbbb867ee'),
	('5fd0002b-f9d9-4fc8-8446-a6f0423c1456'),
	('a8fca10d-f338-45e2-af92-e1b99d62b147'),
	('2fe77a60-48f9-47ea-b5df-5cdd15f0932a'),
	('c2449238-1db5-4964-8568-83eba695efa4'),
	('52b158f1-f9b2-4450-b7d7-fbcaa860a9b3'),
	('ff8b4f1e-9ebb-400c-9232-506f19b65413'),
	('15d6d494-2aa8-405b-9003-b097a05b07d9'),
	('679ab0d0-a1bd-47f8-9eee-d999e045df96'),
	('2d3ec8d1-3c9f-46aa-93db-2992ca65f05b'),
	('6d589816-ce75-4886-9fe7-37222dc8e13b'),
	('a1127d3b-c1bb-412c-95fa-eff86764f0aa');

INSERT INTO PEMAIN VALUES ('fe2d97fd-2981-4d08-804f-35eac3a68ea2'),
	('edb6a44a-3608-4d05-8b6e-33694b8cfb69'),
	('e528daaa-8d6b-4fdd-aad7-4a2737a8d595'),
	('d108615f-8650-4da3-afa3-c640651178e6'),
	('cec2653a-42d3-4d0a-b186-d946584b9c15'),
	('c85dab44-d745-4a3b-8848-0fc85819f893'),
	('bdab0a01-bae4-4689-9dea-658fac980837'),
	('bb461b55-2161-40e3-87b4-fac760b61ea3'),
	('b2fb8eb5-967f-46eb-8557-cef9423cd8b0'),
	('adc03467-0f47-469f-bba9-b71ad7de5310'),
	('a39d2976-33ca-4990-b10f-9e1bdb8934b7'),
	('a00fcc18-48f0-4e9c-bbc2-fb2cb9837e0d'),
	('9a17bb21-3c71-410a-82f0-e002052fe355'),
	('94602227-2a68-4ffc-8c70-fbbdccbc0383'),
	('8cd7f068-fbfb-4cea-b78e-52a7ec2e3c06'),
	('80fe542a-6419-4cf6-aadc-9e91acd0fb6b'),
	('736a3429-487e-42e4-9ccc-ddc281343b2d'),
	('72a99571-ef27-43f4-af61-1767a682e11c'),
	('588773b7-1a57-42ab-af61-a31775a783a5'),
	('4a4a288c-04db-45bc-b992-8e9d4787bfce'),
	('47d158cb-6903-41ba-9b3e-91faf912be91'),
	('3173cb80-438a-4832-a37c-12df4ba1af10'),
	('218b86d5-6355-4718-80da-c1031ba1547f'),
	('1e864d4c-7486-405b-85b8-e643e6cf3491'),
	('1d195034-818b-46a2-a8c6-2e0c1e1daf1d'),
	('1c2dd268-3cf4-4058-ac2b-7221a09acbd5'),
	('1546f5ba-d5ac-447b-84b9-b531c86b5826'),
	('1419a6c3-f4a9-4811-bb06-de14bb7bac3c'),
	('08b82aa2-c8c6-45cf-a51e-0c682c4f04d0'),
	('28fb91fb-bdb3-4dc1-84de-68267163a016'),
	('ea446bd8-e0d4-4300-9344-215d9b32afe2'),
	('8f1651f7-d958-4f79-8986-400f0dbd3e27'),
	('13862068-0100-442c-abe0-caf4a6df77a9'),
	('0075b1df-3b0e-4a34-a889-9761ebf4e3f6'),
	('3e2f882c-b969-4194-ae22-88b49a6c67d4'),
	('303ee247-b1f0-4c68-8626-69f8ea031020'),
	('0097cea1-ff11-43e0-a55b-c49ff8843cf9'),
	('d77acf7b-4f3f-4d56-be09-d41c12d51ef6'),
	('eda9e1a3-4697-457c-beec-2bc988837030'),
	('9538fe85-5ff1-4953-9e18-e540c3b89e2d'),
	('efb93539-acf5-461a-9449-861a2a5017a5'),
	('3d5f174c-938c-4fff-9544-b4066e5363e1'),
	('64835e33-dd98-42d4-bc04-19eea3365467'),
	('c9a16a5b-8fd4-4bf2-aa08-5605b1560717'),
	('8b64fc11-0567-4951-9961-a38736cfaa88'),
	('9cfc1f06-6ba7-41b3-93dc-eb74f54c573f'),
	('9115a51f-67fb-412f-8a9e-296ed15a8f8c'),
	('4babda89-8eea-4df9-97ec-083bbe53a7ab');

INSERT INTO SUTRADARA VALUES ('d2800b0a-a4af-4b43-9318-52d7256af100'),
	('47a83787-d32a-4199-9c02-1e757abae6b1'),
	('311b4875-5a52-49a4-adb4-08d8c01baf4e'),
	('d42149b9-56cb-4b70-9c6d-5e79894ff157'),
	('9037041b-9f2f-4d5e-a421-5386e102cd0b'),
	('538e63b0-175e-4fea-86ed-209eedd6134e'),
	('36587951-fcc6-439a-b102-76bf5567500a'),
	('4660ec2a-7b10-4c34-b70d-a1d4a331a82b'),
	('0b0fe17b-0229-4cdf-965f-463b42a9d78f'),
	('c85dab44-d745-4a3b-8848-0fc85819f893'),
	('66dbc37b-63fc-4896-8012-185b510e3541'),
	('0b111877-06ef-4e42-afe7-42edab9c60df'),
	('a39d2976-33ca-4990-b10f-9e1bdb8934b7');

INSERT INTO TAYANGAN VALUES ('106ba113-3bf3-440d-8f4f-9fa2a5929d89','The Gentlemen','Saat Eddie si bangsawan mewarisi properti keluarga, ia mendapati bahwa tanah itu merupakan lokasi kerajaan ganja yang sangat besar—dan para pemiliknya tidak mau pergi.','Inggris','Sebuah serial yang menelusuri kisah para gangster di bawah dunia London yang penuh intrik dan kejahatan.','https://www.youtube.com/watch?v=wyEOwHrpZH4','2024-02-22 00:00:00','d2800b0a-a4af-4b43-9318-52d7256af100'),
	('405dc63e-0ea5-410f-93bb-6d41c130d82f','Spy X Family','Mata-mata, pembunuh, dan ahli telepati menyamar bersama sebagai satu keluarga. Mereka masing-masing punya alasan sendiri dan menutupi identitas asli dari satu sama lain.','Jepang','A spy on an undercover mission gets married and adopts a child as part of his cover. His wife and daughter have secrets of their own, and all three must strive to keep together.','https://www.youtube.com/watch?v=m5TxWbtQ7qU&pp=ygUUc3B5IHggZmFtaWx5IHRyYWlsZXI%3D','2020-10-05 00:00:00','47a83787-d32a-4199-9c02-1e757abae6b1'),
	('9a5ae86a-b6f1-4878-a84d-35970f4b0089','Hi Bye, Mama!','Seorang ibu yang telah meninggal kembali ke dunia sebagai hantu untuk menjadi dekat dengan putrinya.','Korea Selatan','Hi Bye, Mama! mengisahkan tentang perjalanan seorang ibu yang kembali dari kematian untuk bersama anaknya yang tercinta.','https://www.youtube.com/watch?v=1EWJt4L58UM&pp=ygUTaGkgYnllIG1hbWEgdHJhaWxlcg%3D%3D','2020-02-09 00:00:00','311b4875-5a52-49a4-adb4-08d8c01baf4e'),
	('5d2a09e7-5982-4ff8-98a5-4a43d7f197d9','Bodyguard','Seorang veteran perang yang dianugrahi perlindungan terhadap seorang politisi terkemuka.','Inggris','Bodyguard adalah thriller politik yang menegangkan, mengikuti perjuangan seorang pria untuk melindungi negara dan pemimpinnya.','https://www.youtube.com/watch?v=tLfLU6-9lxY&pp=ygURYm9keWd1YXJkIHRyYWlsZXI%3D','2022-04-02 00:00:00','d42149b9-56cb-4b70-9c6d-5e79894ff157'),
	('602b526d-1aad-4a1c-a71a-b19c8d00426e','Unorthodox','Seorang wanita muda yang melarikan diri dari komunitas Yahudi ultra-Ortodoks di Brooklyn, New York.','Jerman','Unorthodox adalah kisah yang menginspirasi tentang keberanian seorang wanita untuk menemukan kebebasan dan identitasnya.','https://www.youtube.com/watch?v=Nixgq1d5J7g&pp=ygUSdW5vcnRob2RveCB0cmFpbGVy','2022-04-27 00:00:00','9037041b-9f2f-4d5e-a421-5386e102cd0b'),
	('f2507d84-bfbf-42ab-8f05-c699f39aa198','Parasite','Keluarga Kim, yang hidup dalam kemiskinan, secara licik memanfaatkan keluarga Park yang kaya, memicu tragedi dan pertarungan kelas yang mengejutkan.','Korea Selatan','Trailer menunjukkan bagaimana keluarga Kim secara licik menyusup ke dalam kehidupan keluarga Park yang kaya, menghasilkan konflik kelas yang mengejutkan dan penuh ketegangan.','https://youtu.be/5xH0HfJHsaY?si=JthZJGbpYvfUyo7W','2019-08-15 00:00:00','538e63b0-175e-4fea-86ed-209eedd6134e'),
	('fc453357-f66f-4561-9dbc-a99b5508ff96','Mission Impossible : Rogue Nation','Kepala CIA Hunley (Baldwin) meyakinkan komite Senat untuk membubarkan IMF, di mana Ethan Hunt (Cruise) adalah anggota kuncinya. Hunley  Sekarang sendirian, Hunt mengejar organisasi jahat yang bayangan dan mematikan yang disebut Syndicate.','Amerika Serikat','Ethan dan tim menjalankan misi mereka yang paling mustahil dalam Mission: Impossible Rogue Nation.','https://youtu.be/pXwaKB7YOjw?si=ZWg0MlvzTSjN8lsV ','2015-03-23 00:00:00','36587951-fcc6-439a-b102-76bf5567500a'),
	('d9d422a0-6cc5-48dc-af5a-bcd4a47c561c','The Founder','Kisah nyata Ray Kroc, yang mengubah McDonald''s menjadi fenomena global, menggali kegigihan dan manipulasi dalam bisnis.','Amerika Serikat','Trailer menggambarkan Ray Kroc, seorang salesman yang mengubah McDonald''s menjadi franchise global, menyoroti ambisi dan taktiknya dalam mengambil alih bisnis.','https://www.youtube.com/watch?v=AX2uz2XYkbo&ab_channel=RottenTomatoesTrailers ','2016-04-21 00:00:00','4660ec2a-7b10-4c34-b70d-a1d4a331a82b'),
	('42a54d22-fa30-44c8-bfc0-2464157fa976','Kimi No Na Wa','Dua remaja yang tidak saling kenal secara misterius bertukar tubuh, menjalin hubungan melalui waktu dan ruang.','Jepang','Trailer ini memperkenalkan kisah Mitsuha dan Taki, dua remaja yang tidak saling kenal tetapi secara misterius bertukar tubuh dan mengeksplorasi bagaimana mereka menjalani kehidupan satu sama lain sambil mencoba memecahkan misteri di balik fenomena.','https://youtu.be/xU47nhruN-Q?si=NhvG-oQLt2RmuawF ','2016-10-06 00:00:00','0b0fe17b-0229-4cdf-965f-463b42a9d78f'),
	('8ee5ba0f-194f-42db-b5b5-5297b4da290b','Tenki No Ko','Hodaka melarikan diri ke Tokyo, bertemu Hina yang bisa mengendalikan cuaca, bersama mereka mencari tempat dalam dunia yang berubah.','Jepang','Trailer ini memperlihatkan Hodaka, seorang remaja yang melarikan diri ke Tokyo dan bertemu Hina, gadis yang bisa mengubah cuaca. Bersama, mereka mencari tempat mereka di dunia yang hujan terus-menerus.','https://youtu.be/Q6iK6DjV_iE?si=_Y1FtjA5WNSfFMam ','2019-07-23 00:00:00','0b0fe17b-0229-4cdf-965f-463b42a9d78f'),
	('fdfeda18-79b7-47e7-b5f8-541f9bd12f33','Shaun Of The Dead','Shaun mencoba mendapatkan kembali eksnya saat ia dan teman-temannya melawan invasi zombie di London.','Inggris','Trailer menampilkan Shaun yang berusaha menyelamatkan diri dan orang-orang terdekat dari serangan zombie di London, dengan banyak adegan komedi dan aksi.','https://youtu.be/LIfcaZ4pC-4?si=uK7FY3-qCzSKVyfQ ','2012-01-10 00:00:00','c85dab44-d745-4a3b-8848-0fc85819f893'),
	('bb770fb0-bd0d-4a91-ab68-1efe8fcdc2af','Budi Pekerti','Film ini mengeksplorasi bagaimana nilai-nilai kebajikan mempengaruhi kehidupan sehari-hari dan interaksi keluarga.','Indonesia','Trailer ini menunjukkan kisah Bu Prani, seorang guru bimbingan konseling yang menghadapi tantangan besar setelah video perselisihannya dengan pengunjung pasar menjadi viral, menyoroti perjuangan dalam menjaga integritas pribadi dan profesional.','https://www.youtube.com/watch?v=ir7i-QpMOHQ ','2023-10-05 00:00:00','66dbc37b-63fc-4896-8012-185b510e3541'),
	('e3d10264-d586-4852-b128-6f757c1667b4','Nanti Kita Cerita Tentang Hari Ini','Tiga saudara dan orang tua mereka menghadapi cobaan hidup yang mengungkap rahasia lama dan hubungan yang retak.','Indoesia','Trailer ini menggambarkan kisah tiga bersaudara yang berjuang dengan konflik keluarga dan rahasia yang terungkap, menunjukkan ketegangan dan emosi yang mendalam.','https://www.youtube.com/watch?v=TcHh986XvI4','2019-12-13 00:00:00','0b111877-06ef-4e42-afe7-42edab9c60df'),
	('a570abcb-3e59-4892-a22a-20e60a36f935','Koala Kumal','Setelah putus cinta, Dika berusaha menemukan cinta dan diri sendiri, menavigasi serangkaian peristiwa kocak.','Indonesia','Trailer ini menunjukkan kisah Dika yang patah hati setelah tunangannya selingkuh, dan perjalanannya untuk menyembuhkan hati dengan bantuan teman baru yang unik.','https://www.youtube.com/watch?v=Yv_9YvhLv8g','2016-06-11 00:00:00','a39d2976-33ca-4990-b10f-9e1bdb8934b7'),
	('024f92fb-7b6f-4120-a264-f87129f7f225','Marmut Merah Jambu','Dika mengingat kisah cintanya yang penuh warna dan kocak selama masa sekolah, penuh dengan petualangan dan kesalahpahaman.','Indonesia','Trailer ini mengisahkan Dika, yang menceritakan kembali pengalamannya di SMA termasuk cinta pertamanya, dan petualangan membentuk kelompok detektif remaja.','https://www.youtube.com/watch?v=VMQPfcXny-k','2014-04-16 00:00:00','a39d2976-33ca-4990-b10f-9e1bdb8934b7');
;
INSERT INTO SERIES VALUES ('106ba113-3bf3-440d-8f4f-9fa2a5929d89'),
	('405dc63e-0ea5-410f-93bb-6d41c130d82f'),
	('9a5ae86a-b6f1-4878-a84d-35970f4b0089'),
	('5d2a09e7-5982-4ff8-98a5-4a43d7f197d9'),
	('602b526d-1aad-4a1c-a71a-b19c8d00426e');

INSERT INTO FILM VALUES ('f2507d84-bfbf-42ab-8f05-c699f39aa198','https://youtu.be/nW54iazQjQs?si=NrSbRJ00ZIoAp6AD','2019-05-30 00:00:00',132.0),	('fc453357-f66f-4561-9dbc-a99b5508ff96','https://youtu.be/JP8sHgx4mFk?si=8tVsFcFjiWhm6wPa','2015-07-31 00:00:00',131.0),	('d9d422a0-6cc5-48dc-af5a-bcd4a47c561c','https://youtu.be/BcPxDxbYx5g?si=FCTe-nT4xVXRy19H','2016-12-07 00:00:00',115.0),
('42a54d22-fa30-44c8-bfc0-2464157fa976','https://youtu.be/aIQ-hrcWlRc?si=_7kku90Q0yeZNsM7','2016-08-26 00:00:00',112.0),
('8ee5ba0f-194f-42db-b5b5-5297b4da290b','https://youtu.be/8HGM3QJdZ0U?si=rg5ESkzGis3huxYD','2019-07-19 00:00:00',112.0),
('fdfeda18-79b7-47e7-b5f8-541f9bd12f33','https://youtu.be/IIHIpZNUPeE?si=9z61CnQVrgSbV9Zm','2004-09-24 00:00:00',99.0),
('bb770fb0-bd0d-4a91-ab68-1efe8fcdc2af','https://youtu.be/DC0VLH3JsK4?si=84jpp59RQkOHG6yh','2023-11-02 00:00:00',110.0),
('e3d10264-d586-4852-b128-6f757c1667b4','https://youtu.be/G_nGsZntUzg?si=OayZbYOy-8BELWNI','2020-02-27 00:00:00',104.0),
('a570abcb-3e59-4892-a22a-20e60a36f935','https://youtu.be/Ja8R_j6TDPA?si=0oq9qV_pkbQJQa61','2016-07-05 00:00:00',90.0),
('024f92fb-7b6f-4120-a264-f87129f7f225','https://youtu.be/8ZuOGOTkFWM?si=JqR-YRpMMLbPfhBh','2014-05-08 00:00:00',93.0);

INSERT INTO EPISODE VALUES ('106ba113-3bf3-440d-8f4f-9fa2a5929d89','Refined Aggression','When the Duke of Halstead dies, his second son inherits everything, including the title, house and grounds — plus a whole heap of trouble.',67.0,'https://www.youtube.com/watch?v=kF7Ns8IgvzA&pp=ygUXdGhlIGdlbnRsZW1lbiBlcGlzb2RlIDE%3D','2024-03-21 00:00:00'),
	('106ba113-3bf3-440d-8f4f-9fa2a5929d89','Tackle Tommy Woo Woo','The toffs and their gamekeeper hunt a new kind of prey. Susie enlists some help to clean up the mess, and Halstead Manor is blessed with a holy visitor.',63.0,'https://www.youtube.com/watch?v=C-jUJJydSPg&pp=ygUXdGhlIGdlbnRsZW1lbiBlcGlzb2RlIDI%3D','2024-03-28 00:00:00'),
	('106ba113-3bf3-440d-8f4f-9fa2a5929d89','Where''s My Weed At?','Jimmy gets distracted on the job. As supply chain issues delay deliveries, the Horniman brothers take a risky ride to placate a dissatisfied customer.',50.0,'https://www.youtube.com/watch?v=IcUkGjwvVS0&pp=ygUXdGhlIGdlbnRsZW1lbiBlcGlzb2RlIDM%3D','2024-04-06 00:00:00'),
	('405dc63e-0ea5-410f-93bb-6d41c130d82f','Operation Strix','Tasked with getting close to a high-ranking politician in a neighboring country, an elite spy adopts a young girl to strengthen his cover.',27.0,'https://www.youtube.com/watch?v=h_tL16PZ0IE&list=PLwLSw1_eDZl1wGMYg5oB3uEns0CZNl6sI&index=1&pp=iAQB','2022-04-12 00:00:00'),
	('405dc63e-0ea5-410f-93bb-6d41c130d82f','Secure a Wife','Needing someone to act as Anya''s mother for an interview at Eden College, Loid searches for a wife. He meets a beautiful young lady in a boutique.',28.0,'https://www.youtube.com/watch?v=NIgOI38wYzc&list=PLwLSw1_eDZl1wGMYg5oB3uEns0CZNl6sI&index=3&pp=iAQB','2022-04-19 00:00:00'),
	('405dc63e-0ea5-410f-93bb-6d41c130d82f','Prepare for the Entrance Exam','After Yor moves into the Forger house, Loid takes her and Anya on an outing so they can all learn how to conduct themselves as an upper-class family.',24.0,'https://www.youtube.com/watch?v=ziiXFMl2nto&list=PLwLSw1_eDZl1wGMYg5oB3uEns0CZNl6sI&index=5&pp=iAQB','2022-04-26 00:00:00'),
	('9a5ae86a-b6f1-4878-a84d-35970f4b0089','Life is Full of Unpredictable Surprises','Cha Yu-ri, a ghost for five years, realizes her daughter can see her. Just as she decides it''s time to move on, she is returned to her human form.',74.0,'https://www.youtube.com/watch?v=h9sLLN3HMo0&pp=ygUTaGkgYnllIG1hbWEgZXBpc29kZQ%3D%3D','2022-04-26 00:00:00'),
	('9a5ae86a-b6f1-4878-a84d-35970f4b0089','Forgotten Season','Cho Gang-hwa is shaken by the sight of Yu-ri, who''s got 49 days to find her rightful place. What''s more, Cho Seo-woo has gone missing.',69.0,'https://www.youtube.com/watch?v=Ta2xIzZz1aE&pp=ygUTaGkgYnllIG1hbWEgZXBpc29kZQ%3D%3D','2020-02-22 00:00:00'),
	('9a5ae86a-b6f1-4878-a84d-35970f4b0089','Realizing the Beauty of Life is Only Possible After Death','Gang-hwa isn''t sure how to reveal that he got remarried. Wanting to protect Seo-woo from lurking ghosts, Yu-ri eyes an opening at the preschool.',69.0,'https://www.youtube.com/watch?v=Ta2xIzZz1aE&pp=ygUTaGkgYnllIG1hbWEgZXBpc29kZQ%3D%3D','2020-02-29 00:00:00'),
	('5d2a09e7-5982-4ff8-98a5-4a43d7f197d9','Episode 1','Sgt. David Budd is promoted to a protection detail for UK Home Secretary Julia Montague, but he quickly clashes with the hawkish politician.',58.0,'https://www.youtube.com/watch?v=ETyjEDxdn0Y&pp=ygUbYm9keWd1YXJkIHNlc3JpZXMgZXBpc29kZSAx','2020-03-26 00:00:00'),
	('5d2a09e7-5982-4ff8-98a5-4a43d7f197d9','Episode 2','After an attempted attack on the school Budds kids attend, Montague worries about leaks in the department. But she may be in the line of fire herself.',59.0,'https://www.youtube.com/watch?v=kF7Ns8IgvzA&pp=ygUXdGhlIGdlbnRsZW1lbiBlcGlzb2RlIDE%3D','2020-04-03 00:00:00'),
	('602b526d-1aad-4a1c-a71a-b19c8d00426e','Part 1','Born and raised in a New York Hasidic community, Esty struggles after a fruitless first year of marriage. She runs away to Berlin and finds new freedom.',53.0,'https://www.youtube.com/watch?v=qglWf4y1aQg&pp=ygUadW5vcnRob2RveCBuZXRmbGl4IGVwaXNvZGU%3D','2020-03-26 00:00:00');

INSERT INTO GENRE_TAYANGAN VALUES ('f2507d84-bfbf-42ab-8f05-c699f39aa198','Drama'),
	('f2507d84-bfbf-42ab-8f05-c699f39aa198','Thriller'),
	('fc453357-f66f-4561-9dbc-a99b5508ff96','Action'),
	('fc453357-f66f-4561-9dbc-a99b5508ff96','Adventure'),
	('fc453357-f66f-4561-9dbc-a99b5508ff96','Thriller'),
	('d9d422a0-6cc5-48dc-af5a-bcd4a47c561c','Biography'),
	('d9d422a0-6cc5-48dc-af5a-bcd4a47c561c','Drama'),
	('d9d422a0-6cc5-48dc-af5a-bcd4a47c561c','History'),
	('42a54d22-fa30-44c8-bfc0-2464157fa976','Drama'),
	('42a54d22-fa30-44c8-bfc0-2464157fa976','Fantasy'),
	('42a54d22-fa30-44c8-bfc0-2464157fa976','Romance'),
	('8ee5ba0f-194f-42db-b5b5-5297b4da290b','Drama'),
	('8ee5ba0f-194f-42db-b5b5-5297b4da290b','Fantasy'),
	('fdfeda18-79b7-47e7-b5f8-541f9bd12f33','Comedy'),
	('fdfeda18-79b7-47e7-b5f8-541f9bd12f33','Horror'),
	('bb770fb0-bd0d-4a91-ab68-1efe8fcdc2af','Drama'),
	('bb770fb0-bd0d-4a91-ab68-1efe8fcdc2af','Family'),
	('e3d10264-d586-4852-b128-6f757c1667b4','Drama'),
	('e3d10264-d586-4852-b128-6f757c1667b4','Family'),
	('a570abcb-3e59-4892-a22a-20e60a36f935','Comedy'),
	('a570abcb-3e59-4892-a22a-20e60a36f935','Romance'),
	('024f92fb-7b6f-4120-a264-f87129f7f225','Comedy'),
	('024f92fb-7b6f-4120-a264-f87129f7f225','Drama'),
	('106ba113-3bf3-440d-8f4f-9fa2a5929d89','Crime'),
	('405dc63e-0ea5-410f-93bb-6d41c130d82f','Family'),
	('9a5ae86a-b6f1-4878-a84d-35970f4b0089','Drama'),
	('5d2a09e7-5982-4ff8-98a5-4a43d7f197d9','Action'),
	('602b526d-1aad-4a1c-a71a-b19c8d00426e','Drama');

INSERT INTO MENULIS_SKENARIO_TAYANGAN VALUES ('f2507d84-bfbf-42ab-8f05-c699f39aa198','538e63b0-175e-4fea-86ed-209eedd6134e'),	('f2507d84-bfbf-42ab-8f05-c699f39aa198','a0c56158-0b9a-4959-86a8-f42ebf615f72'),
('fc453357-f66f-4561-9dbc-a99b5508ff96','36587951-fcc6-439a-b102-76bf5567500a'),	('d9d422a0-6cc5-48dc-af5a-bcd4a47c561c','8a8e0a4a-e0e8-47a4-8cfa-2f3e5146c9b3'),
('42a54d22-fa30-44c8-bfc0-2464157fa976','0b0fe17b-0229-4cdf-965f-463b42a9d78f'),	('8ee5ba0f-194f-42db-b5b5-5297b4da290b','0b0fe17b-0229-4cdf-965f-463b42a9d78f'),
('fdfeda18-79b7-47e7-b5f8-541f9bd12f33','80fe542a-6419-4cf6-aadc-9e91acd0fb6b'),	('fdfeda18-79b7-47e7-b5f8-541f9bd12f33','c85dab44-d745-4a3b-8848-0fc85819f893'),
('bb770fb0-bd0d-4a91-ab68-1efe8fcdc2af','5a9586c7-6d87-4466-9431-6510b5c6704d'),	('bb770fb0-bd0d-4a91-ab68-1efe8fcdc2af','66dbc37b-63fc-4896-8012-185b510e3541'),
('e3d10264-d586-4852-b128-6f757c1667b4','a67699bb-06fc-4648-91c1-4b8da0423f23'),	('e3d10264-d586-4852-b128-6f757c1667b4','0b111877-06ef-4e42-afe7-42edab9c60df'),
('e3d10264-d586-4852-b128-6f757c1667b4','04942df9-17b5-45e9-bdf5-ba7426d3cb93'), ('e3d10264-d586-4852-b128-6f757c1667b4','ea903189-ce73-4a8b-b68a-88d6c6f28b5f'),
('a570abcb-3e59-4892-a22a-20e60a36f935','a39d2976-33ca-4990-b10f-9e1bdb8934b7'),
('024f92fb-7b6f-4120-a264-f87129f7f225','a39d2976-33ca-4990-b10f-9e1bdb8934b7'),
('024f92fb-7b6f-4120-a264-f87129f7f225','f04be734-30e7-4c07-ab7a-86996a762737'),
('024f92fb-7b6f-4120-a264-f87129f7f225','4eb18e01-c4a9-4507-8149-5e6456c68652'),
('106ba113-3bf3-440d-8f4f-9fa2a5929d89','9ea7d339-3610-4178-a15c-fc759c6a8f1b'),
('405dc63e-0ea5-410f-93bb-6d41c130d82f','2116de0f-033d-4d10-bcbf-62f569d7f812'),
('9a5ae86a-b6f1-4878-a84d-35970f4b0089','1a55c27c-51e4-47de-8784-843e02f9c5d7'),
('5d2a09e7-5982-4ff8-98a5-4a43d7f197d9','5be07994-1f75-4bee-9029-488843ed67ef'),
('602b526d-1aad-4a1c-a71a-b19c8d00426e','bbde825e-8ffc-48ec-b266-3a4fb083bebd'),
('106ba113-3bf3-440d-8f4f-9fa2a5929d89','c288f5d0-0eb4-4286-ad1b-c5f065d52ae0'),
('106ba113-3bf3-440d-8f4f-9fa2a5929d89','545dff8a-6617-47b6-b9b1-943fbbb867ee'),
('106ba113-3bf3-440d-8f4f-9fa2a5929d89','5fd0002b-f9d9-4fc8-8446-a6f0423c1456'),
('106ba113-3bf3-440d-8f4f-9fa2a5929d89','a8fca10d-f338-45e2-af92-e1b99d62b147'),
('106ba113-3bf3-440d-8f4f-9fa2a5929d89','2fe77a60-48f9-47ea-b5df-5cdd15f0932a'),
('106ba113-3bf3-440d-8f4f-9fa2a5929d89','c2449238-1db5-4964-8568-83eba695efa4'),
('602b526d-1aad-4a1c-a71a-b19c8d00426e','52b158f1-f9b2-4450-b7d7-fbcaa860a9b3'),
('602b526d-1aad-4a1c-a71a-b19c8d00426e','ff8b4f1e-9ebb-400c-9232-506f19b65413'),
('602b526d-1aad-4a1c-a71a-b19c8d00426e','15d6d494-2aa8-405b-9003-b097a05b07d9'),
('405dc63e-0ea5-410f-93bb-6d41c130d82f','679ab0d0-a1bd-47f8-9eee-d999e045df96'),
('405dc63e-0ea5-410f-93bb-6d41c130d82f','2d3ec8d1-3c9f-46aa-93db-2992ca65f05b'),
('405dc63e-0ea5-410f-93bb-6d41c130d82f','6d589816-ce75-4886-9fe7-37222dc8e13b'),
('405dc63e-0ea5-410f-93bb-6d41c130d82f','a1127d3b-c1bb-412c-95fa-eff86764f0aa');

INSERT INTO MEMAINKAN_TAYANGAN VALUES ('f2507d84-bfbf-42ab-8f05-c699f39aa198','d108615f-8650-4da3-afa3-c640651178e6'),
('f2507d84-bfbf-42ab-8f05-c699f39aa198','e528daaa-8d6b-4fdd-aad7-4a2737a8d595'),
('f2507d84-bfbf-42ab-8f05-c699f39aa198','edb6a44a-3608-4d05-8b6e-33694b8cfb69'),
('f2507d84-bfbf-42ab-8f05-c699f39aa198','736a3429-487e-42e4-9ccc-ddc281343b2d'),	('fc453357-f66f-4561-9dbc-a99b5508ff96','8cd7f068-fbfb-4cea-b78e-52a7ec2e3c06'),
('fc453357-f66f-4561-9dbc-a99b5508ff96','cec2653a-42d3-4d0a-b186-d946584b9c15'),
('fc453357-f66f-4561-9dbc-a99b5508ff96','80fe542a-6419-4cf6-aadc-9e91acd0fb6b'),
('d9d422a0-6cc5-48dc-af5a-bcd4a47c561c','218b86d5-6355-4718-80da-c1031ba1547f'),
('d9d422a0-6cc5-48dc-af5a-bcd4a47c561c','bdab0a01-bae4-4689-9dea-658fac980837'),
('d9d422a0-6cc5-48dc-af5a-bcd4a47c561c','72a99571-ef27-43f4-af61-1767a682e11c'),
('42a54d22-fa30-44c8-bfc0-2464157fa976','fe2d97fd-2981-4d08-804f-35eac3a68ea2'),
('42a54d22-fa30-44c8-bfc0-2464157fa976','bb461b55-2161-40e3-87b4-fac760b61ea3'),
('8ee5ba0f-194f-42db-b5b5-5297b4da290b','1e864d4c-7486-405b-85b8-e643e6cf3491'),
('8ee5ba0f-194f-42db-b5b5-5297b4da290b','588773b7-1a57-42ab-af61-a31775a783a5'),
('8ee5ba0f-194f-42db-b5b5-5297b4da290b','47d158cb-6903-41ba-9b3e-91faf912be91'),
('fdfeda18-79b7-47e7-b5f8-541f9bd12f33','80fe542a-6419-4cf6-aadc-9e91acd0fb6b'),
('fdfeda18-79b7-47e7-b5f8-541f9bd12f33','c85dab44-d745-4a3b-8848-0fc85819f893'),
('fdfeda18-79b7-47e7-b5f8-541f9bd12f33','adc03467-0f47-469f-bba9-b71ad7de5310'),
('bb770fb0-bd0d-4a91-ab68-1efe8fcdc2af','4a4a288c-04db-45bc-b992-8e9d4787bfce'),
('bb770fb0-bd0d-4a91-ab68-1efe8fcdc2af','1419a6c3-f4a9-4811-bb06-de14bb7bac3c'),
('bb770fb0-bd0d-4a91-ab68-1efe8fcdc2af','b2fb8eb5-967f-46eb-8557-cef9423cd8b0'),
('bb770fb0-bd0d-4a91-ab68-1efe8fcdc2af','08b82aa2-c8c6-45cf-a51e-0c682c4f04d0'),
('e3d10264-d586-4852-b128-6f757c1667b4','1c2dd268-3cf4-4058-ac2b-7221a09acbd5'),
('e3d10264-d586-4852-b128-6f757c1667b4','9a17bb21-3c71-410a-82f0-e002052fe355'),
('e3d10264-d586-4852-b128-6f757c1667b4','1546f5ba-d5ac-447b-84b9-b531c86b5826'),
('a570abcb-3e59-4892-a22a-20e60a36f935','a39d2976-33ca-4990-b10f-9e1bdb8934b7'),
('a570abcb-3e59-4892-a22a-20e60a36f935','94602227-2a68-4ffc-8c70-fbbdccbc0383'),
('a570abcb-3e59-4892-a22a-20e60a36f935','3173cb80-438a-4832-a37c-12df4ba1af10'),
('024f92fb-7b6f-4120-a264-f87129f7f225','a39d2976-33ca-4990-b10f-9e1bdb8934b7'),
('024f92fb-7b6f-4120-a264-f87129f7f225','a00fcc18-48f0-4e9c-bbc2-fb2cb9837e0d'),
('024f92fb-7b6f-4120-a264-f87129f7f225','1d195034-818b-46a2-a8c6-2e0c1e1daf1d'),
('024f92fb-7b6f-4120-a264-f87129f7f225','94602227-2a68-4ffc-8c70-fbbdccbc0383'),
('106ba113-3bf3-440d-8f4f-9fa2a5929d89','28fb91fb-bdb3-4dc1-84de-68267163a016'),
('405dc63e-0ea5-410f-93bb-6d41c130d82f','ea446bd8-e0d4-4300-9344-215d9b32afe2'),
('9a5ae86a-b6f1-4878-a84d-35970f4b0089','8f1651f7-d958-4f79-8986-400f0dbd3e27'),
('5d2a09e7-5982-4ff8-98a5-4a43d7f197d9','13862068-0100-442c-abe0-caf4a6df77a9'),
('602b526d-1aad-4a1c-a71a-b19c8d00426e','0075b1df-3b0e-4a34-a889-9761ebf4e3f6'),
('106ba113-3bf3-440d-8f4f-9fa2a5929d89','3e2f882c-b969-4194-ae22-88b49a6c67d4'),
('106ba113-3bf3-440d-8f4f-9fa2a5929d89','303ee247-b1f0-4c68-8626-69f8ea031020'),
('106ba113-3bf3-440d-8f4f-9fa2a5929d89','0097cea1-ff11-43e0-a55b-c49ff8843cf9'),
('106ba113-3bf3-440d-8f4f-9fa2a5929d89','d77acf7b-4f3f-4d56-be09-d41c12d51ef6'),
('9a5ae86a-b6f1-4878-a84d-35970f4b0089','eda9e1a3-4697-457c-beec-2bc988837030'),
('9a5ae86a-b6f1-4878-a84d-35970f4b0089','9538fe85-5ff1-4953-9e18-e540c3b89e2d'),
('9a5ae86a-b6f1-4878-a84d-35970f4b0089','efb93539-acf5-461a-9449-861a2a5017a5'),
('9a5ae86a-b6f1-4878-a84d-35970f4b0089','3d5f174c-938c-4fff-9544-b4066e5363e1'),
('9a5ae86a-b6f1-4878-a84d-35970f4b0089','64835e33-dd98-42d4-bc04-19eea3365467'),
('9a5ae86a-b6f1-4878-a84d-35970f4b0089','c9a16a5b-8fd4-4bf2-aa08-5605b1560717'),
('9a5ae86a-b6f1-4878-a84d-35970f4b0089','8b64fc11-0567-4951-9961-a38736cfaa88'),
('5d2a09e7-5982-4ff8-98a5-4a43d7f197d9','9cfc1f06-6ba7-41b3-93dc-eb74f54c573f'),
('5d2a09e7-5982-4ff8-98a5-4a43d7f197d9','9115a51f-67fb-412f-8a9e-296ed15a8f8c'),
('5d2a09e7-5982-4ff8-98a5-4a43d7f197d9','4babda89-8eea-4df9-97ec-083bbe53a7ab');

INSERT INTO PERUSAHAAN_PRODUKSI VALUES ('CJ E&M Pictures'),
	('Paramount Pictures'),
	('Alibaba Pictures'),
	('Annapurna Pictures'),
	('CoMix Wave Films'),
	('Toho Co., Ltd.'),
	('Universal Pictures'),
	('Starvision Plus'),
	('Visinema Pictures'),
	('PT. Max Pictures'),
	('MNC Pictures'),
	('Miramax'),
	('Wit Studio'),
	('tvN'),
	('World Productions'),
	('Studio Airlift'),
	('Toff Guy Films'),
	('ITV Studios'),
	('RealFilm Berlin'),
	('CloverWorks');

INSERT INTO PERSETUJUAN VALUES ('CJ E&M Pictures','f2507d84-bfbf-42ab-8f05-c699f39aa198','2019-03-01 00:00:00',90.0,2000000.0,'2019-05-30 00:00:00'),
	('Paramount Pictures','fc453357-f66f-4561-9dbc-a99b5508ff96','2015-03-01 00:00:00',120.0,150000000.0,'2015-07-31 00:00:00'),
	('Alibaba Pictures','fc453357-f66f-4561-9dbc-a99b5508ff96','2015-03-02 00:00:00',120.0,100000000.0,'2015-07-31 00:00:00'),
	('Annapurna Pictures','d9d422a0-6cc5-48dc-af5a-bcd4a47c561c','2016-10-10 00:00:00',75.0,7000000.0,'2016-12-07 00:00:00'),
	('CoMix Wave Films','42a54d22-fa30-44c8-bfc0-2464157fa976','2016-06-01 00:00:00',85.0,10000000.0,'2016-08-26 00:00:00'),
	('Toho Co., Ltd.','8ee5ba0f-194f-42db-b5b5-5297b4da290b','2019-03-15 00:00:00',110.0,30000000.0,'2019-07-19 00:00:00'),
	('Universal Pictures','fdfeda18-79b7-47e7-b5f8-541f9bd12f33','2004-08-01 00:00:00',55.0,5000000.0,'2004-09-24 00:00:00'),
	('Starvision Plus','bb770fb0-bd0d-4a91-ab68-1efe8fcdc2af','2023-10-01 00:00:00',45.0,1500000.0,'2023-11-02 00:00:00'),
	('Visinema Pictures','e3d10264-d586-4852-b128-6f757c1667b4','2020-02-01 00:00:00',60.0,3000000.0,'2020-02-27 00:00:00'),
	('PT. Max Pictures','a570abcb-3e59-4892-a22a-20e60a36f935','2016-06-01 00:00:00',30.0,2000000.0,'2016-07-05 00:00:00'),
	('MNC Pictures','024f92fb-7b6f-4120-a264-f87129f7f225','2014-04-01 00:00:00',45.0,1000000.0,'2014-05-08 00:00:00'),
	('Miramax','106ba113-3bf3-440d-8f4f-9fa2a5929d89','2023-12-03 00:00:00',90.0,10000000.0,'2024-03-21 00:00:00'),
	('Wit Studio','405dc63e-0ea5-410f-93bb-6d41c130d82f','2021-11-04 00:00:00',45.0,8000000.0,'2022-04-12 00:00:00'),
	('tvN','9a5ae86a-b6f1-4878-a84d-35970f4b0089','2019-10-03 00:00:00',60.0,9000000.0,'2020-02-22 00:00:00'),
	('World Productions','5d2a09e7-5982-4ff8-98a5-4a43d7f197d9','2017-08-28 00:00:00',60.0,12000000.0,'2018-08-26 00:00:00'),
	('Studio Airlift','602b526d-1aad-4a1c-a71a-b19c8d00426e','2019-09-20 00:00:00',55.0,11000000.0,'2020-03-26 00:00:00'),
	('Toff Guy Films','106ba113-3bf3-440d-8f4f-9fa2a5929d89','2023-12-03 00:00:00',90.0,8000000.0,'2024-03-21 00:00:00'),
	('ITV Studios','5d2a09e7-5982-4ff8-98a5-4a43d7f197d9','2017-08-16 00:00:00',45.0,9000000.0,'2018-08-26 00:00:00'),
	('RealFilm Berlin','602b526d-1aad-4a1c-a71a-b19c8d00426e','2019-09-18 00:00:00',60.0,12000000.0,'2020-03-26 00:00:00'),
	('CloverWorks','405dc63e-0ea5-410f-93bb-6d41c130d82f','2021-11-02 00:00:00',60.0,11000000.0,'2022-04-12 00:00:00');

INSERT INTO ULASAN VALUES ('f2507d84-bfbf-42ab-8f05-c699f39aa198','SarahJohnson','2024-04-23 09:00:00',5.0,'Parasite is a masterpiece that skillfully blends social commentary with dark humor. The performances are outstanding, and the plot is gripping throughout.'),
	('f2507d84-bfbf-42ab-8f05-c699f39aa198','MichaelSmith','2024-04-01 10:04:59',4.0,'Parasite offers a thought-provoking critique of class divide with unexpected twists. The cinematography and pacing keep you engaged till the end.'),
	('8ee5ba0f-194f-42db-b5b5-5297b4da290b','EmilyGarcia','2024-04-01 14:15:30',4.0,'A beautiful and emotional journey that explores themes of sacrifice and resilience.'),
	('bb770fb0-bd0d-4a91-ab68-1efe8fcdc2af','JamesNguyen','2024-04-17 04:00:14',3.0,'Terdapat beberapa momen emosional yang kuat, film ini sedikit kurang dalam pengembangan karakter.'),
	('a570abcb-3e59-4892-a22a-20e60a36f935','SophiaMartinez','2024-04-20 12:00:34',5.0,'Filmnya lucu, ketawa terus dari awal sampai akhir!'),
	('e3d10264-d586-4852-b128-6f757c1667b4','DavidKim','2024-04-01 13:03:32',4.0,'Penampilan para aktor sangat mengesankan dan ceritanya sangat autentik.'),
	('fdfeda18-79b7-47e7-b5f8-541f9bd12f33','SarahJohnson','2024-04-20 12:12:45',4.0,'A must-see for horror-comedy enthusiasts'),
	('fc453357-f66f-4561-9dbc-a99b5508ff96','EthanPatel','2024-04-27 17:11:41',5.0,'Never doubt Tom Cruise lah pokoknya!'),
	('42a54d22-fa30-44c8-bfc0-2464157fa976','SarahJohnson','2024-03-19 08:02:39',5.0,'A breathtaking anime with a touching story of love and fate. Beautiful animation and emotional depth make it a must-watch!'),
	('a570abcb-3e59-4892-a22a-20e60a36f935','JamesNguyen','2024-03-28 13:40:00',3.0,'Ceritanya agak klise, tapi tetap menghibur.'),
	('106ba113-3bf3-440d-8f4f-9fa2a5929d89','SarahJohnson','2024-04-23 10:15:00',5.0,'Karya yang memikat dengan alur cerita yang penuh intrik. Penampilan karakternya sangat kuat dan pengaruhnya masih terasa bahkan setelah Anda selesai menontonnya.'),
	('405dc63e-0ea5-410f-93bb-6d41c130d82f','MichaelSmith','2024-04-23 11:30:00',4.0,'Sangat menghibur dengan campuran aksi, komedi, dan drama yang sempurna. '),
	('9a5ae86a-b6f1-4878-a84d-35970f4b0089','EmilyGarcia','2024-04-23 12:45:00',4.0,'Mengharukan dengan alur cerita yang dalam dan emosional.'),
	('5d2a09e7-5982-4ff8-98a5-4a43d7f197d9','JamesNguyen','2024-04-23 14:00:00',3.0,'Menegangkan dengan plot yang penuh intrik dan aksi yang mendebarkan. '),
	('602b526d-1aad-4a1c-a71a-b19c8d00426e','SophiaMartinez','2024-04-23 15:15:00',5.0,'Perjalanan emosional yang memukau. Cerita ini menggambarkan pengorbanan dan keberanian dengan cara yang sangat kuat'),
	('106ba113-3bf3-440d-8f4f-9fa2a5929d89','DavidKim','2024-04-23 13:10:00',5.0,'Komedi, drama, sempurna.');

INSERT INTO TAYANGAN_MEMILIKI_DAFTAR_FAVORIT VALUES ('e3d10264-d586-4852-b128-6f757c1667b4','2024-04-01 12:05:32','DavidKim'),
	('9a5ae86a-b6f1-4878-a84d-35970f4b0089','2024-04-28 11:30:00','DavidKim'),
	('8ee5ba0f-194f-42db-b5b5-5297b4da290b','2024-04-01 14:02:13','EmilyGarcia'),
	('a570abcb-3e59-4892-a22a-20e60a36f935','2024-04-23 23:17:00','EmilyGarcia'),
	('106ba113-3bf3-440d-8f4f-9fa2a5929d89','2024-04-23 22:45:00','EmilyGarcia'),
	('fc453357-f66f-4561-9dbc-a99b5508ff96','2024-04-27 17:05:41','EthanPatel'),
	('42a54d22-fa30-44c8-bfc0-2464157fa976','2024-04-23 21:32:00','EthanPatel'),
	('602b526d-1aad-4a1c-a71a-b19c8d00426e','2024-04-28 17:45:00','EthanPatel'),
	('f2507d84-bfbf-42ab-8f05-c699f39aa198','2024-04-01 09:06:00','MichaelSmith'),
	('fdfeda18-79b7-47e7-b5f8-541f9bd12f33','2024-04-25 16:03:05','MichaelSmith'),
	('f2507d84-bfbf-42ab-8f05-c699f39aa198','2024-04-23 08:05:00','SarahJohnson'),
	('fdfeda18-79b7-47e7-b5f8-541f9bd12f33','2024-04-20 12:13:00','SarahJohnson'),
	('42a54d22-fa30-44c8-bfc0-2464157fa976','2024-03-19 08:03:00','SarahJohnson'),
	('5d2a09e7-5982-4ff8-98a5-4a43d7f197d9','2024-04-28 14:15:00','SarahJohnson'),
	('a570abcb-3e59-4892-a22a-20e60a36f935','2024-04-20 12:05:30','SophiaMartinez'),
	('405dc63e-0ea5-410f-93bb-6d41c130d82f','2024-04-28 08:00:00','SophiaMartinez');

INSERT INTO RIWAYAT_NONTON VALUES ('f2507d84-bfbf-42ab-8f05-c699f39aa198','SarahJohnson','2024-04-23 05:00:00','2024-04-23 08:00:00'),
	('f2507d84-bfbf-42ab-8f05-c699f39aa198','MichaelSmith','2024-04-01 06:04:00','2024-04-01 09:04:00'),
	('8ee5ba0f-194f-42db-b5b5-5297b4da290b','EmilyGarcia','2024-04-01 10:00:13','2024-04-01 14:00:13'),
	('bb770fb0-bd0d-4a91-ab68-1efe8fcdc2af','JamesNguyen','2024-04-17 20:00:32','2024-04-17 01:00:32'),
	('a570abcb-3e59-4892-a22a-20e60a36f935','SophiaMartinez','2024-04-20 09:59:30','2024-04-20 11:59:30'),
	('e3d10264-d586-4852-b128-6f757c1667b4','DavidKim','2024-04-01 10:03:32','2024-04-01 12:03:32'),
	('42a54d22-fa30-44c8-bfc0-2464157fa976','OliviaLopez','2024-04-03 09:00:00','2024-04-03 11:00:00'),
	('fc453357-f66f-4561-9dbc-a99b5508ff96','EthanPatel','2024-04-27 15:30:41','2024-04-27 17:00:41'),
	('fdfeda18-79b7-47e7-b5f8-541f9bd12f33','SarahJohnson','2024-04-20 10:10:00','2024-04-20 12:10:00'),
	('bb770fb0-bd0d-4a91-ab68-1efe8fcdc2af','MichaelSmith','2024-04-10 03:14:00','2024-04-10 05:14:00'),
	('e3d10264-d586-4852-b128-6f757c1667b4','EmilyGarcia','2024-04-20 10:00:45','2024-04-20 15:00:00'),
	('a570abcb-3e59-4892-a22a-20e60a36f935','JamesNguyen','2024-03-28 11:35:00','2024-03-28 13:35:00'),
	('42a54d22-fa30-44c8-bfc0-2464157fa976','EthanPatel','2024-04-23 17:30:00','2024-04-23 21:30:00'),
	('42a54d22-fa30-44c8-bfc0-2464157fa976','SarahJohnson','2024-03-19 06:00:00','2024-03-19 08:00:00'),
	('fdfeda18-79b7-47e7-b5f8-541f9bd12f33','MichaelSmith','2024-04-25 14:14:14','2024-04-25 16:00:05'),
	('a570abcb-3e59-4892-a22a-20e60a36f935','EmilyGarcia','2024-04-23 21:00:32','2024-04-23 23:14:00'),
	('106ba113-3bf3-440d-8f4f-9fa2a5929d89','OliviaLopez','2024-04-23 21:00:32','2024-04-23 21:30:32'),
	('405dc63e-0ea5-410f-93bb-6d41c130d82f','EthanPatel','2024-04-23 21:05:15','2024-04-23 21:35:15'),
	('9a5ae86a-b6f1-4878-a84d-35970f4b0089','SarahJohnson','2024-04-23 21:10:45','2024-04-23 21:40:45'),
	('5d2a09e7-5982-4ff8-98a5-4a43d7f197d9','MichaelSmith','2024-04-23 21:15:27','2024-04-23 21:45:27'),
	('602b526d-1aad-4a1c-a71a-b19c8d00426e','EmilyGarcia','2024-04-23 21:20:10','2024-04-23 21:50:10'),
	('5d2a09e7-5982-4ff8-98a5-4a43d7f197d9','JamesNguyen','2024-04-23 21:25:42','2024-04-23 21:55:42'),
	('602b526d-1aad-4a1c-a71a-b19c8d00426e','EthanPatel','2024-04-23 21:30:00','2024-04-23 22:00:00'),
	('106ba113-3bf3-440d-8f4f-9fa2a5929d89','DavidKim','2024-04-23 22:45:00','2024-04-23 23:30:00');


INSERT INTO DAFTAR_FAVORIT VALUES ('2024-04-01 12:05:32','DavidKim','Famz'),
	('2024-04-28 11:30:00','DavidKim','Binge-Worthy Bonanza'),
	('2024-04-01 14:02:13','EmilyGarcia','Anime'),
	('2024-04-23 23:17:00','EmilyGarcia','Love is in the air'),
	('2024-04-23 22:45:00','EmilyGarcia','Horror Night'),
	('2024-04-27 17:05:41','EthanPatel','Booomm'),
	('2024-04-23 21:32:00','EthanPatel','Nippon Paint'),
	('2024-04-28 17:45:00','EthanPatel','Cinephile Delight'),
	('2024-04-01 09:06:00','MichaelSmith','Nerve-wracking'),
	('2024-04-25 16:03:05','MichaelSmith','My type of movies'),
	('2024-04-23 08:05:00','SarahJohnson','Korean Thriller'),
	('2024-04-20 12:13:00','SarahJohnson','Zombies'),
	('2024-03-19 08:03:00','SarahJohnson','Japaneeze'),
	('2024-04-28 14:15:00','SarahJohnson','Silver Screen Gems'),
	('2024-04-20 12:05:30','SophiaMartinez','Heartbeating'),
	('2024-04-28 08:00:00','SophiaMartinez','Screen Magic Mix');


INSERT INTO TAYANGAN_TERUNDUH VALUES ('f2507d84-bfbf-42ab-8f05-c699f39aa198','SarahJohnson','2024-03-01 10:03:00'),
	('f2507d84-bfbf-42ab-8f05-c699f39aa198','MichaelSmith','2024-03-01 16:04:10'),
	('f2507d84-bfbf-42ab-8f05-c699f39aa198','EmilyGarcia','2024-03-03 17:00:00'),
	('f2507d84-bfbf-42ab-8f05-c699f39aa198','JamesNguyen','2024-03-01 15:17:00'),
	('f2507d84-bfbf-42ab-8f05-c699f39aa198','SophiaMartinez','2024-03-04 19:45:11'),
	('f2507d84-bfbf-42ab-8f05-c699f39aa198','DavidKim','2024-03-06 10:34:00'),
	('f2507d84-bfbf-42ab-8f05-c699f39aa198','OliviaLopez','2024-03-05 10:14:00'),
	('f2507d84-bfbf-42ab-8f05-c699f39aa198','EthanPatel','2024-03-10 01:00:04'),
	('42a54d22-fa30-44c8-bfc0-2464157fa976','SarahJohnson','2024-03-08 14:14:00'),
	('fc453357-f66f-4561-9dbc-a99b5508ff96','MichaelSmith','2024-03-08 19:45:00'),
	('42a54d22-fa30-44c8-bfc0-2464157fa976','EmilyGarcia','2024-03-08 23:24:09'),
	('e3d10264-d586-4852-b128-6f757c1667b4','JamesNguyen','2024-03-11 21:34:11'),
	('e3d10264-d586-4852-b128-6f757c1667b4','SophiaMartinez','2024-03-11 13:17:19'),
	('e3d10264-d586-4852-b128-6f757c1667b4','DavidKim','2024-03-12 20:00:00'),
	('e3d10264-d586-4852-b128-6f757c1667b4','OliviaLopez','2024-03-13 09:09:09'),
	('42a54d22-fa30-44c8-bfc0-2464157fa976','EthanPatel','2024-03-14 05:02:00'),
	('8ee5ba0f-194f-42db-b5b5-5297b4da290b','SarahJohnson','2024-03-14 18:10:00'),
	('fdfeda18-79b7-47e7-b5f8-541f9bd12f33','MichaelSmith','2024-03-14 21:00:49'),
	('8ee5ba0f-194f-42db-b5b5-5297b4da290b','EmilyGarcia','2024-03-14 23:14:00'),
	('024f92fb-7b6f-4120-a264-f87129f7f225','JamesNguyen','2024-03-15 07:00:40'),
	('024f92fb-7b6f-4120-a264-f87129f7f225','SophiaMartinez','2024-03-15 09:16:00'),
	('a570abcb-3e59-4892-a22a-20e60a36f935','DavidKim','2024-03-16 20:26:17'),
	('a570abcb-3e59-4892-a22a-20e60a36f935','OliviaLopez','2024-03-17 16:10:09'),
	('8ee5ba0f-194f-42db-b5b5-5297b4da290b','EthanPatel','2024-03-18 15:12:19'),
	('106ba113-3bf3-440d-8f4f-9fa2a5929d89','SarahJohnson','2024-04-28 09:30:00'),
	('405dc63e-0ea5-410f-93bb-6d41c130d82f','MichaelSmith','2024-04-28 10:45:15'),
	('9a5ae86a-b6f1-4878-a84d-35970f4b0089','EmilyGarcia','2024-04-28 12:00:30'),
	('5d2a09e7-5982-4ff8-98a5-4a43d7f197d9','JamesNguyen','2024-04-28 13:15:45'),
	('602b526d-1aad-4a1c-a71a-b19c8d00426e','SophiaMartinez','2024-04-28 14:30:00'),
	('106ba113-3bf3-440d-8f4f-9fa2a5929d89','DavidKim','2024-04-28 15:45:15');

-- TRIGGERS
-- Buat function untuk menghapus baris terkait
CREATE OR REPLACE FUNCTION delete_related_tayangan_memiliki_daftar_favorit() RETURNS TRIGGER AS $$
BEGIN
    DELETE FROM tayangan_memiliki_daftar_favorit
    WHERE timestamp = OLD.timestamp AND username = OLD.username;
    RETURN OLD;
END;
$$ LANGUAGE plpgsql;

-- Buat trigger untuk memanggil function sebelum penghapusan baris di daftar_favorit
CREATE TRIGGER before_delete_on_daftar_favorit
BEFORE DELETE ON daftar_favorit
FOR EACH ROW
EXECUTE FUNCTION delete_related_tayangan_memiliki_daftar_favorit();