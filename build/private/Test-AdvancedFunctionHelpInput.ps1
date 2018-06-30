function Test-AdvancedFunctionHelpInput ( [PSObject] $Help ) {
    $contextName = $Global:FORM_FUNCTION_HELP -f 'Inputs'
    Context -Name $contextName -Fixture {
        #region init
        $pipelineInputParameterTypes = @()
        $inputTypes = $Help.InputTypes.InputType.Type.Name.Split( "`n" ).Where( { $_.Length -gt 0 } )
        #endregion

        $pipelineInputParametersByPropertyName = $Help.Parameters |
            Where-Object -FilterScript { ( $_ | Get-Member -Name 'Parameter' -ErrorAction 'SilentlyContinue' | Measure-Object ).Count -gt 0 } |
            Select-Object -ExpandProperty 'Parameter' |
            Where-Object -FilterScript { $_.PipelineInput -match '^true.*ByPropertyName' } |
            ForEach-Object -Process { $_.Type.Name } |
            Measure-Object
        if ( $pipelineInputParametersByPropertyName.Count -gt 0 ) {
            $pipelineInputParameterTypes += 'System.Management.Automation.PSObject'
        }

        $pipelineInputParameterTypes += $Help.Parameters |
            Where-Object -FilterScript { ( $_ | Get-Member -Name 'Parameter' -ErrorAction 'SilentlyContinue' | Measure-Object ).Count -gt 0 } |
            Select-Object -ExpandProperty 'Parameter' |
            Where-Object -FilterScript { $_.PipelineInput -match '^true.*ByValue' } |
            ForEach-Object -Process {
                $typeName = $_.Type.Name
                switch ( $typeName ) {
                    'String' {
                        'System.String'
                    }
                    'System.String' {
                        'System.String'
                    }
                    'PSObject[]' {
                        'System.Management.Automation.PSObject[]'
                    }
                    default {
                        ( New-Object -TypeName $typeName ).GetType().FullName
                    }
                }
            }

        $pipelineInputParameterTypes = $pipelineInputParameterTypes |
            Sort-Object -Unique

        $testName = "should have at least: '1' entry"
        It -Name $testName -Test {
            $inputTypes.Count |
                Should -BeGreaterThan 0
        }

        foreach ( $inputType in $inputTypes ) {
            if ( $inputType -match '^None' ) {
                $testName = "should not have any pipeline input parameters since: 'Inputs' is set to: '${inputType}'"
                It -Name $testName -Test {
                    ( $pipelineInputParameterTypes | Measure-Object ).Count |
                        Should -Be 0
                }
                break
            }
            else {
                $testName = "should have a pipeline input parameter of type: '${inputType}'"
                It -Name $testName -Test {
                    $inputType |
                        Should -BeIn $pipelineInputParameterTypes
                }
            }
        }

        foreach ( $inputType in $pipelineInputParameterTypes ) {
            $testName = "should have an: 'Inputs' entry for type: '${inputType}'"
            It -Name $testName -Test {
                $inputType |
                    Should -BeIn $inputTypes
            }
        }
    }
}
