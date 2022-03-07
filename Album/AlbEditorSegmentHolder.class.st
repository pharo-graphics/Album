Class {
	#name : #AlbEditorSegmentHolder,
	#superclass : #BlInfiniteHolder,
	#category : #'Album-Editor-Model - Segment'
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
	<return: #BrTextEditor>

	^ self infiniteElement editor
]

{ #category : #initialization }
AlbEditorSegmentHolder >> initialize [
	super initialize.

	itemElement := self createSegmentElement
]

{ #category : #'as yet unclassified' }
AlbEditorSegmentHolder >> onRecycled [
]

{ #category : #accessing }
AlbEditorSegmentHolder >> segment: aBrEditorSegment [
	^ self subclassResponsibility
]
