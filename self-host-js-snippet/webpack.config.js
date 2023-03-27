const path = require('path');

module.exports = env => ({
  mode: 'production',
  entry: './index.js',
  output: {
    path: __dirname,
    filename: 'compiled.js',
  },
  module: {
    rules: [
      {
        test: /\.js/,
        exclude: /node_modules/,
        loader: 'babel-loader'
      }
    ]
  },
});