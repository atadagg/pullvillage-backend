const { DataTypes } = require('sequelize');
const sequelize = require('../config');

const PassengerRequest = sequelize.define('PassengerRequest', {
  id: {
    type: DataTypes.INTEGER,
    primaryKey: true,
    autoIncrement: true,
  },
  userId: {
    type: DataTypes.INTEGER,
    allowNull: false,
  },
  location: {
    type: DataTypes.ENUM('Cekmekoy', 'Sabiha', 'Sile', 'Kadikoy', 'Emlak', 'Karsi', 'Other'),
    allowNull: false,
  },
  fromOzu: {
    type: DataTypes.BOOLEAN,
    allowNull: false,
  },
  datetime: {
    type: DataTypes.DATE,
    allowNull: false,
  },
  offset: {
    type: DataTypes.INTEGER,
    allowNull: false,
  },
  taxi: {
    type: DataTypes.BOOLEAN,
    allowNull: false,
  },
  carpool: {
    type: DataTypes.BOOLEAN,
    allowNull: false,
  },
}, {
  tableName: 'passenger_requests',
  timestamps: false,
});

// Define association
PassengerRequest.associate = (models) => {
  PassengerRequest.belongsTo(models.User, {
    foreignKey: 'userId',
    as: 'user'
  });
};

module.exports = PassengerRequest; 