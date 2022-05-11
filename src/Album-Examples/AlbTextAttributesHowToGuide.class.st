"
! Text attributes 
!! How to create a link in a text?
${example:AlbTextAttributesHowToGuide>>#linkInText|previewExpanded}$
!! How to create a hide-able markup in a text?
${example:AlbTextAttributesHowToGuide>>#hideMarkupInText|previewExpanded}$
"
Class {
	#name : #AlbTextAttributesHowToGuide,
	#superclass : #Object,
	#category : #'Album-Examples-! Documentation'
}

{ #category : #examples }
AlbTextAttributesHowToGuide >> hideMarkupInText [
	<gtExample>
	| text leftMarker rightMarker |

	text := 'Move cursor **here** to show markup' asRopedText fontName: 'Source Sans Pro'; fontSize: 20.

	(text from: 15 to: 18) bold.

	(text from: 13 to: 14)
		foreground: Color gray;
		attribute: (leftMarker := AlbTextInvisibleMarkerAttribute new).

	(text from: 19 to: 20)
		foreground: Color gray;
		attribute: (rightMarker := AlbTextInvisibleMarkerAttribute new).

	(text from: 11 to: 22)
		onCursorEnter: [ :aTextEditor :anEvent :aFromIndex :aToIndex |
			| aSubText |
			(aSubText := (aTextEditor text from: aFromIndex to: aToIndex))
				findAttributes: { leftMarker . rightMarker }
				indicesDo: [ :aMarkupStart :aMarkupEnd |
					(aSubText from: aMarkupStart to: aMarkupEnd) clearAttributesOfClass: AlbTextHideAttribute ] ]
		leave: [ :aTextEditor :anEvent :aFromIndex :aToIndex |
			| aSubText |
			(aSubText := (aTextEditor text from: aFromIndex to: aToIndex))
				findAttributes: { leftMarker  . rightMarker }
				indicesDo: [ :aMarkupStart :aMarkupEnd |
					(aSubText from: aMarkupStart to: aMarkupEnd) attribute: AlbTextHideAttribute new ] ].

	^ AlbEditor new
		aptitude: AlbGlamorousEditorAptitude new;
		text: text
]

{ #category : #examples }
AlbTextAttributesHowToGuide >> linkInText [
	<gtExample>
	| text |
	text := 'You can click on this.' asRopedText.
	(text from: 9 to: 13)
		foreground: Color blue;
		onClick: [ :aTAlbTextEditorTextualPiece :aTarget :aTextEditor :anEvent | anEvent currentTarget phlow spawnObject: aTAlbTextEditorTextualPiece text ];
		attribute: (AlbTextHoverStylableAttribute new attribute: (BlTextDecorationAttribute new underline color: Color blue)).
	^ text
]
