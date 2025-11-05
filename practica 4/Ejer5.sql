/* 1) Listar razón social, dirección y teléfono de agencias que realizaron viajes desde la ciudad de ‘La
Plata’ (ciudad origen) y que el cliente tenga apellido ‘Roma’. Ordenar por razón social y luego por teléfono
*/
SELECT a.razon_social, a.direccion, a.telef
FROM Agencia a 
INNER JOIN Viaje v ON (a.razon_social = v.razon_social)
INNER JOIN Ciudad c ON (v.cpOrigen = c.codigo_postal)
INNER JOIN Cliente cli ON (v.dni = cli.dni)
WHERE c.nombreCiudad = "La Plata" AND cli.apellido = "Roma"
ORDER BY a.razon_social, a.telef

/* 2) Listar fecha, hora, datos personales del cliente, nombres de ciudades origen y destino de viajes
realizados en enero de 2019 donde la descripción del viaje contenga el String ‘demorado’*/
SELECT v.fecha,v.hora, c.dni, c.nombre, c.apellido, c.telefono, c.direccion, co.nombreCiudad, cd.nombreCiudad
FROM Cliente c
INNER JOIN Viaje v ON (c.dni = v.dni)
INNER JOIN Ciudad co ON (co.codigo_postal = v.cpOrigen)
INNER JOIN Ciudad cd ON (cd.codigo_postal = v.cpDestino)
WHERE v.descripcion LIKE "%demorado" and v.fecha BETWEEN "2019-01-01" AND "2019-01-31"

/* 3) Reportar información de agencias que realizaron viajes durante 2019 o que tengan dirección de
mail que termine con ‘@jmail.com’. */
SELECT a.razon_social, a.direccion, a.telef, a.email
FROM Agencia a
INNER JOIN Viaje v ON (a.razon_social = v.razon_social)
WHERE YEAR(v.fecha) = "2019" OR a.email LIKE "%jmail.com"

/* 4) Listar datos personales de clientes que viajaron solo con destino a la ciudad de ‘Coronel
Brandsen’*/
SELECT c.dni, c.nombre, c.apellido, c.telefono, c.direccion
FROM Cliente c
INNER JOIN Viaje v ON (c.dni = v.dni)
INNER JOIN Ciudad ciu ON (v.cpDestino = ciu.codigo_postal)
WHERE ciu.nombreCiudad = "Coronel Brandsen"
EXCEPT
SELECT c.dni, c.nombre, c.apellido, c.telefono, c.direccion
FROM Cliente c
INNER JOIN Viaje v ON (c.dni = v.dni)
INNER JOIN Ciudad ciu ON (v.cpDestino = ciu.codigo_postal)
WHERE ciu.nombreCiudad <> "Coronel Brandsen"

/* 5) Informar cantidad de viajes de la agencia con razón social ‘TAXI Y’ realizados a ‘Villa Elisa’.*/
SELECT COUNT(*) as cantViajes
FROM Viaje v
INNER JOIN Agencia a ON (v.razon_social = a.razon_social)
INNER JOIN Ciudad c ON (v.cpDestino = c.codigo_postal)
WHERE a.razon_social = "TAXI Y" AND c.nombreCiudad = "Villa Elisa"

/* 6) Listar nombre, apellido, dirección y teléfono de clientes que viajaron con todas las agencias.*/
SELECT c.nombre, c.apellido, c.direccion, c.telefono
FROM Cliente c
WHERE NOT EXISTS (
    SELECT *
    FROM Agencia a
    WHERE NOT EXISTS (
        SELECT *
        FROM Viaje v
        WHERE v.dni = c.dni AND v.razon_social = a.razon_social
    )
)
/* MUESTRA CLIENTE TAL QUE NO EXISTA AGENCIA EN LA CUAL NO TENGA VIAJES.*/

/* 7) Modificar el cliente con DNI 38495444 actualizando el teléfono a ‘221-4400897’ */
UPDATE cliente SET telefono="221-4400897" WHERE DNI=38495444

/* 8) Listar razón social, dirección y teléfono de la/s agencias que tengan mayor cantidad de viajes
realizados*/
SELECT a.razon_social, a.direccion, a.telef
FROM Agencia a
INNER JOIN Viaje v ON a.razon_social = v.razon_social
GROUP BY a.razon_social, a.direccion, a.telef
HAVING COUNT(*) = (
    SELECT MAX(cant)
    /*Cuento Viajes y me quedo con la cant mas grande*/
    FROM (
        SELECT COUNT(*) AS cant
        FROM Viaje
        GROUP BY razon_social
    ) as cantViajes
)

/* 9) Reportar nombre, apellido, dirección y teléfono de clientes con al menos 5 viajes. */
SELECT c.nombre, c.apellido, c.direccion, c.telefono
FROM Cliente c
INNER JOIN Viaje v ON (v.dni = c.dni)
GROUP BY c.nombre, c.apellido, c.direccion, c.telefono
HAVING COUNT(*) >= 5

/* 10) Borrar al cliente con DNI 40325692.*/
DELETE FROM Viaje WHERE DNI=40325692
DELETE FROM Cliente WHERE DNI=40325692 