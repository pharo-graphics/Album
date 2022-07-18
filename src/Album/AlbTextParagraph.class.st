Class {
	#name : #AlbTextParagraph,
	#superclass : #BlTextParagraph,
	#instVars : [
		'extendedSelection',
		'oppositeIndex'
	],
	#category : #'Album-UI'
}

{ #category : #accessing }
AlbTextParagraph class >> extendedSelectionColor [
	^ Color gray alpha: 0.35
]

{ #category : #accessing }
AlbTextParagraph class >> oppositeDelimiterBackgroundColor [
	^ Color yellow
]

{ #category : #accessing }
AlbTextParagraph >> extendedSelection [
	^ extendedSelection
]

{ #category : #accessing }
AlbTextParagraph >> extendedSelection: aSelection [
	extendedSelection := aSelection
]

{ #category : #accessing }
AlbTextParagraph >> oppositeIndex [

	^ oppositeIndex 
]

{ #category : #accessing }
AlbTextParagraph >> oppositeIndex: anInteger [

	oppositeIndex := anInteger
]
