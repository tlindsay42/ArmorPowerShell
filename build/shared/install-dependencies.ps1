Install-PackageProvider -Name NuGet -Force | 
	Out-Null

Install-Module -Name Pester -Force

Install-Module -Name posh-git -Force
