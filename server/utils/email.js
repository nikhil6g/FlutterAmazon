const nodemailer = require("nodemailer");
const dotenv = require("dotenv");
dotenv.config();

const transporter = nodemailer.createTransport({
  service: "gmail",
  auth: {
    user: process.env.EMAIL_ID,
    pass: process.env.EMAIL_APP_PASSWORD,
  },
  tls: {
    rejectUnauthorized: false,
  },
});

const sendEmailWithReceipt = async (userEmail, pdfBuffer) => {
  const mailOptions = {
    from: process.env.EMAIL_ID,
    to: userEmail,
    subject: "Payment Receipt - Your Order Confirmation",
    html: "<strong>Thank you for your purchase! Find your receipt attached.</strong>",
    attachments: [
      {
        filename: "receipt.pdf",
        content: pdfBuffer,
        contentType: "application/pdf",
      },
    ],
  };

  try {
    await transporter.sendMail(mailOptions);
    return true;
  } catch (error) {
    console.error("Email sending error:", error);
    throw error;
  }
};

module.exports = { sendEmailWithReceipt };
