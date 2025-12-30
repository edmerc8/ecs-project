const waitPort = require('wait-port');
const { Client } = require('pg');
const path = require('path')
const fs = require('fs'); // Include fs for file-based variable reading

// --- PostgreSQL-Specific Environment Variables ---
const {
    PG_HOST: HOST,
    PG_HOST_FILE: HOST_FILE,
    PG_USER: USER,
    PG_USER_FILE: USER_FILE,
    PG_PASSWORD: PASSWORD,
    PG_PASSWORD_FILE: PASSWORD_FILE,
    PG_DB: DB,
    PG_DB_FILE: DB_FILE,
    PG_PORT: PORT
} = process.env;

let pool; // The PostgreSQL connection pool/client

// --- Utility function to read file-based variables (inherited from mysql.js) ---
const readVariable = (value, file) => file ? fs.readFileSync(file, 'utf8') : value;

async function init() {
    // Read environment variables, checking for file-based secrets
    const host = readVariable(HOST, HOST_FILE);
    const user = readVariable(USER, USER_FILE);
    const password = readVariable(PASSWORD, PASSWORD_FILE);
    const database = readVariable(DB, DB_FILE);

    const dbPort = PORT || 5432;
    const caPath = path.join(process.cwd(), 'src/certs/global-bundle.pem');

    // Wait for the PostgreSQL server to be available
    await waitPort({
        host,
        port: parseInt(dbPort), // PostgreSQL default port
        timeout: 10000,
        waitForDns: true,
    });

    // Check file exists before trying to read it
    if (!fs.existsSync(caPath)) {
        throw new Error(`SSL Certificate not found at ${caPath}.`);
    }

    // Create the PostgreSQL Client/Pool
    pool = new Client({
        host,
        user,
        password,
        database,
        port: dbPort,
        ssl: { // SSL verificaiton required
            rejectUnauthorized: true, 
            ca: fs.readFileSync(caPath).toString(),
        }
    });
    
    // Establish the connection
    await pool.connect(); 
    console.log(`SECURE connection established to host ${host}`);   
    // PostgreSQL table creation (Uses native BOOLEAN type and no DEFAULT CHARSET)
    await pool.query(
        'CREATE TABLE IF NOT EXISTS todo_items (id VARCHAR(36) PRIMARY KEY, name VARCHAR(255), completed BOOLEAN)',
    );

    console.log(`Connected to postgres db at host ${host}`);
}

async function teardown() {
    // In node-postgres, closing the pool is handled by pool.end()
    await pool.end();
}

async function getItems() {
    const res = await pool.query('SELECT id, name, completed FROM todo_items');
    // PostgreSQL BOOLEAN returns true/false directly, no conversion needed (item.completed === 1 is removed).
    return res.rows;
}

async function getItem(id) {
    // Use $1 for parameterized queries
    const res = await pool.query('SELECT id, name, completed FROM todo_items WHERE id=$1', [id]);
    
    // Return the first item, or undefined if not found
    return res.rows[0]; 
}

async function storeItem(item) {
    // Use $1, $2, $3 for parameterized queries
    await pool.query(
        'INSERT INTO todo_items (id, name, completed) VALUES ($1, $2, $3)',
        // PostgreSQL accepts true/false BOOLEAN values directly
        [item.id, item.name, item.completed], 
    );
}

async function updateItem(id, item) {
    // Use $1, $2, $3 for parameterized queries
    const res = await pool.query(
        'UPDATE todo_items SET name=$1, completed=$2 WHERE id=$3',
        [item.name, item.completed, id], 
    );
    // Return true if any row was updated
    return res.rowCount > 0;
}

async function removeItem(id) {
    // Use $1 for parameterized queries
    await pool.query('DELETE FROM todo_items WHERE id = $1', [id]);
}

async function checkConnection() {
    // Standard Postgres "ping"
    await pool.query('SELECT 1');
}

module.exports = {
    init,
    teardown,
    getItems,
    getItem,
    storeItem,
    updateItem,
    removeItem,
    checkConnection,
};