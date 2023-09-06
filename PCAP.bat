@echo off
set Folder=%cd%
set input_file=%1
set filter=%2
set counter=%3
set folderPrefix=PCAP
setlocal enabledelayedexpansion

for /f "delims=." %%a in ("%input_file%") do set filename=%%~nxa
	echo %input_file% was stripped to !filename!
	echo %filter% will be applied

	tshark -C SCT.232408.W4 -Y %filter% -r !filename!.pcapng.gz -w !filename!.pcapng

	tecmp_converter.exe !filename!.pcapng !filename!.notecmp.pcapng
	echo converted
	tshark -F pcap -r !filename!.notecmp.pcapng -w !filename!.notecmp.pcap
	echo %file% finished

	set folderName=!folderPrefix!_!counter!
    if not exist "%Folder%\!folderName!" (
        mkdir "%Folder%\!folderName!"
    )

	move "%Folder%\!filename!.pcapng.gz" "%Folder%\%folderName%\!filename!.pcapng.gz"
	move "%Folder%\!filename!.pcapng" "%Folder%\%folderName%\!filename!.pcapng"
	move "%Folder%\!filename!.notecmp.pcapng" "%Folder%\%folderName%\!filename!.notecmp.pcapng"
	move "%Folder%\!filename!.notecmp.pcap" "%Folder%\%folderName%\!filename!.notecmp.pcap"
	echo %errorlevel%



