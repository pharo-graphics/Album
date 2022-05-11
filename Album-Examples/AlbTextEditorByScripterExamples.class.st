Class {
	#name : #AlbTextEditorByScripterExamples,
	#superclass : #Object,
	#category : #'Album-Examples-By scripter'
}

{ #category : #'click - adornment element' }
AlbTextEditorByScripterExamples >> click_adornment_element [
	<gtExample>
	| aScripter |

	aScripter := self scripterWithElement.
	aScripter do
		action: [ :aAlbEditor | aAlbEditor text: self textWithAdornment ];
		onSelf;
		play.
	
	aScripter click
		id: #adornment;
		play.

	aScripter check
		value: [ :aAlbTextEditor | aAlbTextEditor cursors positions ] equals: #();
		onAlbTextEditor;
		play.

	aScripter check
		satisfies: [ :aAlbEditor | aAlbEditor isFocused not ];
		onSelf;
		play.

	^ aScripter
]

{ #category : #'click - empty' }
AlbTextEditorByScripterExamples >> click_empty [
	<gtExample>
	| aScripter |

	aScripter := self scripterWithElement.

	aScripter click onSelf; play.

	aScripter check
		value: [ :aAlbTextEditor | aAlbTextEditor cursors positions ] equals: #(0);
		onAlbTextEditor;
		play.

	aScripter check
		satisfies: [ :aAlbEditor | aAlbEditor isFocused ];
		onSelf;
		play.

	^ aScripter
]

{ #category : #'instance creation' }
AlbTextEditorByScripterExamples >> scripter [
	<gtExample>
	
	^ BlDevScripter new
]

{ #category : #'instance creation' }
AlbTextEditorByScripterExamples >> scripterElement [
	<gtExample>

	^ AlbEditor new
		aptitude: AlbGlamorousRegularEditorAptitude + AlbGlamorousTextAreaSpacingAptitude;
		matchParent;
		text: '' asRopedText
]

{ #category : #'instance creation' }
AlbTextEditorByScripterExamples >> scripterWithElement [
	<gtExample>
	| aScripter |

	aScripter := self scripter.
	aScripter element: self scripterElement.
	
	aScripter check
		value: [ :aAlbTextEditor | aAlbTextEditor cursors positions ] equals: #();
		onAlbTextEditor;
		play.

	aScripter check
		satisfies: [ :aAlbEditor | aAlbEditor isFocused not ];
		onSelf;
		play.
	
	^ aScripter
]

{ #category : #'click - adornment element' }
AlbTextEditorByScripterExamples >> textWithAdornment [
	<gtExample>

	^ 'Hello world
Next line with ' asRopedText, ('adornment' asRopedText appendingAdornment: [
	BlElement new
		size: 200@100;
		background: (Color gray alpha: 0.2);
		id: #adornment ]), ' element' asRopedText
]
