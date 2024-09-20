CREATE OR ALTER PROCEDURE p_Przetworz_Platnosc
    @id_platnosci INT
AS
BEGIN
    SET NOCOUNT ON;
    
    DECLARE @kwota DECIMAL(10, 2);
    DECLARE @id_klienta INT;

    BEGIN TRY
        BEGIN TRANSACTION;

		IF EXISTS (SELECT 1 FROM Platnosc WHERE id_platnosci = @id_platnosci AND stan = 1)
        BEGIN
            --  jest juz przetworzona, nic nie robimy
            RETURN;
        END;
        -- aktualizacja stanu platnosci
        UPDATE Platnosc
        SET stan = 1
        WHERE id_platnosci = @id_platnosci;

        -- pobranie kwoty platnosci
        SELECT @kwota = kwota
        FROM Platnosc
        WHERE id_platnosci = @id_platnosci;

        -- zmniejszenie zadluzenia
        SELECT @id_klienta = id_klienta
        FROM Zamowienie
        WHERE id_zamowienia = (SELECT id_zamowienia FROM Platnosc WHERE id_platnosci = @id_platnosci);

        UPDATE Zaleglosc
        SET kwota = kwota - @kwota
        WHERE id_klienta = @id_klienta;

        -- Usunięcie klienta z tabeli Zaleglosc, jeśli zadłużenie <= 0
        DELETE FROM Zaleglosc
        WHERE id_klienta = @id_klienta AND kwota <= 0;

        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        THROW;
    END CATCH;
END;

BEGIN TRANSACTION;

EXEC p_Przetworz_Platnosc 1;
EXEC p_Przetworz_Platnosc 2;
EXEC p_Przetworz_Platnosc 3;
EXEC p_Przetworz_Platnosc 4;
EXEC p_Przetworz_Platnosc 5;
EXEC p_Przetworz_Platnosc 6;
EXEC p_Przetworz_Platnosc 10;

COMMIT TRANSACTION;

