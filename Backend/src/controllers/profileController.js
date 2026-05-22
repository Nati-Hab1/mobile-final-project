const User = require('../models/userModel');
const { pool } = require('../config/db');
const bcrypt = require('bcrypt');

const ProfileController = {
  // Get profile
  async getProfile(req, res, next) {
    try {
      const user = await User.findById(req.user.id);
      
      if (!user) {
        const error = new Error('User not found');
        error.statusCode = 404;
        throw error;
      }
      
      res.status(200).json({
        success: true,
        message: 'Profile retrieved successfully',
        data: { user }
      });
    } catch (error) {
      next(error);
    }
  },
  
  // Update profile (PATCH - partial updates allowed)
  async updateProfile(req, res, next) {
    try {
      const { full_name, phone_number, email, password } = req.body;
      
      // Get current user data
      const currentUser = await User.findByEmail(req.user.email);
      
      // If updating email, check if it's already taken
      if (email && email !== req.user.email) {
        const existingUser = await User.findByEmail(email);
        if (existingUser && existingUser.id !== req.user.id) {
          const error = new Error('Email already in use by another account');
          error.statusCode = 400;
          throw error;
        }
      }
      
      // Prepare update data (only include fields that are provided)
      const updateData = {};
      if (full_name !== undefined) updateData.full_name = full_name;
      if (phone_number !== undefined) updateData.phone_number = phone_number;
      if (email !== undefined) updateData.email = email;
      
      // Update user profile
      let updatedUser = await User.update(req.user.id, updateData);
      
      // If password is provided in the same request, update it too
      if (password) {
        if (password.length < 6) {
          const error = new Error('Password must be at least 6 characters');
          error.statusCode = 400;
          throw error;
        }
        
        const hashedPassword = await bcrypt.hash(password, 10);
        await pool.query(
          'UPDATE users SET password = $1, updated_at = CURRENT_TIMESTAMP WHERE id = $2',
          [hashedPassword, req.user.id]
        );
        
        // Fetch updated user again to ensure we have latest data
        updatedUser = await User.findById(req.user.id);
      }
      
      res.status(200).json({
        success: true,
        message: password ? 'Profile and password updated successfully' : 'Profile updated successfully',
        data: { user: updatedUser }
      });
    } catch (error) {
      next(error);
    }
  },
  
  // Update password only (simplified - just new password)
  async updatePassword(req, res, next) {
    try {
      const { password } = req.body;
      
      if (!password || password.length < 6) {
        const error = new Error('Password must be at least 6 characters');
        error.statusCode = 400;
        throw error;
      }
      
      // Hash new password
      const hashedPassword = await bcrypt.hash(password, 10);
      
      // Update password
      await pool.query(
        'UPDATE users SET password = $1, updated_at = CURRENT_TIMESTAMP WHERE id = $2',
        [hashedPassword, req.user.id]
      );
      
      res.status(200).json({
        success: true,
        message: 'Password updated successfully',
        data: null
      });
    } catch (error) {
      next(error);
    }
  },
  
  // Delete profile (account deletion)
async deleteProfile(req, res, next) {
  try {
    // Delete user (all related data will be deleted via CASCADE)
    await User.delete(req.user.id);
    
    res.status(200).json({
      success: true,
      message: 'Account deleted successfully. All your data has been removed from our system.',
      data: null
    });
  } catch (error) {
    next(error);
  }
},
  
  // Get profile statistics
  async getProfileStats(req, res, next) {
    try {
      const userId = req.user.id;
      
      // Get user's roles
      const roles = await User.getUserRoles(userId);
      
      let stats = {
        roles,
        startups_count: 0,
        interests_count: 0,
        bookmarks_count: 0
      };
      
      // If user has startup role, get their startups count
      if (roles.includes('startup')) {
        const result = await pool.query(
          'SELECT COUNT(*) as count FROM startups WHERE owner_id = $1',
          [userId]
        );
        stats.startups_count = parseInt(result.rows[0].count);
      }
      
      // If user has investor role, get their interests and bookmarks count
      if (roles.includes('investor')) {
        const interestsResult = await pool.query(
          'SELECT COUNT(*) as count FROM interests WHERE investor_id = $1',
          [userId]
        );
        stats.interests_count = parseInt(interestsResult.rows[0].count);
        
        const bookmarksResult = await pool.query(
          'SELECT COUNT(*) as count FROM bookmarks WHERE investor_id = $1',
          [userId]
        );
        stats.bookmarks_count = parseInt(bookmarksResult.rows[0].count);
      }
      
      res.status(200).json({
        success: true,
        message: 'Profile statistics retrieved successfully',
        data: stats
      });
    } catch (error) {
      next(error);
    }
  }
};

module.exports = ProfileController;