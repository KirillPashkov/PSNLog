#[void][System.Reflection.Assembly]::LoadFile("$PSHOME\Modules\PK-NLog\lib\NLog.dll")
[void][System.Reflection.Assembly]::LoadFile("$env:USERPROFILE\Documents\WindowsPowerShell\Modules\PK-Log\lib\NLog.dll")

function Get-NewLogger {
param( 
[Parameter(Mandatory=$true)] 
[String]$loggerName 
) 
[NLog.LogManager]::GetLogger($loggerName) 
}

function Get-NewLogConfig {
New-Object NLog.Config.LoggingConfiguration 
}

function Get-NewLogTarget {
param( 
[Parameter(Mandatory=$true)] 
[ValidateSet('console','file','mail')]
[String]$targetType 
) 
	switch ($targetType) {
		"console" {
			New-Object NLog.Targets.ColoredConsoleTarget	
		}
		"file" {
			New-Object NLog.Targets.FileTarget
		}
		"mail" { 
			New-Object NLog.Targets.MailTarget
		}
	}
}

function Get-LogMessageLayout {
param(
[Parameter(Mandatory=$true)] 
[Int]$layoutId 
 ) 
	switch ($layoutId) {
		1 {
			$layout	= '${longdate} | ${machinename} | ${processid} | ${processname} | ${level} | ${logger} | ${message}'
		}
		default {
			$layout	= '${longdate} | ${machinename} | ${processid} | ${processname} | ${level} | ${logger} | ${message}'
		}
	}
	return $layout
}

Export-ModuleMember -Function Get-NewLogger,
                              Get-NewLogConfig,
                              Get-NewLogTarget,
                              Get-LogMessageLayout