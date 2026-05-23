const { pool } = require('../config/db');

const Bookmark = {
  async create(bookmarkData) {
    const { investor_id, startup_id, note } = bookmarkData;
    
    const existing = await pool.query(
      'SELECT id FROM bookmarks WHERE investor_id = $1 AND startup_id = $2',
      [investor_id, startup_id]
    );
    
    if (existing.rows.length > 0) {
      throw new Error('Startup already bookmarked');
    }
    
    const result = await pool.query(
      `INSERT INTO bookmarks (investor_id, startup_id, note) 
       VALUES ($1, $2, $3) 
       RETURNING *`,
      [investor_id, startup_id, note || null]
    );
    return result.rows[0];
  },

  async findByInvestor(investorId) {
    const result = await pool.query(
      `SELECT b.*, 
              s.title as startup_title,
              s.blurb as startup_blurb,
              s.pitch_link,
              u.full_name as startup_owner_name
       FROM bookmarks b
       JOIN startups s ON b.startup_id = s.id
       JOIN users u ON s.owner_id = u.id
       WHERE b.investor_id = $1
       ORDER BY b.created_at DESC`,
      [investorId]
    );
    return result.rows;
  },

  // Delete bookmark
  async delete(id, investorId) {
    const result = await pool.query(
      'DELETE FROM bookmarks WHERE id = $1 AND investor_id = $2 RETURNING id',
      [id, investorId]
    );
    return result.rows[0];
  },

  // Check if bookmark exists
  async exists(investorId, startupId) {
    const result = await pool.query(
      'SELECT id FROM bookmarks WHERE investor_id = $1 AND startup_id = $2',
      [investorId, startupId]
    );
    return result.rows.length > 0;
  }
};

module.exports = Bookmark;