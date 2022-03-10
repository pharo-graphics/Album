Class {
	#name : #AlbDefaultButtonTheme,
	#superclass : #AlbTheme,
	#instVars : [
		'disabledBackgroundColor',
		'disabledTextColor',
		'disabledBorderColor',
		'pressedBorderColor',
		'defaultBorderColor',
		'defaultTextColor',
		'hoveredBorderColor',
		'pressedTextColor',
		'defaultBackgroundColor',
		'hoveredTextColor',
		'textHighlightColor'
	],
	#category : #'Album-Theme-Default'
}

{ #category : #accessing }
AlbDefaultButtonTheme >> defaultBackgroundColor [
	^ defaultBackgroundColor
]

{ #category : #accessing }
AlbDefaultButtonTheme >> defaultBackgroundColor: anObject [
	defaultBackgroundColor := anObject
]

{ #category : #accessing }
AlbDefaultButtonTheme >> defaultBorderColor [
	^ defaultBorderColor
]

{ #category : #accessing }
AlbDefaultButtonTheme >> defaultBorderColor: anObject [
	defaultBorderColor := anObject
]

{ #category : #accessing }
AlbDefaultButtonTheme >> defaultTextColor [
	^ defaultTextColor
]

{ #category : #accessing }
AlbDefaultButtonTheme >> defaultTextColor: anObject [
	defaultTextColor := anObject
]

{ #category : #accessing }
AlbDefaultButtonTheme >> disabledBackgroundColor [
	^ disabledBackgroundColor
]

{ #category : #accessing }
AlbDefaultButtonTheme >> disabledBackgroundColor: anObject [
	disabledBackgroundColor := anObject
]

{ #category : #accessing }
AlbDefaultButtonTheme >> disabledBorderColor [
	^ disabledBorderColor
]

{ #category : #accessing }
AlbDefaultButtonTheme >> disabledBorderColor: anObject [
	disabledBorderColor := anObject
]

{ #category : #accessing }
AlbDefaultButtonTheme >> disabledTextColor [
	^ disabledTextColor
]

{ #category : #accessing }
AlbDefaultButtonTheme >> disabledTextColor: anObject [
	disabledTextColor := anObject
]

{ #category : #accessing }
AlbDefaultButtonTheme >> hoveredBorderColor [
	^ hoveredBorderColor
]

{ #category : #accessing }
AlbDefaultButtonTheme >> hoveredBorderColor: anObject [
	hoveredBorderColor := anObject
]

{ #category : #accessing }
AlbDefaultButtonTheme >> hoveredTextColor [
	^ hoveredTextColor
]

{ #category : #accessing }
AlbDefaultButtonTheme >> hoveredTextColor: anObject [
	hoveredTextColor := anObject
]

{ #category : #initialization }
AlbDefaultButtonTheme >> initialize [
	super initialize.
	disabledBackgroundColor := AlbDefaultColors
		disabledButtonBackgroundColor.
	disabledTextColor := AlbDefaultColors disabledButtonTextColor.
	disabledBorderColor := AlbDefaultColors disabledButtonBorderColor.
	pressedBorderColor := AlbDefaultColors pressedButtonBorderColor.
	defaultBorderColor := AlbDefaultColors defaultButtonBorderColor.
	defaultTextColor := AlbDefaultColors defaultButtonTextColor.
	hoveredBorderColor := AlbDefaultColors hoveredButtonBorderColor.
	pressedTextColor := AlbDefaultColors pressedButtonTextColor.
	defaultBackgroundColor := AlbDefaultColors
		defaultButtonBackgroundColor.
	hoveredTextColor := AlbDefaultColors hoveredButtonTextColor.
	textHighlightColor := AlbDefaultColors textHighlightColor
]

{ #category : #accessing }
AlbDefaultButtonTheme >> pressedBorderColor [
	^ pressedBorderColor
]

{ #category : #accessing }
AlbDefaultButtonTheme >> pressedBorderColor: anObject [
	pressedBorderColor := anObject
]

{ #category : #accessing }
AlbDefaultButtonTheme >> pressedTextColor [
	^ pressedTextColor
]

{ #category : #accessing }
AlbDefaultButtonTheme >> pressedTextColor: anObject [
	pressedTextColor := anObject
]

{ #category : #accessing }
AlbDefaultButtonTheme >> textHighlightColor [
	^ textHighlightColor
]

{ #category : #accessing }
AlbDefaultButtonTheme >> textHighlightColor: anObject [
	textHighlightColor := anObject
]
