# Prepares images for the site.
# Usage: put full-size photos in images\large\ named after their slug (e.g. new-work.jpg),
# then run:  powershell -ExecutionPolicy Bypass -File add-thumbs.ps1
# It shrinks oversized large images to max 1600px and creates any missing 640px thumbnails.
Add-Type -AssemblyName System.Drawing

$root  = Split-Path -Parent $MyInvocation.MyCommand.Path
$large = Join-Path $root "images\large"
$thumb = Join-Path $root "images\thumb"

function Resize-Jpeg([string]$src, [string]$dst, [int]$maxPx) {
    $img = [System.Drawing.Image]::FromFile($src)
    try {
        $scale = [Math]::Min($maxPx / $img.Width, $maxPx / $img.Height)
        if ($scale -ge 1 -and $src -eq $dst) { return $false } # already small enough
        if ($scale -gt 1) { $scale = 1 }
        $w = [int]($img.Width * $scale); $h = [int]($img.Height * $scale)
        $bmp = New-Object System.Drawing.Bitmap($w, $h)
        $g = [System.Drawing.Graphics]::FromImage($bmp)
        $g.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
        $g.DrawImage($img, 0, 0, $w, $h)
        $g.Dispose()
        $codec = [System.Drawing.Imaging.ImageCodecInfo]::GetImageEncoders() | Where-Object { $_.MimeType -eq "image/jpeg" }
        $ep = New-Object System.Drawing.Imaging.EncoderParameters(1)
        $ep.Param[0] = New-Object System.Drawing.Imaging.EncoderParameter([System.Drawing.Imaging.Encoder]::Quality, [long]85)
        $tmp = "$dst.tmp"
        $bmp.Save($tmp, $codec, $ep)
        $bmp.Dispose()
        $img.Dispose()
        Move-Item -Force $tmp $dst
        return $true
    } finally { $img.Dispose() }
}

Get-ChildItem $large -Filter *.jpg | ForEach-Object {
    $name = $_.Name
    $img = [System.Drawing.Image]::FromFile($_.FullName)
    $w = $img.Width; $h = $img.Height
    $img.Dispose()
    if ($w -gt 1650 -or $h -gt 1650) {
        Write-Host "shrinking large/$name ($w x $h -> max 1600)"
        Resize-Jpeg $_.FullName $_.FullName 1600 | Out-Null
    }
    $t = Join-Path $thumb $name
    if (-not (Test-Path $t)) {
        Write-Host "creating thumb/$name"
        Resize-Jpeg $_.FullName $t 640 | Out-Null
    }
}
Write-Host "Done."
