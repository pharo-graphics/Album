Class {
	#name : #AlbRowNumberDecoration,
	#superclass : #OBlRowNumberDecoration,
	#category : #'Album-UI'
}

{ #category : #'as yet unclassified' }
AlbRowNumberDecoration >> aeDraw: anItemElement overOn: aeCanvas in: anInfiniteElement [

	aeCanvas restoreContextAfter: [ 
		self selectionLimitRectangleOf: anItemElement in: anInfiniteElement do: [ :rect | 
			aeCanvas pathTranslate: 0 @ anItemElement bounds inParent top.
			aeCanvas pathFactory: [ :cairoContext | cairoContext rectangle: rect ].
			aeCanvas setBackgroundWith: [ 
				aeCanvas setSourceColor: (self selectionBackgroundColorOf: anItemElement in: anInfiniteElement) ].
			aeCanvas setBorderOff.
			aeCanvas drawFigure ] ].
	super 	aeDraw: anItemElement overOn: aeCanvas in: anInfiniteElement 

]

{ #category : #accessing }
AlbRowNumberDecoration >> selectionBackgroundColorOf: anItemElement in: anInfiniteElement [

	^ anInfiniteElement selectionColor alpha: 0.3
]

{ #category : #geometry }
AlbRowNumberDecoration >> selectionLimitRectangleOf: anItemElement in: anInfiniteElement [

	" Select lines with cursor or with an element at left which has a selection that start at 0 "
	(anItemElement children
		 select: [ :e | 
			 (e isKindOf: BlTextElement) and: [ 
				 e hasCursor or: [ e bounds inParent left isZero and: [ e selection isNotEmpty and: [ e selection from isZero ] ] ] ] ]
		 thenCollect: [ :e | e textFlow assignedLine ]) in: [ :l | 
		l ifEmpty: [ ^ nil ].
		^ 0 @ l first origin y corner: self computedBounds width - self gap @ (l last origin y + l last height) ]
]

{ #category : #geometry }
AlbRowNumberDecoration >> selectionLimitRectangleOf: anItemElement in: anInfiniteElement do: aBlock [
	(self selectionLimitRectangleOf: anItemElement in: anInfiniteElement) ifNotNil: [ :bnds | aBlock value: bnds ]
]
