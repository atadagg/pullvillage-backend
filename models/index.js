const sequelize = require('../config');

// Import all models
const User = require('./user');
const DriverRequest = require('./driverRequest');
const PassengerRequest = require('./passengerRequest');

// Create models object
const models = {
  User,
  DriverRequest,
  PassengerRequest
};

// Set up associations
Object.keys(models).forEach(modelName => {
  if (models[modelName].associate) {
    models[modelName].associate(models);
  }
});

module.exports = models; 