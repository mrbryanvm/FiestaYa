const Event = require('../models/eventModel'); // Asegúrate de que la ruta sea correcta

const createEvent = async (req, res) => {
  try {
    const { title, description, location, date, time, user_id } = req.body;

    const newEvent = await Event.create({
      title,
      description,
      location,
      date,
      time,
      user_id
    });

    res.status(201).json({ event: newEvent });
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: 'Error al crear el evento' });
  }
};

module.exports = {
  createEvent
};
