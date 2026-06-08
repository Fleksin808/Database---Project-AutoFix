-- Remove conflicting tables
DROP TABLE IF EXISTS dil CASCADE;
DROP TABLE IF EXISTS faktura CASCADE;
DROP TABLE IF EXISTS mechanik CASCADE;
DROP TABLE IF EXISTS odstavne_misto CASCADE;
DROP TABLE IF EXISTS platba CASCADE;
DROP TABLE IF EXISTS servisni_stani CASCADE;
DROP TABLE IF EXISTS servisni_ukon CASCADE;
DROP TABLE IF EXISTS vozidlo CASCADE;
DROP TABLE IF EXISTS zakazka CASCADE;
DROP TABLE IF EXISTS zakaznik CASCADE;
DROP TABLE IF EXISTS dil_servisni_ukon CASCADE;
DROP TABLE IF EXISTS mechanik_servisni_ukon CASCADE;
DROP TABLE IF EXISTS odstavne_misto_vozidlo CASCADE;
DROP TABLE IF EXISTS servisni_stani_zakazka CASCADE;

-- =========================
-- MASTER TABLES
-- =========================
CREATE TABLE zakaznik (
  id_zakaznik SERIAL PRIMARY KEY,
  jmeno        VARCHAR(256) NOT NULL,
  prijmeni     VARCHAR(256) NOT NULL,
  email        VARCHAR(256) NOT NULL,
  telefon      VARCHAR(64)  NOT NULL
);

CREATE TABLE vozidlo (
  vin SERIAL PRIMARY KEY,
  id_zakaznik INTEGER NOT NULL REFERENCES zakaznik(id_zakaznik) ON DELETE CASCADE,
  spz        VARCHAR(32)  NOT NULL,
  znacka     VARCHAR(128) NOT NULL,
  model      VARCHAR(128) NOT NULL,
  rok_vyroby INTEGER      NOT NULL
);

CREATE TABLE zakazka (
  id_zakazky SERIAL PRIMARY KEY,
  vin INTEGER NOT NULL REFERENCES vozidlo(vin) ON DELETE CASCADE,
  datum_prijeti DATE NOT NULL,
  stav_zakazky  VARCHAR(64) NOT NULL,
  poznamka      VARCHAR(256) NOT NULL
);

CREATE TABLE servisni_ukon (
  id_ukonu SERIAL PRIMARY KEY,
  id_zakazky INTEGER NOT NULL REFERENCES zakazka(id_zakazky) ON DELETE CASCADE,
  nazev VARCHAR(256) NOT NULL,
  popis VARCHAR(256) NOT NULL,
  plan_hodin        NUMERIC(6,2) NOT NULL,
  skutecnost_hodin  NUMERIC(6,2) NOT NULL,
  hodinova_sazba    NUMERIC(10,2) NOT NULL,
  stav_ukonu        VARCHAR(64) NOT NULL
);

CREATE TABLE mechanik (
  osobni_cislo SERIAL PRIMARY KEY,
  jmeno        VARCHAR(256) NOT NULL,
  kvalifikace  VARCHAR(256) NOT NULL
);

CREATE TABLE dil (
  kod SERIAL PRIMARY KEY,
  nazev VARCHAR(256) NOT NULL,
  prodejni_cena NUMERIC(12,2) NOT NULL,
  skladem_ks    INTEGER NOT NULL,
  min_ks        INTEGER NOT NULL
);

CREATE TABLE faktura (
  cislo_faktury SERIAL PRIMARY KEY,
  id_zakazky INTEGER NOT NULL REFERENCES zakazka(id_zakazky) ON DELETE CASCADE,
  datum_vystaveni DATE NOT NULL,
  splatnost       DATE NOT NULL,
  stav_faktury    VARCHAR(64) NOT NULL
);

CREATE TABLE platba (
  id_transakce SERIAL PRIMARY KEY,
  cislo_faktury INTEGER NOT NULL REFERENCES faktura(cislo_faktury) ON DELETE CASCADE,
  datum DATE NOT NULL,
  castka NUMERIC(12,2) NOT NULL,
  stav_platby   VARCHAR(64) NOT NULL,
  zpusob_platby VARCHAR(64) NOT NULL
);

CREATE TABLE servisni_stani (
  oznaceni SERIAL PRIMARY KEY,
  dostupnost VARCHAR(64) NOT NULL
);

CREATE TABLE odstavne_misto (
  oznaceni SERIAL PRIMARY KEY,
  dostupnost VARCHAR(64) NOT NULL,
  datum_od DATE NOT NULL,
  datum_do DATE NOT NULL
);

-- =========================
-- RELATION TABLES (M:N)
-- =========================
CREATE TABLE mechanik_servisni_ukon (
  osobni_cislo INTEGER NOT NULL REFERENCES mechanik(osobni_cislo) ON DELETE CASCADE,
  id_ukonu     INTEGER NOT NULL REFERENCES servisni_ukon(id_ukonu) ON DELETE CASCADE,
  PRIMARY KEY (osobni_cislo, id_ukonu)
);

CREATE TABLE dil_servisni_ukon (
  kod     INTEGER NOT NULL REFERENCES dil(kod) ON DELETE CASCADE,
  id_ukonu INTEGER NOT NULL REFERENCES servisni_ukon(id_ukonu) ON DELETE CASCADE,
  PRIMARY KEY (kod, id_ukonu)
);

CREATE TABLE odstavne_misto_vozidlo (
  oznaceni INTEGER NOT NULL REFERENCES odstavne_misto(oznaceni) ON DELETE CASCADE,
  vin      INTEGER NOT NULL REFERENCES vozidlo(vin) ON DELETE CASCADE,
  PRIMARY KEY (oznaceni, vin)
);

CREATE TABLE servisni_stani_zakazka (
  oznaceni  INTEGER NOT NULL REFERENCES servisni_stani(oznaceni) ON DELETE CASCADE,
  id_zakazky INTEGER NOT NULL REFERENCES zakazka(id_zakazky) ON DELETE CASCADE,
  PRIMARY KEY (oznaceni, id_zakazky)
);
