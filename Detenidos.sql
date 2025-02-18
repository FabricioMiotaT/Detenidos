-- 1. Tipo_Delito
CREATE TABLE Tipo_Delito (
    Tipo VARCHAR2(50) PRIMARY KEY,
    Descripcion VARCHAR2(200)
);

-- 2. Banda_Criminal
CREATE TABLE Banda_Criminal (
    Nombre VARCHAR2(50) PRIMARY KEY,
    Area_Influencia VARCHAR2(100),
    Descripcion VARCHAR2(200)
);

-- 3. Tipo_Documento
CREATE TABLE Tipo_Documento (
    Tipo VARCHAR2(50) PRIMARY KEY,
    Descripcion VARCHAR2(200)
);

-- 4. Efectivo_Policial
CREATE TABLE Efectivo_Policial (
    CIP VARCHAR2(8) PRIMARY KEY,
    Nombre VARCHAR2(50),
    Apellido VARCHAR2(50),
    Grado VARCHAR2(30),
    Unidad_de_Trabajo VARCHAR2(100),
    Cargo VARCHAR2(50)
);

-- 5. Detenido
CREATE TABLE Detenido (
    Documento_Identidad VARCHAR2(15) PRIMARY KEY,
    Nombres VARCHAR2(50),
    Apellidos VARCHAR2(50),
    Alias VARCHAR2(50),
    Genero VARCHAR2(1),
    Fecha_Nacimiento DATE,
    Nacionalidad VARCHAR2(30),
    Banda_Nombre VARCHAR2(50),
    Talla NUMBER(3,2),
    Contextura VARCHAR2(20),
    CIP VARCHAR2(8),
    Direccion VARCHAR2(100),
    FOREIGN KEY (Banda_Nombre) REFERENCES Banda_Criminal(Nombre),
    FOREIGN KEY (CIP) REFERENCES Efectivo_Policial(CIP)
);

-- 6. Delito
CREATE TABLE Delito (
    Codigo VARCHAR2(5) PRIMARY KEY,
    Nombre VARCHAR2(100),
    Descripcion VARCHAR2(500),
    Tipo VARCHAR2(50),
    Modalidad VARCHAR2(50),
    FOREIGN KEY (Tipo) REFERENCES Tipo_Delito(Tipo)
);

-- 7. Documento_Intervencion
CREATE TABLE Documento_Intervencion (
    Numero_Documento VARCHAR2(8) PRIMARY KEY,
    Tipo VARCHAR2(50),
    Siglas VARCHAR2(10),
    Fecha DATE,
    Lugar VARCHAR2(100),
    Motivo VARCHAR2(200),
    CIP VARCHAR2(8),
    Descripcion VARCHAR2(500),
    FOREIGN KEY (Tipo) REFERENCES Tipo_Documento(Tipo),
    FOREIGN KEY (CIP) REFERENCES Efectivo_Policial(CIP)
);

-- 8. Biometrico
CREATE TABLE Biometrico (
    ID_Biometrico INT PRIMARY KEY,
    Tipo VARCHAR2(50),
    Descripcion VARCHAR2(500)
);

-- 9. Datos_Biometricos_Detenido
CREATE TABLE Datos_Biometricos_Detenido (
    ID_Detalle_Biometrico INT PRIMARY KEY,
    Documento_Identidad VARCHAR2(15),
    ID_Biometrico INT,
    Datos VARCHAR2(500),
    FOREIGN KEY (Documento_Identidad) REFERENCES Detenido(Documento_Identidad),
    FOREIGN KEY (ID_Biometrico) REFERENCES Biometrico(ID_Biometrico)
);

-- 10. Registro_Fotografico
CREATE TABLE Registro_Fotografico (
    ID_Registro INT PRIMARY KEY,
    ID_Detalle_Biometrico INT,
    Descripcion VARCHAR2(200),
    Fecha DATE,
    FOREIGN KEY (ID_Detalle_Biometrico) REFERENCES Datos_Biometricos_Detenido(ID_Detalle_Biometrico)
);

-- 11. Centro_Detencion
CREATE TABLE Centro_Detencion (
    ID_Centro INT PRIMARY KEY,
    Nombre VARCHAR2(100),
    Direccion VARCHAR2(200),
    Ciudad VARCHAR2(50)
);

-- 12. Traslado
CREATE TABLE Traslado (
    Documento_Identidad VARCHAR2(15),
    ID_Centro INT,
    Fecha_Ingreso DATE,
    Fecha_Salida DATE,
    PRIMARY KEY (Documento_Identidad, ID_Centro),
    FOREIGN KEY (Documento_Identidad) REFERENCES Detenido(Documento_Identidad),
    FOREIGN KEY (ID_Centro) REFERENCES Centro_Detencion(ID_Centro)
);

-- 13. Antecedentes_Penales
CREATE TABLE Antecedentes_Penales (
    ID_Antecedente INT PRIMARY KEY,
    Documento_Identidad VARCHAR2(15),
    Codigo_Delito VARCHAR2(5),
    Fecha_Registro DATE,
    Lugar VARCHAR2(100),
    Observaciones VARCHAR2(500),
    FOREIGN KEY (Documento_Identidad) REFERENCES Detenido(Documento_Identidad),
    FOREIGN KEY (Codigo_Delito) REFERENCES Delito(Codigo)
);

-- 14. Confiscacion_Bienes
CREATE TABLE Confiscacion_Bienes (
    ID_Confiscacion INT PRIMARY KEY,
    Documento_Identidad VARCHAR2(15),
    Numero_Documento VARCHAR2(8),
    Bien_Descripcion VARCHAR2(500),
    Cantidad INT,
    Fecha_Confiscacion DATE,
    Valor_Estimado NUMBER(10,2),
    FOREIGN KEY (Documento_Identidad) REFERENCES Detenido(Documento_Identidad),
    FOREIGN KEY (Numero_Documento) REFERENCES Documento_Intervencion(Numero_Documento)
);

-- 15. Jueces
CREATE TABLE Jueces (
    ID_Juez INT PRIMARY KEY,
    Nombre VARCHAR2(50),
    Apellido VARCHAR2(50),
    Especialidad VARCHAR2(50),
    Numero_Colegiatura VARCHAR2(10),
    Experiencia_Years INT,
    Observaciones VARCHAR2(500)
);

-- 16. Audiencia
CREATE TABLE Audiencia (
    ID_Audiencia INT PRIMARY KEY,
    Documento_Identidad VARCHAR2(15),
    Codigo_Delito VARCHAR2(5),
    Fecha_Audiencia DATE,
    Hora_Audiencia TIMESTAMP,
    Lugar VARCHAR2(100),
    ID_Juez INT,
    Observaciones VARCHAR2(500),
    FOREIGN KEY (Documento_Identidad) REFERENCES Detenido(Documento_Identidad),
    FOREIGN KEY (Codigo_Delito) REFERENCES Delito(Codigo),
    FOREIGN KEY (ID_Juez) REFERENCES Jueces(ID_Juez)
);

-- 17. Abogados
CREATE TABLE Abogados (
    ID_Abogado INT PRIMARY KEY,
    Nombre VARCHAR2(50),
    Apellido VARCHAR2(50),
    Tipo VARCHAR2(20),
    Numero_Colegiatura VARCHAR2(10),
    Experiencia_Years INT,
    Observaciones VARCHAR2(500)
);

-- 18. Testigos
CREATE TABLE Testigos (
    ID_Testigo INT PRIMARY KEY,
    Nombre VARCHAR2(50),
    Apellido VARCHAR2(50),
    Relacion VARCHAR2(50),
    Descripcion VARCHAR2(500),
    Contacto VARCHAR2(20)
);

-- 19. Detalle_Audiencia
CREATE TABLE Detalle_Audiencia (
    ID_Detalle INT PRIMARY KEY,
    ID_Audiencia INT,
    ID_Abogado INT,
    ID_Testigo INT,
    Testimonio VARCHAR2(500),
    Descripcion_Evidencia VARCHAR2(500),
    Decision_Final VARCHAR2(500),
    Comentarios VARCHAR2(500),
    Rol_Abogado VARCHAR2(20),
    FOREIGN KEY (ID_Audiencia) REFERENCES Audiencia(ID_Audiencia),
    FOREIGN KEY (ID_Abogado) REFERENCES Abogados(ID_Abogado),
    FOREIGN KEY (ID_Testigo) REFERENCES Testigos(ID_Testigo)
);

