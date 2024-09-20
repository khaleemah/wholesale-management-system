use ismailov

-- Klient
CREATE TABLE Klient (
    id_klienta INT IDENTITY(1,1) PRIMARY KEY,
    imie NVARCHAR(64) NOT NULL,
    nazwisko NVARCHAR(100) NOT NULL,
    ulica NVARCHAR(112) NULL,
    nr_mieszkania VARCHAR(9) NOT NULL,
    kod_pocztowy CHAR(6) NOT NULL,
    miasto NVARCHAR(86) NOT NULL,
    nr_telefonu CHAR(9) NOT NULL,
    email VARCHAR(254) NOT NULL
);
-- Zaleglosc
CREATE TABLE Zaleglosc (
    id_klienta INT PRIMARY KEY,
    kwota DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (id_klienta) REFERENCES Klient (id_klienta)
);
-- Kupujacy
CREATE TABLE Kupujacy (
    id_kupujacego INT IDENTITY(1,1) PRIMARY KEY,
    imie NVARCHAR(64) NOT NULL,
    nazwisko NVARCHAR(100) NOT NULL,
    ulica NVARCHAR(112) NULL,
    nr_mieszkania VARCHAR(9) NOT NULL,
    kod_pocztowy CHAR(6) NOT NULL,
    miasto NVARCHAR(86) NOT NULL,
    nr_telefonu CHAR(9) NOT NULL,
    email VARCHAR(254) NOT NULL
);
-- Produkt
CREATE TABLE Produkt (
    id_produktu INT IDENTITY(1,1) PRIMARY KEY,
    nazwa NVARCHAR(64) NOT NULL,
    dostepna_ilosc INT NOT NULL,
    minimalna_ilosc INT NOT NULL,
    id_kupujacego INT NOT NULL,
    cena_sprzedaz DECIMAL(10, 2) NOT NULL,
    cena_kupno DECIMAL(10, 2) NOT NULL,
    czas_dostawy SMALLINT NOT NULL,
    FOREIGN KEY (id_kupujacego) REFERENCES Kupujacy (id_kupujacego)
);
-- Do_kupienia
CREATE TABLE Do_kupienia (
    id_produktu INT PRIMARY KEY,
    ilosc INT NOT NULL,
    FOREIGN KEY (id_produktu) REFERENCES Produkt (id_produktu)
);
-- Dostawa
CREATE TABLE Dostawa (
    id_dostawy INT IDENTITY(1,1) PRIMARY KEY,
    id_produktu INT NOT NULL,
    data_dostawy DATE NOT NULL,
    ilosc INT NOT NULL,
    FOREIGN KEY (id_produktu) REFERENCES Produkt (id_produktu)
);
-- Zamowienie
CREATE TABLE Zamowienie (
    id_zamowienia INT IDENTITY(1,1) PRIMARY KEY,
    id_klienta INT NOT NULL,
    data_zamowienia DATE NOT NULL,
    stan BIT NOT NULL,
	FOREIGN KEY (id_klienta) REFERENCES Klient (id_klienta)
);
-- Zamowienie_szczegoly
CREATE TABLE Zamowienie_szczegoly (
    id_zamowienia INT NOT NULL,
    id_produktu INT NOT NULL,
    cena DECIMAL(10, 2) NOT NULL,
    ilosc INT NOT NULL,
	PRIMARY KEY CLUSTERED (id_zamowienia, id_produktu),
    FOREIGN KEY (id_zamowienia) REFERENCES Zamowienie (id_zamowienia),
    FOREIGN KEY (id_produktu) REFERENCES Produkt (id_produktu)
);
-- Platnosc
CREATE TABLE Platnosc (
    id_platnosci INT IDENTITY(1,1) PRIMARY KEY,
    id_zamowienia INT NOT NULL,
    kwota DECIMAL(10, 2) NOT NULL,
    stan BIT NOT NULL,
    FOREIGN KEY (id_zamowienia) REFERENCES Zamowienie (id_zamowienia)
);
-- Raport_miesieczny
CREATE TABLE Raport_miesieczny (
    miesiac DATE PRIMARY KEY,
    przychod DECIMAL(15, 2) NOT NULL,
    wydatek DECIMAL(15, 2) NOT NULL,
    zysk DECIMAL(15, 2) NOT NULL
);
