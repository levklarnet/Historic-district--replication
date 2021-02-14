*** HIGHLY CONFIDENTIAL ***
clear 
set more off
set type double

* set your cd to your computer
cd "C:\Users\levklarnet\Downloads\Data_work_1 (1)\Data_work_1 (1)\Script"
global script=c(pwd)
global script=subinstr("$script","\","/",.)
global path=subinstr("$script","/Script","",.)
global output "$path/Output"
global input "$path/Input"
global temp "$path/Temp"

*EOF
