const { pool } = require('../config/db');

const Interest = {
  async create(interestData) {
    const { startup_id, investor_id, message } = interestData;
   
    const existing = await pool.query(
      'SELECT id FROM interests WHERE startup_id = $1 AND investor_id = $2',
      [startup_id, investor_id]
    );
    
    if (existing.rows.length > 0) {
      throw new Error('Interest already expressed for this startup');
    }
    
    const result = await pool.query(
      `INSERT INTO interests (startup_id, investor_id, message, status) 
       VALUES ($1, $2, $3, 'pending') 
       RETURNING *`,
      [startup_id, investor_id, message || null]
    );
    return result.rows[0];
  },

  async findByInvestor(investorId) {
    const result = await pool.query(
      `SELECT i.*, 
              s.title as startup_title,
              s.blurb as startup_blurb,
              u.full_name as startup_owner_name
       FROM interests i
       JOIN startups s ON i.startup_id = s.id
       JOIN users u ON s.owner_id = u.id
       WHERE i.investor_id = $1
       ORDER BY i.created_at DESC`,
      [investorId]
    );
    return result.rows;
  },

  async findByStartup(startupId) {
    const result = await pool.query(
      `SELECT i.*, 
              u.full_name as investor_name,
              u.email as investor_email,
              u.phone_number as investor_phone
       FROM interests i
       JOIN users u ON i.investor_id = u.id
       WHERE i.startup_id = $1
       ORDER BY i.created_at DESC`,
      [startupId]
    );
    return result.rows;
  },

  async updateStatus(id, status) {
    const result = await pool.query(
      `UPDATE interests 
       SET status = $1, updated_at = CURRENT_TIMESTAMP 
       WHERE id = $2 
       RETURNING *`,
      [status, id]
    );
    return result.rows[0];
  }
};

module.exports = Interest;