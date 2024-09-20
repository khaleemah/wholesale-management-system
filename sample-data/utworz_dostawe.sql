CREATE PROCEDURE p_Utworz_dostawe
    @id_produktu INT
AS
BEGIN
    SET NOCOUNT ON;
    
    DECLARE @ilosc INT;
    DECLARE @czas_dostawy INT;
    DECLARE @data_dostawy DATE;
	DECLARE @wydatek DECIMAL(10, 2) = 0;
    
    -- czy produkt jest w tabeli do_kupienia
    IF NOT EXISTS (
        SELECT 1
        FROM do_kupienia
        WHERE id_produktu = @id_produktu
    )
    BEGIN
        THROW 50001, 'Produkt nie istnieje na liście do kupienia.', 1;
        RETURN;
    END

    SELECT @ilosc = ilosc
    FROM do_kupienia
    WHERE id_produktu = @id_produktu;

	SELECT @czas_dostawy = czas_dostawy
    FROM Produkt
    WHERE id_produktu = @id_produktu;

	 -- liczymy date dostawy
    SET @data_dostawy = DATEADD(DAY, @czas_dostawy, GETDATE());

	-- aktualizowanie raportu miesiecznego
    DECLARE @current_month DATE = DATEFROMPARTS(YEAR(GETDATE()), MONTH(GETDATE()), 1);

	SELECT @wydatek = @ilosc * cena_kupno
    FROM Produkt
    WHERE id_produktu = @id_produktu;

    MERGE INTO Raport_miesieczny AS target
    USING (
        SELECT 
            @current_month AS miesiac,
            0 AS przychod,
            @wydatek AS wydatek, 
			-@wydatek AS zysk
    ) AS source (miesiac, przychod, wydatek, zysk)
    ON target.miesiac = source.miesiac
    WHEN MATCHED THEN
        UPDATE SET
            target.wydatek = target.wydatek + source.wydatek,
            target.zysk = target.zysk + source.zysk
    WHEN NOT MATCHED THEN
        INSERT (miesiac, przychod, wydatek, zysk)
        VALUES (source.miesiac, source.przychod, source.wydatek, source.zysk);

    INSERT INTO Dostawa (id_produktu, ilosc, data_dostawy)
    VALUES (@id_produktu, @ilosc, @data_dostawy);

    DELETE FROM do_kupienia
    WHERE id_produktu = @id_produktu;

    PRINT 'Dostawa utworzona pomyślnie.';
END;
