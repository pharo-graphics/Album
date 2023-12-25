"
Kept for now but will be removed in the futur 
"
Class {
	#name : #AlbTextParagraph,
	#superclass : #BlTextParagraph,
	#instVars : [
		'segmentPiece'
	],
	#category : 'Album-UI'
}

{ #category : #'paragraph - measuring' }
AlbTextParagraph >> emptySpan [

	^ BlSpan text: BlText empty attributes: (segmentPiece text iterator attributes reject: [ :a | a isEventHandler ])
]

{ #category : #accessing }
AlbTextParagraph >> segmentPiece: aSegmentPiece [

	segmentPiece := aSegmentPiece
]

{ #category : #'api - compositing' }
AlbTextParagraph >> wantsSeparateCompositingLayer [

	^ false
]
