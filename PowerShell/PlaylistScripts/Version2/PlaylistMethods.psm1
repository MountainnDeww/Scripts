<#
	.SYNOPSIS
		Playlist Methods Powershell Module.

	.DESCRIPTION
		PlaylistMethods.psm1 - Module containing playlist powershell methods.

	.NOTES
		Script          : PlaylistMethods.psm1
		Version         : 1.0
		Author          : Norm Hall
		Email           : norm.hall@outlook.com, halln77@hotmail.com
		Creation Date   : September 16, 2016
		Purpose/Change  : Initial release
		Change Date     : 
		Purpose/Change  : 
		Comment         :        
#>

#[CmdletBinding()]

Function CopyPlaylistsToTemp()
{
	Param (
		[String] $TempPlaylistPath,
		[Switch] $PrintStatus
	)

	If ($PrintStatus) { Write-Host; Write-Host "Copying Playlists to TempPlaylists." -ForegroundColor Green; Write-Host }

	$WPLTempPlaylistPath = ($TempPlaylistPath + "\WPL")
	If (!(Test-Path $WPLTempPlaylistPath)) { New-Item -ItemType Directory -Path $WPLTempPlaylistPath -Force; Write-Host }
	RemoveFiles (Get-ChildItem(($WPLTempPlaylistPath + "\*.wpl")))

	$ZPLTempPlaylistPath = ($TempPlaylistPath + "\ZPL")
	If (!(Test-Path $ZPLTempPlaylistPath)) { New-Item -ItemType Directory -Path $ZPLTempPlaylistPath -Force; Write-Host }
	RemoveFiles (Get-ChildItem(($ZPLTempPlaylistPath + "\*.zpl")))

	$WPLFiles = Get-ChildItem(($PlayListPath + "\*.wpl"))
	$ZPLFiles = Get-ChildItem(($PlayListPath + "\*.zpl"))

	CopyFilesToDestination $WPLFiles $WPLTempPlaylistPath
	CopyFilesToDestination $ZPLFiles $ZPLTempPlaylistPath

	If ($PrintStatus) { Write-Host; Write-Host ("CopyPlaylistsToTemp Complete!") -ForegroundColor Green; Write-Host }
}

Function CopyPlaylistsToMaster()
{
	Param (
		[String] $MasterPlaylistPath,
		[Switch] $PrintStatus
	)

	If ($PrintStatus) { Write-Host; Write-Host "Copying Playlists to MasterPlaylists." -ForegroundColor Green; Write-Host }

	$WPLMasterPlaylistPath = ($MasterPlayListPath + "\WPL")
	$ZPLMasterPlaylistPath = ($MasterPlayListPath + "\ZPL")

	$WPLFiles = Get-ChildItem(($PlayListPath + "\*.wpl"))
	$ZPLFiles = Get-ChildItem(($PlayListPath + "\*.zpl"))

	CopyFilesToDestination $WPLFiles $WPLMasterPlaylistPath
	CopyFilesToDestination $ZPLFiles $ZPLMasterPlaylistPath

	If ($PrintStatus) { Write-Host; Write-Host ("CopyPlaylistsToMaster Complete!") -ForegroundColor Green; Write-Host }
}

Function CopyMastersToPlaylists()
{
	Param (
		[String] $MasterPlaylistPath,
		[Switch] $PrintStatus
	)

	If ($PrintStatus) { Write-Host; Write-Host "Copying MasterPlaylists to Playlists." -ForegroundColor Green; Write-Host }

	$WPLMasterPlaylistFiles = Get-ChildItem($MasterPlayListPath + "\WPL\*.wpl")
	$ZPLMasterPlaylistFiles = Get-ChildItem($MasterPlayListPath + "\ZPL\*.zpl")

	If ($PrintStatus) { Write-Host; Write-Host "Copying MasterPlaylists to Playlists." -ForegroundColor Green; Write-Host }

	CopyFilesToDestination $WPLMasterPlaylistFiles $PlayListPath
	CopyFilesToDestination $ZPLMasterPlaylistFiles $PlayListPath

	If ($PrintStatus) { Write-Host; Write-Host ("CopyMastersToPlaylists Complete!") -ForegroundColor Green; Write-Host }
}

