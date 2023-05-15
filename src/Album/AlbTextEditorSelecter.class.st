"
When in ""cursor update mode"" I place cursors at the end of each selection
"
Class {
	#name : #AlbTextEditorSelecter,
	#superclass : #AlbTextEditorOperator,
	#instVars : [
		'selection',
		'shouldUpdateCursor',
		'shouldDeselectExisting',
		'commands'
	],
	#category : #'Album-Model-Operators'
}

{ #category : #'api - configuration' }
AlbTextEditorSelecter >> all [
	"Select the whole text"
	
	self
		from: 0
		to: self text size
]

{ #category : #'api - configuration' }
AlbTextEditorSelecter >> all: aCompositeSelection [
	aCompositeSelection do: [ :eachMonotoneSelection |
		self from: eachMonotoneSelection from to: eachMonotoneSelection to ]
]

{ #category : #'api - processing' }
AlbTextEditorSelecter >> apply [
	^ self select
]

{ #category : #'api - configuration' }
AlbTextEditorSelecter >> extendToIndex: anIndex [
	| cursorPosition |
	cursorPosition := self cursor position.
	anIndex > cursorPosition
		ifTrue: [ self from: cursorPosition to: anIndex ]
		ifFalse: [ self from: anIndex to: cursorPosition ]
]

{ #category : #'api - configuration' }
AlbTextEditorSelecter >> extendToLineEnd [
	"Extend selection to the end of the line"
	|  cmd globalCursor delta |

	globalCursor := self cursor.
	delta := (self findTextIndexAtLineEnd: globalCursor) - globalCursor position.
	cmd := (self
			privateExtendSelectionRightAt: globalCursor position
			by: delta) toMoveCursor: globalCursor by: delta.
	
	commands add: cmd
]

{ #category : #'api - configuration' }
AlbTextEditorSelecter >> extendToLineStart [

	"Extend selection to the start of the line"

	| cmd delta globalCursor |

	globalCursor := self cursor.
	delta := globalCursor position
	         - (self findTextIndexAtLineStart: globalCursor).
	cmd := (self
		        privateExtendSelectionLeftAt: globalCursor position
		        by: delta) toMoveCursor: globalCursor by: delta negated.

	commands add: cmd
]

{ #category : #'api - configuration' }
AlbTextEditorSelecter >> extendToNextWordEnd [
	"Extend selection to the end of the next word"
	|  theCommands |

	theCommands := self cursors collect: [ :aCursor |
		| aDelta |
		
		aDelta := (self findWordEndAfter: aCursor position) - aCursor position.
		(self
			privateExtendSelectionRightAt: aCursor position
			by: aDelta)
				toMoveCursor: aCursor
				by: aDelta ].
	
	commands addAll: theCommands
]

{ #category : #'api - configuration' }
AlbTextEditorSelecter >> extendToPreviousWordStart [
	"Extend selection to start of the previous word"
	|  theCommands |

	theCommands := self cursors collect: [ :aCursor |
		| aDelta |
		
		aDelta := aCursor position - (self findWordStartBefore: aCursor position).
		(self
			privateExtendSelectionLeftAt: aCursor position
			by: aDelta)
				toMoveCursor: aCursor
				by: aDelta negated ].
	
	commands addAll: theCommands
]

{ #category : #'api - configuration' }
AlbTextEditorSelecter >> extendToWholeLine [

	"Extend selection to the line"

	self
		extendToLineStart;
		extendToLineEnd
]

{ #category : #private }
AlbTextEditorSelecter >> findExistingSelectionEndAfter: aTextIndex within: aTextInterval [
	| anEndIndex |
	
	anEndIndex := aTextIndex.
	self selection do: [ :eachMonotoneSelection |
		(eachMonotoneSelection to between: aTextInterval first and: aTextInterval last)
			ifTrue: [ anEndIndex := anEndIndex max: eachMonotoneSelection to ].
	
		(eachMonotoneSelection to > aTextInterval last
			and: [ eachMonotoneSelection from <= aTextInterval last ])
				ifTrue: [ anEndIndex := aTextInterval last ] ].

	^ anEndIndex
]

{ #category : #private }
AlbTextEditorSelecter >> findExistingSelectionStartBefore: aTextIndex within: aTextInterval [
	| aStartIndex |
	
	aStartIndex := aTextIndex.
	self selection do: [ :eachMonotoneSelection |
		(eachMonotoneSelection from between: aTextInterval first and: aTextInterval last)
			ifTrue: [ aStartIndex := aStartIndex min: eachMonotoneSelection from ].

		(eachMonotoneSelection from < aTextInterval first
			and: [ eachMonotoneSelection to >= aTextInterval first ])
				ifTrue: [ aStartIndex := aTextInterval first ] ].

	^ aStartIndex
]

{ #category : #'api - configuration' }
AlbTextEditorSelecter >> from: aFromIndex to: aToIndex [

	commands add: (AlbExtendSelectionCommand new 
		editor: editor;
		toSelect: { BlSelection from: aFromIndex to: aToIndex };
		toAddCursor: aToIndex)
]

{ #category : #initialization }
AlbTextEditorSelecter >> initialize [
	super initialize.

	selection := BlCompositeSelection new.
	shouldUpdateCursor := true.
	shouldDeselectExisting := false.
	commands := OrderedCollection new
]

{ #category : #'api - configuration' }
AlbTextEditorSelecter >> moveOneDown [
	"Select and move a cursor one line down"
	| theCommands theNewCursorPositions theCursorsOnTheLeft theCursorsOnTheRight theCursorsOutside |

	theCommands := OrderedCollection new.

	theNewCursorPositions := (self cursors collect: [ :aCursor |
		aCursor -> (self
			findTextIndexBelowCursor: aCursor
			ifAbsent: [
				(self isCursorOnTheLastLine: aCursor)
					ifTrue: [ self text size ]
					ifFalse: [ aCursor position ] ]) ]) as: OrderedIdentityDictionary.

	theCursorsOnTheLeft := self cursors
		select: [ :aCursor | self selection anySatisfy: [ :aSelection | aCursor position = aSelection from ] ].

	theCursorsOnTheRight := self cursors
		select: [ :aCursor | self selection anySatisfy: [ :aSelection | aCursor position = aSelection to ] ].

	theCursorsOutside := self cursors
		select: [ :aCursor | (self selection anySatisfy: [ :aSelection | aCursor position between: aSelection from and: aSelection to ]) not ].

	theCursorsOnTheLeft do: [ :aCursor |
		| aDelta |
		aDelta := (theNewCursorPositions at: aCursor) - aCursor position.
		theCommands add: (AlbExtendSelectionCommand new 
			editor: editor;
			toDeselect: { BlSelection from: aCursor position to: (theNewCursorPositions at: aCursor) };
			toMoveCursor: aCursor by: aDelta) ].

	theCursorsOnTheRight, theCursorsOutside do: [ :aCursor | 
		| aDelta |
		aDelta := ((theNewCursorPositions at: aCursor) min: self text size) - aCursor position.
		theCommands add: (AlbExtendSelectionCommand new 
			editor: editor;
			toSelect: { BlSelection from: aCursor position to: ((theNewCursorPositions at: aCursor) min: self text size) };
			toMoveCursor: aCursor by: aDelta;
			withoutResettingDesiredCoordinate) ].
		
	commands addAll: theCommands.
]

{ #category : #'api - configuration' }
AlbTextEditorSelecter >> moveOneToLeft [
	"Select and move a cursor one character to the left"
	|  theCommands |

	theCommands := self cursors collect: [ :aCursor |
		(self
			privateExtendSelectionLeftAt: aCursor position
			by: 1)
				toMoveCursor: aCursor
				by: -1 ].
			
	commands addAll: theCommands
]

{ #category : #'api - configuration' }
AlbTextEditorSelecter >> moveOneToRight [
	"Select and move a cursor one character to the right"
	|  theCommands |

	theCommands := self cursors collect: [ :aCursor |
		(self
			privateExtendSelectionRightAt: aCursor position
			by: 1)
				toMoveCursor: aCursor
				by: 1 ].
	
	commands addAll: theCommands
]

{ #category : #'api - configuration' }
AlbTextEditorSelecter >> moveOneUp [
	"Select and move a cursor one line up"
	| theNewCursorPositions theCursorsOnTheLeft theCursorsOnTheRight theCursorsOutside theCommands |
	
	theCommands := OrderedCollection new.
	theNewCursorPositions := (self cursors collect: [ :aCursor |
		aCursor -> (self
			findTextIndexAboveCursor: aCursor
			ifAbsent: [
				(self isCursorOnTheFirstLine: aCursor)
					ifTrue: [ 0 ]
					ifFalse: [ aCursor position ] ]) ]) as: OrderedIdentityDictionary.

	theCursorsOnTheLeft := self cursors
		select: [ :aCursor | self selection anySatisfy: [ :aSelection | aCursor position = aSelection from ] ].
		
	theCursorsOnTheRight := self cursors
		select: [ :aCursor | self selection anySatisfy: [ :aSelection | aCursor position = aSelection to ] ].
	
	theCursorsOutside := self cursors
		select: [ :aCursor | (self selection anySatisfy: [ :aSelection | aCursor position between: aSelection from and: aSelection to ]) not ].

	"the cursor is on the right side of the selection, we should deselect from the new potential position to its current location"
	theCursorsOnTheRight do: [ :aCursor |
		| aDelta |
		aDelta := aCursor position - (theNewCursorPositions at: aCursor).
		theCommands add: (AlbExtendSelectionCommand new 
			editor: editor;
			toDeselect: { BlSelection from: (theNewCursorPositions at: aCursor) to: aCursor position };
			toMoveCursor: aCursor by: aDelta negated) ].
	
	"the cursor is on the left side of the selection or is not inside any selection, we should extend it to the new potential location"
	theCursorsOnTheLeft, theCursorsOutside do: [ :aCursor | 
		| aDelta |
		aDelta := aCursor position - (theNewCursorPositions at: aCursor).
		theCommands add: (AlbExtendSelectionCommand new 
			editor: editor;
			toSelect: { BlSelection from: (theNewCursorPositions at: aCursor) to: aCursor position };
			toMoveCursor: aCursor by: aDelta negated;
			withoutResettingDesiredCoordinate) ].

	commands addAll: theCommands.
]

{ #category : #'api - configuration' }
AlbTextEditorSelecter >> overwrite [
	"Deselect any selections if they exist and overwrite with the new selection"
	
	shouldDeselectExisting := true
]

{ #category : #private }
AlbTextEditorSelecter >> privateDeselectExisting: aSelection [
	| aDeselecter |
	
	aSelection isEmpty
		ifTrue: [ ^ self ].

	aDeselecter := editor deselecter.	
	aSelection do: [ :eachMonotoneSelection | aDeselecter from: eachMonotoneSelection from to: eachMonotoneSelection to ].
	aDeselecter deselect
]

{ #category : #private }
AlbTextEditorSelecter >> privateExtendSelectionLeftAt: aTextPosition by: anAmount [
	| hasSelectionAfter toSelect toDeselect aNewSelectionStart |

	self
		assert: [ aTextPosition >= 0 ]
		description: [ 'Text position must not be negative' ].

	self
		assert: [ aTextPosition <= self text size ]
		description: [ 'Text position must not exceed text size' ].

	self
		assert: [ anAmount >= 0 ]
		description: [ 'Amount must not be negative' ].

	toSelect := OrderedCollection new.
	toDeselect := OrderedCollection new.

	hasSelectionAfter := self selection
		anySatisfy: [ :eachMonotoneSelection |
			(eachMonotoneSelection from <= aTextPosition)
				and: [ eachMonotoneSelection to > aTextPosition ] ].

	aNewSelectionStart := (aTextPosition - anAmount) max: 0.
	self
		assert: [ aNewSelectionStart >= 0 ]
		description: [ 'Selection start must not be less than 0' ].

	hasSelectionAfter
		ifTrue: [ toSelect add: (BlSelection from: aNewSelectionStart to: aTextPosition) ]
		ifFalse: [
			| aSelectionStart aSelectionEnd |
			aSelectionEnd := self
				findExistingSelectionStartBefore: aTextPosition
				within: (aNewSelectionStart to: aTextPosition).
			
			aSelectionEnd = aTextPosition
				ifFalse: [ toDeselect add: (BlSelection from: aSelectionEnd to: aTextPosition) ].
				
			aSelectionStart := aNewSelectionStart.
			
			aSelectionStart < aSelectionEnd
				ifTrue: [ toSelect add: (BlSelection from: aSelectionStart to: aSelectionEnd) ] ].

	^ AlbExtendSelectionCommand new 
		editor: editor;
		toSelect: toSelect;
		toDeselect: toDeselect
]

{ #category : #private }
AlbTextEditorSelecter >> privateExtendSelectionRightAt: aTextPosition by: anAmount [
	| hasSelectionBefore toSelect toDeselect aNewSelectionEnd |

	self
		assert: [ aTextPosition >= 0 ]
		description: [ 'Text position must not be negative' ].
		
	self
		assert: [ aTextPosition <= self text size ]
		description: [ 'Text position must not exceed text size' ].
		
	self
		assert: [ anAmount >= 0 ]
		description: [ 'Amount must not be negative' ].

	toSelect := OrderedCollection new.
	toDeselect := OrderedCollection new.

	hasSelectionBefore := self selection
		anySatisfy: [ :eachMonotoneSelection |
			(eachMonotoneSelection from < aTextPosition)
				and: [ eachMonotoneSelection to >= aTextPosition ] ].

	aNewSelectionEnd := (aTextPosition + anAmount) min: self text size.
	self
		assert: [ aNewSelectionEnd <= self text size ]
		description: [ 'Selection end must not exceed text size' ].

	hasSelectionBefore
		ifTrue: [ toSelect add: (BlSelection from: aTextPosition to: aNewSelectionEnd) ]
		ifFalse: [
			| aSelectionStart aSelectionEnd |
			aSelectionStart := self
				findExistingSelectionEndAfter: aTextPosition
				within: (aTextPosition to: aNewSelectionEnd).
			
			aSelectionStart = aTextPosition
				ifFalse: [ toDeselect add: (BlSelection from: aTextPosition to: aSelectionStart) ].
				
			aSelectionEnd := aNewSelectionEnd.
			
			aSelectionStart = aSelectionEnd
				ifFalse: [ toSelect add: (BlSelection from: aSelectionStart to: aSelectionEnd) ] ].

	^ AlbExtendSelectionCommand new 
		editor: editor;
		toSelect: toSelect;
		toDeselect: toDeselect
]

{ #category : #private }
AlbTextEditorSelecter >> privateFrom: aFromIndex to: aToIndex [

	aFromIndex = aToIndex
		ifTrue: [ ^ self ].

	selection select: aFromIndex to: aToIndex
]

{ #category : #private }
AlbTextEditorSelecter >> privatePerformSelectAndDeselectCommands: theCommands [
	| aDeselecter  |

	aDeselecter := editor deselecter.

	theCommands do: [ :aCommand |
		aCommand toDeselectDo: [ :eachSelectionToDeselect |
			aDeselecter
				from: eachSelectionToDeselect from
				to: eachSelectionToDeselect to ] ].
	aDeselecter deselect.

	theCommands do: [ :aCommand |
		aCommand toSelectDo: [ :eachSelectionToSelect |
			self
				privateFrom: eachSelectionToSelect from
				to: eachSelectionToSelect to ] ].
	
	shouldUpdateCursor
		ifFalse: [ ^ self ].
	
	theCommands do: [ :aCommand |
		| aNavigator |
		aNavigator := editor navigator.
		aNavigator dueTo: self.
		
		aCommand shouldResetDesiredCoordinate
			ifTrue: [ aNavigator withResettingDesiredCoordinate ]
			ifFalse: [ aNavigator withoutResettingDesiredCoordinate ].
		
		aCommand toMoveCursorDo: [ :eachCursor :anAmount |
			aNavigator move: eachCursor by: anAmount ].
		aCommand toAddCursorDo: [ :aCursorPosition |
			aNavigator moveTo: aCursorPosition ].
		"aCommand toRemoveCursorsDo: [ :aCursor |
			aNavigator remove: aCursor ]".
		aNavigator apply ].
]

{ #category : #private }
AlbTextEditorSelecter >> privateSelect: aFromTextIndex to: aToTextIndex [
	"Select text within an interval defined by provided from and to indices without any other side effects.
	Note:
		- I don't change cursor position.
		- I request segments update"
	| aCommand |
	
	self
		assert: [ aFromTextIndex < aToTextIndex ]
		description: [ 'Must select at least one character' ].

	self
		assert: [ aFromTextIndex between: 0 and: self text size ]
		description: [ 'Selection start index ({1}) must be within text bounds {2}' format: { aFromTextIndex . 0 to: self text size } ].
	self
		assert: [ aToTextIndex between: 0 and: self text size ]
		description: [ 'Selection end index ({1}) must be within text bounds {2}' format: { aToTextIndex . 0 to: self text size } ].
	
	aCommand := AlbTextEditorSelectCommand new
		fromIndex: aFromTextIndex;
		toIndex: aToTextIndex.
	editor executeCommand: aCommand
]

{ #category : #'api - processing' }
AlbTextEditorSelecter >> select [

	| toBeSelected |

	self privatePerformSelectAndDeselectCommands: commands.
	commands removeAll.

	shouldDeselectExisting ifTrue: [ 
		| toBeDeselected |
		toBeDeselected := self selection copy.
		selection do: [ :aMonotoneSelection | toBeDeselected deselect: aMonotoneSelection from to: aMonotoneSelection to ].
		self privateDeselectExisting: toBeDeselected ].

	toBeSelected := selection copy.
	self selection do: [ :aMonotoneSelection | toBeSelected deselect: aMonotoneSelection from to: aMonotoneSelection to ].

	toBeSelected do: [ :aMonotoneSelection | 
		aMonotoneSelection interval size > 1 ifTrue: [ self privateSelect: aMonotoneSelection from to: aMonotoneSelection to ] ].
	
	selection ifNotEmpty: [ self notifyCursorRemoved: self cursor ]
	
	" do not send updateCursors to self here otherwise, navigator moveUp is broken " 
]

{ #category : #private }
AlbTextEditorSelecter >> updateCursors [
	| aNavigator |
	
	aNavigator := editor navigator.
	aNavigator dueTo: self.
	self selection do: [ :aMonotoneSelection | aNavigator addAt: aMonotoneSelection to ].
	aNavigator apply
]

{ #category : #'api - configuration' }
AlbTextEditorSelecter >> withoutCursorUpdate [
	shouldUpdateCursor := false
]

{ #category : #'api - configuration' }
AlbTextEditorSelecter >> wordAt: aTextIndex [
	"Select a word or a whitespace at a given text index"
	| aWordInterval |
	
	aWordInterval := self findWordAt: aTextIndex.
	self from: aWordInterval first to: aWordInterval last
]
