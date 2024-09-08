<#
.Synopsis
	Shows Nexar GraphQL schema using GraphQL Voyager.

.Description
	This command generates and opens HTML which renders GraphQL Voyager with
	the Nexar GraphQL API URL and several display options.

	Requires:
	- Show-GraphQLVoyager.ps1, https://www.powershellgallery.com/packages/Show-GraphQLVoyager

.Parameter RootType
		The root type name. Default: Query

.Parameter Output
		The output HTML file. The default is in the temp directory.

.Parameter HideDocs
		Tells to hide the docs sidebar.

.Parameter HideLeafFields
		Tells to hide all scalars and enums.

.Parameter HideSettings
		Tells to hide the settings panel.

.Parameter HideRoot
		Tells to hide the root type.

.Parameter ShowDeprecated
		Tells to show deprecated entities.

.Parameter ShowRelay
		Tells to show relay related types as is.

.Parameter SortByAlphabet
		Tells to sort fields on graph by alphabet.

.Example
	Show-NexarVoyager Mutation

	Shows Mutation subgraph.

.Example
	Show-NexarVoyager DesComponent -HideDocs -HideSettings

	Shows DesComponent subgraph with all panels hidden.
#>

[CmdletBinding()]
param(
	[Parameter(Position=0)]
	[string]$RootType = 'Query'
	,
	[string]$Output
	,
	[switch]$HideDocs
	,
	[switch]$HideLeafFields
	,
	[switch]$HideSettings
	,
	[switch]$HideRoot
	,
	[switch]$ShowDeprecated
	,
	[switch]$ShowRelay
	,
	[switch]$SortByAlphabet
)

$ErrorActionPreference = 1

$ApiUrl = 'https://api.nexar.com/graphql'
Show-GraphQLVoyager.ps1 -ApiUrl $ApiUrl @PSBoundParameters
