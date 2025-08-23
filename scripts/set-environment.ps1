param(
    [Parameter(Mandatory=$true)]
    [ValidateSet('development', 'uat', 'production')]
    [string]$Environment
)

$envFile = "../env/.env.$Environment"
$targetFile = ".env"

# Check if environment file exists
if (-not (Test-Path $envFile)) {
    Write-Error "Environment file $envFile not found!"
    exit 1
}

# Copy the environment file
Copy-Item -Path $envFile -Destination $targetFile -Force

Write-Host "Environment set to $Environment" -ForegroundColor Green

# Update the main environment configuration
$configFile = "./modules/app_config/lib/config/app_config/cc_app_config.dart"
$configContent = Get-Content $configFile -Raw

# Update the environment setting
$configContent = $configContent -replace "static Environment environment = Environment\.[A-Z_]+;", "static Environment environment = Environment.${Environment.ToUpper()};"

# Save the updated configuration
$configContent | Set-Content $configFile -NoNewline

Write-Host "Updated $configFile with $Environment environment" -ForegroundColor Green
