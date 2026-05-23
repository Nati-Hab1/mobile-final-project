const StartupService = require('../services/startupService');
const { pool } = require('../config/db');

const StartupController = {
  // Create startup
  async createStartup(req, res, next) {
    try {
      const startup = await StartupService.createStartup(req.user.id, req.body);
      
      res.status(201).json({
        success: true,
        message: 'Startup created successfully',
        data: { startup }
      });
    } catch (error) {
      next(error);
    }
  },

async getDashboardStats(req, res, next) {
  try {
    const userId = req.user.id;
    
    // Get total intros sent by this startup user (all intros, regardless of status)
    const introsResult = await pool.query(
      `SELECT COUNT(*) as count FROM intros i
       JOIN startups s ON i.startup_id = s.id
       WHERE s.owner_id = $1`,
      [userId]
    );
    
    // Get completed/accepted intros
    const completedResult = await pool.query(
      `SELECT COUNT(*) as count FROM intros i
       JOIN startups s ON i.startup_id = s.id
       WHERE s.owner_id = $1 AND i.status = $2`,
      [userId, 'accepted']
    );
    
    // Get UNIQUE investors who have ACCEPTED the intro (not just sent)
    // This counts each investor only once, even if they accepted multiple intros
    const investorsResult = await pool.query(
      `SELECT COUNT(DISTINCT i.investor_id) as count FROM intros i
       JOIN startups s ON i.startup_id = s.id
       WHERE s.owner_id = $1 AND i.status = $2`,
      [userId, 'accepted']
    );
    
    // Get total startups created by this user
    const startupsResult = await pool.query(
      'SELECT COUNT(*) as count FROM startups WHERE owner_id = $1',
      [userId]
    );
    
    res.status(200).json({
      success: true,
      message: 'Dashboard stats retrieved successfully',
      data: {
        total_intros: parseInt(introsResult.rows[0].count),
        completed_intros: parseInt(completedResult.rows[0].count),
        investors_count: parseInt(investorsResult.rows[0].count),
        startups_count: parseInt(startupsResult.rows[0].count)
      }
    });
  } catch (error) {
    console.error('Error in getDashboardStats:', error);
    next(error);
  }
},
  
  // Get all startups
  async getAllStartups(req, res, next) {
    try {
      const startups = await StartupService.getAllStartups();
      
      res.status(200).json({
        success: true,
        message: 'Startups retrieved successfully',
        data: { startups, count: startups.length }
      });
    } catch (error) {
      next(error);
    }
  },
  
  // Get startup by ID
async getStartupById(req, res, next) {
  try {
    const id = parseInt(req.params.id);
    
    // Add validation
    if (isNaN(id)) {
      return res.status(400).json({
        success: false,
        message: 'Invalid startup ID'
      });
    }
    
    const startup = await StartupService.getStartupById(id);
    
    res.status(200).json({
      success: true,
      message: 'Startup retrieved successfully',
      data: { startup }
    });
  } catch (error) {
    next(error);
  }
},
  
  // Update startup
  async updateStartup(req, res, next) {
    try {
      const startup = await StartupService.updateStartup(
        parseInt(req.params.id),
        req.user.id,
        req.body
      );
      
      res.status(200).json({
        success: true,
        message: 'Startup updated successfully',
        data: { startup }
      });
    } catch (error) {
      next(error);
    }
  },
  
  // Delete startup
  async deleteStartup(req, res, next) {
    try {
      const result = await StartupService.deleteStartup(
        parseInt(req.params.id),
        req.user.id
      );
      
      res.status(200).json({
        success: true,
        message: result.message,
        data: null
      });
    } catch (error) {
      next(error);
    }
  },
  
  // Get startup interests (for owner)
async getStartupInterests(req, res, next) {
  try {
    const interests = await StartupService.getStartupInterests(
      parseInt(req.params.id),
      req.user.id
    );
    
    res.status(200).json({
      success: true,
      message: 'Interests retrieved successfully',
      data: { interests, count: interests.length }
    });
  } catch (error) {
    next(error);
  }
},

async getMyStartups(req, res, next) {
  try {
    const userId = req.user.id;
    const result = await pool.query(
      'SELECT id, title, blurb, pitch_link, created_at, updated_at FROM startups WHERE owner_id = $1 ORDER BY created_at DESC',
      [userId]
    );
    res.status(200).json({
      success: true,
      data: { startups: result.rows, count: result.rows.length },
      message: 'Your startups retrieved successfully'
    });
  } catch (error) {
    next(error);
  }
},

// In backend/src/controllers/startupController.js
async getMyStartups(req, res, next) {
  try {
    const userId = req.user.id;
    const result = await pool.query(
      'SELECT id, title, blurb, pitch_link, created_at, updated_at FROM startups WHERE owner_id = $1 ORDER BY created_at DESC',
      [userId]
    );
    
    res.status(200).json({
      success: true,
      message: 'Your startups retrieved successfully',
      data: { startups: result.rows, count: result.rows.length }
    });
  } catch (error) {
    next(error);
  }
},

async getAcceptedInvestors(req, res, next) {
  try {
    const userId = req.user.id;
    
    const result = await pool.query(
      `SELECT DISTINCT 
        u.id,
        u.full_name as name,
        u.email,
        s.title as startup_title,
        i.created_at
       FROM intros i
       JOIN startups s ON i.startup_id = s.id
       JOIN users u ON i.investor_id = u.id
       WHERE s.owner_id = $1 AND i.status = $2
       ORDER BY i.created_at DESC`,
      [userId, 'accepted']
    );
    
    res.status(200).json({
      success: true,
      message: 'Accepted investors retrieved successfully',
      data: { investors: result.rows, count: result.rows.length }
    });
  } catch (error) {
    console.error('Error in getAcceptedInvestors:', error);
    next(error);
  }
},

async getAllInterests(req, res, next) {
  try {
    const userId = req.user.id;
    
    // Single JOIN query - NO individual getStartupById calls
    const result = await pool.query(
      `SELECT 
        i.id,
        i.investor_id,
        i.message,
        i.status,
        i.created_at,
        u.full_name as investor_name,
        u.email as investor_email,
        s.title as startup_title,
        s.id as startup_id
       FROM interests i
       JOIN startups s ON i.startup_id = s.id
       JOIN users u ON i.investor_id = u.id
       WHERE s.owner_id = $1
       ORDER BY i.created_at DESC`,
      [userId]
    );
    
    res.status(200).json({
      success: true,
      message: 'All interests retrieved successfully',
      data: { interests: result.rows, count: result.rows.length }
    });
  } catch (error) {
    console.error('Error in getAllInterests:', error);
    res.status(500).json({
      success: false,
      message: error.message
    });
  }
},

async getLatestInterests(req, res, next) {
  try {
    const userId = req.user.id;
    
    // Direct query - NO startup ID parameter
    const result = await pool.query(
      `SELECT 
        i.id,
        i.investor_id,
        i.message,
        i.status,
        i.created_at,
        u.full_name as investor_name,
        u.email as investor_email,
        s.title as startup_title
       FROM interests i
       JOIN startups s ON i.startup_id = s.id
       JOIN users u ON i.investor_id = u.id
       WHERE s.owner_id = $1
       ORDER BY i.created_at DESC
       LIMIT 2`,
      [userId]
    );
    
    res.status(200).json({
      success: true,
      message: 'Latest interests retrieved successfully',
      data: { interests: result.rows, count: result.rows.length }
    });
  } catch (error) {
    console.error('Error in getLatestInterests:', error);
    res.status(500).json({
      success: false,
      message: error.message
    });
  }
}
  
};

module.exports = StartupController;