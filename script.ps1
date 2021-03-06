$fileParamGu = 'C:\Program Files (x86)\CSiD\CSiD Update\paramgu.ini'
$fileConfig = 'C:\Program Files (x86)\CSiD\CSiD Update\genserv.exe.config'

# On init la sortie d'infos
$PrintedEcho = ""

# Récupération des dates de téléchargements
if (Test-Path $fileConfig -PathType leaf) {
    $xml = [xml](Get-Content $fileConfig)

    $PrintedEcho += "scheduling updates : `r`n"
    $i = 0

    foreach ($launch in $xml.parameters.launch) {
        if($launch.argument -eq "/AUTO")
        {
            $PrintedEcho += $launch.schedule + " " + $launch.days + " a " + $launch.startTime + " -- last access : " + $launch.lastaccessed + " a " + $launch.lasttimeaccessed + "`n`r"
            $i++
        }
    }

    if($i -eq 0)
    {
        $PrintedEcho += "Aucun`r`n"
    } else {
        $PrintedEcho += "`r`n"
    }
}

# Récupération de l'heure d'installation
if (Test-Path $fileParamGu -PathType leaf) {
    # Récupération de la ligne de configuration de l'éxécution de l'updater ([UPDATE])
    $UpdateLine = Select-String -Path $fileParamGu -Pattern "\[UPDATE\]"

    # Si on a trouvé un groupe [UPDATE]
    if ($null -ne $UpdateLine) {
        # Quatrième ligne à récupérer après [UPDATE] -- StartTime
        $TimesUpdate = Get-Content $fileParamGu | Select -Index ($UpdateLine.LineNumber + 3)
        
        if ($TimesUpdate.StartsWith("StartTime")) {
            $PrintedEcho += "Time : " + $TimesUpdate.split('=')[1]
        }
    }
    else {
        $PrintedEcho += "Time : Aucun `r`n"
    }
}

echo $PrintedEcho
