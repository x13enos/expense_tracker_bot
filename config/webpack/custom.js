var path = require('path');

module.exports = {
  resolve: {
    alias: {
      '@components': path.resolve('app/javascript/packs/components'),
      '@store': path.resolve('app/javascript/packs/store')
    }
  }
}
