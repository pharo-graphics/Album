"
I am an attribute that is intended to be applied on a multi-line piece of text.

I should be treated differently by text widgets with the support of multi-line text than normal text attributes. One example of a paragraph attribute is line-spacing
"
Class {
	#name : #AlbTextParagraphAttribute,
	#superclass : #BlTextAttribute,
	#category : 'Album-Attributes'
}

{ #category : #hook }
AlbTextParagraphAttribute >> applyOn: aTextParagraph [
]

{ #category : #testing }
AlbTextParagraphAttribute >> isParagraphAttribute [
	"Return true if I am a special paragraph attribute, false otherwise"
	<return: #Boolean>

	^ true
]