-- 20. Casos
CREATE TABLE Casos (
    ID_Caso INT PRIMARY KEY,
    Documento_Identidad VARCHAR2(15),
    Codigo_Delito VARCHAR2(5),
    Fecha_Apertura DATE,
    Estado VARCHAR2(20),
    Observaciones VARCHAR2(500),
    FOREIGN KEY (Documento_Identidad) REFERENCES Detenido(Documento_Identidad),
    FOREIGN KEY (Codigo_Delito) REFERENCES Delito(Codigo)
);

-- 21. Prueba_Evidencial
CREATE TABLE Prueba_Evidencial (
    ID_Prueba INT PRIMARY KEY,
    Descripcion VARCHAR2(200),
    Codigo_Delito VARCHAR2(5),
    FOREIGN KEY (Codigo_Delito) REFERENCES Delito(Codigo)
);

-- 22. Evidencia
CREATE TABLE Evidencia (
    ID_Evidencia INT PRIMARY KEY,
    ID_Caso INT,
    Tipo_Evidencia VARCHAR2(50),
    Descripcion VARCHAR2(500),
    Fecha_Registro DATE,
    Ubicacion VARCHAR2(100),
    FOREIGN KEY (ID_Caso) REFERENCES Casos(ID_Caso)
);

COMMIT;

-- 1. Tipo_Delito
INSERT INTO Tipo_Delito (Tipo, Descripcion) VALUES ('Robo', 'Delito relacionado con el hurto de bienes');
INSERT INTO Tipo_Delito (Tipo, Descripcion) VALUES ('Homicidio', 'Delito relacionado con la muerte de una persona');


-- 2. Banda_Criminal
INSERT INTO Banda_Criminal (Nombre, Area_Influencia, Descripcion) VALUES ('Los Malditos', 'Norte de la ciudad', 'Banda dedicada al robo y extorsión');
INSERT INTO Banda_Criminal (Nombre, Area_Influencia, Descripcion) VALUES ('Los Desalmados', 'Sur de la ciudad', 'Banda dedicada al narcotráfico');

-- 3. Tipo_Documento
INSERT INTO Tipo_Documento (Tipo, Descripcion) VALUES ('Informe', 'Documento de tipo informe policial');
INSERT INTO Tipo_Documento (Tipo, Descripcion) VALUES ('Acta', 'Documento de tipo acta de intervención');

-- 4. Efectivo_Policial
INSERT INTO Efectivo_Policial (CIP, Nombre, Apellido, Grado, Unidad_de_Trabajo, Cargo) 
VALUES ('12345678', 'Juan', 'Pérez', 'Oficial', 'Patrullaje', 'Policía');
INSERT INTO Efectivo_Policial (CIP, Nombre, Apellido, Grado, Unidad_de_Trabajo, Cargo) 
VALUES ('87654321', 'María', 'Gómez', 'Sargento', 'Investigación', 'Detective');

-- 5. Detenido
INSERT INTO Detenido (Documento_Identidad, Nombres, Apellidos, Alias, Genero, Fecha_Nacimiento, Nacionalidad, Banda_Nombre, Talla, Contextura, CIP, Direccion) 
VALUES ('87654321', 'Carlos', 'López', 'El Rápido', 'M', TRUNC(TO_DATE('1990-05-15', 'YYYY-MM-DD')), 'Peruano', 'Los Malditos', 1.75, 'Robusto', '12345678', 'Calle Falsa 123');
INSERT INTO Detenido (Documento_Identidad, Nombres, Apellidos, Alias, Genero, Fecha_Nacimiento, Nacionalidad, Banda_Nombre, Talla, Contextura, CIP, Direccion) 
VALUES ('12345678', 'Ana', 'Martínez', 'La Silenciosa', 'F', TRUNC(TO_DATE('1995-08-17', 'YYYY-MM-DD')), 'Colombiana', 'Los Desalmados', 1.65, 'Delgada', '87654321', 'Avenida Siempre Viva 456');

-- 6. Delito
INSERT INTO Delito (Codigo, Nombre, Descripcion, Tipo, Modalidad) 
VALUES ('DEL1', 'Robo a mano armada', 'Robo cometido con uso de arma de fuego', 'Robo', 'Violento');
INSERT INTO Delito (Codigo, Nombre, Descripcion, Tipo, Modalidad) 
VALUES ('DEL2', 'Homicidio calificado', 'Homicidio cometido con premeditación', 'Homicidio', 'Premeditado');

-- 7. Documento_Intervencion
INSERT INTO Documento_Intervencion (Numero_Documento, Tipo, Siglas, Fecha, Lugar, Motivo, CIP, Descripcion) 
VALUES ('DOC1', 'Informe', 'INF', TO_DATE('2023-10-01', 'YYYY-MM-DD'), 'Calle Principal', 'Intervención por robo', '12345678', 'Se intervino a un sospechoso con arma de fuego');
INSERT INTO Documento_Intervencion (Numero_Documento, Tipo, Siglas, Fecha, Lugar, Motivo, CIP, Descripcion) 
VALUES ('DOC2', 'Acta', 'ACT', TO_DATE('2023-10-02', 'YYYY-MM-DD'), 'Avenida Central', 'Intervención por homicidio', '87654321', 'Se intervino a un sospechoso de homicidio');

-- 8. Biometrico
INSERT INTO Biometrico (ID_Biometrico, Tipo, Descripcion) VALUES (1, 'Huella dactilar', 'Registro de huella dactilar del detenido');
INSERT INTO Biometrico (ID_Biometrico, Tipo, Descripcion) VALUES (2, 'Reconocimiento facial', 'Registro de reconocimiento facial del detenido');

-- 9. Datos_Biometricos_Detenido
INSERT INTO Datos_Biometricos_Detenido (ID_Detalle_Biometrico, Documento_Identidad, ID_Biometrico, Datos) 
VALUES (1, '87654321', 1, 'Huella dactilar registrada');
INSERT INTO Datos_Biometricos_Detenido (ID_Detalle_Biometrico, Documento_Identidad, ID_Biometrico, Datos) 
VALUES (2, '12345678', 2, 'Reconocimiento facial registrado');

-- 10. Registro_Fotografico
INSERT INTO Registro_Fotografico (ID_Registro, ID_Detalle_Biometrico, Descripcion, Fecha) 
VALUES (1, 1, 'Foto de perfil del detenido', TO_DATE('2023-10-01', 'YYYY-MM-DD'));
INSERT INTO Registro_Fotografico (ID_Registro, ID_Detalle_Biometrico, Descripcion, Fecha) 
VALUES (2, 2, 'Foto de frente del detenido', TO_DATE('2023-10-02', 'YYYY-MM-DD'));

-- 11. Centro_Detencion
INSERT INTO Centro_Detencion (ID_Centro, Nombre, Direccion, Ciudad) 
VALUES (1, 'Centro de Detención Norte', 'Calle Norte 123', 'Lima');
INSERT INTO Centro_Detencion (ID_Centro, Nombre, Direccion, Ciudad) 
VALUES (2, 'Centro de Detención Sur', 'Avenida Sur 456', 'Lima');

-- 12. Traslado
INSERT INTO Traslado (Documento_Identidad, ID_Centro, Fecha_Ingreso, Fecha_Salida) 
VALUES ('87654321', 1, TO_DATE('2023-10-01', 'YYYY-MM-DD'), TO_DATE('2023-10-05', 'YYYY-MM-DD'));
INSERT INTO Traslado (Documento_Identidad, ID_Centro, Fecha_Ingreso, Fecha_Salida) 
VALUES ('12345678', 2, TO_DATE('2023-10-02', 'YYYY-MM-DD'), TO_DATE('2023-10-06', 'YYYY-MM-DD'));

-- 13. Antecedentes_Penales
INSERT INTO Antecedentes_Penales (ID_Antecedente, Documento_Identidad, Codigo_Delito, Fecha_Registro, Lugar, Observaciones) 
VALUES (1, '87654321', 'DEL1', TO_DATE('2023-10-01', 'YYYY-MM-DD'), 'Calle Principal', 'Antecedente por robo a mano armada');
INSERT INTO Antecedentes_Penales (ID_Antecedente, Documento_Identidad, Codigo_Delito, Fecha_Registro, Lugar, Observaciones) 
VALUES (2, '12345678', 'DEL2', TO_DATE('2023-10-02', 'YYYY-MM-DD'), 'Avenida Central', 'Antecedente por homicidio calificado');

