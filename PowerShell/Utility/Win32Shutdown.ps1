#Logout
(Get-WmiObject -Class Win32_OperatingSystem -ComputerName .).Win32Shutdown(0)
#Shutdown
(Get-WmiObject -Class Win32_OperatingSystem -ComputerName .).Win32Shutdown(1)
#Reboot
(Get-WmiObject -Class Win32_OperatingSystem -ComputerName .).Win32Shutdown(2)
