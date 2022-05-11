Class {
	#name : #AlbTextEditorSignal,
	#superclass : #BeaconSignal,
	#instVars : [
		'textEditor'
	],
	#category : #'Album-Brick-NU-signals'
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
