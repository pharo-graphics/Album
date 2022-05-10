Class {
	#name : #BaselineOfAlbum,
	#superclass : #BaselineOf,
	#category : #BaselineOfAlbum
}

{ #category : #baselines }
BaselineOfAlbum >> baseline: spec [
	<baseline>
	spec for: #'common' do: [
		spec 
			baseline: 'Bloc' with: [
				spec repository: 'github://plantec/bloc:dev-1.0/src' ];
			baseline: 'BlocPac' with: [
				spec repository: 'github://plantec/bloc-pac:dev-1.0/src' ];
			baseline: 'OnBloc' with: [
				spec repository: 'github://plantec/onbloc/src' ].

		spec 
			package: #'Album' with: [
				spec repository: 'github://plantec/Album/src'.
				spec requires: #(#'Bloc' #'BlocPac' #'OnBloc') ]
			 ].
]