-- 14. Confiscacion_Bienes
INSERT INTO Confiscacion_Bienes (ID_Confiscacion, Documento_Identidad, Numero_Documento, Bien_Descripcion, Cantidad, Fecha_Confiscacion, Valor_Estimado) 
VALUES (1, '87654321', 'DOC1', 'Arma de fuego', 1, TO_DATE('2023-10-01', 'YYYY-MM-DD'), 1500.00);
INSERT INTO Confiscacion_Bienes (ID_Confiscacion, Documento_Identidad, Numero_Documento, Bien_Descripcion, Cantidad, Fecha_Confiscacion, Valor_Estimado) 
VALUES (2, '12345678', 'DOC2', 'Dinero en efectivo', 5000, TO_DATE('2023-10-02', 'YYYY-MM-DD'), 5000.00);

-- 15. Jueces
INSERT INTO Jueces (ID_Juez, Nombre, Apellido, Especialidad, Numero_Colegiatura, Experiencia_Years, Observaciones) 
VALUES (1, 'Luis', 'Ramírez', 'Penal', 'COL12345', 10, 'Juez especializado en casos penales');
INSERT INTO Jueces (ID_Juez, Nombre, Apellido, Especialidad, Numero_Colegiatura, Experiencia_Years, Observaciones) 
VALUES (2, 'Sofía', 'García', 'Civil', 'COL67890', 8, 'Juez especializado en casos civiles');

-- 16. Audiencia
INSERT INTO Audiencia (ID_Audiencia, Documento_Identidad, Codigo_Delito, Fecha_Audiencia, Hora_Audiencia, Lugar, ID_Juez, Observaciones) 
VALUES (1, '87654321', 'DEL1', TO_DATE('2023-10-10', 'YYYY-MM-DD'), TO_TIMESTAMP('2023-10-10 09:00:00', 'YYYY-MM-DD HH24:MI:SS'), 'Juzgado Norte', 1, 'Audiencia por robo a mano armada');
INSERT INTO Audiencia (ID_Audiencia, Documento_Identidad, Codigo_Delito, Fecha_Audiencia, Hora_Audiencia, Lugar, ID_Juez, Observaciones) 
VALUES (2, '12345678', 'DEL2', TO_DATE('2023-10-11', 'YYYY-MM-DD'), TO_TIMESTAMP('2023-10-11 10:00:00', 'YYYY-MM-DD HH24:MI:SS'), 'Juzgado Sur', 2, 'Audiencia por homicidio calificado');

-- 17. Abogados
INSERT INTO Abogados (ID_Abogado, Nombre, Apellido, Tipo, Numero_Colegiatura, Experiencia_Years, Observaciones) 
VALUES (1, 'Pedro', 'Sánchez', 'Defensor', 'COL11111', 5, 'Abogado defensor especializado en casos penales');
INSERT INTO Abogados (ID_Abogado, Nombre, Apellido, Tipo, Numero_Colegiatura, Experiencia_Years, Observaciones) 
VALUES (2, 'Lucía', 'Fernández', 'Fiscal', 'COL22222', 7, 'Abogado fiscal especializado en casos de homicidio');

-- 18. Testigos
INSERT INTO Testigos (ID_Testigo, Nombre, Apellido, Relacion, Descripcion, Contacto) 
VALUES (1, 'Marta', 'Díaz', 'Vecina', 'Testigo del robo', '999888777');
INSERT INTO Testigos (ID_Testigo, Nombre, Apellido, Relacion, Descripcion, Contacto) 
VALUES (2, 'Jorge', 'López', 'Vecino', 'Testigo del homicidio', '999777666');

-- 19. Detalle_Audiencia
INSERT INTO Detalle_Audiencia (ID_Detalle, ID_Audiencia, ID_Abogado, ID_Testigo, Testimonio, Descripcion_Evidencia, Decision_Final, Comentarios, Rol_Abogado) 
VALUES (1, 1, 1, 1, 'El testigo declaró haber visto el robo', 'Evidencia fotográfica', 'Sentencia de 5 años', 'Caso resuelto', 'Defensor');
INSERT INTO Detalle_Audiencia (ID_Detalle, ID_Audiencia, ID_Abogado, ID_Testigo, Testimonio, Descripcion_Evidencia, Decision_Final, Comentarios, Rol_Abogado) 
VALUES (2, 2, 2, 2, 'El testigo declaró haber escuchado disparos', 'Evidencia balística', 'Sentencia de 20 años', 'Caso resuelto', 'Fiscal');

-- 20. Casos
INSERT INTO Casos (ID_Caso, Documento_Identidad, Codigo_Delito, Fecha_Apertura, Estado, Observaciones) 
VALUES (1, '87654321', 'DEL1', TO_DATE('2023-10-01', 'YYYY-MM-DD'), 'Cerrado', 'Caso de robo resuelto');
INSERT INTO Casos (ID_Caso, Documento_Identidad, Codigo_Delito, Fecha_Apertura, Estado, Observaciones) 
VALUES (2, '12345678', 'DEL2', TO_DATE('2023-10-02', 'YYYY-MM-DD'), 'Cerrado', 'Caso de homicidio resuelto');

-- 21. Prueba_Evidencial
INSERT INTO Prueba_Evidencial (ID_Prueba, Descripcion, Codigo_Delito) 
VALUES (1, 'Fotografía del arma', 'DEL1');
INSERT INTO Prueba_Evidencial (ID_Prueba, Descripcion, Codigo_Delito) 
VALUES (2, 'Balística del arma', 'DEL2');

-- 22. Evidencia
INSERT INTO Evidencia (ID_Evidencia, ID_Caso, Tipo_Evidencia, Descripcion, Fecha_Registro, Ubicacion) 
VALUES (1, 1, 'Fotografía', 'Foto del arma utilizada', TO_DATE('2023-10-01', 'YYYY-MM-DD'), 'Archivo Central');
INSERT INTO Evidencia (ID_Evidencia, ID_Caso, Tipo_Evidencia, Descripcion, Fecha_Registro, Ubicacion) 
VALUES (2, 2, 'Balística', 'Informe balístico', TO_DATE('2023-10-02', 'YYYY-MM-DD'), 'Archivo Central');
COMMIT;

--Nuevos registros
INSERT INTO Tipo_Delito (Tipo, Descripcion) VALUES ('Extorsión', 'Delito relacionado con la coacción');
INSERT INTO Tipo_Delito (Tipo, Descripcion) VALUES ('Secuestro', 'Delito relacionado con la privación de libertad');
INSERT INTO Tipo_Delito (Tipo, Descripcion) VALUES ('Narcotráfico', 'Delito relacionado con el tráfico de drogas');
INSERT INTO Tipo_Delito (Tipo, Descripcion) VALUES ('Fraude', 'Delito relacionado con el engaño para obtener beneficios');
INSERT INTO Tipo_Delito (Tipo, Descripcion) VALUES ('Violación', 'Delito relacionado con agresión sexual');

INSERT INTO Banda_Criminal (Nombre, Area_Influencia, Descripcion) 
VALUES ('Los Invisibles', 'Este de la ciudad', 'Banda dedicada al secuestro');
INSERT INTO Banda_Criminal (Nombre, Area_Influencia, Descripcion) 
VALUES ('Shadows', 'Oeste de la ciudad', 'Banda dedicada al fraude y estafas');
INSERT INTO Banda_Criminal (Nombre, Area_Influencia, Descripcion) 
VALUES ('Los Fantasmas', 'Centro de la ciudad', 'Banda dedicada al narcotráfico');
INSERT INTO Banda_Criminal (Nombre, Area_Influencia, Descripcion) 
VALUES ('Los god', 'Norte de la ciudad', 'Banda dedicada a la extorsión');
INSERT INTO Banda_Criminal (Nombre, Area_Influencia, Descripcion) 
VALUES ('N/A', 'N/A', 'N/A');


INSERT INTO Tipo_Documento (Tipo, Descripcion) VALUES ('Reporte', 'Documento de tipo reporte policial');
INSERT INTO Tipo_Documento (Tipo, Descripcion) VALUES ('Orden', 'Documento de tipo orden de captura');
INSERT INTO Tipo_Documento (Tipo, Descripcion) VALUES ('Certificado', 'Documento de tipo certificado oficial');
INSERT INTO Tipo_Documento (Tipo, Descripcion) VALUES ('Declaración', 'Documento de tipo declaración jurada');
INSERT INTO Tipo_Documento (Tipo, Descripcion) VALUES ('Resolución', 'Documento de tipo resolución judicial');

