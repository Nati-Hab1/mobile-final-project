const express = require('express');
const router = express.Router();
const AuthController = require('../controllers/authController');
const { protect } = require('../middleware/authMiddleware');
const { validateRegister, validateLogin, validateRequest } = require('../utils/validators');

router.post('/register', validateRegister, validateRequest, AuthController.register);
router.post('/login', validateLogin, validateRequest, AuthController.login);
router.get('/me', protect, AuthController.getMe);
router.get('/my-roles', protect, AuthController.getMyRoles);
router.post('/logout', protect, AuthController.logout);
router.get('/users/all', protect, AuthController.getAllUsers);


module.exports = router;