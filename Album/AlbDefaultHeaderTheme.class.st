Class {
	#name : #AlbDefaultHeaderTheme,
	#superclass : #AlbTheme,
	#instVars : [
		'textMarkupColor',
		'defaultBackgroundColor',
		'disabledTextColor',
		'defaultTextColor',
		'secondaryBackgroundColor'
	],
	#category : #'Album-Theme-Default'
}

{ #category : #accessing }
AlbDefaultHeaderTheme >> defaultBackgroundColor [
	^ defaultBackgroundColor
]

{ #category : #accessing }
AlbDefaultHeaderTheme >> defaultBackgroundColor: anObject [
	defaultBackgroundColor := anObject
]

{ #category : #accessing }
AlbDefaultHeaderTheme >> defaultTextColor [
	^ defaultTextColor
]

{ #category : #accessing }
AlbDefaultHeaderTheme >> defaultTextColor: anObject [
	defaultTextColor := anObject
]

{ #category : #accessing }
AlbDefaultHeaderTheme >> disabledTextColor [
	^ disabledTextColor
]

{ #category : #accessing }
AlbDefaultHeaderTheme >> disabledTextColor: anObject [
	disabledTextColor := anObject
]

{ #category : #initialization }
AlbDefaultHeaderTheme >> initialize [
	super initialize.
	textMarkupColor := AlbDefaultColors textMarkupColor.
	defaultBackgroundColor := AlbDefaultColors
		defaultHeaderBackgroundColor.
	disabledTextColor := AlbDefaultColors disabledHeaderTextColor.
	defaultTextColor := AlbDefaultColors defaultHeaderTextColor.
	secondaryBackgroundColor := AlbDefaultColors
		secondaryHeaderBackgroundColor
]

{ #category : #accessing }
AlbDefaultHeaderTheme >> secondaryBackgroundColor [
	^ secondaryBackgroundColor
]

{ #category : #accessing }
AlbDefaultHeaderTheme >> secondaryBackgroundColor: anObject [
	secondaryBackgroundColor := anObject
]

{ #category : #accessing }
AlbDefaultHeaderTheme >> textMarkupColor [
	^ textMarkupColor
]

{ #category : #accessing }
AlbDefaultHeaderTheme >> textMarkupColor: anObject [
	textMarkupColor := anObject
]
