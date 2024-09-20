use ismailov

begin tran;
INSERT INTO Klient (imie, nazwisko, ulica, nr_mieszkania, kod_pocztowy, miasto, nr_telefonu, email) VALUES
('Jan', 'Kowalski', 'Kwiatowa', '15/1A', '00-123', 'Warszawa', '123456789', 'jan.kowalski@example.com'),
('Anna', 'Nowak', 'Słoneczna', '20/4B', '01-234', 'Kraków', '234567890', 'anna.nowak@example.com'),
('Piotr', 'Wiśniewski', 'Lipowa', '10/3C', '02-345', 'Łódź', '345678901', 'piotr.wisniewski@example.com'),
('Katarzyna', 'Wójcik', 'Brzozowa', '8/5D', '03-456', 'Wrocław', '456789012', 'katarzyna.wojcik@example.com'),
('Michał', 'Kamiński', 'Dębowa', '12/6E', '04-567', 'Poznań', '567890123', 'michal.kaminski@example.com'),
('Agnieszka', 'Lewandowska', 'Topolowa', '3/7F', '05-678', 'Gdańsk', '678901234', 'agnieszka.lewandowska@example.com'),
('Tomasz', 'Zieliński', 'Jesionowa', '22/8G', '06-789', 'Szczecin', '789012345', 'tomasz.zielinski@example.com'),
('Magdalena', 'Szymańska', 'Wierzbowo', '19/9H', '07-890', 'Bydgoszcz', '890123456', 'magdalena.szymanska@example.com'),
('Robert', 'Woźniak', 'Grabowa', '11/10I', '08-901', 'Lublin', '901234567', 'robert.wozniak@example.com'),
('Elżbieta', 'Dąbrowska', 'Sosnowa', '25/11J', '09-012', 'Katowice', '012345678', 'elzbieta.dabrowska@example.com');




INSERT INTO Kupujacy (imie, nazwisko, ulica, nr_mieszkania, kod_pocztowy, miasto, nr_telefonu, email) VALUES 
('Grzegorz', 'Mazur', 'Wiejska', '8', '66-777', 'Gdynia', '101202303', 'grzegorz.mazur@example.com'),
('Ewa', 'Kaczmarek', NULL, '32', '77-888', 'Rzeszów', '202303404', 'ewa.kaczmarek@example.com'),
('Łukasz', 'Król', 'Warszawska', '12B/4', '88-999', 'Białystok', '303404505', 'lukasz.krol@example.com'),
('Magdalena', 'Pawlak', 'Ogrodowa', '6/1', '99-000', 'Bydgoszcz', '404505606', 'magdalena.pawlak@example.com'),
('Rafał', 'Włodarczyk', 'Świętokrzyska', '14', '11-222', 'Katowice', '505606707', 'rafal.wlodarczyk@example.com'),
('Alicja', 'Dąbrowska', NULL, '27', '22-333', 'Sopot', '606707808', 'alicja.dabrowska@example.com'),
('Krystyna', 'Górska', 'Krucza', '9/3', '33-444', 'Gliwice', '707808909', 'krystyna.gorska@example.com'),
('Dariusz', 'Zając', 'Lipowa', '1A', '44-555', 'Toruń', '808909010', 'dariusz.zajac@example.com'),
('Natalia', 'Błaszczyk', 'Bukowa', '19B/7', '55-666', 'Opole', '909010111', 'natalia.blaszczyk@example.com'),
('Marek', 'Chmielewski', 'Cicha', '4', '66-777', 'Radom', '010111212', 'marek.chmielewski@example.com');




INSERT INTO Produkt (nazwa, dostepna_ilosc, minimalna_ilosc, id_kupujacego, cena_sprzedaz, cena_kupno, czas_dostawy) VALUES 
('Długopis', 100, 20, 1, 1.50, 0.80, 3),
('Ołówek HB', 150, 30, 2, 0.90, 0.50, 2),
('Notes A4', 75, 10, 3, 12.00, 7.50, 5),
('Kalendarz 2024', 50, 5, 4, 25.00, 15.00, 7),
('Blok rysunkowy', 200, 50, 5, 8.00, 5.00, 4),
('Markery kolorowe', 120, 25, 6, 10.00, 6.00, 3),
('Zeszyt 60 kartek', 300, 60, 7, 3.50, 2.00, 2),
('Taśma klejąca', 180, 40, 8, 4.00, 2.50, 1),
('Klej biurowy', 90, 15, 9, 5.00, 3.00, 3),
('Korektor w taśmie', 110, 20, 10, 7.50, 4.50, 2),
('Linijka 30 cm', 140, 25, 1, 2.50, 1.50, 1),
('Nożyczki biurowe', 130, 30, 2, 6.00, 3.50, 2),
('Zakreślacze', 160, 35, 3, 9.00, 5.50, 4),
('Segregator A4', 20, 15, 4, 15.00, 10.00, 5),
('Etykiety samoprzylepne', 170, 30, 5, 5.50, 3.00, 2),
('Papier ksero', 250, 50, 6, 20.00, 12.00, 3),
('Teczka papierowa', 140, 25, 7, 8.50, 5.00, 2),
('Kalkulator biurowy', 60, 10, 8, 35.00, 20.00, 7),
('Zszywacz', 110, 20, 9, 14.00, 8.00, 3),
('Zszywki do zszywacza', 190, 40, 10, 3.00, 1.50, 1),
('Spinacze biurowe', 220, 50, 1, 2.00, 1.00, 1),
('Pióro wieczne', 70, 10, 2, 45.00, 30.00, 6),
('Kreda kolorowa', 150, 30, 3, 6.50, 3.50, 2),
('Farby akwarelowe', 95, 15, 4, 18.00, 10.00, 5),
('Pędzle do farb', 125, 20, 5, 12.00, 7.00, 3);



INSERT INTO Raport_miesieczny (miesiac, przychod, wydatek, zysk) VALUES 
('2024-01-01', 50000.00, 40000.00, 10000.00),
('2024-02-01', 55000.00, 45000.00, 10000.00),
('2024-03-01', 60000.00, 48000.00, 12000.00),
('2024-04-01', 65000.00, 50000.00, 15000.00),
('2024-05-01', 70000.00, 52000.00, 18000.00);

commit tran;

rollback tran
--select * from Produkt order by id_kupujacego

select * from klient
select * from produkt
select * from raport_miesieczny

BEGIN TRANSACTION;
delete from Zamowienie_szczegoly;
delete from platnosc;
delete from zamowienie
delete from zaleglosc
delete from Raport_miesieczny;
delete from dostawa;
delete from do_kupienia;
delete from Produkt;
delete from Kupujacy;
delete from Klient;
COMMIT TRANSACTION;

DBCC CHECKIDENT ('platnosc', RESEED, 0); 
DBCC CHECKIDENT ('zamowienie', RESEED, 0); 
DBCC CHECKIDENT ('dostawa', RESEED, 0); 


DBCC CHECKIDENT ('Produkt', RESEED, 0); 

DBCC CHECKIDENT ('Kupujacy', RESEED, 0); 
DBCC CHECKIDENT ('Klient', RESEED, 0); 



