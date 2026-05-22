const { Pool } = require('pg');
const { 
  DB_HOST, 
  DB_PORT, 
  DB_NAME, 
  DB_USER, 
  DB_PASSWORD 
} = require('./env');

const pool = new Pool({
  host: DB_HOST,
  port: DB_PORT,
  database: DB_NAME,
  user: DB_USER,
  password: DB_PASSWORD,
  max: 20, // Maximum number of clients in the pool
  idleTimeoutMillis: 30000,
  connectionTimeoutMillis: 2000,
});

// Test database connection
const testConnection = async () => {
  try {
    const client = await pool.connect();
    console.log('✅ PostgreSQL connected successfully');
    client.release();
    return true;
  } catch (error) {
    console.error('❌ PostgreSQL connection error:', error.message);
    return false;
  }
};

// Initialize database tables
const initDatabase = async () => {
  const client = await pool.connect();
  try {
    await client.query(`
      CREATE TABLE IF NOT EXISTS users (
        id SERIAL PRIMARY KEY,
        full_name TEXT NOT NULL,
        email TEXT UNIQUE NOT NULL,
        password TEXT NOT NULL,
        role TEXT NOT NULL CHECK(role IN ('startup', 'investor')),
        phone_number TEXT,
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
      );

      CREATE TABLE IF NOT EXISTS startups (
        id SERIAL PRIMARY KEY,
        owner_id INTEGER NOT NULL,
        title TEXT NOT NULL,
        blurb TEXT NOT NULL,
        pitch_link TEXT,
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        FOREIGN KEY(owner_id) REFERENCES users(id) ON DELETE CASCADE
      );

      CREATE TABLE IF NOT EXISTS interests (
        id SERIAL PRIMARY KEY,
        startup_id INTEGER NOT NULL,
        investor_id INTEGER NOT NULL,
        message TEXT,
        status TEXT DEFAULT 'pending',
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        FOREIGN KEY(startup_id) REFERENCES startups(id) ON DELETE CASCADE,
        FOREIGN KEY(investor_id) REFERENCES users(id) ON DELETE CASCADE,
        UNIQUE(startup_id, investor_id)
      );

      CREATE TABLE IF NOT EXISTS bookmarks (
        id SERIAL PRIMARY KEY,
        investor_id INTEGER NOT NULL,
        startup_id INTEGER NOT NULL,
        note TEXT,
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        FOREIGN KEY(investor_id) REFERENCES users(id) ON DELETE CASCADE,
        FOREIGN KEY(startup_id) REFERENCES startups(id) ON DELETE CASCADE,
        UNIQUE(investor_id, startup_id)
      );

      CREATE TABLE IF NOT EXISTS intros (
        id SERIAL PRIMARY KEY,
        startup_id INTEGER NOT NULL,
        investor_id INTEGER NOT NULL,
        intro_text TEXT NOT NULL,
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        FOREIGN KEY(startup_id) REFERENCES startups(id) ON DELETE CASCADE,
        FOREIGN KEY(investor_id) REFERENCES users(id) ON DELETE CASCADE
      );
    `);
    console.log('✅ Database tables initialized');
  } catch (error) {
    console.error('❌ Database initialization error:', error.message);
    throw error;
  } finally {
    client.release();
  }
};

module.exports = { pool, testConnection, initDatabase };