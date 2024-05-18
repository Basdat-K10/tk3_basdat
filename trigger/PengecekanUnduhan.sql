CREATE OR REPLACE FUNCTION cek_tayangan_terunduh() RETURNS TRIGGER AS $$
BEGIN
    IF OLD.timestamp > NOW() - INTERVAL '1 day'
    THEN
        RAISE EXCEPTION 'Tayangan minimal harus berada di daftar unduhan selama 1 hari agar bisa dihapus.';
    END IF;
    
    RETURN OLD;
END;

$$ LANGUAGE plpgsql;

CREATE TRIGGER cek_penghapusan_tayangan_terunduh
BEFORE DELETE ON tayangan_terunduh
FOR EACH ROW
EXECUTE FUNCTION cek_tayangan_terunduh();