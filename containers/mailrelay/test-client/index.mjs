import nodemailer from "nodemailer"

const arg1 = process.argv.length > 2 ? process.argv[2] : ""
const arg2 = process.argv.length > 3 ? process.argv[3] : ""

function getStandardTransporter() {}

function getTLSTransporter() {
  return nodemailer.createTransport({
    host: "bitbox.activescott.com",
    port: 465,
    secure: true,
  })
}

async function sendWithTransporter(transporter, transportInfo) {
  transportInfo = `${transportInfo} on port ${transporter.options.port}`
  console.log(transportInfo)
  try {
    const info = await transporter.sendMail({
      to: "scott@willeke.com",
      from: "asw <admin@activescott.com>",
      subject: `testing from nodemailer (${arg1}, ${transportInfo})`,
      text: `Sent at ${new Date().toLocaleString()}.
  arg1: ${arg1}
  arg2: ${arg2}
  Client Transport Info: ${transportInfo}
  `,
    })

    console.log("Message sent: %s", info)
  } catch (err) {
    console.error(err)
  }
}

// this transporter /may/ still upgrade to TLS if the server supports it
let transporter = nodemailer.createTransport({
  host: "bitbox.activescott.com",
  port: 587,
  secure: false,
  requireTLS: false,
})
await sendWithTransporter(transporter, "TLS optional")

// this transporter MUST still upgrade to TLS if the server supports it
transporter = nodemailer.createTransport({
  host: "bitbox.activescott.com",
  port: 587,
  secure: false,
  requireTLS: true,
})
await sendWithTransporter(transporter, "TLS required")

// this transporter MUST still upgrade to TLS if the server supports it
transporter = nodemailer.createTransport({
  host: "bitbox.activescott.com",
  port: 465,
  secure: false,
  requireTLS: true,
})
await sendWithTransporter(transporter, "TLS required 465")

/*
// NOTE: This one never worked for me. I always get "wrong version number"
// this transporter MUST still upgrade to TLS if the server supports it
transporter = nodemailer.createTransport({
  host: "bitbox.activescott.com",
  port: 465,
  secure: true,
  requireTLS: true,
  tls: {
    ciphers:'SSLv3'
  }
})
await sendWithTransporter(transporter, "TLS forced 465")
*/
