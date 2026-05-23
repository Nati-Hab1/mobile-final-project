const { pool } = require('../config/db');

// Middleware to check if user has any of the allowed roles
const roleMiddleware = (...allowedRoles) => {
  return async (req, res, next) => {
    if (!req.user) {
      return res.status(401).json({
        success: false,
        message: 'Not authenticated'
      });
    }

    // Get user's roles from database
    const result = await pool.query(
      'SELECT role FROM user_roles WHERE user_id = $1 AND is_active = true',
      [req.user.id]
    );
    
    const userRoles = result.rows.map(row => row.role);
    
    // Check if user has ANY of the allowed roles
    const hasAllowedRole = allowedRoles.some(role => userRoles.includes(role));
    
    if (!hasAllowedRole) {
      return res.status(403).json({
        success: false,
        message: `Access denied. Required roles: ${allowedRoles.join(' or ')}`,
        requiredRoles: allowedRoles,
        currentRoles: userRoles
      });
    }
    
    // If user has role but not active in token, we can still proceed
    // The actual role check will happen in the specific endpoints
    next();
  };
};

module.exports = { roleMiddleware };