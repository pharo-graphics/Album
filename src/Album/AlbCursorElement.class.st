Class {
	#name : #AlbCursorElement,
	#superclass : #BlElement,
	#instVars : [
		'textPosition'
	],
	#category : #'Album-UI'
}

{ #category : #initialization }
AlbCursorElement >> defaultBackground [

	^ Color red alpha: 0.5
]

{ #category : #initialization }
AlbCursorElement >> initialize [
	super initialize.
	
	textPosition := 0.
	self focusability: BlFocusability none.
	self elevation: (BlRelativeElevation elevation: 10000)
]

{ #category : #'private - focus' }
AlbCursorElement >> onGotFocus [

	self background: self defaultBackground.
	 
]

{ #category : #'private - focus' }
AlbCursorElement >> onLostFocus [

		self background: (Color veryLightGray )
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
