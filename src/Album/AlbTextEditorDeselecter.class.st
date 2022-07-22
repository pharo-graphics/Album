Class {
	#name : #AlbTextEditorDeselecter,
	#superclass : #AlbTextEditorOperator,
	#instVars : [
		'selection'
	],
	#category : #'Album-Model-Operators'
}

{ #category : #'api - configuration' }
AlbTextEditorDeselecter >> all [
	"Deselect the whole text"

	self selection do: [ :aMonotoneSelection | self from: aMonotoneSelection from to: aMonotoneSelection to ]
]

{ #category : #'api - processing' }
AlbTextEditorDeselecter >> apply [
	^ self deselect
]

{ #category : #'api - processing' }
AlbTextEditorDeselecter >> deselect [

	selection do: [ :aMonotoneSelection | 
		self
			privateDeselect: aMonotoneSelection from
			to: aMonotoneSelection to ]
]

{ #category : #'api - configuration' }
AlbTextEditorDeselecter >> from: aFromIndex to: aToIndex [
	selection select: aFromIndex to: aToIndex
]

{ #category : #initialization }
AlbTextEditorDeselecter >> initialize [
	super initialize.

	selection := BlCompositeSelection new
]

{ #category : #'api - processing' }
AlbTextEditorDeselecter >> outsideOfCursor [
	"Remove all selections that don't contain any existing cursor"

	self selection do: [ :aMonotoneSelection |
		self cursors do: [ :aCursor |
			(aCursor position = aMonotoneSelection from or: [ aCursor position = aMonotoneSelection to ])
				ifFalse: [ self from: aMonotoneSelection from to: aMonotoneSelection to ] ] ]
]

{ #category : #private }
AlbTextEditorDeselecter >> privateDeselect: aFromTextIndex to: aToTextIndex [
	"Deselect text within an interval defined by provided from and to indices without any other side effects.
	Note:
		- I don't change cursor position.
		- I request segments update"
	| aCommand |

	aCommand := AlbTextEditorDeselectCommand new
		fromIndex: aFromTextIndex;
		toIndex: aToTextIndex.
	self editor executeCommand: aCommand
]
