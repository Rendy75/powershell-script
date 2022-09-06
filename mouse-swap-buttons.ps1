$swapButtons = Add-Type -MemberDefinition @'
[DllImport("user32.dll")]
public static extern bool SwapMouseButton(bool swap);
'@ -Name "NativeMethods" -Namespace "PInvoke" -PassThru
Function MouseReport {$script:MouseButton = $null; $script:MouseButton = (Get-ItemProperty "HKCU:\Control Panel\Mouse").SwapMouseButtons
If ($MouseButton -eq 0) {Write-Host " Mouse button is set for RIGHT-Handed mouse. " -ForegroundColor Red -BackgroundColor Yellow}
If ($MouseButton -eq 1) {Write-Host " Mouse button is set for LEFT-Handed mouse. " -ForegroundColor Green -BackgroundColor Black}}
MouseReport
    $Choice = @('Y','X'); Do { Write-Host "  Swap?: (Y) / (X): " -NoNewline -ForegroundColor Yellow
    $Swap = (Read-Host).Trim()} Until (($Choice.Contains($Swap.ToUpper()))); If ($Swap -eq "x"){break}
    # $true for Left-Handed, $false for Right-Handed.
        # Mouse is Right-Handed, change it to Left-Handed
            If ($MouseButton -eq 0) {[bool]$returnValue = $swapButtons::SwapMouseButton($true)}
        # Mouse is Left-Handed, change it to Right-Handed
            If ($MouseButton -eq 1) {[bool]$returnValue = $swapButtons::SwapMouseButton($false)}
    1..10 | % { #Give the system time to respond to the above change to the "user32.dll" change.
    If ($_ -lt 10) {Write-Host "." -ForegroundColor Cyan -NoNewline};Start-Sleep -Milliseconds 200
    If ($_ -ge 10) {Write-Host "." -ForegroundColor Cyan}}
MouseReport