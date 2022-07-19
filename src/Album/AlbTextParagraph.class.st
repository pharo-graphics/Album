"
Kept for now but will be removed in the futur 
"
Class {
	#name : #AlbTextParagraph,
	#superclass : #BlTextParagraph,
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
