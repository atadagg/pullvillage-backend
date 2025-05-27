const DriverRequest = require('../models/driverRequest');
const User = require('../models/user');

exports.submitDriverRequest = async (req, res) => {
  try {
    const { firebaseUid, location, fromOzu, datetime, offset } = req.body;
    if (!firebaseUid || !location || fromOzu === undefined || !datetime || offset === undefined) {
      return res.status(400).json({ error: 'Missing required fields' });
    }
    const request = await DriverRequest.create({ firebaseUid, location, fromOzu, datetime, offset });
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
    const requests = await DriverRequest.findAll({
      include: [{
        model: User,
        as: 'user',
        attributes: ['name', 'surname', 'phoneNumber']
      }],
      attributes: ['id', 'location', 'fromOzu', 'datetime', 'offset']
    });

    // Format the response to flatten user data
    const formattedRequests = requests.map(request => ({
      id: request.id,
      location: request.location,
      fromOzu: request.fromOzu,
      datetime: request.datetime,
      offset: request.offset,
      name: request.user.name,
      surname: request.user.surname,
      phoneNumber: request.user.phoneNumber
    }));

    res.json(formattedRequests);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
}; 