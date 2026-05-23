const { verifyToken } = require('../utils/generateToken');
const { pool } = require('../config/db');

const protect = async (req, res, next) => {
  let token;

  if (req.headers.authorization && req.headers.authorization.startsWith('Bearer')) {
    token = req.headers.authorization.split(' ')[1];
  }

  if (!token) {
    return res.status(401).json({
      success: false,
      message: 'Not authorized to access this route. Please login.'
    });
  }

  try {
    // Verify JWT token
    const decoded = verifyToken(token);
    
    if (!decoded) {
      return res.status(401).json({
        success: false,
        message: 'Invalid or expired token. Please login again.'
      });
    }

    // Get user from database
    const result = await pool.query(
      'SELECT id, full_name, email, phone_number, created_at FROM users WHERE id = $1',
      [decoded.id]
    );

    if (result.rows.length === 0) {
      return res.status(401).json({
        success: false,
        message: 'User not found. Invalid token.'
      });
    }

    req.user = result.rows[0];
    
    // If role is present in token, add it to req.user
    if (decoded.role) {
      req.user.role = decoded.role;
      req.user.activeRole = decoded.role;
    } else {
      req.user.role = null;
      req.user.activeRole = null;
    }
    
    next();
  } catch (error) {
    console.error('Auth middleware error:', error);
    return res.status(401).json({
      success: false,
      message: 'Not authorized to access this route'
    });
  }
};

// Middleware to require a specific role
const requireRole = (requiredRole) => {
  return async (req, res, next) => {
    if (!req.user.role || req.user.role !== requiredRole) {
      return res.status(403).json({
        success: false,
        message: `${requiredRole} role required to access this resource`,
        requiresRole: requiredRole,
        currentRoles: await getCurrentUserRoles(req.user.id)
      });
    }
    next();
  };
};

// Helper function to get user's roles
async function getCurrentUserRoles(userId) {
  const { pool } = require('../config/db');
  const result = await pool.query(
    'SELECT role FROM user_roles WHERE user_id = $1 AND is_active = true',
    [userId]
  );
  return result.rows.map(row => row.role);
}

module.exports = { protect, requireRole };