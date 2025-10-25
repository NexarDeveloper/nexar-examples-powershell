<#
.Synopsis
	Gets the specified workspace projects.

.Parameter WorkspaceUrl
		Specifies the workspace URL.

.Parameter NexarToken
		Specifies the Nexar access token.
		Default: $env:NEXAR_TOKEN

.Parameter NexarApiUrl
		Specifies the Nexar GraphQL URL.
		Default: $env:NEXAR_API_URL or https://api.nexar.com/graphql

.Inputs
		None

.Outputs
		Projects as {id, name, description}
#>

[CmdletBinding()]
param(
	[Parameter(Position=0, Mandatory=1)]
	[string]$WorkspaceUrl
	,
	[string]$NexarToken = $env:NEXAR_TOKEN
	,
	[Uri]$NexarApiUrl = $(if ($env:NEXAR_API_URL) {$env:NEXAR_API_URL} else {'https://api.nexar.com/graphql'})
)

$ErrorActionPreference=1
$ProgressPreference=0

$query = @'
query Projects($workspaceUrl: String!, $first: Int!, $after: String) {
  desProjects(workspaceUrl: $workspaceUrl, first: $first, after: $after) {
    pageInfo {
      endCursor
      hasNextPage
    }
    nodes {
      id
      name
      description
    }
  }
}
'@

$headers = @{
    Authorization = "Bearer $NexarToken"
}

for($cursor = $null;; $cursor = $projects.pageInfo.endCursor) {
	$body = @{
		query = $query
		variables = @{
			workspaceUrl = $WorkspaceUrl
			first = 20
			after = $cursor
		}
	} | ConvertTo-Json -Compress -Depth 99

	$res = Invoke-RestMethod -Method Post -Uri $NexarApiUrl -Headers $headers -Body $body -ContentType application/json

	# result page info and nodes
	$projects = $res.data.desProjects

	# output page nodes
	$projects.nodes

	# done?
	if (!$projects.pageInfo.hasNextPage) {
		break
	}
}
