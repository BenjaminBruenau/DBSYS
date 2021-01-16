
CREATE TABLE land
( land_name              varchar2(56) NOT NULL,
  CONSTRAINT land_pk PRIMARY KEY(land_name)
);

CREATE TABLE ausstattung
( au_name           varchar2(30) NOT NULL,
  CONSTRAINT ausstattung_pk PRIMARY KEY(au_name)
);

CREATE TABLE touristenattraktion
( attraktions_name  varchar2(30) NOT NULL,
  beschreibung      varchar2(100) NOT NULL,
  CONSTRAINT touristenattraktion_pk PRIMARY KEY(attraktions_name)
);

CREATE TABLE adresse
( adress_ID         char(5) NOT NULL,
  stadt             varchar(30) NOT NULL,
  strasse           varchar(30) NOT NULL,
  hausnr            varchar(5) NOT NULL,
  landname          varchar(56) NOT NULL,
  CONSTRAINT adresse_pk PRIMARY KEY(adress_ID),
  CONSTRAINT adresse_fk FOREIGN KEY(landname) REFERENCES land(land_name)
);

CREATE TABLE ferienwohnung
( fw_name           varchar2(30) NOT NULL,
  zimmer_anzahl     INTEGER NOT NULL,
  fw_groesse        NUMBER(5, 2) NOT NULL,
  fw_preis          NUMBER(8, 2) NOT NULL,
  adress_ID         char(5) NOT NULL,
  CONSTRAINT ferienwohnung_pk PRIMARY KEY(fw_name),
  CONSTRAINT ferienwohnung_fk FOREIGN KEY(adress_ID) REFERENCES adresse(adress_ID),
  CONSTRAINT ferienwohnungAnzahlZimmer check (zimmer_anzahl > 0),
  CONSTRAINT ferienwohnungGroesse check (fw_groesse > 10),
  CONSTRAINT ferienwohnungPreis check (fw_preis > 0)
);

CREATE TABLE kunde
( mailadr           varchar2(30) NOT NULL check (REGEXP_LIKE(mailadr, '@')),
  passwort          varchar2(20) NOT NULL,
  IBAN              char(22)     NOT NULL,
  vorname           varchar2(30) NOT NULL,
  nachname          varchar2(30) NOT NULL,
  newsletter        char(1) NOT NULL,
  adress_ID         char(5) NOT NULL,
  CONSTRAINT kunde_pk PRIMARY KEY(mailadr),
  CONSTRAINT kunde_fk FOREIGN KEY(adress_ID) REFERENCES adresse(adress_ID),
  CONSTRAINT kundePasswort check (REGEXP_LIKE(passwort, '[0123456789@?!]') AND LENGTH(passwort) >= 6),
  CONSTRAINT kundeNewsletter  check (newsletter in ('1', '0'))
);

CREATE TABLE bilder
( bild_ID           char(5) NOT NULL,
  bild_datei              BLOB NOT NULL,
  fw_name           varchar2(30) NOT NULL,
  CONSTRAINT bilder_pk PRIMARY KEY(bild_ID),
  CONSTRAINT bilder_fk FOREIGN KEY(fw_name) REFERENCES ferienwohnung(fw_name) ON DELETE CASCADE
);

CREATE TABLE besitzt
( au_name           varchar2(30) NOT NULL,
  fw_name           varchar2(30) NOT NULL,
  CONSTRAINT besitzt_fk1 FOREIGN KEY(au_name) REFERENCES ausstattung(au_name) ON DELETE CASCADE,
  CONSTRAINT besitzt_fk2 FOREIGN KEY(fw_name) REFERENCES ferienwohnung(fw_name) ON DELETE CASCADE,
  CONSTRAINT besitzt_pk PRIMARY KEY(au_name, fw_name)
);

CREATE TABLE in_der_naehe_von
( fw_name           varchar2(30) NOT NULL,
  attraktions_name  varchar2(30) NOT NULL,
  entfernung        NUMBER(5, 3) NOT NULL,    
  CONSTRAINT naehe_fk2 FOREIGN KEY(fw_name) REFERENCES ferienwohnung(fw_name) ON DELETE CASCADE,  
  CONSTRAINT naehe_fk1 FOREIGN KEY(attraktions_name) REFERENCES touristenattraktion(attraktions_name) ON DELETE CASCADE,
  CONSTRAINT naehe_pk PRIMARY KEY(fw_name, attraktions_name),
  CONSTRAINT entfernung check (entfernung <= 50 AND entfernung > 0)
);
  
CREATE TABLE buchung
( buchungsnr        INTEGER NOT NULL check (buchungsnr <= 999999),
  datum_start       DATE NOT NULL,
  datum_end         DATE NOT NULL,
  datum_B           DATE NOT NULL,
  datum_BW          DATE,
  sterne            INTEGER,
  rechnungnr        char(6),
  betrag_R          Number(8, 2),
  datum_R           DATE,
  fw_name           varchar2(30) NOT NULL,
  mailadr           varchar2(30) NOT NULL,
  CONSTRAINT buchung_pk PRIMARY KEY(buchungsnr),
  CONSTRAINT buchung_fk1 FOREIGN KEY(fw_name) REFERENCES ferienwohnung(fw_name),
  CONSTRAINT buchung_fk2 FOREIGN KEY(mailadr) REFERENCES kunde(mailadr),
  CONSTRAINT buchungStart check (datum_start > datum_B),
  CONSTRAINT buchungEnde check (datum_end > datum_B AND datum_end > datum_start),
  CONSTRAINT buchungBewertungsDatum check (datum_BW > datum_end),
  CONSTRAINT sterneAnzahl check (sterne <= 5 AND sterne > 0),
  CONSTRAINT rechnungsDatum check (datum_R > datum_B)
);

