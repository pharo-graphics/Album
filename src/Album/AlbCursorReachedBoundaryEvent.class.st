Class {
	#name : #AlbCursorReachedBoundaryEvent,
	#superclass : #BlEvent,
	#instVars : [
		'cursor',
		'boundary'
	],
	#classVars : [
		'Bottom',
		'Top'
	],
	#category : 'Album-Model-Events'
}

{ #category : #'class initialization' }
AlbCursorReachedBoundaryEvent class >> initialize [
	Top := #top.
	Bottom := #bottom
]

{ #category : #location }
AlbCursorReachedBoundaryEvent >> beBottom [
	boundary := Bottom
]

{ #category : #location }
AlbCursorReachedBoundaryEvent >> beTop [
	boundary := Top
]

{ #category : #accessing }
AlbCursorReachedBoundaryEvent >> cursor [
	^ cursor
]

{ #category : #accessing }
AlbCursorReachedBoundaryEvent >> cursor: anObject [
	cursor := anObject
]

{ #category : #testing }
AlbCursorReachedBoundaryEvent >> isBottom [
	^ boundary = Bottom
]

{ #category : #testing }
AlbCursorReachedBoundaryEvent >> isTop [
	^ boundary = Top
]
