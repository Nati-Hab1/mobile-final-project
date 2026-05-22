const { pool } = require('../config/db');  
const InvestorService = require('../services/investorService');

const InvestorController = {
  // Express interest in startup
  async expressInterest(req, res, next) {
    try {
      const { startup_id, message } = req.body;
      
      const interest = await InvestorService.expressInterest(
        req.user.id,
        startup_id,
        message
      );
      
      res.status(201).json({
        success: true,
        message: 'Interest expressed successfully',
        data: { interest }
      });
    } catch (error) {
      next(error);
    }
  },
  
  // Get my interests
  async getMyInterests(req, res, next) {
    try {
      const interests = await InvestorService.getMyInterests(req.user.id);
      
      res.status(200).json({
        success: true,
        message: 'Interests retrieved successfully',
        data: { interests, count: interests.length }
      });
    } catch (error) {
      next(error);
    }
  },

  async getDashboardStats(req, res, next) {
  try {
    const userId = req.user.id;
    
    // Get total intros received by this investor
    const introsResult = await pool.query(
      'SELECT COUNT(*) as count FROM intros WHERE investor_id = $1',
      [userId]
    );
    
    // Get completed/accepted intros (when you add status column)
    const completedResult = await pool.query(
      'SELECT COUNT(*) as count FROM intros WHERE investor_id = $1', // Add status check later
      [userId]
    );
    
    // Get bookmarked startups count
    const bookmarksResult = await pool.query(
      'SELECT COUNT(*) as count FROM bookmarks WHERE investor_id = $1',
      [userId]
    );
    
    res.status(200).json({
      success: true,
      data: {
        total_intros: parseInt(introsResult.rows[0].count),
        follow_ups: 0, // Can implement later
        startups_count: parseInt(bookmarksResult.rows[0].count),
        completed_intros: parseInt(completedResult.rows[0].count)
      }
    });
  } catch (error) {
    next(error);
  }
},
  
  // Bookmark startup
  async bookmarkStartup(req, res, next) {
    try {
      const { startup_id, note } = req.body;
      
      const bookmark = await InvestorService.bookmarkStartup(
        req.user.id,
        startup_id,
        note
      );
      
      res.status(201).json({
        success: true,
        message: 'Startup bookmarked successfully',
        data: { bookmark }
      });
    } catch (error) {
      next(error);
    }
  },
  
  // Get my bookmarks
  async getMyBookmarks(req, res, next) {
    try {
      const bookmarks = await InvestorService.getMyBookmarks(req.user.id);
      
      res.status(200).json({
        success: true,
        message: 'Bookmarks retrieved successfully',
        data: { bookmarks, count: bookmarks.length }
      });
    } catch (error) {
      next(error);
    }
  },
  
  // Delete bookmark
  async deleteBookmark(req, res, next) {
    try {
      const result = await InvestorService.deleteBookmark(
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

  // Update bookmark note
// Update bookmark note
async updateBookmarkNote(req, res, next) {
  try {
    const bookmarkId = parseInt(req.params.id);
    const { note } = req.body;
    const userId = req.user.id;
    
    // Check if bookmark belongs to this investor
    const checkBookmark = await pool.query(
      'SELECT id FROM bookmarks WHERE id = $1 AND investor_id = $2',
      [bookmarkId, userId]
    );
    
    if (checkBookmark.rows.length === 0) {
      return res.status(404).json({
        success: false,
        message: 'Bookmark not found'
      });
    }
    
    const result = await pool.query(
      'UPDATE bookmarks SET note = $1 WHERE id = $2 RETURNING *',
      [note || null, bookmarkId]
    );
    
    res.status(200).json({
      success: true,
      message: 'Note updated successfully',
      data: { bookmark: result.rows[0] }
    });
  } catch (error) {
    next(error);
  }
},

// Get investor dashboard stats
async getDashboardStats(req, res, next) {
  try {
    const userId = req.user.id;
    
    // Get total intros received by this investor
    const totalIntrosResult = await pool.query(
      'SELECT COUNT(*) as count FROM intros WHERE investor_id = $1',
      [userId]
    );
    
    // Get pending intros (status = 'pending' or NULL)
    const pendingResult = await pool.query(
      'SELECT COUNT(*) as count FROM intros WHERE investor_id = $1 AND (status IS NULL OR status = $2)',
      [userId, 'pending']
    );
    
    // Get accepted/completed intros
    const acceptedResult = await pool.query(
      'SELECT COUNT(*) as count FROM intros WHERE investor_id = $1 AND status = $2',
      [userId, 'accepted']
    );
    
    // Get unique startups that sent intros to this investor
    const startupsResult = await pool.query(
      'SELECT COUNT(DISTINCT startup_id) as count FROM intros WHERE investor_id = $1',
      [userId]
    );
    
    res.status(200).json({
      success: true,
      data: {
        total_intros: parseInt(totalIntrosResult.rows[0].count),
        follow_ups: parseInt(pendingResult.rows[0].count),
        startups_count: parseInt(startupsResult.rows[0].count),
        completed_intros: parseInt(acceptedResult.rows[0].count)
      }
    });
  } catch (error) {
    console.error('Error in getDashboardStats:', error);
    next(error);
  }
}
};

module.exports = InvestorController;