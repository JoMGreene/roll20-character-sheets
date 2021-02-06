﻿$inputFile = 'D:\git\roll20-character-sheets\AD&D 2E Revised\raw\2ESheet-base.html'
$sourceFolder = 'D:\git\roll20-character-sheets\AD&D 2E Revised'
$outputFile = 'D:\git\roll20-character-sheets\AD&D 2E Revised\2ESheet.html'

$replaceConstant = '#REPLACE#'

$content = Get-Content -Path $inputFile

$inserts = ($content | Select-String -Pattern 'insert_')

$inserts | ForEach-Object {
   $_.Trim()
   $split = $_.Line.Split('_')
   $whiteSpace = $split[0].Replace('insert', '')
   $fileName = $split[1]
   $file = Get-ChildItem -Path $sourceFolder -Filter $fileName -Recurse
   $fileContent = Get-Content -Path $file.FullName
   if ($whiteSpace.Length -gt 0) {
      for ($i = 0; $i -lt $fileContent.Length; $i++)
      {
         $fileContent[$i] = $whiteSpace + $fileContent[$i]
      }
   }
   $rawContent = $fileContent -join "`n"
   if ($split.Length -gt 2 -and $rawContent.Contains($replaceConstant)) {
      $rawContent = $rawContent.Replace($replaceConstant, $split[2])
   }

   $content = $content -replace $_.Line, ($rawContent)
}

$content | Set-Content -Path $outputFile
$time = Get-Date -Format "HH:mm:ss";
Write-Host "Combine complete $time" 