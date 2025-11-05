/*1) Listar especie, años, calle, nro y localidad de árboles podados por el podador ‘Juan Perez’ y por
el podador ‘Jose Garcia’.
*/
SELECT DISTINCT a.especie, a.anios, a.calle,l.nombreL
FROM Localidad l
INNER JOIN Arbol a ON l.codigoPostal = a.codigoPostal
INNER JOIN Poda p ON a.nroArbol = p.nroArbol
INNER JOIN Podador pod ON p.DNI = pod.DNI
WHERE (pod.nombre = 'Juan' AND pod.apellido = 'Pérez')
INTERSECT
SELECT DISTINCT a.especie, a.anios, a.calle,l.nombreL
FROM Localidad l
INNER JOIN Arbol a ON l.codigoPostal = a.codigoPostal
INNER JOIN Poda p ON a.nroArbol = p.nroArbol
INNER JOIN Podador pod ON p.DNI = pod.DNI
WHERE (pod.nombre = 'Jose' AND pod.apellido = 'Garcia')

/*2) Reportar DNI, nombre, apellido, fecha de nacimiento y localidad donde viven de aquellos
podadores que tengan podas realizadas durante 2023.
*/
SELECT pod.DNI, pod.nombre, pod.apellido, pod.fnac, l.nombreL
FROM Podador pod
INNER JOIN Poda p ON (pod.DNI = p.DNI)
INNER JOIN Localidad l ON (pod.codigoPostalVive = l.codigoPostal)
WHERE YEAR(p.fecha) = 2023

/*3) Listar especie, años, calle, nro y localidad de árboles que no fueron podados nunca.*/
SELECT a.especie, a.anios, a.nro, l.nombreL
FROM Arbol a
INNER JOIN Localidad l ON (a.codigoPostal = l.codigoPostal)
WHERE a.nroArbol NOT IN (
    SELECT p.nroArbol
    FROM Arbol a INNER JOIN Poda p ON (a.nroArbol = p.nroArbol))

/*4) Reportar especie, años,calle, nro y localidad de árboles que fueron podados durante 2022 y no
fueron podados durante 2023.
*/
SELECT a.especie, a.anios, a.nro, l.nombreL
FROM Arbol a
INNER JOIN Localidad l ON (a.codigoPostal = l.codigoPostal)
INNER JOIN Poda p ON (a.nroArbol = p.nroArbol)
WHERE YEAR(p.fecha) = 2022
EXCEPT(
SELECT a.especie, a.anios, a.nro, l.nombreL
FROM Arbol a
INNER JOIN Localidad l ON (a.codigoPostal = l.codigoPostal)
INNER JOIN Poda p ON (a.nroArbol = p.nroArbol)
WHERE YEAR(p.fecha) = 2023)

/*
5) Reportar DNI, nombre, apellido, fecha de nacimiento y localidad donde viven de aquellos
podadores con apellido terminado con el string ‘ata’ y que tengan al menos una poda durante
2024. Ordenar por apellido y nombre
*/

SELECT podador.DNI, podador.nombre, podador.apellido, podador.fnac, l.nombreL
FROM Podador podador 
INNER JOIN Localidad l ON (podador.codigoPostalVive = l.codigoPostal)
WHERE podador.apellido LIKE "%ata" 
AND podador.DNI IN (
    SELECT poda.DNI
    FROM Poda poda
    WHERE YEAR(poda.fecha) = 2024
)

/* 6) Listar DNI, apellido, nombre, teléfono y fecha de nacimiento de podadores que solo podaron
árboles de especie ‘Coníferas’.
*/
SELECT podador.DNI, podador.nombre, podador.apellido, podador.fnac
FROM Podador podador 
INNER JOIN Poda poda ON (podador.DNI = poda.DNI)
INNER JOIN Arbol a ON (a.nroArbol = poda.nroArbol)
WHERE a.especie = "Coniferas"
EXCEPT
SELECT podador.DNI, podador.nombre, podador.apellido, podador.fnac
FROM Podador podador2 
INNER JOIN Poda poda2 ON (podador.DNI = poda.DNI)
INNER JOIN Arbol a2 ON (a.nroArbol = poda.nroArbol)
WHERE a2.especie <> "Coniferas"

/*7) Listar especies de árboles que se encuentren en la localidad de ‘La Plata’ y también en la
localidad de ‘Salta’.*/
SELECT a.especie
FROM Arbol a INNER JOIN Localidad l ON (a.codigoPostal = l.codigoPostal)
WHERE (l.nombreL = "La Plata")
INTERSECT
SELECT a.especie
FROM Arbol a INNER JOIN Localidad l ON (a.codigoPostal = l.codigoPostal)
WHERE (l.nombreL = "Salta")
/*TAMBIEN LO PODES HACER CON UN 'AND A2.ESPECIE IN' Y CONSULTAS POR LA OTRA LOCALIDAD EN SUBCONSULTA */

/*8) Eliminar el podador con DNI 22234566*/
DELETE FROM Podador WHERE DNI = 222234566

/*9) Reportar nombre, descripción y cantidad de habitantes de localidades que tengan menos de 5
árboles.*/
SELECT l.nombreL, l.descripcion, l.nroHabitantes, COUNT(a.nroArbol) as cantArboles
FROM Localidad l 
INNER JOIN Arbol a ON (l.codigoPostal = a.codigoPostal)
GROUP BY l.codigoPostal
HAVING COUNT(a.nroArbol) < 5