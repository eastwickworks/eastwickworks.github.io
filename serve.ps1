# Tiny local preview server for the site. Run: powershell -ExecutionPolicy Bypass -File serve.ps1
# Then open http://localhost:8321
param([int]$Port = 8321)
$root = Split-Path -Parent $MyInvocation.MyCommand.Path
$listener = New-Object System.Net.HttpListener
$listener.Prefixes.Add("http://localhost:$Port/")
$listener.Start()
Write-Host "Serving $root at http://localhost:$Port/ (Ctrl+C to stop)"
$mime = @{ ".html"="text/html; charset=utf-8"; ".js"="text/javascript; charset=utf-8"; ".css"="text/css";
           ".jpg"="image/jpeg"; ".jpeg"="image/jpeg"; ".png"="image/png"; ".svg"="image/svg+xml"; ".ico"="image/x-icon" }
while ($listener.IsListening) {
    $ctx = $listener.GetContext()
    $path = [System.Uri]::UnescapeDataString($ctx.Request.Url.AbsolutePath)
    if ($path -eq "/") { $path = "/index.html" }
    $file = Join-Path $root ($path -replace "/", "\")
    if ((Test-Path $file -PathType Leaf) -and ((Resolve-Path $file).Path.StartsWith($root))) {
        $bytes = [System.IO.File]::ReadAllBytes($file)
        $ext = [System.IO.Path]::GetExtension($file).ToLower()
        if ($mime.ContainsKey($ext)) { $ctx.Response.ContentType = $mime[$ext] }
        $ctx.Response.ContentLength64 = $bytes.Length
        $ctx.Response.OutputStream.Write($bytes, 0, $bytes.Length)
    } else {
        $ctx.Response.StatusCode = 404
    }
    $ctx.Response.Close()
}
