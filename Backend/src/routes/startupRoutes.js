const express = require('express');
const router = express.Router();
const { protect } = require('../middleware/authMiddleware');
const { roleMiddleware } = require('../middleware/roleMiddleware');
const startupController = require('../controllers/startupController');


router.get('/dashboard-stats', protect, roleMiddleware('startup'), startupController.getDashboardStats);
router.get('/my-startups', protect, roleMiddleware('startup'), startupController.getMyStartups);
router.get('/accepted-investors', protect, roleMiddleware('startup'), startupController.getAcceptedInvestors);
router.get('/all-interests', protect, roleMiddleware('startup'), startupController.getAllInterests);
router.get('/latest-interests', protect, roleMiddleware('startup'), startupController.getLatestInterests);

router.get('/', startupController.getAllStartups);
router.get('/:id', startupController.getStartupById);
router.post('/', protect, roleMiddleware('startup'), startupController.createStartup);
router.put('/:id', protect, roleMiddleware('startup'), startupController.updateStartup);
router.delete('/:id', protect, roleMiddleware('startup'), startupController.deleteStartup);
router.get('/:id/interests', protect, roleMiddleware('startup'), startupController.getStartupInterests);

module.exports = router;