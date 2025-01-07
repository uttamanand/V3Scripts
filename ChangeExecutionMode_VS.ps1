# Get the parameters from the Jenkins environment
$VirtualServiceName = $env:VirtualServiceName  # Get the VirtualServiceName from Jenkins
$ExecutionMode = $env:ExecutionMode  # Get the ExecutionMode from Jenkins

# Set the URL for the API endpoint
$url = "http://localhost:1505/api/Dcm/VSEs/VSE/$VirtualServiceName"

# Define the credentials for basic authentication
$credentials = [System.Management.Automation.PSCredential]::new("admin", ("admin" | ConvertTo-SecureString -AsPlainText -Force))

# Set the XML data to send in the request body, parameterized with $VirtualServiceName and $ExecutionMode
$xmlBody = @"
<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<VirtualService 
    xmlns="http://www.ca.com/lisa/invoke/v2.0" name="$VirtualServiceName" 
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://www.ca.com/lisa/invoke/v2.0 VirtualService.xsd" href="http://localhost:1505/api/Dcm/VSEs/VSE/$VirtualServiceName" type="application/vnd.ca.lisaInvoke.virtualService+xml">
    <ExecutionMode>$ExecutionMode</ExecutionMode>
    <LearnSuccessResponseOnly>false</LearnSuccessResponseOnly>
</VirtualService>
"@

# Set the headers for the request
$headers = @{
    "Content-Type" = "application/vnd.ca.lisaInvoke.virtualService+xml"
}

# Send the PUT request using Invoke-RestMethod
$response = Invoke-RestMethod -Uri $url -Method Put -Body $xmlBody -Headers $headers -Credential $credentials -ContentType "application/vnd.ca.lisaInvoke.virtualService+xml"

# Output the response
$response
