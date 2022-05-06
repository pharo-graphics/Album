Extension { #name : #BlElement }

{ #category : #'*Album-Brick-NU' }
BlElement >> actors [
	^ Array streamContents: [ :aStream |
		self viewModelDo: [ :aViewModel | aStream nextPut: aViewModel ].	
		self aptitudeDo: [ :aLook | aStream nextPut: aLook ] ]
]

{ #category : #'*Album-Brick-NU' }
BlElement >> aptitude [
	^ self userData at: #aptitude ifAbsent: nil
]

{ #category : #'*Album-Brick-NU' }
BlElement >> aptitude: aLook [

	| aLookInstance |

	self aptitudeDo: [ :aCurrentLook | 
		aCurrentLook onUninstalledIn: self.
		self userData at: #aptitude put: nil ].

	aLookInstance := aLook asLook.

	self userData at: #aptitude put: aLookInstance.
	aLookInstance onInstalledIn: self
]

{ #category : #'*Album-Brick-NU' }
BlElement >> layoutResizerPropagations [

	^ self userData
		at: #layoutResizerPropagations
		ifAbsentPut: [ AlbNullLayoutResizerPropagations new element: self ]
]
