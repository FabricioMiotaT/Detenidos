import React, { useEffect, useState } from "react";
import axios from "axios";

const API_URL = "http://localhost:3001/detenidos"; 

function ListaDetenidos() {
  const [detenidos, setDetenidos] = useState([]);
  const [form, setForm] = useState({
    documento: "",
    nombres: "",
    apellidos: "",
    alias: "",
    genero: "",
    fecha_nacimiento: "",
    nacionalidad: "",
    banda_nombre: "",
    talla: "",
    contextura: "",
    cip: "",
    direccion: "",
  });
  const [editando, setEditando] = useState(false);

  useEffect(() => {
    fetchDetenidos();
  }, []);

  const fetchDetenidos = async () => {
    try {
      const response = await axios.get(API_URL);
      console.log("Detenidos obtenidos:", response.data);
      setDetenidos(response.data);
    } catch (error) {
      console.error("Error al obtener los detenidos:", error);
    }
  };

  const handleChange = (e) => {
    setForm({ ...form, [e.target.name]: e.target.value });
  };

  const handleSubmit = async (e) => {

    e.preventDefault();
    try {
      if (editando) {
        await axios.put(`${API_URL}/${form.documento}`, form);
      } else {
        await axios.post(API_URL, form);
      }
      setForm({
        documento: "",
        nombres: "",
        apellidos: "",
        alias: "",
        genero: "",
        fecha_nacimiento: "",
        nacionalidad: "",
        banda_nombre: "",
        talla: "",
        contextura: "",
        cip: "",
        direccion: "",
      });
      setEditando(false);
      fetchDetenidos();
    } catch (error) {
      console.error("Error al guardar el detenido:", error);
    }
  };

  const handleEdit = (detenido) => {
    setForm({
      documento: detenido.DOCUMENTO_IDENTIDAD,
      nombres: detenido.NOMBRES,
      apellidos: detenido.APELLIDOS,
      alias: detenido.ALIAS,
      genero: detenido.GENERO,
      fecha_nacimiento: detenido.FECHA_NACIMIENTO,
      nacionalidad: detenido.NACIONALIDAD,
      banda_nombre: detenido.BANDA_NOMBRE,
      talla: detenido.TALLA,
      contextura: detenido.CONTEXTURA,
      cip: detenido.CIP,
      direccion: detenido.DIRECCION,
    });
    setEditando(true);
  };

  const handleDelete = async (documento) => {
    if (window.confirm("¿Seguro que quieres eliminar este detenido?")) {
      try {
        await axios.delete(`${API_URL}/${documento}`);
        fetchDetenidos();
      } catch (error) {
        console.error("Error al eliminar el detenido:", error);
      }
    }
  };

  return (
    <div>
      <h2>Lista de Detenidos</h2>
      {detenidos.length > 0 ? (
        <table border="1">
          <thead>
            <tr>
              <th>Documento</th>
              <th>Nombre</th>
              <th>Alias</th>
              <th>Género</th>
              <th>Fecha Nac.</th>
              <th>Banda</th>
              <th>Acciones</th>
            </tr>
          </thead>
          <tbody>
            {detenidos.map((detenido) => (
              <tr key={detenido.DOCUMENTO_IDENTIDAD}>
                <td>{detenido.DOCUMENTO_IDENTIDAD}</td>
                <td>{detenido.NOMBRES} {detenido.APELLIDOS}</td>
                <td>{detenido.ALIAS}</td>
                <td>{detenido.GENERO}</td>
                <td>{detenido.FECHA_NACIMIENTO}</td>
                <td>{detenido.BANDA_NOMBRE}</td>
                <td>
                  <button onClick={() => handleEdit(detenido)}>✏️ Editar</button>
                  <button onClick={() => handleDelete(detenido.DOCUMENTO_IDENTIDAD)}>❌ Eliminar</button>
                </td>
              </tr>
            ))}
          </tbody>
        </table>
      ) : (
        <p>No hay detenidos registrados.</p>
      )}

      <h2>{editando ? "Editar Detenido" : "Agregar Detenido"}</h2>
      <form onSubmit={handleSubmit}>
        <input type="text" name="documento" placeholder="Documento" value={form.documento} onChange={handleChange} required />
        <input type="text" name="nombres" placeholder="Nombres" value={form.nombres} onChange={handleChange} required />
        <input type="text" name="apellidos" placeholder="Apellidos" value={form.apellidos} onChange={handleChange} required />
        <input type="text" name="alias" placeholder="Alias" value={form.alias} onChange={handleChange} />
        <select name="genero" value={form.genero} onChange={handleChange}>
          <option value="">Seleccionar género</option>
          <option value="M">Masculino</option>
          <option value="F">Femenino</option>
        </select>
        <input type="date" name="fecha_nacimiento" value={form.fecha_nacimiento} onChange={handleChange} required />
        <input type="text" name="nacionalidad" placeholder="Nacionalidad" value={form.nacionalidad} onChange={handleChange} required />
        <input type="text" name="banda_nombre" placeholder="Banda" value={form.banda_nombre} onChange={handleChange} />
        <input type="text" name="talla" placeholder="Talla" value={form.talla} onChange={handleChange} />
        <input type="text" name="contextura" placeholder="Contextura" value={form.contextura} onChange={handleChange} />
        <input type="text" name="cip" placeholder="CIP" value={form.cip} onChange={handleChange} />
        <input type="text" name="direccion" placeholder="Dirección" value={form.direccion} onChange={handleChange} required />
        <button type="submit">{editando ? "Actualizar" : "Agregar"}</button>
      </form>
    </div>
  );
}

export default ListaDetenidos;
