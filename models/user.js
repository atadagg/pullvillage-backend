const { DataTypes } = require('sequelize');
const sequelize = require('../config');

const User = sequelize.define('User', {
  userId: {
    type: DataTypes.INTEGER,
    primaryKey: true,
    autoIncrement: true,
  },
  firebaseUid: {
    type: DataTypes.STRING,
    allowNull: false,
    unique: true,
  },
  name: {
    type: DataTypes.STRING,
    allowNull: false,
  },
  surname: {
    type: DataTypes.STRING,
    allowNull: false,
  },
  phoneNumber: {
    type: DataTypes.BIGINT,
    allowNull: false,
  },
}, {
  tableName: 'users',
  timestamps: false,
});

// Define associations
User.associate = (models) => {
  User.hasMany(models.DriverRequest, {
    foreignKey: 'firebaseUid',
    sourceKey: 'firebaseUid',
    as: 'driverRequests'
  });
  
  User.hasMany(models.PassengerRequest, {
    foreignKey: 'firebaseUid',
    sourceKey: 'firebaseUid',
    as: 'passengerRequests'
  });
};

module.exports = User; 