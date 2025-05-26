const express = require('express');
const bodyParser = require('body-parser');
const sequelize = require('./config');

// Models (ensure tables are created)
require('./models/user');
require('./models/driverRequest');
require('./models/passengerRequest');

const app = express();
app.use(bodyParser.json());

// Routes (to be implemented)
const userRoutes = require('./routes/user');
const driverRequestRoutes = require('./routes/driverRequest');
const passengerRequestRoutes = require('./routes/passengerRequest');
app.use('/users', userRoutes);
app.use('/driver-requests', driverRequestRoutes);
app.use('/passenger-requests', passengerRequestRoutes);

const PORT = process.env.PORT || 3000;

sequelize.sync().then(() => {
  app.listen(PORT, () => {
    console.log(`Server is running on port ${PORT}`);
  });
}); 