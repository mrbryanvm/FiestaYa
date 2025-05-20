const { createEvent } = require('../models/eventModel');

// Controlador para crear un nuevo evento
const createEventHandler = async (req, res) => {
  try {
    const newEvent = await createEvent(req.body); // Llamamos a la función para crear el evento
    res.status(201).json(newEvent); // Respondemos con el evento creado
  } catch (error) {
    console.error(error);
    res.status(500).json({ error: 'Error al crear evento' }); // Si ocurre un error, respondemos con el mensaje de error
  }
};

module.exports = { createEventHandler };
