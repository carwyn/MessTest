$TEST_SET = @(
    '@GMT.txt',
    '@GMT-0000.txt',
    '@GMT-00.00.txt',
    '@GMT-00.00-00.txt',
    '@GMT-00.00-00.00.txt',

    '@GMT-1001.01.10-00.00.00.txt',
    '@GMT-1000.01.00-00.00.00.txt',
    '@GMT-100a.01.10-00.00.00.txt',
    '@GMT-1000.00.00-00.00.00.log',
    '@GMT-1000.00.00-00.00.00',
    '@GMT-100a.00.00-00.00.00',
    '@GMT-1000.00-00.00.00.00.txt',
    '@GMT-1000.01-10.00.00.00.txt',
    '@GMT-400.01.10-00.00.00.txt',

    '@GMT-0000.00.00-00.00.00.txt',
    '@GMT-1000.00.00-00.00.00.txt',
    '@GMT-2000.00.00-00.00.00.txt',
    '@GMT-3000.00.00-00.00.00.txt',
    '@GMT-4000.00.00-00.00.00.txt',
    '@GMT-0000.01.10-00.00.00.txt',
    '@GMT-1000.01.10-00.00.00.txt',
    '@GMT-2000.01.10-00.00.00.txt',
    '@GMT-3000.01.10-00.00.00.txt',
    '@GMT-4000.01.10-00.00.00.txt',
    
    '@GMT-4100.01.10-00.00.00.txt',
    '@GMT-4100.00.00-00.00.00.txt',
    '@EST-1000.00.00-00.00.00.txt',
    '@EST-1000.01.10-00.00.00.txt',
    '@XXX-1000.00.00-00.00.00.txt',

    'XGMT-1000.00.00-00.00.00.txt',
    'XGMT-1000.01-10.00.00.00.txt'
)

$TESTDIR = "messtest"

$DRIVEPATH = (Get-Location)
$drive = (Split-Path -Qualifier -Path $DRIVEPATH).Replace(":","$")
$dir = (Split-Path -NoQualifier -Path $DRIVEPATH)
$SHAREPATH = Join-Path -Path (Join-Path -Path "\\localhost" -ChildPath $drive) -ChildPath $dir

foreach($p in @($DRIVEPATH, $SHAREPATH)) {
    $cur = (Join-Path -Path $p -ChildPath $TESTDIR)

    foreach($f in $TEST_SET) {
        # Create a fresh target directory each time.
        New-Item -Path $cur -ItemType Directory -ErrorAction Stop | Out-Null
        $filepath = (Join-Path -Path $cur -ChildPath $f)

        try {
            "testing" | Out-File -FilePath $filepath
            $created = (Get-ChildItem -Path $cur)

            if($created.Name -eq $f) {
                Write-Host -ForegroundColor Green ("  Created: {0}" -f $filepath)
            } else {
                Write-Host -ForegroundColor Yellow ("Attempted: {0}" -f $filepath)
                $managed = Join-Path -Path $cur -ChildPath $created.Name
                Write-Host -ForegroundColor Yellow ("  Managed: {0}" -f $managed)
            }

        } catch [System.IO.FileNotFoundException] {
            Write-Host -ForegroundColor Red ("   Failed: {0} (file not found)" -f $filepath)
        } catch [System.UnauthorizedAccessException] {
            Write-Host -ForegroundColor Red ("   Denied: {0} (access denied)" -f $filepath)
        }
        # Tidy up each time by removing the containing directory.
        Remove-Item -Recurse $cur
    }
}
