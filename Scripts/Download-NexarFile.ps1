<#
.Synopsis
	Downloads files from Nexar files.

.Parameter FileId
		Specifies the previously uploaded file ID.

.Parameter OutFile
		Specifies the downloaded file path.

.Parameter NexarToken
		Specifies the Nexar access token.
		Default: $env:NEXAR_TOKEN

.Parameter NexarFilesUrl
		Specifies the Nexar files URL.
		Default: $env:NEXAR_FILES_URL or https://files.nexar.com

.Inputs
		None

.Outputs
		None, the result file is specified by OutFile.
#>

[CmdletBinding()]
param(
	[Parameter(Position=0, Mandatory=1)]
	[string]$FileId
	,
	[Parameter(Position=1, Mandatory=1)]
	[string]$OutFile
	,
	[string]$NexarToken = $env:NEXAR_TOKEN
	,
	[Uri]$NexarFilesUrl = $(if ($env:NEXAR_FILES_URL) {$env:NEXAR_FILES_URL} else {'https://files.nexar.com'})
)

$ErrorActionPreference = 1
$ProgressPreference = 0

$uri = [Uri]::new($NexarFilesUrl, "File/Download?id=$FileId")

$headers = @{
    token = $NexarToken
}

Invoke-WebRequest -Uri $uri -Headers $headers -OutFile $OutFile
