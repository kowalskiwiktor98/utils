# Based on Piotr Stapp's blog post
# https://stapp.space/few-steps-to-pimp-my-terminal/
# ~\Documents\PowerShell\Microsoft.PowerShell_profile.ps1

function Import-Module-With-Measure {  
    param ($ModuleName)
    $import = Measure-Command {
        Import-Module $ModuleName
    }
    Write-Host "$ModuleName import $($import.TotalMilliseconds) ms"
}

#clear
Import-Module PSReadLine
Import-Module-With-Measure posh-git
Import-Module-With-Measure oh-my-posh
Import-Module posh-dotnet

# theme
# Get-PoshThemes
Set-PoshPrompt -Theme half-life

# command history
Set-PSReadLineKeyHandler -Key UpArrow -Function HistorySearchBackward
Set-PSReadLineKeyHandler -Key DownArrow -Function HistorySearchForward

# menu complete using TAB instead of CTRL+SPACE
Set-PSReadlineKeyHandler -Chord Tab -Function MenuComplete

#variables
$DEV = $HOME+"\source\repos"
$REPOS = $DEV
$VSCODE = "C:\VSCode"

#dotnet completion
Register-ArgumentCompleter -Native -CommandName dotnet -ScriptBlock {  
    param($commandName, $wordToComplete, $cursorPosition)
    dotnet complete --position $cursorPosition "$wordToComplete" | ForEach-Object {
        [System.Management.Automation.CompletionResult]::new($_, $_, 'ParameterValue', $_)
    }
}