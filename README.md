[![License](https://img.shields.io/github/license/pharo-graphics/Album.svg)](./LICENSE)

[![Tests](https://github.com/pharo-graphics/Album/actions/workflows/Tests.yml/badge.svg?branch=master)](https://github.com/pharo-graphics/Album/actions/workflows/Tests.yml)
[![Pharo 11](https://img.shields.io/badge/Pharo-11-%23aac9ff.svg)](https://pharo.org/download)
[![Pharo 12](https://img.shields.io/badge/Pharo-12-%23aac9ff.svg)](https://pharo.org/download)

# Album

Album is a text editor library based on Bloc.
Album provide functions to create widgets with advanced text edition features as input field, text area, etc.   

Originaly forked from Brick project editor.


## Installation

Load the stable Album in current stable Pharo with:

```Smalltalk
Metacello new
	baseline: 'Album';
	repository: 'github://pharo-graphics/Album:master/src';
	onConflictUseIncoming;
	load
```

Add Album to your project Baseline with:

```Smalltalk
spec baseline: 'Album' with: [ spec repository: 'github://pharo-graphics/Album:master/src' ].
```

For development, replace `master` by `dev` in previous code.


## License

This code is licensed under the [MIT license](./LICENSE).
