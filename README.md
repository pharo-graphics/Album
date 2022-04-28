# Album
A fork of the Brick editor.

Album depends on Bloc. 
One can load Bloc with:
```Smalltalk
Metacello new
	baseline: 'NewBloc';
	repository: 'github://pharo-graphics/Bloc/src';
	onConflictUseIncoming;
	load
```
