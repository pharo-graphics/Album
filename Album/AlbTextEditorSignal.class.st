Class {
	#name : #AlbTextEditorSignal,
	#superclass : #BeaconSignal,
	#instVars : [
		'textEditor'
	],
	#category : #'Album-Editor-Signals'
}

{ #category : #'instance creation' }
AlbTextEditorSignal class >> textEditor: aTextEditor [
	^ self new textEditor: aTextEditor
]

{ #category : #accessing }
AlbTextEditorSignal >> textEditor [
	^ textEditor
]

{ #category : #accessing }
AlbTextEditorSignal >> textEditor: anObject [
	textEditor := anObject
]
