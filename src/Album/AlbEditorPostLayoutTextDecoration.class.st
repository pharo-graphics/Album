Class {
	#name : #AlbEditorPostLayoutTextDecoration,
	#superclass : #Object,
	#instVars : [
		'currentOppositeTextElement',
		'currentExtendedSelectionList',
		'shiftSelect'
	],
	#category : #'Album-UI'
}

{ #category : #'editor - accessing' }
AlbEditorPostLayoutTextDecoration >> globalCursorPosFrom: anEditor [
	^ anEditor cursor position.
]

{ #category : #initialization }
AlbEditorPostLayoutTextDecoration >> initialize [ 
	super initialize.
	
	self flag: 'review to make it a model that keeps track of selection and of current text on screen'.
	currentExtendedSelectionList := OrderedCollection new.
	shiftSelect := false
	
]

{ #category : #updating }
AlbEditorPostLayoutTextDecoration >> resetCurrentExtendedSelection [

	currentExtendedSelectionList do: [ :e | e resetExtendedSelectionInterval ].
	currentExtendedSelectionList reset.
]

{ #category : #updating }
AlbEditorPostLayoutTextDecoration >> shiftSelectionFrom: anEditor event: anEvent [
	shiftSelect := anEvent modifiers isShift.
	self updateExtendedSelectionFrom: anEditor
]

{ #category : #'editor - accessing' }
AlbEditorPostLayoutTextDecoration >> textOnScreenFrom: anEditor [
	^ anEditor textOnScreen
]

{ #category : #updating }
AlbEditorPostLayoutTextDecoration >> updateAfterLayoutFrom: anEditor [

	self updateOppositeFrom: anEditor.
	self updateExtendedSelectionFrom: anEditor
]

{ #category : #updating }
AlbEditorPostLayoutTextDecoration >> updateExtendedSelection: anInterval from: anEditor [

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
AlbEditorPostLayoutTextDecoration >> updateExtendedSelectionFrom: anEditor [
	
	| collector founds currentSelectionInterval selectedString subTextOnScreen |
	self resetCurrentExtendedSelection.
	shiftSelect ifFalse: [ ^ self  ].
	anEditor selection ifEmpty: [ ^ self  ].
	selectedString := anEditor editor selectedText asString.
	subTextOnScreen := self textOnScreenFrom: anEditor.
	selectedString size >= (subTextOnScreen size // 2) ifTrue: [ ^self ].
	collector := BlIntervalCollector new text: subTextOnScreen asString.
	currentSelectionInterval := anEditor selection from to: anEditor selection to.
	founds := collector searchAll: selectedString excluding: currentSelectionInterval - subTextOnScreen textOffset.
	founds do: [ :interval | 
		self updateExtendedSelection: interval + subTextOnScreen textOffset from: anEditor ].

]

{ #category : #updating }
AlbEditorPostLayoutTextDecoration >> updateOppositeFrom: anEditor [

	| globalCursorPos subtext localCursorPos |
	currentOppositeTextElement ifNotNil: [ currentOppositeTextElement resetOppositeIndex ].
	globalCursorPos := self globalCursorPosFrom: anEditor.
	globalCursorPos isZero ifTrue: [ ^ self ].
	subtext := self textOnScreenFrom: anEditor.
	((subtext start to: subtext end) includes: globalCursorPos) ifFalse: [ ^ self ].
	localCursorPos := globalCursorPos - subtext textOffset.
	anEditor editor limitedSurroundMap
		intervalBetweenDelimitersIn: subtext
		at: localCursorPos
		ifPresent: [ :interval | 
			"before  close delimiter"
			interval first = localCursorPos ifFalse: [ 
				anEditor
					atTextIndex: interval first + subtext start - 1
					do: [ :oppositeTextElement :localIdx | 
						localIdx isZero ifFalse: [ 
							oppositeTextElement oppositeIndex: localIdx.
							currentOppositeTextElement := oppositeTextElement.
							^ self ] ] ].
			"after open delimiter"
			interval last = localCursorPos ifFalse: [ 
				anEditor
					atTextIndex: interval last + subtext start
					do: [ :oppositeTextElement :localIdx | 
						localIdx isZero ifFalse: [ 
							oppositeTextElement oppositeIndex: localIdx.
							currentOppositeTextElement := oppositeTextElement.
							^ self ] ] ] ]
		ifAbsent: [  ].

]
