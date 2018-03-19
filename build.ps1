$workflow_name = $Env:WorkflowName

function Run-WorkflowID([string]$workflow_id)
{    
udstask chworkflow -disable false $workflow_id    
udstask runworkflow $workflow_id    
udstask chworkflow -disable true $workflow_id
}

function Get-WorkflowID([string]$workflow_name)
{    
$workflow_id = $(udsinfo lsworkflow | where-object name -eq $workflow_name).id    
if (! $workflow_id ) {        
return 0;    
} else {        
return $workflow_id    
}    
}

$acthost = "172.24.1.180"
$actuser = "jenkin01"
$pwfile = "c:\temp\jenkin01.key"
 
$env:IGNOREACTCERTS = $true
 
"password" | ConvertTo-SecureString -AsPlainText -Force | ConvertFrom-SecureString | Out-File $pwfile
 
if (! $env:ACTSESSIONID ){
  Connect-Act -acthost $acthost -actuser $actuser -passwordfile $pwfile -ignorecerts -quiet
}

$src_wflow_id = Get-WorkflowID $workflow_name
write-output "Workflow $workflow_name ID is $src_wflow_id`n"

Run-WorkflowID $src_wflow_id

 if (! $env:ACTSESSIONID ){
   write-warning "Login to CDS $acthost failed"
   break
 }
 else {
   Disconnect-Act | Out-Null
 } 