INSERT INTO Efectivo_Policial (CIP, Nombre, Apellido, Grado, Unidad_de_Trabajo, Cargo) 
VALUES ('11112222', 'Luis', 'Torres', 'Capitán', 'Antinarcóticos', 'Jefe de Unidad');
INSERT INTO Efectivo_Policial (CIP, Nombre, Apellido, Grado, Unidad_de_Trabajo, Cargo) 
VALUES ('22223333', 'Carmen', 'Rojas', 'Teniente', 'Homicidios', 'Investigadora');
INSERT INTO Efectivo_Policial (CIP, Nombre, Apellido, Grado, Unidad_de_Trabajo, Cargo) 
VALUES ('33334444', 'Roberto', 'Vargas', 'Suboficial', 'Patrullaje', 'Policía');
INSERT INTO Efectivo_Policial (CIP, Nombre, Apellido, Grado, Unidad_de_Trabajo, Cargo) 
VALUES ('44445555', 'Laura', 'Quispe', 'Oficial', 'Tránsito', 'Policía de Tránsito');
INSERT INTO Efectivo_Policial (CIP, Nombre, Apellido, Grado, Unidad_de_Trabajo, Cargo) 
VALUES ('55556666', 'Jorge', 'Mendoza', 'Sargento', 'Inteligencia', 'Analista');

INSERT INTO Detenido (Documento_Identidad, Nombres, Apellidos, Alias, Genero, Fecha_Nacimiento, Nacionalidad, Banda_Nombre, Talla, Contextura, CIP, Direccion) 
VALUES ('11223344', 'Pedro', 'González', 'El Loco', 'M', TO_DATE('1985-03-12', 'YYYY-MM-DD'), 'Mexicano', 'Los Invisibles', 1.80, 'Robusto', '11112222', 'Calle Luna 789');
INSERT INTO Detenido (Documento_Identidad, Nombres, Apellidos, Alias, Genero, Fecha_Nacimiento, Nacionalidad, Banda_Nombre, Talla, Contextura, CIP, Direccion) 
VALUES ('22334455', 'Lucía', 'Fernández', 'La Tigresa', 'F', TO_DATE('1992-07-25', 'YYYY-MM-DD'), 'Colombiana', 'Shadows', 1.70, 'Delgada', '22223333', 'Avenida Sol 456');
INSERT INTO Detenido (Documento_Identidad, Nombres, Apellidos, Alias, Genero, Fecha_Nacimiento, Nacionalidad, Banda_Nombre, Talla, Contextura, CIP, Direccion) 
VALUES ('33445566', 'Miguel', 'Díaz', 'El Fantasma', 'M', TO_DATE('1988-11-30', 'YYYY-MM-DD'), 'Peruano', 'Los Invisibles', 1.78, 'Atlético', '33334444', 'Calle Estrella 123');
INSERT INTO Detenido (Documento_Identidad, Nombres, Apellidos, Alias, Genero, Fecha_Nacimiento, Nacionalidad, Banda_Nombre, Talla, Contextura, CIP, Direccion) 
VALUES ('44556677', 'Sofía', 'Ramírez', 'La Silenciosa', 'F', TO_DATE('1995-02-14', 'YYYY-MM-DD'), 'Chilena', 'Los Desalmados', 1.65, 'Delgada', '44445555', 'Avenida Río 789');
INSERT INTO Detenido (Documento_Identidad, Nombres, Apellidos, Alias, Genero, Fecha_Nacimiento, Nacionalidad, Banda_Nombre, Talla, Contextura, CIP, Direccion) 
VALUES ('55667788', 'Carlos', 'Vega', 'El Despiadado', 'M', TO_DATE('1990-09-10', 'YYYY-MM-DD'), 'Argentino', 'Los god', 1.82, 'Robusto', '55556666', 'Calle Mar 456');

INSERT INTO Delito (Codigo, Nombre, Descripcion, Tipo, Modalidad) 
VALUES ('DEL3', 'Secuestro express', 'Secuestro rápido para extorsión', 'Secuestro', 'Express');
INSERT INTO Delito (Codigo, Nombre, Descripcion, Tipo, Modalidad) 
VALUES ('DEL4', 'Tráfico de drogas', 'Distribución de cocaína', 'Narcotráfico', 'Distribución');
INSERT INTO Delito (Codigo, Nombre, Descripcion, Tipo, Modalidad) 
VALUES ('DEL5', 'Fraude bancario', 'Estafa mediante transferencias bancarias', 'Fraude', 'Bancario');
INSERT INTO Delito (Codigo, Nombre, Descripcion, Tipo, Modalidad) 
VALUES ('DEL6', 'Violación agravada', 'Agresión sexual con violencia', 'Violación', 'Agravada');
INSERT INTO Delito (Codigo, Nombre, Descripcion, Tipo, Modalidad) 
VALUES ('DEL7', 'Extorsión telefónica', 'Coacción mediante llamadas', 'Extorsión', 'Telefónica');

INSERT INTO Documento_Intervencion (Numero_Documento, Tipo, Siglas, Fecha, Lugar, Motivo, CIP, Descripcion) 
VALUES ('DOC3', 'Reporte', 'REP', TO_DATE('2023-10-03', 'YYYY-MM-DD'), 'Calle Luna', 'Intervención por secuestro', '11112222', 'Se intervino a un sospechoso de secuestro');
INSERT INTO Documento_Intervencion (Numero_Documento, Tipo, Siglas, Fecha, Lugar, Motivo, CIP, Descripcion) 
VALUES ('DOC4', 'Orden', 'ORD', TO_DATE('2023-10-04', 'YYYY-MM-DD'), 'Avenida Sol', 'Intervención por narcotráfico', '22223333', 'Se intervino a un sospechoso con drogas');
INSERT INTO Documento_Intervencion (Numero_Documento, Tipo, Siglas, Fecha, Lugar, Motivo, CIP, Descripcion) 
VALUES ('DOC5', 'Certificado', 'CERT', TO_DATE('2023-10-05', 'YYYY-MM-DD'), 'Calle Estrella', 'Intervención por fraude', '33334444', 'Se intervino a un sospechoso de estafa');
INSERT INTO Documento_Intervencion (Numero_Documento, Tipo, Siglas, Fecha, Lugar, Motivo, CIP, Descripcion) 
VALUES ('DOC6', 'Declaración', 'DEC', TO_DATE('2023-10-06', 'YYYY-MM-DD'), 'Avenida Río', 'Intervención por violación', '44445555', 'Se intervino a un sospechoso de agresión sexual');
INSERT INTO Documento_Intervencion (Numero_Documento, Tipo, Siglas, Fecha, Lugar, Motivo, CIP, Descripcion) 
VALUES ('DOC7', 'Resolución', 'RES', TO_DATE('2023-10-07', 'YYYY-MM-DD'), 'Calle Mar', 'Intervención por extorsión', '55556666', 'Se intervino a un sospechoso de extorsión telefónica');

INSERT INTO Biometrico (ID_Biometrico, Tipo, Descripcion) VALUES (3, 'ADN', 'Registro de ADN del detenido');
INSERT INTO Biometrico (ID_Biometrico, Tipo, Descripcion) VALUES (4, 'Voz', 'Registro de voz del detenido');
INSERT INTO Biometrico (ID_Biometrico, Tipo, Descripcion) VALUES (5, 'Iris', 'Registro de iris del detenido');
INSERT INTO Biometrico (ID_Biometrico, Tipo, Descripcion) VALUES (6, 'Firma', 'Registro de firma del detenido');
INSERT INTO Biometrico (ID_Biometrico, Tipo, Descripcion) VALUES (7, 'Palma', 'Registro de palma de la mano del detenido');

INSERT INTO Datos_Biometricos_Detenido (ID_Detalle_Biometrico, Documento_Identidad, ID_Biometrico, Datos) 
VALUES (3, '11223344', 3, 'ADN registrado');
INSERT INTO Datos_Biometricos_Detenido (ID_Detalle_Biometrico, Documento_Identidad, ID_Biometrico, Datos) 
VALUES (4, '22334455', 4, 'Voz registrada');
INSERT INTO Datos_Biometricos_Detenido (ID_Detalle_Biometrico, Documento_Identidad, ID_Biometrico, Datos) 
VALUES (5, '33445566', 5, 'Iris registrado');
INSERT INTO Datos_Biometricos_Detenido (ID_Detalle_Biometrico, Documento_Identidad, ID_Biometrico, Datos) 
VALUES (6, '44556677', 6, 'Firma registrada');
INSERT INTO Datos_Biometricos_Detenido (ID_Detalle_Biometrico, Documento_Identidad, ID_Biometrico, Datos) 
VALUES (7, '55667788', 7, 'Palma registrada');

