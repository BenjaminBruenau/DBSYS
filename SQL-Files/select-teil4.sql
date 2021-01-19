 
                          
/* Teil 4.1 */

SELECT a.stadt, COUNT(*) AS "Anzahl Ferienwohnungen"
FROM dbsys26.ferienwohnung f
INNER JOIN dbsys26.adresse a ON a.adress_ID = f.adress_ID
GROUP BY a.stadt;


/* Teil 4.2 */

SELECT f.fw_name
FROM dbsys26.ferienwohnung f
INNER JOIN dbsys26.adresse a ON a.adress_ID = f.adress_ID 
WHERE a.landname = 'Spanien' AND 4 < (select AVG(b.sterne)
                                      FROM dbsys26.buchung b       
                                      WHERE f.fw_name = b.fw_name);


/* Teil 4.3 */

Select f.fw_name
FROM dbsys26.ferienwohnung f
LEFT JOIN dbsys26.buchung b ON f.fw_name = b.fw_name
WHERE b.fw_name IS NULL;


/* Teil 4.4 */

CREATE VIEW Max_Ausstattungen( fw_name, anzahl)
AS
SELECT be.fw_name, COUNT(*)
FROM dbsys26.besitzt be
GROUP BY be.fw_name;

SELECT m.fw_name, m.anzahl
FROM Max_Ausstattungen m
WHERE m.anzahl = (SELECT MAX(anzahl)
                FROM  Max_Ausstattungen);



/* Teil 4.5 */

SELECT l.land_name, NVL(COUNT(b.buchungsnr),0) AS "Anzahl Reservierungen pro Land"
FROM dbsys26.land l
LEFT JOIN dbsys26.adresse a  ON a.landname = l.land_name
LEFT JOIN dbsys26.ferienwohnung f ON f.adress_ID = a.adress_ID
LEFT JOIN dbsys26.buchung b ON b.fw_name = f.fw_name
GROUP BY l.land_name
ORDER BY NVL(COUNT(b.buchungsnr),0) DESC;


/* Teil 4.6 */

Select f.fw_name, FLOOR(AVG(b.sterne))
FROM dbsys26.ferienwohnung f
LEFT JOIN dbsys26.buchung b ON b.fw_name = f.fw_name
LEFT JOIN dbsys26.adresse a ON a.adress_ID = f.adress_ID
LEFT JOIN dbsys26.besitzt be ON be.fw_name = f.fw_name
WHERE a.landname = 'Spanien' 
AND f.fw_name NOT IN 
(
    select b2.fw_name
    FROM dbsys26.buchung b2
    WHERE '01.11.2019' < b2.datum_end AND b2.datum_end < '21.11.2019'
    OR '01.11.2019' < b2.datum_start  AND b2.datum_start < '21.11.2019'   
    OR b2.datum_start < '01.11.2019' AND b2.datum_end > '21.11.2019'
)
--AND be.au_name = 'Sauna'
GROUP BY f.fw_name
ORDER BY FLOOR(AVG(b.sterne)) DESC NULLS LAST;

SELECT dbsys26.buchungsnr.NextVal from dual;

    




