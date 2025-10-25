<#
.Synopsis
	Uploads project zip to A365 workspace.

.Parameter WorkspaceUrl
		Specifies the workspace URL.

.Parameter Path
		Specifies the project zip.

.Parameter Name
		Specifies the project name.
		Default: the zip file name.

.Parameter Description
		Optional project description.

.Parameter FolderPath
		Optional project folder path.

.Parameter NexarToken
		Specifies the Nexar access token.
		Default: $env:NEXAR_TOKEN

.Parameter NexarApiUrl
		Specifies the Nexar GraphQL URL.
		Default: $env:NEXAR_API_URL or https://api.nexar.com/graphql

.Parameter NexarFilesUrl
		Specifies the Nexar files URL.
		Default: $env:NEXAR_FILES_URL or https://files.nexar.com

.Inputs
		None

.Outputs
		[string], the uploaded project node ID
#>

[CmdletBinding()]
param(
	[Parameter(Position=0, Mandatory=1)]
	[string]$WorkspaceUrl
	,
	[Parameter(Position=1, Mandatory=1)]
	[string]$Path
	,
	[string]$Name
	,
	[string]$Description
	,
	[string]$FolderPath
	,
	[string]$NexarToken = $env:NEXAR_TOKEN
	,
	[Uri]$NexarApiUrl = $(if ($env:NEXAR_API_URL) {$env:NEXAR_API_URL} else {'https://api.nexar.com/graphql'})
	,
	[Uri]$NexarFilesUrl = $(if ($env:NEXAR_FILES_URL) {$env:NEXAR_FILES_URL} else {'https://files.nexar.com'})
)

$ErrorActionPreference=1
$ProgressPreference=0

### Step 1: Upload to Nexar

if (![System.IO.File]::Exists("$PSScriptRoot\Upload-NexarFile.ps1")) {
	Write-Error 'This script requires Upload-NexarFile.ps1'
}

$fileId = & "$PSScriptRoot\Upload-NexarFile.ps1" -Path $Path -NexarToken $NexarToken -NexarFilesUrl $NexarFilesUrl

### Step 2: Invoke mutation

$query = @'
mutation UploadProject($input: DesUploadProjectInput!) {
  desUploadProject(input: $input) {
    projectId
  }
}
'@

$headers = @{
    Authorization = "Bearer $NexarToken"
}

$body = @{
	query = $query
	variables = @{
		input = @{
			workspaceUrl = $WorkspaceUrl
			fileId = $fileId
			name = if ($Name) {$Name} else {[System.IO.Path]::GetFileNameWithoutExtension($Path)}
			description = $Description
			folderPath = $FolderPath
		}
	}
} | ConvertTo-Json -Compress -Depth 99

$res = Invoke-RestMethod -Method Post -Uri $NexarApiUrl -Headers $headers -Body $body -ContentType application/json
$res.data.desUploadProject.projectId
