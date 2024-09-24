"
I edit text and provide high level abstractions of essential text editor functionality such as selection, cursor, text insertions and deletions.
I subclass infinite data source in order to be able to smoothly display practically infinite amounts of text.
"
Class {
	#name : #AlbTextEditor,
	#superclass : #BlInfiniteDataSource,
	#classTraits : 'TObservable classTrait',
	#instVars : [
		'text',
		'selection',
		'selectionRecorder',
		'segmentCollector',
		'history',
		'filter',
		'shortcuts',
		'isFocused',
		'cursor',
		'hasEventHandlerAttribute',
		'layoutPositionsRange'
	],
	#classInstVars : [
		'isDebug'
	],
	#category : #'Album-Model'
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
AlbTextEditor >> addEditorShortcut: aTextEditorShortcut [

	self editorShortcuts
		add: aTextEditorShortcut
		ifAdded: [ :aNewEditorShortcut | self onShortcutAdded: aNewEditorShortcut ]
		ifReplaced: [ :aPreviousEditorShortcut | self onShortcutRemoved: aPreviousEditorShortcut ]
]

{ #category : #asserting }
AlbTextEditor >> assertUIProcess [
	"I check if the current process is a UI process of all attached editor elements"
	| aCurrentProcess myProcess |
	Bloc debugModeEnabled ifFalse: [ ^self ].
	aCurrentProcess := Processor activeProcess.	
	myProcess := self uiProcess.
	myProcess ifNil: [ ^self ].
	myProcess == aCurrentProcess
		ifFalse: [ AlbEditorWrongThreadError signal: ('I am running from a non-UI process ({1}) expected ({2})'
				format: { aCurrentProcess asString . myProcess asString }) ].
]

{ #category : #accessing }
AlbTextEditor >> cacheSize: anInteger [
	segmentCollector cacheSize: anInteger
]

{ #category : #accessing }
AlbTextEditor >> checkAndSetText: aText [ 
	self checkText: aText.
	self text: aText
]

{ #category : #'text checking' }
AlbTextEditor >> checkText: aText [

	(aText allSatisfy: [ :aCharacter | 
		 (Unicode isPrintable: aCharacter) or: [ 
			 aCharacter isLineBreak or: [ aCharacter = Character tab ] ] ]) 
		ifFalse: [ ^ self error: 'Non printable character in text' ]
]

{ #category : #'private - selection' }
AlbTextEditor >> commitSelection [
	self selectionRecorder commit: self
]

{ #category : #'text - copy/paste' }
AlbTextEditor >> copy: aFromIndex to: aToIndex [

	"Copy text within given text interval to the clipboard"

	Clipboard clipboardText: (self privateText from: aFromIndex + 1 to: aToIndex) asString
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

	^ cursor
]

{ #category : #accessing }
AlbTextEditor >> cursor: aCursor [
	<return: #AlbTextEditorCursor>

	cursor := aCursor
]

{ #category : #accessing }
AlbTextEditor >> cursors [
	^  { self cursor } 
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
AlbTextEditor >> defaultCursor [
	<return: #AlbTextEditorCursor>

	^ AlbTextEditorSingleCursor new
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
	<return: #AlbTextEditorSelectionRecorder>

	^ AlbTextEditorSelectionOverwriteRecorder new
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
	^ AlbTextEditorDeleter new editor: self
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
	<return: #AlbTextEditorDeselecter>

	^ AlbTextEditorDeselecter new editor: self
]

{ #category : #'api - shortcuts' }
AlbTextEditor >> editorShortcuts [
	<return: #AlbTextEditorShortcuts>

	^ shortcuts
]

{ #category : #'commands - processing' }
AlbTextEditor >> enqueueCommand: aTextEditorCommand [
	self deprecated: 'Use #executeCommand since there is not queue management and that the command is directly executed'.
	self executeCommand: aTextEditorCommand
]

{ #category : #'commands - processing' }
AlbTextEditor >> enqueueHolderCommand: aTextEditorHolderCommand interval: aTextInterval [
	self deprecated: 'use directly #notifyItems:event: instead'.

]

{ #category : #'commands - processing' }
AlbTextEditor >> executeCommand: aTextEditorCommand [
	aTextEditorCommand executeOn: self
]

{ #category : #accessing }
AlbTextEditor >> globalTextIndexToLocal: aTextIndex [

	self segmentCollector
		  cachedSegmentAt: aTextIndex
		  ifFound: [ :aSegment | 
			  | piece |
			  piece := aSegment pieces detect: [ :p | p textInterval includes: aTextIndex ].
			  ^ piece globalTextIndexToLocal: aTextIndex ]
		  ifNotFound: [  ].
	^ nil
]

{ #category : #'text - selection' }
AlbTextEditor >> hasCursors [
	"Return true of there is at least one cursor, false otherwise"
	<return: #Boolean>
	
	^ self cursors isNotEmpty
]

{ #category : #'event handler attributes' }
AlbTextEditor >> hasEventHandlerAttribute [
	^ hasEventHandlerAttribute ifNil: [ false ]
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
AlbTextEditor >> history: aTextEditorHistory [
	history := aTextEditorHistory
]

{ #category : #initialization }
AlbTextEditor >> initialize [

	super initialize.
	
	hasEventHandlerAttribute := false.
	filter := AlbTextEditorNoInputFilter new.
	cursor := self defaultCursor.
	selection := self defaultSelection.
	selectionRecorder := self defaultSelectionRecorder.		
	shortcuts := AlbTextEditorShortcuts new.
	history := AlbTextEditorHistory new.
	
	isFocused := false.
	
	self privateText: self defaultText.



]

{ #category : #initialization }
AlbTextEditor >> initializeText: aText [

	aText when: BlTextStringsInserted send: #onStringsInserted: to: self.
	aText when: BlTextsDeleted send: #onTextsDeleted: to: self.
	aText when: BlTextAttributeAdded send: #onTextAttributeAdded: to: self.
	aText when: BlTextAttributesRemoved send: #onTextAttributesRemoved: to: self
]

{ #category : #'api - filter' }
AlbTextEditor >> inputFilter [
	<return: #AlbTextEditorInputFilter>

	^ filter
]

{ #category : #'api - filter' }
AlbTextEditor >> inputFilter: aTextEditorInputFilter [

	filter := aTextEditorInputFilter next: filter
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
	^ AlbTextEditorInserter new editor: self
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
AlbTextEditor >> layoutPositionsRange [
	^ layoutPositionsRange ifNil: [ 0 to: 0 ]
]

{ #category : #accessing }
AlbTextEditor >> layoutPositionsRange: anInterval [
	layoutPositionsRange := anInterval
]

{ #category : #'api - shortcuts' }
AlbTextEditor >> limitedSurroundMap [
	"When inserting some special symbols a text editor should surround a cursor or selection with that symbol"

	| spaceBlock |
	spaceBlock := [ :anOperator :anIndex | 
		(anOperator hasSpaceAroundIndex: anIndex)
			or: [ anOperator selection contains: anIndex ] ].

	^ AlbTextEditorSurroundMap newFromArrays:
		{ 
			{ #'('. #')'. nil. }.
			{ #'['. #']'. nil. }.
			{ #'{'. #'}'. nil. }
		}
]

{ #category : #'model protocol' }
AlbTextEditor >> modeChanged: aMode [

	self flag: 'trying to do nothing to not lose the selection'.
	"self deselecter
		all;
		apply;
		notifyCursorRemoved"
]

{ #category : #'text - cursor' }
AlbTextEditor >> moveCursorTo: aTextIndex [
	"Moves cursor to a given position without any further action such as cancelling selection"
	<event: #AlbCursorMovedEvent>

	self navigator
		moveTo: aTextIndex;
		apply
]

{ #category : #'api - modification' }
AlbTextEditor >> navigator [
	^ AlbTextEditorNavigator new editor: self
]

{ #category : #initialization }
AlbTextEditor >> newSegmentCollector [
	^ self defaultSegmentCollector
]

{ #category : #'private - cursor' }
AlbTextEditor >> notifyAttributesWithinCursor: aCollectionOfAttributes [

	"I select and notify those attributes in the given collection that are within any of the cursors"

	| theEventHandlingAttributes anEvent |
	self isFocused ifFalse: [ ^ self ].

	anEvent := AlbTextCursorAttributeEnterEvent new textEditor: self.
	theEventHandlingAttributes := (aCollectionOfAttributes select: [ :eachAttribute | eachAttribute isEventHandler ]) asSet.

	self privateText
		findAttributesSuchThat: [ :eachAttribute | theEventHandlingAttributes includes: eachAttribute ]
		indicesDo: [ :aStart :anEnd :eachAttribute | 
			(self cursors anySatisfy: [ :eachCursor | eachCursor position between: aStart and: anEnd ]) ifTrue: [ 
				anEvent interval: (aStart to: anEnd).
				(eachAttribute wantsEvent: anEvent) ifTrue: [ eachAttribute handleEvent: anEvent ] ] ]
]

{ #category : #'event firing' }
AlbTextEditor >> notifyDeletedFrom: aFromIndex to: aToIndex [
	self dispatchEvent: (AlbTextDeletedEvent new
		fromIndex: aFromIndex;
		toIndex: aToIndex)
]

{ #category : #'event firing' }
AlbTextEditor >> notifyInserted: aText at: aTextIndex [
	self dispatchEvent: (AlbTextInsertedEvent text: aText at: aTextIndex)
]

{ #category : #'event firing' }
AlbTextEditor >> notifyPrimarySelectionChanged: aSelection [

	self dispatchEvent: (AlbSelectionChangedEvent new selection: aSelection)
]

{ #category : #'event firing' }
AlbTextEditor >> notifyShortcutAdded: aShortcut [
	self dispatchEvent: (AlbShortcutAddedEvent new shortcut: aShortcut)
]

{ #category : #'event firing' }
AlbTextEditor >> notifyShortcutRemoved: aShortcut [
	self dispatchEvent: (AlbShortcutRemovedEvent new shortcut: aShortcut)
]

{ #category : #'event firing' }
AlbTextEditor >> notifyTextEdited: aText [

	self dispatchEvent: (AlbTextEditedEvent new text: aText)
]

{ #category : #'event firing' }
AlbTextEditor >> notifyTextReplaced: aText [

	self dispatchEvent: (AlbTextReplacedEvent new text: aText)
]

{ #category : #hooks }
AlbTextEditor >> onAttached: anEditorElement [
	"sent by the element (from dataSource: )"
	
	super onAttached: anEditorElement.
	self addEventHandler: (AlbTextEditorHandler new element: anEditorElement).
	self notifyChanged
]

{ #category : #'instance creation' }
AlbTextEditor >> onBindHolder: aSegmentHolder at: aPosition [

	"I bind a segment at a given position to the provided segment holder"

	| aSegment previousLastIndex |
	
	"First we want to acquire a segment for a given position"
	aSegment := segmentCollector segmentAt: aPosition.

	"and then bind it to the holder"
	aSegmentHolder segment: aSegment.

	"If the last cached segment was requested, load more so that the editor knows there are more lines"
	(aPosition = segmentCollector lastIndex and: [ segmentCollector end < segmentCollector text size ]) ifFalse: [ ^ self ].
	previousLastIndex := segmentCollector lastIndex.
	segmentCollector computeForwardAt: aPosition + 1.
	self notifyItemsInserted: (aPosition + 1 to: aPosition + segmentCollector lastIndex - previousLastIndex)
]

{ #category : #'instance creation' }
AlbTextEditor >> onCreateHolder: anEditorElement [ 
	"Create and return a new segment holder of a given type to be used with provided editor element"
	<return: #AlbEditorSegmentHolder>
	
	"We perform a single dispatch on a segment type in order to support multiple types"
	^ AlbTextEditorLineSegmentHolder new
]

{ #category : #hooks }
AlbTextEditor >> onDetached: anEditorElement [

	self removeEventHandlersSuchThat: [ :eventHandler | true ].
	super onDetached: anEditorElement.

]

{ #category : #'private - focus' }
AlbTextEditor >> onGotFocus [

	isFocused := true.
	self processCursorAttributes.
	self executeCommand: (AlbTextEditorFocusChangedCommand new hasFocus: true)
]

{ #category : #'private - focus' }
AlbTextEditor >> onLostFocus [
	isFocused := false.

	self processCursorAttributes.
	self executeCommand: (AlbTextEditorFocusChangedCommand new hasFocus: false).
]

{ #category : #hooks }
AlbTextEditor >> onShortcutAdded: aShortcut [

	self notifyShortcutAdded: aShortcut
]

{ #category : #hooks }
AlbTextEditor >> onShortcutRemoved: aShortcut [

	self notifyShortcutRemoved: aShortcut
]

{ #category : #'hooks - text modifications' }
AlbTextEditor >> onStringsInserted: aBlTextStringsInserted [

	"Is sent after a few strings (or one) are inserted in a text model"

	aBlTextStringsInserted strings
		with: aBlTextStringsInserted finalIndices
		do: [ :aString :anIndex | self segmentCollector insertedString: aString at: anIndex in: self ].

	history
		insertedStrings: aBlTextStringsInserted strings
		undo: aBlTextStringsInserted finalIndices
		redo: aBlTextStringsInserted requestedIndices.

	aBlTextStringsInserted strings
		with: aBlTextStringsInserted finalIndices
		do: [ :aString :anIndex | self notifyInserted: aString asRopedText at: anIndex ].

	self notifyTextEdited: self privateText
]

{ #category : #'hooks - text modifications' }
AlbTextEditor >> onTextAttributeAdded: aBlTextAttributeAdded [

	self segmentCollector
		addedAttribute: aBlTextAttributeAdded attribute
		from: aBlTextAttributeAdded fromIndex
		to: aBlTextAttributeAdded toIndex
		in: self.

	aBlTextAttributeAdded attribute isEventHandler ifTrue: [ 
		self
			registerEventHandlerAttribute: aBlTextAttributeAdded attribute
			from: aBlTextAttributeAdded fromIndex
			to: aBlTextAttributeAdded toIndex ].

	self notifyAttributesWithinCursor: { aBlTextAttributeAdded attribute }
]

{ #category : #'hooks - text modifications' }
AlbTextEditor >> onTextAttributesRemoved: aBlTextAttributesRemoved [

	self segmentCollector
		removedAttributesFrom: aBlTextAttributesRemoved fromIndex
		to: aBlTextAttributesRemoved toIndex
		in: self.
	self
		unregisterEventHandlerAttributesFrom: aBlTextAttributesRemoved fromIndex
		to: aBlTextAttributesRemoved toIndex
]

{ #category : #'hooks - text modifications' }
AlbTextEditor >> onTextReplaced [

	"Is sent after a text instance is replaced with a new one"

	self processCursorAttributes.
	self notifyTextReplaced: self privateText
]

{ #category : #'hooks - text modifications' }
AlbTextEditor >> onTextsDeleted: aBlTextsDeleted [

	"Is sent after a piece of text was deleted in a text model"

	aBlTextsDeleted finalIntervals do: [ :eachInterval | 
		self segmentCollector deletedFrom: eachInterval first to: eachInterval last in: self ].

	history
		deletedTexts: (aBlTextsDeleted texts collect: [ :eachText | eachText copyWithoutExternalReferences ])
		undo: (aBlTextsDeleted finalIntervals collect: #first)
		redo: (aBlTextsDeleted requestedIntervals collect: #first).
	"text attributes may reference objects such as computation results in the editor and therefore we
		should remove such attributes"

	aBlTextsDeleted finalIntervals do: [ :eachInterval | self notifyDeletedFrom: eachInterval first to: eachInterval last ].

	self notifyTextEdited: self privateText
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
	^ AlbTextEditorPaster new editor: self
]

{ #category : #'private - selection' }
AlbTextEditor >> prepareSelection [
	self selectionRecorder prepare: self
]

{ #category : #accessing }
AlbTextEditor >> privateText [
	"Return a current text in the text editor. All modification to the text
	are reflected in the UI of the editor. For this reason I must only be
	used from a UI thread. To access a text from a non-UI thread use #textSnapshot
	which would give a copy of the current text."
	
	<return: #BlText>
	
	^ text
]

{ #category : #accessing }
AlbTextEditor >> privateText: aText [ 

	text == aText ifTrue: [ ^ self ].
	"when reducing the text size we should update the selection and cursor positions"
	text ifNotNil: [ self selectNone ].
	self restoreText: aText
]

{ #category : #'private - cursor' }
AlbTextEditor >> processCursorAttributes [
	"I search for the attributes within the whole text that contain (or not contain) any of the cursors and notify about it"
	| anEnteredEvent aLeavedEvent eventHandlingAttributesOutside eventHandlingAttributesInside |
	self flag: 'to be revised'.
	self hasEventHandlerAttribute ifFalse: [ ^self ].
	anEnteredEvent := AlbTextCursorAttributeEnterEvent new textEditor: self.
	aLeavedEvent := AlbTextCursorAttributeLeaveEvent new textEditor: self.

	eventHandlingAttributesOutside := OrderedCollection new.
	eventHandlingAttributesInside := OrderedCollection new.

	self flag: 'Removing this deep iteration ** speeds-up text editing a lot **'. 

	self text
		findAttributesSuchThat: [ :eachAttribute | eachAttribute isEventHandler ]
		indicesDo: [ :aStart :anEnd :anAttribute |
			(self isFocused and: [
				self cursors anySatisfy: [ :eachCursor | eachCursor position between: aStart and: anEnd ] ])
					ifTrue: [ eventHandlingAttributesInside add: anAttribute -> (aStart to: anEnd) ]
					ifFalse: [ eventHandlingAttributesOutside add: anAttribute -> (aStart to: anEnd) ] ].

	eventHandlingAttributesOutside do: [ :eachEventHandlerAttributeAndInterval |
		| eachAttribute eachInterval |
		
		eachAttribute := eachEventHandlerAttributeAndInterval key.
		eachInterval := eachEventHandlerAttributeAndInterval value.
		aLeavedEvent interval: eachInterval.
		
		(eachAttribute wantsEvent: aLeavedEvent)
			ifTrue: [ eachAttribute handleEvent: aLeavedEvent ] ].

	eventHandlingAttributesInside do: [ :eachEventHandlerAttributeAndInterval |
		| eachAttribute eachInterval |
		
		eachAttribute := eachEventHandlerAttributeAndInterval key.
		eachInterval := eachEventHandlerAttributeAndInterval value.
		anEnteredEvent interval: eachInterval.
		
		(eachAttribute wantsEvent: anEnteredEvent)
			ifTrue: [ eachAttribute handleEvent: anEnteredEvent ] ]
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

{ #category : #'event handler attributes' }
AlbTextEditor >> registerEventHandlerAttribute: anEventHandlerattribute from: aFromIndex to: aToIndex [
	| eventHandlers |
	hasEventHandlerAttribute := true.
	eventHandlers := anEventHandlerattribute eventDispatcher handlers.
	anEventHandlerattribute  eventDispatcher removeEventHandlers.
	eventHandlers do: [ :eachHandler | self addEventHandler: (BlEventForwarder forwardTo: eachHandler from: anEventHandlerattribute) ]	
]

{ #category : #'api - shortcuts' }
AlbTextEditor >> removeAllEditorShortcuts [
	self editorShortcuts
		removeAllShortcutsAndDo: [ :aPreviousShortcut | self onShortcutRemoved: aPreviousShortcut ]
]

{ #category : #'api - shortcuts' }
AlbTextEditor >> removeEditorShortcut: aTextEditorShortcut [
	self editorShortcuts
		remove: aTextEditorShortcut
		ifFound: [ :aPreviousShortcut | self onShortcutRemoved: aPreviousShortcut ]
]

{ #category : #'api - shortcuts' }
AlbTextEditor >> removeEditorShortcuts: aCollectionOfTextEditorShortcut [
	aCollectionOfTextEditorShortcut do: [ :eachShortcut | self removeEditorShortcut: eachShortcut ]
]

{ #category : #'api - save state' }
AlbTextEditor >> restoreState: aTextEditorMemento [

	aTextEditorMemento restoreStateOf: self
]

{ #category : #accessing }
AlbTextEditor >> restoreText: aText [

	"before changing the text we must unsubscribe from existing one"

	text ifNotNil: [ text unsubscribe: self ].
	self history setUpToStart.
	cursor := self defaultCursor.

	text := aText.
	" then subscribe to internal text state change (insertion/deletion/attribute change) "
	self initializeText: text.

	"Replacing text instance means that we can not guarantee structural integrity
	of existing cache and have to rebuild it invalidating the whole underlying model structure"
	segmentCollector
		ifNil: [ segmentCollector := self newSegmentCollector ]
		ifNotNil: [ segmentCollector resetCache ].
	segmentCollector text: text.

	self onTextReplaced.

	"notify UI about structural update"
	self notifyChanged
]

{ #category : #'api - save state' }
AlbTextEditor >> saveState [
	<return: #AlbTextEditorMemento>
	
	^ (AlbTextEditorCompositeMemento new all) saveStateOf: self
]

{ #category : #'api - save state' }
AlbTextEditor >> saveState: aTextEditorMemento [
	<return: #AlbTextEditorMemento>
	
	^ aTextEditorMemento saveStateOf: self
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
		  ifTrue: [ self privateText from: self selection from + 1 to: self selection to ]
		  ifFalse: [ self privateText from: 1 to: 0]
]

{ #category : #'api - modification' }
AlbTextEditor >> selecter [
	<return: #AlbTextEditorSelecter>

	^ AlbTextEditorSelecter new editor: self
]

{ #category : #accessing }
AlbTextEditor >> selection [
	<return: #BlSelection>

	^ selection
]

{ #category : #'private - selection' }
AlbTextEditor >> selection: aTextSelection [
	selection := aTextSelection.
	self notifyPrimarySelectionChanged: selection
]

{ #category : #accessing }
AlbTextEditor >> selectionRecorder [
	<return: #AlbTextEditorSelectionRecorder>

	^ selectionRecorder
]

{ #category : #'api - shortcuts' }
AlbTextEditor >> setEditorShortcuts: aTextEditorShortcuts [

	self removeAllEditorShortcuts.
	shortcuts := aTextEditorShortcuts.
	shortcuts do: [ :aNewEditorShortcut | self onShortcutAdded: aNewEditorShortcut ]
]

{ #category : #'api - shortcuts' }
AlbTextEditor >> surroundMap [
	"When inserting some special symbols a text editor should surround a cursor or selection with that symbol"

	| spaceBlock |
	spaceBlock := [ :anOperator :anIndex | true
		"(anOperator hasSpaceAroundIndex: anIndex)
			or: [ anOperator selection contains: anIndex ]" ].

	^ AlbTextEditorSurroundMap newFromArrays:
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
	
	self
		deprecated: 'Please use privateText instead.'
		transformWith:
			'`@receiver text'
				-> '`@receiver privateText'.
	^ text
]

{ #category : #accessing }
AlbTextEditor >> text: aText [ 

	self
		deprecated: 'Please use privateText: instead.'
		transformWith:
			'`@receiver text: `@statements1'
				-> '`@receiver privateText: `@statements1'.

	self privateText: aText
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
AlbTextEditor >> uiProcess [

	| element space |
	element := AlbEditorElement allSubInstances
		           detect: [ :editorElement | editorElement editor == self ]
		           ifNone: [ ^ nil ].
	space := element isAttachedToSceneGraph
		         ifTrue: [ element space ]
		         ifFalse: [ ^ nil ].
	space host uiProcessDo: [ :process | ^ process ].
	^ nil
]

{ #category : #'text - undo/redo' }
AlbTextEditor >> undo [
	history undoOn: self
]

{ #category : #'event handler attributes' }
AlbTextEditor >> unregisterEventHandlerAttribute: anEventHandlerattribute from: aFromIndex to: aToIndex [
]

{ #category : #'event handler attributes' }
AlbTextEditor >> unregisterEventHandlerAttributesFrom: aFromIndex to: aToIndex [
	Transcript show: 'unregisterEventHandlerAttributesFrom: ', aFromIndex printString, ' to: ', aToIndex printString; cr.
]

{ #category : #'private - updating' }
AlbTextEditor >> updateSelection: aFromTextIndex to: aToTextIndex [
	"Update text rendering within an interval defined by provided from and to indices."
	| aCommand |
	
	aCommand := AlbTextEditorSelectionUpdateCommand new
		fromIndex: aFromTextIndex;
		toIndex: aToTextIndex.
	self executeCommand: aCommand
]

{ #category : #'api - modification' }
AlbTextEditor >> updater [
	<return: #AlbTextEditorUpdater>

	^ AlbTextEditorUpdater new editor: self
]

{ #category : #'view configuration' }
AlbTextEditor >> whenTextEditedDo: aBlock [

	self deprecated: 'Use directly when: AlbTextEditedEvent do: instead'. 
	self when: AlbTextEditedEvent do: aBlock
]

{ #category : #accessing }
AlbTextEditor >> withoutCacheLimit [
	 self cacheSize: -1
]
