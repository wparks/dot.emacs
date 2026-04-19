# setup.ps1 — Set up dotfiles symlinks (Windows)
#
# Usage: powershell -ExecutionPolicy Bypass -File setup.ps1
# Requires: Developer Mode enabled (Settings > For Developers > Developer Mode)

$DotfilesDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$EmacsDir = Join-Path $env:USERPROFILE ".emacs.d"

Write-Host "Setting up dotfiles from $DotfilesDir"

# Emacs
if (Test-Path $EmacsDir) {
    $item = Get-Item $EmacsDir
    if ($item.LinkType -ne "SymbolicLink") {
        Write-Host "ERROR: $EmacsDir exists and is not a symlink."
        Write-Host "Back it up and remove it first."
        exit 1
    }
    Write-Host "  $EmacsDir already symlinked"
} else {
    New-Item -ItemType SymbolicLink -Path $EmacsDir -Target (Join-Path $DotfilesDir "emacs.d") | Out-Null
    Write-Host "  $EmacsDir -> $DotfilesDir\emacs.d"
}

Write-Host ""
Write-Host "Done. Launch Emacs to install packages, then run:"
Write-Host "  make grammars   # optional: install tree-sitter grammars"
Write-Host "  make test       # verify everything works"
