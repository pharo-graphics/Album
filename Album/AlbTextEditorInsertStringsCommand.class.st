Class {
	#name : #AlbTextEditorInsertStringsCommand,
	#superclass : #AlbTextEditorCommand,
	#instVars : [
		'strings',
		'indices'
	],
	#category : #'Album-Commands'
}

{ #category : #executing }
AlbTextEditorInsertStringsCommand >> executeOn: aTextEditor [

	aTextEditor text
		insertStrings: self strings
		atAll: self indices
]

{ #category : #accessing }
AlbTextEditorInsertStringsCommand >> indices [
	^ indices
]

{ #category : #accessing }
AlbTextEditorInsertStringsCommand >> indices: anObject [
	indices := anObject
]

{ #category : #printing }
AlbTextEditorInsertStringsCommand >> printOn: aStream [
	aStream
		nextPutAll: 'Inserted'.
	
	self strings with: self indices do: [ :aString :anIndex |
		aStream
			space;
			print: aString;
			nextPutAll: ' at ';
			print: anIndex ]
]

{ #category : #accessing }
AlbTextEditorInsertStringsCommand >> strings [
	^ strings
]

{ #category : #accessing }
AlbTextEditorInsertStringsCommand >> strings: anObject [
	strings := anObject
]
