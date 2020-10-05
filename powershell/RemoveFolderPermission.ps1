function RemovePermission ([string]$Folder,[string]$User)
{
    # https://technet.microsoft.com/en-us/library/ff730951.aspx

    $acl = (Get-Item $Folder).GetAccessControl('Access')

    Write-host "Removing permission for $User"
    $objuser = New-Object System.Security.Principal.NTAccount($User)
    $colRights = [System.Security.AccessControl.FileSystemRights]"FullControl"
    $InheritanceFlag = [System.Security.AccessControl.InheritanceFlags]::"ObjectInherit","ContainerInherit" 
    $PropagationFlag = [System.Security.AccessControl.PropagationFlags]::None
    $objType = [System.Security.AccessControl.AccessControlType]::Allow 

    $objACE = new-object System.Security.AccessControl.FileSystemAccessRule ($objuser, $colRights, $InheritanceFlag, $PropagationFlag, $objType)    
    
    Write-Verbose "Updating the ACL Object"
    Try
    {
        $acl.RemoveAccessRuleAll($objACE)    
    }
    Catch
    {
        $err = $_.Exception.Message
        Write-Warning "Failed to update the ACL object, exiting the script"
        Write-Warning "$err"
        Exit 1
    }
    Set-Acl -path $Folder $acl -ErrorVariable err
    if ($err)
    {
        Write-Warning "Failed to remove $User permission from $Folder, exiting the script"
        Write-Warning "$err"
        Exit 1
    }
    else 
    {
        Write-host "Successfully removed $User permission from $Folder"    
    }
}