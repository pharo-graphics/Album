Class {
	#name : #AlbEditorSegmentType,
	#superclass : #BlInfiniteItemType,
	#classInstVars : [
		'uniqueInstance'
	],
	#category : #'Album-Model-Segment'
}

{ #category : #cleanup }
AlbEditorSegmentType class >> cleanUp [
	super cleanUp.
	
	uniqueInstance := nil
]

{ #category : #accessing }
AlbEditorSegmentType class >> uniqueInstance [
	"Return a unique instance of my type. Since there may be a lot of
	segments of the same type it is better to refer to the same type object
	for memory usage and performance reasons"
	<return: #AlbEditorSegmentType>

	^ uniqueInstance ifNil: [ uniqueInstance := self new ]
]

{ #category : #accessing }
AlbEditorSegmentType >> holder [
	"Instantiate and return a new segment holder based on my type"
	<return: #AlbEditorSegmentHolder>
	
	^ self subclassResponsibility
]