INSERT INTO Registro_Fotografico (ID_Registro, ID_Detalle_Biometrico, Descripcion, Fecha) 
VALUES (3, 3, 'Foto de perfil del detenido', TO_DATE('2023-10-03', 'YYYY-MM-DD'));
INSERT INTO Registro_Fotografico (ID_Registro, ID_Detalle_Biometrico, Descripcion, Fecha) 
VALUES (4, 4, 'Foto de frente del detenido', TO_DATE('2023-10-04', 'YYYY-MM-DD'));
INSERT INTO Registro_Fotografico (ID_Registro, ID_Detalle_Biometrico, Descripcion, Fecha) 
VALUES (5, 5, 'Foto de perfil del detenido', TO_DATE('2023-10-05', 'YYYY-MM-DD'));
INSERT INTO Registro_Fotografico (ID_Registro, ID_Detalle_Biometrico, Descripcion, Fecha) 
VALUES (6, 6, 'Foto de frente del detenido', TO_DATE('2023-10-06', 'YYYY-MM-DD'));
INSERT INTO Registro_Fotografico (ID_Registro, ID_Detalle_Biometrico, Descripcion, Fecha) 
VALUES (7, 7, 'Foto de perfil del detenido', TO_DATE('2023-10-07', 'YYYY-MM-DD'));

INSERT INTO Centro_Detencion (ID_Centro, Nombre, Direccion, Ciudad) 
VALUES (3, 'Centro de Detención Este', 'Calle Este 789', 'Lima');
INSERT INTO Centro_Detencion (ID_Centro, Nombre, Direccion, Ciudad) 
VALUES (4, 'Centro de Detención Oeste', 'Avenida Oeste 456', 'Lima');
INSERT INTO Centro_Detencion (ID_Centro, Nombre, Direccion, Ciudad) 
VALUES (5, 'Centro de Detención Central', 'Calle Central 123', 'Lima');
INSERT INTO Centro_Detencion (ID_Centro, Nombre, Direccion, Ciudad) 
VALUES (6, 'Centro de Detención Sur Este', 'Avenida Sur Este 789', 'Lima');
INSERT INTO Centro_Detencion (ID_Centro, Nombre, Direccion, Ciudad) 
VALUES (7, 'Centro de Detención Norte Oeste', 'Calle Norte Oeste 456', 'Lima');

INSERT INTO Traslado (Documento_Identidad, ID_Centro, Fecha_Ingreso, Fecha_Salida) 
VALUES ('11223344', 3, TO_DATE('2023-10-03', 'YYYY-MM-DD'), TO_DATE('2023-10-08', 'YYYY-MM-DD'));
INSERT INTO Traslado (Documento_Identidad, ID_Centro, Fecha_Ingreso, Fecha_Salida) 
VALUES ('22334455', 4, TO_DATE('2023-10-04', 'YYYY-MM-DD'), TO_DATE('2023-10-09', 'YYYY-MM-DD'));
INSERT INTO Traslado (Documento_Identidad, ID_Centro, Fecha_Ingreso, Fecha_Salida) 
VALUES ('33445566', 5, TO_DATE('2023-10-05', 'YYYY-MM-DD'), TO_DATE('2023-10-10', 'YYYY-MM-DD'));
INSERT INTO Traslado (Documento_Identidad, ID_Centro, Fecha_Ingreso, Fecha_Salida) 
VALUES ('44556677', 6, TO_DATE('2023-10-06', 'YYYY-MM-DD'), TO_DATE('2023-10-11', 'YYYY-MM-DD'));
INSERT INTO Traslado (Documento_Identidad, ID_Centro, Fecha_Ingreso, Fecha_Salida) 
VALUES ('55667788', 7, TO_DATE('2023-10-07', 'YYYY-MM-DD'), TO_DATE('2023-10-12', 'YYYY-MM-DD'));

INSERT INTO Antecedentes_Penales (ID_Antecedente, Documento_Identidad, Codigo_Delito, Fecha_Registro, Lugar, Observaciones) 
VALUES (4, '11223344', 'DEL3', TO_DATE('2023-10-03', 'YYYY-MM-DD'), 'Calle Luna', 'Antecedente por secuestro');
INSERT INTO Antecedentes_Penales (ID_Antecedente, Documento_Identidad, Codigo_Delito, Fecha_Registro, Lugar, Observaciones) 
VALUES (5, '22334455', 'DEL4', TO_DATE('2023-10-04', 'YYYY-MM-DD'), 'Avenida Sol', 'Antecedente por narcotráfico');
INSERT INTO Antecedentes_Penales (ID_Antecedente, Documento_Identidad, Codigo_Delito, Fecha_Registro, Lugar, Observaciones) 
VALUES (6, '33445566', 'DEL5', TO_DATE('2023-10-05', 'YYYY-MM-DD'), 'Calle Estrella', 'Sin antecedentes registrados');
INSERT INTO Antecedentes_Penales (ID_Antecedente, Documento_Identidad, Codigo_Delito, Fecha_Registro, Lugar, Observaciones) 
VALUES (7, '44556677', 'DEL6', TO_DATE('2023-10-06', 'YYYY-MM-DD'), 'Avenida Río', 'Antecedente por violación');
INSERT INTO Antecedentes_Penales (ID_Antecedente, Documento_Identidad, Codigo_Delito, Fecha_Registro, Lugar, Observaciones) 
VALUES (8, '55667788', 'DEL7', TO_DATE('2023-10-07', 'YYYY-MM-DD'), 'Calle Mar', 'Antecedente por extorsión');

INSERT INTO Confiscacion_Bienes (ID_Confiscacion, Documento_Identidad, Numero_Documento, Bien_Descripcion, Cantidad, Fecha_Confiscacion, Valor_Estimado) 
VALUES (3, '11223344', 'DOC3', 'Dinero en efectivo', 10000, TO_DATE('2023-10-03', 'YYYY-MM-DD'), 10000.00);
INSERT INTO Confiscacion_Bienes (ID_Confiscacion, Documento_Identidad, Numero_Documento, Bien_Descripcion, Cantidad, Fecha_Confiscacion, Valor_Estimado) 
VALUES (4, '22334455', 'DOC4', 'Droga incautada', 5, TO_DATE('2023-10-04', 'YYYY-MM-DD'), 5000.00);
INSERT INTO Confiscacion_Bienes (ID_Confiscacion, Documento_Identidad, Numero_Documento, Bien_Descripcion, Cantidad, Fecha_Confiscacion, Valor_Estimado) 
VALUES (5, '33445566', 'DOC5', 'Documentos falsos', 10, TO_DATE('2023-10-05', 'YYYY-MM-DD'), 2000.00);
INSERT INTO Confiscacion_Bienes (ID_Confiscacion, Documento_Identidad, Numero_Documento, Bien_Descripcion, Cantidad, Fecha_Confiscacion, Valor_Estimado) 
VALUES (6, '44556677', 'DOC6', 'Arma blanca', 1, TO_DATE('2023-10-06', 'YYYY-MM-DD'), 300.00);
INSERT INTO Confiscacion_Bienes (ID_Confiscacion, Documento_Identidad, Numero_Documento, Bien_Descripcion, Cantidad, Fecha_Confiscacion, Valor_Estimado) 
VALUES (7, '55667788', 'DOC7', 'Teléfono móvil', 2, TO_DATE('2023-10-07', 'YYYY-MM-DD'), 800.00);

INSERT INTO Jueces (ID_Juez, Nombre, Apellido, Especialidad, Numero_Colegiatura, Experiencia_Years, Observaciones) 
VALUES (3, 'Ana', 'López', 'Penal', 'COL33333', 12, 'Juez especializado en casos de secuestro');
INSERT INTO Jueces (ID_Juez, Nombre, Apellido, Especialidad, Numero_Colegiatura, Experiencia_Years, Observaciones) 
VALUES (4, 'Carlos', 'Martínez', 'Narcotráfico', 'COL44444', 9, 'Juez especializado en casos de narcotráfico');
INSERT INTO Jueces (ID_Juez, Nombre, Apellido, Especialidad, Numero_Colegiatura, Experiencia_Years, Observaciones) 
VALUES (5, 'Marta', 'Gómez', 'Fraude', 'COL55555', 7, 'Juez especializado en casos de fraude');
INSERT INTO Jueces (ID_Juez, Nombre, Apellido, Especialidad, Numero_Colegiatura, Experiencia_Years, Observaciones) 
VALUES (6, 'Jorge', 'Hernández', 'Violación', 'COL66666', 10, 'Juez especializado en casos de agresión sexual');
INSERT INTO Jueces (ID_Juez, Nombre, Apellido, Especialidad, Numero_Colegiatura, Experiencia_Years, Observaciones) 
VALUES (7, 'Lucía', 'Díaz', 'Extorsión', 'COL77777', 8, 'Juez especializado en casos de extorsión');

