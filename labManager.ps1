# VMware vCenter manager
# Uses PowerCLI 6.3R1
# Deploy from template, start, stop, restart and see IP addresses
# Uses your user's credentials to login to vCenter

# Depending on your SSL cert, you may want to run the following command: 
# Set-PowerCLIConfiguration -InvalidCertificateAction Ignore -WarningAction SilentlyContinue

Add-PSSnapin VMware.VimAutomation.Core
$vCenter = "192.168.1.1" # Change to the IP your server



$server = Connect-VIServer $vCenter

write-host "Connected to: $server"

function list-option {
	
	$userOption = read-host -prompt "Please enter the number of your desired option"

	# deploy new vm from template
	if ($userOption -eq "1") {
	deployFromTemplate
	}

	# start vm
	elseif ($userOption -eq "2") {
	startVM
	}

	# stop vm
	elseif ($userOption -eq "3") {
	stopVM
	}

	# restart vm
	elseif ($userOption -eq "4") {
	restartVM
	}

	# list IPs
	elseif ($userOption -eq "5") {
	listIPs
	}

	# exit
	elseif ($userOption -eq "6") {
	Disconnect-VIServer -Server $Server
	exit
	}

	else {
	Write-Host "Invalid selection, returning to menu."
	sleep 2
	menu
	}

} # end of the list-option function

function deployFromTemplate {
	Get-Template | Format-Table
	$temp = read-host -prompt "Enter the name of the template you wish to deploy"
	$vmName = read-host -prompt "Enter the name of your new VM"
	write-host ""
	Get-VMHost | Format-Table
	$esxHost= read-host -prompt "Enter the name of the host you wish to deploy this VM on"
	New-VM -Name $vmName -Template $temp -Host $esxHost -RunAsync
	Start-VM $vmName | Format-Table
	menu
	
}

function startVM {
	Get-VM | where {$_.powerstate -eq “PoweredOff”} | Format-Table
	$vmToStart = read-host -prompt "Enter the name of the VM you wish to start"
	Start-VM $vmToStart
	menu
}

function stopVM {
	Get-VM | where {$_.powerstate -eq “PoweredOn”} | Format-Table
	$vmToStop = read-host -prompt "Enter the name of the VM you wish to stop"
	Stop-VM $vmToStop
	menu
	
}

function restartVM {
	Get-VM | where {$_.powerstate -eq “PoweredOn”} | Format-Table
	$vmToRestart = read-host -prompt "Enter the name of the VM you wish to restart"
	Restart-VM $vmToRestart
	menu
}

function listIPs {
	Get-VM | Select Name, @{N="IP Address";E={@($_.guest.IPAddress[0])}} | Format-Table
	sleep 3
	menu
}

function menu {
	
	write-host ""
	write-host "1) Deploy new VM from template"
	write-host "2) Start VM"
	write-host "3) Stop VM"
	write-host "4) Restart VM"
	write-host "5) List IP addresses"
	write-host "6) Exit"
	list-option
}

menu