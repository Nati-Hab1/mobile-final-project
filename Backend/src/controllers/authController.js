const { pool } = require('../config/db');
const AuthService = require('../services/authService');
const User = require('../models/userModel');

const AuthController = {
  // Register user (without role)
  async register(req, res, next) {
    try {
      const { full_name, email, password, phone_number } = req.body;
      
      const { user } = await AuthService.register({
        full_name,
        email,
        password,
        phone_number
      });
      
      res.status(201).json({
        success: true,
        message: 'User registered successfully',
        data: { user }
      });
    } catch (error) {
      next(error);
    }
  },
  
  // Add role to existing user
  async addRole(req, res, next) {
    try {
      const { role } = req.body;
      const userId = req.user.id;
      
      const userRole = await AuthService.addRole(userId, role);
      
      res.status(200).json({
        success: true,
        message: `${role} role added successfully. You can now access ${role} features.`,
        data: { 
          role: userRole.role,
          message: `You can now use the ${role} dashboard`
        }
      });
    } catch (error) {
      next(error);
    }
  },
  
  // Login user (no role required)
  async login(req, res, next) {
    try {
      const { email, password } = req.body;
      
      const { user, token, roles } = await AuthService.login(email, password);
      
      res.status(200).json({
        success: true,
        message: 'Login successful',
        data: {
          user,
          token,
          roles // Send roles so frontend knows what dashboards to show
        }
      });
    } catch (error) {
      next(error);
    }
  },
  
  // Get role-specific token (for dashboard access)
  async getRoleToken(req, res, next) {
    try {
      const { role } = req.body;
      const userId = req.user.id;
      
      const { token, role: userRole } = await AuthService.getRoleToken(userId, role);
      
      res.status(200).json({
        success: true,
        message: `Ready to access ${role} dashboard`,
        data: {
          token,
          role: userRole
        }
      });
    } catch (error) {
      next(error);
    }
  },
  
  // Get current user with roles
  async getMe(req, res, next) {
    try {
      const user = await AuthService.getCurrentUser(req.user.id);
      
      res.status(200).json({
        success: true,
        message: 'User retrieved successfully',
        data: { 
          user,
          currentRole: req.user.role || null
        }
      });
    } catch (error) {
      next(error);
    }
  },
  
  // Get user's roles
  async getMyRoles(req, res, next) {
    try {
      const roles = await User.getUserRoles(req.user.id);
      
      res.status(200).json({
        success: true,
        message: 'Roles retrieved successfully',
        data: { roles }
      });
    } catch (error) {
      next(error);
    }
  },
  
  // Logout
  async logout(req, res, next) {
    try {
      const result = await AuthService.logout();
      
      res.status(200).json({
        success: true,
        message: result.message,
        data: null
      });
    } catch (error) {
      next(error);
    }
  },

  async getAllUsers(req, res, next) {
  try {
    const { search } = req.query;
    let query = `
      SELECT u.id, u.full_name, u.email, u.phone_number, 
             COALESCE(array_agg(DISTINCT ur.role) FILTER (WHERE ur.role IS NOT NULL), '{}') as roles
      FROM users u
      LEFT JOIN user_roles ur ON u.id = ur.user_id AND ur.is_active = true
    `;
    const params = [];
    
    if (search && search.trim()) {
      query += ` WHERE u.email ILIKE $1 OR u.full_name ILIKE $1`;
      params.push(`%${search}%`);
    }
    
    query += ` GROUP BY u.id ORDER BY u.created_at DESC`;
    
    const result = await pool.query(query, params);
    
    res.status(200).json({
      success: true,
      message: 'Users retrieved successfully',
      data: { users: result.rows, count: result.rows.length }
    });
  } catch (error) {
    console.error('Error in getAllUsers:', error);
    next(error);
  }
}
};

module.exports = AuthController;