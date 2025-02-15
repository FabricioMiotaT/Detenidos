const express = require("express");
const oracledb = require("oracledb");

const router = express.Router();
const dbConfig = {
  user: "fabricio",
  password: "123",
  connectString: "localhost:1521/freepdb2",
};

// Obtener todos los policías
router.get("/", async (req, res) => {
  let connection;
  try {
    connection = await oracledb.getConnection(dbConfig);
    const result = await connection.execute("SELECT * FROM Efectivo_Policial", [], { outFormat: oracledb.OUT_FORMAT_OBJECT });
    res.json(result.rows);
  } catch (err) {
    res.status(500).json({ error: err.message });
  } finally {
    if (connection) await connection.close();
  }
});

// Obtener un policía por CIP
router.get("/:cip", async (req, res) => {
  let connection;
  try {
    connection = await oracledb.getConnection(dbConfig);
    const result = await connection.execute("SELECT * FROM Efectivo_Policial WHERE CIP = :cip", [req.params.cip], { outFormat: oracledb.OUT_FORMAT_OBJECT });
    if (result.rows.length > 0) {
      res.json(result.rows[0]);
    } else {
      res.status(404).json({ error: "Policía no encontrado" });
    }
  } catch (err) {
    res.status(500).json({ error: err.message });
  } finally {
    if (connection) await connection.close();
  }
});

// Insertar un nuevo policía
router.post("/", async (req, res) => {
  const { cip, nombre, apellido, grado, unidad_de_trabajo, cargo } = req.body;
  let connection;
  try {
    connection = await oracledb.getConnection(dbConfig);
    await connection.execute(
      `INSERT INTO Efectivo_Policial (CIP, Nombre, Apellido, Grado, Unidad_de_Trabajo, Cargo)
       VALUES (:cip, :nombre, :apellido, :grado, :unidad_de_trabajo, :cargo)`,
      { cip, nombre, apellido, grado, unidad_de_trabajo, cargo },
      { autoCommit: true }
    );
    res.json({ message: "Policía agregado correctamente" });
  } catch (err) {
    res.status(500).json({ error: err.message });
  } finally {
    if (connection) await connection.close();
  }
});

// Actualizar un policía
router.put("/:cip", async (req, res) => {
  const { nombre, apellido, grado, unidad_de_trabajo, cargo } = req.body;
  let connection;
  try {
    connection = await oracledb.getConnection(dbConfig);
    await connection.execute(
      `UPDATE Efectivo_Policial SET Nombre = :nombre, Apellido = :apellido, Grado = :grado, Unidad_de_Trabajo = :unidad_de_trabajo WHERE CIP = :cip`,
      { nombre, apellido, grado, unidad_de_trabajo, cip: req.params.cip },
      { autoCommit: true }
    );
    res.json({ message: "Policía actualizado correctamente" });
  } catch (err) {
    res.status(500).json({ error: err.message });
  } finally {
    if (connection) await connection.close();
  }
});

// Eliminar un policía
router.delete("/:cip", async (req, res) => {
  let connection;
  try {
    connection = await oracledb.getConnection(dbConfig);
    await connection.execute("DELETE FROM Efectivo_Policial WHERE CIP = :cip", [req.params.cip], { autoCommit: true });
    res.json({ message: "Policía eliminado correctamente" });
  } catch (err) {
    res.status(500).json({ error: err.message });
  } finally {
    if (connection) await connection.close();
  }
});

module.exports = router;
