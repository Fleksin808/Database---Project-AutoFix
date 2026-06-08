D1 - CN
  Kteří mechanici pracovali pouze na zakázkách ve stavu „dokončená“ a na žádných jiných zakázkách?
  
D2 - D1N
  Kteří mechanici pracovali na VŠECH servisních úkonech zakázky s identifikátorem 1? 
  
D3 - A, F5
  SELECT
    v.vin,
    v.spz,
    za.id_zakazky,
    za.stav_zakazky
  FROM vozidlo v
  FULL OUTER JOIN zakazka za
    ON za.vin = v.vin;

D4 - A, F2
  SELECT
    p.id_transakce,
    p.cislo_faktury,
    f.splatnost,
    p.castka
  FROM platba p
  JOIN faktura f USING (cislo_faktury);

D5 - A. F4
  SELECT
    v.vin,
    v.spz,
    za.id_zakazky,
    za.stav_zakazky
  FROM vozidlo v
  LEFT JOIN zakazka za
    ON za.vin = v.vin;

D6 - F3
  SELECT
    ss.oznaceni AS servisni_stani,
    om.oznaceni AS odstavne_misto
  FROM servisni_stani ss
  CROSS JOIN odstavne_misto om;

D7 - A, F1
  SELECT
    p.id_transakce,
    p.cislo_faktury,
    f.stav_faktury,
    p.castka,
    p.datum
  FROM platba p
  JOIN faktura f
    ON f.cislo_faktury = p.cislo_faktury;

D8 - A, F1, G3, I1, I2
  SELECT
    v.vin,
    v.spz,
    COUNT(DISTINCT za.stav_zakazky) AS stavy_vozidla,
    (
      SELECT COUNT(DISTINCT stav_zakazky)
      FROM zakazka za2
      WHERE za2.vin = v.vin
    ) AS stavy_pro_toto_vozidlo
  FROM vozidlo v
  JOIN zakazka za ON za.vin = v.vin
  GROUP BY v.vin, v.spz
  HAVING COUNT(DISTINCT za.stav_zakazky) =
         (
           SELECT COUNT(DISTINCT stav_zakazky)
           FROM zakazka za2
           WHERE za2.vin = v.vin
       );

D9 - A, F4
  SELECT
    f.cislo_faktury,
    f.id_zakazky,
    f.datum_vystaveni,
    f.splatnost,
    f.stav_faktury
  FROM faktura f
  LEFT JOIN platba p ON p.cislo_faktury = f.cislo_faktury
  WHERE p.id_transakce IS NULL;

D10 - A, F1
  SELECT
    f.cislo_faktury,
    z.id_zakaznik,
    z.jmeno,
    z.prijmeni,
    v.spz,
    f.datum_vystaveni,
    f.splatnost,
    f.stav_faktury
  FROM faktura f
  JOIN zakazka za ON za.id_zakazky = f.id_zakazky
  JOIN vozidlo v ON v.vin = za.vin
  JOIN zakaznik z ON z.id_zakaznik = v.id_zakaznik;

D11 - A, F1
  SELECT
    za.id_zakazky,
    v.znacka,
    v.model,
    za.datum_prijeti,
    za.stav_zakazky
  FROM zakazka za
  JOIN vozidlo v
    ON za.vin = v.vin;

D12 - G1, G4
  SELECT z.id_zakaznik, z.jmeno, z.prijmeni, z.email
  FROM zakaznik z
  WHERE NOT EXISTS (
    SELECT *
    FROM vozidlo v
    WHERE v.id_zakaznik = z.id_zakaznik
      AND v.znacka = 'Tesla'
  );

D13 - A, F1, I1, I2, K
  SELECT
    z.id_zakaznik,
    z.jmeno,
    z.prijmeni,
    z.email,
    COUNT(*) AS pocet_vozidel
  FROM zakaznik z
  JOIN vozidlo v ON v.id_zakaznik = z.id_zakaznik
  WHERE z.email IS NOT NULL
  GROUP BY z.id_zakaznik, z.jmeno, z.prijmeni, z.email
  HAVING COUNT(*) >= 1
  ORDER BY pocet_vozidel DESC;

D14 - A, F1, L
  CREATE OR REPLACE VIEW zakazky_se_zakazniky AS
  SELECT
    za.*,
    z.jmeno,
    z.prijmeni
  FROM zakazka za
  JOIN vozidlo v ON v.vin = za.vin
  JOIN zakaznik z ON z.id_zakaznik = v.id_zakaznik;

