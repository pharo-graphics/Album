Class {
	#name : #AlbTextParagraph,
	#superclass : #BlTextParagraph,
	#instVars : [
		'extendedSelection'
	],
	#category : #'Album-UI'
}

{ #category : #accessing }
AlbTextParagraph class >> extendedSelectionColor [
	^ Color gray alpha: 0.35
]

{ #category : #accessing }
AlbTextParagraph >> extendedSelection [
	^ extendedSelection
]

{ #category : #accessing }
AlbTextParagraph >> extendedSelection: aSelection [
	extendedSelection := aSelection
]
