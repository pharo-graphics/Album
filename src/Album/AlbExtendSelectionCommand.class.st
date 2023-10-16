Class {
	#name : 'AlbExtendSelectionCommand',
	#superclass : 'Object',
	#instVars : [
		'editor',
		'toSelect',
		'toDeselect',
		'toMoveCursor',
		'toAddCursor',
		'shouldResetDesiredCoordinate',
		'toRemoveCursors'
	],
	#category : 'Album-Model-Operators',
	#package : 'Album',
	#tag : 'Model-Operators'
}

{ #category : 'accessing' }
AlbExtendSelectionCommand >> editor: anEditor [
	editor := anEditor
]

{ #category : 'accessing' }
AlbExtendSelectionCommand >> initialize [
	super initialize.

	toSelect := OrderedCollection new.
	toDeselect := OrderedCollection new.
	toMoveCursor := nil.
	toAddCursor := nil.
	toRemoveCursors := OrderedCollection new.
	shouldResetDesiredCoordinate := true
]

{ #category : 'accessing' }
AlbExtendSelectionCommand >> shouldResetDesiredCoordinate [
	^ shouldResetDesiredCoordinate
]

{ #category : 'accessing - cursor' }
AlbExtendSelectionCommand >> toAddCursor: aPosition [
	toAddCursor := aPosition
]

{ #category : 'accessing - cursor' }
AlbExtendSelectionCommand >> toAddCursorDo: aBlock [
	toAddCursor ifNotNil: [ :aPosition | aBlock value: aPosition ]
]

{ #category : 'accessing' }
AlbExtendSelectionCommand >> toDeselect [

	^ toDeselect
]

{ #category : 'accessing' }
AlbExtendSelectionCommand >> toDeselect: aCollection [
	toDeselect := aCollection
]

{ #category : 'accessing' }
AlbExtendSelectionCommand >> toDeselectDo: aBlockWithOneArgument [
	toDeselect do: aBlockWithOneArgument
]

{ #category : 'accessing - cursor' }
AlbExtendSelectionCommand >> toMoveCursor: aCursor by: anAmount [
	toMoveCursor := aCursor -> anAmount
]

{ #category : 'accessing - cursor' }
AlbExtendSelectionCommand >> toMoveCursorDo: aBlock [
	toMoveCursor ifNotNil: [ :anAssociation |
		aBlock value: anAssociation key value: anAssociation value ]
]

{ #category : 'accessing' }
AlbExtendSelectionCommand >> toSelect [
	^ toSelect
]

{ #category : 'accessing' }
AlbExtendSelectionCommand >> toSelect: aCollection [
	toSelect := aCollection
]

{ #category : 'accessing' }
AlbExtendSelectionCommand >> toSelectDo: aBlockWithOneArgument [
	toSelect do: aBlockWithOneArgument
]

{ #category : 'accessing' }
AlbExtendSelectionCommand >> withoutResettingDesiredCoordinate [
	shouldResetDesiredCoordinate := false
]
