require("dotenv").config;

const User = require("../models/User");
const Token = require("../models/Token");
const StudentInfo = require("../models/StudentInfos");
const Payments = require("../models/Payment");
const nodemailer = require("nodemailer");
const jwt = require("jsonwebtoken");
const ProcessPayment = require("../models/ProcessPayment");
const Message = require("../models/Message");

const secretCode = process.env.SECRET_CODE;

let transporter = nodemailer.createTransport({
  service: "Gmail",
  auth: {
    user: process.env.EMAIL_ADDRESS,
    pass: process.env.EMAIL_PASS,
  },
});

function renderErrorPageWithRedirect(req, res, msg, redirectUrl) {
  res.render("error", { msg });
}
const functions = {
  verifyUserAndRegister: async function (req, res) {
    try {
      const { admissionNumber, password, gender, ugLevel, email } = req.body;

      const userData = await StudentInfo.findOne({ admissionNumber });
      if (!userData)
        return res
          .status(500)
          .json({ msg: "Dey play !!! Incorrect Admission No!" });
      let user = new User({
        fullname: userData.name,
        admissionNumber: userData.admissionNumber,
        department: userData.department,
        yearOfAdmin: userData.yearOfAdmin,
        password,
        gender,
        ugLevel,
        email,
      });
      user
        .save()
        .then((user) => {
          try {
            const token = user.generateVerificationToken();
            token.save();

            let link =
              "http://" + req.headers.host + "/verifyUser/" + token.token;

            const mailOptions = {
              from: process.env.EMAIL_ADDRESS,
              to: user.email,
              subject: "Account Veritification Token",
              html: `<p> <h1>Hi  <b> ${user.email},</b></h1><p><br><p>Please click on the following <a href="${link}">link</a> to verify your account.</p> 
                                      <br><p>If you did not request this, please ignore this email.</p>`,
            };

            transporter
              .sendMail(mailOptions)
              .then(() => {
                res.status(200).json({
                  msg: `Thanks for registering with us. Please check your Email: ${user.email} for verification link.`,
                });
              })
              .catch(() => {
                res.status(500).json({ msg: "Email error" });
              });
          } catch (err) {
            return res.status(500).json({ msg: err.message });
          }
        })
        .catch((error) => {
          if (error.code === 11000) {
            return res
              .status(500)
              .json({ msg: "Na wa ooo! abeg go sign-in instead" });
          } else {
            throw error;
          }
        });
    } catch (err) {
      return res.status(500).json({ msg: err.message });
    }
  },

  verifyUser: async function (req, res) {
    if (!req.params.token)
    return res.render('error', { msg: 'Dey play! User not found' });
    try {
      const token = await Token.findOne({ token: req.params.token });
      if (!token) return res.render('error', { msg: 'Token not found' });

      User.findOne({ _id: token.userId }, (err, user) => {
        if (!user) return res.render('error', { msg: 'Dey play! User not found' });
        if (user.isVerified) return res.render('error', { msg: 'User already verified' });
        user.isVerified = true;
        user.save();
        res.render('success', {msg: 'Successfully verified your account'})
      });
    } catch (err) {
      res.status(500).json({ msg: err.message });
    }
  },

  signUserIn: async function (req, res) {
    try {
      const user = await User.findOne({
        admissionNumber: req.body.admissionNumber,
      });
      if (!user)
        return res.status(400).json({
          msg: "No be juju be that! \nIncorrect admission please SignUp",
        });
      await user.comparePassword(req.body.password, function (err, isMatch) {
        if (isMatch & !err) {
          if (!user.isVerified) {
            return res
              .status(400)
              .json({ msg: "Our play no too much? verify your account abeg" });
          } else {
            res.status(200).json({
              token: user.generateJWT(),
              ...user._doc,
              msg: "Login In Successful",
            });
          }
        } else {
          res
            .status(400)
            .json({ msg: "Dey play! give me correct password abeg" });
        }
      });
    } catch (err) {
      res.status(500).json({ msg: err.message });
    }
  },

  tokenIsValid: async function (req, res) {
    try {
      const token = req.header("x-auth-token");
      if (!token) return res.json(false);
      const verified = jwt.verify(token, secretCode);
      if (!verified) return res.json(false);

      const user = await User.findById(verified.id);
      if (!user) return res.json(false);

      res.json(true);
    } catch (error) {
      res.status(500).json({ error: error.message });
    }
  },
  getUserData: async function (req, res) {
    try {
      const user = await User.findById(req.user);

      res.json({ ...user._doc, token: req.token });
    } catch (err) {
      res.status(500).json({ msg: err.message });
    }
  },

  updateProfile: async function (req, res) {
    try {
      const user = await User.findById(req.user);
      if (!user) return res.status(400).json({ msg: "User not found" });

      const userDataToBeUpdated = req.body;
      let userId = user._id;
      if (userDataToBeUpdated !== null) {
        const updateUserData = await User.findByIdAndUpdate(
          userId,
          { $set: userDataToBeUpdated },
          { new: true }
        );
        res
          .status(200)
          .json({ ...updateUserData._doc, msg: "Uploaded Successfuly" });
      } else {
        return res.status(400).json({ msg: "Data not updated" });
      }
    } catch (err) {
      res.status(500).json({ msg: err.message });
    }
  },

  getPayment: async function (req, res) {
    try {
      const user = await User.findById(req.user);
      if (!user) return res.status(400).json({ msg: "User not found" });

      const deptName = user.department;

      let query = Payments.find({ departmentName: deptName });

      query.exec(function (err, department) {
        if (err) throw err;
        if (department) return res.status(200).json({ department });
      });
    } catch (err) {
      res.status(500).json({ msg: err.message });
    }
  },
  paymentApi: async function (req, res) {
    const user = await User.findById(req.user);
    if (!user) return res.status(400).json({ msg: "User not found" });

    const userId = user._id;
    const department = user.department;
    const fullName = user.fullname;
    const email = user.email;
    const levyName = req.body.levyName;
    const feeAmount = req.body.feeAmount;
    const referenceId = req.body.referenceId;
    const paymentStatus = req.body.paymentStatus;

    if (paymentStatus === "Success") {
      const paymentData = new ProcessPayment({
        userId: userId,
        userName: fullName,
        userEmail: email,
        departmentName: department,
        levyName: levyName,
        paymentStatus: paymentStatus,
        feeAmount: feeAmount,
        referenceId: referenceId,
      });
      paymentData
        .save()
        .then((response) => {
          res.status(200).json({ msg: "Payment Successful" });
        })
        .catch((err) => {
          res.status(500).json({ msg: "Error", err: err.message });
        });
    }
  },

  getPaymentHistory: async function (req, res) {
    const user = await User.findById(req.user);
    if (!user) return res.status(400).json({ msg: "User not found" });

    const userId = user._id;

    let query = ProcessPayment.find({ userId: userId });
    query.exec(function (err, data) {
      if (err) throw err;
      if (data) return res.status(200).json({ data });
    });
  },

  getAllUsers: async function (req, res) {
    const user = await User.findById(req.user);
    if (!user) return res.status(400).json({ msg: "User not found" });

    User.find({}).select('-password').exec((err, users) => {
      if (err) {
        res.status(401).json({ msg: "Error retrieving users" });
      } else {
        res.json(users);
      }
    });
  },

  getUserByAdmission: async function (req, res) {
    const user = await User.findById(req.user);
    if (!user) return res.status(400).json({ msg: "User not found" });

    try {
      const getUser = await User.findOne({
        admissionNumber: req.params.admissionNumber,
      }).select('-password');
      if (getUser) return res.status(200).json(getUser);
      if (!getUser) return res.status(404).json("User not list not found");
      //Todo 
      //If user is not found, create a invite link to send to user email
    } catch (err) {
      res.status(500).json({ msg: "Error", err: err.message });
    }
  },

  createChat: async function (req, res) {
    const user = await User.findById(req.user);
    if (!user) return res.status(400).json({ msg: "User not found" });

    try {
      const data = {
        sender: req.body.sender,
        receiver: req.body.receiver,
        message: req.body.message,
        media: req.body.media,
      };
      const message = new Message(data);
      await message.save();
      res.status(201).json(message);
    } catch (err) {
      res.status(401).json({ msg: "Error while creating chat" });
    }
  },

  getUserChat: async function (req, res) {
    const user = await User.findById(req.user);
    if (!user) return res.status(401).json({ msg: "User not found" });

    try {
      const message = await Message.find({
        $or: [
          {sender: req.params.sender, receiver: req.params.receiver},
          {sender: req.params.receiver, receiver: req.params.sender}
        ]
      }).sort({createdAt: 'asc'})
      res.json(message);
    } catch (err) {
      res.status(401).json({ msg: "Error retrieving users chats" });
    }
  },

  createResetPasswordToken: async function(req, res){
    try {
      const {email} = req.body;
     

      const user = await User.findOne({email});
      if (!user) return res.status(401).json({ success: false, msg: 'The email address ' + req.body.email + ' is not associated with any account. Double check the email' })

      user.generatePasswordReset();
      await user.save();

      let link = 'http://' + req.headers.host + '/reset/' + user.resetPasswordToken;

      const mailOptions = {
        from: process.env.EMAIL_ADDRESS,
        to: user.email,
        subject: 'Request for Reset Password 🤔',
        html: `<p style="font-size: 20px; font-weight: 500;">You request for a password reset👋</p><p>Please click on the click below to reset your password </p>
        <p style="font-size: 30px; font-weight: bold;"><a href="${link}">Link</a></p> `,
      }

      transporter.sendMail(mailOptions).then((result) => {
        return res.status(201).json({msg: 'Check your email to reset your password'})
      })
    } catch (err) {
      res.status(500).json({ msg: err.message });
    }
  },

  reset: async function (req, res){
    try {
      const {token} = req.params
      const user = await User.findOne({resetPasswordToken: token, resetPasswordExpires: {$gt: Date.now()}})

      if(!user) {
        const msg = 'Password reset token is invalid or has expired'
        console.log(err)
        res.render('error', {msg})

      } 
      
      res.render('resetPassword', {user})
      
    } catch (err) {

      res.status(500).json({ msg: err.message });
    }
  },

  resetPassword: async function(req, res){
    try {
      const {token} = req.params

      User.findOne({resetPasswordToken: token, resetPasswordExpires: {$gt: Date.now()}}).then((data => {
        if(!data) {
          res.render('error', {msg: 'Password reset token is invalid or has expired '})
        } 

        data.password = req.body.password;
        data.resetPasswordToken = undefined;
        data.resetPasswordExpires = undefined;
        data.isVerified = true;


        data.save()

        const mailOptions = {
          from: process.env.EMAIL_ADDRESS,
          to: data.email,
          subject: 'Your password was just changed',
          html: `<p> <h1>Hi  <b> ${data.email},</b></h1><p><br><p>This is a confirmation that the password for your account ${data.email} has just been changed.</p> `
        }

        transporter.sendMail(mailOptions).then((result)=>{
          res.render('success', {msg: 'Password succesfully changed '})
        })
      }))
      .catch((err =>{
        const msg = err.message
  
        res.render('error', {msg})
        // res.status(501).json({ msg: err.message });

      }))


    } catch (err) {
      const msg = err.message
      console.log(err)
      res.render('error', {msg})
    }
  },

  getUserProfileImage: async function(req, res){
    try {
      const user = await User.findById(req.user)
      if(!user) return res.status(401).json({msg: 'User not found'})

      res.status(200).json({profileImage: user.profileImage})
    } catch (error) {
      res.status(501).json({ msg: "Error retreving profile image" });
    }
  }

};

module.exports = functions;
