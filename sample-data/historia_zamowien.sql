CREATE OR ALTER PROCEDURE p_Historia_zamowien
    @id_klienta INT
AS
BEGIN
   SET NOCOUNT ON;

    SELECT 
        z.id_zamowienia AS 'ID Zamówienia',
        z.data_zamowienia AS 'Data Zamówienia',
        z.stan AS 'Stan Zamówienia',
        p.kwota AS 'Kwota'
    FROM Zamowienie z
    JOIN Platnosc p ON z.id_zamowienia = p.id_zamowienia
    WHERE z.id_klienta = @id_klienta
    ORDER BY z.data_zamowienia DESC;

   
END;

exec p_Historia_zamowien 10