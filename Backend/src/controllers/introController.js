const { pool } = require('../config/db');

const IntroController = {
  // Get intros received by investor
  async getMyIntros(req, res, next) {
    try {
      const userId = req.user.id;
      
      const result = await pool.query(
        `SELECT i.*, 
                s.title as startup_title,
                s.blurb as startup_blurb,
                u.full_name as startup_owner_name,
                u.email as startup_owner_email
         FROM intros i
         JOIN startups s ON i.startup_id = s.id
         JOIN users u ON s.owner_id = u.id
         WHERE i.investor_id = $1
         ORDER BY i.created_at DESC`,
        [userId]
      );
      
      res.status(200).json({
        success: true,
        message: 'Intros retrieved successfully',
        data: { intros: result.rows, count: result.rows.length }
      });
    } catch (error) {
      next(error);
    }
  },
  
  // Get intros sent by startup owner
  async getStartupIntros(req, res, next) {
    try {
      const startupId = parseInt(req.params.startupId);
      const userId = req.user.id;
      
      // Check if user owns the startup
      const checkOwner = await pool.query(
        'SELECT id FROM startups WHERE id = $1 AND owner_id = $2',
        [startupId, userId]
      );
      
      if (checkOwner.rows.length === 0) {
        return res.status(403).json({
          success: false,
          message: 'Not authorized to view intros for this startup'
        });
      }
      
      const result = await pool.query(
        `SELECT i.*, 
                u.full_name as investor_name,
                u.email as investor_email,
                u.phone_number as investor_phone
         FROM intros i
         JOIN users u ON i.investor_id = u.id
         WHERE i.startup_id = $1
         ORDER BY i.created_at DESC`,
        [startupId]
      );
      
      res.status(200).json({
        success: true,
        message: 'Intros retrieved successfully',
        data: { intros: result.rows, count: result.rows.length }
      });
    } catch (error) {
      next(error);
    }
  },
  
  // Create intro
async createIntro(req, res, next) {
  try {
    const { startup_id, investor_id, intro_text } = req.body;
    const userId = req.user.id;
    
    // Check ownership
    const checkOwner = await pool.query(
      'SELECT id FROM startups WHERE id = $1 AND owner_id = $2',
      [startup_id, userId]
    );
    
    if (checkOwner.rows.length === 0) {
      return res.status(403).json({
        success: false,
        message: 'Not authorized'
      });
    }
    
    // Create intro
    const introResult = await pool.query(
      `INSERT INTO intros (startup_id, investor_id, intro_text) 
       VALUES ($1, $2, $3) RETURNING *`,
      [startup_id, investor_id, intro_text]
    );
    
    // Also create or update interest record
    const interestResult = await pool.query(
      `INSERT INTO interests (startup_id, investor_id, message, status) 
       VALUES ($1, $2, $3, 'pending')
       ON CONFLICT (startup_id, investor_id) 
       DO UPDATE SET message = $3, updated_at = CURRENT_TIMESTAMP
       RETURNING *`,
      [startup_id, investor_id, intro_text]
    );
    
    res.status(201).json({
      success: true,
      message: 'Intro sent successfully',
      data: { intro: introResult.rows[0] }
    });
  } catch (error) {
    next(error);
  }
},

  // Update intro status (accept/decline)
async updateIntroStatus(req, res, next) {
  try {
    const introId = parseInt(req.params.id);
    const { status } = req.body;
    const userId = req.user.id;
    
    // Check if the intro belongs to this investor
    const checkIntro = await pool.query(
      'SELECT * FROM intros WHERE id = $1 AND investor_id = $2',
      [introId, userId]
    );
    
    if (checkIntro.rows.length === 0) {
      return res.status(404).json({
        success: false,
        message: 'Intro not found or not authorized'
      });
    }
    
    const intro = checkIntro.rows[0];
    
    // Update intro status
    await pool.query(
      'UPDATE intros SET status = $1, updated_at = CURRENT_TIMESTAMP WHERE id = $2',
      [status, introId]
    );
    
    // ALSO update the corresponding interest record
    // Find the interest for this startup-investor pair
    const interestResult = await pool.query(
      'SELECT id FROM interests WHERE startup_id = $1 AND investor_id = $2',
      [intro.startup_id, userId]
    );
    
    if (interestResult.rows.length > 0) {
      // Update existing interest status
      await pool.query(
        'UPDATE interests SET status = $1, updated_at = CURRENT_TIMESTAMP WHERE id = $2',
        [status, interestResult.rows[0].id]
      );
    } else {
      // Create interest record if it doesn't exist
      await pool.query(
        'INSERT INTO interests (startup_id, investor_id, status, message) VALUES ($1, $2, $3, $4)',
        [intro.startup_id, userId, status, intro.intro_text]
      );
    }
    
    res.status(200).json({
      success: true,
      message: `Intro ${status} successfully`,
      data: { intro: { ...intro, status } }
    });
  } catch (error) {
    console.error('Error in updateIntroStatus:', error);
    next(error);
  }
}
};

module.exports = IntroController;