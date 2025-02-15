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
