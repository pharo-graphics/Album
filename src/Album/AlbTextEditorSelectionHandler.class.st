Class {
	#name : #AlbTextEditorSelectionHandler,
	#superclass : #AlbTextEditorToElementHandler,
	#instVars : [
		'startIndex'
	],
	#category : #'Album-UI-Handlers'
}

{ #category : #'event handling' }
AlbTextEditorSelectionHandler >> dragEndEvent: anEvent [

	anEvent consumed: true.

	anEvent currentTarget: element.
	anEvent sendTo: element.

]

{ #category : #'event handling' }
AlbTextEditorSelectionHandler >> dragEvent: anEvent [

	| anEditor currentIndex from to |
	anEvent consumed: true.

	anEditor := anEvent currentTarget editor.

	currentIndex := anEditor navigator findTextIndexAtScreenPosition: anEvent localPosition ifAbsent: [ ^ self ].

	self assert: [ currentIndex between: 0 and: anEditor text size ] description: [ 
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

	anEvent sendTo: element
]

{ #category : #'event handling' }
AlbTextEditorSelectionHandler >> dragStartEvent: anEvent [
	| anEditor |	
	anEvent consumed: true.

	anEditor := anEvent currentTarget editor.
	anEditor deselecter all deselect.
	
	startIndex := anEditor navigator
		findTextIndexAtScreenPosition: anEvent localPosition
		ifAbsent: [ nil ].
	anEvent currentTarget: element.
	anEvent sendTo: element.
]

{ #category : #'api - accessing' }
AlbTextEditorSelectionHandler >> eventsToHandle [
	^ { BlDragEvent . BlDragStartEvent. BlDragEndEvent}
]
