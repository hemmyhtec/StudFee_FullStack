require("dotenv").config;

const Admin = require("../models/Admin");
const nodemailer = require("nodemailer");
const Token = require("../models/Token");
const Payment = require("../models/Payment");
const ProcessPayments = require("../models/ProcessPayment")

const secretCode = process.env.SECRET_CODE;

let transporter = nodemailer.createTransport({
  service: "Gmail",
  auth: {
    user: process.env.EMAIL_ADDRESS,
    pass: process.env.EMAIL_PASS,
  },
});
function renderSuccessPageWithRedirect(req, res, msg, redirectUrl) {
  res.render("success", { msg });
}
function renderErrorPageWithRedirect(req, res, msg, redirectUrl) {
  res.render("error", { msg });
}

const adminController = {
  registerAdmin: async function (req, res) {
    try {
      const { fullname, email, password } = req.body;

      let user = await Admin.findOne({ email });
      if (user) {
        return renderErrorPageWithRedirect(
          req,
          res,
          "You already have an account",
          "admin/register"
        );
      }

      user = new Admin({
        fullname,
        email,
        password,
      });

      user.save().then((user) => {
        try {
          const token = user.generateVerificationToken();
          token.save();

          let link =
            "http://" + req.headers.host + "/verifyAdmin/" + token.token;

          const mailOptions = {
            from: process.env.EMAIL_ADDRESS,
            to: user.email,
            subject: "Account Verification Token",
            html: `<p style="font-size: 25px; font-weight: 500; font-style: italic;">Dear ${user.fullname} 👋</p><p>We are excited to have you join our community 😇! <br> As a member, you now have access to a wide range of features and benefits.</p>
                  <p>To get started, please verify your account using the Link: </p> <p style="font-size: 30px; font-weight: bold;">${link}</p><p>This OTP Code <b> expires in 1hour</b></p> <p>Thank you again for joining Us <br> We look forward to seeing you on the site and hope you have a great experience! </p><p>Best regards</p>`,
          };

          transporter
            .sendMail(mailOptions)
            .then(() => {
              return renderSuccessPageWithRedirect(
                req,
                res,
                `Thanks for registering with us. Please check your Email: ${user.email} for verification link.`,
                "loginAdmin"
              );
            })
            .catch(() => {
              return renderErrorPageWithRedirect(
                req,
                res,
                "Email error.",
                "admin/register"
              );
            });
        } catch (err) {
          return renderErrorPageWithRedirect(
            req,
            res,
            err.message,
            "admin/register"
          );
        }
      });
    } catch (err) {
      return renderErrorPageWithRedirect(
        req,
        res,
        err.message,
        "admin/register"
      );
    }
  },

  verifyAdmin: async function (req, res) {
    if (!req.params.token)
      return res.render("error", { msg: "User not found" });
    try {
      const token = await Token.findOne({ token: req.params.token });
      if (!token) return res.render("error", { msg: "Token not found" });

      Admin.findOne({ _id: token.adminId }, (err, user) => {
        if (!user)
          return res.render("error", { msg: "Dey play! admin not found" });
        if (user.isVerified)
          return res.render("error", { msg: "User already verified" });
        user.isVerified = true;
        user.save();
        res.render("success", { msg: "Successfully verified your account." });
      });
    } catch (err) {
      res.status(500).json({ msg: err.message });
    }
  },

  signInUser: async function (req, res) {
    try {
      const user = await Admin.findOne({ email: req.body.email });
      if (!user) return renderErrorPageWithRedirect(req, res, "User not found");

      await user.comparePassword(req.body.password, function (err, isMatch) {
        if (isMatch & !err) {
          if (!user.isVerified) {
            return renderErrorPageWithRedirect(
                req,
                res,
                "Our play no too much? verify your account abeg"
              );
          } else {
            const token = user.generateJWT();

            res.cookie('token', token, { httpOnly: true });

            res.redirect('admin/dashboard');

          }
        } else {
          return renderErrorPageWithRedirect(
            req,
            res,
            "Dey play! give me correct password abeg"
          );
        }
      });
    } catch (err) {
      return res.render('error', {err: err.message})
    }
  },

  createForm: async function (req, res){
    try {
      const {departmentName, levyName, feeAmount} = req.body

      const levynameExists = await Payment.findOne({levyName})
      if(levynameExists) return renderErrorPageWithRedirect(
        req,
        res,
        'Levy Payment already exists'
      );

      const newPayment = new Payment({
        departmentName,
        levyName,
        feeAmount
      }) 

      newPayment.save().then((result) => {
        renderSuccessPageWithRedirect(req, res, 'Form Successfully created ')
      })
    } catch (err) {
      return renderErrorPageWithRedirect(
        req,
        res,
        err.message
      );
    }
  },

  getAllPaymentList: async function (req, res){
    try {
      Payment.find({}).then((paymentList) => {
        // Generate table rows
        let tableRows = '';
        paymentList.forEach((payment) => {
          tableRows += `
            <tr>
              <td>${payment.departmentName}</td>
              <td>${payment.levyName}</td>
              <td>${payment.feeAmount}</td>
            </tr>
          `;
        });
        // Render the page with the table
        console.log(paymentList)
        res.render('admin/paymentlist', { paymentTable: tableRows });

      })
    } catch (err) {
      return renderErrorPageWithRedirect(
        req,
        res,
        err.message
      );
    }
  },
  getAllPaidUser: async function (req, res){
    try {
      ProcessPayments.find({}).then((userList) => {
        // Generate table rows
        let tableRows = '';
        userList.forEach((paidUsersData) => {
          tableRows += `
            <tr>
              <td>${paidUsersData.userName}</td>
              <td>${paidUsersData.userEmail}</td>
              <td>${paidUsersData.levyName}</td>
              <td>${paidUsersData.feeAmount}</td>
              <td>${paidUsersData.paymentStatus}</td>
              <td>${paidUsersData.referenceId}</td>
            </tr>
          `;
        });
        // Render the page with the table
        res.render('admin/dashboard', { paidUsersTable: tableRows });

      });
    } catch (err) {
      return renderErrorPageWithRedirect(
        req,
        res,
        err.message
      );
    }
  }
  
  
  
  

};

module.exports = adminController;
