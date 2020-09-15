
#Persistent
#SingleInstance , force
#InstallKeybdHook


; Set AHK config

Menu, Tray, Icon, resources\midilab.ico
SendMode Input
SetWorkingDir %A_ScriptDir%



; Ensures a consistent starting directory

if A_OSVersion in WIN_NT4,WIN_95,WIN_98,WIN_ME ; If not Windows XP or greater, quit program
{
  MsgBox This script requires Windows 2000/XP or later.
  ExitApp
}


; Set midilab version

version = midilab



; Load values from the ini file and refresh ports

ReadIni()
gosub, MidiPortRefresh



; Test ports and listen to MIDI input

TestPorts(numports,numports2)
gosub, MidiListen
gosub, MidiOut
gosub, Develop



; Open Midi Montitor on Startup

;gosub, MidiMonitor



; End autoexec section

return



; Includes files

#Include core/core.ahk
#Include core/develop.ahk
#Include user/midi-in.ahk
;#Include user/midi-out.ahk
