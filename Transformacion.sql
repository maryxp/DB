/*Drop TABLE IF EXISTS accede;
Drop TABLE IF EXISTS Usuario;
Drop TABLE IF EXISTS Ejemplar;
Drop TABLE IF EXISTS Version;
Drop TABLE IF EXISTS Pelicula;
Drop TABLE IF EXISTS Director;
Drop VIEW IF EXISTS V_Peliculas CASCADE;
*/

CREATE TABLE director 
  ( codigo INTEGER
  , nombre TEXT
  , apellido TEXT
  , fecha_nac DATE
  , tipo TEXT CHECK (tipo IN ('Principal', 'Suplente'))
  , PRIMARY KEY (codigo)
  );
       
CREATE TABLE pelicula 
  ( titulo TEXT
  , genero TEXT
  , sinopsis TEXT
  , pais_produccion TEXT
  , codigo INTEGER
  , PRIMARY KEY (titulo)
  , FOREIGN KEY(codigo) REFERENCES director(codigo)
  );

CREATE TABLE version 
  ( codigo INTEGER
  , anio DATE
  , idioma TEXT
  , titulo TEXT
  , PRIMARY KEY (codigo)
  , FOREIGN KEY(titulo) REFERENCES pelicula(titulo) 
  );

/*Entidad debil, absorbe la PK de su entidad fuerte*/
CREATE TABLE ejemplar 
  ( numero INTEGER  
  , formato TEXT CHECK (formato IN ('fisico', 'digital'))
  , observaciones TEXT
  , codigo INTEGER
  , PRIMARY KEY(numero, codigo)
  , FOREIGN KEY(codigo) REFERENCES version(codigo)
  );

CREATE TABLE usuario 
  ( cedula INTEGER
  , nombre TEXT
  , apellido TEXT
  , telefono INTEGER
  , PRIMARY KEY(cedula)
  );

--Relaciones 

CREATE TABLE accede 
  ( usuario_cedula INTEGER
  , id Integer GENERATED ALWAYS AS IDENTITY     --Esta PK tuve que añadirla porque sino el usuario no podre ver la misma peli en dos fechas distintas
  , fecha_acceso DATE
  , fecha_terminacion DATE
  , ejemplar_numero INTEGER
  , ejemplar_codigo INTEGER
  , PRIMARY KEY(usuario_cedula, ejemplar_numero, ejemplar_codigo, id)
  , FOREIGN KEY(ejemplar_numero, ejemplar_codigo) REFERENCES ejemplar(numero, codigo)
  );

/*SELECT * FROM pg_catalog.pg_tables;           Arroja todas las tablas creadas en post*/


--Directores             
INSERT INTO director (codigo, nombre, apellido, fecha_nac, tipo)
VALUES (1, 'Alessandro', 'Genovesi', '1973/01/10', 'Principal') ON CONFLICT DO NOTHING; 

INSERT INTO director (codigo, nombre, apellido, fecha_nac, tipo)
VALUES (2, 'Neil', 'Burger', '1963/11/22', 'Principal') ON CONFLICT DO NOTHING;

INSERT INTO director (codigo, nombre, apellido, fecha_nac, tipo)
VALUES (3, 'Diego', 'Vicentini', '1994/01/02', 'Principal') ON CONFLICT DO NOTHING;

SELECT * FROM director;

