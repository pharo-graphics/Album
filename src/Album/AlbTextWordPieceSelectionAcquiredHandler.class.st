Class {
	#name : #AlbTextWordPieceSelectionAcquiredHandler,
	#superclass : #AlbTextWordPieceUniqueHandler,
	#category : #'Album-UI-Word'
}

{ #category : #accessing }
AlbTextWordPieceSelectionAcquiredHandler >> eventClass [
	^ BlElementSelectionAcquiredEvent
]

{ #category : #'api - event managing' }
AlbTextWordPieceSelectionAcquiredHandler >> handleEvent: anEvent [
	| anEditorElement aTextElement aGlobalFrom aGlobalTo |

	"To not create an instance of me for each tiny text element"
	anEditorElement := anEvent currentTarget
		allParentsDetect: [ :anElement | (anElement isKindOf: AlbEditorElement) or: [anElement isKindOf: AlbEditorElement] ]
		ifFound: #yourself
		ifNone: [ ^ self ].

	anEvent consume.

	aTextElement := anEvent currentTarget.
	
	"selection bounds equal to our bounds => fast select the whole text piece"
	(anEvent bounds = aTextElement boundsInLocal)
		ifTrue: [
			aGlobalFrom :=  aTextElement textStart.
			aGlobalTo := aTextElement textEnd ]
		ifFalse: [ 
			| aFromIndex aToIndex |
			aFromIndex := aTextElement indexAtScreenPosition: anEvent bounds origin.
			aToIndex := aTextElement indexAtScreenPosition: anEvent bounds corner.

			"remove previous selection"	
			aTextElement selection do: [ :aMonotoneSelection |
				aGlobalFrom := self localTextIndexToGlobal: aMonotoneSelection from in: aTextElement.
				aGlobalTo := self localTextIndexToGlobal: aMonotoneSelection to in: aTextElement.
				anEditorElement editor recordDeselection: (BlMonotoneSelection from: aGlobalFrom to: aGlobalTo) ].
			
			aGlobalFrom := self localTextIndexToGlobal: aFromIndex from in: aTextElement.
			aGlobalTo := self localTextIndexToGlobal: aToIndex to in: aTextElement ].
		
	anEditorElement editor recordSelection: (BlMonotoneSelection from: aGlobalFrom to: aGlobalTo)
]
