Add-Type -AssemblyName System.Drawing

function Export-GalleryCrop {
  param(
    [Parameter(Mandatory = $true)][string]$Source,
    [Parameter(Mandatory = $true)][string]$Target,
    [Parameter(Mandatory = $true)][double]$X,
    [Parameter(Mandatory = $true)][double]$Y,
    [Parameter(Mandatory = $true)][double]$Width,
    [Parameter(Mandatory = $true)][double]$Height
  )

  $sourceImage = [System.Drawing.Image]::FromFile($Source)
  $targetImage = New-Object System.Drawing.Bitmap 900, 600
  $graphics = [System.Drawing.Graphics]::FromImage($targetImage)

  try {
    $graphics.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
    $graphics.PixelOffsetMode = [System.Drawing.Drawing2D.PixelOffsetMode]::HighQuality
    $graphics.CompositingQuality = [System.Drawing.Drawing2D.CompositingQuality]::HighQuality

    $sourceRectangle = New-Object System.Drawing.RectangleF(
      [single]($sourceImage.Width * $X),
      [single]($sourceImage.Height * $Y),
      [single]($sourceImage.Width * $Width),
      [single]($sourceImage.Height * $Height)
    )
    $targetRectangle = New-Object System.Drawing.RectangleF(0, 0, 900, 600)
    $graphics.DrawImage($sourceImage, $targetRectangle, $sourceRectangle, [System.Drawing.GraphicsUnit]::Pixel)

    $jpegCodec = [System.Drawing.Imaging.ImageCodecInfo]::GetImageEncoders() |
      Where-Object { $_.MimeType -eq 'image/jpeg' }
    $encoderParameters = New-Object System.Drawing.Imaging.EncoderParameters 1
    $encoderParameters.Param[0] = New-Object System.Drawing.Imaging.EncoderParameter(
      [System.Drawing.Imaging.Encoder]::Quality,
      [long]84
    )
    $targetImage.Save($Target, $jpegCodec, $encoderParameters)
  }
  finally {
    $graphics.Dispose()
    $targetImage.Dispose()
    $sourceImage.Dispose()
  }
}

$assetDirectory = Join-Path $PSScriptRoot '..\src\assets'

Export-GalleryCrop (Join-Path $assetDirectory 'venus-main.jpg') (Join-Path $assetDirectory 'venus-detail-1.jpg') 0.35 0.05 0.38 0.57
Export-GalleryCrop (Join-Path $assetDirectory 'venus-main.jpg') (Join-Path $assetDirectory 'venus-detail-2.jpg') 0.57 0.12 0.40 0.60

Export-GalleryCrop (Join-Path $assetDirectory 'supper-main.jpg') (Join-Path $assetDirectory 'supper-detail-1.jpg') 0.30 0.22 0.40 0.58
Export-GalleryCrop (Join-Path $assetDirectory 'supper-main.jpg') (Join-Path $assetDirectory 'supper-detail-2.jpg') 0.05 0.27 0.44 0.58

Export-GalleryCrop (Join-Path $assetDirectory 'adam.png') (Join-Path $assetDirectory 'adam-detail-1.jpg') 0.00 0.16 0.55 0.66
Export-GalleryCrop (Join-Path $assetDirectory 'adam.png') (Join-Path $assetDirectory 'adam-detail-2.jpg') 0.34 0.24 0.42 0.44

Export-GalleryCrop (Join-Path $assetDirectory 'anatomy-main.jpg') (Join-Path $assetDirectory 'anatomy-detail-1.jpg') 0.45 0.12 0.43 0.65
Export-GalleryCrop (Join-Path $assetDirectory 'anatomy-main.jpg') (Join-Path $assetDirectory 'anatomy-detail-2.jpg') 0.02 0.16 0.52 0.64
