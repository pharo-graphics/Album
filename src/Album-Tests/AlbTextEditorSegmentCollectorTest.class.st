"
An AlbTextEditorSegmentCollectorTest is a test class for testing the behavior of AlbTextEditorSegmentCollector
"
Class {
	#name : #AlbTextEditorSegmentCollectorTest,
	#superclass : #TestCase,
	#instVars : [
		'file',
		'textEditor'
	],
	#category : #'Album-Tests-Model-Segment-Text'
}

{ #category : #tests }
AlbTextEditorSegmentCollectorTest class >> fileName [
	^ 'AlbumTestFile.txt' 
]

{ #category : #tests }
AlbTextEditorSegmentCollectorTest class >> openEditor [
	<script>
	| ed file textEditor t |
	file := self fileName asFileReference.
	t := BlRopedText file: file.
	textEditor := AlbTextEditor new text: t.
	ed := AlbEditor new.
	ed editor: textEditor.
	ed openInOblSpace 
	
]

{ #category : #tests }
AlbTextEditorSegmentCollectorTest >> assertSegmentIndicesMustCorrespondToTheInterval [
	| segmentsInterval |
	segmentsInterval := self segmentCollector cachedInterval.
	self
		assert: [ self segments size = segmentsInterval size ]
		description: [ 'Amount of segments must correspond to the interval' ].

	self
		assert: [
			| satisfy |
			satisfy := true.
			self segments with: segmentsInterval do: [ :eachSegment :anExpectedIndex |
				satisfy := satisfy and: [ eachSegment index = anExpectedIndex ]	].
			satisfy ]
		description: [ 'Segment indices must correspond to the interval' ].

		
	
	
	
	

	
]

{ #category : #accessing }
AlbTextEditorSegmentCollectorTest >> createFile: nbLines [

	file := self class fileName asFileReference.
	self deleteFile.
	file ensureCreateFile.
	file writeStreamDo: [ :stream | 
		1 to: nbLines do: [ :l | 
			stream << (l asString, ': 1234567890'); lf ] ].
	^ file
]

{ #category : #accessing }
AlbTextEditorSegmentCollectorTest >> deleteFile [

	file ifNotNil: [ file ensureDelete ]
]

{ #category : #accessing }
AlbTextEditorSegmentCollectorTest >> file [

	^ file
]

{ #category : #accessing }
AlbTextEditorSegmentCollectorTest >> fileRope [

	^ BlRopedText file: self file
]

{ #category : #accessing }
AlbTextEditorSegmentCollectorTest >> segmentCollector [

	^ textEditor segmentCollector
]

{ #category : #tests }
AlbTextEditorSegmentCollectorTest >> segmentTestBlock [

	^ [ :seg :string :textStart :textEnd :delimiterLength | 
	  self assert: seg text asString equals: string.
	  self assert: seg textStart equals: textStart.
	  self assert: seg textEnd equals: textEnd.
	  self assert: seg delimiterLength equals: delimiterLength ]
]

{ #category : #accessing }
AlbTextEditorSegmentCollectorTest >> segments [

	^ self segmentCollector segments
]

{ #category : #tests }
AlbTextEditorSegmentCollectorTest >> test_loadChangeFile_cacheLimit20_computeForwardAt40 [

	| seg segIdx |
	textEditor := AlbTextEditor new.
	textEditor text: Smalltalk changesFile readStream contents.
	textEditor segmentCollector cacheLimit: 20.
	self assertSegmentIndicesMustCorrespondToTheInterval.
	self assert: self segments size equals: 20.
	self segmentCollector computeForwardAt: 15.
	self assertSegmentIndicesMustCorrespondToTheInterval.
	segIdx := self segmentCollector cachedSegmentIndexAt: 500.
	seg := self segments at: segIdx.
	self segmentTestBlock valueWithArguments: {seg. '		spec package: #Toplo with: [ '. 476. 507 .1 }.


	
	
	

	
]

{ #category : #tests }
AlbTextEditorSegmentCollectorTest >> test_loadChangeFile_cacheLimit20_computeForwardFrom0ToFileSize [

	| seg segIdx cacheLimit |
	textEditor := AlbTextEditor new.
	textEditor text: Smalltalk changesFile readStream contents.
	cacheLimit := 20.
	self segmentCollector cacheLimit: cacheLimit.
	self assert: self segments size equals: cacheLimit.
	0 to: textEditor text size // 2 do: [ :pos | 
		segIdx := self segmentCollector cachedSegmentIndexAt: pos.
		segIdx isZero ifTrue: [ 
			"here, normally the last cached segment has been reach a round before"
			segIdx := self segmentCollector cachedSegmentIndexAt: pos - 1.
			self assert: segIdx \\ cacheLimit equals: 0.
			"rebuild forward cache"
			self segmentCollector computeForwardAt: self segmentCollector cachedInterval last.
			self assertSegmentIndicesMustCorrespondToTheInterval.
			segIdx := self segmentCollector cachedSegmentIndexAt: pos ].
		seg := self segments at: segIdx.
		self assertSegmentIndicesMustCorrespondToTheInterval ]
]

{ #category : #tests }
AlbTextEditorSegmentCollectorTest >> test_loadFile2_cacheLimit50 [

	| seg |
	self createFile: 2.
	self textEditorWithCacheLimit: 50.
	self assert: self segments size equals: 3.

	seg := self segments first.
	"seg. string. textStart. textEnd. delimiterLength"
	self segmentTestBlock valueWithArguments: {seg. '1234567890'. 0. 10. 1 }.
	seg := self segments second.
	self segmentTestBlock valueWithArguments: {seg. '1234567890'. 11. 21.  1}.
	seg := self segments third.
	self segmentTestBlock valueWithArguments: {seg. ''. 22. 22 .0}
	
]

{ #category : #tests }
AlbTextEditorSegmentCollectorTest >> test_loadFile400_cacheLimit20_computeForwardAt40 [

	| seg segIdx |
	self createFile: 400.
	self textEditorWithCacheLimit: 20.
	self assert: self segments size equals: 20.
	self segmentCollector computeForwardAt: 15.
	self assertSegmentIndicesMustCorrespondToTheInterval.
	segIdx := self segmentCollector cachedSegmentIndexAt: 330.
	seg := self segments at: segIdx.
	self segmentTestBlock valueWithArguments: {seg. '1234567890'. 330. 340 .1 }.


	
	
	

	
]

{ #category : #tests }
AlbTextEditorSegmentCollectorTest >> test_loadFile4_cacheLimit3 [

	| seg |
	self createFile: 4.
	self textEditorWithCacheLimit: 3.
	self assert: self segments size equals: 3.
	
	seg := self segments first.
	"seg. string. textStart. textEnd. delimiterLength"
	self segmentTestBlock valueWithArguments: {seg. '1234567890'.  0. 10. 1 }.
	seg := self segments second.
	self segmentTestBlock valueWithArguments: {seg. '1234567890'. 11. 21. 1 }.
	seg := self segments third.
	self segmentTestBlock valueWithArguments: {seg. '1234567890'. 22. 32 .1 }.

	
]

{ #category : #tests }
AlbTextEditorSegmentCollectorTest >> test_loadFile4_cacheLimit3_computeForwardAt4 [

	| seg segIdx |
	self createFile: 4.
	"self textEditorWithCacheLimit: 30.
	self assert: self segments size equals: 5.
	self segmentCollector computeForwardAt: 4.
	segIdx := self segmentCollector cachedSegmentIndexAt: 33.
	seg := self segments at: segIdx.
	self segmentTestBlock valueWithArguments: {seg. '1234567890'. 33. 43 .1 }."
	
	self textEditorWithCacheLimit: 3.
	self assert: self segments size equals: 3.
	self segmentCollector computeForwardAt: 4.
	segIdx := self segmentCollector cachedSegmentIndexAt: 33.
	seg := self segments at: segIdx.
	self segmentTestBlock valueWithArguments: {seg. '1234567890'. 33. 43 .1 }.


	
	
	

	
]

{ #category : #tests }
AlbTextEditorSegmentCollectorTest >> test_loadFile4_cacheLimit50 [

	| seg |
	self createFile: 4.
	self textEditorWithCacheLimit: 50.
	self assert: self segments size equals: 5.
	
	seg := self segments first.
	"seg. string. textStart. textEnd. delimiterLength"
	self segmentTestBlock valueWithArguments: {seg. '1234567890'.  0. 10. 1 }.
	seg := self segments second.
	self segmentTestBlock valueWithArguments: {seg. '1234567890'. 11. 21. 1 }.
	seg := self segments third.
	self segmentTestBlock valueWithArguments: {seg. '1234567890'. 22. 32 .1 }.
	seg := self segments fourth.
	self segmentTestBlock valueWithArguments: {seg. '1234567890'. 33. 43 .1 }.
	seg := self segments fifth.
	self segmentTestBlock valueWithArguments: {seg. ''. 44. 44 .0}


	
]

{ #category : #accessing }
AlbTextEditorSegmentCollectorTest >> textEditorWithCacheLimit: anInteger [ 

	textEditor := AlbTextEditor new text: self fileRope.
	textEditor segmentCollector cacheLimit: anInteger.
		
	^ textEditor
]
