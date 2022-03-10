Class {
	#name : #AlbDefaultLinkTheme,
	#superclass : #AlbTheme,
	#instVars : [
		'color',
		'errorColor'
	],
	#category : #'Album-Theme-Default'
}

{ #category : #accessing }
AlbDefaultLinkTheme >> color [
	^ color
]

{ #category : #accessing }
AlbDefaultLinkTheme >> color: anObject [
	color := anObject
]

{ #category : #accessing }
AlbDefaultLinkTheme >> errorColor [
	^ errorColor
]

{ #category : #accessing }
AlbDefaultLinkTheme >> errorColor: anObject [
	errorColor := anObject
]

{ #category : #initialization }
AlbDefaultLinkTheme >> initialize [
	super initialize.
	color := AlbDefaultColors linkColor.
	errorColor := AlbDefaultColors linkWithErrorColor
]
