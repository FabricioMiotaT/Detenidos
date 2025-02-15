import React, { useEffect, useState } from "react";
import "./styles.css";
import ListaDetenidos from "./components/ListaDetenidos";
import ListaDelitos from "./components/ListaDelitos";
import ListaPolicias from "./components/ListaPolicias";

function App() {
  const [detenidos, setDetenidos] = useState([]);
  const [delitos, setDelitos] = useState([]);
  const [policias, setPolicias] = useState([]);

  useEffect(() => {

    fetch("http://localhost:3001/detenidos")
      .then((res) => res.json())
      .then((data) => setDetenidos(data))
      .catch((err) => console.error("Error al obtener detenidos:", err));

    fetch("http://localhost:3001/delitos")
      .then((res) => res.json())
      .then((data) => setDelitos(data))
      .catch((err) => console.error("Error al obtener delitos:", err));

    fetch("http://localhost:3001/policias")
      .then((res) => res.json())
      .then((data) => setPolicias(data))
      .catch((err) => console.error("Error al obtener policías:", err));
  }, []);

  return (
    <div className="panel-container">
      {/* Logo y título */}
      <header className="panel-header">
      <img src="/logo.png" alt="Logo PNP" className="logo" />
      <h1>Panel de Control</h1>
      </header>
      
      {/* Listas */}
      <div className="listas-container">
        <ListaDetenidos detenidos={detenidos} />
        <ListaDelitos delitos={delitos} />
        <ListaPolicias policias={policias} />
      </div>
    </div>
  );
}

export default App;

