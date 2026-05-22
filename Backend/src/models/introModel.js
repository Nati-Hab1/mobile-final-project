const { pool } = require('../config/db');

const Intro = {
  // Create intro
  async create(introData) {
    const { startup_id, investor_id, intro_text } = introData;

    const result = await pool.query(
      `INSERT INTO intros (startup_id, investor_id, intro_text) 
       VALUES ($1, $2, $3) 
       RETURNING *`,
      [startup_id, investor_id, intro_text]
    );
    return result.rows[0];
  },

  // Get intros by startup
  async findByStartup(startupId) {
    const result = await pool.query(
      `SELECT i.*, 
              u.full_name as investor_name,
              u.email as investor_email
       FROM intros i
       JOIN users u ON i.investor_id = u.id
       WHERE i.startup_id = $1
       ORDER BY i.created_at DESC`,
      [startupId]
    );
    return result.rows;
  },

  // Get intros by investor
  async findByInvestor(investorId) {
    const result = await pool.query(
      `SELECT i.*, 
              s.title as startup_title,
              u.full_name as startup_owner_name
       FROM intros i
       JOIN startups s ON i.startup_id = s.id
       JOIN users u ON s.owner_id = u.id
       WHERE i.investor_id = $1
       ORDER BY i.created_at DESC`,
      [investorId]
    );
    return result.rows;
  }
};

module.exports = Intro;