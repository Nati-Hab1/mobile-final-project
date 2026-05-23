const express = require('express');
const router = express.Router();
const AuthController = require('../controllers/authController');
const { protect } = require('../middleware/authMiddleware');
const { body } = require('express-validator');
const { validateRequest } = require('../utils/validators');

router.post(
  '/add-role',
  protect,
  body('role').isIn(['startup', 'investor']).withMessage('Role must be startup or investor'),
  validateRequest,
  AuthController.addRole
);

router.post(
  '/role-token',
  protect,
  body('role').isIn(['startup', 'investor']).withMessage('Role must be startup or investor'),
  validateRequest,
  AuthController.getRoleToken
);

module.exports = router;