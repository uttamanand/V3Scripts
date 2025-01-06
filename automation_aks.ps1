using assembly System.Net.Http
using namespace System.Net.Http
# Convert credentials to base64
$base64AuthInfo = [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes(("admin:admin")))

# Define URI and headers
$uri = "http://api.devtest.apps.devtest.svc.cluster.local/lisa-virtualize-invoke/api/v3/vses/VSE/services"
$headers = @{
    "accept" = "application/json"
    "Authorization" = "Basic $base64AuthInfo"
    "ContentType" = "multipart/form-data"
}

# Create MultipartFormDataContent
$multiPartContent = [System.Net.Http.MultipartFormDataContent]::new()

# Add the files and other form data
$configFile = Get-Item "Config.json"
$rrpairZip = Get-Item "Car-RR-Pairs.zip"
$activeConfig = Get-Item "Alternative_config.config"

$multiPartContent.Add([System.Net.Http.StreamContent]::new($configFile.OpenRead()), "config", $configFile.Name)
$multiPartContent.Add([System.Net.Http.StringContent]::new("true"), "deploy")
$multiPartContent.Add([System.Net.Http.StringContent]::new("true"), "cleanRecording")
$multiPartContent.Add([System.Net.Http.StreamContent]::new($rrpairZip.OpenRead()), "inputFile1", $rrpairZip.Name)
$multiPartContent.Add([System.Net.Http.StreamContent]::new($activeConfig.OpenRead()), "activeConfig", $activeConfig.Name)

# Create HttpClient and HttpRequestMessage
$httpClient = [System.Net.Http.HttpClient]::new()
$request = [System.Net.Http.HttpRequestMessage]::new([System.Net.Http.HttpMethod]::Post, $uri)
$request.Content = $multiPartContent

# Add headers to the request
foreach ($header in $headers.GetEnumerator()) {
    $request.Headers.Add($header.Key, $header.Value)
}

# Send the request
$response = $httpClient.SendAsync($request).Result

# Output the response
$responseContent = $response.Content.ReadAsStringAsync().Result
$response.StatusCode
$responseContent
