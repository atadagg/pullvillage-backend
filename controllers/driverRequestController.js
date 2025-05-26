const DriverRequest = require('../models/driverRequest');

exports.submitDriverRequest = async (req, res) => {
  try {
    const { userId, location, fromOzu, datetime, offset } = req.body;
    if (!userId || !location || fromOzu === undefined || !datetime || offset === undefined) {
      return res.status(400).json({ error: 'Missing required fields' });
    }
    const request = await DriverRequest.create({ userId, location, fromOzu, datetime, offset });
    res.status(201).json(request);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

exports.deleteDriverRequest = async (req, res) => {
  try {
    const { id } = req.params;
    const deleted = await DriverRequest.destroy({ where: { id } });
    if (!deleted) return res.status(404).json({ error: 'Request not found' });
    res.status(204).send();
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

exports.getDriverRequestList = async (req, res) => {
  try {
    const requests = await DriverRequest.findAll();
    res.json(requests);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
}; 