const express = require('express');
const router = express.Router();
const ProfileController = require('../controllers/profileController');
const { protect } = require('../middleware/authMiddleware');
const { body } = require('express-validator');
const { validateRequest } = require('../utils/validators');

router.use(protect);
router.get('/', ProfileController.getProfile);

router.get('/', ProfileController.getProfileStats);

router.patch(
  '/',
  [
    body('full_name').optional().trim().isLength({ min: 2, max: 100 }).withMessage('Full name must be between 2 and 100 characters'),
    body('phone_number').optional().trim().isLength({ max: 20 }).withMessage('Phone number too long'),
    body('email').optional().trim().isEmail().withMessage('Please provide a valid email'),
    body('password').optional().isLength({ min: 6 }).withMessage('Password must be at least 6 characters')
  ],
  validateRequest,
  ProfileController.updateProfile
);

router.put(
  '/password',
  [
    body('password').isLength({ min: 6 }).withMessage('Password must be at least 6 characters')
  ],
  validateRequest,
  ProfileController.updatePassword
);

router.delete(
    '/',
    ProfileController.deleteProfile
);

module.exports = router;