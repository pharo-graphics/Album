Class {
	#name : #AlbTextEditorDeleter,
	#superclass : #AlbTextEditorOperator,
	#instVars : [
		'deletionIntervals',
		'shouldUpdateCursor',
		'shouldUpdateSelection'
	],
	#category : #'Album-Model-Operators'
}

{ #category : #'api - configuration' }
AlbTextEditorDeleter >> afterCursor [
	"Delete all text after the cursor"

	| aCursor |
	aCursor := self cursor.
	self
		from: aCursor position
		to: self text size
]

{ #category : #'api - processing' }
AlbTextEditorDeleter >> apply [
	^ self delete
]

{ #category : #'api - configuration' }
AlbTextEditorDeleter >> beforeCursor [
	"Delete all text before the cursor"
		
	| aCursor |
	aCursor := self cursor.
	self
		from: 0
		to: aCursor position
]

{ #category : #private }
AlbTextEditorDeleter >> computeCursorMovement: aCursor [
	"Cumpute by how much a given cursor should be moved after text deletion within current deletion intervals"

	^ self computeIndexMovement: aCursor position
]

{ #category : #private }
AlbTextEditorDeleter >> computeIndexMovement: anIndex [
	"Compute by how much a given text index should be moved after text deletion within current deletion intervals"
	| aCursorDelta |

	aCursorDelta := 0.

	deletionIntervals do: [ :aMonotoneSelection |
		(aMonotoneSelection to <= anIndex)
			ifTrue: [ aCursorDelta := aCursorDelta - (aMonotoneSelection to - aMonotoneSelection from) ]
			ifFalse: [ aMonotoneSelection from < anIndex
				ifTrue: [ aCursorDelta := aCursorDelta - (anIndex - aMonotoneSelection from) ] ] ].

	^ aCursorDelta
]

{ #category : #private }
AlbTextEditorDeleter >> computeSelectionMovement: aMonotoneSelection [
	"Cumpute by how much a given selection should be moved after text deletion within current deletion intervals.
	Note: a given monotone selection must not overlap with any deletion intervals"
	| aSelectionDelta |
	
	aSelectionDelta := 0.
	
	deletionIntervals do: [ :eachDeletion |
		| size |
		size := eachDeletion to - eachDeletion from.
		eachDeletion to <= aMonotoneSelection from
			ifTrue: [ aSelectionDelta := aSelectionDelta - size  ] ].

	^ aSelectionDelta
]

{ #category : #'api - processing' }
AlbTextEditorDeleter >> delete [
	"Perform deletion operation. All intervals are deleted as a single undoable step"

	editor history groupDuring: [
		shouldUpdateCursor ifTrue: [ self updateCursors ].
		shouldUpdateSelection ifTrue: [ self updateSelection ].
		deletionIntervals reverseDo: [ :aMonotoneSelection |
			self privateDelete: aMonotoneSelection from to: aMonotoneSelection to ] ]
]

{ #category : #'api - configuration' }
AlbTextEditorDeleter >> from: aFromIndex to: aToIndex [
	"Mark a text interval given by from an to indices as the one to be deleted in cursor coordinates"

	aFromIndex = aToIndex
		ifTrue: [ ^ self ].

	deletionIntervals select: aFromIndex to: aToIndex
]

{ #category : #initialization }
AlbTextEditorDeleter >> initialize [
	super initialize.
	
	deletionIntervals := BlCompositeSelection new.
	shouldUpdateCursor := true.
	shouldUpdateSelection := true
]

{ #category : #testing }
AlbTextEditorDeleter >> isDeleter [
	^ true
]

{ #category : #'api - configuration' }
AlbTextEditorDeleter >> oneAfterCursor [
	"Delete one symbol after every cursor"

	editor cursors do: [ :eachCursor |
		self
			from: eachCursor position
			to: ((eachCursor position + 1) min: self text size) ]
]

{ #category : #'api - configuration' }
AlbTextEditorDeleter >> oneAfterCursorIfOutsideOfSelection [
	"Delete one symbol after every cursor but only if there is no selection nearby"

	editor cursors do: [ :eachCursor |
		(self selection contains: eachCursor position)
			ifFalse: [
				self
					from: eachCursor position
					to: ((eachCursor position + 1) min: self text size) ] ]
]

{ #category : #'api - configuration' }
AlbTextEditorDeleter >> oneBeforeCursor [
	"Delete one symbol before every cursor"

	editor cursors do: [ :eachCursor | self oneBeforeCursor: eachCursor ]
]

{ #category : #'api - configuration' }
AlbTextEditorDeleter >> oneBeforeCursor: aCursor [
	"Delete one symbol before the specified cursor "

	self
		from: ((aCursor position - 1) max: 0)
		to: aCursor position
]

{ #category : #'api - configuration' }
AlbTextEditorDeleter >> oneBeforeCursorIfOutsideOfSelection [
	"Delete one symbol before every cursor but only if there is no selection nearby"

	editor cursors do: [ :eachCursor |
		(self selection contains: eachCursor position)
			ifFalse: [ self oneBeforeCursor: eachCursor ] ]
]

{ #category : #private }
AlbTextEditorDeleter >> privateDelete: aFromTextIndex to: aToTextIndex [

	"I delete a piece of text within a given text interval without cursor or selection update.
	Note: cursor or selection location after deletion may be invalid!"

	| aCommand |
	self
		assert: [ aFromTextIndex >= 0 and: [ aFromTextIndex <= self editor text size ] ]
		description: [ 'From deletion index must be within interval [0... text size]' ].
	self
		assert: [ aToTextIndex >= 0 and: [ aToTextIndex <= self editor text size ] ]
		description: [ 'To deletion index must be within interval [0... text size]' ].
	self assert: [ aToTextIndex >= aFromTextIndex ] description: [ 'To index must be greater or equal from index' ].

	aCommand := AlbTextEditorDeleteCommand new
		            fromIndex: aFromTextIndex;
		            toIndex: aToTextIndex.
	self editor executeCommand: aCommand
]

{ #category : #'api - configuration' }
AlbTextEditorDeleter >> selected [
	"Mark currenty selected text as the one to be deleted"

	self selection do: [ :aMonotoneSelection | self from: aMonotoneSelection from to: aMonotoneSelection to ]
]

{ #category : #'api - configuration' }
AlbTextEditorDeleter >> surroundings: aDictionaryOrArray [
	"Delete the surrounding around every cursor (if there is any) but only if the cursor is not part of the selection"

	| theAssociations |
	theAssociations := aDictionaryOrArray isArray
		ifFalse: [ aDictionaryOrArray associations ]
		ifTrue: [ aDictionaryOrArray ].
	editor cursors do: [ :eachCursor |
		(self selection contains: eachCursor position)
			ifFalse: [
				theAssociations
					detect: [ :eachReplacement |
						(self hasString: eachReplacement key beforeCursor: eachCursor)
							and: [ self hasString: eachReplacement value afterCursor: eachCursor ] ]
					ifFound: [ :aReplacement |
						self
							from: eachCursor position - aReplacement key size
							to: eachCursor position + aReplacement value size ] ] ]
]

{ #category : #private }
AlbTextEditorDeleter >> updateCursors [

	| aNavigator hasMoves |
	aNavigator := self editor navigator
		dueTo: self;
		yourself.
	hasMoves := false.
	editor cursors do: [ :eachCursor |
		| aCursorDelta |
		aCursorDelta := self computeCursorMovement: eachCursor.
		aCursorDelta isZero ifFalse: [
			hasMoves := true.
			aNavigator move: eachCursor by: aCursorDelta ] ].
	hasMoves ifTrue: [ aNavigator apply ]
]

{ #category : #private }
AlbTextEditorDeleter >> updateSelection [
	| aSelectionCopy newSelection |
	
	deletionIntervals do: [ :aMonotoneSelection | self editor deselect: aMonotoneSelection from to: aMonotoneSelection to ].
	
	aSelectionCopy := BlCompositeSelection new select: self selection.
	aSelectionCopy deselect: deletionIntervals.

	newSelection := BlCompositeSelection new.
	aSelectionCopy do: [ :eachSelection |
		| aSelectionDelta |

		aSelectionDelta := self computeSelectionMovement: eachSelection.
		newSelection select: (eachSelection from + aSelectionDelta) to: (eachSelection to + aSelectionDelta) ].

	self editor selection: newSelection
]

{ #category : #'api - configuration' }
AlbTextEditorDeleter >> withoutCursorUpdate [
	shouldUpdateCursor := false
]

{ #category : #'api - configuration' }
AlbTextEditorDeleter >> withoutSelectionUpdate [
	shouldUpdateSelection := false
]
