.TITLE
  CCDC Builder

.SYNOPSIS
  Create randomized, virtual networks on the fly for safe red vs. blue environments. 

.DESCRIPTION
  This is a program to automate the creation of virtual networks on the Cyber Security Club at UVU's ESXi server. This is with the intention to give the CCDC team a safe environment to practice blue teaming, while also giving club members a chance to try red teaming during special events. 

.PARAMETER :mandatory:<address>
  The ip address or fqdn of the vCenter server to connect to.
.PARAMETER <difficulty>
  The difficulty setting desired, from 1-5. Higher numbers create more difficult scenarios.
.PARAMETER <teams>
  The number of identical networks to create.

.INPUTS
  Username: The username to log into the server.
  Password: The password for the user to log into the server.

.OUTPUTS
  Prints to screen the status of current steps towards completing the task. 
  
.NOTES
  Version:        1.0
  Author:         Christopher Hallstrom
  Creation Date:  November 17, 2018
  Purpose/Change: Initial script development
  
.EXAMPLE
  ./CCDCBuilder.ps1 -address 192.168.0.10 -difficulty 2 -teams 1