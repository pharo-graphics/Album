# Album
A fork of the Brick editor.

Album depends on Brick. 
One can load Bloc with:
```Smalltalk
Metacello new
	baseline: 'Bloc';
	repository: 'github://pharo-graphics/Bloc/src';
	onConflictUseIncoming;
	load
```
