"
I influence a line spacing of a paragraph of text.

Example:
"
Class {
	#name : #AlbTextParagraphLineSpacingAttribute,
	#superclass : #AlbTextParagraphAttribute,
	#instVars : [
		'lineSpacing'
	],
	#category : 'Album-Attributes'
}

{ #category : #'instance creation' }
AlbTextParagraphLineSpacingAttribute class >> lineSpacing: aNumber [
	^ self new lineSpacing: aNumber
]

{ #category : #hook }
AlbTextParagraphLineSpacingAttribute >> applyOn: aTextParagraph [
	aTextParagraph lineSpacing: self lineSpacing
]

{ #category : #comparing }
AlbTextParagraphLineSpacingAttribute >> equals: anAnotherAttribute [
	^ self lineSpacing = anAnotherAttribute lineSpacing
]

{ #category : #comparing }
AlbTextParagraphLineSpacingAttribute >> hash [
	"Answer an integer value that is related to the identity of the receiver."

	^ super hash bitXor: self lineSpacing hash
]

{ #category : #initialization }
AlbTextParagraphLineSpacingAttribute >> initialize [
	super initialize.
	
	lineSpacing := 0
]

{ #category : #accessing }
AlbTextParagraphLineSpacingAttribute >> lineSpacing [
	^ lineSpacing
]

{ #category : #accessing }
AlbTextParagraphLineSpacingAttribute >> lineSpacing: aNumber [
	lineSpacing := aNumber
]
