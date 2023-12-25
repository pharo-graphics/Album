Class {
	#name : #AlbRowNumberDecoration,
	#superclass : #BlRowNumberDecoration,
	#category : 'Album-UI'
}

{ #category : #geometry }
AlbRowNumberDecoration >> numberVerticalHeightIn: anItemElement fontHeight: fontHeight [

	" redefined to have the number on top of a soft line "
	^ 0
]

{ #category : #accessing }
AlbRowNumberDecoration >> selectionBackgroundOf: anItemElement in: anInfiniteElement [

	^ Color gray alpha: 0.2
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
