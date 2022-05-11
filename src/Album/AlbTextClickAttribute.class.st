Class {
	#name : #AlbTextClickAttribute,
	#superclass : #AlbTextEventHandlerAttribute,
	#instVars : [
		'action'
	],
	#category : #'Album-Attributes'
}

{ #category : #accessing }
AlbTextClickAttribute >> action [
	^ action
]

{ #category : #accessing }
AlbTextClickAttribute >> action: aValuable [
	self 
		assert: [ aValuable notNil ] 
		description: [ 'Action should be initialized' ].

	action := aValuable
]

{ #category : #events }
AlbTextClickAttribute >> handleEvent: anEvent in: aTextEditor on: aTTextEditorTextualPiece [
	self performAction: anEvent in: aTextEditor on: aTTextEditorTextualPiece
]

{ #category : #initialization }
AlbTextClickAttribute >> initialize [
	super initialize.
	
	action := [ :aTTextEditorTextualPiece :aTextElement :aTextEditor :anEvent | ]
]

{ #category : #private }
AlbTextClickAttribute >> performAction: anEvent in: aTextEditor on: aTTextEditorTextualPiece [
	self action glamourValueWithArgs: {
		aTTextEditorTextualPiece. "first we pass text"
		anEvent currentTarget. "then the text piece (word) element"
		aTextEditor. "then the whole text editor"
		anEvent "the event itself"
	}
]

{ #category : #events }
AlbTextClickAttribute >> wantsEvent: anEvent in: aTextEditor [
	^ anEvent isKindOf: BlClickEvent
]
