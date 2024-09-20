use ismailov

CREATE TYPE ProduktyTable AS TABLE (
    id_produktu INT,
    ilosc INT
);

CREATE or alter PROCEDURE p_Zloz_zamowienie
    @id_klienta INT,
    @produkty ProduktyTable READONLY
AS
BEGIN
    SET NOCOUNT ON;
    
    BEGIN TRY
        BEGIN TRANSACTION;

        
        DECLARE @order_id INT;

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
		DBCC CHECKIDENT ('Zamowienie', RESEED, @order_id);
        ROLLBACK TRANSACTION;
        THROW;
    END CATCH;
END;


declare @produkty ProduktyTable;

insert into @produkty values
 (2, 25),   -- Ołówek HB
    (4, 5),    -- Kalendarz 2024
    (7, 40),   -- Zeszyt 60 kartek
    (12, 15);
exec p_Zloz_zamowienie 2, @produkty;

select * from zamowienie

DBCC CHECKIDENT ('Zamowienie', RESEED, 2);  -- Replace 0 with the starting value you want

DELETE FROM zaleglosc
WHERE id_klienta = 2;

update rapro