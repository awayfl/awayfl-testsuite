import typescript from 'rollup-plugin-typescript2'
import nodeResolve from 'rollup-plugin-node-resolve';
import commonjs from 'rollup-plugin-commonjs';
import { terser } from 'rollup-plugin-terser';
import gzipPlugin from 'rollup-plugin-gzip';

export default {
	input: './src/Main.ts',
	output: {
		sourcemap: true,
		format: 'iife',
		name: 'Main',
		file: './bin/js/Main.js'
	},
	plugins: [
		typescript({
			rollupCommonJSResolveHack:true,
		}),
		nodeResolve({
			jsnext: true,
			main: true,
			module: true
		}),
		commonjs({
			include: /node_modules/,
			namedExports: {
				'../../@awayfl/avm1/node_modules/random-seed/index.js': [ 'create' ]
			},
		}),
		terser({
			// mangle: {
			// 	properties: {
			// 		reserved: ['AVMPlayerClass', 'userAgent', 'Number', '__constructor__', 'prototype']
			// 	}
			// }
		}),
		gzipPlugin()
	]
};