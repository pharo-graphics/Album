Class {
	#name : 'AlbTextParagraphMarginAttribute',
	#superclass : 'AlbTextParagraphAttribute',
	#instVars : [
		'paragraphMargin'
	],
	#category : 'Album-Attributes',
	#package : 'Album',
	#tag : 'Attributes'
}

{ #category : 'instance creation' }
AlbTextParagraphMarginAttribute class >> paragraphMargin: anInsets [
	^ self new paragraphMargin: anInsets
]

{ #category : 'hook' }
AlbTextParagraphMarginAttribute >> applyOn: aTextParagraph [
	aTextParagraph paragraphMargin: self paragraphMargin
]

{ #category : 'comparing' }
AlbTextParagraphMarginAttribute >> equals: anAnotherAttribute [
	^ self paragraphMargin = anAnotherAttribute paragraphMargin
]

{ #category : 'comparing' }
AlbTextParagraphMarginAttribute >> hash [
	"Answer an integer value that is related to the identity of the receiver."

	^ super hash bitXor: self paragraphMargin hash
]

{ #category : 'initialization' }
AlbTextParagraphMarginAttribute >> initialize [
	super initialize.

	paragraphMargin := BlInsets empty
]

{ #category : 'accessing' }
AlbTextParagraphMarginAttribute >> paragraphMargin [
	<return: #BlInsets>

	^ paragraphMargin
]

{ #category : 'accessing' }
AlbTextParagraphMarginAttribute >> paragraphMargin: anInsets [
	paragraphMargin := anInsets
]
