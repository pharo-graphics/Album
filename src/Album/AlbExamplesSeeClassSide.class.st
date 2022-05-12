Class {
	#name : #AlbExamplesSeeClassSide,
	#superclass : #Object,
	#category : #'Album-SandBox'
}

{ #category : #'editor examples' }
AlbExamplesSeeClassSide class >> example_CodeEditorWithRBStylerWithDresser [

	| text styler editorElement space |

	text := self methodText asRopedText.

	styler := AlbRBTextStyler new.
	styler classOrMetaClass: self class.

	editorElement := AlbEditor new 
		dresser: AlbTextAreaDresser new;
		styler: styler;
		text: text.
	"editorElement editor useTaskItStylerStrategy."
	editorElement editor
		addEditorShortcut:
			(BlShortcutWithAction new
				combination: BlKeyCombination primaryR;
				action: [ :aShortcutEvent | self inform: 'shortcut catched' ]).

	space := OblSpace new.
	space root addChild: editorElement.
	space title: 'editor'.
	space show.
	
]

{ #category : #'editor examples' }
AlbExamplesSeeClassSide class >> example_EditorAsTextAreaWithDresser [

	| ed space |

	ed := AlbEditor new dresser: AlbTextAreaDresser.
	ed constraintsDo: [ :c | 
		c vertical resizer: BlLayoutResizer fitContent. 
		c horizontal resizer: BlLayoutResizer matchParent].
	ed text: String loremIpsum.
	space := OblSpace new.
	space root addChild: ed.
	space title: 'editor'.
	space show.
	^ ed
]

{ #category : #'editor examples' }
AlbExamplesSeeClassSide class >> example_EditorAsTextAreaWithoutAnyDresser [

	| ed space |

	ed := AlbEditor new.
	ed text: String loremIpsum.
	space := OblSpace new.
	space root addChild: ed.
	space title: 'editor'.
	space show.
	"ed inspect."
	^ ed
]

{ #category : #'editor examples' }
AlbExamplesSeeClassSide class >> example_EditorWithDynamicAttribute [
	<gtExample>
	| cache attribute text ed space |

	cache := Dictionary new.
	
	attribute := AlbTextAdornmentDynamicAttribute new
		beAppend;
		withCache: cache key: #key;
		stencil: [
			BlElement new
				background: (Color gray alpha: 0.4);
				size: 200@100 ].

	text := 'Hello' asRopedText attribute: attribute.
	ed := AlbEditor new dresser: AlbTextAreaDresser new.
	ed text: text.
	ed matchParent.
	space := OblSpace new.
	space root addChild: ed.
	space title: 'editor'.
	space show.

	
	
			
	^ text
]

{ #category : #elements }
AlbExamplesSeeClassSide class >> example_elements_sandbox [

	| sp root child1 child2 |
	root := BlElement new background: Color cyan.
	child1 := BlElement new background: Color yellow.
	child2 := BlElement new background: Color gray.
	root layout: BlFlowLayout new.
	root addChild: child1.
	root addChild: child2.
	root constraintsDo: [ :c |
			c horizontal matchParent.
			c vertical matchParent ].
	sp := OblSpace new.
	sp addChild: root.
	sp show
]

{ #category : #accessing }
AlbExamplesSeeClassSide class >> methodText [
	^ self  class sourceCodeAt: #example_CodeEditorWithRBStylerWithDresser
]
