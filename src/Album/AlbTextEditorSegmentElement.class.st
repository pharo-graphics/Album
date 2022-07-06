"
I am a visual element representing a segment. I am hold by SegmentHolder which binds me with a segment.

Users may customize me by changing segment's layout, margin, padding or visual properties such as background or border.

Override me for more advanced customizations
"
Class {
	#name : #AlbTextEditorSegmentElement,
	#superclass : #BlElement,
	#category : #'Album-UI'
}

{ #category : #sparta }
AlbTextEditorSegmentElement >> drawOnSpartaCanvas: aCanvas [

	self parent itemDecorationsDo: [ :decoration | 
		decoration draw: self onSpartaCanvas: aCanvas in: self parent ].
	super drawOnSpartaCanvas: aCanvas.
	self parent itemDecorationsDo: [ :decoration | 
		decoration draw: self onSpartaCanvasOver: aCanvas in: self parent ]
]
