# nexar-examples-powershell

[nexar.com]: https://nexar.com
[nexar-token-cs]: https://github.com/NexarDeveloper/nexar-token-cs
[nexar-token-py]: https://github.com/NexarDeveloper/nexar-token-py

This repository provides examples of various Nexar operations using PowerShell scripts.

All scripts are ready to use, given the required parameters / prerequisites.
Some scripts are practically useful tools for automating certain scenarios.
Some scripts are templates for further development and customization.

- [Prerequisites](#prerequisites)
- Queries
    - [Get-Workspaces](#get-workspaces)
    - [Get-Projects](#get-projects)
- Mutations
    - [Upload-Project](#upload-project)
- File operations
    - [Upload-NexarFile](#upload-nexarfile)
    - [Download-NexarFile](#download-nexarfile)
- Tools
    - [Show-NexarVoyager](#show-nexarvoyager)

## Prerequisites

If you have not done this already, please register at [nexar.com] and create a
Nexar application with the Design domain enabled.

In order to get anything useful, you also need your Altium Live
credentials and have to be a member of at least one Altium 365 workspace.

An access token is required for all operations. Go to [nexar.com] application details, click
"Generate token". Alternatively, you may get a token using one of the tools:
[nexar-token-cs], [nexar-token-py].

The access token is used as script parameters `NexarToken` or set as the environment variable `NEXAR_TOKEN`.

## Get-Workspaces

[Get-Workspaces.ps1](Scripts/Get-Workspaces.ps1)

This simple "Hello World" query is very important in the Nexar Design domain.
The script gets available workspaces with some useful top level information:

- `name` is the workspace name, e.g. for choosing workspaces in UI
- `url` is used in many subsequent GraphQL queries and mutations
- `location`
    - `apiServiceUrl` is the GraphQL URL for the most effective work with this workspace
    - `filesServiceUrl` is the files URL for the most effective work with this workspace

## Get-Projects

[Get-Projects.ps1](Scripts/Get-Projects.ps1)

This script is used in order to get all project of the specified workspace.
The input workspace URL is either natural A365 URL or obtained by [Get-Workspaces](#get-workspaces).

The script demonstrates important concepts and techniques:

- How to invoke a GraphQL operation with variables (parameters).
- How to handle GraphQL pagination used for potentially lengthy results.

## Upload-Project

[Upload-Project.ps1](Scripts/Upload-Project.ps1)

This script imports the specified project zip file to the specified A365 workspace.
It is ready to use for automating some scenarios.

Practical use case:

- Create and maintain a project designed as the template project, export it to a zip file.
- Use `Upload-Project` in order to replicate this zip as new projects in the same workspace.

**WARNING**: Avoid uploading projects exported from different workspaces.
Such imported projects may have unmanaged components and other unresolved entities.

## Upload-NexarFile

[Upload-NexarFile.ps1](Scripts/Upload-NexarFile.ps1)

This script is used in order to upload files to Nexar for using in subsequent operations.
It is ready to use for automating some scenarios.
In particular it is used by [Upload-Project](#upload-project).

The script takes a file path as input, uploads the file, and returns the uploaded file ID.
This ID is valid for several hours and used in relevant Nexar GraphQL operations as input.

## Download-NexarFile

[Download-NexarFile.ps1](Scripts/Download-NexarFile.ps1)

Given the ID of previously uploaded file, this script downloads this file to the specified location.
This script is rather added for completeness, clients do not have to use it in designed scenarios.

## Show-NexarVoyager

[Show-NexarVoyager.ps1](Scripts/Show-NexarVoyager.ps1)

Nexar GraphQL Voyager online: <https://api.nexar.com/ui/voyager>

This script generates and opens HTML which renders GraphQL Voyager with the
Nexar GraphQL API and several display options.

The script requires [Show-GraphQLVoyager.ps1](https://www.powershellgallery.com/packages/Show-GraphQLVoyager).
You may install it as:

```powershell
Install-Script Show-GraphQLVoyager
```

By default the script renders the graph with `Query` as the root. The graph is
the same as online and rather large. Use the parameter `RootType` in order to
show the graph for a particular type, perhaps with some options, e.g.

```powershell
Show-NexarVoyager Mutation
Show-NexarVoyager DesComponent -HideDocs
```
