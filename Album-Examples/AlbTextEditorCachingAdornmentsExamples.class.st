Class {
	#name : #AlbTextEditorCachingAdornmentsExamples,
	#superclass : #AlbTextEditorAdornmentsExamples,
	#category : #'Album-Examples-! Documentation'
}

{ #category : #example }
AlbTextEditorCachingAdornmentsExamples >> cacheDictionaryExample [
	<gtExample>
	| cache attribute text |

	cache := Dictionary new.
	
	attribute := AlbTextAdornmentDynamicAttribute new
		beAppend;
		withCache: cache key: #key;
		stencil: [
			BlElement new
				background: (Color gray alpha: 0.4);
				size: 200@100 ].

	text := 'Hello' asRopedText attribute: attribute.
			
	^ text
]

{ #category : #example }
AlbTextEditorCachingAdornmentsExamples >> cacheValueHolderExample [
	<gtExample>
	| cache attribute text |

	cache := ValueHolder new.
	
	attribute := AlbTextAdornmentDynamicAttribute new
		beAppend;
		withCache: cache selector: #contents;
		stencil: [
			BlElement new
				background: (Color gray alpha: 0.4);
				size: 200@100 ].

	text := 'Hello' asRopedText attribute: attribute.

	^ text
]
