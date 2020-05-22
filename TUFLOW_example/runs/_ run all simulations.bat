REM - The simulator executable path is preset in the container environment 
rem Set EXE_iSP=..\exe\2018-03-AC\TUFLOW_iSP_w64.exe
rem Set EXE_iDP=..\exe\2018-03-AC\TUFLOW_iDP_w64.exe
REM - Run all example models

start "TUFLOW" /wait /low /b %EXE_iSP% -b  -sl 5m -s2 EXG -el Q100 -e2 2hr		EG05_2D_~s1~_~s2~_~e1~_~e2~_006.tcf
start "TUFLOW" /wait /low /b %EXE_iSP% -b  -sl 5m -s2 EXG -el Q100 -e2 4hr		EG05_2D_~s1~_~s2~_~e1~_~e2~_006.tcf
start "TUFLOW" /wait /low /b %EXE_iSP% -b  -sl 5m -s2 EXG -el QPMF -e2 2hr		EG05_2D_~s1~_~s2~_~e1~_~e2~_006.tcf
start "TUFLOW" /wait /low /b %EXE_iSP% -b  -sl 5m -s2 EXG -el QPMF -e2 4hr		EG05_2D_~s1~_~s2~_~e1~_~e2~_006.tcf
start "TUFLOW" /wait /low /b %EXE_iSP% -b  -sl 5m -s2 D01 -el Q100 -e2 2hr		EG05_2D_~s1~_~s2~_~e1~_~e2~_006.tcf
start "TUFLOW" /wait /low /b %EXE_iSP% -b  -sl 5m -s2 D01 -el Q100 -e2 4hr		EG05_2D_~s1~_~s2~_~e1~_~e2~_006.tcf
start "TUFLOW" /wait /low /b %EXE_iSP% -b  -sl 5m -s2 D01 -el QPMF -e2 2hr		EG05_2D_~s1~_~s2~_~e1~_~e2~_006.tcf
start "TUFLOW" /wait /low /b %EXE_iSP% -b  -sl 5m -s2 D01 -el QPMF -e2 4hr		EG05_2D_~s1~_~s2~_~e1~_~e2~_006.tcf

