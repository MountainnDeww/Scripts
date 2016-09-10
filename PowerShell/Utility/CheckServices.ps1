# Check the TE and ETW services

Function RestartServices
{
    RestartService "Te.Service"
    RestartService "Etw.Service"
}

Function StopServices
{
    StopService "Te.Service"
    StopService "Etw.Service"
}

Function StartServices
{
    StartService "Te.Service"
    StartService "Etw.Service"
}

Function VerifyServiceStates ([Int32] $ServiceState)
{
    VerifyServiceState "Te.Service" $ServiceState
    VerifyServiceState "Etw.Service" $ServiceState
}

Function CheckServiceStates ([Int32] $ServiceState)
{
    CheckServiceState "Te.Service" $ServiceState
    CheckServiceState "Etw.Service" $ServiceState
}

Function RestartService ([String] $ServiceName)
{
    Write-Host; Write-Host "Restarting $ServiceName ..."

    $Service = Get-Service -Name $ServiceName -ErrorAction SilentlyContinue

    If ($Null -ne $Service )
    {
        Restart-Service $Service

        $Service.WaitForStatus($ServiceState_Running, 30)

        VerifyServiceState $ServiceName $ServiceState_Running
    }
}

Function StopService ([String] $ServiceName)
{
    Write-Host; Write-Host "Stopping $ServiceName ..."

    $Service = Get-Service -Name $ServiceName -ErrorAction SilentlyContinue

    If ($Null -ne $Service )
    {
        If ($Service.Status -eq $ServiceState_Running -and $Service.CanStop)
        {
            $Service.Stop()
            $Service.WaitForStatus($ServiceState_Stopped, 30)
        }
        VerifyServiceState $ServiceName $ServiceState_Stopped
    }
}

Function StartService ([String] $ServiceName)
{
    Write-Host; Write-Host "Starting $ServiceName ..."

    $Service = Get-Service -Name $ServiceName -ErrorAction SilentlyContinue

    If ($Null -ne $Service )
    {
        If ($Service.Status -eq $ServiceState_Stopped)
        {
            $Service.Start()
            $Service.WaitForStatus($ServiceState_Running, 30)
        }
        VerifyServiceState $ServiceName $ServiceState_Running
    }
}

Function VerifyServiceState ([String]$ServiceName, [Int32]$ServiceState)
{
    $Service = Get-Service -Name $ServiceName -ErrorAction SilentlyContinue
    
    If ($Null -ne $Service )
    {
        If ($Service.Status -ne $ServiceState)
        {
            $Service.WaitForStatus($ServiceState, 30)
        }

        $ServiceStatus = $ServiceName + ": " + $Service.Status
        If ($Service.Status -ne $ServiceState)
        {
            Write-Error $ServiceStatus
        }
        Else
        {
            Write-Host $ServiceStatus
        }
    }
}

Function CheckServiceState ([String]$ServiceName)
{
    $Service = Get-Service -Name $ServiceName -ErrorAction SilentlyContinue
    
    If ($Null -ne $Service )
    {
        $ServiceStatus = $ServiceName + ": " + $Service.Status
        Write-Host $ServiceStatus
    }
}

$ServiceState_Stopped = 1
$ServiceState_Running = 4

If ($Args.Count) { $ServiceCommand = $Args[0] } Else { $ServiceCommand = ""}

Switch($ServiceCommand.ToString().ToLower())
{
    "start" { StartServices }
    "stop" { StopServices }
    "restart" { RestartServices }
    default { CheckServiceStates }
}

Write-Host