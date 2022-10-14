Class {
	#name : #Album,
	#superclass : #BlElement,
	#traits : 'TOBlLayoutResizable',
	#classTraits : 'TOBlLayoutResizable classTrait',
	#instVars : [
		'editorElement',
		'editionFlagLayer'
	],
	#category : #'Album-UI'
}

{ #category : #'instance creation' }
Album class >> forPharoCode [

	^ self new forPharoCode
]

{ #category : #layers }
Album >> addLayer: anAlbumLayer [

	anAlbumLayer attachTo: self editorElement.
	self addChild: anAlbumLayer
]

{ #category : #initialization }
Album >> defaultEditorElement [

	^ AlbEditorElement new dresser: AlbTextAreaDresser new
]

{ #category : #accessing }
Album >> editorElement [

	^ editorElement
]

{ #category : #accessing }
Album >> editorElement: anEditorElement [
	editorElement ifNotNil: [ editorElement removeFromParent ].
	editorElement := anEditorElement.
	self addChild: anEditorElement
]

{ #category : #initialization }
Album >> forPharoCode [

	self viewModel: AlbEditorPharoCodeModel new.
	self withEditionFlagLayer 
]

{ #category : #initialization }
Album >> initialize [

	super initialize.
	self constraintsDo: [ :c | 
		c horizontal matchParent.
		c vertical matchParent ].
	self editorElement: self defaultEditorElement.
]

{ #category : #layers }
Album >> removeLayer: anAlbumLayer [

	anAlbumLayer detach.
	self removeChild: anAlbumLayer
]

{ #category : #'text - accessing' }
Album >> text [

	^ self editorElement viewModel text
]

{ #category : #'text - accessing' }
Album >> text: aBlText [

	self editorElement viewModel text: aBlText
]

{ #category : #accessing }
Album >> viewModel [ 

	^ self editorElement viewModel
]

{ #category : #accessing }
Album >> viewModel: aViewModel [ 

	self editorElement viewModel: aViewModel
]

{ #category : #layers }
Album >> withEditionFlagLayer [

	editionFlagLayer ifNotNil: [ ^ self ].
	editionFlagLayer := AlbumEditionFlagLayer new.
	self addLayer: editionFlagLayer
]

{ #category : #initialization }
Album >> withLineNumbers [

	self editorElement withLineNumbers
]

{ #category : #layers }
Album >> withoutEditionFlagLayer [

	editionFlagLayer ifNil: [ ^ self ].
	self removeLayer: editionFlagLayer.
	editionFlagLayer := nil
]

{ #category : #initialization }
Album >> withoutLineNumbers [

	self editorElement withoutLineNumbers
]
