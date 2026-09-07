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

{ #category : #segments }
AlbEditorStructureTest >> test_segments_count0 [
	
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
