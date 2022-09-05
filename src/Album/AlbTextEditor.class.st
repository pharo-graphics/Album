"
I edit text and provide high level abstractions of essential text editor functionality such as selection, cursor, text insertions and deletions.

I make use of `AlbTextAdornmentAttribute` to augment text with visual elements. 

I subclass infinite data source in order to be able to smoothly display practically infinite amounts of text.
"
Class {
	#name : #AlbTextEditor,
	#superclass : #OBlInfiniteDataSource,
	#instVars : [
		'model',
		'mode',
		'text',
		'selection',
		'selectionRecorder',
		'segmentCollector',
		'styler',
		'stylerStrategy',
		'stylerEventHandler',
		'attachedElements',
		'history',
		'filter',
		'shortcuts',
		'isFocused',
		'shouldStyleWhenTextModified',
		'cursor',
		'hasEventHandlerAttribute',
		'wordStencilBuilder'
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

{ #category : #'api - shortcuts' }
AlbTextEditor >> addEditorShortcuts: aCollectionOfTextEditorShortcut [
	aCollectionOfTextEditorShortcut
		do: [ :eachShortcut | self addEditorShortcut: eachShortcut ]
]

{ #category : #asserting }
AlbTextEditor >> assertUIProcess [
	"I check if the current process is a UI process of all attached editor elements"
	| aCurrentProcess allUIProcesses |
	Bloc debugModeEnabled ifFalse: [ ^self ].
	aCurrentProcess := Processor activeProcess.	
	allUIProcesses := self uiProcesses.
	
	(allUIProcesses size <= 1)
		ifFalse: [ AlbEditorWrongThreadError signal: 'The editor is attached to multiple elements from different UI processes' ].
		
	(allUIProcesses isEmpty or: [ allUIProcesses anyOne == aCurrentProcess ])
		ifFalse: [ AlbEditorWrongThreadError signal: ('I am running from a non-UI process ({1}) expected ({2})'
				format: { aCurrentProcess asString . allUIProcesses anyOne asString }) ].
]

{ #category : #'api - mode' }
AlbTextEditor >> beEditable [
	self editorMode: AlbTextEditorEditableMode new
]

{ #category : #'api - mode' }
AlbTextEditor >> beEditableCode [
	self editorMode: AlbTextEditorEditableCodeMode new
]

{ #category : #'api - mode' }
AlbTextEditor >> beReadOnlyWithSelection [
	self editorMode: AlbTextEditorReadonlyWithSelectionMode new
]

{ #category : #'api - mode' }
AlbTextEditor >> beReadOnlyWithoutSelection [
	self editorMode: AlbTextEditorReadonlyWithoutSelectionMode new
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
AlbTextEditor >> defaultStyler [
	^ BlTextNullStyler new
]

{ #category : #initialization }
AlbTextEditor >> defaultStylerEventHandler [
	^ BlEventHandler
		on: AlbTextStyledEvent
		do: [ :anEvent | self onTextStyled: anEvent ]
]

{ #category : #initialization }
AlbTextEditor >> defaultStylerStrategy [
	^ AlbTextStylerSyncStrategy new
]

{ #category : #initialization }
AlbTextEditor >> defaultText [
	<return: #BlText>
	^ BlRopedText string: ''
]

{ #category : #initialization }
AlbTextEditor >> defaultWordStencilBuilder [
	^ AlbTextWordPieceStencilBuilder editable
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
	<return: #AlbTextEditorMode>

	^ mode
]

{ #category : #'api - mode' }
AlbTextEditor >> editorMode: aTextEditorMode [
	self
		assert: [ aTextEditorMode isNotNil ]
		description: [ 'Mode must not be nil' ].

	mode = aTextEditorMode
		ifTrue: [ ^ self ].

	"Uninstall existing mode"
	mode uninstallFromEditor: self.
	attachedElements do: [ :eachElement | mode uninstallFromEditorElement: eachElement ].

	mode := aTextEditorMode.
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
	mode := AlbTextEditorNullMode new.
	
	attachedElements := Set new.
	
	filter := AlbTextEditorNoInputFilter new.
	cursor := self defaultCursor.
	selection := self defaultSelection.
	selectionRecorder := self defaultSelectionRecorder.
	
	text := self defaultText.
	self initializeText: text.
	wordStencilBuilder := self defaultWordStencilBuilder.
	segmentCollector := self newSegmentCollector.
	segmentCollector text: text.
	
	styler := self defaultStyler.
	stylerEventHandler := self defaultStylerEventHandler.
	self addEventHandler: stylerEventHandler.
	self useDefaultStylerStrategy.
	
	shortcuts := AlbTextEditorShortcuts new.
	history := AlbTextEditorHistory new.
	
	isFocused := false.
	shouldStyleWhenTextModified := true.

	self beEditable.
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
	filter := aTextEditorInputFilter
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
AlbTextEditor >> itemTypeAt: aPosition [
	"Return segment type at a given position"
	<return: #AlbEditorSegmentType>
	self flag: 'try with uniform item type to avoid collector>>computeBackwardAt:'.
	^ AlbTextEditorLineSegmentType uniqueInstance
	"^ (segmentCollector segmentAt: aPosition) segmentType"
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
	<event: #AlbTextEditorCursorMovedEvent>

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
	
	self isFocused
		ifFalse: [ ^ self ].

	anEvent := AlbTextCursorAttributeEnterEvent new textEditor: self.
	theEventHandlingAttributes := (aCollectionOfAttributes select: [ :eachAttribute | eachAttribute isEventHandler ]) asSet.
	
	self text
		findAttributesSuchThat: [ :eachAttribute | theEventHandlingAttributes includes:  eachAttribute ]
		indicesDo: [ :aStart :anEnd :eachAttribute |
			(self cursors anySatisfy: [ :eachCursor |
					eachCursor position between: aStart and: anEnd ])
						ifTrue: [
							anEvent interval: (aStart to: anEnd).
							(eachAttribute wantsEvent: anEvent)
								ifTrue: [ eachAttribute handleEvent: anEvent ] ] ]
]

{ #category : #'event firing' }
AlbTextEditor >> notifyDeletedFrom: aFromIndex to: aToIndex [
	self dispatchEvent: (AlbTextEditorDeletedEvent new
		editor: self;
		fromIndex: aFromIndex;
		toIndex: aToIndex)
]

{ #category : #'event firing' }
AlbTextEditor >> notifyInserted: aText at: aTextIndex [
	self dispatchEvent: (AlbTextEditorInsertedEvent text: aText at: aTextIndex)
]

{ #category : #'event firing' }
AlbTextEditor >> notifyInteractionAdded: anInteraction [
	self dispatchEvent: (AlbTextEditorInteractionAddedEvent new interaction: anInteraction)
]

{ #category : #'event firing' }
AlbTextEditor >> notifyInteractionRemoved: anInteraction [
	self dispatchEvent: (AlbTextEditorInteractionRemovedEvent new interaction: anInteraction)
]

{ #category : #'event firing' }
AlbTextEditor >> notifyModified: aText [
	self dispatchEvent: (AlbTextEditorModifiedEvent new text: aText)
]

{ #category : #'event firing' }
AlbTextEditor >> notifySelectionChanged: aSelection [
	self dispatchEvent: (AlbTextEditorSelectionChangedEvent new selection: aSelection)
]

{ #category : #'event firing' }
AlbTextEditor >> notifyTextReplaced: aText [
	self dispatchEvent: (AlbTextEditorTextReplacedEvent new text: aText)
]

{ #category : #'event firing' }
AlbTextEditor >> notifyTextStyled [
	self notifyTextStyled: self text

]

{ #category : #'event firing' }
AlbTextEditor >> notifyTextStyled: aText [
	self dispatchEvent: (AlbTextEditorTextStyledEvent new styledText: aText)
]

{ #category : #hooks }
AlbTextEditor >> onAttached: anEditorElement [
	"sent by the element (from dataSource: )"
	
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
	
	
	self flag: 'No example with payloads... '.
	aSegmentHolder payloads ifNotEmpty: [ :theCommands | 
		theCommands do: [ :aHolderCommand | aHolderCommand executeOn: aSegmentHolder ].
		^ self ].

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

{ #category : #'private - focus' }
AlbTextEditor >> onGotFocus [
	isFocused := true.
	
	self processCursorAttributes.
	self executeCommand: (AlbTextEditorFocusChangedCommand new hasFocus: true)
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
	self executeCommand: (AlbTextEditorFocusChangedCommand new hasFocus: false).
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
			self segmentCollector
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

	self assertUIProcess.

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
	self assertUIProcess.

	self processCursorAttributes.
	self notifyTextReplaced: self text
]

{ #category : #'hooks - text modifications' }
AlbTextEditor >> onTextStyled: aTextStyledEvent [

	self assertUIProcess.
	self styler onTextStyled: aTextStyledEvent editor: self
]

{ #category : #'hooks - text modifications' }
AlbTextEditor >> onTextsDeleted: aBlTextsDeleted [
	"Is sent after a piece of text was deleted in a text model"
	self assertUIProcess.

	aBlTextsDeleted finalIntervals
		do: [ :eachInterval |
			self segmentCollector
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
	^ AlbTextEditorPaster new editor: self
]

{ #category : #'private - selection' }
AlbTextEditor >> prepareSelection [
	self selectionRecorder prepare: self
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
	self assertUIProcess.

	aTextEditorMemento restoreStateOf: self
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
	<return: #AlbTextEditorMemento>
	self assertUIProcess.
	
	^ (AlbTextEditorCompositeMemento new all) saveStateOf: self
]

{ #category : #'api - save state' }
AlbTextEditor >> saveState: aTextEditorMemento [
	<return: #AlbTextEditorMemento>
	self assertUIProcess.
	
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
		ifTrue: [ self text copyFrom: self selection from + 1 to: self selection to ]
		ifFalse: [ self text empty ]
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
	
	self notifySelectionChanged: selection
]

{ #category : #accessing }
AlbTextEditor >> selectionRecorder [
	<return: #AlbTextEditorSelectionRecorder>

	^ selectionRecorder
]

{ #category : #'api - shortcuts' }
AlbTextEditor >> setEditorShortcuts: aTextEditorShortcuts [
	self
		assert: [ aTextEditorShortcuts isKindOf: AlbTextEditorShortcuts ]
		description: [ 'Must be an editor shortcuts object' ].
	
	self removeAllEditorShortcuts.
	
	shortcuts := aTextEditorShortcuts.
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
	
	self dispatchEvent: (AlbTextEditorTextStyleRequested new afterAction: aBlock)
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

	stylerStrategy := aToTextStylerStrategy
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
	
	self assertUIProcess.
	^ text
]

{ #category : #accessing }
AlbTextEditor >> text: aText [ 

	| t |
	t := aText asRopedText.
	"when reducing the text size we should update the selection and cursor positions"
	t size < text size ifTrue: [ 
		self navigator
			moveWithin: (0 to: t size);
			apply.

		self deselecter
			from: t size to: text size;
			deselect ].

	self restoreText: t
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

{ #category : #initialization }
AlbTextEditor >> useAsyncStylerStrategy [
	self stylerStrategy: AlbTextStylerAsyncStrategy new
]

{ #category : #initialization }
AlbTextEditor >> useDefaultStylerStrategy [
	self stylerStrategy: self defaultStylerStrategy
]

{ #category : #initialization }
AlbTextEditor >> useSyncStylerStrategy [
	self stylerStrategy: AlbTextStylerSyncStrategy new
]

{ #category : #initialization }
AlbTextEditor >> useTaskItStylerStrategy [
	self stylerStrategy: AlbTextStylerTaskItStrategy new
]

{ #category : #accessing }
AlbTextEditor >> viewInterval [
	^ self segmentCollector viewInterval
]

{ #category : #accessing }
AlbTextEditor >> viewInterval: anInterval [
	self segmentCollector viewInterval: anInterval
]

{ #category : #accessing }
AlbTextEditor >> wordStencil: aWordStencilBuilder [

	wordStencilBuilder := aWordStencilBuilder asStencilBuilder: AlbTextWordPieceStencilBuilder
]

{ #category : #accessing }
AlbTextEditor >> wordStencilBuilder [

	<return: #AlbTextWordPieceStencilBuilder>
	^ wordStencilBuilder
]
