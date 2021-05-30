// See https://zwave-js.github.io/node-zwave-js/#/api/driver?id=zwaveoptions
module.exports = {
  /* Specify the network key to use for encryption. This must be a Buffer of exactly 16 bytes. */
  /* generated with `openssl rand -hex 16` */
  /* DO NOT COMMIT BELOW KEY */
  networkKey: Buffer.from("decafbaddecafbaddecafbaddecafbad"),
  storage: {
    /** Allows you to specify a different cache directory */
    cacheDir: "/cache",
  },
}
