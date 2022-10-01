Class {
	#name : #BlTextNullStyler,
	#superclass : #BlTextStyler,
	#category : #'Album-Brick-NU-Bloc-Text-Text-Styler'
}

{ #category : #private }
BlTextNullStyler >> privateStyle: aBlText [
	^ aBlText
]

{ #category : #private }
BlTextNullStyler >> style: aBlText [
	^ aBlText
]

{ #category : #'hooks - text modifications' }
BlTextNullStyler >> textStyled: aStyledText inTextEditor: aTextEditor [

	" A minimal version without whole text updating"
	aTextEditor notifyTextStyled.
	^ true
]
