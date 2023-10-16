Class {
	#name : 'AlbTextEditorInputFilterDecorator',
	#superclass : 'AlbTextEditorInputFilter',
	#instVars : [
		'next'
	],
	#category : 'Album-Model-Input-filters',
	#package : 'Album',
	#tag : 'Model-Input-filters'
}

{ #category : 'instance creation' }
AlbTextEditorInputFilterDecorator class >> next: aFilter [

	^ self new filter: aFilter
]

{ #category : 'accessing' }
AlbTextEditorInputFilterDecorator >> filter: aString [

	<return: #String>
	^ self next ifNil: [ aString ] ifNotNil: [ :n | n filter: aString ]
]

{ #category : 'accessing' }
AlbTextEditorInputFilterDecorator >> next [

	^ next
]

{ #category : 'accessing' }
AlbTextEditorInputFilterDecorator >> next: aFilter [

	next := aFilter
]
