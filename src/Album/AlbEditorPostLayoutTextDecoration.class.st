Class {
	#name : #AlbEditorPostLayoutTextDecoration,
	#superclass : #Object,
	#instVars : [
		'currentOppositeTextElement',
		'currentExtendedSelectionList',
		'prevSelectedText'
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
	currentExtendedSelectionList := OrderedCollection new
]

{ #category : #updating }
AlbEditorPostLayoutTextDecoration >> refreshExtendedSelectionFrom: anEditor [
	| textOnScreen |
	textOnScreen := self textOnScreenFrom: anEditor.
	prevSelectedText = textOnScreen ifTrue: [ ^self ].
	self updateExtendedSelectionFrom: anEditor.
	prevSelectedText := textOnScreen

]

{ #category : #updating }
AlbEditorPostLayoutTextDecoration >> resetCurrentExtendedSelection [

	currentExtendedSelectionList do: [ :e | e resetExtendedSelectionInterval ].
	currentExtendedSelectionList reset
]

{ #category : #updating }
AlbEditorPostLayoutTextDecoration >> selectionMaxSize [ 
	^ 10000
]

{ #category : #'editor - accessing' }
AlbEditorPostLayoutTextDecoration >> textOnScreenFrom: anEditor [
	^ anEditor textOnScreen
]

{ #category : #updating }
AlbEditorPostLayoutTextDecoration >> updateAfterLayoutFrom: anEditor [

	self updateOppositeFrom: anEditor.
	"self resetCurrentExtendedSelection"
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

	| subtext collector founds |
	
	anEditor selection isEmpty ifTrue: [ ^self ].
	self resetCurrentExtendedSelection.
	anEditor editor selectedText size > self selectionMaxSize ifTrue: [ ^ self ].
	currentExtendedSelectionList reset.
	subtext := self textOnScreenFrom: anEditor.
	collector := BlIntervalCollector new text: subtext asString.
	founds := collector searchAll: anEditor editor selectedText asString excluding: (anEditor selection from + 1 to: anEditor selection to).
	founds do: [ :interval | 
		self updateExtendedSelection: interval + subtext textOffset from: anEditor ].

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
