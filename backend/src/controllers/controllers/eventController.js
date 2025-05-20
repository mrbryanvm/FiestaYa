// src/controllers/eventController.js
const Event = require('../models/eventModel');

const eventController = {
  // Crear nuevo evento
  createEvent: async (req, res) => {
    try {
      const newEvent = await Event.create(req.body);
      res.status(201).json(newEvent);
    } catch (error) {
      console.error('Error al crear evento:', error);
      res.status(500).json({ error: 'Error al crear el evento' });
    }
  },

  // Obtener todos los eventos
  getAllEvents: async (req, res) => {
    try {
      const events = await Event.getAll();
      res.status(200).json(events);
    } catch (error) {
      console.error('Error al obtener eventos:', error);
      res.status(500).json({ error: 'Error al obtener eventos' });
    }
  }
};

module.exports = eventController;
