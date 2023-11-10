"
Class: AlbTextAttributesHowToGuide
                                                                                                    
### Text attributes

####How to create a link in a text?
`AlbTextAttributesHowToGuide class>>#linkInText`
#### How to create a hide-able markup in a text?
`AlbTextAttributesHowToGuide class>>#hideMarkupInText`
"
Class {
	#name : 'AlbTextAttributesHowToGuide',
	#superclass : 'Object',
	#category : 'Album-Examples-! Documentation',
	#package : 'Album-Examples',
	#tag : '! Documentation'
}

{ #category : 'examples' }
AlbTextAttributesHowToGuide class >> hideMarkupInText [

	<script>
	| text leftMarker rightMarker |
	text := 'Move cursor **here** to show markup' asRopedText
		        fontSize: 20.

	(text from: 15 to: 18) bold.

	(text from: 13 to: 14)
		foreground: Color red;
		attribute: (leftMarker := AlbTextInvisibleMarkerAttribute new).

	(text from: 19 to: 20)
		foreground: Color red;
		attribute: (rightMarker := AlbTextInvisibleMarkerAttribute new).

	(text from: 11 to: 22)
		onCursorEnter: [ :aTextEditor :anEvent :aFromIndex :aToIndex | 
			| aSubText |
			(aSubText := aTextEditor text from: aFromIndex to: aToIndex)
				findAttributes: { 
						leftMarker.
						rightMarker }
				indicesDo: [ :aMarkupStart :aMarkupEnd | 
					(aSubText from: aMarkupStart to: aMarkupEnd) 
						clearAttributesOfClass: AlbTextHideAttribute ] ]
		leave: [ :aTextEditor :anEvent :aFromIndex :aToIndex | 
			| aSubText |
			(aSubText := aTextEditor text from: aFromIndex to: aToIndex)
				findAttributes: { 
						leftMarker.
						rightMarker }
				indicesDo: [ :aMarkupStart :aMarkupEnd | 
					(aSubText from: aMarkupStart to: aMarkupEnd) attribute:
						AlbTextHideAttribute new ] ].

	^ (AlbEditorElement new text: text) openInOBlSpace
]

{ #category : 'examples' }
AlbTextAttributesHowToGuide class >> linkInText [
	<script>
	| text |
	text := 'You can click on this.' asRopedText.
	(text from: 9 to: 13)
		foreground: Color blue;
		onClick: [ :textPiece :aTarget :aTextEditor :anEvent | self inform: 'click on "', textPiece text asString, '"' ];
		attribute: (AlbTextHoverStylableAttribute new attribute: (BlTextDecorationAttribute new underline color: Color blue)).
	^  (AlbEditorElement new text: text) openInOBlSpace 
]
