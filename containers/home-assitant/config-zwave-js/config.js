// See https://zwave-js.github.io/node-zwave-js/#/api/driver?id=zwaveoptions
module.exports = {
  /* Specify the network key to use for encryption. This must be a Buffer of exactly 16 bytes. */
  /* generate with `openssl rand -hex 16` */
  /* CHANGE BELOW KEY */
  networkKey: "decafbaddecafbaddecafbaddecafbad",
  storage: {
    /** Allows you to specify a different cache directory */
    cacheDir: "/cache",
  },
}
