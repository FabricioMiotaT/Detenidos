const express = require("express");
const oracledb = require("oracledb");

const router = express.Router();

const dbConfig = {
  user: "fabricio",
  password: "123",
  connectString: "localhost:1521/freepdb2",
};

//Obtener todos los detenidos
router.get("/", async (req, res) => {
  let connection;
  try {
    connection = await oracledb.getConnection(dbConfig);
    const result = await connection.execute(
      `SELECT * FROM Detenido`,
      [],
      { outFormat: oracledb.OUT_FORMAT_OBJECT }
    );
    res.json(result.rows);
  } catch (err) {
    console.error("Error al obtener detenidos:", err);
    res.status(500).json({ error: err.message });
  } finally {
    if (connection) await connection.close();
  }
});

router.get("/:documento", async (req, res) => {
    const { documento } = req.params;
    let connection;
    try {
      connection = await oracledb.getConnection(dbConfig);
      const result = await connection.execute(
        `SELECT * FROM Detenido WHERE DOCUMENTO_IDENTIDAD = :documento`,
        { documento },
        { outFormat: oracledb.OUT_FORMAT_OBJECT }
      );
  
      if (result.rows.length === 0) {
        return res.status(404).json({ error: "Detenido no encontrado" });
      }
  
      res.json(result.rows[0]);
    } catch (err) {
      console.error("Error al buscar detenido:", err);
      res.status(500).json({ error: err.message });
    } finally {
      if (connection) await connection.close();
    }
  });

  router.post("/", async (req, res) => {
    const {
      documento,
      nombres,
      apellidos,
      alias,
      genero,
      fecha_nacimiento,
      nacionalidad,
      banda_nombre,
      talla,
      contextura,
      cip,
      direccion,
    } = req.body;
  
    let connection;
    try {
      connection = await oracledb.getConnection(dbConfig);
  
      await connection.execute(
        `INSERT INTO Detenido (
           DOCUMENTO_IDENTIDAD, NOMBRES, APELLIDOS, ALIAS, GENERO, 
           FECHA_NACIMIENTO, NACIONALIDAD, BANDA_NOMBRE, TALLA, CONTEXTURA, CIP, DIRECCION
         ) VALUES (
           :documento, :nombres, :apellidos, :alias, :genero, 
           TO_DATE(:fecha_nacimiento, 'YYYY-MM-DD'), :nacionalidad, :banda_nombre, 
           :talla, :contextura, :cip, :direccion
         )`,
        {
          documento,
          nombres,
          apellidos,
          alias,
          genero,
          fecha_nacimiento,
          nacionalidad,
          banda_nombre,
          talla: parseFloat(talla),
          contextura,
          cip,
          direccion,
        },
        { autoCommit: true }
      );
  
      res.json({ message: "Detenido agregado correctamente" });
  
    } catch (err) {
      console.error("Error al agregar detenido:", err);
      res.status(500).json({ error: err.message });
    } finally {
      if (connection) await connection.close();
    }
  });
  

router.put("/:documento", async (req, res) => {
    const { documento } = req.params;
    console.log("Documento recibido en API:", documento);
    console.log("Datos enviados desde frontend:", req.body);
  
    let connection;
    try {
      connection = await oracledb.getConnection(dbConfig);
  
      const checkResult = await connection.execute(
        `SELECT * FROM Detenido WHERE DOCUMENTO_IDENTIDAD = :documento`,
        { documento },
        { outFormat: oracledb.OUT_FORMAT_OBJECT }
      );
  
      console.log("🔍 Resultado de búsqueda:", checkResult.rows);
  
      if (checkResult.rows.length === 0) {
        console.warn("⚠️ No se encontró el detenido con documento:", documento);
        return res.status(404).json({ error: "Detenido no encontrado" });
      }
  
      // Intentar actualizar
      const result = await connection.execute(
        `UPDATE Detenido SET 
           NOMBRES = :nombres, APELLIDOS = :apellidos, ALIAS = :alias, GENERO = :genero, 
           FECHA_NACIMIENTO = TO_DATE(:fecha_nacimiento, 'YYYY-MM-DD'), 
           NACIONALIDAD = :nacionalidad, BANDA_NOMBRE = :banda_nombre, 
           TALLA = :talla, CONTEXTURA = :contextura, CIP = :cip, DIRECCION = :direccion
         WHERE DOCUMENTO_IDENTIDAD = :documento`,
        {
          documento,
          ...req.body,
        },
        { autoCommit: true }
      );
  
      console.log("Filas afectadas:", result.rowsAffected);
  
      if (result.rowsAffected === 0) {
        return res.status(404).json({ error: "Detenido no encontrado" });
      }
  
      res.json({ message: "Detenido actualizado correctamente" });
    } catch (err) {
      console.error(" Error al actualizar detenido:", err);
      res.status(500).json({ error: err.message });
    } finally {
      if (connection) await connection.close();
    }
  });
  


// Eliminar un detenido
router.delete("/:documento", async (req, res) => {
  const { documento } = req.params;

  let connection;
  try {
    connection = await oracledb.getConnection(dbConfig);
    await connection.execute(
      `DELETE FROM Detenido WHERE DOCUMENTO_IDENTIDAD = :documento`,
      { documento },
      { autoCommit: true }
    );
    res.json({ message: "Detenido eliminado correctamente" });
  } catch (err) {
    console.error("Error al eliminar detenido:", err);
    res.status(500).json({ error: err.message });
  } finally {
    if (connection) await connection.close();
  }
});

module.exports = router;