CREATE TABLE anzahlung
( anz_ID            char(5) NOT NULL,
  betrag_A          Number(8, 2) NOT NULL,
  datum_A           DATE NOT NULL,
  buchungsnr        INTEGER NOT NULL,
  CONSTRAINT stornierte_anzahlung_pk PRIMARY KEY(anz_ID),
  CONSTRAINT stornierte_anzahlung_fk FOREIGN KEY(buchungsnr) REFERENCES buchung(buchungsnr)
);

CREATE TABLE stornierte_anzahlung
( anz_ID_SB            char(5) NOT NULL,
  betrag_A          Number(8, 2) NOT NULL,
  datum_A           DATE NOT NULL,
  buchungsnr        INTEGER NOT NULL,
  CONSTRAINT anzahlung_pk PRIMARY KEY(anz_ID),
  CONSTRAINT anzahlung_fk FOREIGN KEY(buchungsnr) REFERENCES buchung(buchungsnr)
);

CREATE TABLE stornierte_buchungen
( buchungsnr_SB     INTEGER NOT NULL,
  datum_SB          DATE NOT NULL,
  datum_start       DATE NOT NULL,
  datum_end         DATE NOT NULL,
  datum_B           DATE NOT NULL,
  datum_BW          DATE,
  sterne            INTEGER,
  rechnungnr        char(6),
  betrag_R          Number(8, 2),
  datum_R           DATE,
  fw_name           varchar2(30) NOT NULL,
  mailadr           varchar2(30) NOT NULL,
  CONSTRAINT stornierte_buchung_pk PRIMARY KEY(buchungsnr_SB),
  CONSTRAINT stornierte_buchung_fk1 FOREIGN KEY(fw_name) REFERENCES ferienwohnung(fw_name),
  CONSTRAINT stornierte_buchung_fk2 FOREIGN KEY(mailadr) REFERENCES kunde(mailadr),
  CONSTRAINT stornierte_buchungStart check (datum_start > datum_B),
  CONSTRAINT stornierte_buchungEnde check (datum_end > datum_B AND datum_end > datum_start),
  CONSTRAINT stornierte_buchungBewertungsDatum check (datum_BW > datum_end),
  CONSTRAINT stornierte_buchung_sterneAnzahl check (sterne <= 5 AND sterne > 0),
  CONSTRAINT stornierte_buchung_rechnungsDatum check (datum_R > datum_B)
);  
  
  
CREATE OR REPLACE TRIGGER stornierung
    BEFORE DELETE ON buchung
    FOR EACH ROW
    BEGIN
        insert into stornierte_buchungen VALUES(:old.buchungsnr, SYSDATE, :old.datum_start, :old.datum_end, :old.datum_B,
                                                :old.datum_BW, :old.sterne, :old.rechnungnr, :old.betrag_R, :old.datum_R,
                                                :old.fw_name, :old.mailadr);
    END;
/

/*
CREATE OR REPLACE VIEW kundenstatistik AS
SELECT k.mailadr AS "Mailadresse Kunde", NVL(COUNT(b.buchungsnr),0) AS "Anzahl Buchungen", NVL(COUNT(sb.buchungsnr_SB),0) AS "Anzahl Stornierungen", NVL(SUM(b.betrag_R), 0) AS "Summe aller Zahlungen"
FROM kunde k
LEFT JOIN buchung b ON k.mailadr = b.mailadr
LEFT JOIN stornierte_buchungen sb ON k.mailadr = sb.mailadr
GROUP BY k.mailadr;
*/

CREATE OR REPLACE VIEW kundenstatistik_buchungen(mailB, anzB, sumB)
AS
SELECT k.mailadr, NVL(COUNT(b.buchungsnr),0), NVL(SUM(b.betrag_R), 0)
FROM kunde k
LEFT JOIN buchung b ON k.mailadr = b.mailadr
GROUP BY k.mailadr;

CREATE OR REPLACE VIEW kundenstatistik_stornierte_B(mailSB, anzSB) 
AS
SELECT k.mailadr, NVL(COUNT(sb.buchungsnr_SB),0)
FROM kunde k
LEFT JOIN stornierte_buchungen sb ON k.mailadr = sb.mailadr
GROUP BY k.mailadr;



CREATE OR REPLACE VIEW kundenstatistik AS
SELECT a.mailB AS "Mailadresse Kunde", a.anzB AS "Anzahl Buchungen", anzSB AS "Anzahl Stornierungen", a.sumB AS "Summe aller Zahlungen"
FROM kundenstatistik_buchungen a, kundenstatistik_stornierte_B b
WHERE a.mailB = b.mailSB
ORDER BY a.mailB;

select *
FROM kundenstatistik;

select *
FROM stornierte_buchungen;


DELETE buchung WHERE buchungsnr = 999999;






