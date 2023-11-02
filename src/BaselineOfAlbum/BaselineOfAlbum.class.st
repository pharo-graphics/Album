Class {
	#name : #BaselineOfAlbum,
	#superclass : #BaselineOf,
	#category : #BaselineOfAlbum
}

{ #category : #baselines }
BaselineOfAlbum >> baseline: spec [

	<baseline>
	spec for: #common do: [ 
		spec
			baseline: 'Bloc'
			with: [spec repository: 'github://pharo-graphics/Bloc:dev-1.0/src' ].

		spec
			baseline: 'Alexandrie'
			with: [spec repository: 'github://pharo-graphics/Alexandrie:master/src' ].

		spec
			package: #Album with: [ spec requires: #( #Bloc ) ];
			package: #'Album-Tests' with: [ spec requires: #( #Bloc ) ];
			package: #'Album-Examples' with: [ spec requires: #( #Bloc ) ];
			"package: #'Album-Brick-NU' with: [ spec requires: #( #Bloc ) ];"
			package: #'Album-Alexandrie' with: [ spec requires: #( #Bloc #Alexandrie ) ] ]
]
