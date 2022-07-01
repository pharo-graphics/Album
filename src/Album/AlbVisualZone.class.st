Class {
	#name : #AlbVisualZone,
	#superclass : #Object,
	#instVars : [
		'zone',
		'needRefresh'
	],
	#category : #'Album-UI'
}

{ #category : #sparta }
AlbVisualZone >> drawFrom: anElement onSpartaCanvas: aCanvas [
	^ self subclassResponsibility  
]

{ #category : #accessing }
AlbVisualZone >> zone [

	^ zone
]

{ #category : #accessing }
AlbVisualZone >> zone: anObject [
	zone := anObject.

]
