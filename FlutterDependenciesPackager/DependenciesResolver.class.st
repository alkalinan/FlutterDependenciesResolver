Class {
	#name : #DependenciesResolver,
	#superclass : #Object,
	#instVars : [
		'lock2json',
		'tempFolder'
	],
	#category : #FlutterDependenciesPackager
}

{ #category : #'as yet unclassified' }
DependenciesResolver >> collectDependenciesOf: aFlutterPackage fromLockJson: aDictionnary [

	| packages |
	packages := aDictionnary at: 'packages'.

	"Filter the dependencies to only keep packages that are not from the SDK"
	aFlutterPackage childrenDep:
		(aFlutterPackage childrenDep select: [ :aPkg | 
			 (((packages at: aPkg name) at: 'source') = 'sdk') not ]).

	aFlutterPackage childrenDep do: [ :aPkg | 
		aPkg version: ((packages at: aPkg name) at: 'version').
		aPkg source: ((packages at: aPkg name) at: 'source') ].

]

{ #category : #'as yet unclassified' }
DependenciesResolver >> exploreDirectDependencies: aFlutterPackage [

	"create a new package instance"

	self collectDependenciesOf: aFlutterPackage fromLockJson: lock2json.

	aFlutterPackage childrenDep do: [ :child | 
		| path |
		path := FileLocator home
		        /
		        ('.pub-cache/hosted/pub.dartlang.org/'
		         , child exportPackageName).

		

		child initFromPath: path.
		self exploreDirectDependencies: child ]
]

{ #category : #'as yet unclassified' }
DependenciesResolver >> exploreFromAPackage: aPathasString [

	| pkg |
	"create a new package instance"

	pkg := FlutterPackage new.
	pkg initMainPackageFromPath: aPathasString.

	"because this package is the entry point, get its pubspec.lock as Json"
	lock2json := pkg getJsonFromPubspecLock: pkg pubpspecLockFileLocator.
	self collectDependenciesOf: pkg fromLockJson: lock2json.

	pkg childrenDep do: [ :child | 
		| path |
		path := FileLocator home
		        /
		        ('.pub-cache/hosted/pub.dartlang.org/'
		         , child exportPackageName).

		path copyAllTo: tempFolder / child exportPackageName.

		child initFromPath: path.
		self exploreDirectDependencies: child ].

	^ pkg
]

{ #category : #'as yet unclassified' }
DependenciesResolver >> explorePackage: aPathasString [

	| pkg |
	"create a new package instance"
	pkg := FlutterPackage new.
	pkg initFromPath: aPathasString.
	lock2json := pkg getJsonFromPubspecLock: pkg pubpspecLockFileLocator.
	self collectDependenciesOf: pkg fromLockJson: lock2json.

	pkg childrenDep do: [ :child | 
		| path |
		path := FileLocator home
		        /
		        ('.pub-cache/hosted/pub.dartlang.org/'
		         , child exportPackageName).
		].
	1 halt.
]

{ #category : #'as yet unclassified' }
DependenciesResolver >> initialize [

	tempFolder := FileLocator home / 'PACKAGES/'.
	tempFolder ensureCreateDirectory.
"	tempFolder := (FileLocator home / 'outputParserDart') asFileReference."
	tempFolder children do: [ :f | f deleteAll ]
]
