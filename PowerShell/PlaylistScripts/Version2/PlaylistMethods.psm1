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

	CopyPlaylistToTemp -PlaylistType "WPL" -TempPlaylistPath $TempPlaylistPath -PrintStatus
	CopyPlaylistToTemp -PlaylistType "ZPL" -TempPlaylistPath $TempPlaylistPath -PrintStatus
	CopyPlaylistToTemp -PlaylistType "PLS" -TempPlaylistPath $TempPlaylistPath -PrintStatus

	If ($PrintStatus) { Write-Host; Write-Host ("CopyPlaylistsToTemp Complete!") -ForegroundColor Green; Write-Host }
}

Function CopyPlaylistToTemp()
{
	Param (
		[String] $PlaylistType,
		[String] $TempPlaylistPath,
		[Switch] $PrintStatus
	)

	$TempPlaylistPath = ($TempPlaylistPath + "\" + $PlaylistType)
	If (!(Test-Path $TempPlaylistPath)) { New-Item -ItemType Directory -Path $TempPlaylistPath -Force; Write-Host }
	RemoveFiles (Get-ChildItem(($TempPlaylistPath + "\*." + $PlaylistType.ToLower())))

	If ($PrintStatus) { Write-Host; Write-Host ("Copying", $PlaylistType, "Playlists to TempPlaylists.") -ForegroundColor Green; Write-Host }

	$Files = Get-ChildItem(($PlayListPath + "\*." + $PlaylistType.ToLower()))

	CopyFilesToDestination $Files $TempPlaylistPath

	If ($PrintStatus) { Write-Host; Write-Host ("CopyPlaylistToTemp Complete!") -ForegroundColor Green; Write-Host }
}

Function CopyPlaylistsToMaster()
{
	Param (
		[String] $MasterPlaylistPath,
		[Switch] $PrintStatus
	)

	If ($PrintStatus) { Write-Host; Write-Host "Copying Playlists to MasterPlaylists." -ForegroundColor Green; Write-Host }

	CopyPlaylistToMaster -PlaylistType "WPL" -MasterPlaylistPath $MasterPlaylistPath -PrintStatus
	CopyPlaylistToMaster -PlaylistType "ZPL" -MasterPlaylistPath $MasterPlaylistPath -PrintStatus
	CopyPlaylistToMaster -PlaylistType "PLS" -MasterPlaylistPath $MasterPlaylistPath -PrintStatus

	If ($PrintStatus) { Write-Host; Write-Host ("CopyPlaylistsToMaster Complete!") -ForegroundColor Green; Write-Host }
}

Function CopyPlaylistToMaster()
{
	Param (
		[String] $PlaylistType,
		[String] $MasterPlaylistPath,
		[Switch] $PrintStatus
	)

	If ($PrintStatus) { Write-Host; Write-Host ("Copying", $PlaylistType, "Playlists to MasterPlaylists.") -ForegroundColor Green; Write-Host }

	$MasterPlaylistPath = ($MasterPlayListPath + "\" + $PlaylistType)

	$Files = Get-ChildItem(($PlayListPath + "\*." + $PlaylistType.ToLower()))

	CopyFilesToDestination $Files $MasterPlaylistPath

	If ($PrintStatus) { Write-Host; Write-Host ("CopyPlaylistToMaster Complete!") -ForegroundColor Green; Write-Host }
}

Function CopyMastersToPlaylists()
{
	Param (
		[String] $MasterPlaylistPath,
		[Switch] $PrintStatus
	)

	If ($PrintStatus) { Write-Host; Write-Host "Copying MasterPlaylists to Playlists." -ForegroundColor Green; Write-Host }

	CopyMasterToPlaylists -PlaylistType "WPL" -MasterPlaylistPath $MasterPlaylistPath -PrintStatus
	CopyMasterToPlaylists -PlaylistType "ZPL" -MasterPlaylistPath $MasterPlaylistPath -PrintStatus
	CopyMasterToPlaylists -PlaylistType "PLS" -MasterPlaylistPath $MasterPlaylistPath -PrintStatus

	If ($PrintStatus) { Write-Host; Write-Host ("CopyMastersToPlaylists Complete!") -ForegroundColor Green; Write-Host }
}

Function CopyMasterToPlaylists()
{
	Param (
		[String] $PlaylistType,
		[String] $MasterPlaylistPath,
		[Switch] $PrintStatus
	)

	If ($PrintStatus) { Write-Host; Write-Host "Copying", $PlaylistType, "MasterPlaylists to Playlists." -ForegroundColor Green; Write-Host }

	$MasterPlaylistFiles = Get-ChildItem($MasterPlayListPath + "\" + $PlaylistType + "\*." + $PlaylistType.ToLower())

	CopyFilesToDestination $MasterPlaylistFiles $PlayListPath

	If ($PrintStatus) { Write-Host; Write-Host ("CopyMasterToPlaylists Complete!") -ForegroundColor Green; Write-Host }
}

Function CreateCleanPlayListFiles()
{
	Param (
		[Switch] $PrintStatus,
		[Switch] $Relative
	)

	If ($PrintStatus) { Write-Host; Write-Host "Creating Clean Playlists." -ForegroundColor Green; Write-Host }

	$Files = Get-ChildItem(($PlayListPath + "\*.wpl"))
	ForEach ($File In $Files)
	{
		Write-Host $File.FullName.Replace(".wpl",".clean")
		If ($Relative) 
		{ 
			$FilePath = CreateCleanPlayList -FilePath $File.FullName -RelativePaths 
		}
		Else 
		{ 
			$FilePath = CreateCleanPlayList -FilePath $File.FullName 
		}

		If (!(Test-Path $FilePath )) { Write-Host ("File not found:" + $FilePath) -ForegroundColor Red }
	}

	If ($PrintStatus) { Write-Host; Write-Host ("CreateCleanPlayListFiles Complete!") -ForegroundColor Green; Write-Host }
}

Function CreateCleanPlayList()
{
	Param (
		[String] $FilePath, 
		[Switch] $PrintStatus,
		[Switch] $RelativePaths
	)

	If ($PrintStatus) { Write-Host; Write-Host "Creating Clean Playlist." -ForegroundColor Green; Write-Host }

	If ($FilePath)
	{
		$CleanFilePath = RemovePlayListInfo $FilePath ($FilePath.Replace(".wpl", ".clean"))
	}
	Else
	{
		Write-Warning "Verify file location for: [$FilePath]"
	}

	If ($PrintStatus) { Write-Host; Write-Host ("CreateCleanPlayList Complete!") -ForegroundColor Green; Write-Host }

	If ($CaughtException) { Write-Host }

	Return $CleanFilePath
}

Function CreatePowerDVDPlayListFiles()
{
	Param (
		[Switch] $PrintStatus,
		[Switch] $Relative
	)

	[String] $FilePath = [String]::Empty

	If ($PrintStatus) { Write-Host; Write-Host "Creating PowerDVD Playlists." -ForegroundColor Green; Write-Host }

	$PLSFiles = Get-ChildItem(($PlayListPath + "\*.pls"))
	If($PLSFiles.Length -gt 0)
	{
		RemoveFiles ($PLSFiles)
	}

	$Files = Get-ChildItem(($PlayListPath + "\*.clean"))
	ForEach ($File In $Files)
	{
		Write-Host $File.FullName.Replace(".clean",".pls")
		If ($Relative) 
		{ 
			$FilePath = (CreatePowerDVDPlayList -FilePath $File.FullName -RelativePaths )
		}
		Else 
		{ 
			$FilePath = (CreatePowerDVDPlayList -FilePath $File.FullName )
		}

		If (!(Test-Path $FilePath)) { Write-Host ("File not found:" + $FilePath) -ForegroundColor Red }
	}

	If ($PrintStatus) { Write-Host; Write-Host ("CreatePowerDVDPlayListFiles Complete!") -ForegroundColor Green; Write-Host }

}

Function CreatePowerDVDPlayList()
{
	Param (
		[String] $FilePath, 
		[Switch] $PrintStatus,
		[Switch] $RelativePaths
	)

	If ($PrintStatus) { Write-Host; Write-Host "Creating PowerDVD Playlist." -ForegroundColor Green; Write-Host }

	[Long] $LineCount = 0

	$PLSFilePath = $FilePath.Replace(".clean", ".pls")

	$FileContent = Get-Content $FilePath
	ForEach($Line In $FileContent)
	{
		$NewLine = $Line
		$WriteToFile = $false

		If ($NewLine.Contains("<?wpl version=""1.0""?>"))
		{
			$NewLine = $NewLine.Replace("<?wpl version=""1.0""?>", "[playlist]")
			$NewLine = $NewLine.Replace("  ", "")
			$WriteToFile = $true
		}
		If ($NewLine.Contains("<media src=""") -or $NewLine.Contains(""" />"))
		{
			$NewLine = $NewLine.Replace("<media src=""", "")
			$NewLine = $NewLine.Replace(""" />", "")
			$NewLine = $NewLine.Replace("  ", "")
			$WriteToFile = $true
			$LineCount+=1
		}
		
		If ($WriteToFile) { Write-ToFile $PLSFilePath $NewLine }

		Write-Host "." -NoNewline
	}

	Write-Host; Write-Host "$LineCount Tracks."; Write-Host

	If ($PrintStatus) { Write-Host; Write-Host ("CreatePowerDVDPlayList Complete!") -ForegroundColor Green; Write-Host }

	If ($CaughtException) { Write-Host }

	Return $PLSFilePath
}

# Clean the file
Function RemovePlayListInfo ([String] $FilePath, [String] $CleanFilePath)
{
	If ($PrintStatus) { Write-Host; Write-Host "Removing Playlists Info." -ForegroundColor Green; Write-Host }

	[Long] $LineCount = 0

	[String] $LiteralMediaSrc = [String]::Format("<media src=`"{0}\", ($MusicPath))
	[String] $RelativeMediaSrc = "<media src=`"..\"

	If (Test-Path $CleanFilePath) 
	{
		New-Item -Type File -Path $CleanFilePath -Force; Write-Host 
	}

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
				$LineCount+=1
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

			Write-Host "." -NoNewline
		}
	}
	
	Write-Host; Write-Host "$LineCount Tracks."; Write-Host

	If ($PrintStatus) { Write-Host; Write-Host ("RemovePlayListInfo Complete!") -ForegroundColor Green; Write-Host }

	Return $CleanFilePath
}

Function ReplacePlWithCleanPl()
{
	Param (
		[Switch] $PrintStatus
	)

	If ($PrintStatus) { Write-Host; Write-Host "Replacing Dirty Playlists with Clean Playlists." -ForegroundColor Green; Write-Host }

	RemoveFiles (Get-ChildItem(($PlayListPath + "\*.wpl")))
	RemoveFiles (Get-ChildItem(($PlayListPath + "\*.zpl")))
	RemoveFiles (Get-ChildItem(($PlayListPath + "\*.pls")))

	$Files = Get-ChildItem(($PlayListPath + "\*.clean"))
	ForEach ($File In $Files)
	{
		# Create WPL
		$CleanWPL = $File.FullName.Replace(".clean",".wpl")
		Copy-Item -Path $File -Destination $CleanWPL -Force
		Write-Host $CleanWPL

		# Create ZPL
		$FileContent = Get-Content $File
		$FileContent = $FileContent.Replace("<?wpl version=""1.0""?>", "<?zpl version=""2.0""?>")
		$CleanZPL = $File.FullName.Replace(".clean",".zpl")
		Set-Content -Path $CleanZPL -Value $FileContent -Force
		Write-Host $CleanZPL
	}
	Write-Host

	# Create PLS
	CreatePowerDVDPlayListFiles -PrintStatus

	# Cleanup
	RemoveBakClean -Bak -Clean -PrintStatus

	If ($PrintStatus) { Write-Host; Write-Host ("ReplacePlWithCleanPl Complete!") -ForegroundColor Green; Write-Host }
}

Function RemoveBakClean()
{
	Param (
		[Switch] $Bak,
		[Switch] $PrintStatus,
		[Switch] $Clean
	)

	If  ($Bak)
	{
		$BakFiles = Get-ChildItem(($PlayListPath + "\*.bak"))
		If ($BakFiles.Length -gt 0)
		{
			If ($PrintStatus) { Write-Host; Write-Host "Removing .bak files." -ForegroundColor Green; Write-Host }
			RemoveFiles -Files $BakFiles
		}
	}

	If  ($Clean)
	{
		$CleanFiles = Get-ChildItem(($PlayListPath + "\*.clean"))
		If ($CleanFiles.Length -gt 0)
		{
			If ($PrintStatus) { Write-Host; Write-Host "Removing .clean files." -ForegroundColor Green; Write-Host }
			RemoveFiles -Files $CleanFiles
		}
	}

	If ($PrintStatus) { Write-Host; Write-Host ("RemoveBakClean Complete!") -ForegroundColor Green; Write-Host }
}

Function SetMusicFolderInFiles()
{
	Param (
		#[String] $MusicPath,
		#[String] $PlayListPath,
		[String] $OldMusicPath,
		[Switch] $PrintStatus,
		[Switch] $Relative
	)

	If ($PrintStatus) { Write-Host; Write-Host "Setting music folder in files." -ForegroundColor Green; Write-Host }

	#If ($Drive) { $MusicPath = ($Drive + "\Music") }
	#Else { ("M:\Music") }

	$WPLFiles = Get-ChildItem ($PlayListPath + "\*.wpl")
	ForEach ($File In $WPLFiles)
	{
		Write-Host $File.FullName
        If ($Relative)
    	{
		    SetMusicFolder -FilePath $File.FullName -MusicPath $MusicPath -OldMusicPath $OldMusicPath -Relative
        }
        Else
        {
		    SetMusicFolder -FilePath $File.FullName -MusicPath $MusicPath -OldMusicPath $OldMusicPath 
        }
	}

	$ZPLFiles = Get-ChildItem ($PlayListPath + "\*.zpl")
	ForEach ($File In $ZPLFiles)
	{
		Write-Host $File.FullName
        If ($Relative)
    	{
    		SetMusicFolder -FilePath $File.FullName -MusicPath $MusicPath -OldMusicPath $OldMusicPath -Relative
        }
        Else
        {
    		SetMusicFolder -FilePath $File.FullName -MusicPath $MusicPath -OldMusicPath $OldMusicPath 
        }
	}

	If ($PrintStatus) { Write-Host; Write-Host ("SetMusicFolderInFiles Complete!") -ForegroundColor Green; Write-Host }
}

Function SetMusicFolder()
{
	Param (
		[String] $FilePath, 
		#[String] $MusicPath,
		[String] $OldMusicPath,
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
		$Global:SearchPath = $LiteralPath
		$Global:ReplacePath = $RelativePath
	}
	Else
	{
		$Global:SearchPath = $RelativePath
		$Global:ReplacePath = $LiteralPath
	}

    If ($OldMusicPath.Length -gt 0)
    {
		$Global:SearchPath = [String]::Format("<media src=`"{0}\", ($OldMusicPath))
    }

	If ($FilePath)
	{
		$BackupFilePath = BackupFile $FilePath
		ReCreateEmptyFile $FilePath
		SetMusicFolderPath $BackupFilePath $FilePath
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

	#$Global:MusicDrive = "M:"
	#$Global:MusicPath = $MusicDrive + "\Music"
	#$Global:PlayListPath = $MusicPath + ("\Playlists")

	#cd $PlayListScripts

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

	#$Global:MusicDrive = "M:"
	#$Global:MusicPath = $MusicDrive + "\Music"
	#$Global:PlayListPath = $MusicPath + ("\Playlists")

	#cd $PlayListScripts

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

Function CopyWplToPls()
{
	Param (
		[String] $PlayListScripts,
		[Switch] $PrintStatus
	)

	$WplFiles = Get-ChildItem(($PlayListPath + "\*.wpl"))

	If ($PrintStatus) { Write-Host; Write-Host ("Copying Wpl To Pls.") -ForegroundColor Green; Write-Host }
	
	ForEach ($File In $WplFiles)
	{
		$DestinationPath = (Split-Path $File -Parent)
		$SourceFile = (Split-Path $File -Leaf)
		$SourceFileName = $SourceFile.Split(".")[0]
	
		$DestinationFile = ($DestinationPath + "\" + $SourceFileName + ".pls")
	
		CreatePLSFile $File $DestinationFile
	}
	
	If ($PrintStatus) { Write-Host; Write-Host ($ScriptPath["Name"] + " Complete!") -ForegroundColor Green; Write-Host }
	
}

# Create PLS file
Function CreatePLSFile ([String] $SourceFilePath, [String] $DestinationFilePath)
{
    $FileContent = Get-Content $SourceFilePath
    ForEach($Line In $FileContent)
    {
        If ($Line -eq ("<?wpl version=""1.0""?>"))
        {
            Write-ToFile $DestinationFilePath ("[playlist]")
        }

        If ($Line.Contains("<media src="))
        {
            Write-ToFile $DestinationFilePath $Line.Replace("<media src=", "").Replace("/>", "").Replace("""", "").Replace("  ", " ").Trim()
        }
    }
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
