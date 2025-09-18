function Resolve-EnvVariable {
	param (
		[Parameter(Mandatory=$true)]
		[string]$envVarName
	)
	Write-Host -NoNewLine "Working with:" -ForegroundColor Red
	Write-Host $envVarName
	
	#$envVarValue = (Get-Item "Env:$envVarName").value
	$envVarValue = [System.Environment]::GetEnvironmentVariable($envVarName)
	if ($envVarValue) {
		Write-Host -NoNewLine "With value:" -ForegroundColor Red
		Write-Host $envVarValue
	} else {
		Write-Output -NoNewLine "ERROR 1:"
		Write-Output $nuVarValue " is not defined"
		return @{Code=-1;Value="Error " + $nuVarValue + " not defined"}
	}
	$envVars = [regex]::Matches($envVarValue, '%(\w+)%')
	if ($envVars.Count -gt 0) {
		Write-Host -NoNewLine "Having inside:"  -ForegroundColor Red
		Write-Host $envVars
	}
	foreach ($envVar in $envVars) {
		$nuVarValue = Resolve-EnvVariable($envVar.Groups[1].Value)
		if ($nuVarValue.Code -lt 0) {
			continue
		}
		Write-Host -NoNewLine "Value returned:" -ForegroundColor Red
		Write-Host $nuVarValue
		# Replacing %VAR_NAME% con var_value in envVarValue
		$envVarValue = $envVarValue.Replace("%" + $envVar.Value + "%", $nuVarValue)
	}
	
	return @{Code=0;Value=$envVarValue}
}

# Esegui la funzione
Resolve-EnvVariable("PATH")