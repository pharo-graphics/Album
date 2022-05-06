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
BlElement >> aptitudeDo: aBlock [

	"self
		deprecated: 'Use #dresserDo: instead'
		on: '29 April 2022'
		in:
		'Pharo-11.0.0+build.16.sha.5766e3132f1a6901f113e15c63dd95ddfab5fadb (64 Bit)'."
	self dresser ifNotNil: aBlock
]

{ #category : #'*Album-Brick-NU' }
BlElement >> layoutResizerPropagations [
	^ self userData
		at: #layoutResizerPropagations
		ifAbsentPut: [ AlbLayoutResizerElementPropagations new element: self ]
]
