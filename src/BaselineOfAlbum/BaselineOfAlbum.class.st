Class {
	#name : #BaselineOfAlbum,
	#superclass : #BaselineOf,
	#category : #BaselineOfAlbum
}

{ #category : #baselines }
BaselineOfAlbum >> baseline: spec [
	<baseline>

	spec for: #common do: [ 
		self declareBlocOn: spec.

		spec
			package: #Album with: [ spec requires: #( #Bloc ) ];
			package: #'Album-Tests' with: [ spec requires: #( #Album ) ];
			package: #'Album-Examples' with: [ spec requires: #( #'Album-Tests' ) ];
			"package: #'Album-Brick-NU' with: [ spec requires: #( #Bloc ) ];"
			package: #'Album-Alexandrie' with: [ spec requires: #( #'Album-Examples' ) ].

		spec
			group: 'production'
			with: #( #Album ).
		spec
			group: 'development'
			with: #( #'Album-Alexandrie' ). "Transitively includes all"
		spec
			group: 'default'
			with: #('development') ]

]

{ #category : #baselines }
BaselineOfAlbum >> declareBlocOn: spec [

	spec
		baseline: 'Bloc'
		with: [ spec repository: 'github://pharo-graphics/Bloc:master/src' ]
]
