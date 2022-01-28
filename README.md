# sqlslip
Slipstreaming CUs of SQL Server and create ISO images from them

## Works on:
- SQL Server 2019 with Cumulative Updates
- SQL Server 2016 with Service Packs (but not Service Packs *and* Cumultative updates)

## Installation
Clone this repository and make sure you add in the same directory or in your path the [OSCDIMG.EXE executable](https://docs.microsoft.com/en-us/windows-hardware/manufacture/desktop/oscdimg-command-line-options)

## Usage
```
sqlslip SQLSource-Directory CU-Directory TargetDirectory [/nocleanup] [/noiso]
```
e.g.
```
sqlslip.cmd E:\ C:\CU14 D:\Temp\SQLSERVER2019CU14.ISO
```
- ```E:\``` is a read-only source for the RTM version of SQL Server (e.g. mounted ISO)
- ```C:\CU14``` is the location of the *untouched* KB exe of the CU
- ```CU14``` will be then the label of the ISO, so you may want to name the directory like SQL2019CU14 instead.
   
- ```D:\temp\SQLSERVER2019CU14``` side-by-side with the iso will be a temporary directory which will be erased afterwards

 - ```/nocleanup``` will not remove  ```D:\temp\SQLSERVER2019CU14```
 - ```/noiso``` builds the structure and not the ISO

- the build of the iso requires ```ISOCDIMG.EXE``` in the path to be found in the AIK or other OS related SDK.
