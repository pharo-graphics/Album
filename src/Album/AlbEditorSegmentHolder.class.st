"
I am a segment holder and is responsible for binding it to its visual representation.
I am also responsible for caching functionality in order to reduce amount of instantiated objects.
"
Class {
	#name : #AlbEditorSegmentHolder,
	#superclass : #BlInfiniteHolder,
	#category : #'Album-Model-Segment'
}

{ #category : #initialization }
AlbEditorSegmentHolder >> createSegmentElement [
	"Create and return an that should represent a segment that I will hold.
	An element can be any of `BlElement withAllSubclasses`"
	<return: #BlElement>
	
	^ self subclassResponsibility
]

{ #category : #accessing }
AlbEditorSegmentHolder >> editor [
	"Return the attached text editor instance.
	Editor can not be nil"
	<return: #AlbTextEditor>

	^ self infiniteElement editor
]

{ #category : #initialization }
AlbEditorSegmentHolder >> initialize [
	super initialize.

	itemElement := self createSegmentElement
]

{ #category : #updating }
AlbEditorSegmentHolder >> onRecycled [
]

{ #category : #accessing }
AlbEditorSegmentHolder >> segment: aEditorSegment [
	^ self subclassResponsibility
]
