

INSERT INTO ferienwohnung VALUES (Paradies, 1, 15, 320, 'AMHKNP'); 

INSERT INTO land VALUES('Deutschland');
INSERT INTO land VALUES('Kroatien');
INSERT INTO land VALUES('Spanien');
INSERT INTO land VALUES('Schweiz');
INSERT INTO land VALUES('Weltraum');

INSERT INTO ausstattung VALUES('Swimming Pool');
INSERT INTO ausstattung VALUES('Küche');
INSERT INTO ausstattung VALUES('Sauna');
INSERT INTO ausstattung VALUES('Tennisplatz');
INSERT INTO ausstattung VALUES('Waschsalon');
INSERT INTO ausstattung VALUES('Fitnessraum');
INSERT INTO ausstattung VALUES('Balkon');

INSERT INTO touristenattraktion VALUES('Europapark', 'Der Europa-Park ist ein Freizeit- und Themenpark in Rust,
Baden-Württemberg.');
INSERT INTO touristenattraktion VALUES('Konstanzer Münster', 'Das Konstanzer Münster ist seit 13. August 1955
eine Basilica minor in Konstanz am Bodensee.');
INSERT INTO touristenattraktion VALUES('Bodensee', 'Der Bodensee ist ein 63 km langer See zwischen Deutschland,
Österreich und der Schweiz');
INSERT INTO touristenattraktion VALUES('Mainau', 'Ausflugsinsel am Bodensee');
INSERT INTO touristenattraktion VALUES('Fernsehturm', '368 m hoher Turm, eröffnet 1969, mit Aussichtsplattform in 203 m Höhe');

INSERT INTO adresse VALUES('DEKN0', 'Konstanz', 'Hans-Sauerbruch-Straße', '2', 'Deutschland');
INSERT INTO adresse VALUES('DEB00', 'Berlin', 'Unter den Linden', '77', 'Deutschland');
INSERT INTO adresse VALUES('CHZ00', 'Zürich', 'Kurhausstrasse', '65', 'Schweiz');
INSERT INTO adresse VALUES('ESB00', 'Barcelona', 'Arriba-Arriba-vía', '1337', 'Spanien');
INSERT INTO adresse VALUES('ESB01', 'Barcelona', 'pablo-escobar-via', '420', 'Spanien');
INSERT INTO adresse VALUES('ESB02', 'Barcelona', 'casa-de-papel-via', '69', 'Spanien');
INSERT INTO adresse VALUES('ESB03', 'Barcelona', 'via-de-taco', '137', 'Spanien');
INSERT INTO adresse VALUES('DEKN1', 'Konstanz', 'Rheingutstraße', '36', 'Deutschland');
INSERT INTO adresse VALUES('IPCP1', 'CORUSCANT', 'Imperial-Palace', '1', 'Weltraum');
INSERT INTO adresse VALUES('GXTA1', 'Tatooine', 'Somewhere in the Desert', '42', 'Weltraum');
INSERT INTO adresse VALUES('WGBW1', 'Irgendwo', 'Irgendwo-Im-Nirgendwo', '42', 'Deutschland');

INSERT INTO ferienwohnung VALUES('Harbor Apartments', 3, 21.50, 200.00, 'DEKN0');  
INSERT INTO ferienwohnung VALUES('Adlon Suites', 10, 500, 10000.00, 'DEB00');
INSERT INTO ferienwohnung VALUES('Dolder Grand Ferienwohnungen', 5, 200, 400.00, 'CHZ00');
INSERT INTO ferienwohnung VALUES('Un Poco Loco', 4, 420, 150.00, 'ESB00');
INSERT INTO ferienwohnung VALUES('Hacienda Napoles', 10, 800, 14.000, 'ESB01');
INSERT INTO ferienwohnung VALUES('Manuelas Albergue', 2, 120, 50.00, 'ESB02');
INSERT INTO ferienwohnung VALUES('Hotel Tapas', 3, 120, 50.00, 'ESB03');
INSERT INTO ferienwohnung VALUES('Hotel Tequila', 4, 120, 60.00, 'ESB03');
INSERT INTO ferienwohnung VALUES('AMH', 1, 15, 320.00, 'DEKN1');


INSERT INTO kunde VALUES('darthvader@imperial-mail.glxy', 'jointhedarkside1977!', 'IP00000000000000000001', 'Darth', 'Vader',
'1', 'IPCP1');
INSERT INTO kunde VALUES('ben-kenobi@jedi.glxy', 'ihavethehighground4', 'JD66664444555563278991', 'Kenobi', 'Ben',
'0', 'GXTA1');
INSERT INTO kunde VALUES('benjamin@bruenau.de', 'pw1234', 'DE17470242000339756691', 'Brünau', 'Benjamin', '0', 'DEKN1');
INSERT INTO kunde VALUES('hanswurst55@gmail.com', 'sehrsicher99?', 'DE00339756691174702420', 'Mustermann', 'Max', '1', 'WGBW1');
INSERT INTO kunde VALUES('dmlmaster@hotmail.de', 'abcdefgh1', 'DE45566911743397702420', 'Frosch', 'Walter', '1', 'WGBW1');


INSERT INTO bilder VALUES ('Test1', hextoraw('453d7a34'), 'AMH');
INSERT INTO bilder VALUES ('Test2', hextoraw('FFFFFa45'), 'AMH');
INSERT INTO bilder VALUES ('Test3', hextoraw('453d7a34'), 'Un Poco Loco');
INSERT INTO bilder VALUES ('Test4', hextoraw('453d7a34'), 'Adlon Suites');
INSERT INTO bilder VALUES ('Test5', hextoraw('453d7a34'), 'Harbor Apartments');
INSERT INTO bilder VALUES ('Test6', hextoraw('453d7a34'), 'Dolder Grand Ferienwohnungen');

INSERT INTO besitzt VALUES ('Swimming Pool', 'Dolder Grand Ferienwohnungen');
INSERT INTO besitzt VALUES ('Küche', 'AMH');
INSERT INTO besitzt VALUES ('Waschsalon', 'AMH');
INSERT INTO besitzt VALUES ('Waschsalon', 'Un Poco Loco');
INSERT INTO besitzt VALUES ('Küche', 'Un Poco Loco');
INSERT INTO besitzt VALUES ('Tennisplatz', 'Un Poco Loco');
INSERT INTO besitzt VALUES ('Swimming Pool', 'Adlon Suites');
INSERT INTO besitzt VALUES ('Sauna', 'Adlon Suites');
INSERT INTO besitzt VALUES ('Fitnessraum', 'Adlon Suites');
INSERT INTO besitzt VALUES ('Balkon', 'Adlon Suites');
INSERT INTO besitzt VALUES ('Sauna', 'Un Poco Loco');
INSERT INTO besitzt VALUES ('Sauna', 'Hacienda Napoles');
INSERT INTO besitzt VALUES ('Sauna', 'Hotel Tapas');
INSERT INTO besitzt VALUES ('Sauna', 'Hotel Tequila');

INSERT into in_der_naehe_von VALUES ('AMH', 'Europapark', 50);
INSERT into in_der_naehe_von VALUES ('Adlon Suites', 'Europapark', 50);
INSERT into in_der_naehe_von VALUES ('AMH', 'Konstanzer Münster', 2);
INSERT into in_der_naehe_von VALUES ('AMH', 'Bodensee', 0.5);
INSERT into in_der_naehe_von VALUES ('Adlon Suites', 'Fernsehturm', 3);


INSERT into buchung(buchungsnr, datum_start, datum_end, datum_B, fw_name, mailadr)
VALUES (999999, '24-12-2020', '25-12-2020', '07-12-2020', 'Adlon Suites', 'darthvader@imperial-mail.glxy');

INSERT into buchung(buchungsnr, datum_start, datum_end, datum_B, fw_name, mailadr)
VALUES (1, '01-08-2021', '25-12-2021', '30-12-2020', 'Un Poco Loco', 'ben-kenobi@jedi.glxy');

INSERT into buchung VALUES(2, '14-10-2020', '05-12-2020', '28-08-2020', '06-12-2020', 5, 'ABC001', 800.42, '29-08-2020',
'AMH', 'benjamin@bruenau.de');

INSERT into buchung VALUES(3, '01-12-2020', '05-12-2020', '30-11-2020', NULL, NULL, 'ABC002', 666.66, '03-12-2020',
'Adlon Suites', 'dmlmaster@hotmail.de');

INSERT into buchung VALUES(4, '01-01-2018', '05-01-2018', '30-12-2017', '10-01-2018', 5, 'ESB01', 66.000, '02-01-2018',
'Hacienda Napoles', 'dmlmaster@hotmail.de');

INSERT into buchung VALUES(5, '01-11-2019', '21-11-2019', '30-12-2017', '01-12-2019', 3, 'ESB02', 400.00, '02-11-2019',
'Manuelas Albergue', 'dmlmaster@hotmail.de');

INSERT into buchung VALUES(6, '01-11-2020', '21-11-2020', '30-12-2019', '01-12-2020', 3, 'ESB02', 400.00, '02-11-2020',
'Manuelas Albergue', 'dmlmaster@hotmail.de');

INSERT into buchung VALUES(7, '15-10-2019', '15-11-2019', '30-12-2018', '01-12-2019', 3, 'ESB01', 400.00, '02-11-2019',
'Hacienda Napoles', 'dmlmaster@hotmail.de');

INSERT into buchung VALUES(8, '01-08-2020', '14-08-2020', '20-07-2020', '01-12-2020', 4, 'ESB02', 450.00, '02-08-2020',
'Hacienda Napoles', 'hanswurst55@gmail.com');

INSERT into buchung VALUES(9, '01-10-2020', '14-10-2020', '20-09-2020', '01-12-2020', 5, 'ESB00', 460.00, '02-10-2020',
'Un Poco Loco', 'hanswurst55@gmail.com');

INSERT into buchung VALUES(10, '01-01-2020', '14-01-2020', '20-12-2019', '01-02-2020', 4, 'ESB03', 460.00, '02-01-2020',
'Hotel Tequila', 'hanswurst55@gmail.com');

INSERT into buchung VALUES(11, '14-10-2018', '05-12-2018', '28-08-2018', '06-12-2018', 5, 'ABC001', 800.42, '29-08-2018',
'Harbor Apartments', 'benjamin@bruenau.de');

CREATE SEQUENCE b_nr Increment by 1 START WITH 100;
--//CREATE SEQUENCE buchungsnr Increment by 1 START WITH 100;

INSERT into anzahlung VALUES('ANZ01', 150.42, '09-09-2020', 2);
INSERT into anzahlung VALUES('ANZ02', 333.33, '01-12-2020', 3);


UPDATE in_der_naehe_von
    SET entfernung = 2
    WHERE fw_name in ('AMH') AND attraktions_name in ('Konstanzer Münster');

DELETE buchung WHERE buchungsnr = 999999;

commit;










