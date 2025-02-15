import React, { useEffect, useState } from "react";
import axios from "axios";

const API_URL = "http://localhost:3001/delitos";

function ListaDelitos() {
  const [delitos, setDelitos] = useState([]);
  const [form, setForm] = useState({
    codigo: "",
    descripcion: "",
    tipo: "",
    modalidad: "",
  });
  const [editando, setEditando] = useState(false);

  useEffect(() => {
    fetchDelitos();
  }, []);

  const fetchDelitos = async () => {
    try {
      const response = await axios.get(API_URL);
      setDelitos(response.data);
    } catch (error) {
      console.error("Error al obtener los delitos:", error);
    }
  };

  const handleChange = (e) => {
    setForm({ ...form, [e.target.name]: e.target.value });
  };

  const handleSubmit = async (e) => {
    e.preventDefault();
    try {
      if (editando) {
        console.log("Datos enviados:", form);  

        await axios.put(`${API_URL}/${form.codigo}`, form);
      } else {
        await axios.post(API_URL, form);
      }
      setForm({ codigo: "", descripcion: "", tipo: "" , modalidad: "" });
      setEditando(false);
      fetchDelitos();
    } catch (error) {
      console.error("Error al guardar el delito:", error);
    }
  };

  const handleEdit = (delito) => {
    setForm({
      codigo: delito.CODIGO,
      descripcion: delito.DESCRIPCION,
      tipo: delito.TIPO,
      modalidad: delito.MODALIDAD,
    });
    setEditando(true);
  };

  const handleDelete = async (codigo) => {
    if (window.confirm("¿Seguro que quieres eliminar este delito?")) {
      try {
        await axios.delete(`${API_URL}/${codigo}`);
        fetchDelitos();
      } catch (error) {
        console.error("Error al eliminar el delito:", error);
      }
    }
  };

  return (
    <div>
      <h2>Lista de Delitos</h2>
      {delitos.length > 0 ? (
        <table border="1">
          <thead>
            <tr>
              <th>Código</th>
              <th>Descripción</th>
              <th>Tipo</th>
              <th>Modalidad</th>
              <th>Acciones</th>
            </tr>
          </thead>
          <tbody>
            {delitos.map((delito) => (
              <tr key={delito.CODIGO}>
                <td>{delito.CODIGO}</td>
                <td>{delito.DESCRIPCION}</td>
                <td>{delito.TIPO}</td>
                <td>{delito.MODALIDAD}</td>
                <td>
                  <button onClick={() => handleEdit(delito)}>✏️ Editar</button>
                  <button onClick={() => handleDelete(delito.CODIGO)}>❌ Eliminar</button>
                </td>
              </tr>
            ))}
          </tbody>
        </table>
      ) : (
        <p>No hay delitos registrados.</p>
      )}

      <h2>{editando ? "Editar Delito" : "Agregar Delito"}</h2>
      <form onSubmit={handleSubmit}>
        <input type="text" name="codigo" placeholder="Código" value={form.codigo} onChange={handleChange} required />
        <input type="text" name="descripcion" placeholder="Descripción" value={form.descripcion} onChange={handleChange} required />
        <input type="text" name="tipo" placeholder="Tipo" value={form.tipo} onChange={handleChange} required />
        <input type="text" name="modalidad" placeholder="Modalidad" value={form.modalidad} onChange={handleChange} required />
        <button type="submit">{editando ? "Actualizar" : "Agregar"}</button>
      </form>
    </div>
  );

  
}

export default ListaDelitos;
