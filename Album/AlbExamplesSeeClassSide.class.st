Class {
	#name : #AlbExamplesSeeClassSide,
	#superclass : #Object,
	#category : #'Album-SandBox'
}

{ #category : #examples }
AlbExamplesSeeClassSide class >> example_CodeEditorWithRBStyler [

	| text styler editorElement space |

	text := self methodText asRopedText.

	styler := AlbRBTextStyler new.
	styler classOrMetaClass: self class.

	editorElement := AlbEditor new 
		dresser: AlbTextAreaDresser;
		styler: styler;
		text: text.
	"editorElement editor useTaskItStylerStrategy."
	editorElement editor
		addEditorShortcut:
			(BlShortcutWithAction new
				combination: BlKeyCombination primaryR;
				action: [ :aShortcutEvent | self inform: 'shortcut catched' ]).

	space := BlSpace new.
	space root addChild: editorElement.
	space title: 'editor'.
	space show.
	
]

{ #category : #examples }
AlbExamplesSeeClassSide class >> example_EditorAsTextArea1 [

	| ed space propagations |
	ed := AlbEditor new.
	
	propagations := AlbLayoutResizerPropagations new.
	ed layoutResizerPropagations addPropagations: propagations.
	ed styles markDirty.
	

self halt.
	"AlbLayoutResizerAptitude inherit onInstalledIn: ed."
	ed aptitude: AlbTextAreaAptitude.
	ed when: AlbEditorStylerChanged do: [ :anEvent | ed styler: anEvent styler ].
	ed when: AlbEditorTextChanged do: [ :anEvent | ed text: anEvent text ].
	ed when: AlbEditorModeChanged do: [ :anEvent | ed mode: anEvent mode ].
	ed text: String loremIpsum.
	ed fireEvent: AlbEditorTextRequest new.
	ed constraintsDo: [ :c | 
		c vertical resizer: BlLayoutResizer fitContent.
		c horizontal resizer: BlLayoutResizer matchParent ].
	
	ed layoutResizerPropagations addPropagations: propagations.
	"ed layoutResizerPropagations addPropagations: BrLayoutResizerPropagations new."
	"ed userData at: #brickLook put: nil."
	"ed when: BrEditorStylerChanged do: [ :anEvent | ed styler: anEvent styler ]."
	"ed when: BrEditorTextChanged do: [ :anEvent | ed  text: anEvent text ]."
	"ed when: BrEditorModeChanged do: [ :anEvent | ed mode: anEvent mode ]."
	ed
		when: BlBlurEvent
		do: [ :anEvent | ed border: (BlBorder paint: Color red width: 1) ].
	"ed
		when: BlFocusEvent
		do: [ :anEvent | ed border: (BlBorder paint: Color blue width: 1) ]."
	"ed constraints vertical resizer: BlLayoutResizer fitContent.
	ed constraints horizontal resizer: BlLayoutResizer fitContent."
	"ed aptitude: ToTextAreaAptitude2."
	
	"ed vFitContent."
	"ed fitContent."
	"ed text: String loremIpsum."
	space := BlSpace new.
	space root addChild: ed.
	space title: 'editor'.
	space show.

	^ ed
]

{ #category : #examples }
AlbExamplesSeeClassSide class >> example_EditorAsTextAreaWithAptitude [

	| ed space |
	ed := AlbEditor new aptitude: AlbTextAreaAptitude.
	"ed vFitContent."
	ed text: String loremIpsum.
	space := BlSpace new.
	space root addChild: ed.
	space title: 'editor'.
	space show.
	^ ed
]

{ #category : #examples }
AlbExamplesSeeClassSide class >> example_EditorAsTextAreaWithDresser [

	| ed space |

	ed := AlbEditor new dresser: AlbTextAreaDresser.
	ed text: String loremIpsum.
	space := BlSpace new.
	space root addChild: ed.
	space title: 'editor'.
	space show.
	ed inspect.
	^ ed
]

{ #category : #examples }
AlbExamplesSeeClassSide class >> example_EditorAsTextArea_with_glamAptitude [


	| ed space propagations |
	ed := AlbEditor new.
	
	"propagations := AlbLayoutResizerPropagations new."
	"ed layoutResizerPropagations addPropagations: propagations."
	"ed styles markDirty."
self halt.
	"ToLayoutResizerAptitude inherit onInstalledIn: ed."
	ed aptitude: AlbTextAreaGlamAptitude.
	"ed layoutResizerPropagations addPropagations: propagations."
	"ed layoutResizerPropagations addPropagations: BrLayoutResizerPropagations new."
	"ed userData at: #brickLook put: nil."
	"ed when: BrEditorStylerChanged do: [ :anEvent | ed styler: anEvent styler ]."
	"ed when: BrEditorTextChanged do: [ :anEvent | ed  text: anEvent text ]."
	"ed when: BrEditorModeChanged do: [ :anEvent | ed mode: anEvent mode ]."
	"ed
		when: BlFocusEvent
		do: [ :anEvent | ed border: (BlBorder paint: Color blue width: 1) ]."
	"ed constraints vertical resizer: BlLayoutResizer fitContent.
	ed constraints horizontal resizer: BlLayoutResizer fitContent."
	"ed aptitude: ToTextAreaAptitude2."
	ed text: String loremIpsum.
	"ed vFitContent."
	"ed fitContent."
	"ed text: String loremIpsum."

	space := BlSpace new.
	space root addChild: ed.
	space title: 'editor'.
	space show.
	^ ed
]

{ #category : #examples }
AlbExamplesSeeClassSide class >> example_EditorAsTextFieldWithAptitude [

	| ed space |
	self halt.
	ed := AlbEditor new
		      aptitude: "BrEditorAptitude +" AlbTextFieldAptitude;
		      text: 'edit me'.

	space := BlSpace new.
	space root addChild: ed.
	space title: 'editor'.
	space show.
	ed
]

{ #category : #accessing }
AlbExamplesSeeClassSide class >> methodText [
	^ self  class sourceCodeAt: #example_CodeEditorWithRBStyler
]
