$TEST_SET = @(
    '@GMT-2000.01.10-00.00.00.txt',
    '@GMT-1000.01.10-00.00.00.txt'
)

$TESTDIR = "messtest"

foreach($f in $TEST_SET) {
    New-Item -Name $TESTDIR | Out-Null
    Write-Host ("Attempting: {0}" -f $f)
    "testing" | Out-File -FilePath (Join-Path -Path $TESTDIR -ChildPath $f)
    Write-Host ("Created: {0}" -f (Get-ChildItem -Path $TESTDIR))
    Remove-Item -Recurse $TESTDIR
}
