const express = require('express');
const cors = require('cors');
const bodyParser = require('body-parser');
const detenidosRoutes = require('./routes/detenidos');
const delitosRoutes = require('./routes/delitos');
const policiasRoutes = require('./routes/policias');

const app = express();
app.use(cors());
app.use(bodyParser.json());

// Rutas para las entidades
app.use('/detenidos', detenidosRoutes);
app.use('/delitos', delitosRoutes);
app.use('/policias', policiasRoutes);

// Ruta para verificar que el servidor está funcionando
app.get('/', (req, res) => {
    res.send('Servidor funcionando gaaa');
});

const PORT = 3001;
app.listen(PORT, () => {
    console.log(`Servidor corriendo en http://localhost:${PORT}`);
});
