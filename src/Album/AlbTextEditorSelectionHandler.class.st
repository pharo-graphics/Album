Class {
	#name : #AlbTextEditorSelectionHandler,
	#superclass : #BlCustomEventHandler,
	#instVars : [
		'startIndex'
	],
	#category : #'Album-UI-Handlers'
}

{ #category : #'dnd handlers' }
AlbTextEditorSelectionHandler >> dragEndEvent: anEvent [

	| anEditorElement |
	anEvent consumed: true.

	anEditorElement := anEvent currentTarget
		                   withAllParentsDetect: [ :anElement | 
		                   anElement isKindOf: AlbEditorElement ]
		                   ifFound: #yourself
		                   ifNone: [ ^ self ].
	anEvent currentTarget: anEditorElement.
	anEvent sendTo: anEditorElement.

]

{ #category : #'dnd handlers' }
AlbTextEditorSelectionHandler >> dragEvent: anEvent [

	| anEditor currentIndex from to anEditorElement |
	anEvent consumed: true.

	anEditorElement := anEvent currentTarget
		                   withAllParentsDetect: [ :anElement | 
		                   anElement isKindOf: AlbEditorElement ]
		                   ifFound: #yourself
		                   ifNone: [ ^ self ].

	anEditor := anEvent currentTarget editor.

	currentIndex := anEditor navigator
		                findTextIndexAtScreenPosition: anEvent localPosition
		                ifAbsent: [ ^ self ].

	self
		assert: [ currentIndex between: 0 and: anEditor text size ]
		description: [ 
			'Text index ({1}) must be within text bounds {2}' format: { 
					currentIndex.
					(0 to: anEditor text size) } ].

	startIndex ifNil: [ startIndex := currentIndex ].

	from := startIndex min: currentIndex.
	to := startIndex max: currentIndex.
	anEditor selecter
		overwrite;
		from: from to: to;
		select.
	"Update the cursor position when dragging from right to left. This is added to force layout then to update the selection on the editor element"
	startIndex = anEditor cursor position ifTrue: [ 
		anEditor navigator
			moveTo: from;
			apply ].

]

{ #category : #'dnd handlers' }
AlbTextEditorSelectionHandler >> dragStartEvent: anEvent [
	| anEditor anEditorElement |	
	anEvent consumed: true.

	anEditor := anEvent currentTarget editor.
	anEditor deselecter all deselect.
	
	startIndex := anEditor navigator
		findTextIndexAtScreenPosition: anEvent localPosition
		ifAbsent: [ nil ].
	anEditorElement := anEvent currentTarget
		                   withAllParentsDetect: [ :anElement | 
		                   anElement isKindOf: AlbEditorElement ]
		                   ifFound: #yourself
		                   ifNone: [ ^ self ].
	anEvent currentTarget: anEditorElement.
	anEvent sendTo: anEditorElement.
]

{ #category : #'api - accessing' }
AlbTextEditorSelectionHandler >> eventsToHandle [
	^ { BlDragEvent . BlDragStartEvent. BlDragEndEvent}
]
