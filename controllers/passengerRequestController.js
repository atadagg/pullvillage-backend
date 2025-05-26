const PassengerRequest = require('../models/passengerRequest');

exports.submitPassengerRequest = async (req, res) => {
  try {
    const { userId, location, fromOzu, datetime, offset, taxi, carpool } = req.body;
    if (!userId || !location || fromOzu === undefined || !datetime || offset === undefined || taxi === undefined || carpool === undefined) {
      return res.status(400).json({ error: 'Missing required fields' });
    }
    const request = await PassengerRequest.create({ userId, location, fromOzu, datetime, offset, taxi, carpool });
    res.status(201).json(request);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

exports.deletePassengerRequest = async (req, res) => {
  try {
    const { id } = req.params;
    const deleted = await PassengerRequest.destroy({ where: { id } });
    if (!deleted) return res.status(404).json({ error: 'Request not found' });
    res.status(204).send();
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

exports.getPassengerTaxiRequest = async (req, res) => {
  try {
    const { userId } = req.params;
    const request = await PassengerRequest.findOne({ where: { userId } });
    if (!request) return res.status(404).json({ error: 'Request not found' });
    res.json(request);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

exports.getPassengerRequestList = async (req, res) => {
  try {
    const requests = await PassengerRequest.findAll();
    res.json(requests);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
}; 