D15 - A, F1, G1, G4, J
  SELECT DISTINCT z.*
  FROM zakaznik z
  JOIN vozidlo v ON v.id_zakaznik = z.id_zakaznik
  ORDER BY z.id_zakaznik;
  
  SELECT z.*
  FROM zakaznik z
  WHERE EXISTS (
    SELECT *
    FROM vozidlo v
    WHERE v.id_zakaznik = z.id_zakaznik
  )
  ORDER BY z.id_zakaznik;
  
  SELECT z.*
  FROM zakaznik z
  WHERE z.id_zakaznik IN (
    SELECT v.id_zakaznik
    FROM vozidlo v
  )
  ORDER BY z.id_zakaznik;

D16 - M
  SELECT *
  FROM zakazky_se_zakazniky
  WHERE stav_zakazky = 'v_realizaci';

D17 - A, B, F4
  SELECT d.*
  FROM dil d
  LEFT JOIN dil_servisni_ukon dsu ON d.kod = dsu.kod
  WHERE dsu.id_ukonu IS NULL;

D18 - A, F1, H1
  SELECT *
  FROM zakaznik z
  JOIN vozidlo v ON v.id_zakaznik = z.id_zakaznik
  WHERE v.znacka = 'Mercedes-Benz'
  
  UNION
  
  SELECT *
  FROM zakaznik z
  JOIN vozidlo v ON v.id_zakaznik = z.id_zakaznik
  WHERE v.znacka = 'Audi';

D19 - A, F1, H2
  SELECT 
      v.vin, 
      v.spz, 
      v.id_zakaznik, 
      v.znacka, 
      v.model, 
      v.rok_vyroby,
      za.id_zakazky, 
      za.datum_prijeti, 
      za.stav_zakazky, 
      za.poznamka
  FROM vozidlo v
  JOIN zakazka za ON za.vin = v.vin
  
  EXCEPT
  
  SELECT 
      v.vin, 
      v.spz, 
      v.id_zakaznik, 
      v.znacka, 
      v.model, 
      v.rok_vyroby,
      za.id_zakazky, 
      za.datum_prijeti, 
      za.stav_zakazky, 
      za.poznamka
  FROM vozidlo v
  JOIN zakazka za ON za.vin = v.vin
  WHERE za.stav_zakazky = 'dokoncena';

D20 - A, F1, G2, I1, I2
  SELECT *
  FROM (
    SELECT
      z.id_zakaznik,
      z.jmeno,
      z.prijmeni,
      z.email,
      COUNT(*) AS pocet_zakazek
    FROM zakaznik z
    JOIN vozidlo v ON v.id_zakaznik = z.id_zakaznik
    JOIN zakazka za ON za.vin = v.vin
    GROUP BY z.id_zakaznik, z.jmeno, z.prijmeni, z.email
  ) t
  WHERE t.pocet_zakazek >= 1;

D21 - A, F1, H3
  SELECT v.*
  FROM vozidlo v
  JOIN zakazka za ON za.vin = v.vin
  
  INTERSECT
  
  SELECT v.*
  FROM vozidlo v
  JOIN zakazka za ON za.vin = v.vin
  JOIN servisni_ukon su ON su.id_zakazky = za.id_zakazky;

D22 - C, F1, G1, H2
  SELECT *
  FROM mechanik m
  WHERE m.osobni_cislo IN (
    SELECT msu.osobni_cislo
    FROM mechanik_servisni_ukon msu
    JOIN servisni_ukon su ON su.id_ukonu = msu.id_ukonu
    WHERE su.stav_ukonu = 'dokonceno'
  )
  EXCEPT
  SELECT *
  FROM mechanik m
  WHERE m.osobni_cislo IN (
    SELECT msu.osobni_cislo
    FROM mechanik_servisni_ukon msu
    JOIN servisni_ukon su ON su.id_ukonu = msu.id_ukonu
    WHERE su.stav_ukonu <> 'dokonceno'
  );

