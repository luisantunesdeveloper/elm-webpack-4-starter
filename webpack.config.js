const path = require('path');
const glob = require('glob');
const webpack = require('webpack');
const merge = require('webpack-merge');
const HtmlWebpackPlugin = require('html-webpack-plugin');
const ExtractTextPlugin = require('extract-text-webpack-plugin');
const CopyWebpackPlugin = require('copy-webpack-plugin')
const UglifyJsPlugin = require('uglifyjs-webpack-plugin')
const CompressionPlugin = require("compression-webpack-plugin")
const StyleLintPlugin = require('stylelint-webpack-plugin');
const PurifyCSSPlugin = require('purifycss-webpack');
const DashboardPlugin = require('webpack-dashboard/plugin');
const BundleAnalyzerPlugin = require('webpack-bundle-analyzer').BundleAnalyzerPlugin;

const prod = 'production';
const dev = 'development';

// build env
const TARGET_ENV = process.env.npm_lifecycle_event === 'build' ? prod : dev;
const isDev = TARGET_ENV === dev;
const isProd = TARGET_ENV === prod;


// entry and output path/filename variables
const entryPath = path.join(__dirname, 'src/static/index.js');
const outputPath = path.join(__dirname, 'dist');
const outputFilename = isProd ? '[name].[hash].js' : '[name].js';

console.log(`Building for ${TARGET_ENV}`);

const commonConfig = {
  output: {
    path: outputPath,
    filename: `static/js/${outputFilename}`,
  },

  resolve: {
    extensions: ['.js', '.elm']
  },

  module: {
    noParse: /\.elm$/,
    rules: [
      {
        test: /\.(eot|ttf|woff|woff2|svg)$/,
        use: 'file-loader?publicPath=../../&name=static/css/[hash].[ext]',
      },
    ]
  },

  plugins: [
    new HtmlWebpackPlugin({
      template: 'src/static/index.html',
      inject: 'body',
      filename: 'index.html',
    }),

    new StyleLintPlugin(),

    new CopyWebpackPlugin([
      { from: 'src/static/favicon.ico' }
    ]),
  ]
};

if (isDev) {
  module.exports = merge(commonConfig, {
    mode: 'development',

    entry: [
      'webpack-dev-server/client?http://localhost:8080',
      entryPath,
    ],

    module: {
      rules: [
        {
          test: /\.elm$/,
          exclude: [/elm-stuff/, /node_modules/],
          use: [
            {
              loader: 'elm-hot-loader'
            },
            {
              loader: 'elm-webpack-loader',
              options: {
                verbose: true,
                warn: true,
                debug: true
              }
            }
          ]
        },
        {
          test: /\.s?css$/,
          use: ['style-loader', 'css-loader', 'postcss-loader', 'sass-loader']
        }
      ]
    },

    plugins: [
      new DashboardPlugin(),
    ],

    devServer: {
      historyApiFallback: true,
      contentBase: './src',
      inline: true,
      stats: 'errors-only',
    }
  });
}

if (isProd) {
  module.exports = merge(commonConfig, {
    mode: 'production',

    entry: entryPath,

    module: {
      rules: [
        {
          test: /\.elm$/,
          exclude: [/elm-stuff/, /node_modules/],
          use: 'elm-webpack-loader'
        },
        {
          test: /\.s?css$/,
          use: ExtractTextPlugin.extract({
            fallback: 'style-loader',
            use: ['css-loader', 'postcss-loader', 'sass-loader']
          })
        }
      ]
    },

    plugins: [
      new ExtractTextPlugin({
        filename: 'static/css/[name].[hash].css',
        allChunks: true
      }),

      new PurifyCSSPlugin({
        // Give paths to parse for rules. These should be absolute!
        paths: glob.sync(path.join(__dirname, 'src/**/*.elm')),
        purifyOptions: {
          minify: true
        },
        verbose: true
      }),

      new CopyWebpackPlugin([
        { from: 'src/static/img', to: 'static/img' },
      ]),

      new UglifyJsPlugin(),

      new CompressionPlugin(),

      new BundleAnalyzerPlugin(),
    ]
  });
}
