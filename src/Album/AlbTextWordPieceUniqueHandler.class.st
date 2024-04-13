Class {
	#name : #AlbTextWordPieceUniqueHandler,
	#superclass : #AlbTextWordPieceHandler,
	#classInstVars : [
		'uniqueInstance'
	],
	#category : #'Album-UI-Word'
}

{ #category : #accessing }
AlbTextWordPieceUniqueHandler class >> cleanUp [
	super cleanUp.
	
	uniqueInstance := nil
]

{ #category : #accessing }
AlbTextWordPieceUniqueHandler class >> uniqueInstance [
	^ uniqueInstance ifNil: [ uniqueInstance := self new ]
]
