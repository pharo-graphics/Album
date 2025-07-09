Class {
	#name : #AlbTextEditorByScripterExamples,
	#superclass : #Object,
	#category : #'Album-Examples-By scripter'
}

{ #category : #'click - adornment element' }
AlbTextEditorByScripterExamples class >> click_adornment_element [
	<script>
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
		onAlbum;
		play.

	aScripter check
		satisfies: [ :aAlbEditor | aAlbEditor isFocused not ];
		onSelf;
		play.

	^ aScripter
]

{ #category : #'click - empty' }
AlbTextEditorByScripterExamples class >> click_empty [
	<script>
	| aScripter |

	aScripter := self scripterWithElement.

	aScripter click onSelf; play.

	aScripter check
		value: [ :aAlbTextEditor | aAlbTextEditor cursors positions ] equals: #(0);
		onAlbum;
		play.

	aScripter check
		satisfies: [ :aAlbEditor | aAlbEditor isFocused ];
		onSelf;
		play.

	^ aScripter
]

{ #category : #'api - accessing' }
AlbTextEditorByScripterExamples class >> scripter [
	
	^ BlDevScripter new
]

{ #category : #'instance creation' }
AlbTextEditorByScripterExamples class >> scripterElement [

	^ AlbEditorElement new
		text: '' asRopedText
]

{ #category : #'instance creation' }
AlbTextEditorByScripterExamples class >> scripterWithElement [
	| aScripter |

	aScripter := self scripter.
	aScripter element: self scripterElement.
	
	aScripter check
		value: [ :aAlbTextEditor | aAlbTextEditor cursors positions ] equals: #();
		onAlbum;
		play.

	aScripter check
		satisfies: [ :aAlbEditor | aAlbEditor isFocused not ];
		onSelf;
		play.
	
	^ aScripter
]

{ #category : #'click - adornment element' }
AlbTextEditorByScripterExamples class >> textWithAdornment [

	^ 'Hello world
Next line with ' asRopedText, ('adornment' asRopedText appendingAdornment: [
	BlElement new
		extent: 200@100;
		background: (Color gray alpha: 0.2);
		id: #adornment ]), ' element' asRopedText
]
