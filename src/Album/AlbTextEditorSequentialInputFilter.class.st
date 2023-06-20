Class {
	#name : #AlbTextEditorSequentialInputFilter,
	#superclass : #AlbTextEditorInputFilter,
	#instVars : [
		'filters'
	],
	#category : #'Album-Model-Input-filters'
}

{ #category : #accessing }
AlbTextEditorSequentialInputFilter >> filter: aString [

	<return: #String>
	| r |
	r := aString.
	filters do: [ :f | r := f filter: r ].
	^ r
]

{ #category : #initialization }
AlbTextEditorSequentialInputFilter >> initialize [ 

	super initialize.
	filters := OrderedCollection 
]
