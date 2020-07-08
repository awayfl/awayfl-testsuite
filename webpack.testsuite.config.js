const path = require('path');
const fs = require('fs');
const webpack = require('webpack');
const CopyWebPackPlugin = require('copy-webpack-plugin');
const HTMLWebPackPlugin = require('html-webpack-plugin');
const Terser = require('terser-webpack-plugin')
const rimraf = require("rimraf");
const tsloader = require.resolve('ts-loader');
const merge = require("webpack-merge");
module.exports = {

    entry: {
        "index": path.join(__dirname, "src", "TestSuite.tsx")
    },
    //devtool: 'source-map',
    output: {
        path: path.join(__dirname, "testsuite"),
        filename: 'js/TestSuite.js',
        publicPath: '/'
    },
    plugins: [new CopyWebPackPlugin([
		{ from: "template/TestSuite.html", to: "TestSuite.html" },
	])
        
   /* new CircularDependencyPlugin({
        // exclude detection of files based on a RegExp
        exclude: /a\.js|node_modules/,
        // include specific files based on a RegExp
        //include: /dir/,
        // add errors to webpack instead of warnings
        failOnError: true,
        // allow import cycles that include an asyncronous import,
        allowAsyncCycles: false,
        // set the current working directory for displaying module paths
        cwd: process.cwd(),
      })*/
        //new webpack.optimize.UglifyJsPlugin({minimize: true})
    ],
    resolve: {
        // Add `.ts` and `.tsx` as a resolvable extension.
        extensions: ['.webpack.js', '.web.js', '.ts', '.tsx', '.js', ".css", ".sass"],
    },
    module: {
        rules: [
            { test: /\.scss$/,   loaders: ["style", "css", "sass"] },
            { test: /\.css$/,    loaders: ["style-loader","css-loader"] },
            // all files with a `.ts` or `.tsx` extension will be handled by `awesome-typescript-loader`
            { test: /\.ts(x?)$/, loader: tsloader},

            // all files with a `.js` or `.jsx` extension will be handled by `source-map-loader`
            { test: /\.js(x?)$/, loader: require.resolve('source-map-loader') }
        ]
    },
    devServer: {
      historyApiFallback: true,
    },
};
