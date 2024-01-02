<#
.Synopsis
	Gets all workspaces with basic information.

.Parameter NexarToken
		Specifies the Nexar access token.
		Default: $env:NEXAR_TOKEN

.Parameter NexarApiUrl
		Specifies the Nexar GraphQL URL.
		Default: $env:NEXAR_API_URL or https://api.nexar.com/graphql

.Inputs
		None

.Outputs
		Workspaces as {name, url, id, location={name, apiServiceUrl, filesServiceUrl}}
#>

[CmdletBinding()]
param(
	[string]$NexarToken = $env:NEXAR_TOKEN
	,
	[Uri]$NexarApiUrl = $(if ($env:NEXAR_API_URL) {$env:NEXAR_API_URL} else {'https://api.nexar.com/graphql'})
)

$ErrorActionPreference = 1
$ProgressPreference = 0

$query = @'
query {
  desWorkspaces {
    name
    url
    location {
      apiServiceUrl
      filesServiceUrl
    }
  }
}
'@

$headers = @{
    Authorization = "Bearer $NexarToken"
    'Content-Type' = 'application/json'
}

$body = @{
	query = $query
} | ConvertTo-Json -Compress -Depth 99

$res = Invoke-RestMethod -Method Post -Uri $NexarApiUrl -Body $body -Headers $headers
$res.data.desWorkspaces
