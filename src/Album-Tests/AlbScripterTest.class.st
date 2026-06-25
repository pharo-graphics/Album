Class {
	#name : #AlbScripterTest,
	#superclass : #TestCase,
	#category : #'Album-Tests-Scripter'
}

{ #category : #tests }
AlbScripterTest >> testClick [

	| aScripter |
	aScripter := BlDevScripter new.
	aScripter element: AlbEditorElement new.

	aScripter substeps: 'Click empty' do: [ :aStep |
		aStep testClick onSelf.

		aStep check
			value: [ :aAlbTextEditor | aAlbTextEditor cursor position ] equals: 0;
			onAlbum.

		aStep check
			satisfies: [ :aAlbEditor | aAlbEditor hasFocus ];
			onSelf ].

	aScripter syncContinue
]

{ #category : #running }
AlbScripterTest >> testEmpty [

	| aScripter |
	aScripter := BlDevScripter new.
	aScripter element: AlbEditorElement new.
	
	aScripter substeps: 'Initialize' do: [ :aStep |
		aStep check
			value: [ :aAlbTextEditor | aAlbTextEditor cursor position ] equals: 0;
			onAlbum.

		aStep check
			satisfies: [ :aAlbEditor | aAlbEditor hasFocus not ];
			onSelf ].

	aScripter syncContinue
]

{ #category : #tests }
AlbScripterTest >> testTypeHelloWorld [

	| aScripter |
	aScripter := BlDevScripter new.
	aScripter element: AlbEditorElement new.

	aScripter substeps: 'Type text' do: [ :aStep |
		aStep testClick onSelf.

		aStep type: 'Hello world'.

		aStep check
			value: [ :aAlbTextEditor | aAlbTextEditor text asString ] equals: 'Hello world';
			onAlbum.

		aStep check
			value: [ :aAlbTextEditor | aAlbTextEditor cursor position ] equals: 11;
			onAlbum ].

	aScripter syncContinue
]
