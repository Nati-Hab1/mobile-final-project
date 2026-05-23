const Interest = require('../models/interestModel');
const Bookmark = require('../models/bookmarkModel');
const Startup = require('../models/startupModel');
const { route } = require('../routes/investorRoutes');


const InvestorService = {

  async expressInterest(investorId, startupId, message) {

    const startup = await Startup.findById(startupId);
    if (!startup) {
      const error = new Error('Startup not found');
      error.statusCode = 404;
      throw error;
    }
    
    if (startup.owner_id === investorId) {
      const error = new Error('You cannot express interest in your own startup');
      error.statusCode = 400;
      throw error;
    }
    
    const interest = await Interest.create({
      investor_id: investorId,
      startup_id: startupId,
      message
    });
    
    return interest;
  },

  async getMyInterests(investorId) {
    const interests = await Interest.findByInvestor(investorId);
    return interests;
  },
  
  async bookmarkStartup(investorId, startupId, note) {
    // Check if startup exists
    const startup = await Startup.findById(startupId);
    if (!startup) {
      const error = new Error('Startup not found');
      error.statusCode = 404;
      throw error;
    }
    
    const bookmark = await Bookmark.create({
      investor_id: investorId,
      startup_id: startupId,
      note
    });
    
    return bookmark;
  },
  
  async getMyBookmarks(investorId) {
    const bookmarks = await Bookmark.findByInvestor(investorId);
    return bookmarks;
  },
  
  async deleteBookmark(bookmarkId, investorId) {
    const bookmark = await Bookmark.delete(bookmarkId, investorId);
    if (!bookmark) {
      const error = new Error('Bookmark not found or not authorized');
      error.statusCode = 404;
      throw error;
    }
    
    return { message: 'Bookmark removed successfully' };
  }

};

module.exports = InvestorService;