Class {
	#name : #AlbThemeElementProperty,
	#superclass : #BlElementProperty,
	#instVars : [
		'theme'
	],
	#category : #'Album-Theme'
}

{ #category : #accessing }
AlbThemeElementProperty >> = anObject [
	self == anObject
		ifTrue: [ ^ true ].
	self class = anObject class
		ifFalse: [ ^ false ].
	^ theme = anObject theme
]

{ #category : #accessing }
AlbThemeElementProperty >> applyOnElement: anElement [
	anElement userData at: #AlbTheme put: theme.	
]

{ #category : #accessing }
AlbThemeElementProperty >> canPropagateToChildren [
	^ true
]

{ #category : #accessing }
AlbThemeElementProperty >> hash [
	^ theme hash
]

{ #category : #accessing }
AlbThemeElementProperty >> theme [
	^ theme
]

{ #category : #accessing }
AlbThemeElementProperty >> theme: aTheme [
	theme := aTheme
]
