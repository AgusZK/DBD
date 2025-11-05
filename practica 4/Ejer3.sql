/*1. Listar DNI, nombre, apellido,dirección y email de integrantes nacidos entre 1980 y 1990 y que
hayan realizado algún recital durante 2023.
*/
SELECT i.DNI, i.nombre, i.apellido, i.direccion, i.email, i.fecha_nacimiento
FROM Integrante i
WHERE i.fecha_nacimiento BETWEEN '1980-01-01' AND '1990-12-31' 
AND i.DNI IN (
    SELECT i2.DNI
    FROM Integrante i2 INNER JOIN Recital r2 ON (i2.codigoB = r2.codigoB)
    WHERE YEAR(r2.fecha) = 2023
)

/*2) Reportar nombre, género musical y año de creación de bandas que hayan realizado recitales
durante 2023, pero no hayan tocado durante 2022 */
SELECT b.nombreBanda, b.genero_musical, b.anio_creacion
FROM Banda b
INNER JOIN Recital r ON (b.codigoB = r.codigoB)
WHERE YEAR(r.fecha) = 2023
EXCEPT
SELECT b.nombreBanda, b.genero_musical, b.anio_creacion
FROM Banda b
INNER JOIN Recital r ON (b.codigoB = r.codigoB)
WHERE YEAR(r.fecha) = 2022

/* 3) Listar el cronograma de recitales del día 04/12/2023. Se deberá listar nombre de la banda que
ejecutará el recital, fecha, hora, y el nombre y ubicación del escenario correspondiente.*/
SELECT b.nombreBanda, r.fecha, r.hora, e.nombre_escenario
FROM Banda b 
INNER JOIN Recital r ON (b.codigoB = r.codigoB)
INNER JOIN Escenario e ON (r.nroEscenario = e.nroEscenario)
WHERE r.fecha = '2023-12-4'

/* 4) Listar DNI, nombre, apellido,email de integrantes que hayan tocado en el escenario con nombre
‘Gustavo Cerati’ y en el escenario con nombre ‘Carlos Gardel’.*/
SELECT i.DNI, i.nombre, i.apellido, i.email
FROM Integrante i
INNER JOIN Recital r ON (i.codigoB = r.codigoB)
INNER JOIN Escenario e ON (r.nroEscenario = e.nroEscenario)
WHERE e.nombre_escenario = "Gustavo Cerati"
INTERSECT
SELECT i.DNI, i.nombre, i.apellido, i.email
FROM Integrante i
INNER JOIN Recital r ON (i.codigoB = r.codigoB)
INNER JOIN Escenario e ON (r.nroEscenario = e.nroEscenario)
WHERE e.nombre_escenario = "Carlos Gardel"

/*5) Reportar nombre, género musical y año de creación de bandas que tengan más de 5 integrantes.*/
SELECT b.nombreBanda, b.genero_musical, b.anio_creacion, COUNT(i.DNI) as cantIntegrantes
FROM Banda b
INNER JOIN Integrante i ON (b.codigoB = i.codigoB)
GROUP BY b.codigoB, b.genero_musical, b.anio_creacion
HAVING COUNT(i.DNI) > 5
/*NO RECUERDO SI HAY QUE PONER TODOS LOS PARAMETROS DEL SELECT EN EL GROUP BY*/

/* 6) Listar nombre de escenario, ubicación y descripción de escenarios que solo tuvieron recitales
con el género musical rock and roll. Ordenar por nombre de escenario
*/
SELECT e.nombre_escenario, e.ubicacion, e.descripcion
FROM Escenario e
INNER JOIN Recital r ON e.nroEscenario = r.nroEscenario
INNER JOIN Banda b ON r.codigoB = b.codigoB
WHERE b.genero_musical = 'rock and roll'
EXCEPT
SELECT e.nombre_escenario, e.ubicacion, e.descripcion
FROM Escenario e
INNER JOIN Recital r ON e.nroEscenario = r.nroEscenario
INNER JOIN Banda b ON r.codigoB = b.codigoB
WHERE b.genero_musical <> 'rock and roll'
ORDER BY nombre_escenario;

/* 7) Listar nombre, género musical y año de creación de bandas que hayan realizado recitales en
escenarios cubiertos durante 2023.// cubierto es true, false según corresponda
*/
SELECT b.nombreBanda, b.genero_musical, b.anio_creacion
FROM Banda b 
INNER JOIN Recital r ON (b.codigoB = r.codigoB)
INNER JOIN Escenario e ON (r.nroEscenario = e.nroEscenario)
WHERE e.cubierto = true AND YEAR(r.fecha)=2023

/*8. Reportar para cada escenario, nombre del escenario y cantidad de recitales durante 2024*/
SELECT e.nombre_escenario, COUNT(e.nroEscenario) as cantRecitales
FROM Escenario e
INNER JOIN Recital r ON (e.nroEscenario = r.nroEscenario)
WHERE YEAR(r.fecha) = 2024
GROUP BY e.nombre_escenario

/*9) Modificar el nombre de la banda ‘Mempis la Blusera’ a: ‘Memphis la Blusera’.*/
UPDATE Banda SET nombreBanda = "Memphis la Blusera" WHERE nombreBanda = "Mempis la Blusera"
