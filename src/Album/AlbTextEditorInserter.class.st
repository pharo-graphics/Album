"
Example:

[[[
anEditor := AlbTextEditor new.
anEditor inserter
	atCursor;
	string: 'Hello';
	insert.
anEditor
]]]

"
Class {
	#name : #AlbTextEditorInserter,
	#superclass : #AlbTextEditorOperator,
	#instVars : [
		'insertionIndices',
		'text',
		'shouldUpdateCursor',
		'shouldUpdateSelection',
		'shouldDeleteSelected',
		'inputFilter',
		'surroundMap'
	],
	#category : #'Album-Model-Operators'
}

{ #category : #'api - processing' }
AlbTextEditorInserter >> apply [
	^ self insert
]

{ #category : #'api - configuration' }
AlbTextEditorInserter >> at: anIndex [
	"Add a given index as another text insertion location"

	insertionIndices
		detect: [ :eachAssociation | eachAssociation key = anIndex ]
		ifNone: [ insertionIndices add: (anIndex -> text) ]
]

{ #category : #'api - configuration' }
AlbTextEditorInserter >> atCursor [
	self cursor do: [ :aCursor | self at: aCursor position ]
]

{ #category : #'api - configuration' }
AlbTextEditorInserter >> atEnd [
	"Insert a text at the very end"
	self at: self text size
]

{ #category : #'api - configuration' }
AlbTextEditorInserter >> beforeSelectedLines [
	"We insert text at the beginning of all selected lines"
	| aCollectionOfLineStarts |
	
	aCollectionOfLineStarts := OrderedCollection new.
	
	self selection do: [ :aMonotoneSelection |
		aCollectionOfLineStarts add: (self findLineStartBefore: aMonotoneSelection from + 1).
		aCollectionOfLineStarts addAll: (self findLineStartsBetween: aMonotoneSelection from + 1 and: aMonotoneSelection to) ].

	aCollectionOfLineStarts asSet do: [ :anIndex | self at: anIndex ]
]

{ #category : #private }
AlbTextEditorInserter >> computeIndexMovement: anIndex afterInserted: aText at: anInsertionIndex [
	"Compute by how much a given text index should be moved after a privided text is inserted at a given insertion index"
	<return: #Number>

	^ anIndex < anInsertionIndex
		ifTrue: [ 0 ]
		ifFalse: [ aText size ]
]

{ #category : #private }
AlbTextEditorInserter >> computeSelection: aSelection afterInserted: aText at: anInsertionIndex [
	<return: #BlSelection>

	aSelection to <= anInsertionIndex
		ifTrue: [ ^ aSelection ].

	aSelection from >= anInsertionIndex
		ifTrue: [ ^ BlSelection
			from: aSelection from + aText size
			to: aSelection to + aText size ].

	^ BlSelection
		from: aSelection from
		to: aSelection to + aText size
]

{ #category : #'api - configuration' }
AlbTextEditorInserter >> crLineEndingWithWhitespace [
	"Insert a Cr line ending
	additionally adding a whitespace from the previous line according to a cursor"

	self text: (self cursor isEmpty
		ifTrue: [ String cr ]
		ifFalse: [ String cr, (self findWhitespaceOfLineBefore: self cursor first position) ])
]

{ #category : #private }
AlbTextEditorInserter >> deleteSelectedText [
	| aDeleter newInsertionIndices |
	
	aDeleter := self editor deleter.
	aDeleter selected.

	newInsertionIndices := SortedCollection new.
	insertionIndices do: [ :eachAssociation |
		| anIndex |
		anIndex := eachAssociation key.
		newInsertionIndices add: (anIndex + (aDeleter computeIndexMovement: anIndex)) -> eachAssociation value ].
	
	insertionIndices := newInsertionIndices.
	
	aDeleter delete
]

{ #category : #'api - configuration' }
AlbTextEditorInserter >> indentation [
	"Insert an indentation (Tab)"

	self text: String tab
]

{ #category : #initialization }
AlbTextEditorInserter >> initialize [
	super initialize.
	
	text := nil.
	
	"a text that should be added on the right side when surround insertion is enabled.
	if surround text is not set, we duplicate the inserted text itself"
	surroundMap := AlbTextEditorSurroundMap new.
	
	insertionIndices := SortedCollection sortBlock: [ :a :b | a key < b key ].
	shouldUpdateCursor := true.
	shouldUpdateSelection := true.
	shouldDeleteSelected := true.

	inputFilter := AlbTextEditorNoInputFilter new
]

{ #category : #'api - configuration' }
AlbTextEditorInserter >> inputFilter: aTextEditorInputFilter [
	inputFilter := aTextEditorInputFilter
]

{ #category : #'api - processing' }
AlbTextEditorInserter >> insert [
	| theFilteredTextMap theInsertions theCursorMovements |

	shouldDeleteSelected
		ifTrue: [ self deleteSelectedText ].
		
	theFilteredTextMap := Dictionary new.
	theInsertions := OrderedCollection new.
	theCursorMovements := OrderedCollection new.
	
	insertionIndices ifEmpty: [ self atCursor ].
	
	insertionIndices do: [ :eachAssociation |
		| anIndex aFilteredText |
		
		anIndex := eachAssociation key.
		
		aFilteredText := theFilteredTextMap
			at: eachAssociation value
			ifAbsentPut: [ inputFilter filter: eachAssociation value ].

		surroundMap
			closingFor: eachAssociation value
			in: self at: anIndex
			ifPresent: [ :aRightSurroundText |
				| aFilteredSurroundText theSurroundingIndices |
				aFilteredSurroundText := theFilteredTextMap
					at: aRightSurroundText
					ifAbsentPut: [ inputFilter filter: aRightSurroundText ].

				theSurroundingIndices := self
					privateComputeInsertionIndices: aFilteredText
					withSurround: aFilteredSurroundText
					at: anIndex.
					
				theInsertions add: { 
					#index -> theSurroundingIndices first.
					#string -> aFilteredText.
					#requestedIndex -> anIndex.
					#surrounding -> {
						#index -> theSurroundingIndices second.
						#string -> aRightSurroundText.
					} asDictionary
				} asDictionary ]

			ifAbsent: [
				surroundMap
					openingFor: eachAssociation value
					ifPresent: [ :aLeftSurroundText |
						(self hasString: eachAssociation value afterCursor: (AlbTextEditorSingleCursor at: anIndex))
							ifTrue: [
								shouldUpdateCursor
									ifTrue: [
										self cursors do: [ :eachCursor |
											(eachCursor position = anIndex) ifTrue: [ theCursorMovements add: (eachCursor -> (anIndex + eachAssociation value size)) ] ] ]]
							ifFalse: [
								theInsertions add: { 
									#index -> anIndex.
									#requestedIndex -> anIndex.
									#string -> aFilteredText.
								} asDictionary
					] ]
					ifAbsent: [
						theInsertions add: { 
							#index -> anIndex.
							#requestedIndex -> anIndex.
							#string -> aFilteredText.
						} asDictionary
					] ] ].
		
	theInsertions in: [ :_ |
		| theInsertionStrings theInsertionIndices |
		
		theInsertionStrings := OrderedCollection new.
		theInsertionIndices := OrderedCollection new.
		
		theInsertions do: [ :eachInsertion |
			(eachInsertion at: #string) ifNotEmpty: [ :eachString |
				theInsertionStrings add: eachString.
				theInsertionIndices add: (eachInsertion at: #index) ].
			eachInsertion at: #surrounding
					ifPresent: [ :aSurrounding |
						(aSurrounding at: #string) ifNotEmpty: [ :eachString |
							theInsertionStrings add: eachString.
							theInsertionIndices add: (aSurrounding at: #index) ] ] ].

		self editor history groupDuring: [
			theCursorMovements ifNotEmpty: [ :theMovements |
				| aNavigator |
				aNavigator := self editor navigator.
				aNavigator withHistorization.
				theMovements do: [ :eachMovement | aNavigator move: eachMovement key to: eachMovement value ].
				aNavigator apply ].
			
			self telemetry
				timeSync: [ 'Insert {1} at {2}' format: { theInsertionStrings asArray . theInsertionIndices asArray } ]
				during: [ self privateInsertStrings: theInsertionStrings atAll: theInsertionIndices ] ] ].	
	
	theInsertions reverseDo: [ :eachInsertion | 
		shouldUpdateCursor
			ifTrue: [
				eachInsertion at: #surrounding
					ifPresent: [ :aSurrounding |
						self telemetry
							timeSync: [ 'Update cursor {1} surrounding {2} at {3}' format: {
								(eachInsertion at: #string).
								(aSurrounding at: #string).
								(eachInsertion at: #requestedIndex)} ]
							during: [ self
								privateUpdateCursorsAfterInsertion: (eachInsertion at: #string)
								withSurround: (aSurrounding at: #string)
								at: (eachInsertion at: #requestedIndex) ] ]
					ifAbsent: [
						self telemetry
							timeSync: [ 'Update cursor {1} at {2}' format: {
								(eachInsertion at: #string).
								(eachInsertion at: #requestedIndex)} ]
							during: [ self
								privateUpdateCursorsAfterInsertion: (eachInsertion at: #string)
								at: (eachInsertion at: #requestedIndex) ] ] ].
		shouldUpdateSelection
			ifTrue: [
				eachInsertion at: #surrounding
					ifPresent: [ :aSurrounding |
						self telemetry
							timeSync: [ 'Update selection {1} surrounding {2} at {3}' format: {
								(eachInsertion at: #string).
								(aSurrounding at: #string).
								(eachInsertion at: #requestedIndex)} ]
							during: [ self
								updateSelectionAfterInsertion: (eachInsertion at: #string)
								withSurround: (aSurrounding at: #string)
								at: (eachInsertion at: #requestedIndex) ] ]
					ifAbsent: [
						self telemetry
							timeSync: [ 'Update selection {1} at {2}' format: {
								(eachInsertion at: #string).
								(eachInsertion at: #requestedIndex)} ]
							during: [ self
								updateSelectionAfterInsertion: (eachInsertion at: #string)
								at: (eachInsertion at: #requestedIndex) ] ] ] ]
]

{ #category : #testing }
AlbTextEditorInserter >> isInserter [
	^ true
]

{ #category : #'api - configuration' }
AlbTextEditorInserter >> lineEnding [
	"Insert a line ending (Cr, Lf or CrLf depending on the current platform)"

	self text: OSPlatform current lineEnding
]

{ #category : #'api - configuration' }
AlbTextEditorInserter >> lineEndingWithWhitespace [
	"Insert a line ending (Cr, Lf or CrLf depending on the current platform)
	additionally  adding a whitespace from the previous line according to a cursor"

	self text: (self cursor isEmpty
		ifTrue: [ OSPlatform current lineEnding ]
		ifFalse: [ OSPlatform current lineEnding, (self findWhitespaceOfLineBefore: self cursor first position) ])
]

{ #category : #'api - configuration' }
AlbTextEditorInserter >> onlyAlphaNumeric [
	self inputFilter: AlbTextEditorAlphaNumericInputFilter new
]

{ #category : #'api - configuration' }
AlbTextEditorInserter >> onlyDigits [
	self inputFilter: AlbTextEditorDigitInputFilter new
]

{ #category : #'api - configuration' }
AlbTextEditorInserter >> onlyLetters [
	self inputFilter: AlbTextEditorLetterInputFilter new
]

{ #category : #private }
AlbTextEditorInserter >> privateComputeCursorIndices: aString withSurround: aSurroundString at: aTextIndex [
	| aLeftIndex aRightIndex |

	aLeftIndex := aTextIndex.
	aRightIndex := aTextIndex + aString size.
	
	(self selection do: [ :eachMonotoneSelection | (eachMonotoneSelection contains: aTextIndex)
		ifTrue: [
			aLeftIndex := eachMonotoneSelection from.
			aRightIndex := eachMonotoneSelection to + aString size ] ]).
	
	^ { aLeftIndex . aRightIndex }
]

{ #category : #private }
AlbTextEditorInserter >> privateComputeInsertionIndices: aString withSurround: aSurroundString at: aTextIndex [
	| aLeftIndex aRightIndex |

	aLeftIndex := aTextIndex.
	aRightIndex := aTextIndex.
	
	(self selection do: [ :eachMonotoneSelection | (eachMonotoneSelection contains: aTextIndex)
		ifTrue: [
			aLeftIndex := eachMonotoneSelection from.
			aRightIndex := eachMonotoneSelection to ] ]).
	
	^ { aLeftIndex . aRightIndex }
]

{ #category : #private }
AlbTextEditorInserter >> privateComputeSelectionIndices: aString withSurround: aSurroundString at: aTextIndex [
	| aLeftIndex aRightIndex |

	aLeftIndex := aTextIndex.
	aRightIndex := aTextIndex + aString size.
	
	(self selection do: [ :eachMonotoneSelection | (eachMonotoneSelection contains: aTextIndex)
		ifTrue: [
			aLeftIndex := eachMonotoneSelection from.
			aRightIndex := eachMonotoneSelection to + aString size ] ]).
	
	^ { aLeftIndex . aRightIndex }
]

{ #category : #private }
AlbTextEditorInserter >> privateInsertStrings: aCollectionOfString atAll: aCollectionOfIndices [
	| aCommand |

	aCommand := AlbTextEditorInsertStringsCommand new
		strings: aCollectionOfString;
		indices: aCollectionOfIndices.

	self editor enqueueCommand: aCommand
]

{ #category : #private }
AlbTextEditorInserter >> privateUpdateCursorsAfterInsertion: aText at: anIndex [
	self cursor do: [ :aCursor |
		| aCursorDelta |
		
		aCursorDelta := self telemetry
			timeSync: [
				'Compute movement for {1} inserting {2} at {3}'
					format: { aCursor position . aText . anIndex } ]
			during: [
				self
					computeIndexMovement: aCursor position
					afterInserted: aText
					at: anIndex ].

		aCursorDelta isZero
			ifFalse: [
				self telemetry
					timeSync: [ 'Move cursor at {1} by {2}' format: { aCursor position . aCursorDelta } ]
					during: [
						self editor navigator
							context: self context;
							dueTo: self;
							move: aCursor by: aCursorDelta;
							apply ] ] ]
]

{ #category : #private }
AlbTextEditorInserter >> privateUpdateCursorsAfterInsertion: aText withSurround: aSurroundText at: aTextIndex [
	| theIndices |

	theIndices := self privateComputeCursorIndices: aText withSurround: aSurroundText at: aTextIndex.

	self cursor do: [ :aCursor |
		| aCursorDelta |
					
		aCursorDelta := self
			computeIndexMovement: aCursor position
			afterInserted: aText
			at: theIndices first.
	
		aCursorDelta := aCursorDelta + (self
			computeIndexMovement: aCursor position
			afterInserted: aSurroundText
			at: theIndices second + aText size).

		aCursorDelta isZero
			ifFalse: [ self editor navigator
				dueTo: self;
				move: aCursor by: aCursorDelta;
				apply ] ]
]

{ #category : #'private - accessing' }
AlbTextEditorInserter >> shouldDeleteSelected [
	^ shouldDeleteSelected
]

{ #category : #'private - accessing' }
AlbTextEditorInserter >> shouldDeleteSelected: aBoolean [
	shouldDeleteSelected := aBoolean
]

{ #category : #'private - accessing' }
AlbTextEditorInserter >> shouldUpdateCursor [
	^ shouldUpdateCursor
]

{ #category : #'private - accessing' }
AlbTextEditorInserter >> shouldUpdateCursor: anObject [
	shouldUpdateCursor := anObject
]

{ #category : #'private - accessing' }
AlbTextEditorInserter >> shouldUpdateSelection [
	^ shouldUpdateSelection
]

{ #category : #'private - accessing' }
AlbTextEditorInserter >> shouldUpdateSelection: anObject [
	shouldUpdateSelection := anObject
]

{ #category : #'api - configuration' }
AlbTextEditorInserter >> string: aString [
	self text: aString
]

{ #category : #'api - configuration' }
AlbTextEditorInserter >> surroundings: aSurroundMap [
	surroundMap := aSurroundMap
]

{ #category : #'api - configuration' }
AlbTextEditorInserter >> text: aBlText [

	self editor checkText: aBlText.
	text := aBlText asString.
	insertionIndices do: [ :eachAssociation | 
		eachAssociation value ifNil: [ eachAssociation value: text ] ]
]

{ #category : #private }
AlbTextEditorInserter >> updateSelectionAfterInsertion: aText at: anIndex [
	| anExistingSelection |

	anExistingSelection := BlCompositeSelection new select: self editor selection.
	anExistingSelection reverseDo: [ :aMonotoneSelection |
		| aNewSelection |

		aNewSelection := self computeSelection: aMonotoneSelection afterInserted: aText at: anIndex.
		aNewSelection = aMonotoneSelection
			ifFalse: [
				self editor deselect: aMonotoneSelection from to: aMonotoneSelection to.
				self editor select: aNewSelection from to: aNewSelection to ] ]
]

{ #category : #private }
AlbTextEditorInserter >> updateSelectionAfterInsertion: aText withSurround: aSurroundText at: aTextIndex [
	| anExistingSelection theIndices |
	
	theIndices := self privateComputeSelectionIndices: aText withSurround: aSurroundText at: aTextIndex.

	anExistingSelection := BlCompositeSelection new select: self editor selection.
	anExistingSelection reverseDo: [ :aMonotoneSelection |
		| aNewSelection |

		aNewSelection := self computeSelection: aMonotoneSelection afterInserted: aText at: theIndices first.
		aNewSelection := self computeSelection: aNewSelection afterInserted: aText at: theIndices second.
		aNewSelection = aMonotoneSelection
			ifFalse: [
				self editor deselect: aMonotoneSelection from to: aMonotoneSelection to.
				self editor select: aNewSelection from to: aNewSelection to ] ]
]

{ #category : #'api - configuration' }
AlbTextEditorInserter >> withSelectionDelete [
	shouldDeleteSelected := true
]

{ #category : #'api - configuration' }
AlbTextEditorInserter >> withoutCursorUpdate [
	shouldUpdateCursor := false
]

{ #category : #'api - configuration' }
AlbTextEditorInserter >> withoutSelectionDelete [
	shouldDeleteSelected := false
]

{ #category : #'api - configuration' }
AlbTextEditorInserter >> withoutSelectionUpdate [
	shouldUpdateSelection := false
]
