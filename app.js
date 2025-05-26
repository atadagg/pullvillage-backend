const express = require('express');
const bodyParser = require('body-parser');
const sequelize = require('./config');
const https = require('https');
const fs = require('fs');

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

app.use((req, res, next) => {
  console.log(`[${new Date().toISOString()}] ${req.method} ${req.originalUrl}`);
  next();
});

const PORT = process.env.PORT || 3000;

sequelize.sync().then(() => {
  const options = {
    key: fs.readFileSync('server.key'),
    cert: fs.readFileSync('server.cert')
  };

  https.createServer(options, app).listen(PORT, () => {
    console.log(`HTTPS server running on port ${PORT}`);
  });
}); 