Class {
	#name : #AlbEditorSelectionEchoPen,
	#superclass : #AlbEditorFeltPen,
	#instVars : [
		'currentEchoList',
		'canHandleEcho'
	],
	#category : #'Album-UI'
}

{ #category : #accessing }
AlbEditorSelectionEchoPen class >> selectionEchoColor [
	^ Color yellow alpha: 0.55
]

{ #category : #accessing }
AlbEditorSelectionEchoPen >> canHandleEcho [
	^ canHandleEcho ifNil: [ canHandleEcho := false ]
]

{ #category : #'mouse handlers' }
AlbEditorSelectionEchoPen >> doubleClickEvent: anEvent [
	super doubleClickEvent: anEvent.
	self updateEchoIn: anEvent currentTarget event: anEvent
]

{ #category : #'mouse handlers' }
AlbEditorSelectionEchoPen >> dragEndEvent: anEvent [
	super dragEndEvent: anEvent.
	self updateEchoIn: anEvent currentTarget event: anEvent
]

{ #category : #'mouse handlers' }
AlbEditorSelectionEchoPen >> dragEvent: anEvent [
	super dragEvent: anEvent.
	self updateEchoIn: anEvent currentTarget event: anEvent
]

{ #category : #'mouse handlers' }
AlbEditorSelectionEchoPen >> dragStartEvent: anEvent [
	super dragStartEvent: anEvent.
	self updateEchoIn: anEvent currentTarget event: anEvent
]

{ #category : #updating }
AlbEditorSelectionEchoPen >> highlight: aPieceElement from: startIdx to: endIdx [

	aPieceElement
		highlightCategory: #selectionEcho
		with: (BlTextParagraphHighlight
				 paint: self class selectionEchoColor
				 from: startIdx
				 to: endIdx).
	currentEchoList add: aPieceElement
]

{ #category : #initialization }
AlbEditorSelectionEchoPen >> initialize [ 
	super initialize.
	
	currentEchoList := OrderedCollection new.
	canHandleEcho := false
	
]

{ #category : #'mouse handlers' }
AlbEditorSelectionEchoPen >> mouseDownEvent: anEvent [
	super mouseDownEvent: anEvent.
	self updateEchoIn: anEvent currentTarget event: anEvent
]

{ #category : #updating }
AlbEditorSelectionEchoPen >> onScrollDoneIn: anEditor [ 
	super onScrollDoneIn: anEditor.
	self updateEchoIn: anEditor
]

{ #category : #updating }
AlbEditorSelectionEchoPen >> resetCurrentEcho [

	currentEchoList do: [ :e | e resetHighlightsOfCategory: #selectionEcho ].
	currentEchoList reset.
]

{ #category : #updating }
AlbEditorSelectionEchoPen >> updateEcho: anInterval in: anEditor [

	| startIdx endIdx |
	startIdx := anInterval first.
	endIdx := anInterval last.
	anEditor
		textPiecesAndTheirElementsWithinIndexInterval: (startIdx to: endIdx)
		do: [ :piece :pieceElement | 
			| first last |
			((piece textStart to: piece textEnd) includesAll: (startIdx to: endIdx))
				ifTrue: [ 
					first := startIdx.
					last := endIdx ]
				ifFalse: [ 
					startIdx > piece textStart
						ifTrue: [ 
							first := startIdx.
							last := piece textEnd ]
						ifFalse: [ 
							first := piece textStart.
							last := endIdx min: piece textEnd ] ].
			self highlight: pieceElement from: first - piece textStart - 1 to: last - piece textStart ]		
	
]

{ #category : #updating }
AlbEditorSelectionEchoPen >> updateEchoIn: anEditor [
	
	| selectedString |
	self resetCurrentEcho.
	canHandleEcho ifFalse: [ ^ self  ].
	anEditor selection ifEmpty: [ ^ self  ].
	selectedString := anEditor selectedText asString.
	self updateEchoIn: anEditor withString: selectedString

]

{ #category : #updating }
AlbEditorSelectionEchoPen >> updateEchoIn: anEditor event: anEvent [
	canHandleEcho := anEvent modifiers isShift.
	self updateEchoIn: anEditor
]

{ #category : #updating }
AlbEditorSelectionEchoPen >> updateEchoIn: anEditor withString: aString [
	
	| collector founds currentSelectionInterval subTextOnScreen |
	subTextOnScreen := anEditor subTextOnScreen.
	aString size >= (subTextOnScreen size // 2) ifTrue: [ ^self ].
	collector := BlIntervalCollector new text: subTextOnScreen asString.
	currentSelectionInterval := anEditor selection from +1 to: anEditor selection to.
	founds := collector searchAll: aString excluding: currentSelectionInterval - subTextOnScreen textOffset.
	founds do: [ :interval | 
		self updateEcho: interval + subTextOnScreen textOffset in: anEditor ].

]
