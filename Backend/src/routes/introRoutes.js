const express = require('express');
const router = express.Router();
const introController = require('../controllers/introController');
const { protect } = require('../middleware/authMiddleware');
const { roleMiddleware } = require('../middleware/roleMiddleware');

router.use(protect);

// Investor: Get my intros (received)
router.get('/my-intros', roleMiddleware('investor'), introController.getMyIntros);

// Startup: Get intros for a specific startup
router.get('/startup/:startupId', roleMiddleware('startup'), introController.getStartupIntros);

// Startup: Create intro
router.post('/', roleMiddleware('startup'), introController.createIntro);
router.patch('/:id/status', protect, roleMiddleware('investor'), introController.updateIntroStatus);

module.exports = router;