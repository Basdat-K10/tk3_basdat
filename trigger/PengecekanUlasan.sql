
CREATE OR REPLACE FUNCTION check_duplicate_ulasan()
RETURNS TRIGGER AS $$
BEGIN
    IF EXISTS (
        SELECT *
        FROM ULASAN
        WHERE username = NEW.username
          AND id_tayangan = NEW.id_tayangan
    ) THEN
        RAISE EXCEPTION 'Error: Pengguna sudah mengevaluasi tayangan ini';
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER before_insert_ulasan
BEFORE INSERT ON ULASAN
FOR EACH ROW
EXECUTE FUNCTION check_duplicate_ulasan();
