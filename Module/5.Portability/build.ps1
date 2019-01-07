# Look at -precondition in git and unload Task.
# Add task for Script Analyzer
# Add task for Pester tests
# Update pre-build checklist

Invoke-psake -buildFile .\bulletProof.build.ps1 -docs
Invoke-psake -buildFile .\bulletProof.build.ps1

