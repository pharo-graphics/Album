Class {
	#name : #AlbEditorOppositePen,
	#superclass : #AlbEditorFeltPen,
	#instVars : [
		'currentOppositeTextElement'
	],
	#category : #'Album-UI'
}

{ #category : #updating }
AlbEditorOppositePen >> onLayoutDoneIn: anEditor [ 
	super onLayoutDoneIn: anEditor.
	self updateOppositeFrom: anEditor.

]

{ #category : #updating }
AlbEditorOppositePen >> updateOppositeFrom: anEditor [

	| globalCursorPos subtext localCursorPos |
	currentOppositeTextElement ifNotNil: [ currentOppositeTextElement resetOppositeIndex ].
	globalCursorPos := anEditor cursor position..
	globalCursorPos isZero ifTrue: [ ^ self ].
	subtext := anEditor subTextOnScreen.
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