Function CreateCleanPlayListFiles()
{
	Param (
		[Switch] $PrintStatus,
		[Switch] $Relative
	)

	If ($PrintStatus) { Write-Host; Write-Host "Creating Clean Playlists." -ForegroundColor Green; Write-Host }

	$startDir = $PWD
	$workingDir = $ScriptPath.Path

	CD $workingDir

	$Files = Get-ChildItem(($PlayListPath + "\*.*pl"))
	ForEach ($File In $Files)
	{
		If ($Relative) { CreateCleanPlayList -FilePath $File.FullName -RelativePaths }
		Else { CreateCleanPlayList -FilePath $File.FullName }

		$FilePath = $File.FullName + ".clean"
		If (Test-Path $FilePath ) { Write-Host $FilePath }
		Else { Write-Host ("File not found:" + $FilePath) -ForegroundColor Red }
	}

	CD $startDir

	If ($PrintStatus) { Write-Host; Write-Host ("CreateCleanPlayListFiles Complete!") -ForegroundColor Green; Write-Host }
}

Function CreateCleanPlayList()
{
	Param (
		[String] $FilePath, 
		[Switch] $PrintStatus,
		[Switch] $RelativePaths
	)

	#Cls

	#$Script:FilePath = "D:\Music\Playlists\Favorite Rock.wpl"
	#$NewFileParent = Split-Path $FilePath -Parent
	#$FileLeaf = Split-Path $FilePath -Leaf
	#$FileName = $FileLeaf.Split(".")
	#$NewFileLeaf = ($FileName[0] + "_New." + $FileName[1])
	#$Script:NewFilePath = Join-Path $NewFileParent -ChildPath $NewFileLeaf

	If ($PrintStatus) { Write-Host; Write-Host "Creating Clean Playlist." -ForegroundColor Green; Write-Host }

	If ($FilePath)
	{
		RemovePlayListInfo $FilePath (CreateCleanFile $FilePath)
	}
	Else
	{
		Write-Warning "Verify file location for: [$FilePath]"
	}

	If ($PrintStatus) { Write-Host; Write-Host ("CreateCleanPlayList Complete!") -ForegroundColor Green; Write-Host }

	If ($CaughtException) { Write-Host }
}

