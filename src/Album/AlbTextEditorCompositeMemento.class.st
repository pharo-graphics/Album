Class {
	#name : #AlbTextEditorCompositeMemento,
	#superclass : #AlbTextEditorMemento,
	#instVars : [
		'mementos'
	],
	#category : #'Album-Model-Memento'
}

{ #category : #'api - memento' }
AlbTextEditorCompositeMemento >> addMemento: aMemento [
	mementos add: aMemento
]

{ #category : #'api - memento' }
AlbTextEditorCompositeMemento >> all [
	self
		cursors;
		history;
		inputFilter;
		mode;
		selection;
		shortcuts;
		text
]

{ #category : #'api - memento' }
AlbTextEditorCompositeMemento >> cursors [
	mementos add: AlbTextEditorCursorsMemento new
]

{ #category : #'api - memento' }
AlbTextEditorCompositeMemento >> history [
	mementos add: AlbTextEditorHistoryMemento new
]

{ #category : #initialization }
AlbTextEditorCompositeMemento >> initialize [
	super initialize.
	
	mementos := SortedCollection sortUsing: [ :a :b | a order < b order ]
]

{ #category : #'api - memento' }
AlbTextEditorCompositeMemento >> inputFilter [
	mementos add: AlbTextEditorInputFilterMemento new
]

{ #category : #evaluating }
AlbTextEditorCompositeMemento >> label [
	^ 'Composite ({1})' format: { self mementos size }
]

{ #category : #'api - accessing' }
AlbTextEditorCompositeMemento >> mementoOfType: aMementoType do: aBlock [
	self mementos
		detect: [ :eachMemento | eachMemento isKindOf: aMementoType ]
		ifFound: aBlock
]

{ #category : #accessing }
AlbTextEditorCompositeMemento >> mementos [
	^ mementos 
]

{ #category : #'api - memento' }
AlbTextEditorCompositeMemento >> mode [

]

{ #category : #accessing }
AlbTextEditorCompositeMemento >> order [
	^ self shouldNotImplement
]

{ #category : #memento }
AlbTextEditorCompositeMemento >> restoreStateOf: aTextEditor [
	mementos do: [ :eachMemento | eachMemento restoreStateOf: aTextEditor ]
]

{ #category : #memento }
AlbTextEditorCompositeMemento >> saveStateOf: aTextEditor [
	mementos do: [ :eachMemento | eachMemento saveStateOf: aTextEditor ]
]

{ #category : #'api - memento' }
AlbTextEditorCompositeMemento >> selection [
	mementos add: AlbTextEditorSelectionMemento new
]

{ #category : #'api - accessing' }
AlbTextEditorCompositeMemento >> selectionDo: aBlock [
	self
		mementoOfType: AlbTextEditorSelectionMemento
		do: [ :aSelectionMemento | aBlock value: aSelectionMemento selection ]
]

{ #category : #'api - memento' }
AlbTextEditorCompositeMemento >> shortcuts [
	mementos add: AlbTextEditorShortcutsMemento new
]

{ #category : #'api - memento' }
AlbTextEditorCompositeMemento >> text [
	mementos add: AlbTextEditorTextMemento new
]

{ #category : #'api - accessing' }
AlbTextEditorCompositeMemento >> textDo: aBlock [
	self
		mementoOfType: AlbTextEditorTextMemento
		do: [ :aTextMemento | aBlock value: aTextMemento value ]
]

{ #category : #evaluating }
AlbTextEditorCompositeMemento >> value [
	^ self mementos
]
