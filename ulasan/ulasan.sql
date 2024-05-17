-- Step 1: Create the function
CREATE OR REPLACE FUNCTION check_duplicate_ulasan()
RETURNS TRIGGER AS $$
BEGIN
    IF EXISTS (
        SELECT 1
        FROM ULASAN
        WHERE username = NEW.username
          AND id_tayangan = NEW.id_tayangan
    ) THEN
        RAISE EXCEPTION 'Error: Pengguna sudah mengevaluasi tayangan ini';
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Step 2: Create the trigger
CREATE TRIGGER before_insert_ulasan
BEFORE INSERT ON ULASAN
FOR EACH ROW
EXECUTE FUNCTION check_duplicate_ulasan();
