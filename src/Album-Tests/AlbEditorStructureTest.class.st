Class {
	#name : #AlbEditorStructureTest,
	#superclass : #BlSpaceTestCase,
	#instVars : [
		'editor'
	],
	#category : #'Album-Tests-TextEditor'
}

{ #category : #initialization }
AlbEditorStructureTest >> setUp [

	super setUp.
	space extent: 400 @ 300.
	editor := AlbInfiniteEditorElement new.
	editor exact: 400 @ 300.
	space deferAndSettle: [ space root addChild: editor ]
]

{ #category : #tests }
AlbEditorStructureTest >> testEditorElementLineIndexAtTextIndex [

	| multiLineText compositeEditor |
	multiLineText := 'First line', String cr, 'Second line', String cr, 'Third line'.
	compositeEditor := AlbEditorElement new.
	compositeEditor exact: 400 @ 300.
	space deferAndSettle: [ 
		space root removeChildren.
		space root addChild: compositeEditor.
		compositeEditor text: multiLineText ].
	self assert: (compositeEditor lineIndexAtTextIndex: 1) equals: 1.
	self assert: (compositeEditor lineIndexAtTextIndex: 12) equals: 2.
	self assert: (compositeEditor lineIndexAtTextIndex: 25) equals: 3.
	self assert: (compositeEditor lineIndexAtTextIndex: 100) equals: nil
]

{ #category : #tests }
AlbEditorStructureTest >> testInfiniteEditorLineIndexAtTextIndex [

	| multiLineText |
	multiLineText := 'First line', String cr, 'Second line', String cr, 'Third line'.
	space deferAndSettle: [ editor text: multiLineText ].
	self assert: (editor lineIndexAtTextIndex: 1) equals: 1.
	self assert: (editor lineIndexAtTextIndex: 12) equals: 2.
	self assert: (editor lineIndexAtTextIndex: 25) equals: 3.
	self assert: (editor lineIndexAtTextIndex: 100) equals: nil
]

{ #category : #tests }
AlbEditorStructureTest >> testSegmentsCount [

	| segments |
	segments := editor children
		select: [ :eachChild | eachChild isKindOf: AlbTextEditorSegmentElement ].	
	self assert: segments size equals: 1.
	
	space deferAndSettle: [ editor text: 'A' ].
	self assert: editor children size equals: 1.
	segments := editor children
		select: [ :eachChild | eachChild isKindOf: AlbTextEditorSegmentElement ].	
	self assert: segments size equals: 1.
	
	space deferAndSettle: [ editor text: 'A A' ].
	self assert: editor children size equals: 1.
	segments := editor children
		select: [ :eachChild | eachChild isKindOf: AlbTextEditorSegmentElement ].	
	self assert: segments size equals: 1.
	
	space deferAndSettle: [ editor text: 'A A', String cr ].
	self assert: editor children size equals: 2.
	segments := editor children
		select: [ :eachChild | eachChild isKindOf: AlbTextEditorSegmentElement ].	
	self assert: editor children size equals: 2
]

{ #category : #tests }
AlbEditorStructureTest >> testTextElementLineIndexWithoutParent [

	self assert: AlbTextElement new lineIndex equals: nil
]
