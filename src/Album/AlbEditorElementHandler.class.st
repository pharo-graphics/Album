Class {
	#name : #AlbEditorElementHandler,
	#superclass : #BlCustomEventHandler,
	#instVars : [
		'element'
	],
	#category : #'Album-UI-Handlers'
}

{ #category : #accessing }
AlbEditorElementHandler >> element: anElement [

	element := anElement
]

{ #category : #testing }
AlbEditorElementHandler >> isElementEnabled [
	"Workaround for https://github.com/pharo-graphics/Album/issues/67:
	AlbEditorElement and AlbInfiniteEditorElement do not implement #isEnabled
	in Album or Bloc (it is currently provided as a BlElement extension in Toplo).
	When Toplo is present, query its enablement; when running standalone, default to true."

	^ (element respondsTo: #isEnabled)
		  ifTrue: [ element isEnabled ]
		  ifFalse: [ true ]
]
