CREATE DATABASE db_practica_triggers 
USE db_practica_triggers 

CREATE TABLE empleados(
codigo INT PRIMARY KEY,
nombre VARCHAR(50),
apellido VARCHAR(50),
telefono INT,
fechaRegistro DATE
)

CREATE TABLE AuditoriaEmpleado(
codigo INT PRIMARY KEY,
fechaModificacion DATE,
detalle VARCHAR(200)
)

INSERT INTO empleados(codigo,nombre,apellido,telefono,fechaRegistro)
VALUES(1001,'Diego','Celis',79388393,GETDATE())
INSERT INTO empleados(codigo,nombre,apellido,telefono,fechaRegistro)
VALUES(1002,'Manuel','Serpas',79388393,GETDATE())
INSERT INTO empleados(codigo,nombre,apellido,telefono,fechaRegistro)
VALUES(1003,'Zulma','Rivera',79388393,GETDATE())

CREATE OR ALTER TRIGGER TR_AudiEmpleados
ON empleados
AFTER UPDATE
AS
BEGIN
INSERT INTO AuditoriaEmpleado
(codigo,fechaModificacion,detalle)
SELECT codigo,GETDATE(),'Se modifico el empleado'
FROM inserted
END

CREATE OR ALTER TRIGGER TR_Verificacion
ON empleados
INSTEAD OF INSERT
AS
BEGIN
IF EXISTS(
SELECT inserted.codigo
FROM inserted
INNER JOIN empleados ON inserted.codigo=empleados.codigo
WHERE empleados.codigo=inserted.codigo
)
BEGIN
PRINT('El codigo de empleado ya existe');
ROLLBACK;
END;
ELSE 
INSERT INTO empleados(codigo,nombre,apellido,telefono,fechaRegistro)
SELECT codigo,nombre,apellido,telefono,fecharegistro FROM inserted
END;

UPDATE empleados SET nombre='Julio' WHERE codigo=1001
SELECT * FROM empleados
SELECT* FROM AuditoriaEmpleado

CREATE TABLE auditorioEliminacion(
codigo INT PRIMARY KEY,
nombre VARCHAR(50),
fechaEliminacion DATE
)


CREATE OR ALTER TRIGGER TR_Historial
ON empleados
INSTEAD OF DELETE
AS
BEGIN
INSERT INTO auditorioEliminacion(codigo,nombre,fechaEliminacion)
SELECT codigo,nombre,getdate() FROM deleted
DELETE FROM empleados
WHERE empleados.codigo IN (SELECT codigo FROM deleted);
END;

DELETE FROM empleados WHERE codigo=1002
SELECT* FROM empleados
SELECT*FROM auditorioEliminacion

SELECT* FROM empleados

/*Parte Practica*/
CREATE TABLE productos (
    codigo VARCHAR(50) PRIMARY KEY,
    nombreproducto VARCHAR(255),
    fecharegistro DATE
);

CREATE TABLE inventario (
    id INT PRIMARY KEY,
    codigoProducto VARCHAR(50),
    existencias INT,
    FOREIGN KEY (codigoProducto) REFERENCES productos(codigo)
);

CREATE TABLE auditoria (
    idinventario INT,
    nombreproducto VARCHAR(255),
    proceso VARCHAR(255),
    fechaevento TIMESTAMP,
    FOREIGN KEY (idinventario) REFERENCES inventario(id)
);



/*Insert*/
INSERT INTO productos (codigo, nombreproducto, fecharegistro)
VALUES ('AE202', 'Kilo de Azucar de 2.5 ', '2023-09-29'),
       ('BF101', 'Caja de Aceite Orisol Botella (750ml)', '2023-09-29'),
       ('CG303', 'Caja shakalaka (sixpack)', '2023-09-29');

INSERT INTO auditoria (idinventario, nombreproducto, proceso, fechaevento)
VALUES (1, 'Fardo Harina de comal Extra Suave ', 'Venta',DEFAULT),
       (2, 'Fardo de Salvacola surtido) ', 'Devolución', DEFAULT),
       (3, '3 Cajas de Frijoles La chula 1kg', 'Venta', DEFAULT);

SELECT*FROM auditoria

INSERT INTO inventario (id, codigoProducto, existencias)
VALUES (1, 'AE202', 30),
       (2, 'BF101', 25),
       (3, 'CG303', 18);

SELECT* FROM inventario
/*triggers*/
CREATE TRIGGER before_insert_inventario
ON inventario
BEFORE INSERT
AS
BEGIN
    SET NOCOUNT ON;

    IF EXISTS (SELECT 1 FROM inserted i INNER JOIN inventario inv ON i.codigo_producto = inv.codigo_producto)
    BEGIN
        RAISEERROR('Error: El código de producto ya existe en el inventario.', 16, 1);
        ROLLBACK TRANSACTION; -- Si estás dentro de una transacción, puedes revertirla
    END
END;



CREATE OR ALTER TRIGGER tr_inventario_elimination_audit
ON inventario 
AFTER DELETE
AS
BEGIN
    -- Insertar el registro eliminado en la tabla auditoria
    INSERT INTO auditoria (idinventario, nombreproducto, proceso, fechaevento)
    SELECT deleted.id, deleted.codigoProducto, 'Eliminación', GETDATE()
    FROM deleted;

    -- Eliminar el registro de la tabla inventario
    DELETE FROM inventario
    FROM deleted
    WHERE inventario.id = deleted.id;
END;
