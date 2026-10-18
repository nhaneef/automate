#----------------------------------------------------------------------#
Connect-MgGraph -Scopes "RoleManagement.ReadWrite.Directory"
$eligibleroles=Get-MgRoleManagementDirectoryRoleEligibilityScheduleInstance -Filter "principalId eq 'e9797ee8-5452-4aaf-aa05-efc189744cc7'"
$ids = $eligibleroles | ForEach-Object { $_.RoleDefinitionId }
#$roledefinitionids = import-csv -path .\ActivateEntraRole.csv
#$roledefinitionids = Get-MgRoleManagementDirectoryRoleDefinition
#$roles=Get-MgRoleManagementDirectoryRoleDefinition -role
foreach ($id in $ids){
$params = @{
    "PrincipalId" = "e9797ee8-5452-4aaf-aa05-efc189744cc7"
    "RoleDefinitionId" = "$id"
    "Justification" = "Daily Operations"
    "DirectoryScopeId" = "/"
    "Action" = "SelfActivate"
    "ScheduleInfo" = @{
      "StartDateTime" = Get-Date
      "Expiration" = @{
         "Type" = "AfterDuration"
         "Duration" = "PT8H"
        
       }
      }
}

  New-MgRoleManagementDirectoryRoleAssignmentScheduleRequest -BodyParameter $params |
    Format-List Id, Status, Action, AppScopeId, DirectoryScopeId, RoleDefinitionID, IsValidationOnly, Justification, PrincipalId, CompletedDateTime, CreatedDateTime, TargetScheduleID
}