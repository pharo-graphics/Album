Class {
	#name : #AlbEditorTextFlowLayoutExamples,
	#superclass : #TestCase,
	#category : #'Album-Examples-Layout'
}

{ #category : #'instance creation' }
AlbEditorTextFlowLayoutExamples >> testContainer [
	
	<demo>
	<sampleInstance>
	
	| anElement |
	
	anElement := BlElement new
		layout: (AlbLineFlowLayout new lineSpacing: 10);
		constraintsDo: [ :c |
			c horizontal exact: 500.
			c vertical fitContent ];
		addChildren: (20 timesCollect: [
			BlElement new
				extent: 75@30;
				margin: (BlInsets all: 4);
				background: (Color random alpha: 0.5) ]).
			
	^ anElement
]

{ #category : #'examples - layout' }
AlbEditorTextFlowLayoutExamples >> testContainerExtent [
	<demo>
	<sampleInstance>
	
	| aContainer |
	aContainer := self testContainer.
	aContainer forceLayout.
	self assert: aContainer extent equals: 500.0@182.0.
	^ aContainer
]

{ #category : #'examples - layout' }
AlbEditorTextFlowLayoutExamples >> testLayoutNoMemoryLeak [
	<demo>
	<sampleInstance>
	
	| aContainer |
	
	aContainer := self testContainerExtent.
	
	self assert: aContainer layout hasLines.
	self assert: aContainer layout hasElements.
	aContainer onRemovedFromSceneGraph.
	self assert: aContainer layout hasLines.
	self assert: aContainer layout hasElements not.
	
	^ aContainer
]