D23 - I1, N
  -- začneme v transakci, aby nám insert neovlivnil databázi
  BEGIN;
  
  -- ověříme si počet záznamů před insertem
  SELECT COUNT(*)
  FROM servisni_ukon;
  
  -- provedeme insert (typ N = INSERT ... SELECT)
  -- vložíme nový "automatický" servisní úkon pro zakázky ve stavu 'prijata'
  -- LIMIT zajistí, že vložíme max 5 řádků
  INSERT INTO servisni_ukon
  (id_zakazky, nazev, popis, plan_hodin, skutecnost_hodin, hodinova_sazba, stav_ukonu)
  SELECT
    za.id_zakazky,
    'Vstupni kontrola',
    'Automaticky generovana kontrola pri prijeti',
    0.50,
    0.00,
    800.00,
    'naplanovano'
  FROM zakazka za
  WHERE za.stav_zakazky = 'prijata'
  ORDER BY za.id_zakazky
  LIMIT 5;
  
  -- ověříme počet řádků po vložení
  SELECT COUNT(*)
  FROM servisni_ukon;
  
  -- zrušíme naši transakci
  ROLLBACK;
  
  -- zkontrolujeme, že stav je jako před transakcí
  SELECT COUNT(*)
  FROM servisni_ukon;

D24 - G1, I1, P
  -- začneme transakci, aby delete neovlivnil databázi
  BEGIN;
  
  -- ověříme počet záznamů před smazáním
  SELECT COUNT(*)
  FROM platba;
  
  -- provedeme delete (typ P = DELETE s vnořeným SELECT)
  DELETE FROM platba
  WHERE cislo_faktury IN (
    SELECT f.cislo_faktury
    FROM faktura f
    WHERE f.stav_faktury = 'nezaplacena'
  );
  
  -- ověříme počet záznamů po smazání
  SELECT COUNT(*)
  FROM platba;
  
  -- zrušíme změny
  ROLLBACK;
  
  -- zkontrolujeme, že stav je stejný jako před transakcí
  SELECT COUNT(*)
  FROM platba;

D25 - G1, I1, I2, O
  -- začneme transakci, aby update neovlivnil databázi
  BEGIN;
  
  -- zkontrolujeme stav zakázek před změnou
  SELECT *
  FROM zakazka
  WHERE id_zakazky IN (
    SELECT su.id_zakazky
    FROM servisni_ukon su
    GROUP BY su.id_zakazky
    HAVING COUNT(*) =
           COUNT(CASE WHEN su.stav_ukonu = 'dokonceno' THEN 1 END)
  );
  
  -- provedeme update (typ O = UPDATE s vnořeným SELECT)
  UPDATE zakazka
  SET stav_zakazky = 'dokoncena'
  WHERE id_zakazky IN (
    SELECT su.id_zakazky
    FROM servisni_ukon su
    GROUP BY su.id_zakazky
    HAVING COUNT(*) =
           COUNT(CASE WHEN su.stav_ukonu = 'dokonceno' THEN 1 END)
  );
  
  -- zkontrolujeme stav zakázek po změně
  SELECT *
  FROM zakazka
  WHERE id_zakazky IN (
    SELECT su.id_zakazky
    FROM servisni_ukon su
    GROUP BY su.id_zakazky
    HAVING COUNT(*) =
           COUNT(CASE WHEN su.stav_ukonu = 'dokonceno' THEN 1 END)
  );
  
  -- vrátíme změny zpět
  ROLLBACK;
  
  -- ověříme, že stav je stejný jako před transakcí
  SELECT *
  FROM zakazka;

D26 - D1, G1, G4
  SELECT *
  FROM mechanik m
  WHERE NOT EXISTS (
    SELECT *
    FROM servisni_ukon su
    WHERE su.id_zakazky = 2
      AND NOT EXISTS (
        SELECT *
        FROM mechanik_servisni_ukon msu
        WHERE msu.osobni_cislo = m.osobni_cislo
          AND msu.id_ukonu = su.id_ukonu
      )
  );

D27 - D2, G1, G4, H2
  SELECT *
  FROM servisni_ukon
  WHERE id_zakazky = 2
  EXCEPT
  SELECT *
  FROM servisni_ukon su
  WHERE id_ukonu IN (
      SELECT id_ukonu
      FROM mechanik_servisni_ukon msu
      WHERE id_ukonu = su.id_ukonu
        AND osobni_cislo IN (
            -- Začátek ověřované části
            SELECT osobni_cislo
            FROM mechanik m
            WHERE NOT EXISTS (
              SELECT *
              FROM servisni_ukon su2
              WHERE su2.id_zakazky = 2
                AND NOT EXISTS (
                  SELECT *
                  FROM mechanik_servisni_ukon msu2
                  WHERE msu2.osobni_cislo = m.osobni_cislo
                    AND msu2.id_ukonu = su2.id_ukonu
                )
            )
            -- Konec ověřované části
        )
  );
