const { pool } = require('../config/db');

const Startup = {
  async create(startupData) {
    const { owner_id, title, blurb, pitch_link } = startupData;
    const result = await pool.query(
      `INSERT INTO startups (owner_id, title, blurb, pitch_link) 
       VALUES ($1, $2, $3, $4) 
       RETURNING *`,
      [owner_id, title, blurb, pitch_link || null]
    );
    return result.rows[0];
  },

  async findAll(filters = {}) {
    let query = `
      SELECT s.*, 
             u.full_name as owner_name, 
             u.email as owner_email,
             u.phone_number as owner_phone
      FROM startups s
      JOIN users u ON s.owner_id = u.id
    `;
    const values = [];
    let valueCounter = 1;

    if (filters.owner_id) {
      query += ` WHERE s.owner_id = $${valueCounter++}`;
      values.push(filters.owner_id);
    }

    query += ` ORDER BY s.created_at DESC`;

    const result = await pool.query(query, values);
    return result.rows;
  },

  // Get startup by ID
  async findById(id) {
    if (isNaN(id) || id <= 0) {
      return null;
    }

    const result = await pool.query(
      `SELECT s.*, 
            u.full_name as owner_name, 
            u.email as owner_email,
            u.phone_number as owner_phone
     FROM startups s
     JOIN users u ON s.owner_id = u.id
     WHERE s.id = $1`,
      [id]
    );
    return result.rows[0];
  },

  // Update startup
  async update(id, updateData) {
    const { title, blurb, pitch_link } = updateData;
    const updates = [];
    const values = [];
    let valueCounter = 1;

    if (title) {
      updates.push(`title = $${valueCounter++}`);
      values.push(title);
    }
    if (blurb) {
      updates.push(`blurb = $${valueCounter++}`);
      values.push(blurb);
    }
    if (pitch_link !== undefined) {
      updates.push(`pitch_link = $${valueCounter++}`);
      values.push(pitch_link);
    }

    updates.push(`updated_at = CURRENT_TIMESTAMP`);
    values.push(id);

    const result = await pool.query(
      `UPDATE startups SET ${updates.join(', ')} 
       WHERE id = $${valueCounter} 
       RETURNING *`,
      values
    );

    return result.rows[0];
  },

  // delete startup
  async delete(id) {
    const result = await pool.query(
      'DELETE FROM startups WHERE id = $1 RETURNING id',
      [id]
    );
    return result.rows[0];
  },

  // Check if user owns startup
  async isOwner(startupId, userId) {
    const result = await pool.query(
      'SELECT id FROM startups WHERE id = $1 AND owner_id = $2',
      [startupId, userId]
    );
    return result.rows.length > 0;
  }
};

module.exports = Startup;