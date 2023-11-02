[![License](https://img.shields.io/github/license/plantec/Album.svg)](./LICENSE)

[![Tests](https://github.com/plantec/Album/actions/workflows/Tests.yml/badge.svg?branch=master)](https://github.com/plantec/Album/actions/workflows/Tests.yml)
[![Pharo 11](https://img.shields.io/badge/Pharo-11-%23aac9ff.svg)](https://pharo.org/download)
[![Pharo 12](https://img.shields.io/badge/Pharo-12-%23aac9ff.svg)](https://pharo.org/download)

# Album

Album is a text editor library based on Bloc.
Album provide functions to create widgets with advanced text edition features as input field, text area, etc.   

Originaly forked from Brick project editor.

## Installation

To install the latest version of Album in Pharo you just need to execute the following script:

```Smalltalk
Metacello new
	baseline: 'Album';
	repository: 'github://plantec/Album:master/src';
	onConflictUseIncoming;
	load
```

To add in your project BaselineOf:

```Smalltalk
spec baseline: 'Album' with: [ spec repository: 'github://plantec/Album:master/src' ].
```