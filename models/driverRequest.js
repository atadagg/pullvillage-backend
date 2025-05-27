const { DataTypes } = require('sequelize');
const sequelize = require('../config');

const DriverRequest = sequelize.define('DriverRequest', {
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
}, {
  tableName: 'driver_requests',
  timestamps: false,
});

// Define association
DriverRequest.associate = (models) => {
  DriverRequest.belongsTo(models.User, {
    foreignKey: 'userId',
    as: 'user'
  });
};

module.exports = DriverRequest; 