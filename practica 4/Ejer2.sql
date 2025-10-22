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