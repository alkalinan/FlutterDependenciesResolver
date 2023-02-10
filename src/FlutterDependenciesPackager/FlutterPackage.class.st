Class {
	#name : #FlutterPackage,
	#superclass : #Object,
	#instVars : [
		'name',
		'version',
		'path',
		'source',
		'childrenDep',
		'parentalDep',
		'pubspecyaml',
		'pubspeclock'
	],
	#category : #FlutterDependenciesPackager
}

{ #category : #initialize }
FlutterPackage class >> withName: aString [

	| aPackage |
	aPackage := FlutterPackage new.
	aPackage name: aString.
	^ aPackage
]

{ #category : #initialize }
FlutterPackage class >> withName: aString withParent: aFlutterPackage [

	| aPackage |
	aPackage := FlutterPackage new.
	aPackage name: aString.
	aPackage parentalDep: aFlutterPackage.
	^aPackage.
]

{ #category : #setter }
FlutterPackage >> = otherFlutterPackage [

	self == otherFlutterPackage ifTrue: [ ^true ].
	self species == otherFlutterPackage species ifFalse: [^ false].
	^ self exportPackageName = otherFlutterPackage exportPackageName.

]

{ #category : #setter }
FlutterPackage >> asString [

	"name-version"

	^  self exportPackageName
]

{ #category : #accessing }
FlutterPackage >> childrenDep [
	^ childrenDep
]

{ #category : #setter }
FlutterPackage >> childrenDep: aCollection [ 
	childrenDep := aCollection
]

{ #category : #setter }
FlutterPackage >> exportPackageName [
	
	"name-version"
	version isNil ifTrue: [ ^ name ] ifFalse: [ ^ name, '-', version ]. 
]

{ #category : #'as yet unclassified' }
FlutterPackage >> getInfoFromPubspecYaml: aFileReference [

	"return the FileLocator of the pubspec.yaml file in this current package"

	| y2j json |
	y2j := Yaml2Json new.
	json := STONJSON fromString:
		        (y2j convertPubSpecYamlToJson: aFileReference contents).
	"official name of the package"
	self name: (json at: 'name').
	"get the direct dependencies (direct main) "
	self childrenDep:
		((json at: 'dependencies' ifAbsent: Dictionary new) keys collect: [ :k | 
			 FlutterPackage withName: k withParent: self ])
]

{ #category : #'as yet unclassified' }
FlutterPackage >> getInfoFromPubspecYaml: aFileReference withDevDependencies: aBoolean [

	"return the FileLocator of the pubspec.yaml file in this current package"

	| y2j json dependencies |
	dependencies := OrderedCollection new.
	y2j := Yaml2Json new.
	json := STONJSON fromString:
		        (y2j convertPubSpecYamlToJson: aFileReference contents).
	"official name of the package"
	self name: (json at: 'name').
	"get the direct dependencies (direct main) "
	dependencies := (json at: 'dependencies' ifAbsent: Dictionary new)
		                keys collect: [ :k | 
		                FlutterPackage withName: k withParent: self ].
	aBoolean ifTrue: [ 
		dependencies := dependencies ,
			((json at: 'dev_dependencies' ifAbsent: Dictionary new) keys 
				 collect: [ :k | FlutterPackage withName: k withParent: self ])
				asOrderedCollection ].
	self childrenDep: dependencies asOrderedCollection
]

{ #category : #'as yet unclassified' }
FlutterPackage >> getJsonFromPubspecLock: aFileReference [

	"return the FileLocator of the pubspec.yaml file in this current package"

	| y2j json |
	y2j := Yaml2Json new.
	json := STONJSON fromString:
		        (y2j convertPubSpecLockToJson: aFileReference contents).
	^ json
]

{ #category : #initialize }
FlutterPackage >> initFromPath: aFileLocator [

	self path: aFileLocator.
	pubspecyaml := self pubpspecYamlFileLocator.

	self getInfoFromPubspecYaml: pubspecyaml
]

{ #category : #initialize }
FlutterPackage >> initMainPackageFromPath: aFileLocator [

	self path: aFileLocator.
	pubspecyaml := self pubpspecYamlFileLocator.

	self getInfoFromPubspecYaml: pubspecyaml  withDevDependencies: true.
]

{ #category : #initialization }
FlutterPackage >> initialize [

	name := String new.
	path := FileLocator new.
	childrenDep := Set new.
	parentalDep := Set  new
]

{ #category : #getter }
FlutterPackage >> name [
	^ name
]

{ #category : #setter }
FlutterPackage >> name: aString [ 
	name := aString
]

{ #category : #setter }
FlutterPackage >> parentalDep: aFlutterPackage [ 
	parentalDep := aFlutterPackage
]

{ #category : #setter }
FlutterPackage >> path [
	^ path
]

{ #category : #setter }
FlutterPackage >> path: aFileLocator [ 
	path := aFileLocator
]

{ #category : #setter }
FlutterPackage >> printOn: aStream [

	aStream
		nextPutAll: self asString.
]

{ #category : #'as yet unclassified' }
FlutterPackage >> pubpspecLockFileLocator [

	"return the FileLocator of the pubspec.yaml file in this current package"

	| path2Lock |
	(self path allChildrenMatching: 'pubspec.lock') isNotEmpty
		ifTrue: [ 
		path2Lock := (self path allChildrenMatching: 'pubspec.lock') first ]
		ifFalse: [ 
		Exception signal: 'The path does not contain any pubspec.lock file' ].
	^ path2Lock
]

{ #category : #'as yet unclassified' }
FlutterPackage >> pubpspecYamlFileLocator [

	"return the FileLocator of the pubspec.yaml file in this current package"

	| path2Yaml |

	(self path allChildrenMatching: 'pubspec.yaml') isNotEmpty
		ifTrue: [ 
		path2Yaml := (self path allChildrenMatching: 'pubspec.yaml') first ]
		ifFalse: [ 
		Exception signal: 'The path does not contain any pubspec.yaml file' ].
	^ path2Yaml
]

{ #category : #setter }
FlutterPackage >> source: aString [ 
	source := aString
]

{ #category : #setter }
FlutterPackage >> version: aString [ 
	version := aString
]
