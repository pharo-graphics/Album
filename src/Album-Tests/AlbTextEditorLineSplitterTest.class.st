Class {
	#name : #AlbTextEditorLineSplitterTest,
	#superclass : #TestCase,
	#category : #'Album-Tests-TextEditor'
}

{ #category : #accessing }
AlbTextEditorLineSplitterTest >> beReplaceTextAttribute [

	^ AlbTextAdornmentDynamicAttribute new
		beReplace;
		stencil: [ BlElement new 
			size: 10@10; 
			background: Color lightGray ]
]

{ #category : #accessing }
AlbTextEditorLineSplitterTest >> beReplaceTextAttributeReturningEmptyCollection [

	^ AlbTextAdornmentDynamicAttribute new
		beReplace;
		stencil: [ #() ]
]

{ #category : #accessing }
AlbTextEditorLineSplitterTest >> beReplaceTextAttributeReturningTwoElements [

	^ AlbTextAdornmentDynamicAttribute new
		beReplace;
		stencil: [ 
			{ BlElement new 
				size: 10@10; 
				background: Color lightGray.
			 BlElement new 
				size: 10@10; 
				background: Color gray } ]
]

{ #category : #'split subtext' }
AlbTextEditorLineSplitterTest >> test_splitSub_Hello_from_HabaHelloFoo [
	| aText aSubText aSplitter aStream |

	aText := 'HabaHelloFoo' asRopedText.
	aSubText := aText from: 5 to: 9.

	aSplitter := self textLineSplitter.
	aStream := self textSegmentStream.

	aSplitter split: aSubText in: aStream.

	self assert: aStream segments size equals: 1.
	self assert: aStream segments first textStart equals: 0.
	self assert: aStream segments first textEnd equals: 5.

	^ aStream
]

{ #category : #split }
AlbTextEditorLineSplitterTest >> test_split_BeReplacedTextAtributeReturningEmptyCollection_FollowedByLf [

	| aText aSplitter aStream aTextAttribute theAttributes |

	aTextAttribute := self beReplaceTextAttributeReturningEmptyCollection.
	aText := 'Hello' asRopedText attribute: aTextAttribute.
	
	self assert: aText size equals: 5.
	theAttributes := (aText from: aText size to: aText size) iterator attributes.
	self assert: theAttributes size equals: 1.
	self assert: theAttributes first equals: aTextAttribute.

	aText insertString: String lf at: aText size.
	self assert: aText size equals: 6.
	theAttributes := (aText from: aText size to: aText size) iterator attributes.
	self assert: theAttributes size equals: 1.
	self assert: theAttributes first equals: aTextAttribute.
	
	aSplitter := self textLineSplitter.
	aStream := self textSegmentStream.

	aSplitter split: aText in: aStream.

	self assert: aStream contents size equals: 2.
	self assert: aStream contents first textStart equals: 0.
	self assert: aStream contents first textEnd equals: 5.
	
	self assert: aStream contents second textStart equals: 6.
	self assert: aStream contents second textEnd equals: 6.

	^ aStream
]

{ #category : #split }
AlbTextEditorLineSplitterTest >> test_split_BeReplacedTextAtributeReturningTwoElements_FollowedByLf [
	| aText aSplitter aStream aTextAttribute theAttributes |

	aTextAttribute := self beReplaceTextAttributeReturningTwoElements.
	aText := 'Hello' asRopedText attribute: aTextAttribute.
	
	self assert: aText size equals: 5.
	theAttributes := (aText from: aText size to: aText size) iterator attributes.
	self assert: theAttributes size equals: 1.
	self assert: theAttributes first equals: aTextAttribute.

	aText insertString: String lf at: aText size.
	self assert: aText size equals: 6.
	theAttributes := (aText from: aText size to: aText size) iterator attributes.
	self assert: theAttributes size equals: 1.
	self assert: theAttributes first equals: aTextAttribute.
	
	aSplitter := self textLineSplitter.
	aStream := self textSegmentStream.

	aSplitter split: aText in: aStream.

	self assert: aStream contents size equals: 2.
	self assert: aStream contents first textStart equals: 0.
	self assert: aStream contents first textEnd equals: 5.
	
	self assert: aStream contents second textStart equals: 6.
	self assert: aStream contents second textEnd equals: 6.

	^ aStream
]

{ #category : #split }
AlbTextEditorLineSplitterTest >> test_split_BeReplacedTextAtribute_FollowedByLf [
	| aText aSplitter aStream aTextAttribute theAttributes |

	aTextAttribute := self beReplaceTextAttribute.
	aText := 'Hello' asRopedText attribute: aTextAttribute.
	
	self assert: aText size equals: 5.
	theAttributes := (aText from: aText size to: aText size) iterator attributes.
	self assert: theAttributes size equals: 1.
	self assert: theAttributes first equals: aTextAttribute.

	aText insertString: String lf at: aText size.
	self assert: aText size equals: 6.
	theAttributes := (aText from: aText size to: aText size) iterator attributes.
	self assert: theAttributes size equals: 1.
	self assert: theAttributes first equals: aTextAttribute.
	
	aSplitter := self textLineSplitter.
	aStream := self textSegmentStream.

	aSplitter split: aText in: aStream.

	self assert: aStream contents size equals: 2.
	self assert: aStream contents first textStart equals: 0.
	self assert: aStream contents first textEnd equals: 5.
	
	self assert: aStream contents second textStart equals: 6.
	self assert: aStream contents second textEnd equals: 6.

	^ aStream
]

{ #category : #split }
AlbTextEditorLineSplitterTest >> test_split_Cr [
	| aText aSplitter aStream aSegment |

	aText := String cr asRopedText.
	aSplitter := self textLineSplitter.
	aStream := self textSegmentStream.

	aSplitter split: aText in: aStream.

	self assert: aStream contents size equals: 2.

	aSegment := aStream contents first.
	self assert: aSegment textStart equals: 0.
	self assert: aSegment textEnd equals: 0.
	self assert: aSegment textEndDelimited equals: 1.
	self assert: aSegment text asString equals: ''.
	
	aSegment := aStream segments second.
	self assert: aSegment textStart equals: 1.
	self assert: aSegment textEnd equals: 1.
	self assert: aSegment textEndDelimited equals: 1.
	self assert: aSegment text asString equals: ''.

	^ aStream
]

{ #category : #split }
AlbTextEditorLineSplitterTest >> test_split_CrCr [
	| aText aSplitter aStream aSegment |

	aText := (String cr, String cr) asRopedText.
	aSplitter := self textLineSplitter.
	aStream := self textSegmentStream.

	aSplitter split: aText in: aStream.

	self assert: aStream segments size equals: 3.
	
	aSegment := aStream contents first.
	self assert: aSegment textStart equals: 0.
	self assert: aSegment textEnd equals: 0.
	self assert: aSegment textEndDelimited equals: 1.
	self assert: aSegment text asString equals: ''.
	
	aSegment := aStream contents second.
	self assert: aSegment textStart equals: 1.
	self assert: aSegment textEnd equals: 1.
	self assert: aSegment textEndDelimited equals: 2.
	self assert: aSegment text asString equals: ''.
	
	aSegment := aStream contents third.
	self assert: aSegment textStart equals: 2.
	self assert: aSegment textEnd equals: 2.
	self assert: aSegment textEndDelimited equals: 2.
	self assert: aSegment text asString equals: ''.

	^ aStream
]

{ #category : #split }
AlbTextEditorLineSplitterTest >> test_split_CrLf [
	| aText aSplitter aStream aSegment |

	aText := (String cr, String lf) asRopedText.
	aSplitter := self textLineSplitter.
	aStream := self textSegmentStream.

	aSplitter split: aText in: aStream.

	self assert: aStream segments size equals: 2.
	
	aSegment := aStream segments first.
	self assert: aSegment textStart equals: 0.
	self assert: aSegment textEnd equals: 0.
	self assert: aSegment textEndDelimited equals: 2.
	self assert: aSegment text asString equals: ''.
	
	aSegment := aStream segments second.
	self assert: aSegment textStart equals: 2.
	self assert: aSegment textEnd equals: 2.
	self assert: aSegment textEndDelimited equals: 2.
	self assert: aSegment text asString equals: ''.

	^ aStream
]

{ #category : #split }
AlbTextEditorLineSplitterTest >> test_split_CrLfCrLf [

	| aText aSplitter aStream aSegment |

	aText := (String cr, String lf, String cr, String lf) asRopedText.
	aSplitter := self textLineSplitter.
	aStream := self textSegmentStream.

	aSplitter split: aText in: aStream.

	self assert: aStream segments size equals: 3.
	
	aSegment := aStream segments first.
	self assert: aSegment textStart equals: 0.
	self assert: aSegment textEnd equals: 0.
	self assert: aSegment textEndDelimited equals: 2.
	self assert: aSegment text asString equals: ''.
	
	aSegment := aStream segments second.
	self assert: aSegment textStart equals: 2.
	self assert: aSegment textEnd equals: 2.
	self assert: aSegment textEndDelimited equals: 4.
	self assert: aSegment text asString equals: ''.
	
	aSegment := aStream segments third.
	self assert: aSegment textStart equals: 4.
	self assert: aSegment textEnd equals: 4.
	self assert: aSegment textEndDelimited equals: 4.
	self assert: aSegment text asString equals: ''.

	^ aStream
]

{ #category : #split }
AlbTextEditorLineSplitterTest >> test_split_Cra [

	| aText aSplitter aStream aSegment |

	aText := (String cr, 'a') asRopedText.
	aSplitter := self textLineSplitter.
	aStream := self textSegmentStream.

	aSplitter split: aText in: aStream.

	self assert: aStream segments size equals: 2.
	
	aSegment := aStream segments first.
	self assert: aSegment textStart equals: 0.
	self assert: aSegment textEnd equals: 0.
	self assert: aSegment text asString equals: ''.
	
	aSegment := aStream segments second.
	self assert: aSegment textStart equals: 1.
	self assert: aSegment textEnd equals: 2.
	self assert: aSegment text asString equals: 'a'.

	^ aStream
]

{ #category : #split }
AlbTextEditorLineSplitterTest >> test_split_CraCr [
	| aText aSplitter aStream aSegment |

	aText := (String cr, 'a', String cr) asRopedText.
	aSplitter := self textLineSplitter.
	aStream := self textSegmentStream.

	aSplitter split: aText in: aStream.

	self assert: aStream segments size equals: 3.

	aSegment := aStream segments first.
	self assert: aSegment textStart equals: 0.
	self assert: aSegment textEnd equals: 0.
	self assert: aSegment text asString equals: ''.
	
	aSegment := aStream segments second.
	self assert: aSegment textStart equals: 1.
	self assert: aSegment textEnd equals: 2.
	self assert: aSegment text asString equals: 'a'.
	
	aSegment := aStream segments third.
	self assert: aSegment textStart equals: 3.
	self assert: aSegment textEnd equals: 3.
	self assert: aSegment text asString equals: ''.

	^ aStream
]

{ #category : #split }
AlbTextEditorLineSplitterTest >> test_split_CraCrLf [
	| aText aSplitter aStream aSegment |

	aText := (String cr, 'a', String cr, String lf) asRopedText.
	aSplitter := self textLineSplitter.
	aStream := self textSegmentStream.

	aSplitter split: aText in: aStream.

	self assert: aStream segments size equals: 3.
	
	aSegment := aStream segments first.
	self assert: aSegment textStart equals: 0.
	self assert: aSegment textEnd equals: 0.
	self assert: aSegment text asString equals: ''.
	
	aSegment := aStream segments second.
	self assert: aSegment textStart equals: 1.
	self assert: aSegment textEnd equals: 2.
	self assert: aSegment text asString equals: 'a'.
	
	aSegment := aStream segments third.
	self assert: aSegment textStart equals: 4.
	self assert: aSegment textEnd equals: 4.
	self assert: aSegment text asString equals: ''.

	^ aStream
]

{ #category : #split }
AlbTextEditorLineSplitterTest >> test_split_CraCrLfb [
	| aText aSplitter aStream aSegment |

	aText := (String cr, 'a', String cr, String lf, 'b') asRopedText.
	aSplitter := self textLineSplitter.
	aStream := self textSegmentStream.

	aSplitter split: aText in: aStream.

	self assert: aStream segments size equals: 3.
	
	aSegment := aStream segments first.
	self assert: aSegment textStart equals: 0.
	self assert: aSegment textEnd equals: 0.
	self assert: aSegment text asString equals: ''.
	
	aSegment := aStream segments second.
	self assert: aSegment textStart equals: 1.
	self assert: aSegment textEnd equals: 2.
	self assert: aSegment text asString equals: 'a'.
	
	aSegment := aStream segments third.
	self assert: aSegment textStart equals: 4.
	self assert: aSegment textEnd equals: 5.
	self assert: aSegment text asString equals: 'b'.

	^ aStream
]

{ #category : #split }
AlbTextEditorLineSplitterTest >> test_split_CraCrLfbLf [
	| aText aSplitter aStream aSegment |

	aText := (String cr, 'a', String cr, String lf, 'b', String lf) asRopedText.
	aSplitter := self textLineSplitter.
	aStream := self textSegmentStream.

	aSplitter split: aText in: aStream.

	self assert: aStream segments size equals: 4.
	
	aSegment := aStream segments first.
	self assert: aSegment textStart equals: 0.
	self assert: aSegment textEnd equals: 0.
	self assert: aSegment textEndDelimited equals: 1.
	self assert: aSegment text asString equals: ''.
	
	aSegment := aStream segments second.
	self assert: aSegment textStart equals: 1.
	self assert: aSegment textEnd equals: 2.
	self assert: aSegment textEndDelimited equals: 4.
	self assert: aSegment text asString equals: 'a'.
	
	aSegment := aStream segments third.
	self assert: aSegment textStart equals: 4.
	self assert: aSegment textEnd equals: 5.
	self assert: aSegment textEndDelimited equals: 6.
	self assert: aSegment text asString equals: 'b'.
	
	aSegment := aStream segments fourth.
	self assert: aSegment textStart equals: 6.
	self assert: aSegment textEnd equals: 6.
	self assert: aSegment text asString equals: ''.

	^ aStream
]

{ #category : #split }
AlbTextEditorLineSplitterTest >> test_split_Hello [
	| aText aSplitter aStream aSegment |

	aText := 'Hello' asRopedText.
	aSplitter := self textLineSplitter.
	aStream := self textSegmentStream.

	aSplitter split: aText in: aStream.

	self assert: aStream segments size equals: 1.

	aSegment := aStream segments first.
	self assert: aSegment textStart equals: 0.
	self assert: aSegment textEnd equals: 5.
	self assert: aSegment text asString equals: 'Hello'.

	^ aStream
]

{ #category : #split }
AlbTextEditorLineSplitterTest >> test_split_HelloCrBeautifulCrWorldWithReplacement [
	| aText aSplitter aStream |

	aText := ('Hello', String cr, 'World') asRopedText.
	(aText from: 4 to: 8) replacingAdornment: [ BlElement new size: 6@6; background: Color red ].

	aSplitter := self textLineSplitter.
	aStream := self textSegmentStream.

	aSplitter split: aText in: aStream.

	self assert: aStream segments size equals: 1.
	self assert: aStream segments first textStart equals: 0.
	self assert: aStream segments first textEnd equals: 11.

	^ aStream
]

{ #category : #split }
AlbTextEditorLineSplitterTest >> test_split_HelloCrBeautifulCrWorldWithReplacementAndAppending [

	| aText aSplitter aStream |

	aText := ('Hello', String cr, 'World') asRopedText.
	(aText from: 4 to: 8)
		replacingAdornment: [ BlElement new size: 6@6; background: Color red ];
		appendingAdornment: [ BlElement new size: 6@6; background: Color blue ].

	aSplitter := self textLineSplitter.
	aStream := self textSegmentStream.

	aSplitter split: aText in: aStream.

	self assert: aStream segments size equals: 1.
	self assert: aStream segments first textStart equals: 0.
	self assert: aStream segments first textEnd equals: 11.

	^ aStream
]

{ #category : #split }
AlbTextEditorLineSplitterTest >> test_split_HelloCrWorldWithReplacement [
	| aText aSplitter aStream |

	aText := ('Hello', String cr, 'World') asRopedText.
	(aText from: 4 to: 8) replacingAdornment: [ BlElement new size: 6@6; background: Color red ].

	aSplitter := self textLineSplitter.
	aStream := self textSegmentStream.

	aSplitter split: aText in: aStream.

	self assert: aStream segments size equals: 1.
	self assert: aStream segments first textStart equals: 0.
	self assert: aStream segments first textEnd equals: 11.

	^ aStream
]

{ #category : #split }
AlbTextEditorLineSplitterTest >> test_split_HelloSpaceWorldWithReplacementOfSpace [
	| aText aSplitter aStream |

	aText := ('Hello World') asRopedText.
	(aText from: 5 to: 7) replacingAdornment: [ BlElement new size: 6@6; background: Color red ].

	aSplitter := self textLineSplitter.
	aStream := self textSegmentStream.

	aSplitter split: aText in: aStream.

	self assert: aStream segments size equals: 1.
	self assert: aStream segments first textStart equals: 0.
	self assert: aStream segments first textEnd equals: 11.

	^ aStream
]

{ #category : #'split subtext' }
AlbTextEditorLineSplitterTest >> test_split_Hello_from_HabaHelloFoo [
	| aText aSplitter aStream |

	aText := 'HabaHelloFoo' asRopedText.

	aSplitter := self textLineSplitter.
	aStream := self textSegmentStream.

	aSplitter split: (aText from: 5 to: 9) in: aStream.

	self assert: aStream segments size equals: 1.
	self assert: aStream segments first textStart equals: 0.
	self assert: aStream segments first textEnd equals: 5.

	^ aStream
]

{ #category : #split }
AlbTextEditorLineSplitterTest >> test_split_a [
	| aText aSplitter aStream aSegment |

	aText := ('a') asRopedText.
	aSplitter := self textLineSplitter.
	aStream := self textSegmentStream.

	aSplitter split: aText in: aStream.

	self assert: aStream segments size equals: 1.
	
	aSegment := aStream segments first.
	self assert: aSegment textStart equals: 0.
	self assert: aSegment textEnd equals: 1.
	self assert: aSegment text asString equals: 'a'.

	^ aStream
]

{ #category : #split }
AlbTextEditorLineSplitterTest >> test_split_empty [
	| aText aSplitter aStream aSegment |

	aText := '' asRopedText.
	aSplitter := self textLineSplitter.
	aStream := self textSegmentStream.
	
	aSplitter split: aText in: aStream.
	
	self assert: aStream segments size equals: 1.
	
	aSegment := aStream segments first.
	self assert: aSegment textStart equals: 0.
	self assert: aSegment textEnd equals: 0.
	self assert: aSegment text asString equals: ''.

	^ aStream
]

{ #category : #split }
AlbTextEditorLineSplitterTest >> test_split_haCrCrbaCr [
	| aText aSplitter aStream aSegment |

	aText := ('ha', String cr, String cr, 'ba', String cr) asRopedText.
	aSplitter := self textLineSplitter.
	aStream := self textSegmentStream.

	aSplitter split: aText in: aStream.

	self assert: aStream segments size equals: 4.
	
	aSegment := aStream segments first.
	self assert: aSegment textStart equals: 0.
	self assert: aSegment textEnd equals: 2.
	self assert: aSegment text asString equals: 'ha'.
	
	aSegment := aStream segments second.
	self assert: aSegment textStart equals: 3.
	self assert: aSegment textEnd equals: 3.
	self assert: aSegment text asString equals: ''.
	
	aSegment := aStream segments third.
	self assert: aSegment textStart equals: 4.
	self assert: aSegment textEnd equals: 6.
	self assert: aSegment text asString equals: 'ba'.
	
	aSegment := aStream segments fourth.
	self assert: aSegment textStart equals: 7.
	self assert: aSegment textEnd equals: 7.
	self assert: aSegment text asString equals: ''.

	^ aStream
]

{ #category : #accessing }
AlbTextEditorLineSplitterTest >> textLineSplitter [


	^ AlbTextEditorLineSplitter new
]

{ #category : #accessing }
AlbTextEditorLineSplitterTest >> textSegmentStream [


	^ LimitedWriteStream on: (Array new: 50).
]
