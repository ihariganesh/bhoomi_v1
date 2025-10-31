const express = require('express');
const router = express.Router();
const auth = require('../middleware/auth');

// Auth routes
router.post('/register', auth.register);
router.post('/login', auth.login);
router.post('/refresh', auth.refreshToken);
router.post('/logout', auth.protect, auth.logout);
router.get('/me', auth.protect, auth.getMe);

module.exports = router;
