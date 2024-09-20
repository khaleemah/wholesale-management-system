use ismailov

CREATE TYPE ProduktyTable AS TABLE (
    id_produktu INT,
    ilosc INT
);

CREATE PROCEDURE p_Zloz_zamowienie
    @id_klienta INT,
    @produkty ProduktyTable READONLY
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @order_id INT;
    BEGIN TRY
        BEGIN TRANSACTION;

       
        INSERT INTO Zamowienie (id_klienta, data_zamowienia, stan)
        VALUES (@id_klienta, GETDATE(), 0); 

        SET @order_id = SCOPE_IDENTITY();

        DECLARE @za_malo BIT = 0;
		-- sprawdzamy, czy produkty sa dostepne
        INSERT INTO Zamowienie_szczegoly (id_zamowienia, id_produktu, cena, ilosc)
        SELECT @order_id, p.id_produktu, p.cena_sprzedaz, op.ilosc
        FROM @produkty op
        JOIN Produkt p ON op.id_produktu = p.id_produktu
        WHERE p.dostepna_ilosc >= op.ilosc;

        -- czy wszystkie produkty zostaly dodane do zamowienia
        SET @za_malo = CASE WHEN EXISTS (
            SELECT 1
            FROM @produkty op
            LEFT JOIN Produkt p ON op.id_produktu = p.id_produktu
            WHERE p.id_produktu IS NULL OR p.dostepna_ilosc < op.ilosc
        ) THEN 1 ELSE 0 END;

        IF @za_malo = 1
        BEGIN
            THROW 50001, 'Nie wystarczające zapasy na zamówienie', 1;
        END;

        -- zmniejszamy zapasy w tabeli Produkt
        UPDATE p
        SET dostepna_ilosc = dostepna_ilosc - op.ilosc
        FROM @produkty op
        JOIN Produkt p ON op.id_produktu = p.id_produktu;

        -- aktualizujemy przychody
        DECLARE @kwota DECIMAL(10, 2);

        SELECT @kwota = SUM(op.ilosc * p.cena_sprzedaz)
        FROM @produkty op
        JOIN Produkt p ON op.id_produktu = p.id_produktu;

       
        DECLARE @current_month DATE = DATEFROMPARTS(YEAR(GETDATE()), MONTH(GETDATE()), 1);

        MERGE INTO Raport_miesieczny AS target
        USING (
            SELECT 
                @current_month AS miesiac,
                @kwota AS przychod,
                0 AS wydatek,
                @kwota AS zysk
        ) AS source (miesiac, przychod, wydatek, zysk)
        ON target.miesiac = source.miesiac
        WHEN MATCHED THEN
            UPDATE SET
                target.przychod = target.przychod + source.przychod,
                target.zysk = target.zysk + source.zysk
        WHEN NOT MATCHED THEN
            INSERT (miesiac, przychod, wydatek, zysk)
            VALUES (source.miesiac, source.przychod, source.wydatek, source.zysk);

        -- tworzymy platnosc
        INSERT INTO Platnosc (id_zamowienia, kwota, stan)
        VALUES (@order_id, @kwota, 0);

        -- zarzadzamy zaleglosciami
		-- czy klient ma już zaleglosci
		IF EXISTS (
			SELECT 1
			FROM Zaleglosc
			WHERE id_klienta = @id_klienta
		)
		BEGIN
			-- aktualizacja istniejącej zaległości
			UPDATE Zaleglosc
			SET kwota = kwota + @kwota
			WHERE id_klienta = @id_klienta;
		END
		ELSE
		BEGIN
			-- dodanie nowej zaległości
			INSERT INTO Zaleglosc (id_klienta, kwota)
			VALUES (@id_klienta, @kwota);
		END


        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
		ROLLBACK TRANSACTION;
		DECLARE @last_id INT;
        SELECT @last_id = ISNULL(MAX(id_zamowienia), 0) FROM Zamowienie;
		DBCC CHECKIDENT ('Zamowienie', RESEED, @last_id);
        
        THROW;
    END CATCH;
END;


begin tran

--  1
DECLARE @produkty1 ProduktyTable;
DELETE FROM @produkty1;
INSERT INTO @produkty1 (id_produktu, ilosc)
VALUES (1, 10), (2, 5), (3, 3);
EXEC p_Zloz_zamowienie 1, @produkty1;

-- 2
DECLARE @produkty2 ProduktyTable;
DELETE FROM @produkty2;
INSERT INTO @produkty2 (id_produktu, ilosc)
VALUES (2, 8), (4, 4), (6, 5), (25,10); 
EXEC p_Zloz_zamowienie 2, @produkty2;

-- 3
DECLARE @produkty3 ProduktyTable;
DELETE FROM @produkty3;
INSERT INTO @produkty3 (id_produktu, ilosc)
VALUES (3, 5), (5, 10), (7, 7);
EXEC p_Zloz_zamowienie 3, @produkty3;

DECLARE @produkty32 ProduktyTable;
DELETE FROM @produkty32;
INSERT INTO @produkty32 (id_produktu, ilosc)
VALUES (11, 30), (13, 40), (25, 100); 
EXEC p_Zloz_zamowienie 3, @produkty32;

-- 4
DECLARE @produkty4 ProduktyTable;
DELETE FROM @produkty4;
INSERT INTO @produkty4 (id_produktu, ilosc)
VALUES (4, 2), (6, 3), (8, 4), (20, 40); 
EXEC p_Zloz_zamowienie 4, @produkty4;

-- 5
DECLARE @produkty5 ProduktyTable;
DELETE FROM @produkty5;
INSERT INTO @produkty5 (id_produktu, ilosc)
VALUES (5, 15), (7, 8); 
EXEC p_Zloz_zamowienie 5, @produkty5;

-- 6
DECLARE @produkty6 ProduktyTable;
DELETE FROM @produkty6;
INSERT INTO @produkty6 (id_produktu, ilosc)
VALUES (6, 6), (7, 250), (9, 6), (10, 4); 
EXEC p_Zloz_zamowienie 6, @produkty6;

-- 7
DECLARE @produkty7 ProduktyTable;
DELETE FROM @produkty7;
INSERT INTO @produkty7 (id_produktu, ilosc)
VALUES (7, 9), (9, 5); 
EXEC p_Zloz_zamowienie 7, @produkty7;

-- 8
DECLARE @produkty8 ProduktyTable;
DELETE FROM @produkty8;
INSERT INTO @produkty8 (id_produktu, ilosc)
VALUES (8, 4), (10, 2), (12, 3); 
EXEC p_Zloz_zamowienie 8, @produkty8;

-- 9
DECLARE @produkty9 ProduktyTable;
DELETE FROM @produkty9;
INSERT INTO @produkty9 (id_produktu, ilosc)
VALUES (9, 7), (11, 5), (13, 4); 
EXEC p_Zloz_zamowienie 9, @produkty9;

-- 10
DECLARE @produkty10 ProduktyTable;
DELETE FROM @produkty10;
INSERT INTO @produkty10 (id_produktu, ilosc)
VALUES (10, 3), (12, 2), (14, 4); 
EXEC p_Zloz_zamowienie 10, @produkty10;


DECLARE @produkty102 ProduktyTable;
DELETE FROM @produkty102;
INSERT INTO @produkty102 (id_produktu, ilosc)
VALUES (11, 30), (13, 40), (21, 200); 
EXEC p_Zloz_zamowienie 10, @produkty102;

commit tran