--Pelicula
INSERT INTO pelicula (titulo, genero, sinopsis, pais_produccion, codigo)
VALUES ('Fabricante de lágrimas', 'Romántico', 'A veces, el mayor temor de uno es aceptar que alguien pueda 
        amarlo honestamente por lo que es. Nica y Rigel están listos para descubrirlo juntos.', 'Italia', 01) ON CONFLICT DO NOTHING;

INSERT INTO pelicula (titulo, genero, sinopsis, pais_produccion, codigo)
VALUES ('Divergente', 'Ciencia Ficción', 'En una sociedad futura, la gente se divide en facciones según sus virtudes 
        personales. Después de que la joven Tris sea declarada "divergente" y, por tanto, nunca encajará en ningún grupo, 
        ella descubre un complot para destruir a quienes son como ella.', 'USA', 02) ON CONFLICT DO NOTHING;

INSERT INTO pelicula (titulo, genero, sinopsis, pais_produccion, codigo)
VALUES ('Simon', 'Drama social', 'Luego de escapar de Venezuela, Simón, un líder estudiantil, combate contra su trauma y 
        culpa por dejar su país atrás mientras busca conseguir asilo político en Miami antes de que sea deportado.', 'Vzla', 03) ON CONFLICT DO NOTHING;

SELECT * FROM pelicula;

--version 
INSERT INTO version (codigo, anio , idioma , titulo)
VALUES (1, '2024/04/04', 'Italiano', 'Fabricante de lágrimas') ON CONFLICT DO NOTHING;

INSERT INTO version (codigo, anio , idioma , titulo) 
VALUES (2, '2014/03/21', 'Ingles', 'Divergente') ON CONFLICT DO NOTHING;

INSERT INTO version (codigo, anio , idioma , titulo)
VALUES (3, '2023/04/15', 'Español', 'Simon') ON CONFLICT DO NOTHING;

SELECT * FROM version;

--ejemplar
INSERT INTO ejemplar (numero, formato , observaciones, codigo)
VALUES (1, 'fisico' , 'Posee adaptacion de lenguaje', 1) ON CONFLICT DO NOTHING;

INSERT INTO ejemplar (numero, formato , observaciones, codigo)
VALUES (4, 'digital', 'Posee subtitulos automaticos', 2) ON CONFLICT DO NOTHING;

INSERT INTO ejemplar (numero, formato , observaciones, codigo)
VALUES (7, 'fisico', 'Incluye version producida en idioma Ingles', 3) ON CONFLICT DO NOTHING;

INSERT INTO ejemplar (numero, formato , observaciones, codigo)
VALUES (3, 'digital' , 'Incluye version producida en Ingles', 1) ON CONFLICT DO NOTHING;

INSERT INTO ejemplar (numero, formato , observaciones, codigo)
VALUES (5, 'digital', 'Posee banda sonora especial para la version', 2) ON CONFLICT DO NOTHING;

INSERT INTO ejemplar (numero, formato , observaciones, codigo)
VALUES (2, 'digital', 'Disponible en plataformas Streaming', 3) ON CONFLICT DO NOTHING;

SELECT * FROM ejemplar;

--Usuario 
INSERT INTO usuario (cedula, nombre, apellido, telefono) 
VALUES (26454785, 'Lucia', 'Perez', 124658798) ON CONFLICT DO NOTHING;

INSERT INTO usuario (cedula, nombre, apellido, telefono) 
VALUES (12154545, 'Pedro', 'Hernandez', 246798555) ON CONFLICT DO NOTHING;

INSERT INTO usuario (cedula, nombre, apellido, telefono) 
VALUES (5587458, 'Carmen', 'Carmona', 163357489) ON CONFLICT DO NOTHING;

INSERT INTO usuario (cedula, nombre, apellido, telefono) 
VALUES (30789496, 'Javier', 'Rodriguez', 167455112) ON CONFLICT DO NOTHING;

SELECT * FROM usuario;

--Accede
INSERT INTO accede (usuario_cedula, fecha_acceso, fecha_terminacion, ejemplar_numero, ejemplar_codigo)
VALUES (26454785, '2023/05/28', '2023/06/25', 7, 3) ON CONFLICT DO NOTHING;

INSERT INTO accede (usuario_cedula, fecha_acceso, fecha_terminacion, ejemplar_numero, ejemplar_codigo)
VALUES (12154545, '2023/07/15', '2023/08/10', 7, 3) ON CONFLICT DO NOTHING;

INSERT INTO accede (usuario_cedula, fecha_acceso, fecha_terminacion, ejemplar_numero, ejemplar_codigo)
VALUES (26454785, '2024/05/23', '2024/06/27', 1, 1) ON CONFLICT DO NOTHING;

INSERT INTO accede (usuario_cedula, fecha_acceso, fecha_terminacion, ejemplar_numero, ejemplar_codigo)
VALUES (30789496, '2021/02/03', '2021/03/11', 4, 2) ON CONFLICT DO NOTHING;

INSERT INTO accede (usuario_cedula, fecha_acceso, fecha_terminacion, ejemplar_numero, ejemplar_codigo)
VALUES (26454785, '2019/08/19', '2019/08/26', 5, 2) ON CONFLICT DO NOTHING;

INSERT INTO accede (usuario_cedula, fecha_acceso, fecha_terminacion, ejemplar_numero, ejemplar_codigo)
VALUES (30789496, '2024/09/10', '2024/09/10', 1, 1) ON CONFLICT DO NOTHING;

INSERT INTO accede (usuario_cedula, fecha_acceso, fecha_terminacion, ejemplar_numero, ejemplar_codigo)
VALUES (26454785, '2020/10/19', '2020/10/23', 4, 2) ON CONFLICT DO NOTHING;

SELECT * FROM accede;
--El usuario de CI 5 no tiene acceso a ninguna

ALTER TABLE director
ADD CONSTRAINT CHK_anioNac CHECK (age(fecha_nac) > interval '18 YEARS');


UPDATE version
SET anio = '2020/09/10', idioma = 'Frances' 
WHERE codigo = 02;

UPDATE pelicula 
SET pais_produccion = 'Francia', genero = 'Romance'
WHERE titulo = 'Divergente';

UPDATE usuario
SET nombre = 'Maria', apellido = 'Jimenez'
WHERE cedula = 26454785;


DELETE FROM usuario     
WHERE cedula = 5587458 OR cedula = 12154545;

--View

CREATE VIEW V_PELICULAS AS
                    
	SELECT * FROM V_PELICULAS; 
	
  SELECT 
    p.titulo, 
    p.sinopsis, 
    v.anio, 
    v.idioma,
    d.nombre AS nombre_director,
    d.codigo AS codigo_director,
    d.fecha_nac,
    d.apellido AS apellido_director,
    d.tipo,
    e.numero,
    e.formato,
    e.observaciones,
    e.codigo AS codigo_ejemplar,
    u.cedula,
    u.nombre AS nombre_usuario,
    u.apellido AS apellido_usuario,
    u.telefono,
    a.usuario_cedula,
    a.fecha_acceso,
    a.fecha_terminacion,
    a.ejemplar_numero,
    a.ejemplar_codigo
    
	FROM 
    pelicula AS p 
  	INNER JOIN 
  version AS v 
    ON p.titulo = v.titulo 
	INNER JOIN 
    director AS d
    ON d.codigo = p.codigo
	INNER JOIN
    ejemplar AS e
  	ON e.codigo = v.codigo
	INNER JOIN
    accede AS a
	ON a.ejemplar_numero = e.numero
	INNER JOIN
    usuario AS u
  ON u.cedula = a.usuario_cedula
	
;
   
--Trigger   

CREATE OR REPLACE FUNCTION handle_acceder_insertion() RETURNS TRIGGER AS $$
  BEGIN
    IF  EXISTS(
      SELECT 1
      FROM /* `accede JOIN ejemplar` me da todos los ejemplares que el usuario ha accedido dentro del intervalo de acceso */
        accede as a 
        INNER JOIN 
        ejemplar as e
          ON a.ejemplar_numero = e.numero AND a.ejemplar_codigo = e.codigo
      WHERE 
        a.usuario_cedula     = NEW.usuario_cedula  AND 
        a.ejemplar_codigo    = NEW.ejemplar_codigo AND 
        tsrange(a.fecha_acceso, a.fecha_terminacion, '[]') 
          && tsrange(NEW.fecha_acceso, NEW.fecha_terminacion, '[]') AND
        /* ahora me aseguro de que no exista otro ejemplar en el mismo intervalo cuyo formato sea distinto */
        NOT EXISTS  ( /* la consulta es *casi* la misma, solo que agarro el ejemplar que matchea el numero, para comparar formatos */
          SELECT e1.formato 
          FROM 
            accede as a1
            INNER JOIN 
            ejemplar as e1 
            ON a1.ejemplar_numero = e1.numero AND a1.ejemplar_codigo = e1.codigo
          WHERE 
            a1.usuario_cedula    = NEW.usuario_cedula  AND 
            a1.ejemplar_codigo   = NEW.ejemplar_codigo AND 
            e1.numero            = NEW.ejemplar_numero AND 
            tsrange(a1.fecha_acceso, a1.fecha_terminacion, '[]') 
              && tsrange(NEW.fecha_acceso, NEW.fecha_terminacion, '[]') AND
            e1.formato <> e.formato
      )
    ) 
    THEN 
      RAISE EXCEPTION '% Un usuario no puede acceder a dos formatos en un mismo periodo de tiempo. ', NEW.usuario_cedula;
    ELSE 
      RETURN NEW;
    END IF;
  END;
$$ LANGUAGE plpgsql;                                            --En que lenguaje se escribira la funct

CREATE OR REPLACE TRIGGER acceso_unico_por_medio BEFORE INSERT
  ON accede
  -- porque para escribir la condicion se necesita   agarrar cada fila y ver si cumple o no la condicion
  FOR EACH ROW                                    
  EXECUTE FUNCTION handle_acceder_insertion ();


/* testeando el trigger */
INSERT INTO accede 
  (usuario_cedula, fecha_acceso , fecha_terminacion , ejemplar_numero, ejemplar_codigo)
VALUES 
  (26454785, '3024/05/28', '3024/06/25', 1, 1), /* llamemos esto A */
  (26454785, '3024/04/01', '3024/04/02', 3, 1), /* no deberia disparar el trigger, puesto que no hay solapamiento con A */
  (26454785, '3024/07/01', '3024/07/02', 3, 1)  /* no deberia disparar el trigger, puesto que no hay solapamiento con A */
  ;

/* -- uncomment and test
INSERT INTO accede 
  (usuario_cedula, fecha_acceso , fecha_terminacion , ejemplar_numero, ejemplar_codigo)
VALUES 
  (26454785, '3024/06/01', '3024/06/20', 3, 1) /* deberia disparar, puesto hay solapamiento con A. Totalmente contenido */
  --(26454785, '3024/05/01', '3024/06/20', 3, 1) /* deberia disparar, puesto hay solapamiento con A. Parcialmente contenido */
  --(26454785, '3024/06/01', '3024/06/26', 3, 1) /* deberia disparar, puesto hay solapamiento con A. Parcialmente contenido */
  --(26454785, '3024/05/01', '3024/06/26', 3, 1) /* deberia disparar, puesto hay solapamiento con A. Parcialmente contenido */
;
*/