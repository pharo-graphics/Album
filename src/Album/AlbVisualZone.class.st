Class {
	#name : #AlbVisualZone,
	#superclass : #BlInfiniteItemDecoration,
	#instVars : [
		'zone',
		'needRefresh'
	],
	#category : #'Album-UI'
}

{ #category : #accessing }
AlbVisualZone >> zone [

	^ zone
]

{ #category : #accessing }
AlbVisualZone >> zone: anObject [
	zone := anObject.

]
