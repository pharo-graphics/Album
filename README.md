# Album
A fork of the Brick editor.

For now, Album depends on Brick. 
One can load Bloc/Brick with:
```Smalltalk
Metacello new
	baseline: 'SpecBrick';
	repository: 'github://pharo-graphics/Spec-Brick/src';
	onConflictUseIncoming;
	load
```
