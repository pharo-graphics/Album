Class {
	#name : 'AlbTextEditorReplacedEvent',
	#superclass : 'BlEvent',
	#instVars : [
		'previous',
		'current'
	],
	#category : 'Album-UI-Requests',
	#package : 'Album',
	#tag : 'UI-Requests'
}

{ #category : 'accessing' }
AlbTextEditorReplacedEvent >> current [

	^ current
]

{ #category : 'accessing' }
AlbTextEditorReplacedEvent >> current: aTextEditor [

	current := aTextEditor
]

{ #category : 'accessing' }
AlbTextEditorReplacedEvent >> previous [

	^ previous
]

{ #category : 'accessing' }
AlbTextEditorReplacedEvent >> previous: aTextEditor [

	previous := aTextEditor
]
