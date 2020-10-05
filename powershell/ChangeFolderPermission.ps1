function DisableInheritance ([string]$Folder)
{
    Write-host "Disabling the object inheritance..."
    $acl = (Get-Item $Folder).GetAccessControl('Access')
    $acl.SetAccessRuleProtection($true,$true)
    Set-Acl -Path $Folder -AclObject $acl -ErrorVariable err
    if ($err)
    {
        Write-Warning "Failed to disable the inheritance on $Folder , exiting the script"
        Write-Warning "$err"
        exit 1
    }
    else
    {
        write-host "Successfully disabled the inheritance on $Folder"
    }
}

function AddPermission ([string]$Folder,[string]$User,[string]$Permission)
{
    # https://technet.microsoft.com/en-us/library/ff730951.aspx
    
    $acl = (Get-Item $Folder).GetAccessControl('Access')
       
    $objuser = New-Object System.Security.Principal.NTAccount($User)
    $colRights = [System.Security.AccessControl.FileSystemRights]$permission
    $InheritanceFlag = [System.Security.AccessControl.InheritanceFlags]::"ObjectInherit","ContainerInherit" 
    $PropagationFlag = [System.Security.AccessControl.PropagationFlags]::None
    $objType = [System.Security.AccessControl.AccessControlType]::Allow 

    $objACE = new-object System.Security.AccessControl.FileSystemAccessRule ($objuser, $colRights, $InheritanceFlag, $PropagationFlag, $objType)
    
    Write-Verbose "Updating the ACL Object"
    Try
    {
        $acl.SetAccessRule($objACE)    
    }
    Catch
    {
        $err = $_.Exception.Message
        Write-Warning "Failed to update the ACL object, exiting the script"
        Write-Warning "$err"
        Exit 1
    }

    write-host "Granting $User $Permission permission on $Folder"
    Set-Acl -Path $Folder -AclObject $acl -ErrorVariable err
    if ($err)
    {
        Write-Warning "Failed to grant $User $Permission permission on $Folder , exiting the script"
        Write-Warning "$err"
        exit 1
    }
    else
    {
        write-host "Successfully granted $User $Permission permission on $Folder"
    }
}