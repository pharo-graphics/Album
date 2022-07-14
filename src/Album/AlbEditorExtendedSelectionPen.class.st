Class {
	#name : #AlbEditorExtendedSelectionPen,
	#superclass : #AlbEditorFeltPen,
	#instVars : [
		'currentExtendedSelectionList'
	],
	#category : #'Album-UI'
}

{ #category : #'mouse handlers' }
AlbEditorExtendedSelectionPen >> doubleClickEvent: anEvent [
	super doubleClickEvent: anEvent.
	self shiftSelectionFrom: anEvent currentTarget event: anEvent
]

{ #category : #'mouse handlers' }
AlbEditorExtendedSelectionPen >> dragEndEvent: anEvent [
	super dragEndEvent: anEvent.
	self shiftSelectionFrom: anEvent currentTarget event: anEvent
]

{ #category : #'mouse handlers' }
AlbEditorExtendedSelectionPen >> dragStartEvent: anEvent [
	super dragStartEvent: anEvent.
	self shiftSelectionFrom: anEvent currentTarget event: anEvent
]

{ #category : #initialization }
AlbEditorExtendedSelectionPen >> initialize [ 
	super initialize.
	
	currentExtendedSelectionList := OrderedCollection new.
	shiftSelect := false
	
]

{ #category : #'mouse handlers' }
AlbEditorExtendedSelectionPen >> mouseDownEvent: anEvent [
	super mouseDownEvent: anEvent.
	self shiftSelectionFrom: anEvent currentTarget event: anEvent
]

{ #category : #updating }
AlbEditorExtendedSelectionPen >> onScrollDoneIn: anEditor [ 
	super onScrollDoneIn: anEditor.
	self updateExtendedSelectionFrom: anEditor
]

{ #category : #updating }
AlbEditorExtendedSelectionPen >> resetCurrentExtendedSelection [

	currentExtendedSelectionList do: [ :e | e resetExtendedSelectionInterval ].
	currentExtendedSelectionList reset.
]

{ #category : #accessing }
AlbEditorExtendedSelectionPen >> shiftSelect: aBoolean [
	shiftSelect := aBoolean
]

{ #category : #updating }
AlbEditorExtendedSelectionPen >> shiftSelectionFrom: anEditor event: anEvent [
	shiftSelect := anEvent modifiers isShift.
	self updateExtendedSelectionFrom: anEditor
]

{ #category : #updating }
AlbEditorExtendedSelectionPen >> updateExtendedSelection: anInterval from: anEditor [

	| startIdx endIdx |
	startIdx := anInterval first.
	endIdx := anInterval last.
	anEditor
		piecesAndTheirElementsWithinIndexInterval: (startIdx to: endIdx)
		do: [ :piece :pieceElement | 
			piece isText ifTrue: [ 
				| first last |
				((piece textStart to: piece textEnd) includesAll:
					 (startIdx to: endIdx))
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
								last := endIdx < piece textEnd
									        ifTrue: [ endIdx ]
									        ifFalse: [ piece textEnd ] ] ].

				pieceElement extendedSelectionInterval: (first - piece textStart - 1 to: last - piece textStart).
				currentExtendedSelectionList add: pieceElement ] ]
]

{ #category : #updating }
AlbEditorExtendedSelectionPen >> updateExtendedSelectionFrom: anEditor [
	
	| selectedString |
	self resetCurrentExtendedSelection.
	shiftSelect ifFalse: [ ^ self  ].
	anEditor selection ifEmpty: [ ^ self  ].
	selectedString := anEditor selectedText asString.
	self updateExtendedSelectionFrom: anEditor withString: selectedString

]

{ #category : #updating }
AlbEditorExtendedSelectionPen >> updateExtendedSelectionFrom: anEditor withString: aString [
	
	| collector founds currentSelectionInterval subTextOnScreen |
	self resetCurrentExtendedSelection.
	shiftSelect ifFalse: [ ^ self  ].
	subTextOnScreen := anEditor subTextOnScreen.
	aString size >= (subTextOnScreen size // 2) ifTrue: [ ^self ].
	collector := BlIntervalCollector new text: subTextOnScreen asString.
	currentSelectionInterval := anEditor selection from to: anEditor selection to.
	founds := collector searchAll: aString excluding: currentSelectionInterval - subTextOnScreen textOffset.
	founds do: [ :interval | 
		self updateExtendedSelection: interval + subTextOnScreen textOffset from: anEditor ].

]
