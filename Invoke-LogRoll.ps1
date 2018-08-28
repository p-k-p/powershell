#-----------------------------------------------------------------------------#
#                                                                             #
#   Function        LogRoll                                                   #
#                                                                             #
#   Description     Roll logfiles to a specified size and logcount            #
#                                                                             #
#   Arguments       See the Param() block                                     #
#                                                                             #
#   Notes           Function checks if file $fileName is larger than          #
#                   the parameter $filesize and if it is it will roll a log   #
#                   and delete the oldest log if there are more than          #
#                   $logcount logs.                                           #
#                                                                             #
#   History                                                                   #
#                                                                             #
#   Example         LogRoll -fileName $logfile -filesize 1mb -logcount 5      #
#                                                                             #
#-----------------------------------------------------------------------------#

Function LogRoll
{ 
    param([string]$fileName, [int64]$fileSize = 128kb , [int] $logcount = 5) 
        
    if (Test-Path $fileName) 
    { 
        $file = Get-ChildItem $filename

        if ($file.length -ige $fileSize)
        { 
            $files = $file.Directory.GetFiles("$($file.Name)*") | Sort-Object -Property LastWriteTime 
             
            foreach ($i in $files.Count..1)
            {
                
                $files = $file.Directory.GetFiles("$($file.Name)*") | Sort-Object -Property LastWriteTime
                $operatingFile = $files.Where({$_.name -eq "$($file.Name).$i"})

                if ($operatingfile) {
                
                    $operatingFilenumber = $operatingFile.name.trim($fileName)
                
                } else {
                
                    $operatingFilenumber = 0
                
                }
 
                if(($operatingFilenumber -eq 0) -and ($i -ne 1) -and ($i -lt $logcount)) 
                { 
                    $operatingFilenumber = $i 
                    $operatingFile = $files.Where({$_.name -eq "$($file.Name).$($i - 1)"})

                    move-item $operatingFile.FullName -Destination "$($file.FullName).$operatingFilenumber" -Force 
                } 
                elseif($i -ge $logcount) 
                { 
                    if($operatingFilenumber -eq 0) 
                    {  
                        $operatingFilenumber = $i - 1 
                        $operatingFile = $files.Where({$_.name -eq "$($file.Name).$operatingFilenumber"}) 
                        
                    } 
                    remove-item $operatingFile.FullName -Force 
                } 
                elseif($i -eq 1) 
                { 
                    $operatingFilenumber = 1 
                    move-item $file.FullName -Destination "$($file.FullName).$operatingFilenumber" -Force 
                } 
                else 
                { 
                    $operatingFilenumber = $i + 1  
                    $operatingFile = $files.Where({$_.name -eq "$($file.Name).$($i - 1)"})
                     
                    move-item $operatingFile.FullName -Destination "$($file.FullName).$operatingFilenumber" -Force    
                } 
            } 
        } 
    }   
}