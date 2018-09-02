# MessTest
This is a little project started to collect examples of bizarre UNC and NTFS
filesystem behaviour. It was started after finding a file with the following
name on a UNC share:

``
@GMT-2000.01.10-00.00.00.txt
``

This file could not be deleted or renamed via the UNC path returning File Not
Found errors. Neither can it be copied using robocopy or renamed using
Windows Explorer via the UNC path. It can however be manipulated via the local
drive letter path.

## Setup For Testing

To run the script in this repository or otherwise test the issue with other
tools simply make the same directory available via both drive letter path and
UNC (SMB) path, for example:

| Drive Path | UNC Path |
| -- | -- |
| `C:\Users\bob\test` | `\\localhost\C$\Users\bob\test` |

The script is designed to be run from the drive path and works out the
correct UNC path. Make sure the user the script runs as has access rights
to create directories and files via both paths.

To manually test this without using the script simply try writing some
text to a file via the two paths:

``
"testing" | Out-File -FilePath C:\Users\bob\test\@GMT-2000.01.10-00.00.00.txt

"testing" | Out-File -FilePath \\localhost\C$\Users\bob\test\@GMT-2000.01.10-00.00.00.txt
``

## Discoveries So Far

Upon further investigation I found other examples that produce errors or
unexpected behaviour upon attempted file creation via UNC paths:

| Attempted | Result | Note |
| -- | -- | -- |
| `@GMT-1000.00.00-00.00.00.txt` | `.txt` | Just extension. |
| `@GMT-2000.00.00-00.00.00.txt` | `.txt` | Just extension. |
| `@GMT-1000.01.10-00.00.00.txt` | `.txt` | Just extension. |
| `@GMT-2000.01.10-00.00.00.txt` | File Not Found | Huh? |
| `@GMT-1000.00.00-00.00.00` | Access Denied | What? |
| `@EST-1000.00.00-00.00.00.txt` | `@EST-1000.00.00-00.00.00.txt` | Works |
| `@EST-1000.01.10-00.00.00.txt` | `@EST-1000.01.10-00.00.00.txt` | Works |
| `XGMT-1000.00.00-00.00.00.txt` | `XGMT-1000.00.00-00.00.00.txt` | Works |
| `@GMT-1000.00-00.00.00.00.txt` | `@GMT-1000.00-00.00.00.00.txt` | Flipped hyphen. |

A few months before I'd seen [PENTESTER’S WINDOWS NTFS TRICKS COLLECTION](https://sec-consult.com/en/blog/2018/06/pentesters-windows-ntfs-tricks-collection/)
which made me think it might be an alternate data streams issue but upon
looking back this doesn't match any of those cases. The filenames being
date based also seems too coincidental. But why then is the File Not Found
example different?
