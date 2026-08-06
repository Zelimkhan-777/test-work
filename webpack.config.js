const path = require('path');
const HtmlWebpackPlugin = require('html-webpack-plugin');
const { VueLoaderPlugin } = require('vue-loader');

module.exports = {
  entry: './src/main.js',
  output: {
    path: path.resolve(__dirname, 'dist'),
    filename: 'assets/app.[contenthash:8].js',
    clean: true,
  },
  module: {
    rules: [
      { test: /\.vue$/, loader: 'vue-loader' },
      {
        test: /\.js$/,
        exclude: /node_modules/,
        use: {
          loader: 'babel-loader',
          options: { presets: [['@babel/preset-env', { targets: '> 0.5%, not dead' }]] },
        },
      },
      { test: /\.css$/, use: ['style-loader', 'css-loader'] },
      { test: /\.(png|jpe?g|webp|svg)$/i, type: 'asset/resource', generator: { filename: 'assets/[name].[contenthash:8][ext]' } },
      { test: /\.(woff2?|ttf)$/i, type: 'asset/resource', generator: { filename: 'assets/fonts/[name].[contenthash:8][ext]' } },
    ],
  },
  plugins: [
    new VueLoaderPlugin(),
    new HtmlWebpackPlugin({ template: './public/index.html' }),
  ],
  devServer: {
    static: path.join(__dirname, 'dist'),
    port: 8080,
    hot: true,
    historyApiFallback: true,
  },
  resolve: { extensions: ['.js', '.vue'] },
};
