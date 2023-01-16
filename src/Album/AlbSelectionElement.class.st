Class {
	#name : #AlbSelectionElement,
	#superclass : #AlbTextPortionElement,
	#instVars : [
		'editorHandler',
		'elementHandler',
		'infiniteHandler'
	],
	#category : #'Album-UI'
}

{ #category : #accessing }
AlbSelectionElement >> borderWidth [

	^ 1
]

{ #category : #initialization }
AlbSelectionElement >> defaultBackground [ 

	^ self defaultSelectionColor 
]

{ #category : #'private - infinite element changes' }
AlbSelectionElement >> extentChangedIn: anInfiniteElement [

	self updateMainSelectionVerticesIn: anInfiniteElement
]

{ #category : #initialization }
AlbSelectionElement >> initialize [ 

	super initialize.
	self vertices: #().
	self constraintsDo: [ :c | c ignoreByLayout  ].
	self outskirts: (BlOutskirts centered).

]

{ #category : #'private - focus' }
AlbSelectionElement >> onGotFocusIn: anEditorElement [ 

	self background: anEditorElement selectionColor.
	self border:	(BlBorder paint: anEditorElement selectionColor twiceDarker  width: self borderWidth)
]

{ #category : #initialization }
AlbSelectionElement >> onInstalledIn: anEditorElement [


	self background: anEditorElement selectionColor.
	self border:	(BlBorder paint: anEditorElement selectionColor twiceDarker  width: self borderWidth).
	editorHandler := AlbSelectionEditorHandler new
		                 selectionElement: self;
		                 editorElement: anEditorElement;
		                 yourself.
	elementHandler := AlbSelectionElementHandler new
		                  selectionElement: self;
		                  editorElement: anEditorElement;
		                  yourself.
	infiniteHandler := AlbSelectionInfiniteHandler new
		                   selectionElement: self;
		                   editorElement: anEditorElement;
		                   yourself.
	anEditorElement editor addEventHandler: editorHandler.
	anEditorElement addEventHandler: elementHandler.
	anEditorElement infinite addEventHandler: infiniteHandler.

	anEditorElement infinite
		when: AlbTextEditorReplacedEvent
		do: [ :event | 
			event previous ifNotNil: [ :prev | prev removeEventHandler: editorHandler ].
			event current ifNotNil: [ :curr | curr addEventHandler: editorHandler ] ].


]

{ #category : #'private - focus' }
AlbSelectionElement >> onLostFocusIn: anEditorElement [  

	| c |
	c := Color lightGray alpha: 0.1.
	self background: c.
	self border:	(BlBorder paint: c twiceDarker  width: self borderWidth)
]

{ #category : #initialization }
AlbSelectionElement >> onUninstalledIn: anEditorElement [

	anEditorElement infinite removeEventHandler: infiniteHandler.
	anEditorElement editor removeEventHandler: editorHandler.
	anEditorElement removeEventHandler: elementHandler
]

{ #category : #'private - infinite element changes' }
AlbSelectionElement >> selectionChangedIn: anInfiniteElement [

	self updateMainSelectionVerticesIn: anInfiniteElement.
]

{ #category : #'private - infinite element changes' }
AlbSelectionElement >> selectionRectanglesIn: anInfiniteElement [

	"return all selections rectangles from coordinate system of text elements with selection to my local coordinates"

	^ Array streamContents: [ :stream | 
		  anInfiniteElement textElementsDo: [ :te | 
			  te selectionRectangles do: [ :r | 
					stream nextPut: ((anInfiniteElement localBoundsToMine: (BlBounds fromRectangle: r) fromChild: te) translateBy: 0 @ (te position y) negated ) ] ] ]
]

{ #category : #'private - infinite element changes' }
AlbSelectionElement >> selectionScrolled: aPoint in: anInfiniteElement [

	self updateMainSelectionVerticesIn: anInfiniteElement
]

{ #category : #'private - infinite element changes' }
AlbSelectionElement >> updateMainSelectionVerticesIn: anInfiniteElement [

	| rects |
	anInfiniteElement ifNil: [ ^ self ].
	rects := self selectionRectanglesIn: anInfiniteElement.
	rects
		ifEmpty: [ self parentDo: [ :p | self removeFromParent ] ]
		ifNotEmpty: [ 
			self adjacentRectangles: rects.
			self hasParent ifFalse: [ 
				anInfiniteElement addChild: self ] ]
]
