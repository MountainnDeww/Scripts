#function Select-Folder($message='Select the VS source cache folder', $path = $env:windir) {  
function Select-Folder($message='Select the VS source cache folder') {  
    $object = New-Object -comObject Shell.Application   
    # $folder = $object.BrowseForFolder(0, $message, 0, $path)  
    $folder = $object.BrowseForFolder(0, $message, 0)   # Shows the desktop root, as desired
    if ($folder -ne $null) {  
        $folder.self.Path  
    }  
}

function CreateDirectoryIfNeeded ( [string] $directory )
{
	if ( ! ( Test-Path $directory -type "Container" ) )
	{
		New-Item -type directory -Path $directory > $null
	}
}

function Set-VS-Source-Cache-Folder($message='Select the VS source cache folder') {  
	$selectedFolder = Select-Folder($message)
	$vs2010DebuggerPath = "HKCU:\Software\Microsoft\VisualStudio\10.0\Debugger\"
	$sourceServExtractTo = "SourceServerExtractToDirectory"
	$currentCacheFolder = (Get-ItemProperty $vs2010DebuggerPath).$sourceServExtractTo
	Write "The old VS source cache folder was set to $currentCacheFolder"
	#CreateDirectoryIfNeeded $selectedFolder
	Set-ItemProperty -path $vs2010DebuggerPath -name $sourceServExtractTo -value $selectedFolder
	Write "The new VS source cache folder is $selectedFolder"
}

Set-VS-Source-Cache-Folder