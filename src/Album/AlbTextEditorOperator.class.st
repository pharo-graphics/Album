Class {
	#name : 'AlbTextEditorOperator',
	#superclass : 'Object',
	#instVars : [
		'editor',
		'subscriptions',
		'context'
	],
	#category : 'Album-Model-Operators',
	#package : 'Album',
	#tag : 'Model-Operators'
}

{ #category : 'api - processing' }
AlbTextEditorOperator >> apply [
	^ self subclassResponsibility 
]

{ #category : 'private - asserting' }
AlbTextEditorOperator >> assertUIProcess [
	editor assertUIProcess
]

{ #category : 'private' }
AlbTextEditorOperator >> characterType: aCharacter [
	<return: #Symbol>

	(self isWordChar: aCharacter)
		ifTrue: [ ^ #word ].

	aCharacter isSeparator
		ifTrue: [ ^ #separator ].

	^ #other
]

{ #category : 'accessing' }
AlbTextEditorOperator >> context [
	^ context
]

{ #category : 'accessing' }
AlbTextEditorOperator >> context: anObject [
	"An object that understands #telemetry message"
	context := anObject
]

{ #category : 'accessing' }
AlbTextEditorOperator >> cursor [
	^ editor cursor
]

{ #category : 'accessing' }
AlbTextEditorOperator >> cursor: aCursor [
	editor cursor: aCursor
]

{ #category : 'accessing' }
AlbTextEditorOperator >> cursors [

	^  { self cursor } asSet
]

{ #category : 'accessing' }
AlbTextEditorOperator >> editor [
	^ editor
]

{ #category : 'accessing' }
AlbTextEditorOperator >> editor: aTextEditor [

	editor := aTextEditor
]

{ #category : 'private' }
AlbTextEditorOperator >> findLineEndAfter: aTextIndex [
	<return: #Number>
	| aText aTextIterator foundLineBreak |

	aText := self text.
	aTextIterator := aText iterator: aTextIndex to: aText size.

	"if we have a line break after cursor - do nothing"
	(aTextIterator hasNext and: [ aTextIterator peek isLineBreak ])
		ifTrue: [ ^ aTextIndex ].

	foundLineBreak := false.
	[ aTextIterator hasNext and: [ (foundLineBreak := aTextIterator next isLineBreak) not ] ] whileTrue.

	^ aTextIterator position - foundLineBreak asBit
]

{ #category : 'private' }
AlbTextEditorOperator >> findLineStartBefore: aTextIndex [
	"Please note, I return 0 for the first line"
	<return: #Number>
	| aText aTextIterator foundLineBreak |

	aText := self text.
	
	self
		assert: [ aTextIndex <= aText size ]
		description: [ 'Text index must not exceed text size' ].

	aTextIterator := aText iterator: (1 min: aText size) to: aTextIndex.
	aTextIterator skip: ((aTextIndex - 1) max: 0).

	"if we have a line break before aTextIndex"
	(aTextIterator hasPrevious and: [ aTextIterator peer isLineBreak ])
		ifTrue: [ ^ aTextIndex - 1 ].

	foundLineBreak := false.
	[ aTextIterator hasPrevious and: [ (foundLineBreak := aTextIterator previous isLineBreak) not ] ] whileTrue.

	^ aTextIterator position + foundLineBreak asBit
]

{ #category : 'private' }
AlbTextEditorOperator >> findLineStartsBetween: aTextStart and: aTextEnd [
	<return: #Number>
	| aText aTextIterator |

	aText := self text.
	aTextIterator := aText iterator: aTextStart to: aTextEnd.
	
	^ Array streamContents: [ :aStream |
		[ aTextIterator hasNext ] whileTrue: [
			aTextIterator next isLineBreak
				ifTrue: [ aStream nextPut: aTextIterator position ] ] ]
]

{ #category : 'api - utility' }
AlbTextEditorOperator >> findTextIndexAboveCursor: aCursor ifAbsent: anExceptionBlock [
	"Find a text index one line above the given cursor"
	<return: #Number>
	| aTransformation aGlobalTextIndex |
	
	aGlobalTextIndex := nil.

	aTransformation := AlbTextEditorRelativeScreenToCursorTransformation new
		cursor: aCursor;
		beUp;
		whenTransformed: [ :aTextIndex | aGlobalTextIndex := aTextIndex ].

	editor executeCommand: (AlbTextEditorScreenToCursorCommand new transformation: aTransformation).
	
	^ aGlobalTextIndex
		ifNotNil: [ aGlobalTextIndex ]
		ifNil: anExceptionBlock
]

{ #category : 'api - utility' }
AlbTextEditorOperator >> findTextIndexAtCursor: aCursor ifAbsent: anExceptionBlock [
	"Find a text index one line below the given cursor"
	<return: #Number>
	| aTransformation aGlobalTextIndex |
	
	aGlobalTextIndex := nil.

	aTransformation := AlbTextEditorRelativeScreenToCursorTransformation new
		cursor: aCursor;
		whenTransformed: [ :aTextIndex | aGlobalTextIndex := aTextIndex ].
	
	editor executeCommand: (AlbTextEditorScreenToCursorCommand new transformation: aTransformation).
	
	aGlobalTextIndex
		ifNotNil: [ ^ aGlobalTextIndex ]
		ifNil: [ self flag: 'Until I figure out why it can be nil'. ^ anExceptionBlock value ].
	
	"could not find a text index for a given screen position"
	self
		assert: [ aGlobalTextIndex isNotNil ]
		description: [ 'There must always be some text index found' ].
		
	^ aGlobalTextIndex
]

{ #category : 'api - utility' }
AlbTextEditorOperator >> findTextIndexAtLineEnd: aCursor [
	"Find a text index at the end of the line where the cursor is located"
	<return: #Number>
	| aText aTextIterator foundLineBreak |
	
	aText := self text.
	aTextIterator := aText iterator: aCursor position + 1 to: aText size.

	"if we have a line break after cursor - do nothing"
	(aTextIterator hasNext and: [ aTextIterator peek isLineBreak ])
		ifTrue: [ ^ aCursor position ].

	foundLineBreak := false.
	[ aTextIterator hasNext and: [ (foundLineBreak := aTextIterator next isLineBreak) not ] ] whileTrue.

	^ aTextIterator position - foundLineBreak asBit
]

{ #category : 'api - utility' }
AlbTextEditorOperator >> findTextIndexAtLineStart: aCursor [
	"Find a text index at the start of the line where the cursor is located"
	<return: #Number>
	| aText aTextIterator foundLineBreak |
	
	aText := self text.
	aTextIterator := aText iterator: 1 to: aCursor position.
	aTextIterator skip: aCursor position.

	"if we have a line break before cursor - do nothing"
	(aTextIterator hasPrevious
		and: [ (aTextIterator previous; hasPrevious)
			and: [ aTextIterator peek isLineBreak ] ])
		ifTrue: [ ^ aCursor position ].

	foundLineBreak := false.
	[ aTextIterator hasPrevious and: [ (foundLineBreak := aTextIterator previous isLineBreak) not ] ] whileTrue.

	^ aTextIterator position + foundLineBreak asBit
]

{ #category : 'api - utility' }
AlbTextEditorOperator >> findTextIndexAtScreenPosition: aScreenPosition [
	"Convert screen position to a text index"
	<return: #Number>
	| aTransformation aGlobalTextIndex |
	
	aGlobalTextIndex := nil.

	aTransformation := AlbTextEditorExplicitScreenToCursorTransformation new screenPosition: aScreenPosition.
	aTransformation whenTransformed: [ :aTextIndex | aGlobalTextIndex := aTextIndex ].
	
	editor executeCommand: (AlbTextEditorScreenToCursorCommand new transformation: aTransformation).
	
	"could not find a text index for a given screen position"
	self
		assert: [ aGlobalTextIndex isNotNil ]
		description: [ 'There must always be some text index found' ].
		
	^ aGlobalTextIndex
]

{ #category : 'api - utility' }
AlbTextEditorOperator >> findTextIndexAtScreenPosition: aScreenPosition ifAbsent: anExceptionBlock [
	"Convert screen position to a text index"
	<return: #Number>
	| aTransformation aGlobalTextIndex |
	
	aGlobalTextIndex := nil.

	aTransformation := AlbTextEditorExplicitScreenToCursorTransformation new screenPosition: aScreenPosition.
	aTransformation whenTransformed: [ :aTextIndex | aGlobalTextIndex := aTextIndex ].
	
	editor executeCommand: (AlbTextEditorScreenToCursorCommand new transformation: aTransformation).
	
	aGlobalTextIndex
		ifNotNil: [ ^ aGlobalTextIndex ]
		ifNil: [ self flag: 'Until I figure out why it can be nil'. ^ anExceptionBlock value ].
	
	"could not find a text index for a given screen position"
	self
		assert: [ aGlobalTextIndex isNotNil ]
		description: [ 'There must always be some text index found' ].
		
	^ aGlobalTextIndex
]

{ #category : 'api - utility' }
AlbTextEditorOperator >> findTextIndexBelowCursor: aCursor ifAbsent: anExceptionBlock [
	"Find a text index one line below the given cursor"
	<return: #Number>
	| aTransformation aGlobalTextIndex |
	
	aGlobalTextIndex := nil.

	aTransformation := AlbTextEditorRelativeScreenToCursorTransformation new
		cursor: aCursor;
		beDown;
		whenTransformed: [ :aTextIndex | aGlobalTextIndex := aTextIndex ].
	
	editor executeCommand: (AlbTextEditorScreenToCursorCommand new transformation: aTransformation).
	
	aGlobalTextIndex
		ifNotNil: [ ^ aGlobalTextIndex ]
		ifNil: [ self flag: 'Until I figure out why it can be nil'. ^ anExceptionBlock value ].
	
	"could not find a text index for a given screen position"
	self
		assert: [ aGlobalTextIndex isNotNil ]
		description: [ 'There must always be some text index found' ].
		
	^ aGlobalTextIndex
]

{ #category : 'private' }
AlbTextEditorOperator >> findWhitespaceOfLineBefore: aTextIndex [

	<return: #String>
	| aLineStartIndex aText aTextIterator sp |
	aText := self text.
	aText ifEmpty: [ ^ '' ].
	(aText at: (aTextIndex max: 1)) isLineBreak ifTrue: [ ^ '' ].

	aLineStartIndex := (self findLineStartBefore: aTextIndex) + aText size isZero not asBit.

	aTextIterator := aText iterator: aLineStartIndex to: aTextIndex.

	sp := ''.
	[ aTextIterator hasNext and: [ aTextIterator peek = Character tab or: [ aTextIterator peek = Character space ] ] ] 
		whileTrue: [ 
			sp := sp, aTextIterator peek asString.
			aTextIterator next ].

	^ sp
]

{ #category : 'private' }
AlbTextEditorOperator >> findWordAt: aTextIndex [
	"Find a word text interval or a whitespace at a given text index"
	<return: #Interval>
	| aTextIterator hasWordToTheLeft hasWordToTheRight shouldBeWord aWordStart aWordEnd aDesiredType |
	
	aTextIterator := self text iterator skip: aTextIndex.
	
	hasWordToTheLeft := aTextIterator hasPrevious and: [ self isWordChar: aTextIterator peer ].
	hasWordToTheRight := aTextIterator hasNext and: [ self isWordChar: aTextIterator peek ].
	shouldBeWord := hasWordToTheLeft or: hasWordToTheRight.

	aWordStart := aTextIndex.
	aWordEnd := aTextIndex.

	aTextIterator hasNext ifTrue: [
		aTextIterator
			nextSegment: [ :eachCharacter | self characterType: eachCharacter ]
			indicesDo: [ :aStart :anEnd :aType |
				aDesiredType := aType.
				(shouldBeWord not or: [ (aType = #word and: [ shouldBeWord ]) ])
					ifTrue: [ aWordEnd := anEnd ] ] ].
	
	aTextIterator := self text iterator skip: aTextIndex.
	aTextIterator hasPrevious ifTrue: [
		aTextIterator
			previousSegment: [ :eachCharacter | self characterType: eachCharacter ]
			indicesDo: [ :aStart :anEnd :aType |
				((aType = #word and: [ shouldBeWord ]) or: [ (aDesiredType isNil or: [ aType = aDesiredType ] ) ])
					ifTrue: [ aWordStart := aStart ] ] ].

	^ aWordStart to: aWordEnd
]

{ #category : 'private' }
AlbTextEditorOperator >> findWordEndAfter: aTextIndex [
	"Find a text index of the end of the next word after a given text index"
	| textIterator newPosition aText |

	newPosition := aTextIndex.
	aText := self text.

	textIterator := aText iterator: (newPosition max: 1) to: aText size.
	[ textIterator hasNext and: [ newPosition = aTextIndex ] ] whileTrue: [
		| skip |
		skip := textIterator peek isSeparator.
		textIterator nextWord.
		skip ifFalse: [ newPosition := textIterator position ] ].

	^ newPosition
]

{ #category : 'private' }
AlbTextEditorOperator >> findWordStartBefore: aTextIndex [
	"Find a text index of start of the previous word before a given text index"
	| newPosition aText |
	
	aText := self text.
	newPosition := aTextIndex - 1.
	newPosition := newPosition max: 0.
	[ newPosition > 0 and: [ (aText at: newPosition) isSeparator ] ] whileTrue:
		[ newPosition := newPosition - 1 ].
	[ newPosition = 0 or: [ (aText at: newPosition) isSeparator ] ] whileFalse:
		[ newPosition := newPosition - 1 ].
	
	^ newPosition
]

{ #category : 'private' }
AlbTextEditorOperator >> hasSpaceAroundCursor: aCursor [
	"Answer a boolean indicating whether the characters either side of the cursor are separators (or end of string)"
	| anIterator |
	
	aCursor position isZero ifTrue: [ ^ true ].

	anIterator := self text 
			iterator: (aCursor position min: self text size)
			to: ((aCursor position + 1) min: self text size).
	2 timesRepeat:
		[ (anIterator hasNext and:
			[ anIterator next isSeparator not ]) ifTrue: [ ^false ] ].
	^ true
]

{ #category : 'testing' }
AlbTextEditorOperator >> hasSpaceAroundIndex: anIndex [

	^ self hasSpaceAroundCursor: (AlbTextEditorSingleCursor at: anIndex)
]

{ #category : 'private' }
AlbTextEditorOperator >> hasString: aString afterCursor: aCursor [
	| anIterator |
	
	self
		assert: [ aString isNotEmpty ]
		description: [ 'String must not be empty' ].
	
	aCursor position = self text size
		ifTrue: [ ^ false ].
	
	anIterator := self text iterator: ((aCursor position + 1) min: self text size) to: self text size.
	aString do: [ :eachCharacter |
		anIterator hasNext
			ifFalse: [ ^ false ].
			
		anIterator next = eachCharacter
			ifFalse: [ ^ false ] ].
	^ true
]

{ #category : 'private' }
AlbTextEditorOperator >> hasString: aString beforeCursor: aCursor [
	| anIterator |
	
	self
		assert: [ aString isNotEmpty ]
		description: [ 'String must not be empty' ].
	
	aCursor position isZero
		ifTrue: [ ^ false ].
	
	anIterator := self text iterator: 1 to: ((aCursor position + 1) min: self text size).
	anIterator skip: aCursor position.
	aString reverseDo: [ :eachCharacter |
		anIterator hasPrevious
			ifFalse: [ ^ false ].
			
		anIterator previous = eachCharacter
			ifFalse: [ ^ false ] ].
	^ true
]

{ #category : 'initialization' }
AlbTextEditorOperator >> initialize [
	super initialize.

	subscriptions := OrderedCollection new
]

{ #category : 'testing' }
AlbTextEditorOperator >> isCursorOnTheFirstLine: aCursor [
	<return: #Boolean>

	^ (self findLineStartBefore: (aCursor position max: self text isNotEmpty asBit)) isZero
]

{ #category : 'testing' }
AlbTextEditorOperator >> isCursorOnTheLastLine: aCursor [
	<return: #Boolean>

	^ (self findLineEndAfter: (aCursor position + 1 max: self text isNotEmpty asBit)) = self text size
]

{ #category : 'testing' }
AlbTextEditorOperator >> isDeleter [
	^ false
]

{ #category : 'testing' }
AlbTextEditorOperator >> isInserter [
	^ false
]

{ #category : 'private' }
AlbTextEditorOperator >> isWordChar: aCharacter [
	<return: #Number>

	^ aCharacter isAlphaNumeric
]

{ #category : 'notifying' }
AlbTextEditorOperator >> notifyCursorAdded: aCursor [
	| aCommand |

	aCommand := AlbTextEditorCursorAddCommand new
		context: self context;
		cursor: aCursor.
	editor executeCommand: aCommand
]

{ #category : 'notifying' }
AlbTextEditorOperator >> notifyCursorRemoved [
	self notifyCursorRemoved: self cursor
]

{ #category : 'notifying' }
AlbTextEditorOperator >> notifyCursorRemoved: aCursor [
	| aCommand |

	aCommand := AlbTextEditorCursorRemoveCommand new
		context: self context;
		cursor: aCursor.
	editor executeCommand: aCommand
]

{ #category : 'accessing' }
AlbTextEditorOperator >> selection [
	^ editor selection
]

{ #category : 'api - event' }
AlbTextEditorOperator >> subscribe: anEventHandler [

	editor addEventHandler: anEventHandler.
	subscriptions add: anEventHandler.
	^ anEventHandler
]

{ #category : 'accessing' }
AlbTextEditorOperator >> text [

	^ editor privateText
]

{ #category : 'api - event' }
AlbTextEditorOperator >> unsubscribe [

	subscriptions do: [ :anEventHandler | editor removeEventHandler: anEventHandler ]
]

{ #category : 'api - event' }
AlbTextEditorOperator >> when: anEventClass do: aBlock [

	^ self subscribe: (BlEventHandler on: anEventClass do: aBlock)
]
