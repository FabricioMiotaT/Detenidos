const express = require("express");
const oracledb = require("oracledb");

const router = express.Router();
const dbConfig = {
  user: "fabricio",
  password: "123",
  connectString: "localhost:1521/freepdb2",
};

// Obtener todos los delitos
router.get("/", async (req, res) => {
  let connection;
  try {
    connection = await oracledb.getConnection(dbConfig);
    const result = await connection.execute("SELECT * FROM Delito", [], { outFormat: oracledb.OUT_FORMAT_OBJECT });
    res.json(result.rows);
  } catch (err) {
    res.status(500).json({ error: err.message });
  } finally {
    if (connection) await connection.close();
  }
});

// Obtener un delito por código
router.get("/:codigo", async (req, res) => {
  let connection;
  try {
    connection = await oracledb.getConnection(dbConfig);
    const result = await connection.execute("SELECT * FROM Delito WHERE Codigo = :codigo", [req.params.codigo], { outFormat: oracledb.OUT_FORMAT_OBJECT });
    if (result.rows.length > 0) {
      res.json(result.rows[0]);
    } else {
      res.status(404).json({ error: "Delito no encontrado" });
    }
  } catch (err) {
    res.status(500).json({ error: err.message });
  } finally {
    if (connection) await connection.close();
  }
});

// 🔹 Insertar un nuevo delito
router.post("/", async (req, res) => {
  const { codigo, nombre, descripcion, tipo, modalidad } = req.body;
  let connection;
  try {
    connection = await oracledb.getConnection(dbConfig);
    await connection.execute(
      `INSERT INTO Delito (Codigo, Nombre, Descripcion, Tipo, Modalidad)
       VALUES (:codigo, :nombre, :descripcion, :tipo, :modalidad)`,
      { codigo, nombre, descripcion, tipo, modalidad },
      { autoCommit: true }
    );
    res.json({ message: "Delito agregado correctamente" });
  } catch (err) {
    res.status(500).json({ error: err.message });
  } finally {
    if (connection) await connection.close();
  }
});

router.put("/:codigo", async (req, res) => {
    const { codigo } = req.params;
    const { descripcion, tipo, modalidad } = req.body;

    let connection;
    try {
        connection = await oracledb.getConnection(dbConfig);
        console.log("Código recibido:", codigo);
        console.log("Datos recibidos:", req.body);

        const result = await connection.execute(
            `UPDATE Delito SET 
                Descripcion = :descripcion, 
                Tipo = :tipo, 
                Modalidad = :modalidad 
             WHERE Codigo = :codigo`,
            { descripcion, tipo, modalidad, codigo },
            { autoCommit: true }
        );

        console.log("🔹 Filas afectadas:", result.rowsAffected);

        if (result.rowsAffected === 0) {
            return res.status(404).json({ message: "Delito no encontrado" });
        }

        res.json({ message: "Delito actualizado correctamente" });
    } catch (error) {
        console.error("Error en la actualización:", error);
        res.status(500).json({ error: "Error del servidor", detalle: error.message });
    } finally {
        if (connection) await connection.close();
    }
});

  
// Eliminar un delito
router.delete("/:codigo", async (req, res) => {
  let connection;
  try {
    connection = await oracledb.getConnection(dbConfig);
    await connection.execute("DELETE FROM Delito WHERE Codigo = :codigo", [req.params.codigo], { autoCommit: true });
    res.json({ message: "Delito eliminado correctamente" });
  } catch (err) {
    res.status(500).json({ error: err.message });
  } finally {
    if (connection) await connection.close();
  }
});

module.exports = router;
