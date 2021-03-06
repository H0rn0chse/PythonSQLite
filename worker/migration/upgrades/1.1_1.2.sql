PRAGMA foreign_keys=off;
BEGIN TRANSACTION;
DROP VIEW view_ReceiptDetail;
DROP VIEW view_ReceiptAnalysis;
DROP VIEW view_ReceiptList;
DROP VIEW view_databaseInfo;

/*================================================================================
    Schema of Lines table changed
================================================================================*/
ALTER TABLE Lines RENAME TO Lines_temp;
-- Apply schema of new Lines table
CREATE TABLE Lines (
	ID	INTEGER NOT NULL UNIQUE,
	Receipt	INTEGER NOT NULL,
	Value	INTEGER NOT NULL,
	Billing	INTEGER NOT NULL,
	Type	INTEGER NOT NULL,
	PRIMARY KEY(ID),
	FOREIGN KEY(Type) REFERENCES Types(ID)
);
-- copy old data to new table
INSERT INTO Lines(ID, Receipt, Value, Billing, Type)
SELECT ID, Receipt, Value, Billing, Typ
FROM Lines_temp;
-- Delete temporary table
DROP TABLE Lines_temp;

/*================================================================================
    Schema of Settings table changed
================================================================================*/
ALTER TABLE Settings RENAME TO Settings_temp;
-- Apply schema of new Settings table
CREATE TABLE Settings (
	Person	INTEGER NOT NULL,
	Type	INTEGER NOT NULL,
	Version	TEXT NOT NULL,
	PageItems	INTEGER NOT NULL,
	Language	TEXT,
	DefaultDir	TEXT,
	FOREIGN KEY(Type) REFERENCES Types(ID),
	FOREIGN KEY(Person) REFERENCES Persons(ID)
);
-- copy old data to new table
INSERT INTO Settings(Person, Type, Version, PageItems)
SELECT Person, Typ, Version, PageItems
FROM Settings_temp;
-- Delete temporary table
DROP TABLE Settings_temp;
-- Provide default values
UPDATE Settings
SET Version = '1.2',
    Language = 'en_GB',
    DefaultDir = '',
    PageItems = 10;

/*================================================================================
    I18n Table was added
================================================================================*/
CREATE TABLE i18n (
	scriptCode	TEXT NOT NULL,
	de	TEXT,
	en_GB	TEXT,
	PRIMARY KEY(scriptCode)
);
-- insert translation data
INSERT INTO i18n VALUES ('detail.section.title','Beleg Details','Receipt details');
INSERT INTO i18n VALUES ('analysis.section.title','Auswertung','Analysis');
INSERT INTO i18n VALUES ('history.section.title','Verlauf','History');
INSERT INTO i18n VALUES ('settings.section.title','Einstellungen','Settings');
INSERT INTO i18n VALUES ('settings.defaultValues','Standardwerte','Default values');
INSERT INTO i18n VALUES ('common.billingAccount','Abrechnungsperson','Billing account');
INSERT INTO i18n VALUES ('common.billingType','Abrechnungstyp','Billing type');
INSERT INTO i18n VALUES ('settings.lists','Listen','Lists');
INSERT INTO i18n VALUES ('common.persons','Personen','Persons');
INSERT INTO i18n VALUES ('common.accounts','Konten','Accounts');
INSERT INTO i18n VALUES ('common.types','Typen','Types');
INSERT INTO i18n VALUES ('common.stores','Läden','Stores');
INSERT INTO i18n VALUES ('common.save','Speichern','Save');
INSERT INTO i18n VALUES ('common.language','Sprache','Language');
INSERT INTO i18n VALUES ('new.section.title.long','Neuen Beleg anlegen','Add new receipt');
INSERT INTO i18n VALUES ('common.store','Laden','Store');
INSERT INTO i18n VALUES ('common.date','Datum','Date');
INSERT INTO i18n VALUES ('common.account','Konto','Account');
INSERT INTO i18n VALUES ('common.add','Hinzufügen','Add');
INSERT INTO i18n VALUES ('common.reset','Zurücksetzen','Reset');
INSERT INTO i18n VALUES ('common.result','Ergebnis','Result');
INSERT INTO i18n VALUES ('receipt.id','Belegnummer','Receipt id');
INSERT INTO i18n VALUES ('common.delete','Löschen','Delete');
INSERT INTO i18n VALUES ('common.cancel','Abbrechen','Cancel');
INSERT INTO i18n VALUES ('common.id','Id','Id');
INSERT INTO i18n VALUES ('common.value','Wert','Value');
INSERT INTO i18n VALUES ('common.edit','Bearbeiten','Edit');
INSERT INTO i18n VALUES ('analysis.grouping','Gruppierung','Grouping');
INSERT INTO i18n VALUES ('analysis.xAxis','x-Achse','X-Axis');
INSERT INTO i18n VALUES ('analysis.yAxis','y-Achse','Y-Axis');
INSERT INTO i18n VALUES ('filter.apply','Filter anwenden','Apply filter');
INSERT INTO i18n VALUES ('filter.ReceiptID','Belegnummer','Receipt id');
INSERT INTO i18n VALUES ('filter.ReceiptDate','Datum','Date');
INSERT INTO i18n VALUES ('filter.ReceiptAccount','Konto','Account');
INSERT INTO i18n VALUES ('filter.ReceiptStore','Laden','Store');
INSERT INTO i18n VALUES ('filter.ReceiptComment','Kommentar','Comment');
INSERT INTO i18n VALUES ('filter.ReceiptValue','Belegwert','Receipt value');
INSERT INTO i18n VALUES ('filter.LineTypes','Abrechnungstyp','Line type');
INSERT INTO i18n VALUES ('filter.LinePersons','Abrechnungsperson','Line person');
INSERT INTO i18n VALUES ('filter.LineValues','Positionswert','Line value');
INSERT INTO i18n VALUES ('filter.after','Nach','After');
INSERT INTO i18n VALUES ('filter.before','Vor','Before');
INSERT INTO i18n VALUES ('filter.unequal','Ungleich','Unequal');
INSERT INTO i18n VALUES ('filter.equal','Gleich','equal');
INSERT INTO i18n VALUES ('filter.greater','Größer','Greater');
INSERT INTO i18n VALUES ('filter.smaller','Kleiner','Smaller');
INSERT INTO i18n VALUES ('filter.contains','Enthält','Contains');
INSERT INTO i18n VALUES ('filter.containsNot','Enthält nicht','Contains not');
INSERT INTO i18n VALUES ('filter.all','Alle','All');
INSERT INTO i18n VALUES ('filter.none','Keiner','None');
INSERT INTO i18n VALUES ('filter.atLeastOne','Zumindest einer','At least one');
INSERT INTO i18n VALUES ('detail.message.override','Möchtest du noch nicht gespeicherten Belegdaten verwerfen?','Do you want to deny the unsaved changes to the receipt?');
INSERT INTO i18n VALUES ('database.locked','Die Datenbank die du gerade öffnen möchtest ist seit $ gesperrt. Bitte bestätige, dass du die Sperrung aufheben möchtest. Bedenke aber, dass dies Andere und ihre Arbeit beeinträchtigen könnte.','The database you''re trying to access is locked since $. Pease confirm that you want to unlock it. But keep in mind that this might affect other and their work.');
INSERT INTO i18n VALUES ('database.abort','Die geteilte Datenbank wurde von einer anderen Person bearbeitet. Bitte öffne die geteilte Datenbank erneut oder starte das Programm neu.','The shared databas opened by another person. Please reopen the shared database or restart the program.');
INSERT INTO i18n VALUES ('settings.createSharedDatabase','Erstelle Datenbank','Create database');
INSERT INTO i18n VALUES ('settings.openSharedDatabase','Öffne Datenbank','Open database');
INSERT INTO i18n VALUES ('settings.openUserDatabase','Öffne Nutzerdatenbank','Open user database');
INSERT INTO i18n VALUES ('settings.setDefaultDatabase','Setze aktuelle Datenbank als Standard','Set current database as default');
INSERT INTO i18n VALUES ('common.confirm','Bestätigen','Confirm');
INSERT INTO i18n VALUES ('database.openDefault','Öffne Nutzerdatenbank','Open user database');
INSERT INTO i18n VALUES ('settings.databaseSettings','Datenbankeinstellungen','Database settings');
INSERT INTO i18n VALUES ('settings.currentDatabase','Aktuelle Datenbank','Current database');

