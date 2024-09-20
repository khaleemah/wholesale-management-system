
CREATE TRIGGER tr_Sprawdz_ilosc
ON Produkt
AFTER UPDATE
AS
BEGIN
    DECLARE @id_produktu INT;
    DECLARE @nowa_ilosc INT;
    DECLARE @minimalna_ilosc INT;
    DECLARE @potrzebna_ilosc INT;

	DECLARE cur CURSOR FOR
    SELECT i.id_produktu, i.dostepna_ilosc, i.minimalna_ilosc
    FROM inserted i
    INNER JOIN Produkt p ON i.id_produktu = p.id_produktu;
	  OPEN cur;
    FETCH NEXT FROM cur INTO @id_produktu, @nowa_ilosc, @minimalna_ilosc;

    WHILE @@FETCH_STATUS = 0
    BEGIN
        IF @nowa_ilosc < @minimalna_ilosc
        BEGIN
             -- obliczamy potrzebna ilosc do uzupelnienia
            SET @potrzebna_ilosc = 3 * @minimalna_ilosc;

            -- sprawdzamy czy taki rekord juz istnieje
            IF NOT EXISTS (
                SELECT 1
                FROM do_kupienia
                WHERE id_produktu = @id_produktu
            )
            BEGIN

                INSERT INTO do_kupienia (id_produktu, ilosc)
                VALUES (@id_produktu, @potrzebna_ilosc);
            END
        END

        FETCH NEXT FROM cur INTO @id_produktu, @nowa_ilosc, @minimalna_ilosc;
    END

    CLOSE cur;
    DEALLOCATE cur;
END;


begin tran


DECLARE @produkty32 ProduktyTable;
DELETE FROM @produkty32;
INSERT INTO @produkty32 (id_produktu, ilosc)
VALUES (11, 30), (13, 40), (25, 105); 
EXEC p_Zloz_zamowienie 3, @produkty32;
