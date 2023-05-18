@echo off
:start
cls
setlocal enableDelayedExpansion
REM wyswietl rekordy
echo Diff 	     Nick 	 Punkty
echo -------------------------------
call :displayRekordy
echo -------------------------------
echo.

set /p nick=4 literowy nick: 

REM sprawdz czy 4 litery
call :nickWalidacja czyWalid "!nick!"

if "!czyWalid!" NEQ "true" (
	echo Mialy byc 4 litery spoko [kliknij enter aby kontynuacja]
	pause >nul
	goto :start
)
echo.

REM we daj mu wybrac level
choice /c 123 /m "Wybierz poziom (1 - Easy, 2 - Extra, 3 - Ultra)"
set wybor=!errorlevel!

REM ogarnij co wybral
if "!wybor!" EQU "1" set /a max=20
if "!wybor!" EQU "2" set /a max=50
if "!wybor!" EQU "3" set /a max=100

echo OK !nick!, twoim zadaniem bedzie wybrac liczbe od 1 do !max!

REM wstepnie wylosuj liczbe
call :wylosuj liczba 1 !max!

REM rozpocznij gameplay, funkcja wroci tylko tu jezeli zgadl
call :gameplay ile !liczba! 1
cls
echo No ladnie, zajelo ci to tylko !ile! prob.

REM wyczytaj obecny rekord
if "!wybor!" EQU "1" set poziom=Easy.
if "!wybor!" EQU "2" set poziom=Extra
if "!wybor!" EQU "3" set poziom=Ultra

call :readRekord highScore !poziom!

if !highScore! LEQ !ile! (
	echo Niestety, nie jest to nowy rekord. Obecny wynosi !highScore! prob
	echo Probuj dalej. Kliknij cokolwiek
	pause >nul
	goto :start
)

echo Brawo. Wychodzi na to ze jest to nowy rekord. Serdecznie gratuluje wygranej. Poprzedni rekord wynosil !highScore! prob

REM zapisz wynik :D
call :setRekord !poziom! !nick! !ile!

echo Kliknij cokolwiek aby wyjsc z gry
pause >nul

endlocal
goto :eof


:nickWalidacja ret nick
setlocal enableDelayedExpansion
	set ret=true
	set nick=%~2
	if "!nick:~0,4!" NEQ "!nick!" set ret=false
	if "!nick:~0,3!" EQU "!nick!" set ret=false
endlocal & set %1=%ret%
goto :eof

:wylosuj ret od do
setlocal enableDelayedExpansion
	set /a res=(!random! %% (%3 - %2)) + %2
endlocal & set %1=%res%
goto :eof


:gameplay ileZajelo doZgadniecia obecnaIloscProb
setlocal enableDelayedExpansion
set liczba=%2
set /a ileProb=%3
set wygrana=false
set /p zgad=Podaj liczbe: 
if !liczba! NEQ !zgad! (
	echo Niestety nie jest to ta liczba.
	set /a ileProb=ileProb+1
	call :gameplay ileProb !liczba! !ileProb!
)
endlocal & set %1=%ileProb%
goto :eof

:displayRekordy
setlocal enableDelayedExpansion
for /F "tokens=*" %%A in (rekordy.txt) do (
	set /a idx=0
	set res=%%A
	for %%x in (!res!) do (
		set res[!idx!]=%%x
		set /a idx+=1
	)
	set res=!res[0]!        !res[1]!        !res[2]!
	echo !res!
)
endlocal
goto :eof

:readRekord
setlocal enableDelayedExpansion
set resF=
for /F "tokens=*" %%A in (rekordy.txt) do (
	set res=%%A
	set /a idx=0
	for %%x in (!res!) do (
		set res[!idx!]=%%x
		set /a idx+=1
	)
	
	if "!res[0]!" equ "%2" set resF=!res[2]!
)
endlocal & set %1=%resF%
goto :eof

:setRekord poziom nick ilosc
setlocal enableDelayedExpansion
set res=
set /a i=0
for /F "tokens=*" %%A in (rekordy.txt) do (
	set /a i+=1
	set res=%%A
	set /a idx=0
	for %%x in (!res!) do (
		set line[!idx!]=%%x
		set /a idx+=1
	)
	if "!line[0]!" equ "%1" (
		set line[1]=%2
		set line[2]=%3
	)
	
	set res[!i!]=!line[0]! !line[1]! !line[2]!
)

echo !res[1]! > rekordy.txt
echo !res[2]! >> rekordy.txt
echo !res[3]! >> rekordy.txt

endlocal & set %1=%resF%
goto :eof


:eof