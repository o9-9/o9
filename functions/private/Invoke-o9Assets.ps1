function Invoke-o9Assets {
  param (
      $type,
      $Size,
      [switch]$render
  )

  # Create the Viewbox and set its size
  $LogoViewbox = New-Object Windows.Controls.Viewbox
  $LogoViewbox.Width = $Size
  $LogoViewbox.Height = $Size

  # Create a Canvas to hold the paths
  $canvas = New-Object Windows.Controls.Canvas
  $canvas.Width = 150
  $canvas.Height = 150

  # Define a scale factor for the content inside the Canvas
  $scaleFactor = $Size / 100

  # Apply a scale transform to the Canvas content
  $scaleTransform = New-Object Windows.Media.ScaleTransform($scaleFactor, $scaleFactor)
  $canvas.LayoutTransform = $scaleTransform

  switch ($type) {
      'logo' {
          $LogoPathData = @"
M114.7 47.7c-6.5 2.2-12.9 8.1-15.8 14.5-3.5 8-3.4 20.2.3 27.8 5.4 11 17 15.5 29.1 11.4 5.8-2 14.2-9.4 15.9-14 2.4-6.8 3.1-3.6 2.5 12.3-.6 17.9-2.3 24.5-7.9 30.2-4.3 4.3-7.6 5.9-14 6.7-6.7.8-12.7-.8-15.9-4.2l-2.4-2.6 2.2-1.6c1.2-1 4-2.8 6.2-4.1s4.5-3.6 5.1-5.1c3.1-7.6-7.5-13.9-16-9.5-11.5 5.9-5.2 22.9 10.4 28.1 6.7 2.2 19.2 1.5 26.4-1.6 8.9-3.8 15-12.1 18.3-25 2.1-8.3 1.9-36.8-.3-44-2.7-8.8-6.9-14.5-13-17.7-4.6-2.3-6.6-2.7-15.8-3-7.8-.2-11.7.1-15.3 1.4m23.3 2.2c1.4.9 3.6 3.9 5 6.7 2.2 4.2 2.5 6.2 2.5 14.9 0 9.9-.1 10.1-3.7 15.7-7 10.8-17.1 14-24.2 7.8-5.1-4.6-6.9-9.9-6.9-20.5.1-14.2 4.9-24 12.9-26.5 3.9-1.2 11.4-.3 14.4 1.9m-22.5 1.8c-3.9 3.8-5.8 10.4-6.3 21.3-.4 9.3-.2 11.2 1.8 15.8 2.3 5.3 6.9 10.2 9.6 10.2.8 0 1.4.5 1.4 1.1 0 1.7-8.1.4-12.8-2-8-4.1-10.7-9.6-10.6-22.1 0-7.8.3-10.2 2.1-13.5 2.6-5 6.7-8.9 11.8-11.4 4.6-2.2 5.5-2 3 .6m30.4.4c4.5 2.5 8.4 7.9 10.8 14.9 1.5 4.5 1.8 8.6 1.8 23 0 19.6-.9 24.4-6.7 34-3.4 5.7-10.9 11.2-16.6 12.3-2.3.4-2.5.3-.8-.7 7-4.3 10.7-9.4 12.4-17.1 1.8-8.2 2.3-23 1.3-39.5-.9-15.5-2.7-23.7-5.9-27.3-2-2.3-.8-2.2 3.7.4m-29.3 60.2c3.3 2.9 2.8 6.8-1.4 9.3-1.5.9-4.6 3-7 4.5L104 129l-2-3.3c-3.3-5.3-2.5-11.3 1.8-14 4-2.4 9.6-2.2 12.8.6m-77.1-39C24.9 78.2 17.7 89 17.7 106c0 16.9 7.1 27.2 21.3 31.4 11.2 3.3 25.1 1.1 32.9-5.2 1.9-1.6 5.1-5.7 7-9.3 3.5-6.3 3.6-6.6 3.6-17.4-.1-9.9-.4-11.6-2.8-16.7-3.2-6.5-8-11.1-14.6-14-5.8-2.6-19.8-3.4-25.6-1.5m18.4 2.3c7 4.1 10.4 13.6 10.5 29.4.1 14.1-1.7 20.8-7.2 27-3.3 3.7-4.4 4.3-8.8 4.7C39.1 138 32 127.1 32 105.5c0-14.6 4.2-26.4 10.7-29.9 3.7-2 11.8-2 15.2 0m-21.3 3.6c-4.5 6-6.1 13.1-6.1 26.8 0 13.3 1.6 20.3 5.6 25.4 3.9 5-3.5 2-8.8-3.6-9.4-9.8-10.8-28.9-2.9-40.6C27.2 83 35.8 76 38.2 76c.5 0-.2 1.5-1.6 3.2m35 2.2c6.5 5.6 8.9 11.4 9.2 23.1.3 9.6.1 10.3-3 16.5-2.5 5-4.5 7.3-8.2 9.8-2.6 1.7-5.2 3.2-5.6 3.2-.5 0 .5-2.6 2.1-5.8 6.6-12.9 5.8-37.7-1.5-48.5l-2.4-3.5 2.8.9c1.5.6 4.5 2.5 6.6 4.3
"@
          $LogoPath = New-Object Windows.Shapes.Path
          $LogoPath.Data = [Windows.Media.Geometry]::Parse($LogoPathData)
          $LogoPath.Fill = [System.Windows.Media.BrushConverter]::new().ConvertFromString("#ffffff")

          $canvas.Children.Add($LogoPath) | Out-Null
      }
      'checkmark' {
          $canvas.Width = 512
          $canvas.Height = 512

          $scaleFactor = $Size / 2.54
          $scaleTransform = New-Object Windows.Media.ScaleTransform($scaleFactor, $scaleFactor)
          $canvas.LayoutTransform = $scaleTransform

          # Define the circle path
          $circlePathData = "M 1.27,0 A 1.27,1.27 0 1,0 1.27,2.54 A 1.27,1.27 0 1,0 1.27,0"
          $circlePath = New-Object Windows.Shapes.Path
          $circlePath.Data = [Windows.Media.Geometry]::Parse($circlePathData)
          $circlePath.Fill = [System.Windows.Media.BrushConverter]::new().ConvertFromString("#39ba00")

          # Define the checkmark path
          $checkmarkPathData = "M 0.873 1.89 L 0.41 1.391 A 0.17 0.17 0 0 1 0.418 1.151 A 0.17 0.17 0 0 1 0.658 1.16 L 1.016 1.543 L 1.583 1.013 A 0.17 0.17 0 0 1 1.599 1 L 1.865 0.751 A 0.17 0.17 0 0 1 2.105 0.759 A 0.17 0.17 0 0 1 2.097 0.999 L 1.282 1.759 L 0.999 2.022 L 0.874 1.888 Z"
          $checkmarkPath = New-Object Windows.Shapes.Path
          $checkmarkPath.Data = [Windows.Media.Geometry]::Parse($checkmarkPathData)
          $checkmarkPath.Fill = [Windows.Media.Brushes]::White

          # Add the paths to the Canvas
          $canvas.Children.Add($circlePath) | Out-Null
          $canvas.Children.Add($checkmarkPath) | Out-Null
      }
      'warning' {
          $canvas.Width = 512
          $canvas.Height = 512

          # Define a scale factor for the content inside the Canvas
          $scaleFactor = $Size / 512  # Adjust scaling based on the canvas size
          $scaleTransform = New-Object Windows.Media.ScaleTransform($scaleFactor, $scaleFactor)
          $canvas.LayoutTransform = $scaleTransform

          # Define the circle path
          $circlePathData = "M 256,0 A 256,256 0 1,0 256,512 A 256,256 0 1,0 256,0"
          $circlePath = New-Object Windows.Shapes.Path
          $circlePath.Data = [Windows.Media.Geometry]::Parse($circlePathData)
          $circlePath.Fill = [System.Windows.Media.BrushConverter]::new().ConvertFromString("#f41b43")

          # Define the exclamation mark path
          $exclamationPathData = "M 256 307.2 A 35.89 35.89 0 0 1 220.14 272.74 L 215.41 153.3 A 35.89 35.89 0 0 1 251.27 116 H 260.73 A 35.89 35.89 0 0 1 296.59 153.3 L 291.86 272.74 A 35.89 35.89 0 0 1 256 307.2 Z"
          $exclamationPath = New-Object Windows.Shapes.Path
          $exclamationPath.Data = [Windows.Media.Geometry]::Parse($exclamationPathData)
          $exclamationPath.Fill = [Windows.Media.Brushes]::White

          # Get the bounds of the exclamation mark path
          $exclamationBounds = $exclamationPath.Data.Bounds

          # Calculate the center position for the exclamation mark path
          $exclamationCenterX = ($canvas.Width - $exclamationBounds.Width) / 2 - $exclamationBounds.X
          $exclamationPath.SetValue([Windows.Controls.Canvas]::LeftProperty, $exclamationCenterX)

          # Define the rounded rectangle at the bottom (dot of exclamation mark)
          $roundedRectangle = New-Object Windows.Shapes.Rectangle
          $roundedRectangle.Width = 80
          $roundedRectangle.Height = 80
          $roundedRectangle.RadiusX = 30
          $roundedRectangle.RadiusY = 30
          $roundedRectangle.Fill = [Windows.Media.Brushes]::White

          # Calculate the center position for the rounded rectangle
          $centerX = ($canvas.Width - $roundedRectangle.Width) / 2
          $roundedRectangle.SetValue([Windows.Controls.Canvas]::LeftProperty, $centerX)
          $roundedRectangle.SetValue([Windows.Controls.Canvas]::TopProperty, 324.34)

          # Add the paths to the Canvas
          $canvas.Children.Add($circlePath) | Out-Null
          $canvas.Children.Add($exclamationPath) | Out-Null
          $canvas.Children.Add($roundedRectangle) | Out-Null
      }
      default {
          Write-Host "Invalid type: $type"
      }
  }

  # Add the Canvas to the Viewbox
  $LogoViewbox.Child = $canvas

  if ($render) {
      # Measure and arrange the canvas to ensure proper rendering
      $canvas.Measure([Windows.Size]::new($canvas.Width, $canvas.Height))
      $canvas.Arrange([Windows.Rect]::new(0, 0, $canvas.Width, $canvas.Height))
      $canvas.UpdateLayout()

      # Initialize RenderTargetBitmap correctly with dimensions
      $renderTargetBitmap = New-Object Windows.Media.Imaging.RenderTargetBitmap($canvas.Width, $canvas.Height, 96, 96, [Windows.Media.PixelFormats]::Pbgra32)

      # Render the canvas to the bitmap
      $renderTargetBitmap.Render($canvas)

      # Create a BitmapFrame from the RenderTargetBitmap
      $bitmapFrame = [Windows.Media.Imaging.BitmapFrame]::Create($renderTargetBitmap)

      # Create a PngBitmapEncoder and add the frame
      $bitmapEncoder = [Windows.Media.Imaging.PngBitmapEncoder]::new()
      $bitmapEncoder.Frames.Add($bitmapFrame)

      # Save to a memory stream
      $imageStream = New-Object System.IO.MemoryStream
      $bitmapEncoder.Save($imageStream)
      $imageStream.Position = 0

      # Load the stream into a BitmapImage
      $bitmapImage = [Windows.Media.Imaging.BitmapImage]::new()
      $bitmapImage.BeginInit()
      $bitmapImage.StreamSource = $imageStream
      $bitmapImage.CacheOption = [Windows.Media.Imaging.BitmapCacheOption]::OnLoad
      $bitmapImage.EndInit()

      return $bitmapImage
  } else {
      return $LogoViewbox
  }
}
