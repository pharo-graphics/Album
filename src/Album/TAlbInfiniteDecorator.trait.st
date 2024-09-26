Trait {
	#name : #TAlbInfiniteDecorator,
	#category : #'Album-UI'
}

{ #category : #'t - infinite editor accessing - editor' }
TAlbInfiniteDecorator >> addEditorShortcut: aTextEditorInteraction [

	self next addEditorShortcut: aTextEditorInteraction
]

{ #category : #'t - infinite editor private - accessing text' }
TAlbInfiniteDecorator >> atTextIndex: aTextIndex do: aBlock [

	" aBlock takes 2 arguments : the local text element and the local text index within the local text element"
	self next atTextIndex: aTextIndex do: aBlock
]

{ #category : #'t - infinite editor view - configuration' }
TAlbInfiniteDecorator >> beEditable [

	self next beEditable
]

{ #category : #'t - infinite editor view - configuration' }
TAlbInfiniteDecorator >> beReadonlyWithSelection [

	self next beReadonlyWithSelection
]

{ #category : #'t - infinite editor view - configuration' }
TAlbInfiniteDecorator >> beReadonlyWithoutSelection [

	self next beReadonlyWithoutSelection
]

{ #category : #'t - infinite editor private - accessing editor' }
TAlbInfiniteDecorator >> cacheSize: aNumber [

	self next cacheSize: aNumber
]

{ #category : #'t - infinite editor completing' }
TAlbInfiniteDecorator >> completeWordSuffixFromString: aString [

	self next completeWordSuffixFromString: aString
]

{ #category : #'t - infinite editor accessing - cursor' }
TAlbInfiniteDecorator >> cursor [

	^ self next cursor
]

{ #category : #'t - infinite editor accessing - cursor' }
TAlbInfiniteDecorator >> cursorColor: aColor [

	self next cursorColor: aColor
]

{ #category : #'t - infinite editor accessing - cursor' }
TAlbInfiniteDecorator >> cursorElement [

	^ self next cursorElement
]

{ #category : #'t - infinite editor accessing - cursor' }
TAlbInfiniteDecorator >> cursors [
	<return: #AlbTextEditorCursor>
	
	^ self next cursors
]

{ #category : #'t - infinite editor editor - operator' }
TAlbInfiniteDecorator >> deleter [
	<return: #AlbTextEditorDeleter>

	^ self next deleter
]

{ #category : #'t - infinite editor editor - operator' }
TAlbInfiniteDecorator >> deselecter [
	<return: #AlbTextEditorDeselecter>

	^ self next deselecter
]

{ #category : #'t - infinite editor accessing - editor' }
TAlbInfiniteDecorator >> editor [
	<return: #AlbTextEditor>

	^ self next editor
]

{ #category : #'t - infinite editor view - configuration' }
TAlbInfiniteDecorator >> editorDo: aBlock [

	self next editorDo: aBlock
]

{ #category : #'t - infinite editor accessing - text' }
TAlbInfiniteDecorator >> enlargedSubTextOnScreen [
	
	^ self next enlargedSubTextOnScreen 
]

{ #category : #'t - infinite editor accessing - selection' }
TAlbInfiniteDecorator >> hasSelection [

	^ self next hasSelection
]

{ #category : #'t - infinite editor accessing' }
TAlbInfiniteDecorator >> infinite [

	^ self next infinite
]

{ #category : #'t - infinite editor accessing' }
TAlbInfiniteDecorator >> infiniteDo: aBlock [

	aBlock value: self infinite
]

{ #category : #'t - infinite editor accessing - editor' }
TAlbInfiniteDecorator >> inputFilter: aTextEditorInputFilter [

	self next inputFilter: aTextEditorInputFilter
]

{ #category : #'t - infinite editor editor - operator' }
TAlbInfiniteDecorator >> inserter [
	<return: #AlbTextEditorInserter>

	^ self next inserter
]

{ #category : #'t - infinite editor accessing - editor' }
TAlbInfiniteDecorator >> isEditable [

	^ self next isEditable
]

{ #category : #'t - infinite editor accessing - mode' }
TAlbInfiniteDecorator >> mode [

	<return: #BlText>

	^ self next mode
]

{ #category : #'t - infinite editor accessing - mode' }
TAlbInfiniteDecorator >> mode: anEditabilityMode [

	self next mode: anEditabilityMode
]

{ #category : #'t - infinite editor editor - operator' }
TAlbInfiniteDecorator >> navigator [
	<return: #AlbTextEditorNavigator>

	^ self next navigator
]

{ #category : #'t - infinite editor accessing' }
TAlbInfiniteDecorator >> next [

	^ self explicitRequirement 
]

{ #category : #'t - infinite editor accessing' }
TAlbInfiniteDecorator >> next: aDecoratorOrInfinite [

	self explicitRequirement 
]

{ #category : #'t - infinite editor accessing - editor' }
TAlbInfiniteDecorator >> removeEditorShortcut: aTextEditorInteraction [

	self next removeEditorShortcut: aTextEditorInteraction
]

{ #category : #'t - infinite editor accessing' }
TAlbInfiniteDecorator >> rootAlbumElement: anAlbumElement [

	self next rootAlbumElement: anAlbumElement
]

{ #category : #'t - infinite editor private - accessing editor' }
TAlbInfiniteDecorator >> segments [
	^ self next segments
]

{ #category : #'t - infinite editor accessing - selection' }
TAlbInfiniteDecorator >> selectedText [

	^ self next selectedText
]

{ #category : #'t - infinite editor editor - operator' }
TAlbInfiniteDecorator >> selecter [
	<return: #AlbTextEditorSelecter>

	^ self next selecter
]

{ #category : #'t - infinite editor accessing - selection' }
TAlbInfiniteDecorator >> selection [
	<return: #BlSelection>

	^ self next selection
]

{ #category : #'t - infinite editor accessing - selection' }
TAlbInfiniteDecorator >> selectionColor [

	^ self next selectionColor
]

{ #category : #'t - infinite editor accessing - text' }
TAlbInfiniteDecorator >> subTextOnScreen [
	
	^ self next subTextOnScreen 
]

{ #category : #'t - infinite editor accessing - text' }
TAlbInfiniteDecorator >> subTextOnScreenInterval [
	
	^ self next subTextOnScreenInterval 
]

{ #category : #'t - infinite editor accessing - text' }
TAlbInfiniteDecorator >> text [
	"Return a text I work with. All modifications to a text must be done from UI thread"
	<return: #BlText>

	^ self next text
]

{ #category : #'t - infinite editor accessing - text' }
TAlbInfiniteDecorator >> text: aText [

	self next text: aText
]

{ #category : #'t - infinite editor private - view accessing' }
TAlbInfiniteDecorator >> textElementsDo: aBlock [

	self next textElementsDo: aBlock
]

{ #category : #'t - infinite editor private - accessing text' }
TAlbInfiniteDecorator >> textInternalRepresentationChanged [

	self next textInternalRepresentationChanged
]

{ #category : #'t - infinite editor accessing - text' }
TAlbInfiniteDecorator >> textLeft [

	^  self padding left + self next textLeft
]

{ #category : #'t - infinite editor private - accessing text' }
TAlbInfiniteDecorator >> textPiecesAndTheirElementsWithinIndexInterval: anInterval do: aBlock [

	self next textPiecesAndTheirElementsWithinIndexInterval: anInterval do: aBlock
]

{ #category : #'t - infinite editor accessing - text' }
TAlbInfiniteDecorator >> textSnapshot [
	"Return a snaphost (copy) of the current text.
	I am safe to use from a non-UI thread because the returned text is independent from the
	current one and can be safely modified"
	<return: #BlText>

	^ self next textSnapshot
]

{ #category : #'t - infinite editor view - configuration' }
TAlbInfiniteDecorator >> whenTextEditedDo: aBlock [

	self deprecated: 'Use directly editorDo: [:ed | ed when: AlbTextEditedEvent do: ] instead'. 
	self next whenTextEditedDo: aBlock
]

{ #category : #'t - infinite editor view - configuration' }
TAlbInfiniteDecorator >> whenTextReplacedDo: aBlock [

	self next whenTextReplacedDo: aBlock
]

{ #category : #'t - infinite editor view - configuration' }
TAlbInfiniteDecorator >> withRowNumbers [

	self next withRowNumbers
]

{ #category : #'t - infinite editor view - configuration' }
TAlbInfiniteDecorator >> withSoftLine [

	self next withSoftLine
]

{ #category : #'t - infinite editor accessing' }
TAlbInfiniteDecorator >> withoutCacheLimit [

	self next withoutCacheLimit
]

{ #category : #'t - infinite editor view - configuration' }
TAlbInfiniteDecorator >> withoutRowNumbers [

	self next withoutRowNumbers
]

{ #category : #'t - infinite editor view - configuration' }
TAlbInfiniteDecorator >> withoutSoftLine [

	self next withoutSoftLine
]

{ #category : #'t - infinite editor private - view accessing' }
TAlbInfiniteDecorator >> wordStencil [

	^ self next wordStencil
]

{ #category : #'t - infinite editor private - view accessing' }
TAlbInfiniteDecorator >> wordStencil: aWordStencil [

	self next wordStencil: aWordStencil
]
