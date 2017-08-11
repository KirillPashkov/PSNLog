Import-Module PK-Log

function Test-ScriptLogger {
	
	# Create a log config
	$logCfg						= Get-NewLogConfig
	
	# Configure file logging target
	$debugLog 					= Get-NewLogTarget -targetType "file"
	$debugLog.ArchiveAboveSize 	= 102400
	$debugLog.archiveEvery 		= "Month"
	$debugLog.ArchiveNumbering 	= "Rolling"	
	$debugLog.CreateDirs		= $true	
	$debugLog.FileName 			= 'C:\log\debug.log'
	$debugLog.Encoding 			= [System.Text.Encoding]::GetEncoding("UTF-8")
	$debugLog.KeepFileOpen 		= $false
	$debugLog.Layout 			= Get-LogMessageLayout -layoutId 1	
	$debugLog.maxArchiveFiles 	= 1
	
	# Add target to Log config
	$logCfg.AddTarget("file", $debugLog)
	
	# Configure a console logging target
	$console 					= Get-NewLogTarget -targetType "console"
	$console.Layout 			= Get-LogMessageLayout -layoutId 1
	
	# Add target to Log config
	$logCfg.AddTarget("console", $console)
	
	# Configure a mail logging target
	#$mailLog					= Get-NewLogTarget -targetType "mail"
	#$mailLog.SmtpServer		= "smtp.mynet.local"
	#$mailLog.From				= "scriptlogger@mynet.local"
	#$mailLog.To				= "receiver@mail.me"
	#$mailLog.Encoding 			= [System.Text.Encoding]::GetEncoding("UTF-8")
	#$mailLog.Subject			= "[NLog] MailLogger Test"
	#$mailLog.Layout			= Get-LogMessageLayout -layoutId 1
	
	
	
	<# 
	[NLog.Targets.MailTarget]$testTarget = $null
	
	$testTarget.From
	$testTarget.To
	$testTarget.SmtpServer
	$testTarget.Layout
	$testTarget.Body
	$testTarget.Name
	$testTarget.Encoding
	$testTarget.Subject
	#>
	
	
	# Configure rules for targets
	$rule1 = New-Object NLog.Config.LoggingRule("*", [NLog.LogLevel]::Trace, $console)
	$logCfg.LoggingRules.Add($rule1)
	
	$rule2 = New-Object NLog.Config.LoggingRule("*", [NLog.LogLevel]::Debug, $debugLog)
	$logCfg.LoggingRules.Add($rule2)

	# Rule to send only mail for Error messages
	#$rule3 = New-Object NLog.Config.LoggingRule("*", [NLog.LogLevel]::Error, $mailLog)
	#$logCfg.LoggingRules.Add($rule3)
	
	# Assign configured Log config to LogManager
	[NLog.LogManager]::Configuration = $logCfg
	
	# Create a new Logger
	$Log = Get-NewLogger -loggerName "TestLogger"
	
	# Write test Log messages
	$Log.Debug("Debug Message")
	$Log.Info("Info Message")
	$Log.Warn("Warn Message")
	$Log.Error("Error Message")
	$Log.Trace("Trace Message")
	$Log.Fatal("Fatal Message")
	
	$Log.Error("Error Message")
	$Log.Error("Error Message")
}

Test-ScriptLogger