INSERT INTO Audiencia (ID_Audiencia, Documento_Identidad, Codigo_Delito, Fecha_Audiencia, Hora_Audiencia, Lugar, ID_Juez, Observaciones) 
VALUES (3, '11223344', 'DEL3', TO_DATE('2023-10-12', 'YYYY-MM-DD'), TO_TIMESTAMP('2023-10-12 09:00:00', 'YYYY-MM-DD HH24:MI:SS'), 'Juzgado Este', 3, 'Audiencia por secuestro');
INSERT INTO Audiencia (ID_Audiencia, Documento_Identidad, Codigo_Delito, Fecha_Audiencia, Hora_Audiencia, Lugar, ID_Juez, Observaciones) 
VALUES (4, '22334455', 'DEL4', TO_DATE('2023-10-13', 'YYYY-MM-DD'), TO_TIMESTAMP('2023-10-13 10:00:00', 'YYYY-MM-DD HH24:MI:SS'), 'Juzgado Oeste', 4, 'Audiencia por narcotráfico');
INSERT INTO Audiencia (ID_Audiencia, Documento_Identidad, Codigo_Delito, Fecha_Audiencia, Hora_Audiencia, Lugar, ID_Juez, Observaciones) 
VALUES (5, '33445566', 'DEL5', TO_DATE('2023-10-14', 'YYYY-MM-DD'), TO_TIMESTAMP('2023-10-14 11:00:00', 'YYYY-MM-DD HH24:MI:SS'), 'Juzgado Central', 5, 'Audiencia por fraude');
INSERT INTO Audiencia (ID_Audiencia, Documento_Identidad, Codigo_Delito, Fecha_Audiencia, Hora_Audiencia, Lugar, ID_Juez, Observaciones) 
VALUES (6, '44556677', 'DEL6', TO_DATE('2023-10-15', 'YYYY-MM-DD'), TO_TIMESTAMP('2023-10-15 12:00:00', 'YYYY-MM-DD HH24:MI:SS'), 'Juzgado Sur Este', 6, 'Audiencia por violación');
INSERT INTO Audiencia (ID_Audiencia, Documento_Identidad, Codigo_Delito, Fecha_Audiencia, Hora_Audiencia, Lugar, ID_Juez, Observaciones) 
VALUES (7, '55667788', 'DEL7', TO_DATE('2023-10-16', 'YYYY-MM-DD'), TO_TIMESTAMP('2023-10-16 13:00:00', 'YYYY-MM-DD HH24:MI:SS'), 'Juzgado Norte Oeste', 7, 'Audiencia por extorsión');

INSERT INTO Abogados (ID_Abogado, Nombre, Apellido, Tipo, Numero_Colegiatura, Experiencia_Years, Observaciones) 
VALUES (3, 'Ricardo', 'Gutiérrez', 'Defensor', 'COL33333', 6, 'Abogado defensor especializado en secuestro');
INSERT INTO Abogados (ID_Abogado, Nombre, Apellido, Tipo, Numero_Colegiatura, Experiencia_Years, Observaciones) 
VALUES (4, 'Patricia', 'Vargas', 'Fiscal', 'COL44444', 8, 'Abogado fiscal especializado en narcotráfico');
INSERT INTO Abogados (ID_Abogado, Nombre, Apellido, Tipo, Numero_Colegiatura, Experiencia_Years, Observaciones) 
VALUES (5, 'Fernando', 'Rojas', 'Defensor', 'COL55555', 5, 'Abogado defensor especializado en fraude');
INSERT INTO Abogados (ID_Abogado, Nombre, Apellido, Tipo, Numero_Colegiatura, Experiencia_Years, Observaciones) 
VALUES (6, 'Gabriela', 'Mendoza', 'Fiscal', 'COL66666', 7, 'Abogado fiscal especializado en violación');
INSERT INTO Abogados (ID_Abogado, Nombre, Apellido, Tipo, Numero_Colegiatura, Experiencia_Years, Observaciones) 
VALUES (7, 'Héctor', 'Paredes', 'Defensor', 'COL77777', 9, 'Abogado defensor especializado en extorsión');

INSERT INTO Testigos (ID_Testigo, Nombre, Apellido, Relacion, Descripcion, Contacto) 
VALUES (3, 'Mario', 'Gómez', 'Vecino', 'Testigo del secuestro', '999666555');
INSERT INTO Testigos (ID_Testigo, Nombre, Apellido, Relacion, Descripcion, Contacto) 
VALUES (4, 'Sara', 'López', 'Vecina', 'Testigo del narcotráfico', '999555444');
INSERT INTO Testigos (ID_Testigo, Nombre, Apellido, Relacion, Descripcion, Contacto) 
VALUES (5, 'Javier', 'Torres', 'Vecino', 'Testigo del fraude', '999444333');
INSERT INTO Testigos (ID_Testigo, Nombre, Apellido, Relacion, Descripcion, Contacto) 
VALUES (6, 'Elena', 'Ramírez', 'Vecina', 'Testigo de la violación', '999333222');
INSERT INTO Testigos (ID_Testigo, Nombre, Apellido, Relacion, Descripcion, Contacto) 
VALUES (7, 'Oscar', 'Díaz', 'Vecino', 'Testigo de la extorsión', '999222111');

INSERT INTO Detalle_Audiencia (ID_Detalle, ID_Audiencia, ID_Abogado, ID_Testigo, Testimonio, Descripcion_Evidencia, Decision_Final, Comentarios, Rol_Abogado) 
VALUES (3, 3, 3, 3, 'El testigo declaró haber visto el secuestro', 'Evidencia fotográfica', 'Sentencia de 10 años', 'Caso resuelto', 'Defensor');
INSERT INTO Detalle_Audiencia (ID_Detalle, ID_Audiencia, ID_Abogado, ID_Testigo, Testimonio, Descripcion_Evidencia, Decision_Final, Comentarios, Rol_Abogado) 
VALUES (4, 4, 4, 4, 'El testigo declaró haber visto el narcotráfico', 'Evidencia de drogas', 'Sentencia de 15 años', 'Caso resuelto', 'Fiscal');
INSERT INTO Detalle_Audiencia (ID_Detalle, ID_Audiencia, ID_Abogado, ID_Testigo, Testimonio, Descripcion_Evidencia, Decision_Final, Comentarios, Rol_Abogado) 
VALUES (5, 5, 5, 5, 'El testigo declaró haber visto el fraude', 'Evidencia documental', 'Sentencia de 5 años', 'Caso resuelto', 'Defensor');
INSERT INTO Detalle_Audiencia (ID_Detalle, ID_Audiencia, ID_Abogado, ID_Testigo, Testimonio, Descripcion_Evidencia, Decision_Final, Comentarios, Rol_Abogado) 
VALUES (6, 6, 6, 6, 'El testigo declaró haber escuchado la agresión', 'Evidencia médica', 'Sentencia de 20 años', 'Caso resuelto', 'Fiscal');
INSERT INTO Detalle_Audiencia (ID_Detalle, ID_Audiencia, ID_Abogado, ID_Testigo, Testimonio, Descripcion_Evidencia, Decision_Final, Comentarios, Rol_Abogado) 
VALUES (7, 7, 7, 7, 'El testigo declaró haber recibido llamadas de extorsión', 'Evidencia de llamadas', 'Sentencia de 8 años', 'Caso resuelto', 'Defensor');

INSERT INTO Casos (ID_Caso, Documento_Identidad, Codigo_Delito, Fecha_Apertura, Estado, Observaciones) 
VALUES (3, '11223344', 'DEL3', TO_DATE('2023-10-03', 'YYYY-MM-DD'), 'Cerrado', 'Caso de secuestro resuelto');
INSERT INTO Casos (ID_Caso, Documento_Identidad, Codigo_Delito, Fecha_Apertura, Estado, Observaciones) 
VALUES (4, '22334455', 'DEL4', TO_DATE('2023-10-04', 'YYYY-MM-DD'), 'Abierto', 'Caso de narcotráfico');
INSERT INTO Casos (ID_Caso, Documento_Identidad, Codigo_Delito, Fecha_Apertura, Estado, Observaciones) 
VALUES (5, '33445566', 'DEL5', TO_DATE('2023-10-05', 'YYYY-MM-DD'), 'Cerrado', 'Caso de fraude resuelto');
INSERT INTO Casos (ID_Caso, Documento_Identidad, Codigo_Delito, Fecha_Apertura, Estado, Observaciones) 
VALUES (6, '44556677', 'DEL6', TO_DATE('2023-10-06', 'YYYY-MM-DD'), 'Abierto', 'Caso de violación ');
INSERT INTO Casos (ID_Caso, Documento_Identidad, Codigo_Delito, Fecha_Apertura, Estado, Observaciones) 
VALUES (7, '55667788', 'DEL7', TO_DATE('2023-10-07', 'YYYY-MM-DD'), 'Abierto', 'Caso de extorsión');

