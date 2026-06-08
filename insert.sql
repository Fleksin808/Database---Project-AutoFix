-- =========================
-- VYČIŠTĚNÍ DATABÁZE
-- =========================
TRUNCATE TABLE
  platba,
  faktura,
  servisni_stani_zakazka,
  odstavne_misto_vozidlo,
  mechanik_servisni_ukon,
  dil_servisni_ukon,
  servisni_ukon,
  zakazka,
  vozidlo,
  zakaznik,
  servisni_stani,
  odstavne_misto,
  mechanik,
  dil
RESTART IDENTITY CASCADE;


-- =========================
-- INSERTY
-- =========================

INSERT INTO zakaznik (jmeno, prijmeni, email, telefon) VALUES
('Jan', 'Novak', 'jan.novak@autofix.cz', '777111222'),
('Petra', 'Svobodova', 'petra.svobodova@autofix.cz', '777333444'),
('Adam', 'Kral', 'adam.kral@autofix.cz', '777555666');

INSERT INTO vozidlo (id_zakaznik, spz, znacka, model, rok_vyroby) VALUES
(1, '1AB2345', 'Mercedes-Benz', 'C 200', 2021),
(2, '2CD3456', 'Audi', 'A3', 2018),
(3, '3EF4567', 'Skoda', 'Octavia', 2023);

INSERT INTO zakazka (vin, datum_prijeti, stav_zakazky, poznamka) VALUES
(1, '2025-03-01', 'v_realizaci', 'Vymena oleje a filtru'),
(2, '2025-03-10', 'ceka_na_dil', 'Vymena prednich brzd'),
(3, '2025-12-01', 'prijata', 'Diagnostika motoru');

INSERT INTO servisni_ukon
(id_zakazky, nazev, popis, plan_hodin, skutecnost_hodin, hodinova_sazba, stav_ukonu) VALUES
(1, 'Vymena oleje', 'Vymena motoroveho oleje', 1.00, 1.00, 800.00, 'dokonceno'),
(1, 'Vymena filtru', 'Vymena olejoveho filtru', 0.50, 0.75, 800.00, 'dokonceno'),
(2, 'Vymena brzd', 'Vymena brzdovych desticek', 2.00, 0.00, 900.00, 'naplanovano'),
(3, 'Diagnostika', 'Diag OBD a kontrola chyb', 1.00, 0.50, 950.00, 'dokonceno');

INSERT INTO mechanik (jmeno, kvalifikace) VALUES
('Karel Dvorak', 'senior'),
('Tomas Kral', 'junior'),
('Eva Horova', 'specialista');

INSERT INTO dil (nazev, prodejni_cena, skladem_ks, min_ks) VALUES
('Olejovy filtr', 250.00, 3, 5),
('Motorovy olej 5W-30 (1L)', 320.00, 20, 10),
('Brzdove desticky - sada', 1400.00, 0, 2),
('Kab. filtr', 220.00, 8, 5);

INSERT INTO mechanik_servisni_ukon (osobni_cislo, id_ukonu) VALUES
(1, 1),
(2, 2),
(1, 3),
(3, 4);

INSERT INTO dil_servisni_ukon (kod, id_ukonu) VALUES
(2, 1),
(1, 2),
(3, 3);

INSERT INTO servisni_stani (dostupnost) VALUES
('ano'),
('ano'),
('ano');

INSERT INTO odstavne_misto (dostupnost, datum_od, datum_do) VALUES
('ano', '2025-03-01', '2025-03-05'),
('ano', '2025-03-10', '2025-03-15'),
('ano', '2025-12-01', '2025-12-10');

INSERT INTO servisni_stani_zakazka (oznaceni, id_zakazky) VALUES
(1, 1),
(2, 2),
(3, 3);

INSERT INTO odstavne_misto_vozidlo (oznaceni, vin) VALUES
(1, 2),
(2, 1),
(3, 3);

INSERT INTO faktura (id_zakazky, datum_vystaveni, splatnost, stav_faktury) VALUES
(1, '2025-03-05', '2025-03-20', 'zaplacena'),
(2, '2025-03-12', '2025-03-26', 'nezaplacena'),
(3, '2025-12-02', '2025-12-16', 'vystavena');

INSERT INTO platba (cislo_faktury, datum, castka, stav_platby, zpusob_platby) VALUES
(1, '2025-03-06', 2500.00, 'zaplaceno', 'karta'),
(1, '2025-03-06', 300.00, 'zaplaceno', 'hotovost'),
(2, '2025-03-20', 500.00, 'castecne_zaplaceno', 'prevod');
