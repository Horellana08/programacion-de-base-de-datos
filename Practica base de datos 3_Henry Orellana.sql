--1 Seleccione todos los campos de la tabla, pero conviértalos con un alias a español
select ProductID as id, Name as 'nombre',
ProductNumber as 'Numero de Producto',
Color , SafetyStockLevel 'Filtros de existencia'
from Production.Product

--2 Seleccione todos los registros de la tabla donde Weight sean distintos de null.
SELECT *FROM Production.Product
WHERE  Weight IS NOT NULL;

--3 Cree una consulta que permita una búsqueda por Name completo.
SELECT * FROM Production.Product WHERE Name = 'Adjustable Race';

--4 Cree una consulta que permita una búsqueda por Name usando coincidencia
SELECT * FROM Production.Product WHERE 
Name LIKE 'Ad%';

--5 Selecciona 4 campos cualquiera de la tabla, pero el ultimo debe de ser SellStartDate y
mostraremos solamente el año de la fecha

SELECT *FROM Production.Product
SELECT ProductID , Name , ProductNumber , YEAR(SellStartDate) AS 'Año_de_Venta'
FROM Production.Product

--6 Seleccione 5 campos de la tabla y el ultimo campo debe de ser ListPrice donde los precios
ronden entre 100 y 1000

SELECT ProductID, Name, ProductNumber, SellStartDate, ListPrice
FROM Production.Product WHERE ListPrice BETWEEN 100 AND 1000;

--7 Seleccione 5 campos de la tabla y el ultimo debe de ser color donde se muestren solo los
registros del color silver y black.

SELECT ProductID, Name, ProductNumber, SellStartDate, ListPrice
FROM Production.Product WHERE Color IN ('silver', 'Black');

--8 . Seleccione 4 columnas de la tabla y la última debe de ser safetystocklevel donde estén
entre 1 y 100

SELECT ProductID, Name, ProductNumber, SellStartDate
FROM Production.Product WHERE SafetyStockLevel BETWEEN 1 AND 1000;

--9 Seleccione 3 campos de la tabla y muestre la proyección de venta que existiría al vender
todas las unidades multiplicando (existencias * precio) donde esa columna se llame
proyección total de venta.
SELECT ProductID,Name,  ProductNumber, (SafetyStockLevel * ListPrice) AS Proyeccion_Total_Venta
FROM Production.Product;

--PARTE 2
--1-Seleccione todo el registro donde exista un filtro para el campo TransactionDate para
seleccionar desde que fecha y hasta que fecha se desea obtener información.
SELECT *FROM Production.TransactionHistory
WHERE TransactionDate BETWEEN '2013-07-31 00:00:00.000' AND '2013-07-31 00:00:00.000';

--2 Seleccione todos los registros donde el ProductID sea 784,800 y 968.
SELECT *FROM Production.TransactionHistory
WHERE ProductID IN (784, 800, 968);

--3 Seleccione todos los registros donde el Quantity sea mayor a 5 y TransactionType sea igual
a W o S.

SELECT * FROM Production.TransactionHistory
WHERE Quantity > 5 AND (TransactionType = 'W' OR TransactionType = 'S');

--4 Seleccione todos los registros donde ReferenceOrderLineID sea mayor de 0 y ActualCost
sea mayor de 0.

SELECT *FROM Production.TransactionHistory
WHERE ReferenceOrderLineID > 0 AND ActualCost > 0;

--5 Seleccione los siguiente campos ProductID, ReferenceOrderID,ReferenceOrderLineID y por
ultimo muestre el TransactionDate donde se muestre no el numero del mes si no el
nombre del mes respectivo.

SELECT ProductID,ReferenceOrderID,ReferenceOrderLineID,
datename(month,TransactionDate) AS Nombre_Mes
FROM Production.TransactionHistory;
