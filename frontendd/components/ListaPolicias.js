import React, { useEffect, useState } from "react";
import axios from "axios";

const API_URL = "http://localhost:3001/policias";

function ListaPolicias() {
  const [policias, setPolicias] = useState([]);
  const [form, setForm] = useState({
    cip: "",
    nombre: "",   
    apellido: "", 
    grado: "",
    unidad_de_Trabajo: "",
  });
  
  const [editando, setEditando] = useState(false);

  useEffect(() => {
    fetchPolicias();
  }, []);

  const fetchPolicias = async () => {
    try {
      const response = await axios.get(API_URL);
      setPolicias(response.data);
    } catch (error) {
      console.error("Error al obtener los policías:", error);
    }
  };

  const handleChange = (e) => {
    setForm({ ...form, [e.target.name]: e.target.value });
  };

  const handleSubmit = async (e) => {
    e.preventDefault();
    try {
      if (editando) {
        await axios.put(`${API_URL}/${form.cip}`, form);
      } else {
        await axios.post(API_URL, form);
      }
      setForm({ cip: "", nombre: "", apellido: "", grado: "", comisaria: "" });
      setEditando(false);
      fetchPolicias();
    } catch (error) {
      console.error("Error al guardar el policía:", error);
    }
  };

  const handleEdit = (policia) => {
    setForm({
      cip: policia.CIP,
      Nombre: policia.NOMBRE,   
      Apellido: policia.APELLIDO,
      Grado: policia.GRADO,
      Unidad_de_Trabajo: policia.UNIDAD_DE_TRABAJO,
    });
    setEditando(true);
  };
  

  const handleDelete = async (cip) => {
    if (window.confirm("¿Seguro que quieres eliminar este policía?")) {
      try {
        await axios.delete(`${API_URL}/${cip}`);
        fetchPolicias();
      } catch (error) {
        console.error("Error al eliminar el policía:", error);
      }
    }
  };

  return (
    <div>
      <h2>Lista de Policías</h2>
      {policias.length > 0 ? (
        <table border="1">
          <thead>
            <tr>
              <th>CIP</th>
              <th>Nombre</th>
              <th>Grado</th>
              <th>Unidad de Trabajo</th>
            </tr>
          </thead>
          <tbody>
            {policias.map((policia) => (
              <tr key={policia.CIP}>
                <td>{policia.CIP}</td>
                <td>{policia.NOMBRE} {policia.APELLIDO}</td>
                <td>{policia.GRADO}</td>
                <td>{policia.UNIDAD_DE_TRABAJO}</td>
                <td>
                  <button onClick={() => handleEdit(policia)}>Editar</button>
                  <button onClick={() => handleDelete(policia.CIP)}>Eliminar</button>
                </td>
              </tr>
            ))}
          </tbody>
        </table>
      ) : (
        <p>No hay policías registrados.</p>
      )}

      <h2>{editando ? "Editar Policía" : "Agregar Policía"}</h2>
      <form onSubmit={handleSubmit}>
        <input type="text" name="cip" placeholder="CIP" value={form.cip} onChange={handleChange} required />
        <input type="text" name="nombre" placeholder="Nombres" value={form.nombre} onChange={handleChange} required />
        <input type="text" name="apellido" placeholder="Apellidos" value={form.apellido} onChange={handleChange} required />
        <input type="text" name="grado" placeholder="Grado" value={form.grado} onChange={handleChange} required />
        <input type="text" name="unidad_de_trabajo" placeholder="Unidad de Trabajo" value={form.comisaria} onChange={handleChange} required />
        <button type="submit">{editando ? "Actualizar" : "Agregar"}</button>
      </form>
    </div>
  );
}

export default ListaPolicias;
