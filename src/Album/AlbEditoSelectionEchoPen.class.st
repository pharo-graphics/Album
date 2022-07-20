Class {
	#name : #AlbEditoSelectionEchoPen,
	#superclass : #AlbEditorFeltPen,
	#instVars : [
		'currentSelectionEchoList'
	],
	#category : #'Album-UI'
}

{ #category : #accessing }
AlbEditoSelectionEchoPen class >> selectionEchoColor [
	^ Color gray alpha: 0.35
]

{ #category : #'mouse handlers' }
AlbEditoSelectionEchoPen >> doubleClickEvent: anEvent [
	super doubleClickEvent: anEvent.
	self shiftSelectionFrom: anEvent currentTarget event: anEvent
]

{ #category : #'mouse handlers' }
AlbEditoSelectionEchoPen >> dragEndEvent: anEvent [
	super dragEndEvent: anEvent.
	self shiftSelectionFrom: anEvent currentTarget event: anEvent
]

{ #category : #'mouse handlers' }
AlbEditoSelectionEchoPen >> dragStartEvent: anEvent [
	super dragStartEvent: anEvent.
	self shiftSelectionFrom: anEvent currentTarget event: anEvent
]

{ #category : #updating }
AlbEditoSelectionEchoPen >> highlight: aPieceElement from: startIdx to: endIdx [

	aPieceElement
		highlightCategory: #selectionEcho
		with: (BlTextParagraphHighlight paint: self class selectionEchoColor from: startIdx to: endIdx).
	currentSelectionEchoList add: aPieceElement
]

{ #category : #initialization }
AlbEditoSelectionEchoPen >> initialize [ 
	super initialize.
	
	currentSelectionEchoList := OrderedCollection new.
	shiftSelect := false
	
]

{ #category : #'mouse handlers' }
AlbEditoSelectionEchoPen >> mouseDownEvent: anEvent [
	super mouseDownEvent: anEvent.
	self shiftSelectionFrom: anEvent currentTarget event: anEvent
]

{ #category : #updating }
AlbEditoSelectionEchoPen >> onScrollDoneIn: anEditor [ 
	super onScrollDoneIn: anEditor.
	self updateSelectionEchoFrom: anEditor
]

{ #category : #updating }
AlbEditoSelectionEchoPen >> resetCurrentSelectionEcho [

	currentSelectionEchoList do: [ :e | e resetHighlightsOfCategory: #selectionEcho ].
	currentSelectionEchoList reset.
]

{ #category : #accessing }
AlbEditoSelectionEchoPen >> shiftSelect: aBoolean [
	shiftSelect := aBoolean
]

{ #category : #updating }
AlbEditoSelectionEchoPen >> shiftSelectionFrom: anEditor event: anEvent [
	shiftSelect := anEvent modifiers isShift.
	self updateSelectionEchoFrom: anEditor
]

{ #category : #updating }
AlbEditoSelectionEchoPen >> updateSelectionEcho: anInterval from: anEditor [

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
AlbEditoSelectionEchoPen >> updateSelectionEchoFrom: anEditor [
	
	| selectedString |
	self resetCurrentSelectionEcho.
	shiftSelect ifFalse: [ ^ self  ].
	anEditor selection ifEmpty: [ ^ self  ].
	selectedString := anEditor selectedText asString.
	self updateSelectionEchoFrom: anEditor withString: selectedString

]

{ #category : #updating }
AlbEditoSelectionEchoPen >> updateSelectionEchoFrom: anEditor withString: aString [
	
	| collector founds currentSelectionInterval subTextOnScreen |
	self resetCurrentSelectionEcho.
	shiftSelect ifFalse: [ ^ self  ].
	subTextOnScreen := anEditor subTextOnScreen.
	aString size >= (subTextOnScreen size // 2) ifTrue: [ ^self ].
	collector := BlIntervalCollector new text: subTextOnScreen asString.
	currentSelectionInterval := anEditor selection from +1 to: anEditor selection to.
	founds := collector searchAll: aString excluding: currentSelectionInterval - subTextOnScreen textOffset.
	founds do: [ :interval | 
		self updateSelectionEcho: interval + subTextOnScreen textOffset from: anEditor ].

]
