--CREACION DE TRIGGERS
USE RefaccionariaAutomotriz;
--ALTER TABLE [2021].VentasRefacciones ADD FOREIGN KEY (idrefaccion) REFERENCES [dbo].Refacciones(idrefaccion);

---Tabla que guarda las insercciones nuevas por medio del trigger
CREATE TABLE InsertedRefaccion(
	id_auditoria int identity primary key,
	id_refac int, 
	nombre_R varchar(40),
	usuario varchar(40),
	fecha datetime,
	accion varchar (25)
);

--Tabla que guarda las eliminaciones por medio del trigger
CREATE TABLE DeletedRefaccion(
	id_auditoria int identity primary key,
	id_refac int, 
	usuario varchar(40),
	fecha datetime,
	accion varchar (25)
);


--INSERT TRIGGER
CREATE TRIGGER TR_RefacInserted ON [dbo].Refacciones AFTER INSERT 
AS
SET NOCOUNT ON
DECLARE @id_refac int, @nombre_R varchar(40);
SELECT @id_refac=I.idrefaccion, @nombre_R=I.nombrerefaccion FROM inserted as I;

INSERT INTO InsertedRefaccion (id_refac,nombre_R,usuario,fecha,accion) 
VALUES(@id_refac, @nombre_R, SYSTEM_USER, GETDATE(), 'insertado');
GO

INSERT INTO Refacciones VALUES('Llanta Rin 14', 'TORNEL', 'At 09', 1500, 10);
INSERT INTO Refacciones VALUES('Llanta Rin 15', 'NEXEN', 'Cp661', 1400, 12);
INSERT INTO Refacciones VALUES('Llanta Rin 16', 'CONTINENTAL', 'Conti Procontact', 2500, 14);
INSERT INTO Refacciones VALUES('Llanta Rin 17', 'SAILUN', 'Terramax H/T', 2000, 20);
INSERT INTO Refacciones VALUES('Llanta Rin 18', 'YOKOHAMA', 'Advsport', 1200, 15);
INSERT INTO Refacciones VALUES('Llanta Rin 19', 'SAILUN', 'Terramax H/T', 1000, 18);

SELECT * FROM Refacciones;
SELECT * FROM InsertedRefaccion;

TRUNCATE TABLE Refacciones;
TRUNCATE TABLE InsertedRefaccion;
TRUNCATE TABLE DeletedRefaccion;

--ALTER TABLE [2021].VentasRefacciones DROP CONSTRAINT FK__VentasRef__idref__3D5E1FD2;
--TRUNCATE TABLE Refacciones;
--ALTER TABLE [2021].VentasRefacciones ADD FOREIGN KEY (idrefaccion) REFERENCES [dbo].Refacciones(idrefaccion);


--DELETE TRIGGER
CREATE TRIGGER TR_DeletedRefaccion ON Refacciones AFTER DELETE
AS
SET NOCOUNT ON
DECLARE @id_refac int;
SELECT @id_refac = D.idrefaccion FROM deleted AS D;

INSERT INTO DeletedRefaccion (id_refac,usuario,fecha,accion) 
VALUES(@id_refac, SYSTEM_USER, GETDATE(), 'Eliminado');
GO

SELECT * FROM Refacciones;
SELECT * FROM DeletedRefaccion;

DELETE FROM Refacciones WHERE idrefaccion=5;
DELETE FROM Refacciones WHERE idrefaccion=6; 


--UPDATE TRIGGER
ALTER TRIGGER TR_UpdatedVentas ON Refacciones AFTER UPDATE
AS
DECLARE @existencia int;
SELECT @existencia= I.existencia FROM inserted as I;

IF(@existencia<0 OR @existencia > 100)
	BEGIN
		PRINT('El valor no puede ser negativo, debe estar entre 0 y 100')
		ROLLBACK;
	END
ELSE
	BEGIN
		RETURN	
	END
GO

SELECT * FROM Refacciones;

UPDATE Refacciones SET existencia=-5 WHERE idrefaccion=3;
UPDATE Refacciones SET existencia=6 WHERE idrefaccion=2;



ELSE 
	DECLARE @id_refac int, @nombreR varchar(40);
	SELECT @id_refac= Refacciones.idrefaccion, @nombreR=Refacciones.nombrerefaccion FROM Refacciones;
	INSERT INTO InsertedRefaccion(id_refac,nombre_R,usuario,fecha,accion)
	VALUES(@id_refac, @nombreR,SYSTEM_USER, GETDATE(),'Actualizacion');

INSERT INTO [2021].VentasRefacciones VALUES();
INSERT INTO [2021].VentasRefacciones VALUES();
INSERT INTO [2021].VentasRefacciones VALUES();