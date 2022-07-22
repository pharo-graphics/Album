"
I am a text segment holder `AlbTextEditorSegment` designed to be used by `AlbTextEditor`
"
Class {
	#name : #AlbTextEditorSegmentHolder,
	#superclass : #AlbEditorSegmentHolder,
	#category : #'Album-Model-Segment-Text'
}

{ #category : #updating }
AlbTextEditorSegmentHolder >> onCursorAdded [
	"Is sent when text editor's cursor changes.
	Segment holder should update text elements accordingly"
	
	self subclassResponsibility
]

{ #category : #updating }
AlbTextEditorSegmentHolder >> onCursorChanged [
	"Is sent when text editor's cursor changes.
	Segment holder should update text elements accordingly"
	self deprecated: 'not used anymore in Album'.

]

{ #category : #updating }
AlbTextEditorSegmentHolder >> onCursorRemoved [
	"Is sent when text editor's cursor changes.
	Segment holder should update text elements accordingly"
	
	self subclassResponsibility
]

{ #category : #updating }
AlbTextEditorSegmentHolder >> onFocusChanged: aBoolean [
	"Is sent when text editor's focus state changes.
	Segment holder should update text elements accordingly"

	self subclassResponsibility
]

{ #category : #updating }
AlbTextEditorSegmentHolder >> onSelectionChanged [
	"Is sent when text editor's selection changes.
	Segment holder should update text elements accordingly"
	
	self subclassResponsibility
]

{ #category : #updating }
AlbTextEditorSegmentHolder >> onTextChanged [
	"Is sent when text changed in the editor (for example style attributes).
	Segment holder should update text elements accordingly"
	
	self subclassResponsibility
]
