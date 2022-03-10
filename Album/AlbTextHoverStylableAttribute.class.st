"
I add attributes to a piece of text when user hovers it with a mouse, then I remove those attributes when the mouse is no longer over the text
"
Class {
	#name : #AlbTextHoverStylableAttribute,
	#superclass : #AlbTextHoverAttribute,
	#instVars : [
		'attributes'
	],
	#category : #'Album-Editor-Attributes'
}

{ #category : #accessing }
AlbTextHoverStylableAttribute >> attribute: aTextAttribute [
	self attributes: { aTextAttribute }
]

{ #category : #accessing }
AlbTextHoverStylableAttribute >> attributes [
	^ attributes
]

{ #category : #accessing }
AlbTextHoverStylableAttribute >> attributes: aCollectionOfAttributes [
	"Set a collection of attribtues that should be added when user hover a text with a mouse"
	attributes := aCollectionOfAttributes
]

{ #category : #initialization }
AlbTextHoverStylableAttribute >> initialize [
	super initialize.

	attributes := #().
	enterAction := [ :aText :aTextElement :aTextEditor :anEvent | aText attributes: self attributes ].
	leaveAction := [ :aText :aTextElement :aTextEditor :anEvent |
		aText clearAttributes: [ :aTextAttribute | self attributes identityIncludes: aTextAttribute ] ]
]