INSERT INTO Prueba_Evidencial (ID_Prueba, Descripcion, Codigo_Delito) 
VALUES (3, 'Fotografía del lugar del secuestro', 'DEL3');
INSERT INTO Prueba_Evidencial (ID_Prueba, Descripcion, Codigo_Delito) 
VALUES (4, 'Droga incautada', 'DEL4');
INSERT INTO Prueba_Evidencial (ID_Prueba, Descripcion, Codigo_Delito) 
VALUES (5, 'Documentos falsos', 'DEL5');
INSERT INTO Prueba_Evidencial (ID_Prueba, Descripcion, Codigo_Delito) 
VALUES (6, 'Informe médico', 'DEL6');
INSERT INTO Prueba_Evidencial (ID_Prueba, Descripcion, Codigo_Delito) 
VALUES (7, 'Registro de llamadas', 'DEL7');

INSERT INTO Evidencia (ID_Evidencia, ID_Caso, Tipo_Evidencia, Descripcion, Fecha_Registro, Ubicacion) 
VALUES (3, 3, 'Fotografía', 'Foto del lugar del secuestro', TO_DATE('2023-10-03', 'YYYY-MM-DD'), 'Archivo Central');
INSERT INTO Evidencia (ID_Evidencia, ID_Caso, Tipo_Evidencia, Descripcion, Fecha_Registro, Ubicacion) 
VALUES (4, 4, 'Droga', 'Droga incautada', TO_DATE('2023-10-04', 'YYYY-MM-DD'), 'Archivo Central');
INSERT INTO Evidencia (ID_Evidencia, ID_Caso, Tipo_Evidencia, Descripcion, Fecha_Registro, Ubicacion) 
VALUES (5, 5, 'Documentos', 'Documentos falsos', TO_DATE('2023-10-05', 'YYYY-MM-DD'), 'Archivo Central');
INSERT INTO Evidencia (ID_Evidencia, ID_Caso, Tipo_Evidencia, Descripcion, Fecha_Registro, Ubicacion) 
VALUES (6, 6, 'Médico', 'Informe médico', TO_DATE('2023-10-06', 'YYYY-MM-DD'), 'Archivo Central');
INSERT INTO Evidencia (ID_Evidencia, ID_Caso, Tipo_Evidencia, Descripcion, Fecha_Registro, Ubicacion) 
VALUES (7, 7, 'Llamadas', 'Registro de llamadas', TO_DATE('2023-10-07', 'YYYY-MM-DD'), 'Archivo Central');
COMMIT;

--10 Consultas:
--1 Obtener todos los detenidos con su fecha de nacimiento:
SELECT * FROM DETENIDO;
--2 Obtener el listado de delitos con su modalidad:
SELECT Codigo, Nombre, Modalidad FROM Delito;
--3 Listar los abogados con su especialidad:
SELECT Nombre, Apellido, Especialidad FROM Abogados;
--4 Obtener las evidencias de un caso específico:
SELECT ID_Evidencia, Tipo_Evidencia, Descripcion FROM Evidencia WHERE ID_Caso = 2;
--5 Contar el número de casos abiertos:
SELECT COUNT(*) FROM Casos WHERE Estado = 'Abierto';
--6 Listar todos los jueces con su especialidad:
SELECT Nombre, Apellido, Especialidad FROM Jueces;
--7 Obtener el número total de traslados realizados
SELECT COUNT(*) FROM TRASLADO;
--8 Obtener los testigos que participaron en una audiencia específica
SELECT t.nombre, t.apellido, d.id_audiencia 
FROM DETALLE_AUDIENCIA d, TESTIGOS t WHERE t.id_testigo = d.id_testigo;
--9 Obtener las audiencias programadas para un juez específico:
SELECT * FROM AUDIENCIA WHERE id_juez = 1;
--10 Obtener el estado de un caso con el código de delito específico:
SELECT * FROM Casos WHERE Codigo_Delito = 'DEL1';

--10 Consultas de Varias Tablas:
--1 Obtener el nombre del detenido y su delito sea el primero

SELECT d.nombres, d.apellidos, de.nombre 
FROM detenido d, delito de, 
(select Codigo_delito FROM audiencia) a 
WHERE a.codigo_delito = de.codigo;

--2 Listar los detenidos junto con la evidencia asociada a su caso:

SELECT d.nombres, d.apellidos, e.descripcion
FROM detenido d, 
(select id_caso,documento_identidad FROM casos) a , evidencia e
WHERE e.id_caso = a.id_caso and a.documento_identidad = d.documento_identidad;

select d.nombres, d.apellidos, e.descripcion 
from detenido d 
NATURAL JOIN evidencia e 
NATURAL JOIN casos ;

--3 Listar las audiencias y los abogados involucrados:

SELECT a.Fecha_Audiencia, ab.Nombre, ab.Apellido
FROM Audiencia a
JOIN Detalle_Audiencia da ON a.ID_Audiencia = da.ID_Audiencia
JOIN Abogados ab ON da.ID_Abogado = ab.ID_Abogado;

--4 Obtener la cantidad de detenidos agrupados por nombre de banda:

SELECT BANDA_nombre as NOMBRE_BANDA, COUNT(*) as CANTIDAD
FROM DETENIDO 
JOIN banda_criminal b ON banda_nombre = b.nombre 
GROUP BY banda_nombre;

--5 Obtener los traslados de un detenido junto con el centro de detención:

SELECT t.Documento_Identidad, d.nombres, c.Nombre 
FROM Traslado t
JOIN Detenido d ON t.documento_identidad = d.documento_identidad
JOIN Centro_Detencion c ON t.ID_Centro = c.ID_Centro;


--6 Obtener los jueces que han presidido audiencias con detenidos

SELECT j.Nombre, j.Apellido, a.Fecha_Audiencia, d.Nombres AS Nombre_Detenido, d.Apellidos AS Apellido_Detenido
FROM Jueces j
JOIN Audiencia a ON j.ID_Juez = a.ID_Juez
JOIN Detenido d ON a.Documento_Identidad = d.Documento_Identidad;

--7 Listar los documentos de intervención con los efectivos policiales responsables
SELECT ep.Nombre AS Nombre, ep.Apellido AS Apellido, di.Numero_Documento, di.Fecha, di.Lugar, di.Motivo
FROM Documento_Intervencion di
JOIN Efectivo_Policial ep ON di.CIP = ep.CIP;

--8 Mostrar la cantidad de delitos por tipo de delito
SELECT td.Tipo, COUNT(d.Codigo) AS Cantidad_Delitos
FROM Tipo_Delito td
JOIN Delito d ON td.Tipo = d.Tipo
GROUP BY td.Tipo;

--9 Listar los centros de detención junto con la cantidad de detenidos que albergan
SELECT c.Nombre AS Centro_Detencion, COUNT(t.Documento_Identidad) AS Cantidad_Detenidos
FROM Centro_Detencion c
JOIN Traslado t ON c.ID_Centro = t.ID_Centro
JOIN Detenido d ON t.Documento_Identidad = d.Documento_Identidad
GROUP BY c.Nombre;

--10 Listar los detenidos junto con los bienes confiscados
SELECT d.nombres, d.apellidos, cb.Bien_Descripcion, cb.Cantidad, cb.Fecha_Confiscacion, cb.Valor_Estimado
FROM Detenido d
JOIN Confiscacion_Bienes cb ON d.Documento_Identidad = cb.Documento_Identidad;


