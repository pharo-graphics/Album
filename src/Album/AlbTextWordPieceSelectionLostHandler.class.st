Class {
	#name : #AlbTextWordPieceSelectionLostHandler,
	#superclass : #AlbTextWordPieceUniqueHandler,
	#category : #'Album-UI-Word'
}

{ #category : #accessing }
AlbTextWordPieceSelectionLostHandler >> eventClass [
	^ BlElementSelectionLostEvent
]

{ #category : #'api - event managing' }
AlbTextWordPieceSelectionLostHandler >> handleEvent: anEvent [
	| aTextEditElement anEditorElement |
	
	"To not create an instance of me for each tiny text element"
	anEditorElement := anEvent currentTarget
		allParentsDetect: [ :anElement | (anElement isKindOf: AlbEditorElement) or: [anElement isKindOf: AlbEditorElement] ]
		ifFound: #yourself
		ifNone: [ ^ self ].

	anEvent consume.

	aTextEditElement := anEvent currentTarget.

	aTextEditElement selection do: [ :aMonotoneSelection |
		| aGlobalFrom aGlobalTo |

		aGlobalFrom := self localTextIndexToGlobal: aMonotoneSelection from in: aTextEditElement textStart.
		aGlobalTo := self localTextIndexToGlobal: aMonotoneSelection to in: aTextEditElement textStart.
		anEditorElement editor recordDeselection: (BlMonotoneSelection from: aGlobalFrom to: aGlobalTo) ]
]
