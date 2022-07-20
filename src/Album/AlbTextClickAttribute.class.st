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

	"first we pass text then the text piece (word) element then the whole text editor and the event itself "

	self action
		value: aTTextEditorTextualPiece
		value: anEvent currentTarget
		value: aTextEditor
		value: anEvent
]

{ #category : #events }
AlbTextClickAttribute >> wantsEvent: anEvent in: aTextEditor [
	^ anEvent isKindOf: BlClickEvent
]