-- PROCEDIMIENTOS ALMACENADOS
--1 PROCEDIMIENTOS QUE AÑADE UN DETENIDO
CREATE OR REPLACE PROCEDURE insertar_Detenido(
    d_dni IN VARCHAR2,
    d_nombres IN VARCHAR2,
    d_apellidos IN VARCHAR2,
    d_alias IN VARCHAR2,
    d_genero IN VARCHAR2,
    d_fecha_nacimiento IN DATE,
    d_nacionalidad IN VARCHAR2,
    d_banda_nombre IN VARCHAR2,
    d_talla IN NUMBER,
    d_contextura IN VARCHAR2,
    d_cip IN VARCHAR2,
    d_direccion IN VARCHAR2
) IS 
BEGIN
    INSERT INTO Detenido (Documento_Identidad, Nombres, Apellidos, Alias, Genero, Fecha_Nacimiento, Nacionalidad, Banda_Nombre, Talla, Contextura, CIP, Direccion) 
    VALUES (d_dni, d_nombres,  d_apellidos, d_alias, d_genero, d_fecha_nacimiento,  d_nacionalidad ,  d_banda_nombre, d_talla, d_contextura, d_cip,  d_direccion);
END;

BEGIN
    insertar_Detenido(
        '32345658',  -- Documento_Identidad
        'Diego',  -- Nombres
        'Macedo',  -- Apellidos
        'Regy',  -- Alias
        'M',  -- Género
        TO_DATE('1990-05-12', 'YYYY-MM-DD'),  -- Fecha_Nacimiento
        'Peruano',  -- Nacionalidad
        'Los god',  -- Banda_Nombre
        1.75,  -- Talla
        'Atlética',  -- Contextura
        '11112222',  -- CIP
        'Av. Siempre Viva 742'  -- Dirección
    );
END;
/
Commit;

--2 Procedimiento para actualizar el estado de una caso
 CREATE OR REPLACE PROCEDURE actualizar_estado_caso(
    p_id_caso IN INT,
    p_estado IN VARCHAR2
) IS
BEGIN
    UPDATE Casos
    SET Estado = p_estado
    WHERE ID_Caso = p_id_caso;
END;

BEGIN
    actualizar_estado_caso(1, 'Cerrado');
END;
/

--Funcion 1

CREATE OR REPLACE FUNCTION generar_correo(codigo VARCHAR2)
RETURN VARCHAR2
IS
    correo VARCHAR2(100);
BEGIN
    SELECT LOWER(SUBSTR(nombre, 1, 1) || apellido || '@comisaria.pe')
    INTO correo
    FROM efectivo_Policial e
    WHERE e.CIP = codigo;
    RETURN correo;
END;

SELECT generar_correo('12345678') FROM dual;

--Funcion 2

CREATE OR REPLACE FUNCTION ConsultarAntecedentes (
    p_Documento_Identidad VARCHAR2
) RETURN VARCHAR2 IS
    v_count NUMBER := 0;
    v_resultado VARCHAR2(4000);
BEGIN
    -- Contar antecedentes del detenido
    SELECT COUNT(*) INTO v_count
    FROM Antecedentes_Penales
    WHERE Documento_Identidad = p_Documento_Identidad;

    IF v_count > 0 THEN
        -- Concatenar todos los antecedentes 
        SELECT LISTAGG(Observaciones, ' | ') WITHIN GROUP (ORDER BY Fecha_Registro DESC)
        INTO v_resultado
        FROM Antecedentes_Penales
        WHERE Documento_Identidad = p_Documento_Identidad;
        -- Agregar info
        v_resultado := 'Total Antecedentes: ' || v_count || ' - Detalles: ' || v_resultado;
    ELSE
        v_resultado := 'No tiene antecedentes';
    END IF;
    RETURN v_resultado;
END;
/

SELECT ConsultarAntecedentes('12345678') AS Total_Antecedentes FROM DUAL;

-- Vista de los detenidos y su informacion de traslado
CREATE VIEW detenidos_traslados AS
SELECT 
    d.Nombres, 
    d.Apellidos, 
    t.Fecha_Ingreso, 
    c.Nombre AS Centro_Detencion
FROM 
    Detenido d
JOIN 
    Traslado t 
    ON d.Documento_Identidad = t.Documento_Identidad
JOIN 
    Centro_Detencion c 
    ON t.ID_Centro = c.ID_Centro;

SELECT * FROM detenidos_traslados;

--Vista con los detalles de audiencia de los detenidos

CREATE VIEW detenidos_audiencias_programadas AS
SELECT 
    d.Nombres, 
    d.Apellidos, 
    a.Fecha_Audiencia, 
    a.Observaciones
FROM 
    Detenido d
JOIN 
    Audiencia a 
    ON d.Documento_Identidad = a.Documento_Identidad;

SELECT * FROM detenidos_audiencias_programadas;


-- TRIGGERS (6)

-- 1 Trigger de insert y update --
CREATE OR REPLACE TRIGGER TRIGGER_tipo_delito BEFORE INSERT OR UPDATE ON delito
FOR EACH ROW 
BEGIN
    IF :NEW.Tipo NOT IN ('Robo', 'Homicidio', 'Extorsión', 'Extorsión', 'Secuestro' , 'Narcotráfico' , 'Fraude' , 'Violación' ) THEN
    RAISE_APPLICATION_ERROR(-20003, 'Tipo de delito inválido para la tabla SOLO -ROBO-HOMICIDIO-SECUESTRO-');
    END IF;
END;
/

INSERT INTO delito (Tipo) 
VALUES ('aaaa');


-- 2 Trigger de insert y update --
CREATE OR REPLACE TRIGGER TRIGGER_fecha_nacimiento
BEFORE INSERT OR UPDATE ON detenido
FOR EACH ROW
BEGIN
  IF :NEW.fecha_nacimiento > SYSDATE THEN
    RAISE_APPLICATION_ERROR(-20004, 'La fecha de nacimiento no puede ser mayor a la actual');
  END IF;
END;
/

INSERT INTO detenido (fecha_nacimiento) 
VALUES (TO_DATE('2027-01-01', 'YYYY-MM-DD'));


-- 3 Trigger de Insert y update--
CREATE OR REPLACE TRIGGER TRIGGER_fechas_traslado
BEFORE INSERT OR UPDATE ON traslado
FOR EACH ROW
BEGIN
  IF :NEW.fecha_salida IS NOT NULL AND :NEW.fecha_ingreso > :NEW.fecha_salida THEN
    RAISE_APPLICATION_ERROR(-20005, 'La fecha de ingreso no puede ser posterior a la Fecha_Salida del detenido');
  END IF;
END;
/

INSERT INTO traslado (documento_identidad, id_centro, fecha_ingreso, fecha_salida) 
VALUES ('12345678', 1, TO_DATE ('2025-02-02', 'YYYY-MM-DD'), TO_DATE('2023-02-01', 'YYYY-MM-DD'));

-- 4 Trigger de deleting--
CREATE OR REPLACE TRIGGER TRIGGER_juicio
BEFORE DELETE ON casos
FOR EACH ROW
BEGIN
  IF :OLD.estado = 'Abierto' THEN
    RAISE_APPLICATION_ERROR(-20008, 'No se puede eliminar el caso porque está en juicio');
  END IF;
END;
/
DELETE FROM casos 
WHERE estado = 'Abierto';

--5 Trigger de deleting--
CREATE OR REPLACE TRIGGER TRIGGER_antecedentes_delete
BEFORE DELETE ON antecedentes_penales
FOR EACH ROW
BEGIN
  -- Simula la solicitud de confirmación antes de borrar
  DECLARE
    v_confirmacion VARCHAR2(10);
  BEGIN
    v_confirmacion := 'NO'; 
    IF v_confirmacion = 'NO' THEN
      RAISE_APPLICATION_ERROR(-20011, 'Confirmación requerida para eliminar el antecedente penal. Operación cancelada.');
    END IF;
  END;
END;
/

-- Intentamos eliminar el antecedente
DELETE FROM antecedentes_penales WHERE ID_Antecedente = 4;

--6 Trigger de update--
CREATE OR REPLACE TRIGGER TRIGGER_antecedentes_update
BEFORE UPDATE ON antecedentes_penales
FOR EACH ROW
BEGIN
  -- Evita cambiar campos críticos como el dni y el codigo del delito
  IF :NEW.documento_identidad <> :OLD.documento_identidad THEN
    RAISE_APPLICATION_ERROR(-20012, 'No se puede cambiar el Documento de Identidad del antecedente penal');
  END IF;

  IF :NEW.codigo_delito <> :OLD.codigo_delito THEN
    RAISE_APPLICATION_ERROR(-20013, 'No se puede cambiar el Código del Delito en los antecedentes penales');
  END IF;
END;
/

-- Prueba de cambiar el dni
UPDATE antecedentes_penales 
SET documento_identidad = '12345681' 
WHERE ID_Antecedente = 5;

