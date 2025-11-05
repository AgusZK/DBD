/* 1) Listar DNI, legajo y apellido y nombre de todos los alumnos que tengan año de ingreso inferior a
2014.
*/
SELECT p.DNI, a.Legajo, p.Nombre
FROM Alumno a 
INNER JOIN Persona p ON (a.DNI = p.DNI)
WHERE a.Anio_Ingreso < 2014

/* 2) Listar DNI, matrícula, apellido y nombre de los profesores que dictan cursos que tengan más de
100 horas de duración. Ordenar por DNI.*/
SELECT profe.DNI, profe.Matricula, p.Apellido,p.Nombre
FROM Profesor profe
INNER JOIN Persona p ON (profe.DNI = p.DNI)
INNER JOIN Profesor_Curso pc ON (pc.DNI = p.DNI)
INNER JOIN Curso c ON (pc.Cod_Curso = c.Cod_Curso)
WHERE c.Duracion > 100
ORDER BY p.dni

/* 3) Listar el DNI, Apellido, Nombre, Género y Fecha de nacimiento de los alumnos inscriptos al
curso con nombre “Diseño de Bases de Datos” en 2023.
*/
SELECT p.DNI, p.Apellido, p.Nombre, p.Genero, p.Fecha_Nacimiento
FROM Alumno a
INNER JOIN Persona p ON (a.DNI = p.DNI)
INNER JOIN Alumno_Curso ac ON (p.DNI = ac.DNI)
INNER JOIN Curso c ON (ac.Cod_Curso = c.Cod_Curso)
WHERE c.Nombre = "Diseño de Bases de Datos" AND YEAR(ac.Anio)="2023"

/* 4) Listar el DNI, Apellido, Nombre y Calificación de aquellos alumnos que obtuvieron una
calificación superior a 8 en algún curso que dicta el profesor “Juan Garcia”. Dicho listado deberá
estar ordenado por Apellido y nombre.
*/
SELECT p.DNI, p.Apellido, p.Nombre
FROM Persona p
INNER JOIN Alumno_Curso ac ON (p.DNI = ac.DNI)
INNER JOIN Profesor_Curso pc ON (ac.Cod_Curso = pc.Cod_Curso)
INNER JOIN Profesor profe ON (pc.DNI = p.DNI)
WHERE p.Nombre = "Juan" AND p.Apellido = "Garcia" AND ac.Calificacion > 8
ORDER BY p.DNI, p.Nombre

/* 5) Listar el DNI, Apellido, Nombre y Matrícula de aquellos profesores que posean más de 3 títulos.
Dicho listado deberá estar ordenado por Apellido y Nombre.
*/
SELECT p.DNI, p.Apellido, p.Nombre, profe.Matricula
FROM Persona p
INNER JOIN Profesor profe ON (profe.DNI = p.DNI)
INNER JOIN Titulo_Profesor tituloProfe ON (profe.DNI = tituloProfe.DNI)
GROUP BY p.DNI,p.Apellido, p.Nombre, profe.Matricula
HAVING COUNT(tituloProfe.Cod_Titulo) > 3
ORDER BY p.Apellido, p.Nombre

/* 6) Listar el DNI, Apellido, Nombre, Cantidad de horas y Promedio de horas que dicta cada profesor.
La cantidad de horas se calcula como la suma de la duración de todos los cursos que dicta.
*/
SELECT p.DNI, p.Apellido, p.Nombre, SUM(c.Duracion) as cantHoras , AVG(c.Duracion) as promHoras
FROM Persona p 
INNER JOIN Profesor profe ON (p.DNI = profe.DNI)
INNER JOIN Profesor_Curso pc ON (profe.DNI = pc.DNI)
INNER JOIN Curso c on (pc.Cod_Curso = c.Cod_Curso)
GROUP BY p.DNI, p.Apellido, p.Nombre

/* 7) Listar Nombre y Descripción del curso que posea más alumnos inscriptos y del que posea
menos alumnos inscriptos durante 2024.
*/

SELECT c.Nombre, c.Descripcion, /*COUNT(ac.DNI) AS cantidad_alumnos*/
FROM Curso c
INNER JOIN Alumno_Curso ac ON c.Cod_Curso = ac.Cod_Curso
WHERE ac.Anio = 2024
GROUP BY c.Cod_Curso, c.Nombre, c.Descripcion
HAVING COUNT(ac.DNI) = (
    SELECT MAX(cantidad)
    FROM (
        SELECT COUNT(*) AS cantidad
        FROM Alumno_Curso
        WHERE Anio = 2024
        GROUP BY Cod_Curso
    ) AS cantMax
)
OR COUNT(ac.DNI) = (
    SELECT MIN(cantidad)
    FROM (
        SELECT COUNT(*) AS cantidad
        FROM Alumno_Curso
        WHERE Anio = 2024
        GROUP BY Cod_Curso
    ) AS cantMin
);


/* 8) Listar el DNI, Apellido, Nombre y Legajo de alumnos que realizaron cursos con nombre
conteniendo el string ‘BD’ durante 2022 pero no realizaron ningún curso durante 2023.
*/
SELECT p.DNI, p.Apellido, p.Nombre, a.Legajo
FROM Persona p
INNER JOIN Alumno a ON (p.DNI = a.DNI)
INNER JOIN Alumno_Curso ac ON (a.DNI = ac.DNI)
INNER JOIN Curso c ON (ac.Cod_Curso = c.Cod_Curso)
WHERE c.Nombre LIKE "%BD%" AND ac.Anio = "2022"
EXCEPT
SELECT p.DNI, p.Apellido, p.Nombre, a.Legajo
FROM Persona p2
INNER JOIN Alumno a2 ON (p2.DNI = a2.DNI)
INNER JOIN Alumno_Curso ac2 ON (a2.DNI = ac2.DNI)
INNER JOIN Curso c2 ON (ac2.Cod_Curso = c2.Cod_Curso)
WHERE ac2.Anio = "2023"


/* 9) Agregar un profesor con los datos que prefiera y agregarle el título con código: 25*/
INSERT INTO Persona (DNI, Apellido, Nombre, Fecha_Nacimiento, Estado_Civil, Genero)
VALUES (1235,"Gonzalez","Agustin","2004-03-03","Soltero","M")

INSERT INTO Profesor (DNI, Matricula, Nro_Expediente)
VALUES (1235, 444, 10)

INSERT INTO Titulo_Profesor (Cod_Titulo, DNI, Fecha)
VALUES (25, 1235, "2025-05-11")

/*10) Modificar el estado civil del alumno cuyo legajo es ‘2020/09’, el nuevo estado civil es divorciado.
*/
UPDATE Persona SET Estado_Civil="Divociado" WHERE DNI IN (
    SELECT a.DNI
    FROM Alumno a
    WHERE a.Legajo = "2020/09"
)

/*11) Dar de baja el alumno con DNI 30568989. Realizar todas las bajas necesarias para no dejar el
conjunto de relaciones en un estado inconsistente.
*/
DELETE FROM Alumno_Curso WHERE DNI=30568989
DELETE FROM Alumno WHERE DNI=30568989
DELETE FROM Persona WHERE DNI=30568989
