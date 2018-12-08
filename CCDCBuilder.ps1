param (
	[Parameter(Mandatory=$true)][string]$address,
	[string]$difficulty = 1,
	[string]$teams = 1,
	[string]$filename,
	[switch]$help
)


function printHelp { 
  if($server) {Disconnect-VIServer -Server $server -confirm:$false -force}
	write-host "CCDC Builder, an automated practice environment generator"
  write-host "Usage: CCDCBuilder.ps1 -address <ip/fqdn> [-difficulty <1-5>] [-teams <1+>] [-filename <filename>]"
  write-host "    address     The ip/fqdn of the vCenter server to connect to."
  write-host "    difficulty  The difficulty setting desired, from 1-5. Default is 1."
  write-host "                Higher numbers create more difficult scenarios."
  write-host "    teams       The number of identical networks to create. Must be 1 or more. Default is 1."
  write-host "                Remember difficult networks will be large, and creating several will require capable hardware."
  write-host "    filename    The filepath\filename.csv to export configurations to."
  write-host "                Default is to not export data."
  write-host "    help        Print this help menu and exit."
  write-host ""
  write-host "example:"
  write-host "./CCDCBuilder.ps1 -address 192.168.0.10 -difficulty 2 -teams 3 -filename export.csv"
  write-host ""
  write-host -NoNewline "Press Enter to exit..."
  read-host
  exit 1
}

trap {"$_"; exit 1;}
$ErrorActionPreference = "Stop"



####  	Print usage   ####
if($help) {printHelp}

####	Verify Powershell version	####
$PSVersionMajor = ($PSVersionTable.PSVersion | sort-object major | ForEach-Object     {$_.major})
$PSVersionMinor = ($PSVersionTable.PSVersion | sort-object minor | ForEach-Object     {$_.minor})
if (-NOT $PSVersionMajor -ge 3) {
    write-host "You are running Powershell $PSVersionMajor.$PSVersionMinor. You must run v3.x or greater to run this command."
    write-host -NoNewline "Press Enter to exit..."
    read-host
    exit 1
}

####	Get PowerCLI if not already installed	####
if ((get-module -listavailable -name vmware.powercli | foreach-object {$_.name}) -ne "VMWare.PowerCLI") {
    $user = [Security.Principal.WindowsIdentity]::GetCurrent();
    if ((New-Object Security.Principal.WindowsPrincipal $user).IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator)) {
    	write-host "Installing PowerCLI and required modules..."
        $error = install-module -Force -SkipPublisherCheck vmware.powercli #from powershellgallery
        if ($error -ne $null) {
            write-host "Failed to install module `"VMWare.PowerCLI`". Please install manually."
            write-host -NoNewline "Press Enter to exit..."
            read-host
            exit 1
        }
        else {
        	write-host "Install Successful"
        }
    } else {
        write-host "Please run as Administrator to install the VMWare.PowerCLI module, or install it manually."
        write-host -NoNewline "Press Enter to exit..."
        read-host
        exit 1
    }
}

####	Connect to Server	####
$username = $( Read-Host "Input username" )
$password = $( Read-Host -asSecureString "Input password" )
$credentials = New-Object System.Management.Automation.PSCredential -ArgumentList $username, $password
write-host "Connecting to $address"
$server = Connect-VIServer -Server $address -credential $credentials -force 
write-host "Connected successfully"


####  	Configure network   ####
<#switch ($difficulty) {
	1 {
    write-host "Configuring for difficulty 1"
    write-host "WORK IN PROGRESS"
	}
	2 {
    write-host "Configuring for difficulty 2"
    write-host "WORK IN PROGRESS"
	}
	3 {
    write-host "Configuring for difficulty 3"
    write-host "WORK IN PROGRESS"
	}
	4 {
    write-host "Configuring for difficulty 4"
    write-host "WORK IN PROGRESS"
	}
	5 {
    write-host "Configuring for difficulty 5"
    write-host "WORK IN PROGRESS"
	}
	default { printHelp }
}


####	Build the networks   ####
For ($i=1; $i -le $teams; $i++) {
  write-host "Building network for team $i"
}#>


####  POC 	####
write-host "Configuring for POC"
$workstation_templates = Get-Template -Name Ubuntu* -Server $server -Datastore "Small Storage" #-Location "Templates/"
$workstation_template = $workstation_templates[0]	# $workstation_templates[(Get-Random -Maximum ([array]$workstation_templates).count)]
$workstation_vm = New-VM -Template $workstation_template -Server $server -Datastore "BigBubba" -Name "Workstation"
Start-VM -VM $workstation_vm
write-host "Workstation started"


####  Disconnect from Server  ####
write-host "Disconnecting from $address"
Disconnect-VIServer -Server $server -confirm:$false -force


####  Report what was created   ####
if ($filename) {
  write-host "Configurations have been exported to $filename"
}