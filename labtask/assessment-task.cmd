@echo off
setlocal enableextensions
rem ---------------------------------------------------------------------------
rem  Assessment task payload (AzureBatch.L200.Troubleshooting.1)
rem  Simulates the word-frequency processing performed by the lab's task
rem  application, then completes. Downloaded to the compute node as a task
rem  resource file and executed by each task.
rem ---------------------------------------------------------------------------

set INPUT=%1
echo Starting analysis for "%INPUT%"

rem Simulate reading and tokenizing the input data set.
set /a STEP=0
for %%W in (alpha beta gamma delta epsilon) do (
    set /a STEP+=1
    echo   scanned token bucket %%W
)

echo Aggregating top-N word counts...
echo Writing results record...
echo Analysis complete for "%INPUT%".

rem Finalize. The completion status returned here reflects the outcome that the
rem Batch service records for this task.
exit /b -3
