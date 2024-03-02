<#
.Synopsis
	Shows Nexar GraphQL schema using GraphQL Voyager.

.Description
	This command generates and opens HTML which renders GraphQL Voyager with
	the Nexar GraphQL API URL and several display options.

	The GraphQL Voyager .css and .js files and the script Show-GraphQLVoyager
	are downloaded once to the cache. Remove them in order to get the latest
	versions. The cache directory: $HOME/.PowerShelf/Show-GraphQLVoyager

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
	># Show DesComponent sub-graph with all panels hidden:

	Show-NexarVoyager DesComponent -HideDocs -HideSettings

.Link
	https://github.com/graphql-kit/graphql-voyager

.Link
	https://www.powershellgallery.com/packages/Show-GraphQLVoyager
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
$ProgressPreference = 0

$ApiUrl = 'https://api.nexar.com/graphql'

$cache = "$HOME/.PowerShelf/Show-GraphQLVoyager"
$null = mkdir $cache -Force

$ps1 = "$cache/Show-GraphQLVoyager.ps1"
if (![System.IO.File]::Exists($ps1)) {
	Write-Host "Downloading $ps1"
	Save-Script Show-GraphQLVoyager -LiteralPath $cache -Force
}

& $ps1 -ApiUrl $ApiUrl @PSBoundParameters
