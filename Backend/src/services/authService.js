const User = require('../models/userModel');
const { generateToken } = require('../utils/generateToken');

const AuthService = {
  async register(userData) {
    const { email } = userData;
    
    const existingUser = await User.findByEmail(email);
    if (existingUser) {
      const error = new Error('User already exists with this email');
      error.statusCode = 400;
      throw error;
    }
    const user = await User.create(userData);
    
    return { user };
  },
  
  async addRole(userId, role) {
    
    const hasRole = await User.hasRole(userId, role);
    if (hasRole) {
      const error = new Error(`You already have ${role} role`);
      error.statusCode = 400;
      throw error;
    }
    
    const userRole = await User.addRole(userId, role);
    return userRole;
  },

  async login(email, password) {
    // Find user
    const user = await User.findByEmail(email);
    if (!user) {
      const error = new Error('Invalid credentials');
      error.statusCode = 401;
      throw error;
    }
    
    const isPasswordValid = await User.verifyPassword(password, user.password);
    if (!isPasswordValid) {
      const error = new Error('Invalid credentials');
      error.statusCode = 401;
      throw error;
    }
    
    const userRoles = await User.getUserRoles(user.id);
    
    const token = generateToken(user.id, user.email, null);
    
    const { password: _, ...userWithoutPassword } = user;
    
    return { 
      user: userWithoutPassword, 
      token,
      roles: userRoles
    };
  },
  
  // Get current user with roles
  async getCurrentUser(userId) {
    const user = await User.findById(userId);
    if (!user) {
      const error = new Error('User not found');
      error.statusCode = 404;
      throw error;
    }
    
    return user;
  },
  
  async getRoleToken(userId, role) {
    const user = await User.findById(userId);
    if (!user) {
      const error = new Error('User not found');
      error.statusCode = 404;
      throw error;
    }
    

    const hasRole = await User.hasRole(userId, role);
    if (!hasRole) {
      const error = new Error(`You don't have ${role} role. Please add this role first.`);
      error.statusCode = 403;
      throw error;
    }
    
    // Generate role-specific token
    const token = generateToken(user.id, user.email, role);
    
    return { token, role };
  },
  
  // Logout
  async logout() {
    return { message: 'Logged out successfully' };
  }
};

module.exports = AuthService;