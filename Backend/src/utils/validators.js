const { body, validationResult } = require("express-validator");

const phoneValidator = body("phone_number")
  .optional({ checkFalsy: true })
  .trim()
  .matches(/^(\+251|0)?9\d{8}$/)
  .withMessage(
    "Phone number must be valid (Example: 0911223344 or +251911223344)",
  );

const validateRegister = [
  body("full_name")
    .trim()
    .notEmpty()
    .withMessage("Full name is required")
    .isLength({ min: 2, max: 100 })
    .withMessage("Full name must be between 2 and 100 characters"),
  body("email")
    .trim()
    .notEmpty()
    .withMessage("Email is required")
    .isEmail()
    .withMessage("Please provide a valid email")
    .normalizeEmail(),
  body("password")
    .notEmpty()
    .withMessage("Password is required")
    .isLength({ min: 6 })
    .withMessage("Password must be at least 6 characters"),
  body("phone_number")
    .optional({ checkFalsy: true })
    .trim()
    .isLength({ max: 20 })
    .withMessage("Phone number cannot exceed 20 characters")
    .custom((value) => {
      if (value && value.length > 0) {
        const phoneRegex = /^[0-9+\-\s()]+$/;
        if (!phoneRegex.test(value)) {
          throw new Error(
            "Phone number can only contain numbers, spaces, +, -, (, )",
          );
        }
      }
      return true;
    }),
];

const validateLogin = [
  body("email")
    .trim()
    .notEmpty()
    .withMessage("Email is required")
    .isEmail()
    .withMessage("Please provide a valid email"),
  body("password").notEmpty().withMessage("Password is required"),
];

const validateStartup = [
  body("title")
    .trim()
    .notEmpty()
    .withMessage("Startup title is required")
    .isLength({ min: 3, max: 200 })
    .withMessage("Title must be between 3 and 200 characters"),

  body("blurb")
    .trim()
    .notEmpty()
    .withMessage("Blurb is required")
    .isLength({ min: 10, max: 500 })
    .withMessage("Blurb must be between 10 and 500 characters"),

  body("pitch_link")
    .optional({ checkFalsy: true })
    .trim()
    .isURL()
    .withMessage("Please provide a valid URL"),
];

const validateProfileUpdate = [
  body("full_name")
    .optional({ checkFalsy: true })
    .trim()
    .isLength({ min: 2, max: 100 })
    .withMessage("Full name must be between 2 and 100 characters"),

  phoneValidator,

  body("email")
    .optional({ checkFalsy: true })
    .trim()
    .isEmail()
    .withMessage("Please provide a valid email")
    .normalizeEmail(),
];

const validateInterest = [
  body("startup_id")
    .notEmpty()
    .withMessage("Startup ID is required")
    .isInt({ min: 1 })
    .withMessage("Startup ID must be a valid integer"),

  body("message")
    .optional({ checkFalsy: true })
    .trim()
    .isLength({ max: 500 })
    .withMessage("Message cannot exceed 500 characters"),
];

const validateBookmark = [
  body("startup_id")
    .notEmpty()
    .withMessage("Startup ID is required")
    .isInt({ min: 1 })
    .withMessage("Startup ID must be a valid integer"),

  body("note")
    .optional({ checkFalsy: true })
    .trim()
    .isLength({ max: 500 })
    .withMessage("Note cannot exceed 500 characters"),
];

const validateIntro = [
  body("startup_id")
    .notEmpty()
    .withMessage("Startup ID is required")
    .isInt({ min: 1 })
    .withMessage("Startup ID must be a valid integer"),

  body("intro_text")
    .trim()
    .notEmpty()
    .withMessage("Intro text is required")
    .isLength({ min: 10, max: 1000 })
    .withMessage("Intro text must be between 10 and 1000 characters"),
];

const validatePasswordUpdate = [
  body("current_password")
    .notEmpty()
    .withMessage("Current password is required"),
  body("new_password")
    .notEmpty()
    .withMessage("New password is required")
    .isLength({ min: 6 })
    .withMessage("New password must be at least 6 characters"),
];

// Account deletion validation
const validateAccountDeletion = [
  body("password_confirmation")
    .notEmpty()
    .withMessage("Password confirmation is required"),
];

const validateRequest = (req, res, next) => {
  const errors = validationResult(req);

  if (!errors.isEmpty()) {
    return res.status(400).json({
      success: false,
      message: "Validation error",
      errors: errors.array().map((err) => ({
        field: err.path,
        message: err.msg,
      })),
    });
  }

  next();
};

module.exports = {
  validateRegister,
  validateLogin,
  validateStartup,
  validateProfileUpdate,
  validateInterest,
  validateBookmark,
  validateIntro,
  validatePasswordUpdate,
  validateRequest,
};
