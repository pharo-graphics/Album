"
I am a dynamic version of an adornment attribute that creates visual text adornments with the help of a provided stencil (builder).

I work together with ==AlbTextAdornmentStencilBuilder== to build a corresponding stencil for a text adornment.
Users should create a subclass of ==AlbTextAdornmentStencilBuilder== and override ==#buildDefault== that returns a new instance of an intended stencil or a new visual element (==BlElement==).

Once stencil builder is created it can be attached to the attribute as follows:
[[[
	AlbTextAdornmentDynamicAttribute new
		stencil: AlbTextAdornmentStencilBuilder new
]]]

For scripting purposes a block closure can be used instead. It can have two optional parameters:
 - a piece of text to be affected
 - and and instance of an editor element to get access to the editor model if it needs to be invalidated due to some user actions (for example trigger syntax highlighter to restyle a text)

[[[
	AlbTextAdornmentDynamicAttribute new
		stencil: [ :aBlText :aEditorElement |  BlElement new ""or AlbStencil that creates elements"" ]
]]]
"
Class {
	#name : 'AlbTextAdornmentDynamicAttribute',
	#superclass : 'AlbTextAdornmentAttribute',
	#instVars : [
		'stencilBuilder'
	],
	#category : 'Album-Attributes',
	#package : 'Album',
	#tag : 'Attributes'
}

{ #category : 'accessing' }
AlbTextAdornmentDynamicAttribute >> doAffect: aTTextEditorTextualPiece in: anEditorElement [
	"Return an element that should affect (either append or replace) a provided text piece"
	<return: #SequenceableCollection of: #BlElement>
	| aResult |

	aResult := stencilBuilder
		segmentPiece: aTTextEditorTextualPiece;
		editor: anEditorElement;
		build.

	aResult isCollection
		ifTrue: [ ^ aResult ].

	^ aResult asElement asOrderedCollection
]

{ #category : 'accessing' }
AlbTextAdornmentDynamicAttribute >> stencil: anAdornmentStencilBuilder [
	stencilBuilder := anAdornmentStencilBuilder "asStencilBuilder: AlbTextAdornmentStencilBuilder"
]

{ #category : 'printing' }
AlbTextAdornmentDynamicAttribute >> storeOn: aStream [
	super storeOn: aStream.
	
	aStream
		space;
		nextPutAll: #stencil: asString;
		space;
		nextPut: $(;
		store: stencilBuilder;
		nextPut: $)
]
