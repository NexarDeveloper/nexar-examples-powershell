﻿<#
.Synopsis
	Gets user workspaces.

.Parameter NexarToken
		Specifies the Nexar access token.
		Default: $env:NEXAR_TOKEN

.Parameter NexarApiUrl
		Specifies the Nexar GraphQL URL.
		Default: $env:NEXAR_API_URL or https://api.nexar.com/graphql

.Inputs
	None

.Outputs
	{name url authId location={name apiServiceUrl filesServiceUrl}}
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
    authId
    location {
      name
      apiServiceUrl
      filesServiceUrl
    }
  }
}
'@

$body = @{
	query = $query
} | ConvertTo-Json -Compress

$headers = @{
    Authorization = "Bearer $NexarToken"
    'Content-Type' = 'application/json'
}

$res = Invoke-RestMethod -Method Post -Uri $NexarApiUrl -Body $body -Headers $headers
$res.data.desWorkspaces
