"
I'm an infinite element for text viewing and editing. I support scrolling, selection and other classical text editing features.
Text editing operations are driven by my data source (called textEditor). I also own a view model (viewModel) that serve as an interface for clients applicative model (such as a browser as an example).


"
Class {
	#name : #AlbEditorElement,
	#superclass : #BlElement,
	#traits : 'TAlbInfiniteDecorator + TOBlLayoutResizable',
	#classTraits : 'TAlbInfiniteDecorator classTrait + TOBlLayoutResizable classTrait',
	#instVars : [
		'next',
		'selectionElement'
	],
	#category : #'Album-UI'
}

{ #category : #initialization }
AlbEditorElement >> defaultBackground [

	^ BlBackground paint: Color white
]

{ #category : #initialization }
AlbEditorElement >> defaultLayout [

	^ BlFrameLayout new
]

{ #category : #initialization }
AlbEditorElement >> defaultMargin [

	^ BlInsets all: 1
]

{ #category : #initialization }
AlbEditorElement >> defaultPadding [

	^ BlInsets empty

]

{ #category : #initialization }
AlbEditorElement >> initialize [
	
	super initialize.
	self layout: self defaultLayout.
	self background: self defaultBackground.
	self margin: self defaultMargin.
	self padding: self defaultPadding.
	self next: AlbInfiniteTextEditorElement new.
	self addChild: next.
	self infinite editor when: BlInfiniteDataSourceChanged do: [ self initializeSelectionElement ].
	self matchParent
]

{ #category : #initialization }
AlbEditorElement >> initializeSelectionElement [

	selectionElement ifNotNil: [ :se | 
		se onUninstalledIn: self.
		se parentDo: [ se removeFromParent ] ].
	selectionElement := self mode selectionElement.
	selectionElement ifNotNil: [ :se | se onInstalledIn: self ]
]
