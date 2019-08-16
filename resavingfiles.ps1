Set-ExecutionPolicy unrestricted
# add the required .NET assembly
Add-Type -AssemblyName System.Windows.Forms


Function Get-Folder($initialDirectory)
{
    [System.Reflection.Assembly]::LoadWithPartialName("System.windows.forms")|Out-Null

    $foldername = New-Object System.Windows.Forms.FolderBrowserDialog
    $foldername.Description = "Select a folder"
    $foldername.rootfolder = "MyComputer"

    if($foldername.ShowDialog() -eq "OK")
    {
        $folder += $foldername.SelectedPath
    }
    return $folder
}




Function Get-FileName($initialDirectory)
{
    [System.Reflection.Assembly]::LoadWithPartialName("System.windows.forms") | Out-Null
    
    $OpenFileDialog = New-Object System.Windows.Forms.OpenFileDialog
    $OpenFileDialog.initialDirectory = $initialDirectory
    $OpenFileDialog.filter = "CSV (*.csv)| *.csv"
    $OpenFileDialog.ShowDialog() | Out-Null
    $OpenFileDialog.filename
}


$inputfile = Get-FileName "C:\temp"
#$inputdata = get-content $inputfile



$a = Get-Folder

#[System.Windows.MessageBox]::Show($a)
#[System.Windows.MessageBox]::Show($inputfile)


$csv = Import-Csv $inputfile
$outfilefile = $a + "\debug.txt"
#[System.Windows.MessageBox]::Show($outfilefile)


#Start-Transcript -Path $outfilefile



foreach($item in $csv)
    {

     $fullpathOld = join-path -path $a -childpath $($item.old)
     $fullpathNew = join-path -path $a -childpath  $($item.new)


If(Test-Path $fullpathOld) { 
Write-Output $($item.old) " renamed to " $($item.new) 

#Get-ChildItem -recurse -name | ForEach-Object { Move-Item $_ $_.replace($($item.old), $($item.new)) }
# Get-ChildItem $a'\*\'  | Rename-Item -NewName {$_.name -replace $($item.old) ,$($item.new)} 

Rename-Item -Path $fullpathOld -NewName $($item.new) 
Get-ChildItem $fullpathNew'\*.*'  | Rename-Item -NewName {$_.name -replace $($item.old) ,$($item.new)}

 # ls $a'\*\*.*',$a'\*\'  | Rename-Item -NewName {$_.name -replace $($item.old) ,$($item.new)}



 
}
Else 
{
 
Write-Output $($item.old) " DOES NOT EXIST" 


 }

 }

 
#Stop-Transcript


[System.Windows.MessageBox]::Show('Done. Have a nice day!!')