Class {
	#name : #AlbTextEditorCachingAdornmentsExamples,
	#superclass : #AlbTextEditorAdornmentsExamples,
	#category : #'Album-Examples-! Documentation'
}

{ #category : #example }
AlbTextEditorCachingAdornmentsExamples class >> cacheDictionaryExample [
	<script>
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
			
	^ text onAlbum openInOblSpace 
]

{ #category : #example }
AlbTextEditorCachingAdornmentsExamples class >> cacheValueHolderExample [
	<script>
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

	^ text onAlbum openInOblSpace 
]
