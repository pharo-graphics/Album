"
I am a visual element representing a segment. I am hold by SegmentHolder which binds me with a segment.

Users may customize me by changing segment's layout, margin, padding or visual properties such as background or border.

Override me for more advanced customizations
"
Class {
	#name : #AlbTextEditorSegmentElement,
	#superclass : #BlElement,
	#category : 'Album-UI'
}

{ #category : #initialization }
AlbTextEditorSegmentElement >> initialize [ 
	super initialize.
	self clipChildren: false
]

{ #category : #'api - compositing' }
AlbTextEditorSegmentElement >> wantsSeparateCompositingLayer [

	^ false
]
