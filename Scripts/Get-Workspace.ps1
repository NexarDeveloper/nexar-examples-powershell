<#
.Synopsis
	Gets the workspace info by its URL.

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
	{name authId location={name apiServiceUrl filesServiceUrl}}
#>

[CmdletBinding()]
param(
	[Parameter(Mandatory=1)]
	[string]$WorkspaceUrl
	,
	[string]$NexarToken = $env:NEXAR_TOKEN
	,
	[Uri]$NexarApiUrl = $(if ($env:NEXAR_API_URL) {$env:NEXAR_API_URL} else {'https://api.nexar.com/graphql'})
)

$ErrorActionPreference=1
$ProgressPreference=0

$query = @'
query WorkspaceInfo($workspaceUrl: String!) {
  desWorkspaceByUrl(workspaceUrl: $workspaceUrl) {
    name
    authId
    location {
      name
      apiServiceUrl
      filesServiceUrl
    }
  }
}
'@

$headers = @{
    Authorization = "Bearer $NexarToken"
}

$body = @{
	query = $query
	variables = @{
		workspaceUrl = $WorkspaceUrl
	}
} | ConvertTo-Json -Compress

$res = Invoke-RestMethod -Method Post -Uri $NexarApiUrl -Headers $headers -Body $body -ContentType application/json
$res.data.desWorkspaceByUrl
