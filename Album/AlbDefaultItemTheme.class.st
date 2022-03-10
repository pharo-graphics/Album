Class {
	#name : #AlbDefaultItemTheme,
	#superclass : #AlbTheme,
	#instVars : [
		'selectedColor',
		'deselectedColor',
		'hoveredColor',
		'defaultColor',
		'focusedBorderColor',
		'pressedColor'
	],
	#category : #'Album-Theme-Default'
}

{ #category : #accessing }
AlbDefaultItemTheme >> defaultColor [
	^ defaultColor
]

{ #category : #accessing }
AlbDefaultItemTheme >> defaultColor: anObject [
	defaultColor := anObject
]

{ #category : #accessing }
AlbDefaultItemTheme >> deselectedColor [
	^ deselectedColor
]

{ #category : #accessing }
AlbDefaultItemTheme >> deselectedColor: anObject [
	deselectedColor := anObject
]

{ #category : #accessing }
AlbDefaultItemTheme >> focusedBorderColor [
	^ focusedBorderColor
]

{ #category : #accessing }
AlbDefaultItemTheme >> focusedBorderColor: anObject [
	focusedBorderColor := anObject
]

{ #category : #accessing }
AlbDefaultItemTheme >> hoveredColor [
	^ hoveredColor
]

{ #category : #accessing }
AlbDefaultItemTheme >> hoveredColor: anObject [
	hoveredColor := anObject
]

{ #category : #initialization }
AlbDefaultItemTheme >> initialize [
	super initialize.
	selectedColor := AlbDefaultColors selectedListItemColor.
	deselectedColor := AlbDefaultColors deselectedListItemColor.
	hoveredColor := AlbDefaultColors hoveredListItemColor.
	defaultColor := AlbDefaultColors defaultListItemColor.
	focusedBorderColor := AlbDefaultColors focusedListItemBorder.
	pressedColor := AlbDefaultColors pressedListItemColor
]

{ #category : #accessing }
AlbDefaultItemTheme >> pressedColor [
	^ pressedColor
]

{ #category : #accessing }
AlbDefaultItemTheme >> pressedColor: anObject [
	pressedColor := anObject
]

{ #category : #accessing }
AlbDefaultItemTheme >> selectedColor [
	^ selectedColor
]

{ #category : #accessing }
AlbDefaultItemTheme >> selectedColor: anObject [
	selectedColor := anObject
]
