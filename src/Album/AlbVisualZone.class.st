Class {
	#name : #AlbVisualZone,
	#superclass : #BlInfiniteDecoration,
	#instVars : [
		'zone',
		'needRefresh'
	],
	#category : #'Album-UI'
}

{ #category : #testing }
AlbVisualZone class >> isDeprecated [ 
	^ true
]

{ #category : #accessing }
AlbVisualZone >> zone [

	^ zone
]

{ #category : #accessing }
AlbVisualZone >> zone: anObject [
	zone := anObject.

]
