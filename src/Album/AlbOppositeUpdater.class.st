Class {
	#name : #AlbOppositeUpdater,
	#superclass : #Object,
	#instVars : [
		'currentOppositeTextElement',
		'extentChangeHandler',
		'cursorMoveHandler',
		'scrollHandler'
	],
	#category : #'Album-UI'
}

{ #category : #'opposite highlighting' }
AlbOppositeUpdater >> cursorMovedIn: anEditorElement [

	self updateOppositeFrom: anEditorElement
]

{ #category : #'infinite element changes' }
AlbOppositeUpdater >> extentChangedIn: anInfiniteElement [

	self updateOppositeFrom: anInfiniteElement
]

{ #category : #'opposite highlighting' }
AlbOppositeUpdater >> highlightOpposite: aPieceElement from: startIdx to: endIdx [

	aPieceElement
		highlightCategory: #opposite
		with: (BlTextParagraphHighlight paint: self oppositeBackgroundColor from: startIdx to: endIdx).
	currentOppositeTextElement := aPieceElement
]

{ #category : #'api - install/uninstall  hook' }
AlbOppositeUpdater >> onInstalledIn: anEditorElement [

	extentChangeHandler := BlEventHandler
		                       on: BlElementExtentChangedEvent
		                       do: [ :evt | 
		                       self extentChangedIn: anEditorElement ].
	cursorMoveHandler := BlEventHandler
		                     on: AlbCursorMovedEvent
		                     do: [ :evt | 
		                     self cursorMovedIn: anEditorElement ].
	scrollHandler := BlEventHandler
		                 on: BlElementScrolledEvent
		                 do: [ :evt | self scrollEventIn: anEditorElement ].

	anEditorElement addEventHandler: extentChangeHandler.
	anEditorElement editor addEventHandler: cursorMoveHandler.
	anEditorElement infinite addEventHandler: scrollHandler
]

{ #category : #'api - install/uninstall  hook' }
AlbOppositeUpdater >> onUninstalledIn: anEditorElement [

	anEditorElement removeEventHandler: extentChangeHandler.
	anEditorElement editor removeEventHandler: cursorMoveHandler.
	anEditorElement infinite removeEventHandler: scrollHandler
]

{ #category : #accessing }
AlbOppositeUpdater >> oppositeBackgroundColor [

	^ Color gray alpha: 0.5
]

{ #category : #'infinite element changes' }
AlbOppositeUpdater >> scrollEventIn: anInfiniteElement [

	self updateOppositeFrom: anInfiniteElement
]

{ #category : #'opposite highlighting' }
AlbOppositeUpdater >> updateOppositeFrom: anEditorElement [

	| globalCursorPos subtext localCursorPos |
	
	currentOppositeTextElement ifNotNil: [ 
		currentOppositeTextElement resetHighlightsOfCategory: #opposite.
		currentOppositeTextElement := nil ].
	globalCursorPos := anEditorElement cursor position.
	globalCursorPos isZero ifTrue: [ ^ self ].
	subtext := anEditorElement subTextOnScreen.
	((subtext start to: subtext end) includes: globalCursorPos) ifFalse: [ ^ self ].
	localCursorPos := globalCursorPos - subtext textOffset.
	anEditorElement editor limitedSurroundMap
		intervalBetweenDelimitersIn: subtext
		at: localCursorPos
		ifPresent: [ :interval | "before  close delimiter"
			interval first = localCursorPos ifFalse: [ 
				anEditorElement
					atTextIndex: interval first + subtext start - 1
					do: [ :oppositeTextElement :localIdx | 
						localIdx isZero ifFalse: [ 
							^ self highlightOpposite: oppositeTextElement from: localIdx - 1 to: localIdx ] ] ].
			"after open delimiter"
			interval last = localCursorPos ifFalse: [ 
				anEditorElement atTextIndex: interval last + subtext start do: [ :oppositeTextElement :localIdx | 
					localIdx isZero ifFalse: [ 
						^ self highlightOpposite: oppositeTextElement from: localIdx - 1 to: localIdx ] ] ] ]
		ifAbsent: [  ]
]
