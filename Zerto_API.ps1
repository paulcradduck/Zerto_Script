#Adding PowerCLI Snap-in
Add-PSSnapin VMware.VimAutomation.Core

#Defining Variables
$ZertoServer = ""
$ZertoPort = "9669"
$ZertoUser = ""
$ZertoPassword = ""
$vCenterServer = ""
$vCenterUser = ""
$vCenterPassword = ""
$CurrentDate = Get-Date
$CurrentDate = $CurrentDate.ToString('MM-dd-yyyy')

function LoadSnapin{
param($PSSnapinName)
if (!(Get-PSSnapin | where {$_.Name   -eq $PSSnapinName})){
Add-pssnapin -name $PSSnapinName
}
}
# Loading snapins and modules
LoadSnapin -PSSnapinName   "VMware.VimAutomation.Core"
# Connecting to the vCenter
connect-viserver -Server $vCenterServer

# Building Zerto API string and invoking API
$baseURL = "https://" + $ZertoServer + ":"+$ZertoPort+"/v1/"
# Authenticating with Zerto APIs
$xZertoSessionURI = $baseURL + "session/add"
$authInfo = ("{0}:{1}" -f $ZertoUser,$ZertoPassword)
$authInfo = [System.Text.Encoding]::UTF8.GetBytes($authInfo)
$authInfo = [System.Convert]::ToBase64String($authInfo)
$headers = @{Authorization=("Basic {0}" -f $authInfo)}
$sessionBody = '{"AuthenticationMethod": "1"}'
$contentType = "application/json"
$xZertoSessionResponse = Invoke-WebRequest -Uri $xZertoSessionURI -Headers $headers -Method POST -Body $sessionBody -ContentType $contentType
# Extracting x-zerto-session from the response, and adding it to the actual API
$xZertoSession = $xZertoSessionResponse.headers.get_item("x-zerto-session")
$zertSessionHeader = @{"x-zerto-session"=$xZertoSession}

# Get Local Site Status
$LocalSiteInfoURL = $BaseURL+"localsite"
$LocalSiteInfoCMD = Invoke-RestMethod -Uri $LocalSiteInfoURL -TimeoutSec 100 -Headers $zertSessionHeader -ContentType "application/JSON"
$LocalSiteInfoCMD

# Get Peer Site Status
$PeerSiteInfoURL = $BaseURL+"peersites"
$PeerSiteInfoCMD = Invoke-RestMethod -Uri $PeerSiteInfoURL -TimeoutSec 100 -Headers $zertSessionHeader -ContentType "application/JSON"
$PeerSiteInfo = $PeerSiteInfoCMD | Select *
$PeerSiteInfo

# Get Protected VMs List
$ProtectedVMsURL = $BaseURL+"vms"
$ProtectedVMsCMD = Invoke-RestMethod -Uri $ProtectedVMsURL -TimeoutSec 100 -Headers $zertSessionHeader -ContentType "application/JSON"
$ProtectedVMs = $ProtectedVMsCMD | Select *
$ProtectedVMs

# Get Virtual Protection Group List
$VPGsURL = $BaseURL+"vpgs"
$VPGsCMD = Invoke-RestMethod -Uri $VPGsURL -TimeoutSec 100 -Headers $zertSessionHeader -ContentType "application/JSON"
$VPGs = $VPGsCMD | Select *
$VPGs

# Get VRA List
$VRAsURL = $BaseURL+"vras"
$VRAsCMD = Invoke-RestMethod -Uri $VRAsURL -TimeoutSec 100 -Headers $zertSessionHeader -ContentType "application/JSON"
$VRAs = $VRAsCMD | Select *
$VRAs


#####################################################################

