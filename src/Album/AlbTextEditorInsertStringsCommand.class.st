Class {
	#name : 'AlbTextEditorInsertStringsCommand',
	#superclass : 'AlbTextEditorCommand',
	#instVars : [
		'strings',
		'indices'
	],
	#category : 'Album-Commands',
	#package : 'Album',
	#tag : 'Commands'
}

{ #category : 'executing' }
AlbTextEditorInsertStringsCommand >> executeOn: aTextEditor [

	aTextEditor privateText insertStrings: self strings atAll: self indices
]

{ #category : 'accessing' }
AlbTextEditorInsertStringsCommand >> indices [
	^ indices
]

{ #category : 'accessing' }
AlbTextEditorInsertStringsCommand >> indices: anObject [
	indices := anObject
]

{ #category : 'accessing' }
AlbTextEditorInsertStringsCommand >> strings [
	^ strings
]

{ #category : 'accessing' }
AlbTextEditorInsertStringsCommand >> strings: anObject [
	strings := anObject
]
