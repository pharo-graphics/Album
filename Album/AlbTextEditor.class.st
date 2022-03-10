"
! The Moldable Editor

I edit text and provide high level abstractions of essential text editor functionality such as selection, cursor, text insertions and deletions.

I make use of ${class:AlbTextAdornmentAttribute}$ to augment text with visual elements. 

I subclass infinite data source in order to be able to smoothly display practically infinite amounts of text.
"
Class {
	#name : #AlbTextEditor,
	#superclass : #BlInfiniteDataSource,
	#instVars : [
		'model',
		'mode',
		'text',
		'selection',
		'selectionRecorder',
		'segmentBuilder',
		'segmentCollector',
		'styler',
		'stylerStrategy',
		'stylerEventHandler',
		'cursors',
		'attachedElements',
		'history',
		'filter',
		'shortcuts',
		'isFocused',
		'shouldStyleWhenTextModified'
	],
	#classInstVars : [
		'isDebug'
	],
	#category : #'Album-Editor-Model'
}

{ #category : #cleanup }
AlbTextEditor class >> cleanUp [
	super cleanUp.
	
	isDebug := nil
]

{ #category : #accessing }
AlbTextEditor class >> isDebug [
	^ isDebug ifNil: [ false ]
]

{ #category : #accessing }
AlbTextEditor class >> isDebug: aBoolean [
	isDebug := aBoolean
]

{ #category : #'api - shortcuts' }
AlbTextEditor >> addEditorShortcut: aBrTextEditorShortcut [
	self editorShortcuts
		add: aBrTextEditorShortcut
		ifAdded: [ :aNewEditorShortcut | self onShortcutAdded: aNewEditorShortcut ]
		ifReplaced: [ :aPreviousEditorShortcut | self onShortcutRemoved: aPreviousEditorShortcut ]
]

{ #category : #'api - shortcuts' }
AlbTextEditor >> addEditorShortcuts: aCollectionOfBrTextEditorShortcut [
	aCollectionOfBrTextEditorShortcut
		do: [ :eachShortcut | self addEditorShortcut: eachShortcut ]
]

{ #category : #asserting }
AlbTextEditor >> assertUIProcess [
	"I check if the current process is a UI process of all attached editor elements"
	| aCurrentProcess allUIProcesses |
	
	aCurrentProcess := Processor activeProcess.	
	allUIProcesses := self uiProcesses.
	
	(allUIProcesses size <= 1)
		ifFalse: [ BrEditorWrongThreadError signal: 'The editor is attached to multiple elements from different UI processes' ].
		
	(allUIProcesses isEmpty or: [ allUIProcesses anyOne == aCurrentProcess ])
		ifFalse: [ BrEditorWrongThreadError signal: ('I am running from a non-UI process ({1}) expected ({2})'
				format: { aCurrentProcess asString . allUIProcesses anyOne asString }) ].
]

{ #category : #'api - mode' }
AlbTextEditor >> beEditable [
	self editorMode: BrTextEditorEditableMode new
]

{ #category : #'api - mode' }
AlbTextEditor >> beEditableCode [
	self editorMode: BrTextEditorEditableCodeMode new
]

{ #category : #accessing }
AlbTextEditor >> beLineBased [
	segmentBuilder := AlbTextEditorLineSegmentBuilder new splitter: AlbTextEditorLineSplitter new
]

{ #category : #accessing }
AlbTextEditor >> beParagraphBased [
	segmentBuilder := AlbTextEditorLineSegmentBuilder new splitter: AlbTextEditorParagraphSplitter new
]

{ #category : #'api - mode' }
AlbTextEditor >> beReadOnlyWithSelection [
	self editorMode: BrTextEditorReadonlyWithSelectionMode new
]

{ #category : #'api - mode' }
AlbTextEditor >> beReadOnlyWithoutSelection [
	self editorMode: BrTextEditorReadonlyWithoutSelectionMode new
]

{ #category : #'private - selection' }
AlbTextEditor >> commitSelection [
	self selectionRecorder commit: self
]

{ #category : #'text - copy/paste' }
AlbTextEditor >> copy: aFromIndex to: aToIndex [
	"Copy text within given text interval to the clipboard"
	
	Clipboard clipboardText: (self text from: aFromIndex + 1 to: aToIndex) asString
]

{ #category : #'text - copy/paste' }
AlbTextEditor >> copySelected [
	"Copy currently selected text to the clipboard"
	
	self selection isEmpty
		ifTrue: [ ^ self ].
		
	self
		copy: self selection from
		to: self selection to
]

{ #category : #accessing }
AlbTextEditor >> cursor [
	<return: #AlbTextEditorCursor>

	self
		deprecated: 'Use #cursors instead.'
		transformWith: '`@receiver cursor' -> '`@receiver cursors'.

	^ cursors
]

{ #category : #accessing }
AlbTextEditor >> cursors [
	<return: #AlbTextEditorCursor>

	^ cursors
]

{ #category : #'text - copy/paste' }
AlbTextEditor >> cut: aFromIndex to: aToIndex [
	"Copy text within given text interval to the clipboard and remove it from the editor.
	Note: I update the cursor location and selection"

	self copy: aFromIndex to: aToIndex.

	self selectNone.
	self moveCursorTo: aFromIndex.
	self delete: aFromIndex to: aToIndex
]

{ #category : #'text - copy/paste' }
AlbTextEditor >> cutSelected [
	"Copy currently selected text to the clipboard and remove it from the editor.
	Note: I update the cursor location and selection"
	
	self selection isEmpty
		ifTrue: [ ^ self ].
	
	self
		cut: self selection from
		to: self selection to
]

{ #category : #initialization }
AlbTextEditor >> defaultCursors [
	<return: #BrTextEditorCursor>

	^ BrTextEditorMultipleCursor new
]

{ #category : #initialization }
AlbTextEditor >> defaultSegmentBuilder [
	^ AlbTextEditorLineSegmentBuilder new
]

{ #category : #initialization }
AlbTextEditor >> defaultSegmentCollector [
	^ AlbTextEditorSegmentCollector new
]

{ #category : #initialization }
AlbTextEditor >> defaultSelection [
	<return: #BlSelection>

	^ BlCompositeSelection new
]

{ #category : #initialization }
AlbTextEditor >> defaultSelectionRecorder [
	<return: #AblTextEditorSelectionRecorder>

	^ AblTextEditorSelectionOverwriteRecorder new
]

{ #category : #initialization }
AlbTextEditor >> defaultStyler [
	^ BlTextNullStyler new
]

{ #category : #initialization }
AlbTextEditor >> defaultStylerEventHandler [
	^ BlEventHandler
		on: BrTextStyledEvent
		do: [ :anEvent | self onTextStyled: anEvent ]
]

{ #category : #initialization }
AlbTextEditor >> defaultStylerStrategy [
	^ BrTextStylerSyncStrategy new
]

{ #category : #initialization }
AlbTextEditor >> defaultText [
	<return: #BlText>
	^ BlRopedText string: ''
]

{ #category : #'private - text' }
AlbTextEditor >> delete: aFromTextIndex to: aToTextIndex [
	"I delete a piece of text within a given text interval without cursor or selection update.
	Note: cursor or selection location after deletion may be invalid!"

	self deleter
		from: aFromTextIndex to: aToTextIndex;
		withoutCursorUpdate;
		withoutSelectionUpdate;
		delete
]

{ #category : #'api - modification' }
AlbTextEditor >> deleter [
	^ BrTextEditorDeleter new editor: self
]

{ #category : #'private - text' }
AlbTextEditor >> deselect: aFromTextIndex to: aToTextIndex [
	"Deselect text within an interval defined by provided from and to indices without any other side effects.
	Note:
		- I don't change cursor position.
		- I request segments update"

	self deselecter
		from: aFromTextIndex to: aToTextIndex;
		deselect
]

{ #category : #'api - modification' }
AlbTextEditor >> deselecter [
	<return: #BrTextEditorDeselecter>

	^ BrTextEditorDeselecter new editor: self
]

{ #category : #'text - styling' }
AlbTextEditor >> disableStyleTextWhenModified [
	shouldStyleWhenTextModified := false
]

{ #category : #'text - styling' }
AlbTextEditor >> disableStyleTextWhenModifiedDuring: aBlock [
	| aPreviousShouldStyleWhenTextModified |
	
	aPreviousShouldStyleWhenTextModified := shouldStyleWhenTextModified.
	shouldStyleWhenTextModified := false.
	aBlock ensure: [ shouldStyleWhenTextModified := aPreviousShouldStyleWhenTextModified ]
]

{ #category : #'api - mode' }
AlbTextEditor >> editorMode [
	<return: #BrTextEditorMode>

	^ mode
]

{ #category : #'api - mode' }
AlbTextEditor >> editorMode: aBrTextEditorMode [
	self
		assert: [ aBrTextEditorMode isNotNil ]
		description: [ 'Mode must not be nil' ].

	mode = aBrTextEditorMode
		ifTrue: [ ^ self ].

	"Uninstall existing mode"
	mode uninstallFromEditor: self.
	attachedElements do: [ :eachElement | mode uninstallFromEditorElement: eachElement ].

	mode := aBrTextEditorMode.
	mode installOnEditor: self.
	attachedElements do: [ :eachElement | mode installOnEditorElement: eachElement ].
	
	self notifyChanged
]

{ #category : #'api - shortcuts' }
AlbTextEditor >> editorShortcuts [
	<return: #AlbTextEditorShortcuts>

	^ shortcuts
]

{ #category : #'text - styling' }
AlbTextEditor >> enableStyleTextWhenModified [
	shouldStyleWhenTextModified := true
]

{ #category : #'commands - processing' }
AlbTextEditor >> enqueueCommand: aTextEditorCommand [
	(AlbTextEditorCommandSignal textEditor: self)
		command: aTextEditorCommand;
		emit.

	aTextEditorCommand executeOn: self
]

{ #category : #'commands - processing' }
AlbTextEditor >> enqueueHolderCommand: aTextEditorHolderCommand interval: aTextInterval [
	(AlbTextEditorHolderCommandSignal textEditor: self)
		command: aTextEditorHolderCommand;
		interval: aTextInterval;
		emit.

	self
		notifyItems: aTextInterval
		event: aTextEditorHolderCommand
]

{ #category : #'text - selection' }
AlbTextEditor >> hasCursors [
	"Return true of there is at least one cursor, false otherwise"
	<return: #Boolean>
	
	^ self cursors isNotEmpty
]

{ #category : #'text - selection' }
AlbTextEditor >> hasSelection [
	"Return true of there is at least one selected character, false otherwise"
	<return: #Boolean>
	
	^ self selection isNotEmpty
]

{ #category : #accessing }
AlbTextEditor >> history [
	<return: #AlbTextEditorHistory>
	
	^ history
]

{ #category : #accessing }
AlbTextEditor >> history: aBrTextEditorHistory [
	history := aBrTextEditorHistory
]

{ #category : #initialization }
AlbTextEditor >> initialize [
	super initialize.
	
	mode := AlbTextEditorNullMode new.
	
	attachedElements := Set new.
	
	filter := BrTextEditorNoInputFilter new.
	cursors := self defaultCursors.
	selection := self defaultSelection.
	selectionRecorder := self defaultSelectionRecorder.
	
	text := self defaultText.
	self initializeText: text.
	
	segmentCollector := self defaultSegmentCollector.
	segmentCollector editor: self.
	segmentCollector text: text.
	segmentBuilder := self defaultSegmentBuilder.

	styler := self defaultStyler.
	stylerEventHandler := self defaultStylerEventHandler.
	self addEventHandler: stylerEventHandler.
	self useDefaultStylerStrategy.
	
	shortcuts := AlbTextEditorShortcuts new.
	history := BrTextEditorHistory new.
	
	isFocused := false.
	shouldStyleWhenTextModified := true.

	self beEditable.
	"self beParagraphBased"
]

{ #category : #initialization }
AlbTextEditor >> initializeText: aBrText [
	aBrText when: BlTextStringsInserted send: #onStringsInserted: to: self.
	aBrText when: BlTextsDeleted send: #onTextsDeleted: to: self.
	aBrText when: BlTextAttributeAdded send: #onTextAttributeAdded: to: self.
	aBrText when: BlTextAttributesRemoved send: #onTextAttributesRemoved: to: self.
]

{ #category : #'api - filter' }
AlbTextEditor >> inputFilter [
	<return: #BrTextEditorInputFilter>

	^ filter
]

{ #category : #'api - filter' }
AlbTextEditor >> inputFilter: aBrTextEditorInputFilter [
	filter := aBrTextEditorInputFilter
]

{ #category : #'private - text' }
AlbTextEditor >> insertString: aString at: aTextIndex [

	self inserter
		at: aTextIndex;
		string: aString;
		withoutCursorUpdate;
		withoutSelectionUpdate;
		withoutSelectionDelete;
		insert
]

{ #category : #'api - modification' }
AlbTextEditor >> inserter [
	^ BrTextEditorInserter new editor: self
]

{ #category : #accessing }
AlbTextEditor >> isFocused [
	<return: #Boolean>

	^ isFocused
]

{ #category : #accessing }
AlbTextEditor >> itemCount [
	^ segmentCollector computedSegmentsCount
]

{ #category : #accessing }
AlbTextEditor >> itemIdAt: aPosition [
	^ (segmentCollector segmentAt: aPosition) index
]

{ #category : #accessing }
AlbTextEditor >> itemTypeAt: aPosition [
	"Return segment type at a given position"
	<return: #AlbEditorSegmentType>
	
	^ (segmentCollector segmentAt: aPosition) segmentType
]

{ #category : #accessing }
AlbTextEditor >> model [
	^ model
]

{ #category : #accessing }
AlbTextEditor >> model: anObject [
	model := anObject
]

{ #category : #'text - cursor' }
AlbTextEditor >> moveCursorTo: aTextIndex [
	"Moves cursor to a given position without any further action such as cancelling selection"
	<event: #BrTextEditorCursorMovedEvent>

	self navigator
		moveTo: aTextIndex;
		apply
]

{ #category : #'api - modification' }
AlbTextEditor >> navigator [
	^ BrTextEditorNavigator new editor: self
]

{ #category : #'commands - creation' }
AlbTextEditor >> newFocusChangedCommand [
	^ BrTextEditorFocusChangedCommand new
]

{ #category : #'commands - creation' }
AlbTextEditor >> newInvalidateCommand [
	^ BrTextEditorInvalidateCommand new
]

{ #category : #'commands - creation' }
AlbTextEditor >> newSelectCommand [
	^ BrTextEditorSelectCommand new
]

{ #category : #'commands - creation' }
AlbTextEditor >> newSelectionUpdateCommand [
	^ BrTextEditorSelectionUpdateCommand new
]

{ #category : #'commands - creation' }
AlbTextEditor >> newUpdateCommand [
	^ BrTextEditorUpdateCommand new
]

{ #category : #'private - cursor' }
AlbTextEditor >> notifyAttributesWithinCursor: aCollectionOfAttributes [
	"I select and notify those attributes in the given collection that are within any of the cursors"
	| theEventHandlingAttributes anEvent |
	
	self isFocused
		ifFalse: [ ^ self ].

	anEvent := BrTextCursorAttributeEnterEvent new.
	
	theEventHandlingAttributes := (aCollectionOfAttributes select: [ :eachAttribute | eachAttribute isEventHandler ]) asSet.
	
	self text
		findAttributesSuchThat: [ :eachAttribute | theEventHandlingAttributes includes:  eachAttribute ]
		indicesDo: [ :aStart :anEnd :eachAttribute |
			(self cursors anySatisfy: [ :eachCursor |
					eachCursor position between: aStart and: anEnd ])
						ifTrue: [
							anEvent interval: (aStart to: anEnd).
							(eachAttribute wantsEvent: anEvent in: self)
								ifTrue: [ eachAttribute handleEvent: anEvent in: self on: nil ] ] ]
]

{ #category : #'event firing' }
AlbTextEditor >> notifyDeletedFrom: aFromIndex to: aToIndex [
	self dispatchEvent: (BrTextEditorDeletedEvent new
		editor: self;
		fromIndex: aFromIndex;
		toIndex: aToIndex)
]

{ #category : #'event firing' }
AlbTextEditor >> notifyInserted: aText at: aTextIndex [
	self dispatchEvent: (BrTextEditorInsertedEvent text: aText at: aTextIndex)
]

{ #category : #'event firing' }
AlbTextEditor >> notifyInteractionAdded: anInteraction [
	self dispatchEvent: (BrTextEditorInteractionAddedEvent new interaction: anInteraction)
]

{ #category : #'event firing' }
AlbTextEditor >> notifyInteractionRemoved: anInteraction [
	self dispatchEvent: (BrTextEditorInteractionRemovedEvent new interaction: anInteraction)
]

{ #category : #'event firing' }
AlbTextEditor >> notifyModified: aText [
	self dispatchEvent: (BrTextEditorModifiedEvent new text: aText)
]

{ #category : #'event firing' }
AlbTextEditor >> notifySelectionChanged: aSelection [
	self dispatchEvent: (BrTextEditorSelectionChangedEvent new selection: aSelection)
]

{ #category : #'event firing' }
AlbTextEditor >> notifyTextReplaced: aText [
	self dispatchEvent: (BrTextEditorTextReplacedEvent new text: aText)
]

{ #category : #'event firing' }
AlbTextEditor >> notifyTextStyled: aText [
	self dispatchEvent: (BrTextEditorTextStyledEvent new styledText: aText)
]

{ #category : #hooks }
AlbTextEditor >> onAttached: anEditorElement [
	super onAttached: anEditorElement.

	attachedElements := attachedElements copyWith: anEditorElement.

 	mode installOnEditorElement: anEditorElement.
	shortcuts do: [ :eachInteraction | self onInteractionAdded: eachInteraction to: anEditorElement ].

	anEditorElement when: BlMouseUpEvent do: [ :anEvent | anEvent consumed: true ].
	anEditorElement when: BlClickEvent do: [ :anEvent | anEvent consumed: true ].
	anEditorElement when: BlFocusEvent do: [ self onGotFocus ].
	anEditorElement when: BlBlurEvent do: [ self onLostFocus ].

	self notifyChanged
]

{ #category : #'instance creation' }
AlbTextEditor >> onBindHolder: aSegmentHolder at: aPosition [
	"I bind a segment at a given position to the provided segment holder"
	| aSegment previousLastIndex |

	"First we want to acquire a segment for a given position"
	aSegmentHolder infiniteElement telemetry
		timeSync: [ 'Get segment at {1}' format: { aPosition } ]
		during: [ aSegment := segmentCollector segmentAt: aPosition. ].

	"and then bind it to the holder"
	aSegmentHolder infiniteElement telemetry
		timeSync: [ 'Set segment at {1}' format: { aPosition } ]
		during: [ aSegmentHolder segment: aSegment ].

	"If the last cached segment was requested, load more so that the editor knows there are more lines"
	(aPosition = segmentCollector lastIndex and: [ segmentCollector end < segmentCollector text size ])
		ifTrue: [
			previousLastIndex := segmentCollector lastIndex.
			segmentCollector computeForwardAt: aPosition + 1.
			self notifyItemsInserted: (aPosition + 1 to: aPosition + segmentCollector lastIndex - previousLastIndex) ]
]

{ #category : #'instance creation' }
AlbTextEditor >> onBindHolder: aSegmentHolder at: aPosition payloads: aCollectionOfPayloads [	
	"I bind a segment at a given position to provided segment holder"

	aCollectionOfPayloads
		ifEmpty: [ self onBindHolder: aSegmentHolder at: aPosition ]
		ifNotEmpty: [ :theCommands |
			theCommands do: [ :aHolderCommand | aHolderCommand executeOn: aSegmentHolder ] ]
]

{ #category : #'instance creation' }
AlbTextEditor >> onCreateHolder: anEditorElement type: aSegmentType [
	"Create and return a new segment holder of a given type to be used with provided editor element"
	<return: #AlbEditorSegmentHolder>
	
	"We perform a single dispatch on a segment type in order to support multiple types"
	^ aSegmentType holder
]

{ #category : #hooks }
AlbTextEditor >> onDetached: anEditorElement [
	super onDetached: anEditorElement.

	attachedElements := attachedElements copyWithout: anEditorElement.

	mode uninstallFromEditorElement: anEditorElement.
	shortcuts do: [ :eachInteraction | self onInteractionRemoved: eachInteraction from: anEditorElement ].

	anEditorElement
		removeEventHandlersSuchThat: [ :aHandler | (aHandler isKindOf: BlEventHandler)
			and: [ { BlMouseUpEvent . BlClickEvent . BlFocusEvent . BlBlurEvent } includes: aHandler eventClass ] ]
]

{ #category : #hooks }
AlbTextEditor >> onElementRecycled: anElementHolder [
	super onElementRecycled: anElementHolder.
	
	anElementHolder onRecycled
]

{ #category : #'private - focus' }
AlbTextEditor >> onGotFocus [
	isFocused := true.
	
	self cursors isEmpty
		ifTrue: [ self navigator moveTo: 0; apply ].

	self processCursorAttributes.
	self enqueueCommand: (self newFocusChangedCommand hasFocus: true)
]

{ #category : #hooks }
AlbTextEditor >> onInteractionAdded: anInteraction to: anEditorElement [
	anEditorElement removeShortcutsWithCombination: anInteraction combination.
	anEditorElement addShortcut: anInteraction asShortcut
]

{ #category : #hooks }
AlbTextEditor >> onInteractionRemoved: anInteraction from: anEditorElement [
	anEditorElement removeShortcutsWithCombination: anInteraction combination
]

{ #category : #'private - focus' }
AlbTextEditor >> onLostFocus [
	isFocused := false.

	self processCursorAttributes.
	self enqueueCommand: (self newFocusChangedCommand hasFocus: false).
]

{ #category : #hooks }
AlbTextEditor >> onShortcutAdded: anInteraction [
	attachedElements do: [ :eachElement | self onInteractionAdded: anInteraction to: eachElement ].
	self notifyInteractionAdded: anInteraction
]

{ #category : #hooks }
AlbTextEditor >> onShortcutRemoved: anInteraction [
	attachedElements do: [ :eachElement | self onInteractionRemoved: anInteraction from: eachElement ].
	self notifyInteractionRemoved: anInteraction
]

{ #category : #'hooks - text modifications' }
AlbTextEditor >> onStringsInserted: aBlTextStringsInserted [
	"Is sent after a few strings (or one) are inserted in a text model"
	self assertUIProcess.
	
	aBlTextStringsInserted strings
		with: aBlTextStringsInserted finalIndices
		do: [ :aString :anIndex |
			self segmentBuilder
				insertedString: aString
				at: anIndex
				in: self ].

	history
		insertedStrings: aBlTextStringsInserted strings
		undo: aBlTextStringsInserted finalIndices
		redo: aBlTextStringsInserted requestedIndices.

	aBlTextStringsInserted strings
		with: aBlTextStringsInserted finalIndices
		do: [ :aString :anIndex |
			self
				notifyInserted: aString asRopedText
				at: anIndex ].

	self notifyModified: self text.

	shouldStyleWhenTextModified
		ifTrue: [ self styleText ]
]

{ #category : #'hooks - text modifications' }
AlbTextEditor >> onTextAttributeAdded: aBlTextAttributeAdded [
	self assertUIProcess.

	self segmentBuilder
		addedAttribute: aBlTextAttributeAdded attribute
		from: aBlTextAttributeAdded fromIndex
		to: aBlTextAttributeAdded toIndex
		in: self.

	self notifyAttributesWithinCursor: { aBlTextAttributeAdded attribute }
]

{ #category : #'hooks - text modifications' }
AlbTextEditor >> onTextAttributesRemoved: aBlTextAttributesRemoved [
	self assertUIProcess.

	self segmentBuilder
		removedAttributesFrom: aBlTextAttributesRemoved fromIndex
		to: aBlTextAttributesRemoved toIndex
		in: self.
]

{ #category : #'hooks - text modifications' }
AlbTextEditor >> onTextReplaced [
	"Is sent after a text instance is replaced with a new one"
	self assertUIProcess.

	self processCursorAttributes.
	self notifyTextReplaced: self text
]

{ #category : #'hooks - text modifications' }
AlbTextEditor >> onTextStyled: aBlTextStyledEvent [
	self assertUIProcess.
	
	(aBlTextStyledEvent text isNextGenerationOf: self text)
		ifTrue: [
			self text rope: aBlTextStyledEvent text text rope.
			
			aBlTextStyledEvent editorElement telemetry
				timeSync: [ 'Execute after-action: {1}' format: { aBlTextStyledEvent afterAction } ]
				during: [ aBlTextStyledEvent afterAction value: self text. ].
			
			aBlTextStyledEvent editorElement telemetry
				timeSync: [ 'notifyTextStyled' ]
				during: [ self notifyTextStyled: self text ].
			
			aBlTextStyledEvent editorElement telemetry
				timeSync: [ 'processCursorAttributes' ]
				during: [ self processCursorAttributes ].
			
			aBlTextStyledEvent editorElement telemetry
				timeSync: [ 'Invalidate the whole text editor due to text change' ]
				during: [
					self updater
						all;
						update ] ]
		ifFalse: [ self styleTextAndAfterDo: aBlTextStyledEvent afterAction ]
]

{ #category : #'hooks - text modifications' }
AlbTextEditor >> onTextsDeleted: aBlTextsDeleted [
	"Is sent after a piece of text was deleted in a text model"
	self assertUIProcess.

	aBlTextsDeleted finalIntervals
		do: [ :eachInterval |
			self segmentBuilder
				deletedFrom: eachInterval first
				to:  eachInterval last
				in: self ].

	history
		"text attributes may reference objects such as computation results in the editor and therefore we
		should remove such attributes"
		deletedTexts: (aBlTextsDeleted texts collect: [ :eachText | eachText copyWithoutExternalReferences ])
		undo: (aBlTextsDeleted finalIntervals collect: #first)
		redo: (aBlTextsDeleted requestedIntervals collect: #first).

	aBlTextsDeleted finalIntervals
		do: [ :eachInterval |
			self
				notifyDeletedFrom: eachInterval first
				to:  eachInterval last ].

	self notifyModified: self text.
	
	shouldStyleWhenTextModified
		ifTrue: [ self styleText ]
]

{ #category : #'text - copy/paste' }
AlbTextEditor >> paste [
	"A paste a text from the clipboard at the current cursor position.
	I delete any currently selected text and update cursor position"
	
	self paster
		fromClipboard;
		atCursor;
		paste
]

{ #category : #'api - modification' }
AlbTextEditor >> paster [
	^ BrTextEditorPaster new editor: self
]

{ #category : #'private - selection' }
AlbTextEditor >> prepareSelection [
	self selectionRecorder prepare: self
]

{ #category : #'private - cursor' }
AlbTextEditor >> processCursorAttributes [
	"I search for the attributes within the whole text that contain (or not contain) any of the cursors and notify about it"

	| anEnteredEvent aLeavedEvent eventHandlingAttributesOutside eventHandlingAttributesInside |

	anEnteredEvent := BrTextCursorAttributeEnterEvent new.
	aLeavedEvent := BrTextCursorAttributeLeaveEvent new.

	eventHandlingAttributesOutside := OrderedDictionary new.
	eventHandlingAttributesInside := OrderedDictionary new.

	self text
		findAttributesSuchThat: [ :eachAttribute | eachAttribute isEventHandler ]
		indicesDo: [ :aStart :anEnd :anAttribute |
			((self isFocused and: [ self cursors anySatisfy: [ :eachCursor |
				eachCursor position between: aStart and: anEnd ] ])
					ifTrue: [ eventHandlingAttributesInside ]
					ifFalse: [ eventHandlingAttributesOutside ])
						at: anAttribute put: (aStart to: anEnd) ].

	eventHandlingAttributesOutside keysAndValuesDo: [ :eachAttribute :eachInterval |
		aLeavedEvent interval: eachInterval.
		(eachAttribute wantsEvent: aLeavedEvent in: self) ifTrue: [
			eachAttribute handleEvent: aLeavedEvent in: self on: nil ] ].

	eventHandlingAttributesInside keysAndValuesDo: [ :eachAttribute :eachInterval |
		anEnteredEvent interval: eachInterval.
		(eachAttribute wantsEvent: anEnteredEvent in: self) ifTrue: [
			eachAttribute handleEvent: anEnteredEvent in: self on: nil ] ]

]

{ #category : #'private - selection' }
AlbTextEditor >> recordDeselection: aMonotoneTextSelection [
	self selectionRecorder deselect: aMonotoneTextSelection in: self.
	
	(self selection + self selectionRecorder selection) isEmpty
		ifTrue: [ ^ self ].
		
	self moveCursorTo: (self selection + self selectionRecorder selection) to
]

{ #category : #'private - selection' }
AlbTextEditor >> recordSelection: aMonotoneTextSelection [
	self selectionRecorder select: aMonotoneTextSelection in: self.

	(self selection + self selectionRecorder selection) isEmpty
		ifTrue: [ ^ self ].
		
	self moveCursorTo: (self selection + self selectionRecorder selection) to
]

{ #category : #'text - undo/redo' }
AlbTextEditor >> redo [
	history redoOn: self
]

{ #category : #'api - shortcuts' }
AlbTextEditor >> removeAllEditorShortcuts [
	self editorShortcuts
		removeAllShortcutsAndDo: [ :aPreviousShortcut | self onShortcutRemoved: aPreviousShortcut ]
]

{ #category : #'api - shortcuts' }
AlbTextEditor >> removeEditorShortcut: aBrTextEditorShortcut [
	self editorShortcuts
		remove: aBrTextEditorShortcut
		ifFound: [ :aPreviousShortcut | self onShortcutRemoved: aPreviousShortcut ]
]

{ #category : #'api - shortcuts' }
AlbTextEditor >> removeEditorShortcuts: aCollectionOfBrTextEditorShortcut [
	aCollectionOfBrTextEditorShortcut do: [ :eachShortcut | self removeEditorShortcut: eachShortcut ]
]

{ #category : #'api - save state' }
AlbTextEditor >> restoreState: aBrTextEditorMemento [
	self assertUIProcess.

	aBrTextEditorMemento restoreStateOf: self
]

{ #category : #accessing }
AlbTextEditor >> restoreText: aToText [
	"before changing the text we must unsubscribe from existing one"	
	text unsubscribe: self.

	text := aToText.
	self initializeText: text.

	"Replacing text instance means that we can not guarantee structural integrity
	of existing cache and have to rebuild it invalidating the whole underlying model structure"
	segmentCollector := self defaultSegmentCollector.
	segmentCollector editor: self.
	segmentCollector text: text.

	self onTextReplaced.

	"notify UI about structural update"
	self notifyChanged.

	"text changed, we should style it"
	shouldStyleWhenTextModified
		ifTrue: [ self styleText ]
]

{ #category : #'api - save state' }
AlbTextEditor >> saveState [
	<return: #BrTextEditorMemento>
	self assertUIProcess.
	
	^ (BrTextEditorCompositeMemento new all) saveStateOf: self
]

{ #category : #'api - save state' }
AlbTextEditor >> saveState: aBrTextEditorMemento [
	<return: #BrTextEditorMemento>
	self assertUIProcess.
	
	^ aBrTextEditorMemento saveStateOf: self
]

{ #category : #accessing }
AlbTextEditor >> segmentBuilder [
	<return: #AlbTextEditorSegmentBuilder>

	^ segmentBuilder
]

{ #category : #accessing }
AlbTextEditor >> segmentBuilder: aTextSegmentBuilder [
	"Change current segment builder to a new one and completely invalidate the structure"
	
	segmentBuilder := aTextSegmentBuilder.
	self notifyChanged
]

{ #category : #accessing }
AlbTextEditor >> segmentBuilderDo: aBlock [
	aBlock value: segmentBuilder
]

{ #category : #accessing }
AlbTextEditor >> segmentCollector [
	<return: #AlbTextEditorSegmentCollector>

	^ segmentCollector
]

{ #category : #'private - text' }
AlbTextEditor >> select: aFromTextIndex to: aToTextIndex [
	"Select text within an interval defined by provided from and to indices without any other side effects.
	Note:
		- I don't change cursor position.
		- I request segments update"

	self selecter
		from: aFromTextIndex to: aToTextIndex;
		withoutCursorUpdate;
		select
]

{ #category : #'text - selection' }
AlbTextEditor >> selectNone [
	"Deselect the whole text in the editor without any other side effects.
	Note:
		- I don't change cursor position.
		- I request segments update"

	self selection isEmpty
		ifTrue: [ ^ self ].

	self
		deselect: self selection from
		to: self selection to
]

{ #category : #'text - selection' }
AlbTextEditor >> selectedText [
	<return: #BlText>
	
	^ self hasSelection
		ifTrue: [ self text copyFrom: self selection from + 1 to: self selection to ]
		ifFalse: [ self text empty ]
]

{ #category : #'api - modification' }
AlbTextEditor >> selecter [
	<return: #BrTextEditorSelecter>

	^ BrTextEditorSelecter new editor: self
]

{ #category : #accessing }
AlbTextEditor >> selection [
	<return: #BlSelection>

	^ selection
]

{ #category : #'private - selection' }
AlbTextEditor >> selection: aTextSelection [
	selection := aTextSelection.
	
	self notifySelectionChanged: selection
]

{ #category : #accessing }
AlbTextEditor >> selectionRecorder [
	<return: #AblTextEditorSelectionRecorder>

	self
		assert: [ selectionRecorder isNotNil ]
		description: [ 'Selection recorder can not be nil' ].

	^ selectionRecorder
]

{ #category : #'api - shortcuts' }
AlbTextEditor >> setEditorShortcuts: aToTextEditorShortcuts [
	self
		assert: [ aToTextEditorShortcuts isKindOf: AlbTextEditorShortcuts ]
		description: [ 'Must be an editor shortcuts object' ].
	
	self removeAllEditorShortcuts.
	
	shortcuts := aToTextEditorShortcuts.
	shortcuts do: [ :aNewEditorShortcut | self onShortcutAdded: aNewEditorShortcut ]
]

{ #category : #'text - styling' }
AlbTextEditor >> styleText [
	"I request styler to re-style my current text"
	
	self styleTextAndAfterDo: [ :aStyledText | "do nothing" ]
]

{ #category : #'text - styling' }
AlbTextEditor >> styleTextAndAfterDo: aBlock [
	"I first style, and then I do aBlock once I am finished"
	
	self dispatchEvent: (BrTextEditorTextStyleRequested new afterAction: aBlock)
]

{ #category : #accessing }
AlbTextEditor >> styler [
	<return: #BlTextStyler>
	^ styler
]

{ #category : #accessing }
AlbTextEditor >> styler: aStyler [
	styler = aStyler
		ifTrue: [ ^ self ].

	styler := aStyler.

	"styler changed, let's restyle the text"
	shouldStyleWhenTextModified
		ifTrue: [ self styleText ]
]

{ #category : #accessing }
AlbTextEditor >> stylerStrategy [
	<return: #AlbTextStylerStrategy>
	^ stylerStrategy
]

{ #category : #accessing }
AlbTextEditor >> stylerStrategy: aToTextStylerStrategy [
	self 
		assert: [ aToTextStylerStrategy isNotNil ] 
		description: [ 'Text styler strategy must be non-nil' ].

	stylerStrategy := aToTextStylerStrategy
]

{ #category : #'api - shortcuts' }
AlbTextEditor >> surroundMap [
	"When inserting some special symbols a text editor should surround a cursor or selection with that symbol"

	| spaceBlock |
	spaceBlock := [ :anOperator :anIndex |
		(anOperator hasSpaceAroundIndex: anIndex)
			or: [ anOperator selection contains: anIndex ] ].

	^ BrTextEditorSurroundMap newFromArrays:
		{ 
			{ #'('. #')'. spaceBlock. }.
			{ #'"'. #'"'. spaceBlock. }.
			{ #''''. #''''. spaceBlock. }.
			{ #'['. #']'. spaceBlock. }.
			{ #'{'. #'}'. spaceBlock. }
		}
]

{ #category : #accessing }
AlbTextEditor >> text [
	"Return a current text in the text editor. All modification to the text
	are reflected in the UI of the editor. For this reason I must only be
	used from a UI thread. To access a text from a non-UI thread use #textSnapshot
	which would give a copy of the current text"
	<return: #BlText>
	
	self assertUIProcess.
	^ text
]

{ #category : #accessing }
AlbTextEditor >> text: aBrText [
	
	"when reducing the text size we should update the selection and cursor positions"
	(aBrText size < text size)
		ifTrue: [
			self navigator
				moveWithin: (0 to: aBrText size);
				apply.
			
			self deselecter
				from: aBrText size to: text size;
				deselect ].

	self restoreText: aBrText
]

{ #category : #accessing }
AlbTextEditor >> textSnapshot [
	"Return a snaphost (copy) of the current text.
	I am safe to use from a non-UI thread because the returned text is independent from the
	current one and can be safely modified"
	<return: #BlText>

	^ text copy
]

{ #category : #asserting }
AlbTextEditor >> uiProcesses [
	| theElementGroupedByProcess allUIProcesses |

	theElementGroupedByProcess := attachedElements groupedBy: [ :eachElement |
		| eachSpace eachUIProcess |
		eachSpace := eachElement isAttachedToSceneGraph
			ifTrue: [ eachElement space ]
			ifFalse: [ nil ].
		eachUIProcess := nil.
		eachSpace ifNotNil: [ eachSpace host uiProcessDo: [ :aProcess | eachUIProcess := aProcess ] ].
		eachUIProcess ].
	
	allUIProcesses := theElementGroupedByProcess keys reject: #isNil.

	^ allUIProcesses
]

{ #category : #'text - undo/redo' }
AlbTextEditor >> undo [
	history undoOn: self
]

{ #category : #'private - updating' }
AlbTextEditor >> updateSelection: aFromTextIndex to: aToTextIndex [
	"Update text rendering within an interval defined by provided from and to indices."
	| aCommand |
	
	aCommand := self newSelectionUpdateCommand
		fromIndex: aFromTextIndex;
		toIndex: aToTextIndex.
	self enqueueCommand: aCommand
]

{ #category : #'api - modification' }
AlbTextEditor >> updater [
	<return: #BrTextEditorUpdater>

	^ BrTextEditorUpdater new editor: self
]

{ #category : #initialization }
AlbTextEditor >> useAsyncStylerStrategy [
	self stylerStrategy: BrTextStylerAsyncStrategy new
]

{ #category : #initialization }
AlbTextEditor >> useDefaultStylerStrategy [
	self stylerStrategy: self defaultStylerStrategy
]

{ #category : #initialization }
AlbTextEditor >> useSyncStylerStrategy [
	self stylerStrategy: BrTextStylerSyncStrategy new
]

{ #category : #initialization }
AlbTextEditor >> useTaskItStylerStrategy [
	self stylerStrategy: BrTextStylerTaskItStrategy new
]
