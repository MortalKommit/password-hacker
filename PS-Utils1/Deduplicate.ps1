Function Remove-Duplicates{
param([Parameter(Mandatory=$true,Position = 0)][ValidateNotNullOrEmpty()]$directory,
    [System.Management.Automation.SwitchParameter]$isolate,
    [System.Management.Automation.SwitchParameter]$remove,
    [System.Management.Automation.SwitchParameter]$subfolder)
if($subfolder.IsPresent){
    gci -Directory -LiteralPath "\\?\$directory" | 
    %{
        $dirhashlist = [System.Collections.Generic.Dictionary[[string],[string]]]::new()
        $dupelist = [System.Collections.ArrayList]::new()
        if(-not (Test-Path "$($_.FullName)\dupes")){
            New-Item -Path $_.FullName -ItemType Directory -Name "dupes" | Out-Null
        }
        gci $_.FullName  -Recurse |
            ?{$_.PSIscontainer -eq $false
            } |
            %{
                $filehashvalue = (Get-FileHash $_).Hash
                #Add hash to Dictionary if not already present
                if(! $dirhashlist.ContainsKey($filehashvalue)){    
                    $dirhashlist.Add($filehashvalue,[System.IO.Path]::GetFullPath($_.FullName))
                }
                #Existing key = dupe
                else{
                    #Create a dupes folder and isolate
                    $dupepath = if($_.Directory.Parent.FullName -eq "\\?\$directory"){
                                    $_.DirectoryName + "\dupes\"
                                }
                                else{
                                   $_.Directory.Parent.FullName + "\dupes\"
                                }
                    Move-Item -Path $_.FullName -Destination ($dupepath) 
                    $dupelist.Add($_.FullName) | Out-Null  
                }
            }
            if($remove.IsPresent){
                Remove-Item ($_.Fullname + '\dupes') -Recurse
                Write-Host "Deduplicated $($_.FullName)"
            }
        }
}
else{
    $dirhashlist = [System.Collections.Generic.Dictionary[[string],[string]]]::new()
    $dupelist = [System.Collections.ArrayList]::new()
    gci -File -LiteralPath "\\?\$directory" -Recurse | 
    %{
        $filehashvalue = (Get-FileHash $_.FullName).Hash
        #Add hash to Dictionary if not already present
        if(! $dirhashlist.ContainsKey($filehashvalue)){    
            $dirhashlist.Add($filehashvalue,$_.FullName)
        }
        else{
            $dupelist.Add($_.FullName) | 
            %{
                Remove-Item $dupelist[$_]
                Write-Host "Removed $($dupelist[$_])"
            }
        }
    }
}
<#
gci -Directory -LiteralPath "\\?\$directory" | 
    %{ $dirhashlist = [System.Collections.Generic.Dictionary[[string],[string]]]::new()
       $dupelist = [System.Collections.ArrayList]::new()
gci -Directory -LiteralPath "\\?\$directory" 
#>
}
Remove-Duplicates -directory "H:\ripme\rips" -remove -subfolder