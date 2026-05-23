const express = require('express');
const router = express.Router(),
const InvestorController = require('../controllers/investorController');
const { protect } = require('../middleware/authMiddleware');
const { roleMiddleware } = require('../middleware/roleMiddleware');
const { validateInterest, validateBookmark, validateRequest } = require('../utils/validators');

router.use(protect);
router.use(roleMiddleware('investor'));

router.post('/interests', validateInterest, validateRequest, InvestorController.expressInterest);
router.get('/interests', InvestorController.getMyInterests);
router.get('/dashboard-stats', protect, roleMiddleware('investor'), InvestorController.getDashboardStats);

router.post('/bookmarks', validateBookmark, validateRequest, InvestorController.bookmarkStartup);
router.get('/bookmarks', InvestorController.getMyBookmarks);
router.delete('/bookmarks/:id', InvestorController.deleteBookmark);
router.put('/bookmarks/:id/note', validateRequest, InvestorController.updateBookmarkNote);
router.get('/dashboard-stats', protect, roleMiddleware('investor'), InvestorController.getDashboardStats);
router.patch('/bookmarks/:id', protect, roleMiddleware('investor'), InvestorController.updateBookmarkNote);

module.exports = router;