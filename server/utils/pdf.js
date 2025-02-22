const PDFDocument = require("pdfkit");
const fs = require("fs");
const path = require("path");

const generateReceiptPDF = (order, user) => {
  return new Promise((resolve, reject) => {
    try {
      const doc = new PDFDocument({ margin: 50 });
      const buffers = [];

      doc.on("data", buffers.push.bind(buffers));
      doc.on("end", () => resolve(Buffer.concat(buffers)));
      doc.on("error", reject);

      const logoPath = path.join(
        __dirname,
        "../../assets/images/amazon_in.png"
      );
      if (fs.existsSync(logoPath)) {
        doc.image(logoPath, { width: 120, align: "center" });
      }

      doc
        .moveDown()
        .fontSize(20)
        .text("Payment Receipt", { align: "center", underline: true });
      doc.moveDown(2);

      doc
        .fontSize(12)
        .text(`Order ID: ${order._id}`, { align: "left" })
        .text(`Order Date: ${new Date(order.orderAt).toLocaleString()}`)
        .moveDown();

      doc
        .text(`Customer Name: ${user.name}`)
        .text(`Email: ${user.email}`)
        .text(`Address: ${order.address}`)
        .moveDown();

      doc.fontSize(14).text("Order Details:", { underline: true });
      order.products.forEach((item, index) => {
        doc
          .fontSize(12)
          .text(`${index + 1}. ${item.product.name}`)
          .text(`   Quantity: ${item.quantity} | Price: $${item.product.price}`)
          .moveDown(0.5);
      });

      doc.moveDown();
      doc
        .fontSize(14)
        .text(`Total Price: $${order.totalPrice}`, { bold: true });

      doc.end();
    } catch (error) {
      reject(error);
    }
  });
};

module.exports = { generateReceiptPDF };
