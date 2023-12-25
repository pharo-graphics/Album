Class {
	#name : #AlbTextParagraphWordPaddingAttribute,
	#superclass : #AlbTextParagraphAttribute,
	#instVars : [
		'wordPadding'
	],
	#category : 'Album-Attributes'
}

{ #category : #'instance creation' }
AlbTextParagraphWordPaddingAttribute class >> wordPadding: aBlInsets [
	^ self new wordPadding: aBlInsets
]

{ #category : #hook }
AlbTextParagraphWordPaddingAttribute >> applyOn: aTextParagraph [
	aTextParagraph wordPadding: self wordPadding
]

{ #category : #comparing }
AlbTextParagraphWordPaddingAttribute >> equals: anAnotherAttribute [
	^ self wordPadding = anAnotherAttribute wordPadding
]

{ #category : #comparing }
AlbTextParagraphWordPaddingAttribute >> hash [
	"Answer an integer value that is related to the identity of the receiver."

	^ super hash bitXor: self wordPadding hash
]

{ #category : #initialization }
AlbTextParagraphWordPaddingAttribute >> initialize [
	super initialize.

	wordPadding := BlInsets empty
]

{ #category : #accessing }
AlbTextParagraphWordPaddingAttribute >> wordPadding [
	<return: #BlInsets>

	^ wordPadding
]

{ #category : #accessing }
AlbTextParagraphWordPaddingAttribute >> wordPadding: aBlInsets [
	wordPadding := aBlInsets
]
