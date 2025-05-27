const PassengerRequest = require('../models/passengerRequest');
const User = require('../models/user');

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
    const request = await PassengerRequest.findOne({ 
      where: { userId },
      include: [{
        model: User,
        as: 'user',
        attributes: ['name', 'surname', 'phoneNumber']
      }],
      attributes: ['id', 'location', 'fromOzu', 'datetime', 'offset', 'taxi', 'carpool']
    });
    
    if (!request) return res.status(404).json({ error: 'Request not found' });
    
    // Format the response to flatten user data
    const formattedRequest = {
      id: request.id,
      location: request.location,
      fromOzu: request.fromOzu,
      datetime: request.datetime,
      offset: request.offset,
      taxi: request.taxi,
      carpool: request.carpool,
      name: request.user.name,
      surname: request.user.surname,
      phoneNumber: request.user.phoneNumber
    };
    
    res.json(formattedRequest);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

exports.getPassengerRequestList = async (req, res) => {
  try {
    const requests = await PassengerRequest.findAll({
      include: [{
        model: User,
        as: 'user',
        attributes: ['name', 'surname', 'phoneNumber']
      }],
      attributes: ['id', 'location', 'fromOzu', 'datetime', 'offset', 'taxi', 'carpool']
    });

    // Format the response to flatten user data
    const formattedRequests = requests.map(request => ({
      id: request.id,
      location: request.location,
      fromOzu: request.fromOzu,
      datetime: request.datetime,
      offset: request.offset,
      taxi: request.taxi,
      carpool: request.carpool,
      name: request.user.name,
      surname: request.user.surname,
      phoneNumber: request.user.phoneNumber
    }));

    res.json(formattedRequests);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
}; 