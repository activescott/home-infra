import nodemailer from "nodemailer"

const arg1 = process.argv.length > 2 ? process.argv[2] : ""
const arg2 = process.argv.length > 3 ? process.argv[3] : ""

let transporter = nodemailer.createTransport({
  host: "bitbox.activescott.com",
  port: 587,
  secure: false,
})

try {
  const info = await transporter.sendMail({
    to: "scott@willeke.com",
    from: "asw <admin@activescott.com>",
    subject: `testing from nodemailer (${arg1})`,
    text: `Sent at ${new Date().toLocaleString()}.
arg1: ${arg1}
arg2: ${arg2}
`,
  })

  console.log("Message sent: %s", info)
} catch (err) {
  console.error(err)
}
