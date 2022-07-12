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

{ #category : #drawing }
AlbTextParagraph >> drawExtendedSelectionOnSpartaCanvas: aCanvas padding: aBlInsets [

	self
		drawselection: self extendedSelection
		onSpartaCanvas: aCanvas
		padding: aBlInsets
		color: self class extendedSelectionColor
]

{ #category : #accessing }
AlbTextParagraph >> extendedSelection [
	^ extendedSelection
]

{ #category : #accessing }
AlbTextParagraph >> extendedSelection: aSelection [
	extendedSelection := aSelection
]
