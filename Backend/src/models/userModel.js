const { pool } = require('../config/db');
const bcrypt = require('bcrypt');

const User = {
  // Create new user (without role)
  async create(userData) {
    const { full_name, email, password, phone_number } = userData;
    const hashedPassword = await bcrypt.hash(password, 10);

    const result = await pool.query(
      `INSERT INTO users (full_name, email, password, phone_number) 
       VALUES ($1, $2, $3, $4) 
       RETURNING id, full_name, email, phone_number, created_at`,
      [full_name, email, hashedPassword, phone_number || null]
    );

    return result.rows[0];
  },

  async addRole(userId, role) {
    const result = await pool.query(
      `INSERT INTO user_roles (user_id, role) 
       VALUES ($1, $2) 
       ON CONFLICT (user_id, role) DO UPDATE SET is_active = true
       RETURNING *`,
      [userId, role]
    );
    return result.rows[0];
  },

  async getUserRoles(userId) {
    const result = await pool.query(
      'SELECT role FROM user_roles WHERE user_id = $1 AND is_active = true',
      [userId]
    );
    return result.rows.map(row => row.role);
  },

  async hasRole(userId, role) {
    const result = await pool.query(
      'SELECT id FROM user_roles WHERE user_id = $1 AND role = $2 AND is_active = true',
      [userId, role]
    );
    return result.rows.length > 0;
  },

  async findByEmail(email) {
    const result = await pool.query(
      'SELECT * FROM users WHERE email = $1',
      [email]
    );
    return result.rows[0];
  },

  // Find user by ID with roles
  async findById(id) {
    const result = await pool.query(
      'SELECT id, full_name, email, phone_number, created_at FROM users WHERE id = $1',
      [id]
    );

    if (result.rows.length === 0) return null;

    const user = result.rows[0];
    user.roles = await this.getUserRoles(id);

    return user;
  },

  // Update user profile
  async update(id, updateData) {
    const { full_name, phone_number, email } = updateData;
    const updates = [];
    const values = [];
    let valueCounter = 1;

    if (full_name) {
      updates.push(`full_name = $${valueCounter++}`);
      values.push(full_name);
    }
    if (phone_number !== undefined) {
      updates.push(`phone_number = $${valueCounter++}`);
      values.push(phone_number);
    }
    if (email) {
      updates.push(`email = $${valueCounter++}`);
      values.push(email);
    }

    updates.push(`updated_at = CURRENT_TIMESTAMP`);
    values.push(id);

    const result = await pool.query(
      `UPDATE users SET ${updates.join(', ')} 
       WHERE id = $${valueCounter} 
       RETURNING id, full_name, email, phone_number, created_at`,
      values
    );

    return result.rows[0];
  },

  // Delete user and all related data
  async delete(id) {
    const result = await pool.query(
      'DELETE FROM users WHERE id = $1 RETURNING id',
      [id]
    );
    return result.rows[0];
  },

  async verifyPassword(plainPassword, hashedPassword) {
    return await bcrypt.compare(plainPassword, hashedPassword);
  },

  async removeRole(userId, role) {
    const result = await pool.query(
      'UPDATE user_roles SET is_active = false WHERE user_id = $1 AND role = $2 RETURNING *',
      [userId, role]
    );
    return result.rows[0];
  },

  async updatePassword(userId, newHashedPassword) {
    const result = await pool.query(
      'UPDATE users SET password = $1, updated_at = CURRENT_TIMESTAMP WHERE id = $2 RETURNING id',
      [newHashedPassword, userId]
    );
    return result.rows[0];
  },
};

module.exports = User;