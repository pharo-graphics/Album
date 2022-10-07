Class {
	#name : #AlbCursorElement,
	#superclass : #BlElement,
	#instVars : [
		'textPosition'
	],
	#category : #'Album-UI'
}

{ #category : #initialization }
AlbCursorElement >> initialize [
	super initialize.
	
	textPosition := 0.
	self focusability: BlFocusability none
]

{ #category : #accessing }
AlbCursorElement >> textPosition [
	^ textPosition
]

{ #category : #accessing }
AlbCursorElement >> textPosition: aNumber [
	textPosition := aNumber.
	self requestLayout
]
