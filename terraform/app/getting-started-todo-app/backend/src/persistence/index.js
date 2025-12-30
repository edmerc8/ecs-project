// if (process.env.MYSQL_HOST) module.exports = require('./mysql');
// else module.exports = require('./sqlite');
if (process.env.DB_ENGINE === 'postgres') {
    module.exports = require('./postgres'); // <--- New PostgreSQL file
} else if (process.env.MYSQL_HOST) {
    module.exports = require('./mysql');
} else {
    module.exports = require('./sqlite');
}