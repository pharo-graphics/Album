Class {
	#name : #AlbTextEditorByScripterTest,
	#superclass : #TestCase,
	#instVars : [
		'scripter'
	],
	#category : #'Album-Tests'
}

{ #category : #running }
AlbTextEditorByScripterTest >> setUp [

	super setUp.
	scripter := BlDevScripter new
]

{ #category : #running }
AlbTextEditorByScripterTest >> tearDown [

	scripter close.
	super tearDown
]

{ #category : #tests }
AlbTextEditorByScripterTest >> testClickRequestsFocus [

	scripter element:
		(AlbEditorElement new
			text: '' asRopedText;
			yourself).

	scripter check
		value: [ :aAlbTextEditor | aAlbTextEditor cursor position ] equals: 0;
		onAlbum.

	scripter check
		satisfies: [ :aAlbEditor | aAlbEditor hasFocus not ];
		onSelf.

	scripter click onSelf.

	scripter check
		value: [ :aAlbTextEditor | aAlbTextEditor cursor position ] equals: 0;
		onAlbum.

	scripter check
		satisfies: [ :aAlbEditor | aAlbEditor hasFocus ];
		onSelf.

	scripter syncPlay
]

{ #category : #tests }
AlbTextEditorByScripterTest >> testCursorMovementAndInsert [

	scripter element:
		(AlbEditorElement new
			text: '' asRopedText;
			yourself).

	scripter click onSelf.
	scripter type: 'Hello'.
	scripter keyClick: KeyboardKey left.
	scripter keyClick: KeyboardKey left.
	scripter type: 'x'.

	scripter check
		value: [ :aAlbTextEditor | aAlbTextEditor text asString ] equals: 'Helxlo';
		onAlbum.

	scripter check
		value: [ :aAlbTextEditor | aAlbTextEditor cursor position ] equals: 4;
		onAlbum.

	scripter syncPlay
]

{ #category : #tests }
AlbTextEditorByScripterTest >> testTypeAndBackspace [

	scripter element:
		(AlbEditorElement new
			text: '' asRopedText;
			yourself).

	scripter click onSelf.
	scripter type: 'Hello'.
	scripter keyClick: KeyboardKey backspace.

	scripter check
		value: [ :aAlbTextEditor | aAlbTextEditor text asString ] equals: 'Hell';
		onAlbum.

	scripter check
		value: [ :aAlbTextEditor | aAlbTextEditor cursor position ] equals: 4;
		onAlbum.

	scripter syncPlay
]

{ #category : #tests }
AlbTextEditorByScripterTest >> testTypeText [

	scripter element:
		(AlbEditorElement new
			text: '' asRopedText;
			yourself).

	scripter click onSelf.
	scripter type: 'Hello'.

	scripter check
		value: [ :aAlbTextEditor | aAlbTextEditor text asString ] equals: 'Hello';
		onAlbum.

	scripter check
		value: [ :aAlbTextEditor | aAlbTextEditor cursor position ] equals: 5;
		onAlbum.

	scripter syncPlay
]
