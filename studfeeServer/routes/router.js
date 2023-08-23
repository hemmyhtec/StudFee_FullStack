const express = require("express");
const functions = require("../controller/functions");
const router = express.Router();
const auth = require("../middleware/jwt");
const authTwo = require("../middleware/jwt_web");
const validate = require("../middleware/validator");
const validateTwo = require("../middleware/validatorTwo");
const validateThree = require("../middleware/validatorThree");
const validateFour = require("../middleware/validatorFour");
const { check } = require("express-validator");
const adminController = require("../controller/adminController");

router.post("/register", functions.verifyUserAndRegister);

router.get("/verifyUser/:token", functions.verifyUser);

router.post("/userSign", functions.signUserIn);

router.post("/tokenIsValid", functions.tokenIsValid);

router.get("/getUserData", auth, functions.getUserData);

router.put("/updateData", auth, functions.updateProfile);

router.get("/payments", auth, functions.getPayment);

router.post("/paymentsProcess", auth, functions.paymentApi);

router.get("/paymentsHistory", auth, functions.getPaymentHistory);

router.get("/users", auth, functions.getAllUsers);

router.get("/users/:admissionNumber", auth, functions.getUserByAdmission);

router.post("/createChats", auth, functions.createChat);

router.get("/chats/:sender:/receiver", auth, functions.getUserChat);

router.post("/resetPasswordToken", functions.createResetPasswordToken);

router.get("/reset/:token", functions.reset);

router.post(
  "/reset/:token",
  [
    check("password")
      .not()
      .isEmpty()
      .isLength({ min: 9 })
      .withMessage("Must be at least 8 chars long"),
    check("confirmPassword", "Passwords do not match").custom(
      (value, { req }) => value === req.body.password
    ),
  ],
  validateFour,
  functions.resetPassword
);

router.get("/success");
router.get("/error");

router.get("/logout", function (req, res) {
  res.clearCookie("x-auth-token");
  res.status(200).json({ msg: "Sign-out successful" });
});

router.get("/getUserProfileUrl", auth, functions.getUserProfileImage);

// Render Admin Registration Form
router.get("/register-admin", (req, res) => {
  res.render("admin/register");
});

//Admin Routes
router.post(
  "/register-admin",
  [
    check("fullname", "Name is required").not().isEmpty(),
    check("email", "Please include a valid email").isEmail(),
    check(
      "password",
      "Please enter a password with 8 or more characters"
    ).isLength({ min: 8 }),
    check("confirmPassword", "Passwords do not match").custom(
      (value, { req }) => value === req.body.password
    ),
  ],
  validate,
  adminController.registerAdmin
);

// Render Admin Registration Form
router.get("/signin", (req, res) => {
  res.render("admin/signin");
});

//Admin Routes
router.post(
  "/signin",
  [
    check("email", "Please include a valid email")
      .isEmail()
      .withMessage("Invalid email"),
    check(
      "password",
      "Please enter a password with 8 or more characters"
    ).isLength({ min: 8 }),
  ],
  validateTwo,
  adminController.signInUser
);

router.get('/admin/dashboard', authTwo, adminController.getAllPaidUser, (req, res) => {
  res.render('admin/dashboard');
});

router.get('/admin/paymentlist', authTwo, adminController.getAllPaymentList, (req, res) => {
  res.render('admin/paymentlist');
});


// router.get(
//   "/admin/dashboard",
//   authTwo,
//   function (req, res, next) {
//     // Create an array of promises for the two methods
//     const promises = [
//       adminController.getAllPaidUser(req, res, next),
//       adminController.getAllPaymentList(req, res, next),
//     ];

//     // Wait for both promises to resolve before calling next()
//     Promise.all(promises)
//       .then(() => {
//         next();
//       })
//       .catch((err) => {
//         next(err);
//       });
//   },
//   function (req, res) {
//     // Render the page after both methods have finished
//     res.render("admin/dashboard");
//   }
// );

router.post("/logout", (req, res) => {
  res.clearCookie("token");
  res.render("admin/signin");
});

//Admin Routes
router.get("/create-form", (req, res)=>{
  res.render("admin/create-form");
})

router.post(
  "/create-form",
  [
    check("departmentName", "Department name required").not().isEmpty(),
    check("levyName", "Levy name required").not().isEmpty(),
    check("feeAmount", "Fee amount required").not().isEmpty(),
  ],
  validateThree,
  authTwo,
  adminController.createForm
);

router.get("/verifyAdmin/:token", adminController.verifyAdmin);

module.exports = router;
