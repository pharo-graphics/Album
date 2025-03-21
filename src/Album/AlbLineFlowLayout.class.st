"
I am a special kind of Flow layout optimized to layout small text piece elements with moldable editor's segment.

I do not support children matching parent. All of them must have either exact of fit content resizing strategies.
"
Class {
	#name : #AlbLineFlowLayout,
	#superclass : #BlLayout,
	#instVars : [
		'lines',
		'lineSpacing'
	],
	#category : #'Album-Layout'
}

{ #category : #constraints }
AlbLineFlowLayout class >> constraints [
	^ AlbLineFlowLayoutConstraints new
]

{ #category : #measure }
AlbLineFlowLayout >> adaptLinesLastElementMeasureToFillLine: anElement [

	"In case a the selection should fill line, each last (soft) line element should be resized to fill the available horizontal space"

	lines do: [ :aLine | 
		aLine lastElementDo: [ :theLastElement | 
			theLastElement isTextElement ifTrue: [ 
				theLastElement measure: (BlExtentMeasurementSpec exact: theLastElement measuredExtent
						 + ((anElement measuredWidth - aLine width max: 0.0) @ theLastElement padding height negated)) ] ] ]
]

{ #category : #geometry }
AlbLineFlowLayout >> findClosestChildOf: anElement to: aPoint [
	<return: #BlElement>
	| aClosestLine |

	aClosestLine := self findClosestLineTo: aPoint.
	^ aClosestLine findClosestChildOf: anElement to: aPoint
]

{ #category : #geometry }
AlbLineFlowLayout >> findClosestLineTo: aPoint [
	<return: #AlbFlowLine>
	| aClosestLine aClosestDistance |
	
	aClosestLine := lines.
	aClosestDistance := aClosestLine distanceTo: aPoint.
	
	lines do: [ :eachLine | 
		| eachDistance |
		
		eachDistance := eachLine distanceTo: aPoint.
		eachDistance < aClosestDistance
			ifTrue: [
				aClosestDistance := eachDistance.
				aClosestLine := eachLine ] ].
		
	^ aClosestLine
]

{ #category : #testing }
AlbLineFlowLayout >> hasElements [
	^ lines notNil and: [ lines elements notNil ]
]

{ #category : #testing }
AlbLineFlowLayout >> hasLines [
	^ lines notNil
]

{ #category : #initialization }
AlbLineFlowLayout >> initialize [
	super initialize.
	
	lineSpacing := 0
]

{ #category : #layout }
AlbLineFlowLayout >> layout: anElement in: aRectangle context: aBlElementBoundsUpdateContext [
	| anOffsetX anOffsetY aLeft aTop |

	anOffsetX := anElement padding left.
	anOffsetY := anElement padding top.

	aLeft := anOffsetX.
	aTop := anOffsetY.
	
	lines do: [ :aLine |
		aLine origin: aLeft @ aTop.
		(aLine elementsIn: anElement) do: [ :aChildElement |
			| aWidth aMarginedTop |
			aLeft := aLeft + aChildElement margin left.

			aMarginedTop := aTop .
			aMarginedTop := aChildElement supportsBaseline
				ifTrue: [ aMarginedTop + (aLine baseline - aChildElement baselineOffset) ]
				ifFalse: [ aMarginedTop + aChildElement margin top + ((aLine baseline - aChildElement measuredHeight) max: 0) ].
			
			aWidth := aChildElement measuredWidth.
			"we computed layout bounds for the element, let it apply it"
			aChildElement applyLayoutIn: (aLeft @ aMarginedTop extent: aChildElement measuredExtent) context: aBlElementBoundsUpdateContext.
			"offset width for the next element"
			aLeft := aLeft + aWidth + aChildElement margin right ].
		"prepare values for the next line"
		aLeft := anOffsetX.
		aTop := aTop + aLine height + lineSpacing ].
	
	self layoutIgnored: anElement context: aBlElementBoundsUpdateContext
]

{ #category : #accessing }
AlbLineFlowLayout >> lineSpacing [
	^ lineSpacing
]

{ #category : #accessing }
AlbLineFlowLayout >> lineSpacing: anObject [
	lineSpacing := anObject
]

{ #category : #measure }
AlbLineFlowLayout >> measure: anElement with: anExtentSpec [

	| maxWidth maxHeight aCurrentLine totalContentWidth totalContentHeight measuredWidth textFlow |

	"compute how much space is available along both axes"
	maxWidth := (anExtentSpec widthSpec isUnspecified
		             ifTrue: [ SmallInteger maxVal ]
		             ifFalse: [ anExtentSpec widthSpec size ]) - anElement padding width.

	maxHeight := (anExtentSpec heightSpec isUnspecified
		              ifTrue: [ SmallInteger maxVal ]
		              ifFalse: [ anExtentSpec heightSpec size ]) - anElement padding height.

	"Actually a linked list of lines"
	lines := AlbFlowLine new maxWidth: maxWidth.
	measuredWidth := 0.

	"measure children and distribute them in lines"
	aCurrentLine := lines.
	anElement children accountedByLayout do: [ :aChildElement | 
		aChildElement isTextElement ifTrue: [ aChildElement textFlow offsetFromSegmentStart: measuredWidth ].
		self measureChildWithMargins: aChildElement parentSpec: anExtentSpec.
		measuredWidth := measuredWidth + aChildElement measuredWidth.
		aCurrentLine := aCurrentLine add: aChildElement ].

	aCurrentLine pushedQueue do: [ :aPushedElement | 
		aCurrentLine := aCurrentLine nextLine.
		aCurrentLine push: aPushedElement ].

	"compute total extent to measure layout's owner element"
	totalContentWidth := anElement padding width + lines totalWidth.
	totalContentHeight := anElement padding height + lines totalHeight + (lines count - 1 * lineSpacing).

	anElement measuredExtent: (anExtentSpec sizeFor: totalContentWidth @ totalContentHeight).

	"check the shouldFillLine setting"
	textFlow := anElement constraints albumTextFlow.
	textFlow shouldFillLine ifTrue: [ self adaptLinesLastElementMeasureToFillLine: anElement ].

	self measureIgnored: anElement with: anExtentSpec
]

{ #category : #'hooks - layout' }
AlbLineFlowLayout >> onCleanUp: anElement [
	self resetLines
]

{ #category : #initialization }
AlbLineFlowLayout >> resetLines [
	lines ifNotNil: [ :theLines | theLines reset ]
]
