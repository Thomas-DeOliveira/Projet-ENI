module.exports = {
  HOST: 'mysql-projet-eni.mysql.database.azure.com',
  USER: 'adminmysql',
  PASSWORD: '',
  DB: 'todolist_db',
  dialect: 'mysql',
  pool: {
    max: 5,
    min: 0,
    acquire: 30000,
    idle: 10000
  }
};
