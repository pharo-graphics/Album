Class {
	#name : #AlbEditorStructureTest,
	#superclass : #TestCase,
	#instVars : [
		'editor'
	],
	#category : #'Album-Tests-TextEditor'
}

{ #category : #initialization }
AlbEditorStructureTest >> setUp [
	editor := AlbInfiniteEditorElement new.
]

{ #category : #segments }
AlbEditorStructureTest >> test_segments_count0 [
	
	| segments |
	

	segments := editor children
		select: [ :eachChild | eachChild isKindOf: AlbTextEditorSegmentElement ].	
	self assert: segments size equals: 0.
	
	editor text: 'A'.
	self assert: editor children size isZero.

	editor forceLayout.
	self assert: editor children size equals: 1.

	segments := editor children
		select: [ :eachChild | eachChild isKindOf: AlbTextEditorSegmentElement ].	
	self assert: segments size equals: 1.
	
	editor text: 'A A'.
	self assert: editor children size equals: 1.

	editor forceLayout.
	self assert: editor children size equals: 1.

	segments := editor children
		select: [ :eachChild | eachChild isKindOf: AlbTextEditorSegmentElement ].	
	self assert: segments size equals: 1.
	
	editor text: 'A A', String cr.
	self assert: editor children size equals: 1.

	editor forceLayout.
	self assert: editor children size equals: 2.

	segments := editor children
		select: [ :eachChild | eachChild isKindOf: AlbTextEditorSegmentElement ].	
	self assert: segments size equals: 2.


]