/*================================================================================
    Restore Views
================================================================================*/
CREATE VIEW view_ReceiptDetail AS
	SELECT
		l.ID as LineID,
		r.ID as ReceiptID,
		r.Date as ReceiptDate,
		r.Account as ReceiptAccount,
		r.Store as ReceiptStore,
		r.Comment as ReceiptComment,

		l.Value as LineValue,
		l.Billing as LineBilling,
		l.Type as LineType


	FROM Lines l
	LEFT JOIN Receipts r
		ON l.Receipt = r.ID;
CREATE VIEW view_ReceiptAnalysis as
	SELECT
		r.Date as sortDate,

		r.ID as yID,
		l.Value as yValue,

		strftime('%m-%Y', datetime(r.Date, 'unixepoch')) as xTime,
		a.DisplayName as xAccount,
		s.DisplayName as xStore,
		t.DisplayName as xType,
		p.DisplayName as xBilling

	FROM Lines l
		LEFT JOIN Receipts r
			ON r.ID = l.Receipt
		LEFT JOIN Persons p
			ON p.ID = l.Billing
		LEFT JOIN Types t
			ON t.ID = l.Type
		LEFT JOIN Stores s
			ON s.ID = r.Store
		LEFT JOIN Accounts a
			on a.ID = r.Account;
CREATE VIEW view_ReceiptList AS
	SELECT
		r.ID as ReceiptID,
		r.Date as ReceiptDate,
		a.DisplayName as ReceiptAccount,
		s.DisplayName as ReceiptStore,
		r.Comment as ReceiptComment,

		aggLines.ReceiptValue as ReceiptValue,
		aggLines.LineTypes,
		aggLines.LinePersons,
		aggLines.LineValues


	FROM Receipts r
	LEFT JOIN Accounts a
		ON a.ID = r.Account
	LEFT Join Stores s
		ON s.ID = r.Store
	LEFT JOIN (SELECT
		l.Receipt as ReceiptID,
		json_group_array(DISTINCT t.DisplayName) as LineTypes,
		json_group_array(DISTINCT p.DisplayName) as LinePersons,
		json_group_array(DISTINCT l.Value) as LineValues,
		SUM(Value) as ReceiptValue
	FROM Lines l
	LEFT JOIN Types t
		ON t.ID = l.Type
	LEFT JOIN Persons p
		ON p.ID = l.Billing
	GROUP BY l.Receipt) aggLines
		ON aggLines.ReceiptID = r.ID;
CREATE VIEW view_databaseInfo
as
SELECT
	count(DISTINCT r.ID) AS ReceiptCount,
	json_group_array(DISTINCT l.ID) AS LineIdList,
	json_group_array(DISTINCT r.ID) AS ReceiptIdList
from Receipts r
LEFT JOIN Lines l;

COMMIT;
PRAGMA foreign_keys=on;