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
AlbTextClickAttribute >> handleEvent: anEvent [ 
	self performAction: anEvent 
]

{ #category : #initialization }
AlbTextClickAttribute >> initialize [
	super initialize.
	
	action := [ :aTTextEditorTextualPiece :aTextElement :aTextEditor :anEvent | ]
]

{ #category : #private }
AlbTextClickAttribute >> performAction: anEvent [

	"first we pass text then the text piece (word) element then the whole text editor and the event itself "

	self action
		value: anEvent textualPiece
		value: anEvent wrappedEvent currentTarget
		value: anEvent textEditor
		value: anEvent wrappedEvent
]

{ #category : #events }
AlbTextClickAttribute >> wantsEvent: anEvent [ 
	^ anEvent wrappedEvent isKindOf: BlClickEvent
]
