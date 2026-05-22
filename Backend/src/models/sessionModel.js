const { pool } = require('../config/db');

const Session = {
  async createSession(userId, token, activeRole, expiresIn = '7d') {
    const expiresAt = new Date();
    expiresAt.setDate(expiresAt.getDate() + 7);

    const result = await pool.query(
      `INSERT INTO user_sessions (user_id, token, active_role, expires_at) 
       VALUES ($1, $2, $3, $4) 
       RETURNING *`,
      [userId, token, activeRole, expiresAt]
    );
    return result.rows[0];
  },

  async getSessionByToken(token) {
    const result = await pool.query(
      `SELECT s.*, u.full_name, u.email 
       FROM user_sessions s
       JOIN users u ON s.user_id = u.id
       WHERE s.token = $1 AND s.expires_at > NOW()`,
      [token]
    );
    return result.rows[0];
  },

  async updateActiveRole(token, newRole) {
    const result = await pool.query(
      `UPDATE user_sessions 
       SET active_role = $2, updated_at = CURRENT_TIMESTAMP 
       WHERE token = $1 
       RETURNING *`,
      [token, newRole]
    );
    return result.rows[0];
  },

  // Remove a session (logout)
  async invalidateSession(token) {
    const result = await pool.query(
      'DELETE FROM user_sessions WHERE token = $1 RETURNING id',
      [token]
    );
    return result.rows[0];
  },

  // Remove all sessions for a user (logout from all devices)
  async invalidateAllUserSessions(userId) {
    const result = await pool.query(
      'DELETE FROM user_sessions WHERE user_id = $1 RETURNING id',
      [userId]
    );
    return result.rows;
  }
};

module.exports = Session;