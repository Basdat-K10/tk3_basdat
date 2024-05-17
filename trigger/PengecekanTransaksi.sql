CREATE OR REPLACE FUNCTION manage_subscription_transaction()
RETURNS TRIGGER AS
$$
DECLARE
    active_transaction RECORD;
BEGIN
    -- Check if there is an active subscription for the user
    SELECT *
    INTO active_transaction
    FROM "transaction"
    WHERE username = NEW.username
    AND CURRENT_DATE BETWEEN start_date_time AND end_date_time;

    IF FOUND THEN
        -- If active subscription exists, update it
        UPDATE "transaction"
        SET
            nama_paket = NEW.nama_paket,
            start_date_time = CURRENT_DATE,
            end_date_time = CURRENT_DATE + INTERVAL '1 month',
            metode_pembayaran = NEW.metode_pembayaran,
            timestamp_pembayaran = CURRENT_TIMESTAMP
        WHERE username = NEW.username
            AND end_date_time > CURRENT_DATE;

        -- Skip the insert since we're updating an existing record
        RETURN NULL;
    ELSE
        -- If no active subscription, proceed with the insert
        RETURN NEW;
    END IF;
END;
$$
LANGUAGE plpgsql;


CREATE TRIGGER handle_subscription_transaction
BEFORE INSERT ON "transaction"
FOR EACH ROW
EXECUTE FUNCTION manage_subscription_transaction();
