const express = require('express');
const app = express();
const db = require('./persistence');
const getGreeting = require('./routes/getGreeting');
const getItems = require('./routes/getItems');
const addItem = require('./routes/addItem');
const updateItem = require('./routes/updateItem');
const deleteItem = require('./routes/deleteItem');

// Used to fail health checks during shutdown
let isShuttingDown = false;

app.use(express.json());
app.use(express.static(__dirname + '/static'));


app.get('/api/health', async (req, res) => {
    // Disable caching so monitoring tools get fresh data
    res.set('Cache-Control', 'no-cache, no-store, must-revalidate');

    const health = {
        status: 'UP',
        uptime: process.uptime(),
        timestamp: new Date().toISOString(),
        checks: {
            database: 'UP'
        }
    };

    // If we shutting down, fail the health check
    if (isShuttingDown) {
        health.status = 'DOWN';
        health.message = 'Service is shutting down';
        return res.status(503).json(health);
    }

    try {
        // Validate database connectivity
        await db.checkConnection(); 
    } catch (err) {
        health.status = 'DOWN';
        health.checks.database = 'DOWN';
        health.error = err.message;
        return res.status(503).json(health);
    }

    res.status(200).json(health);
});



app.get('/api/greeting', getGreeting);
app.get('/api/items', getItems);
app.post('/api/items', addItem);
app.put('/api/items/:id', updateItem);
app.delete('/api/items/:id', deleteItem);

db.init()
    .then(() => {
        app.listen(3000, () => console.log('Listening on port 3000'));
    })
    .catch((err) => {
        console.error(err);
        process.exit(1);
    });

const gracefulShutdown = () => {
    db.teardown()
        .catch(() => {})
        .then(() => process.exit());
};

process.on('SIGINT', gracefulShutdown);
process.on('SIGTERM', gracefulShutdown);
process.on('SIGUSR2', gracefulShutdown); // Sent by nodemon
