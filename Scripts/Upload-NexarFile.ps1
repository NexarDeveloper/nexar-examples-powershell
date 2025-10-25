<#
.Synopsis
	Uploads files to Nexar files.

.Parameter Path
		Specifies the file to be uploaded.

.Parameter NexarToken
		Specifies the Nexar access token.
		Default: $env:NEXAR_TOKEN

.Parameter NexarFilesUrl
		Specifies the Nexar files URL.
		Default: $env:NEXAR_FILES_URL or https://files.nexar.com

.Inputs
		None

.Outputs
		[string], the uploaded file ID
#>

[CmdletBinding()]
param(
	[Parameter(Mandatory=1)]
	[string]$Path
	,
	[string]$NexarToken = $env:NEXAR_TOKEN
	,
	[Uri]$NexarFilesUrl = $(if ($env:NEXAR_FILES_URL) {$env:NEXAR_FILES_URL} else {'https://files.nexar.com'})
)

$ErrorActionPreference=1
$ProgressPreference=0

Add-Type -AssemblyName System.Net.Http

$Path = $PSCmdlet.GetUnresolvedProviderPathFromPSPath($Path)

$uploadUrl = "$NexarFilesUrl".TrimEnd('/') + '/File/Upload'

$http, $data, $form, $response = $null
try {
	$http = [System.Net.Http.HttpClient]::new()
	$http.DefaultRequestHeaders.Add('token', $NexarToken)

	$data = [System.Net.Http.ByteArrayContent]::new([System.IO.File]::ReadAllBytes($Path))
	$data.Headers.ContentType = [System.Net.Http.Headers.MediaTypeHeaderValue]::Parse('multipart/form-data')

	$form = [System.Net.Http.MultipartFormDataContent]::new()
	$form.Add($data, 'file', [System.IO.Path]::GetFileName($Path))

	$response = $http.PostAsync($uploadUrl, $form).GetAwaiter().GetResult()
	$content = $response.Content.ReadAsStringAsync().GetAwaiter().GetResult()
	if ($response.IsSuccessStatusCode) {
		$content
	}
	else {
		$StatusCode = $response.StatusCode
		throw "StatusCode=$([int]$StatusCode)($StatusCode): $content"
	}
}
catch {
	throw "Cannot upload file: $_"
}
finally {
	if ($response) {$response.Dispose()}
	if ($form) {$form.Dispose()}
	if ($data) {$data.Dispose()}
	if ($http) {$http.Dispose()}
}
