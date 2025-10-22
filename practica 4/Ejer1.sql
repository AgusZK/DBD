/*1) Listar datos personales de clientes cuyo apellido 
comience con el string ‘Pe’. Ordenar por DNI
 */

SELECT c.nombre, c.apellido, c.DNI, c.telefono, c.direccion
FROM Cliente c
WHERE (c.apellido LIKE 'PE%')
ORDER BY c.DNI

/*2) Listar nombre, apellido, DNI, teléfono y dirección de clientes que realizaron compras solamente
durante 2024.*/
SELECT c.nombre, c.apellido, c.DNI, c.telefono, c.direccion
FROM Cliente c INNER JOIN Factura f ON (c.idCliente = f.idCliente)
WHERE (f.fecha BETWEEN 2024-01-01 and 2024-12-31)

/*3) Listar nombre, descripción, precio y stock de productos vendidos al cliente con DNI 45789456,
pero que no fueron vendidos a clientes de apellido ‘Garcia’.
*/
SELECT p.nombreP, p.descripcion, p.precio, p.stock
FROM Producto p 
INNER JOIN Detalle d ON (p.idProducto = d.idProducto)
INNER JOIN Factura f ON (f.nroTicket = d.nroTicket)
INNER JOIN Cliente c ON (c.idCliente = f.idCliente)
WHERE (c.dni = 45789456)
EXCEPT
SELECT p.nombreP, p.descripcion, p.precio, p.stock
FROM Producto p INNER JOIN Detalle d ON (p.idProducto = d.idProducto)
INNER JOIN Factura  f ON (f.nroTicket = d.nroTicket)
INNER JOIN Cliente c ON (c.idCliente = f.idCliente)
WHERE (c.apellido = 'Garcia')

/* 4) Listar nombre, descripción, precio y stock de productos no vendidos a clientes que tengan
teléfono con característica 221 (la característica está al comienzo del teléfono). Ordenar por
nombre.
*/

SELECT p.nombreP, p.descripcion, p.precio, p.stock
FROM Producto p
WHERE p.idProducto NOT IN(
SELECT p.idProducto
FROM Producto p 
INNER JOIN Detalle d ON (p.idProducto = d.idProducto)
INNER JOIN Factura f ON (f.nroTicket = d.nroTicket)
INNER JOIN Cliente c ON (c.idCliente = f.idCliente)
WHERE (c.telefono LIKE '221'))
ORDER BY p.nombreP

/*5) Listar para cada producto nombre, descripción, precio y cuantas veces fue vendido. Tenga en
cuenta que puede no haberse vendido nunca el producto.*/
SELECT p.nombreP, p.descripcion, p.precio, SUM(d.cantidad) as Vendidos
FROM Producto p LEFT JOIN Detalle d ON (p.idProducto = d.idProducto)
GROUP BY p.idProducto, p.nombreP

/*6) Listar nombre, apellido, DNI, teléfono y dirección de clientes que compraron los productos con
nombre ‘prod1’ y ‘prod2’ pero nunca compraron el producto con nombre ‘prod3’.
*/
SELECT c.nombre, c.apellido, c.DNI, c.telefono, c.direccion
FROM Cliente c 
INNER JOIN Factura f ON (c.idCliente = f.idCliente)
INNER JOIN Detalle d on (d.nroTicket = f.nroTicket)
INNER JOIN Producto p on (d.idProducto = p.idProducto)
WHERE (p.nombreP IN ('prod1','prod2')
AND c.idCliente NOT IN (
    SELECT c.idCliente
    FROM Cliente c INNER JOIN Factura f ON (c.idCliente = f.idCliente)
    INNER JOIN Detalle  d ON (d.nroTicket = f.nroTicket)
    INNER JOIN Producto p ON (d.idProducto = p.idProducto)
    WHERE p.nombreP = 'prod3'))

/*7) Listar nroTicket, total, fecha, hora y DNI del cliente, de aquellas facturas donde se haya
comprado el producto ‘prod38’ o la factura tenga fecha de 2023.*/
SELECT f.nroTicket, f.fecha, f.fecha,f.hora, c.DNI
FROM Cliente c 
INNER JOIN Factura f ON (c.idCliente = f.idCliente)
INNER JOIN Detalle d ON (f.nroTicket = d.nroTicket)
INNER JOIN Producto p ON (d.idProducto = p.idProducto)
WHERE (p.nombreP = 'prod38' OR YEAR(f.fecha) = 2023)

/*8)  un cliente con los siguientes datos: nombre:’Jorge Luis’, apellido:’Castor’, DNI:
40578999, teléfono: ‘221-4400789’, dirección:’11 entre 500 y 501 nro:2587’ y el id de cliente:
500002. Se supone que el idCliente 500002 no existe.*/
INSERT INTO Cliente (idCliente, nombre, apellido, DNI, telefono, direccion)
VALUES (500002,'Jorge Luis', 'Castor', 40578999, '221-4400789', '11 entre 500 h 510 nro:2587')

/*9)  Listar nroTicket, total, fecha, hora para las facturas del cliente ´Jorge Pérez´ donde no haya
comprado el producto ´Z´*/
SELECT f.nroTicket, f.total, f.fecha, f.hora
FROM Cliente c
INNER JOIN Factura f ON (c.idCliente = f.idCliente)
INNER JOIN Detalle d ON (f.nroTicket = d.nroTicket)
INNER JOIN Producto p ON (p.idProducto = d.idProducto)
WHERE (c.nombre = 'Jorge' AND c.apellido = 'Pérez' AND f.nroTicket NOT IN (
    SELECT d.nroTicket
    FROM Detalle d INNER JOIN Producto p ON (p.idProducto = d.idProducto)
    WHERE (p.nombreP = 'Z')))

/*Listar DNI, apellido y nombre de clientes donde el monto total comprado, teniendo en cuenta
todas sus facturas, supere $100000.
*/
SELECT c.DNI, c.apellido, c.nombre
FROM Cliente c INNER JOIN Factura f ON (c.idCliente = f.idCliente)
GROUP BY c.idCliente
HAVING SUM(f.total) > 100000