# Clean the file
Function RemovePlayListInfo ([String] $FilePath, [String] $CleanFilePath)
{
	If ($PrintStatus) { Write-Host; Write-Host "Removing Playlists Info." -ForegroundColor Green; Write-Host }

	$LiteralMediaSrc = [String]::Format("<media src=`"{0}\", ($MusicPath))
	$RelativeMediaSrc = "<media src=`"..\"

	$FileContent = Get-Content $FilePath
	ForEach($Line In $FileContent)
	{
		If (-Not($Line.Contains("<meta ")) -and -Not($Line.Contains("<guid")) -and -Not($Line.Contains("<author/>")) -and -Not($Line.Contains("<author />")))
		{
			$NewLine = $Line

			$StringStart = -1

			If ($NewLine.Contains("<head>"))
			{
				$StringStart = $NewLine.IndexOf("<head>")
				$NewLine = ("  " + $NewLine.SubString($StringStart))
			}

			If ($Line.Contains("</head>"))
			{
				$StringStart = $NewLine.IndexOf("</head>")
				$NewLine = ("  " + $NewLine.SubString($StringStart))
			}

			If ($Line.Contains("<body>"))
			{
				$StringStart = $NewLine.IndexOf("<body>")
				$NewLine = ("  " + $NewLine.SubString($StringStart))
			}

			If ($Line.Contains("</body>"))
			{
				$StringStart = $NewLine.IndexOf("</body>")
				$NewLine = ("  " + $NewLine.SubString($StringStart))
			}

			If ($Line.Contains("<title>"))
			{
				$StringStart = $NewLine.IndexOf("<title>")
				$NewLine = ("    " + $NewLine.SubString($StringStart))
			}

			If ($Line.Contains("<seq>"))
			{
				$StringStart = $NewLine.IndexOf("<seq>")
				$NewLine = ("    " + $NewLine.SubString($StringStart))
			}

			If ($Line.Contains("</seq>"))
			{
				$StringStart = $NewLine.IndexOf("</seq>")
				$NewLine = ("    " + $NewLine.SubString($StringStart))
			}

			If ($Line.Contains("<media src="))
			{
				$StringStart = $NewLine.IndexOf("<media src=")
				$NewLine = ("      " + $NewLine.SubString($StringStart))
			}

			If ($RelativePaths -and $NewLine.Contains($LiteralMediaSrc))
			{
				$NewLine = $NewLine.Replace($LiteralMediaSrc, $RelativeMediaSrc)
			}

			If ($NewLine.Contains("&apos;"))
			{
				$NewLine = $NewLine.Replace("&apos;", "'")
			}

			$EndStringStart = -1
			If ($Line.Contains("serviceId=")) { $EndStringStart = $NewLine.IndexOf("serviceId=") }
			ElseIf ($Line.Contains("albumTitle=")) { $EndStringStart = $NewLine.IndexOf("albumTitle=") }
			ElseIf ($Line.Contains("albumArtist=")) { $EndStringStart = $NewLine.IndexOf("albumArtist=") }
			ElseIf ($Line.Contains("trackTitle=")) { $EndStringStart = $NewLine.IndexOf("trackTitle=") }
			ElseIf ($Line.Contains("trackArtist=")) { $EndStringStart = $NewLine.IndexOf("trackArtist=") }
			ElseIf ($Line.Contains("duration=")) { $EndStringStart = $NewLine.IndexOf("duration=") }
			ElseIf ($Line.Contains("cid=")) { $EndStringStart = $NewLine.IndexOf("cid=") }
			ElseIf ($Line.Contains("tid=")) { $EndStringStart = $NewLine.IndexOf("tid=") }

			If ($EndStringStart -ge 0)
			{
				$NewLine = ($NewLine.SubString(0, $EndStringStart) + "/>")
			}

			If ($NewLine.EndsWith("""/>"))
			{
				$NewLine = $NewLine.Replace("""/>", """ />")
			}

			Write-ToFile $CleanFilePath $NewLine
		}
	}

	If ($PrintStatus) { Write-Host; Write-Host ("RemovePlayListInfo Complete!") -ForegroundColor Green; Write-Host }
}

Function ReplacePlWithCleanPl()
{
	Param (
		[Switch] $PrintStatus
	)

	If ($PrintStatus) { Write-Host; Write-Host "Replacing Dirty Playlists with Clean Playlists." -ForegroundColor Green; Write-Host }

	$Files = Get-ChildItem(($PlayListPath + "\*.*pl"))
	ForEach ($File In $Files)
	{
		$CleanPL = ($File.FullName + ".clean")
		IF (Test-Path $CleanPL)
		{
			Move-Item -Path $CleanPL -Destination $File.FullName -Force
			Write-Host $File.FullName
		}
	}

	If ($PrintStatus) { Write-Host; Write-Host ("ReplacePlWithCleanPl Complete!") -ForegroundColor Green; Write-Host }
}

Function RemoveBakClean()
{
	Param (
		[Switch] $Bak,
		[Switch] $PrintStatus,
		[Switch] $Clean
	)

	$WPLFiles = ($PlayListPath + "\*.wpl")
	$ZPLFiles = ($PlayListPath + "\*.zpl")

	If  ($Bak)
	{
		If ($PrintStatus) { Write-Host; Write-Host "Removing .bak files." -ForegroundColor Green; Write-Host }

		RemoveFiles (Get-ChildItem(($WPLFiles + ".bak")))
		RemoveFiles (Get-ChildItem(($ZPLFiles + ".bak")))
	}

	If  ($Clean)
	{
		If ($PrintStatus) { Write-Host; Write-Host "Removing .clean files." -ForegroundColor Green; Write-Host }

		RemoveFiles (Get-ChildItem(($WPLFiles + ".clean")))
		RemoveFiles (Get-ChildItem(($ZPLFiles + ".clean")))
	}

	If ($PrintStatus) { Write-Host; Write-Host ("RemoveBakClean Complete!") -ForegroundColor Green; Write-Host }
}

Function SetMusicFolderInFiles()
{
	Param (
		[String] $MusicPath,
		[String] $PlayListPath,
		[Switch] $PrintStatus
	)

	If ($PrintStatus) { Write-Host; Write-Host "Setting music folder in files." -ForegroundColor Green; Write-Host }

	#If ($Drive) { $MusicPath = ($Drive + "\Music") }
	#Else { ("M:\Music") }

	$WPLFiles = Get-ChildItem ($PlayListPath + "\*.wpl")
	ForEach ($File In $WPLFiles)
	{
		Write-Host $File.FullName
		SetMusicFolder -FilePath $File.FullName -MusicPath $MusicPath
	}

	$ZPLFiles = Get-ChildItem ($PlayListPath + "\*.zpl")
	ForEach ($File In $ZPLFiles)
	{
		Write-Host $File.FullName
		SetMusicFolder -FilePath $File.FullName -MusicPath $MusicPath
	}

	If ($PrintStatus) { Write-Host; Write-Host ("SetMusicFolderInFiles Complete!") -ForegroundColor Green; Write-Host }
}

Function SetMusicFolder()
{
	Param (
		[String] $FilePath, 
		[String] $MusicPath,
		[Switch] $PrintStatus,
		[Switch] $Relative
	)

	If ($PrintStatus) { Write-Host; Write-Host ("Setting Music Folder in File") -ForegroundColor Green; Write-Host }

	$RelativePath = "<media src=`"..\"
	If (-Not($FileMusicPath)) { $FileMusicPath = [String]::Format("<media src=`"{0}\", ($MusicPath)) }
	If (-Not($FileMusicPath.StartsWith("<media src=`""))) { $FileMusicPath = ("<media src=`"" + $MusicPath) }
	If (-Not($FileMusicPath.EndsWith("\"))) { $FileMusicPath = ($FileMusicPath + "\") }
	$LiteralPath = $FileMusicPath

	If ($Relative)
	{
		$Script:SearchPath = $LiteralPath
		$Script:ReplacePath = $RelativePath
	}
	Else
	{
		$Script:SearchPath = $RelativePath
		$Script:ReplacePath = $LiteralPath
	}


	If ($FilePath)
	{
		$BackupFilePath = BackupFile $FilePath
		ReCreateEmptyFile $FilePath
		SetMusicFolder $BackupFilePath $FilePath
	}
	Else
	{
		Write-Warning "Syntax: SetMusicFolder.ps1 [-FilePath] `"FullPathToFile`" [[-MusicPath] `"FullPathToMusicFolder`"]"
	}

	If ($CaughtException) { Write-Host }

	If ($PrintStatus) { Write-Host; Write-Host ("SetMusicFolder Complete!") -ForegroundColor Green; Write-Host }
}

# Compare lines in files
Function CompareLines ()
{
	Param (
		[String] $WplFilePath, 
		[String] $ZplFilePath
	)

	$WplFileContent = Get-Content $WplFilePath
	$ZplFileContent = Get-Content $ZplFilePath
	ForEach($WplLine In $WplFileContent)
	{
		If (!($WplLine.Contains("wpl version")))
		{
			ForEach($ZplLine In $ZplFileContent)
			{
				If (!($WplLine.Contains("zpl version")))
				{
					If ($WplLine -ne $ZplLine) { "" }
				}
			}
		}
	}
}

Function CompareFiles()
{
	Param (
		[String] $WplFilePath,
		[String] $ZplFilePath,
		[Switch] $PrintStatus
	)

	If ($PrintStatus) { Write-Host; Write-Host ("Comparing Files.") -ForegroundColor Green; Write-Host }

	# Compare the files
	If($WplFilePath -and $ZplFilePath) { CompareLines $WplFilePath $ZplFilePath}

	If ($PrintStatus) { Write-Host; Write-Host ("CompareFiles Complete!") -ForegroundColor Green; Write-Host }

	If ($CaughtException) { Write-Host }
}

Function CopyWplToZpl()
{
	Param (
		[String] $PlayListScripts,
		[Switch] $PrintStatus
	)

	If ($PrintStatus) { Write-Host; Write-Host ("Copying Wpl To Zpl.") -ForegroundColor Green; Write-Host }

	#$PlayListScripts = $env:USERPROFILE + "\OneDrive\Scripts\PowerShell\PlaylistScripts"

	$Global:MusicDrive = "M:"
	$Global:MusicPath = $MusicDrive + "\Music"
	$Global:PlayListPath = $MusicPath + ("\Playlists")

	cd $PlayListScripts

	$WplFiles = Get-ChildItem(($PlayListPath + "\*.wpl"))

	ForEach ($File In $WplFiles)
	{
		$DestinationPath = (Split-Path $File -Parent)
		$SourceFile = (Split-Path $File -Leaf)
		$SourceFileName = $SourceFile.Split(".")[0]

		$DestinationFile = ($DestinationPath + "\" + $SourceFileName + ".zpl")

		Copy-Item $File $DestinationFile -Force

		$zplContent = Get-Content($File)
		$zplContent = $zplContent.Replace("<?wpl version=`"1.0`"?>", "<?zpl version=`"2.0`"?>")
		Out-File -FilePath $DestinationFile -InputObject $zplContent -Force
	}

	If ($PrintStatus) { Write-Host; Write-Host ("CopyWplToZpl Complete!") -ForegroundColor Green; Write-Host }
}

Function CopyZplToWpl()
{
	Param (
		[String] $PlayListScripts,
		[Switch] $PrintStatus
	)

	If ($PrintStatus) { Write-Host; Write-Host ("Copying Zpl To Wpl.") -ForegroundColor Green; Write-Host }

	#$PlayListScripts = $env:USERPROFILE + "\OneDrive\Scripts\PowerShell\PlaylistScripts"

	$Global:MusicDrive = "M:"
	$Global:MusicPath = $MusicDrive + "\Music"
	$Global:PlayListPath = $MusicPath + ("\Playlists")

	cd $PlayListScripts

	$ZplFiles = Get-ChildItem(($PlayListPath + "\*.zpl"))

	ForEach ($File In $ZplFiles)
	{
		$DestinationPath = (Split-Path $File -Parent)
		$SourceFile = (Split-Path $File -Leaf)
		$SourceFileName = $SourceFile.Split(".")[0]

		$DestinationFile = ($DestinationPath + "\" + $SourceFileName + ".wpl")

		Copy-Item $File $DestinationFile -Force

		$wplContent = Get-Content($File)
		$wplContent.Replace("<?zpl version=`"2.0`"?>", "<?wpl version=`"1.0`"?>")
		Out-File -FilePath $DestinationFile -InputObject $wplContent -Force
	}

	If ($PrintStatus) { Write-Host; Write-Host ("CopyZplToWpl Complete!") -ForegroundColor Green; Write-Host }
}

Function RestoreBakFiles()
{
	Param (
		[Switch] $PrintStatus
	)

	If ($PrintStatus) { Write-Host; Write-Host ("Restoring Bak Files.") -ForegroundColor Green; Write-Host }

	$WPLFiles = Get-ChildItem ($PlayListPath + "\*.wpl")
	ForEach ($File In $WPLFiles)
	{
		$BakFile = ($File.FullName + ".bak")
		If (Test-Path $BakFile)
		{
			Write-Host $File.FullName
			Remove-Item $File.FullName
			Rename-Item $BakFile $File.FullName
		}
	}

	$ZPLFiles = Get-ChildItem ($PlayListPath + "\*.zpl")
	ForEach ($File In $ZPLFiles)
	{
		$BakFile = ($File.FullName + ".bak")
		If (Test-Path $BakFile)
		{
			Write-Host $File.FullName
			Remove-Item $File.FullName
			Rename-Item $BakFile $File.FullName
		}
	}

	If ($PrintStatus) { Write-Host; Write-Host ("RestoreBakFiles Complete!") -ForegroundColor Green; Write-Host }
}
