#Persistent
#SingleInstance , force
#InstallKeybdHook

; Global Variables
global version                                  ; appname for ini file access and gui display
global MidiInDevice, MidiOutDevice              ; midi devices
global MidiInPort, MidiOutPort                  ; midi port
global statusbyte, chan, number, value, channel ; midi raw data (??? why chan and channel exist?)
global note, CC_num, pitchb, type               ; interpreted midi data or midi out parameter
global change                                   ; seems not used, "positive" or "negative"
global mode                                     ; seems related to keyinput
note_lowest := 38   ; midi out parameter
vel := 100          ; midi out parameter
channel := 1        ; default channel =1
CC_num := 7         ; CC
CCIntVal := 0       ; Default zero for  CC  (data byte 2)
CCIntDelta := 1     ; Amount to change CC (data byte 2)

; Set AHK config
Menu, Tray, Icon, resources\midilab.ico
SendMode Input
SetWorkingDir %A_ScriptDir%

; If not Windows XP or greater, quit program
if A_OSVersion in WIN_NT4,WIN_95,WIN_98,WIN_ME 
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

; Open Midi Montitor on Startup
gosub, MidiMonitor

; End of auto exec section
Return



; =============================================================================================
; labels section 
; =============================================================================================

; ----------------------------------------------
; rules label (??? seems to be midi-in to action script space)
; ----------------------------------------------

rules:
{
    ; Defince helper vars or functions
    if value between 1 and 10
    {
    change := "positive"
    }
    if value between 120 and 127
    {
    change := "negative"
    }

    ; Get modifier key state
    if !getKeyState("Ctrl") and !getKeyState("Alt") and !getKeyState("Shift")
    {
    mode := "Default"
    }
    if (getKeyState("Shift") and !getKeyState("Ctrl") and !getKeyState("Alt"))
    {
    mode := "Shift"
    }
    if !getKeyState("Shift") and getKeyState("Ctrl") and !getKeyState("Alt")
    {
    mode := "Ctrl"
    }
    if !getKeyState("Shift") and getKeyState("Ctrl") and getKeyState("Alt")
    {
    mode := "Ctrl + Alt"
    }
    if getKeyState("Shift") and getKeyState("Ctrl") and !getKeyState("Alt")
    {
    mode := "Ctrl + Shift"
    }
    if !getKeyState("Shift") and !getKeyState("Ctrl") and getKeyState("Alt")
    {
    mode := "Alt"
    }
    if getKeyState("Shift") and !getKeyState("Ctrl") and getKeyState("Alt")
    {
    mode := "Alt + Shift"
    }
    if getKeyState("Shift") and getKeyState("Ctrl") and getKeyState("Alt")
    {
    mode := "Ctrl + Alt + Shift"
    }
}
Return

; ----------------------------------------------
; core gui labels
; ----------------------------------------------

; Midi monitor gui code - creates the monitor window
MidiMonitor: ; midi monitor gui with listviews
{
  posx := A_ScreenWidth - 600
  posy := A_ScreenHeight - 380
  ; MsgBox %posx%

  Gui, 14: destroy
  Gui, 14: default
  Gui, 14: add, text, x10 y5, MIDI Input ; %TheChoice%
  Gui, 14: Add, DropDownList, x10 y20 w140 Choose%TheChoice% vMidiInPort gDoneInChange altsubmit -tabstop, %MiList% ; (
  Gui, 14: add, text, x320 y5, MIDI Ouput ; %TheChoice2%
  Gui, 14: Add, DropDownList, x320 y20 w140 Choose%TheChoice2% vMidiOutPort gDoneOutChange altsubmit -tabstop, %MoList%
  Gui, 14: Add, ListView, x5 r11 w300 Backgroundblack caqua Count10 vIn1 -tabstop, type|status|channel|number|value|
  Gui, 14: Add, ListView, x+5 r11 w300 Backgroundblack cyellow Count10 vOut1 -tabstop, type|status|channel|number|value|
  Gui, 14: +AlwaysOnTop
  Gui, 14: add, Button, x5 w300 gSet_Done, Save && Reload
  Gui, 14: add, Button, xp+305 w300 gCancel, Cancel
  Gui, 14: show, autosize x%posx% y%posy%, IO Monitor
}
Return

; Midi input selection
MidiSet:
{
  Gui, 6: Destroy
  Gui, 2: Destroy
  Gui, 3: Destroy
  Gui, 4: Destroy
  Gui, 4: +LastFound +AlwaysOnTop +Caption +ToolWindow ;-SysMenu
  Gui, 4: Font, s12
  Gui, 4: add, text, x10 y10 w300 cmaroon, Select Midi Ports. ; Text title
  Gui, 4: Font, s8
  Gui, 4: Add, Text, x10 y+10 w175 Center , Midi In Port ;Just text label
  Gui, 4: font, s8
  Gui, 4: Add, ListBox, x10 w200 h100 Choose%TheChoice% vMidiInPort gDoneInChange AltSubmit, %MiList% ; --- midi in listing of ports
  Gui, 4: Add, TEXT, x220 y40 w175 Center, Midi Out Port ; gDoneOutChange
  Gui, 4: Add, ListBox, x220 y62 w200 h100 Choose%TheChoice2% vMidiOutPort gDoneOutChange AltSubmit, %MoList% ; --- midi out listing
  Gui, 4: add, Button, x10 w205 gSet_Done, Done - Reload script.
  Gui, 4: add, Button, xp+205 w205 gCancel, Cancel
  Gui, 4: show , , %version% Midi Port Selection ; main window title and command to show it.
}
Return

; Run this when midi input port has changed
DoneInChange:
{
  gui +lastfound
  Gui, Submit, NoHide
  Gui, Flash
  Gui, 4: Submit, NoHide
  Gui, 4: Flash
  If %MidiInPort%
  UDPort:= MidiInPort - 1, MidiInDevice:= UDPort ; probably a much better way do this, I took this from JimF's qwmidi without out editing much.... it does work same with doneoutchange below.
  GuiControl, 4:, UDPort, %MidiIndevice%
  WriteIni()
  ; MsgBox, 32, , midi in device = %MidiInDevice%`nmidiinport = %MidiInPort%`nport = %port%`ndevice= %device% `n UDPort = %UDport% ; UNCOMMENT FOR TESTING IF NEEDED
}
Return

; Run this when output port has changed
DoneOutChange:
{
  gui +lastfound
  Gui, Submit, NoHide
  Gui, Flash
  Gui, 4: Submit, NoHide
  Gui, 4: Flash
  If %MidiOutPort%
  UDPort2:= MidiOutPort - 1 , MidiOutDevice:= UDPort2
  GuiControl, 4: , UDPort2, %MidiOutdevice%
  WriteIni()

  ;Gui, Destroy
}
Return

; Save config and reload
Set_Done:
{
  Gui, 3: Destroy
  Gui, 4: Destroy
  sleep, 100
  Reload
}
Return

; Do not save and close all dialogs
Cancel:
{
  Gui, Destroy
  Gui, 2: Destroy
  Gui, 3: Destroy
  Gui, 4: Destroy
  Gui, 5: Destroy
}
Return

; Reset configuration and delete ini
ResetAll:
{
  MsgBox, 33, %version% - Reset All?, This will delete ALL settings`, and restart this program!
  IfMsgBox, OK
  {
    FileDelete, core/%version%.ini ; delete the ini file to reset ports, probably a better way to do this ...
    Reload ; restart the app
  }
  IfMsgBox, Cancel
  {
    ; Do nothing
  }
}
Return

; On window close
GuiClose:
{
  Suspend, Permit ; allow Exit to work Paused.
  MsgBox, 4, Exit %version%, Exit %version% %ver%?
  IfMsgBox No
  Return
  Else IfMsgBox Yes
  midiOutClose(h_midiout)
  Gui, 6: Destroy
  Gui, 2: Destroy
  Gui, 3: Destroy
  Gui, 4: Destroy
  Gui, 5: Destroy
  gui, 7: destroy
  Sleep 100
  ;winclose, Midi_in_2 ;close the midi in 2 ahk file
  ExitApp
}

; ----------------------------------------------
; core routine labels
; ----------------------------------------------

; Load new settings from midi out menu item
MidiOut:
{
  OpenCloseMidiAPI()
  h_midiout := midiOutOpen(MidiOutDevice) ; OUTPUT PORT 1 SEE BELOW FOR PORT 2
}
Return

; Get list of MIDI ports
MidiPortRefresh: ; get the list of ports
{
  MIlist := MidiInsList(NumPorts) ; Get midi inputs list
  Loop Parse, MIlist, |
  {
  }
  TheChoice := MidiInDevice + 1

  MOlist := MidiOutsList(NumPorts2) ; Get midi outputs list
  Loop Parse, MOlist, |
  {
  }
  TheChoice2 := MidiOutDevice + 1
}
Return

; Midi input / output under the hood
MidiListen:
{
  DeviceID := MidiInDevice ; midiindevice from IniRead above assigned to deviceid
  CALLBACK_WINDOW := 0x10000 ; from orbiks code for midi input

  Gui, +LastFound ; set up the window for midi data to arrive.
  hWnd := WinExist() ;MsgBox, 32, , line 176 - mcu-input is := %MidiInDevice% , 3 ; this is just a test to show midi device selection

  hMidiIn =
  VarSetCapacity(hMidiIn, 4, 0)
  result := DllCall("winmm.dll\midiInOpen", UInt,&hMidiIn, UInt,DeviceID, UInt,hWnd, UInt,0, UInt,CALLBACK_WINDOW, "UInt")
  If result
  {
    MsgBox, Error, midiInOpen Returned %result%`n
    ;GoSub, sub_exit
  }

  hMidiIn := NumGet(hMidiIn) ; because midiInOpen writes the value in 32 bit binary Number, AHK stores it as a string
  result := DllCall("winmm.dll\midiInStart", UInt,hMidiIn)
  If result
  {
    MsgBox, Error, midiInStart Returned %result%`nRight Click on the Tray Icon - Left click on MidiSet to select valid midi_in port.
    ;GoSub, sub_exit
  }

  OpenCloseMidiAPI()

  ; See top of this file for function called when a midi message is detected
  OnMessage(0x3C1, "MidiMsgDetect")
  OnMessage(0x3C2, "MidiMsgDetect")
  OnMessage(0x3C3, "MidiMsgDetect")
  OnMessage(0x3C4, "MidiMsgDetect")
  OnMessage(0x3C5, "MidiMsgDetect")
  OnMessage(0x3C6, "MidiMsgDetect")
}
Return

; ----------------------------------------------
; core send labels
; ----------------------------------------------
; Relay controller message
RelayCC:
{
  type := "CC" ; Only used in the midi display - has nothing to do with message output
  MidiOutDisplay(type, statusbyte, chan , CC_num, value) ; update the MidiMonitoritor gui
  midiOutShortMsg(h_midiout, (channel+175), CC_num, CCIntVal)

  ;MsgBox, 0, ,sendcc triggered , 1 ; for testing purposes only
}
Return

; Send controller message
SendCC:
{
  type := "CC"
  statusbyte := (channel+174)
  number = %CC_num% ; set value of the number to the above cc_num for display on the midi out window (only needed if you want to see output)
  value = %CCIntVal%
  midiOutShortMsg(h_midiout, (channel+175), CC_num, CCIntVal)
  MidiOutDisplay(type, statusbyte, channel, number, value) ; ; update the MidiMonitoritor gui

  ;MsgBox, 0, ,sendcc triggered , 1 ; for testing purposes only
}
Return

; Send out note messages
RelayNote:
{
  type := "NoteOn"
  midiOutShortMsg(h_midiout, statusbyte, number, value)
  MidiOutDisplay(type, statusbyte, chan, number, value)
}
Return

; Send out note messages ; this should probably be a funciton but... eh
SendNote:
{
  type := "Note"
  ;statusbyte := 144
  chan = %channel%
  number = %note% ; Set value of the number to the above cc_num for display on the midi out window (only needed if you want to see output)
  value = %vel%
  midiOutShortMsg(h_midiout, statusbyte, note, vel) ; call the midi funcitons with these params.
  MidiOutDisplay(type, statusbyte, chan, number, value)
}
Return

; Send a progam change message - value is ignored
SendPC:
{
  type := "PC"
  statusbyte := 192
  chan = %channel%
  number = %PC% ; Set value of the number to the above cc_num for display on the midi out window (only needed if you want to see output)
  value =
  midiOutShortMsg(h_midiout, (channel+191), pc, value)
  MidiOutDisplay(type, statusbyte, chan, number, value)
}
Return




; =============================================================================================
; functions section
; =============================================================================================

; ----------------------------------------------
; core config functions
; ----------------------------------------------

; Read .ini file to load port settings - also set up the tray Menu
ReadIni()
{
  ;Menu, tray, NoStandard
  ;Menu, tray, add
  menu, tray, add, MidiMonitor ; Menu item for the midi monitor
  Menu, tray, add, MidiSet ; set midi ports tray item
  Menu, tray, add, ResetAll ; DELETE THE .INI FILE - a new config needs to be set up

  menu, tray, Rename, MidiSet, Open MIDI port selection
  menu, tray, Rename, ResetAll, Reset port selection
  menu, tray, Rename, MidiMonitor, Show IO Monitor (Ctrl+Alt+M)

  IfExist, core/%version%.ini
  {
    IniRead, MidiInDevice, core/%version%.ini, Settings, MidiInDevice , %MidiInDevice% ; read the midi In port from ini file
    IniRead, MidiOutDevice, core/%version%.ini, Settings, MidiOutDevice , %MidiOutDevice% ; read the midi out port from ini file
  }
  Else ; no ini exists and this is either the first run or reset settings.
  {
    MsgBox, 1, No ini file found, Select midi ports? ; Prompt user to select midi ports
    IfMsgBox, Cancel
    ExitApp
    IfMsgBox, yes
    gosub, midiset ; run the midi setup routine
  }
} ; endof readini

; Write selections to .ini filea
WriteIni()
{
  IfNotExist, core/%version%.ini ; if no .ini
  FileAppend,, core/%version%.ini ; make .ini with the following entries.
  IniWrite, %MidiInDevice%, core/%version%.ini, Settings, MidiInDevice
  IniWrite, %MidiOutDevice%, core/%version%.ini, Settings, MidiOutDevice
}

; ----------------------------------------------
; core ports functions
; ----------------------------------------------
; Confirm selected ports exist
TestPorts(numports,numports2)
{
  ; In port selection test based on numports
  If MidiInDevice not Between 0 and %numports%
  {
    MidiIn := 0 ; this var is just to show if there is an error - set if the ports are valid 1, invalid 0

    If (MidiInDevice == "") ; if there is no midi in device
    MidiInerr = Midi In Port EMPTY. ; set this var to error message

    If (midiInDevice > %numports%) ; if greater than the number of ports on the system.
    MidiInnerr = Midi In Port Invalid. ; set this error message
  }
  Else
  {
    MidiIn := 1 ; setting var to non-error state or valid
  }

  ; Test out ports
  If MidiOutDevice not Between 0 and %numports2%
  {
    MidiOut := 0 ; set var to 0 as Error state.

    If (MidiOutDevice == "") ; if blank
    MidiOuterr = Midi Out Port EMPTY. ; set this error message

    If (midiOutDevice > %numports2%) ; if greater than number of availble ports
    MidiOuterr = Midi Out Port Out Invalid. ; set this error message
  }
  Else
  {
    MidiOut := 1 ; set var to 1 as valid state.
  }

  ; Test to see if ports valid, if either invalid load the gui to select
  If (%MidiIn% == 0) Or (%MidiOut% == 0)
  {
    MsgBox, 49, Midi Port Error!,%MidiInerr%`n%MidiOuterr%`n`nLaunch Midi Port Selection!
    IfMsgBox, Cancel
    ExitApp
    midiok = 0 ; Not sure if this is really needed now....
    Gosub, MidiSet
  }
  Else
  {
    midiok = 1
    Return ; do nothing - perhaps do the not test instead above.
  }

}

; ----------------------------------------------
; core core functions
; ----------------------------------------------

; Midi input section in calls this function each time a midi message is received. Then the midi message is broken up into parts for manipulation. See http://www.midi.org/techspecs/midimessages.php (decimal values).
MidiMsgDetect(hInput, midiMsg, wMsg)
{
  ; Extract Variables by extracting from midi message
  statusbyte := midiMsg & 0xFF ; Extract statusbyte = what type of midi message and what midi channel
  chan := (statusbyte & 0x0f) + 1 ; WHAT MIDI CHANNEL IS THE MESSAGE ON? EXTRACT FROM STATUSBYTE
  number := (midiMsg >> 8) & 0xFF ; THIS IS number VALUE = NOTE NUMBER OR CC NUMBER
  value := (midiMsg >> 16) & 0xFF ; value VALUE IS NOTE VELEOCITY OR CC VALUE
  pitchb := (value << 7) | number ; (midiMsg >> 8) & 0x7F7F masking to extract the pbs

  ; Assign type variable for display only
  if statusbyte between 176 and 191 ; Is message a CC
  type := "cc" ; if so then set type to CC - only used with the midi monitor
  if statusbyte between 144 and 159 ; Is message a Note On
  type := "noteon" ; Set gui var
  if statusbyte between 128 and 143 ; Is message a Note Off?
  type := "noteoff" ; set gui to NoteOff
  if statusbyte between 192 and 208 ;Program Change
  type := "pc"
  if statusbyte between 224 and 239 ; Is message a Pitch Bend
  type := "pitchb" ; Set gui to pb

  MidiInDisplay(type, statusbyte, chan, number, value) ; Show midi input on midi monitor display
  gosub, rules ; run rules label to organize
}

; Show midi input on gui monitor
MidiInDisplay(type, statusbyte, chan, number, value)
{
  Gui, 14:default
  Gui, 14:ListView, In1 ; see the first listview midi in monitor
  LV_Add("",type,statusbyte,chan,number,value) ; Setting up the columns for gui
  LV_ModifyCol(1,"center")
  LV_ModifyCol(2,"center")
  LV_ModifyCol(3,"center")
  LV_ModifyCol(4,"center")
  LV_ModifyCol(5,"center")
  If (LV_GetCount() > 10)
  {
    LV_Delete(1)
  }
}

; Show midi output on gui monitor
MidiOutDisplay(type, statusbyte, chan, number, value)
{
  Gui, 14:default
  Gui, 14:ListView, Out1 ; see the second listview midi out monitor
  LV_Add("",type,statusbyte,chan,number,value)
  LV_ModifyCol(1,"center")
  LV_ModifyCol(2,"center")
  LV_ModifyCol(3,"center")
  LV_ModifyCol(4,"center")
  LV_ModifyCol(5,"center")

  If (LV_GetCount() > 10)
  {
    LV_Delete(1)
  }
}

; Show key output
KeyOutDisplay(number, key, multi, mode) ; update the MidiMonitoritor gui
{
  keyout := RegExReplace(key, "[{}]", "")
  mode := RegExReplace(mode, "none", "Key")

  Gui, 14:default
  Gui, 14:ListView, Out1 ; see the second listview midi out monitor
  LV_Add("",number, keyout, multi, mode)
  LV_ModifyCol(1,"center")
  LV_ModifyCol(2,"center")
  LV_ModifyCol(3,"center")
  LV_ModifyCol(4,"center")
  LV_ModifyCol(5,"center")

  If (LV_GetCount() > 10)
  {
    LV_Delete(1)
  }
}

; Returns a "|"-separated list of midi output devices
MidiOutsList(ByRef NumPorts)
{
  local List, MidiOutCaps, PortName, result, midisize
  (A_IsUnicode)? offsetWordStr := 64: offsetWordStr := 32
  midisize := offsetWordStr + 18
  VarSetCapacity(MidiOutCaps, midisize, 0)
  VarSetCapacity(PortName, offsetWordStr) ; PortNameSize 32

  ; Midi output devices on system, First device ID 0
  NumPorts := DllCall("winmm.dll\midiOutGetNumDevs")

  Loop %NumPorts%
  {
    result := DllCall("winmm.dll\midiOutGetDevCaps", "Uint",A_Index - 1, "Ptr",&MidiOutCaps, "Uint",midisize)
    If (result)
    {
      List .= "|-Error-"
      Continue
    }
    PortName := StrGet(&MidiOutCaps + 8, offsetWordStr)
    List .= "|" PortName
  }

  Return SubStr(List,2)
}

; At the beginning to load, at the end to unload winmm.dll
OpenCloseMidiAPI()
{
  static hModule
  If hModule
  DllCall("FreeLibrary", UInt,hModule), hModule := ""
  If (0 = hModule := DllCall("LoadLibrary",Str,"winmm.dll"))
  {
    MsgBox Cannot load libray winmm.dll
    Exit
  }
}

; Functions for sending short messages
midiOutOpen(uDeviceID = 0)
{
  ; Open midi port for sending individual midi messages --> handle
  strh_midiout = 0000
  result := DllCall("winmm.dll\midiOutOpen", UInt,&strh_midiout, UInt,uDeviceID, UInt,0, UInt,0, UInt,0, UInt)
  If (result or ErrorLevel)
  {
    MsgBox There was an Error opening the midi port.`nError code %result%`nErrorLevel = %ErrorLevel%
    Return -1
  }
  Return UInt@(&strh_midiout)
}

; All midi sent to the output midi port - calls this function
midiOutShortMsg(h_midiout, MidiStatus, Param1, Param2)
{
  result := DllCall("winmm.dll\midiOutShortMsg", UInt,h_midiout, UInt, MidiStatus|(Param1<<8)|(Param2<<16), UInt)
  If (result or ErrorLevel)
  {
    MsgBox There was an Error Sending the midi event: (%result%`, %ErrorLevel%)
    Return -1
  }
}

; Close MidiOutput
midiOutClose(h_midiout)
{
  Loop 9
  {
    result := DllCall("winmm.dll\midiOutClose", UInt,h_midiout)
    If !(result or ErrorLevel)
    Return
    Sleep 250
  }
  MsgBox Error in closing the midi output port. There may still be midi events being Processed.
  Return -1
}

; Get number of midi output devices on system, first device has an ID of 0
MidiOutGetNumDevs()
{
  Return DllCall("winmm.dll\midiOutGetNumDevs")
}

; Get name of a midiOut device for a given ID
MidiOutNameGet(uDeviceID = 0)
{
  VarSetCapacity(MidiOutCaps, 50, 0) ; allows for szPname to be 32 bytes
  OffsettoPortName := 8, PortNameSize := 32
  result := DllCall("winmm.dll\midiOutGetDevCapsA", UInt,uDeviceID, UInt,&MidiOutCaps, UInt,50, UInt)
  If (result OR ErrorLevel)
  {
    MsgBox Error %result% (ErrorLevel = %ErrorLevel%) in retrieving the name of midi output %uDeviceID%
    Return -1
  }
  VarSetCapacity(PortName, PortNameSize)
  DllCall("RtlMoveMemory", Str,PortName, Uint,&MidiOutCaps+OffsettoPortName, Uint,PortNameSize)
  Return PortName
}

; Returns number of midi output devices, creates global array MidiOutPortName with their names
MidiOutsEnumerate()
{
  local NumPorts, PortID
  MidiOutPortName =
  NumPorts := MidiOutGetNumDevs()
  Loop %NumPorts%
  {
    PortID := A_Index -1
    MidiOutPortName%PortID% := MidiOutNameGet(PortID)
  }
  Return NumPorts
}

; Helper functions
UInt@(ptr)
{
  Return *ptr | *(ptr+1) << 8 | *(ptr+2) << 16 | *(ptr+3) << 24
}

; Windows 2000 and later
PokeInt(p_value, p_address)
{
  DllCall("ntdll\RtlFillMemoryUlong", UInt,p_address, UInt,4, UInt,p_value)
}

; Midi in port handling - Returns a "|"-separated list of midi output devices
MidiInsList(ByRef NumPorts)
{
  local List, MidiInCaps, PortName, result, midisize
  (A_IsUnicode)? offsetWordStr := 64: offsetWordStr := 32
  midisize := offsetWordStr + 18
  VarSetCapacity(MidiInCaps, midisize, 0)
  VarSetCapacity(PortName, offsetWordStr) ; PortNameSize 32

  NumPorts := DllCall("winmm.dll\midiInGetNumDevs") ; #midi output devices on system, First device ID 0

  Loop %NumPorts%
  {
    result := DllCall("winmm.dll\midiInGetDevCaps", "UInt",A_Index-1, "Ptr",&MidiInCaps, "UInt",midisize)
    If (result OR ErrorLevel)
    {
      List .= "|-Error-"
      Continue
    }
    PortName := StrGet(&MidiInCaps + 8, offsetWordStr)
    List .= "|" PortName
  }
  Return SubStr(List,2)
}

; Get number of midi output devices on system, first device has an ID of 0
MidiInGetNumDevs()
{
  Return DllCall("winmm.dll\midiInGetNumDevs")
}

; Get name of a midiOut device for a given ID
MidiInNameGet(uDeviceID = 0)
{
  VarSetCapacity(MidiInCaps, 50, 0) ; allows for szPname to be 32 bytes
  OffsettoPortName := 8, PortNameSize := 32
  result := DllCall("winmm.dll\midiInGetDevCapsA", UInt,uDeviceID, UInt,&MidiInCaps, UInt,50, UInt)
  If (result OR ErrorLevel)
  {
    MsgBox Error %result% (ErrorLevel = %ErrorLevel%) in retrieving the name of midi Input %uDeviceID%
    Return -1
  }
  VarSetCapacity(PortName, PortNameSize)
  DllCall("RtlMoveMemory", Str,PortName, Uint,&MidiInCaps+OffsettoPortName, Uint,PortNameSize)
  Return PortName
}

; Returns number of midi output devices, creates global array MidiOutPortName with their names
MidiInsEnumerate()
{
  local NumPorts, PortID
  MidiInPortName =
  NumPorts := MidiInGetNumDevs()
  Loop %NumPorts%
  {
    PortID := A_Index -1
    MidiInPortName%PortID% := MidiInNameGet(PortID)
  }
  Return NumPorts
}

; ----------------------------------------------
; other functions
; ----------------------------------------------

; send key
SendKey(num, key1, key2, currentmode="Default", multi=1, mod1="none", mod2="none")
{
  if (mode == currentmode)
  {
    IfEqual, number, %num%
    {
      if value between 120 and 127
      {
        datanew := (128-value)*multi
        if (mod1 == "none")
        SendInput {%key1% %datanew%}
        if (mod1 <> "none" && mod2 == "none")
        SendInput {%mod1% down}{%key1% %datanew%}{%mod1% up}
        if (mod1 <> "none" && mod2 <> "none")
        SendInput {%mod2% down}{%mod1% down}{%key1% %datanew%}
      }
      if value between 1 and 10
      {
        datanew := (value)*multi
        if (mod1 == "none")
        SendInput {%key2% %datanew%}
        if (mod1 <> "none" && mod2 == "none")
        SendInput {%mod1% down}{%key2% %datanew%}{%mod1% up}
        if (mod1 <> "none" && mod2 <> "none")
        SendInput {%mod2% down}{%mod1% down}{%key2% %datanew%}
      }
    }
  }
}

; send code
SendCode(num, keycode1, keycode2, currentmode="Default", multi=1)
{
  ;MsgBox %currentmode% %mode%
  if (mode == currentmode)
  {
    ;Msgbox %mode%
    IfEqual, number, %num%
    {
      if value between 120 and 127
      {
        datanew := (128-value)*multi
        Loop %datanew%
        SendInput %keycode1%
        KeyOutDisplay(number, keycode1, multi, mode)
      }

      if value between 1 and 10
      {
        datanew := (value)*multi

        Loop %datanew%
        SendInput %keycode2%

        KeyOutDisplay(number, keycode2, multi, mode)
      }
    }
  }
}





; =============================================================================================
; HOT KEYS SECTION
; =============================================================================================

; ----------------------------------------------
; USER HOT KEYS
; ----------------------------------------------

!^s::
{
    Reload
} Return

!^m::
{
    GoSub, MidiMonitor
} Return

^Esc::
{
    Suspend
} Return

;joystick velocity
Joy9:: ;L3 button
Loop
{
    GetKeyState, b5, Joy5 ;L1
    if b5 = D
        Return
    Sleep, 10
    GetKeyState, joyy, JoyY 
    Vel := 127 - Floor(joyy)
    
} Return

;joystick pitchbend (still not working)
Joy7:: ;what button
Loop
{
    GetKeyState, b5, Joy5 ;L1
    if b5 = D
        Return
    Sleep, 10
    GetKeyState, joyy, JoyY 
    statusbyte := OxE0 ; pitchbend
    pitchbend := Floor(8192 - (joyy/100 * 8192 * 2))  ;-8192 ~ 8192
    note := pitchbend & 0xFF ;LSBl (??? I dont know how to bit calc)
    vel := (pitchbend >> 7) & 0xFF ;MSB
    MsgBox, %note% %vel%
    gosub, SendNote
} Return

; transpose
Left::
{
    note_lowest -= 1
} Return
Right::
{
    note_lowest += 1
} Return

; NoteOn (generated by generate_hotkey.py )
; simulating button accordion c system
$F2:: 
    If (A_PriorHotKey != A_ThisHotKey){
        note := note_lowest + 4
        statusbyte = 144        ; NOTE ON MESSAGE
        gosub, SendNote
    }Return
$F2 up::
    If (A_PriorHotKey != A_ThisHotKey){
        note := note_lowest + 4
        statusbyte = 128        ; NOTE OFF MESSAGE
        gosub, SendNote
    }Return
$F3::
    If (A_PriorHotKey != A_ThisHotKey){
        note := note_lowest + 7
        statusbyte = 144        ; NOTE ON MESSAGE
        gosub, SendNote
    }Return
$F3 up::
    If (A_PriorHotKey != A_ThisHotKey){
        note := note_lowest + 7
        statusbyte = 128        ; NOTE OFF MESSAGE
        gosub, SendNote
    }Return
$F4::
    If (A_PriorHotKey != A_ThisHotKey){
        note := note_lowest + 10
        statusbyte = 144        ; NOTE ON MESSAGE
        gosub, SendNote
    }Return
$F4 up::
    If (A_PriorHotKey != A_ThisHotKey){
        note := note_lowest + 10
        statusbyte = 128        ; NOTE OFF MESSAGE
        gosub, SendNote
    }Return
$F5::
    If (A_PriorHotKey != A_ThisHotKey){
        note := note_lowest + 13
        statusbyte = 144        ; NOTE ON MESSAGE
        gosub, SendNote
    }Return
$F5 up::
    If (A_PriorHotKey != A_ThisHotKey){
        note := note_lowest + 13
        statusbyte = 128        ; NOTE OFF MESSAGE
        gosub, SendNote
    }Return
$F6::
    If (A_PriorHotKey != A_ThisHotKey){
        note := note_lowest + 16
        statusbyte = 144        ; NOTE ON MESSAGE
        gosub, SendNote
    }Return
$F6 up::
    If (A_PriorHotKey != A_ThisHotKey){
        note := note_lowest + 16
        statusbyte = 128        ; NOTE OFF MESSAGE
        gosub, SendNote
    }Return
$F7::
    If (A_PriorHotKey != A_ThisHotKey){
        note := note_lowest + 19
        statusbyte = 144        ; NOTE ON MESSAGE
        gosub, SendNote
    }Return
$F7 up::
    If (A_PriorHotKey != A_ThisHotKey){
        note := note_lowest + 19
        statusbyte = 128        ; NOTE OFF MESSAGE
        gosub, SendNote
    }Return
$F8::
    If (A_PriorHotKey != A_ThisHotKey){
        note := note_lowest + 22
        statusbyte = 144        ; NOTE ON MESSAGE
        gosub, SendNote
    }Return
$F8 up::
    If (A_PriorHotKey != A_ThisHotKey){
        note := note_lowest + 22
        statusbyte = 128        ; NOTE OFF MESSAGE
        gosub, SendNote
    }Return
$F9::
    If (A_PriorHotKey != A_ThisHotKey){
        note := note_lowest + 25
        statusbyte = 144        ; NOTE ON MESSAGE
        gosub, SendNote
    }Return
$F9 up::
    If (A_PriorHotKey != A_ThisHotKey){
        note := note_lowest + 25
        statusbyte = 128        ; NOTE OFF MESSAGE
        gosub, SendNote
    }Return
$F10::
    If (A_PriorHotKey != A_ThisHotKey){
        note := note_lowest + 28
        statusbyte = 144        ; NOTE ON MESSAGE
        gosub, SendNote
    }Return
$F10 up::
    If (A_PriorHotKey != A_ThisHotKey){
        note := note_lowest + 28
        statusbyte = 128        ; NOTE OFF MESSAGE
        gosub, SendNote
    }Return
$F11::
    If (A_PriorHotKey != A_ThisHotKey){
        note := note_lowest + 31
        statusbyte = 144        ; NOTE ON MESSAGE
        gosub, SendNote
    }Return
$F11 up::
    If (A_PriorHotKey != A_ThisHotKey){
        note := note_lowest + 31
        statusbyte = 128        ; NOTE OFF MESSAGE
        gosub, SendNote
    }Return
$F12::
    If (A_PriorHotKey != A_ThisHotKey){
        note := note_lowest + 34
        statusbyte = 144        ; NOTE ON MESSAGE
        gosub, SendNote
    }Return
$F12 up::
    If (A_PriorHotKey != A_ThisHotKey){
        note := note_lowest + 34
        statusbyte = 128        ; NOTE OFF MESSAGE
        gosub, SendNote
    }Return

$3::
    If (A_PriorHotKey != A_ThisHotKey){
        note := note_lowest + 3
        statusbyte = 144        ; NOTE ON MESSAGE
        gosub, SendNote
    }Return
$3 up::
    If (A_PriorHotKey != A_ThisHotKey){
        note := note_lowest + 3
        statusbyte = 128        ; NOTE OFF MESSAGE
        gosub, SendNote
    }Return
$4::
    If (A_PriorHotKey != A_ThisHotKey){
        note := note_lowest + 6
        statusbyte = 144        ; NOTE ON MESSAGE
        gosub, SendNote
    }Return
$4 up::
    If (A_PriorHotKey != A_ThisHotKey){
        note := note_lowest + 6
        statusbyte = 128        ; NOTE OFF MESSAGE
        gosub, SendNote
    }Return
$5::
    If (A_PriorHotKey != A_ThisHotKey){
        note := note_lowest + 9
        statusbyte = 144        ; NOTE ON MESSAGE
        gosub, SendNote
    }Return
$5 up::
    If (A_PriorHotKey != A_ThisHotKey){
        note := note_lowest + 9
        statusbyte = 128        ; NOTE OFF MESSAGE
        gosub, SendNote
    }Return
$6::
    If (A_PriorHotKey != A_ThisHotKey){
        note := note_lowest + 12
        statusbyte = 144        ; NOTE ON MESSAGE
        gosub, SendNote
    }Return
$6 up::
    If (A_PriorHotKey != A_ThisHotKey){
        note := note_lowest + 12
        statusbyte = 128        ; NOTE OFF MESSAGE
        gosub, SendNote
    }Return
$7::
    If (A_PriorHotKey != A_ThisHotKey){
        note := note_lowest + 15
        statusbyte = 144        ; NOTE ON MESSAGE
        gosub, SendNote
    }Return
$7 up::
    If (A_PriorHotKey != A_ThisHotKey){
        note := note_lowest + 15
        statusbyte = 128        ; NOTE OFF MESSAGE
        gosub, SendNote
    }Return
$8::
    If (A_PriorHotKey != A_ThisHotKey){
        note := note_lowest + 18
        statusbyte = 144        ; NOTE ON MESSAGE
        gosub, SendNote
    }Return
$8 up::
    If (A_PriorHotKey != A_ThisHotKey){
        note := note_lowest + 18
        statusbyte = 128        ; NOTE OFF MESSAGE
        gosub, SendNote
    }Return
$9::
    If (A_PriorHotKey != A_ThisHotKey){
        note := note_lowest + 21
        statusbyte = 144        ; NOTE ON MESSAGE
        gosub, SendNote
    }Return
$9 up::
    If (A_PriorHotKey != A_ThisHotKey){
        note := note_lowest + 21
        statusbyte = 128        ; NOTE OFF MESSAGE
        gosub, SendNote
    }Return
$0::
    If (A_PriorHotKey != A_ThisHotKey){
        note := note_lowest + 24
        statusbyte = 144        ; NOTE ON MESSAGE
        gosub, SendNote
    }Return
$0 up::
    If (A_PriorHotKey != A_ThisHotKey){
        note := note_lowest + 24
        statusbyte = 128        ; NOTE OFF MESSAGE
        gosub, SendNote
    }Return
$-::
    If (A_PriorHotKey != A_ThisHotKey){
        note := note_lowest + 27
        statusbyte = 144        ; NOTE ON MESSAGE
        gosub, SendNote
    }Return
$- up::
    If (A_PriorHotKey != A_ThisHotKey){
        note := note_lowest + 27
        statusbyte = 128        ; NOTE OFF MESSAGE
        gosub, SendNote
    }Return
$^::
    If (A_PriorHotKey != A_ThisHotKey){
        note := note_lowest + 30
        statusbyte = 144        ; NOTE ON MESSAGE
        gosub, SendNote
    }Return
$^ up::
    If (A_PriorHotKey != A_ThisHotKey){
        note := note_lowest + 30
        statusbyte = 128        ; NOTE OFF MESSAGE
        gosub, SendNote
    }Return
$sc073::
    If (A_PriorHotKey != A_ThisHotKey){
        note := note_lowest + 33
        statusbyte = 144        ; NOTE ON MESSAGE
        gosub, SendNote
    }Return
$sc073 up::
    If (A_PriorHotKey != A_ThisHotKey){
        note := note_lowest + 33
        statusbyte = 128        ; NOTE OFF MESSAGE
        gosub, SendNote
    }Return
$w::
    If (A_PriorHotKey != A_ThisHotKey){
        note := note_lowest + 2
        statusbyte = 144        ; NOTE ON MESSAGE
        gosub, SendNote
    }Return
$w up::
    If (A_PriorHotKey != A_ThisHotKey){
        note := note_lowest + 2
        statusbyte = 128        ; NOTE OFF MESSAGE
        gosub, SendNote
    }Return
$e::
    If (A_PriorHotKey != A_ThisHotKey){
        note := note_lowest + 5
        statusbyte = 144        ; NOTE ON MESSAGE
        gosub, SendNote
    }Return
$e up::
    If (A_PriorHotKey != A_ThisHotKey){
        note := note_lowest + 5
        statusbyte = 128        ; NOTE OFF MESSAGE
        gosub, SendNote
    }Return
$r::
    If (A_PriorHotKey != A_ThisHotKey){
        note := note_lowest + 8
        statusbyte = 144        ; NOTE ON MESSAGE
        gosub, SendNote
    }Return
$r up::
    If (A_PriorHotKey != A_ThisHotKey){
        note := note_lowest + 8
        statusbyte = 128        ; NOTE OFF MESSAGE
        gosub, SendNote
    }Return
$t::
    If (A_PriorHotKey != A_ThisHotKey){
        note := note_lowest + 11
        statusbyte = 144        ; NOTE ON MESSAGE
        gosub, SendNote
    }Return
$t up::
    If (A_PriorHotKey != A_ThisHotKey){
        note := note_lowest + 11
        statusbyte = 128        ; NOTE OFF MESSAGE
        gosub, SendNote
    }Return
$y::
    If (A_PriorHotKey != A_ThisHotKey){
        note := note_lowest + 14
        statusbyte = 144        ; NOTE ON MESSAGE
        gosub, SendNote
    }Return
$y up::
    If (A_PriorHotKey != A_ThisHotKey){
        note := note_lowest + 14
        statusbyte = 128        ; NOTE OFF MESSAGE
        gosub, SendNote
    }Return
$u::
    If (A_PriorHotKey != A_ThisHotKey){
        note := note_lowest + 17
        statusbyte = 144        ; NOTE ON MESSAGE
        gosub, SendNote
    }Return
$u up::
    If (A_PriorHotKey != A_ThisHotKey){
        note := note_lowest + 17
        statusbyte = 128        ; NOTE OFF MESSAGE
        gosub, SendNote
    }Return
$i::
    If (A_PriorHotKey != A_ThisHotKey){
        note := note_lowest + 20
        statusbyte = 144        ; NOTE ON MESSAGE
        gosub, SendNote
    }Return
$i up::
    If (A_PriorHotKey != A_ThisHotKey){
        note := note_lowest + 20
        statusbyte = 128        ; NOTE OFF MESSAGE
        gosub, SendNote
    }Return
$o::
    If (A_PriorHotKey != A_ThisHotKey){
        note := note_lowest + 23
        statusbyte = 144        ; NOTE ON MESSAGE
        gosub, SendNote
    }Return
$o up::
    If (A_PriorHotKey != A_ThisHotKey){
        note := note_lowest + 23
        statusbyte = 128        ; NOTE OFF MESSAGE
        gosub, SendNote
    }Return
$p::
    If (A_PriorHotKey != A_ThisHotKey){
        note := note_lowest + 26
        statusbyte = 144        ; NOTE ON MESSAGE
        gosub, SendNote
    }Return
$p up::
    If (A_PriorHotKey != A_ThisHotKey){
        note := note_lowest + 26
        statusbyte = 128        ; NOTE OFF MESSAGE
        gosub, SendNote
    }Return
$@::
    If (A_PriorHotKey != A_ThisHotKey){
        note := note_lowest + 29
        statusbyte = 144        ; NOTE ON MESSAGE
        gosub, SendNote
    }Return
$@ up::
    If (A_PriorHotKey != A_ThisHotKey){
        note := note_lowest + 29
        statusbyte = 128        ; NOTE OFF MESSAGE
        gosub, SendNote
    }Return
$[::
    If (A_PriorHotKey != A_ThisHotKey){
        note := note_lowest + 32
        statusbyte = 144        ; NOTE ON MESSAGE
        gosub, SendNote
    }Return
$[ up::
    If (A_PriorHotKey != A_ThisHotKey){
        note := note_lowest + 32
        statusbyte = 128        ; NOTE OFF MESSAGE
        gosub, SendNote
    }Return
$a::
    If (A_PriorHotKey != A_ThisHotKey){
        note := note_lowest + 1
        statusbyte = 144        ; NOTE ON MESSAGE
        gosub, SendNote
    }Return
$a up::
    If (A_PriorHotKey != A_ThisHotKey){
        note := note_lowest + 1
        statusbyte = 128        ; NOTE OFF MESSAGE
        gosub, SendNote
    }Return
$s::
    If (A_PriorHotKey != A_ThisHotKey){
        note := note_lowest + 4
        statusbyte = 144        ; NOTE ON MESSAGE
        gosub, SendNote
    }Return
$s up::
    If (A_PriorHotKey != A_ThisHotKey){
        note := note_lowest + 4
        statusbyte = 128        ; NOTE OFF MESSAGE
        gosub, SendNote
    }Return
$d::
    If (A_PriorHotKey != A_ThisHotKey){
        note := note_lowest + 7
        statusbyte = 144        ; NOTE ON MESSAGE
        gosub, SendNote
    }Return
$d up::
    If (A_PriorHotKey != A_ThisHotKey){
        note := note_lowest + 7
        statusbyte = 128        ; NOTE OFF MESSAGE
        gosub, SendNote
    }Return
$f::
    If (A_PriorHotKey != A_ThisHotKey){
        note := note_lowest + 10
        statusbyte = 144        ; NOTE ON MESSAGE
        gosub, SendNote
    }Return
$f up::
    If (A_PriorHotKey != A_ThisHotKey){
        note := note_lowest + 10
        statusbyte = 128        ; NOTE OFF MESSAGE
        gosub, SendNote
    }Return
$g::
    If (A_PriorHotKey != A_ThisHotKey){
        note := note_lowest + 13
        statusbyte = 144        ; NOTE ON MESSAGE
        gosub, SendNote
    }Return
$g up::
    If (A_PriorHotKey != A_ThisHotKey){
        note := note_lowest + 13
        statusbyte = 128        ; NOTE OFF MESSAGE
        gosub, SendNote
    }Return
$h::
    If (A_PriorHotKey != A_ThisHotKey){
        note := note_lowest + 16
        statusbyte = 144        ; NOTE ON MESSAGE
        gosub, SendNote
    }Return
$h up::
    If (A_PriorHotKey != A_ThisHotKey){
        note := note_lowest + 16
        statusbyte = 128        ; NOTE OFF MESSAGE
        gosub, SendNote
    }Return
$j::
    If (A_PriorHotKey != A_ThisHotKey){
        note := note_lowest + 19
        statusbyte = 144        ; NOTE ON MESSAGE
        gosub, SendNote
    }Return
$j up::
    If (A_PriorHotKey != A_ThisHotKey){
        note := note_lowest + 19
        statusbyte = 128        ; NOTE OFF MESSAGE
        gosub, SendNote
    }Return
$k::
    If (A_PriorHotKey != A_ThisHotKey){
        note := note_lowest + 22
        statusbyte = 144        ; NOTE ON MESSAGE
        gosub, SendNote
    }Return
$k up::
    If (A_PriorHotKey != A_ThisHotKey){
        note := note_lowest + 22
        statusbyte = 128        ; NOTE OFF MESSAGE
        gosub, SendNote
    }Return
$l::
    If (A_PriorHotKey != A_ThisHotKey){
        note := note_lowest + 25
        statusbyte = 144        ; NOTE ON MESSAGE
        gosub, SendNote
    }Return
$l up::
    If (A_PriorHotKey != A_ThisHotKey){
        note := note_lowest + 25
        statusbyte = 128        ; NOTE OFF MESSAGE
        gosub, SendNote
    }Return
$sc027::
    If (A_PriorHotKey != A_ThisHotKey){
        note := note_lowest + 28
        statusbyte = 144        ; NOTE ON MESSAGE
        gosub, SendNote
    }Return
$sc027 up::
    If (A_PriorHotKey != A_ThisHotKey){
        note := note_lowest + 28
        statusbyte = 128        ; NOTE OFF MESSAGE
        gosub, SendNote
    }Return
$sc028::
    If (A_PriorHotKey != A_ThisHotKey){
        note := note_lowest + 31
        statusbyte = 144        ; NOTE ON MESSAGE
        gosub, SendNote
    }Return
$sc028 up::
    If (A_PriorHotKey != A_ThisHotKey){
        note := note_lowest + 31
        statusbyte = 128        ; NOTE OFF MESSAGE
        gosub, SendNote
    }Return
$Shift::
    If (A_PriorHotKey != A_ThisHotKey){
        note := note_lowest + 0
        statusbyte = 144        ; NOTE ON MESSAGE
        gosub, SendNote
    }Return
$Shift up::
    If (A_PriorHotKey != A_ThisHotKey){
        note := note_lowest + 0
        statusbyte = 128        ; NOTE OFF MESSAGE
        gosub, SendNote
    }Return
$z::
    If (A_PriorHotKey != A_ThisHotKey){
        note := note_lowest + 3
        statusbyte = 144        ; NOTE ON MESSAGE
        gosub, SendNote
    }Return
$z up::
    If (A_PriorHotKey != A_ThisHotKey){
        note := note_lowest + 3
        statusbyte = 128        ; NOTE OFF MESSAGE
        gosub, SendNote
    }Return
$x::
    If (A_PriorHotKey != A_ThisHotKey){
        note := note_lowest + 6
        statusbyte = 144        ; NOTE ON MESSAGE
        gosub, SendNote
    }Return
$x up::
    If (A_PriorHotKey != A_ThisHotKey){
        note := note_lowest + 6
        statusbyte = 128        ; NOTE OFF MESSAGE
        gosub, SendNote
    }Return
$c::
    If (A_PriorHotKey != A_ThisHotKey){
        note := note_lowest + 9
        statusbyte = 144        ; NOTE ON MESSAGE
        gosub, SendNote
    }Return
$c up::
    If (A_PriorHotKey != A_ThisHotKey){
        note := note_lowest + 9
        statusbyte = 128        ; NOTE OFF MESSAGE
        gosub, SendNote
    }Return
$v::
    If (A_PriorHotKey != A_ThisHotKey){
        note := note_lowest + 12
        statusbyte = 144        ; NOTE ON MESSAGE
        gosub, SendNote
    }Return
$v up::
    If (A_PriorHotKey != A_ThisHotKey){
        note := note_lowest + 12
        statusbyte = 128        ; NOTE OFF MESSAGE
        gosub, SendNote
    }Return
$b::
    If (A_PriorHotKey != A_ThisHotKey){
        note := note_lowest + 15
        statusbyte = 144        ; NOTE ON MESSAGE
        gosub, SendNote
    }Return
$b up::
    If (A_PriorHotKey != A_ThisHotKey){
        note := note_lowest + 15
        statusbyte = 128        ; NOTE OFF MESSAGE
        gosub, SendNote
    }Return
$n::
    If (A_PriorHotKey != A_ThisHotKey){
        note := note_lowest + 18
        statusbyte = 144        ; NOTE ON MESSAGE
        gosub, SendNote
    }Return
$n up::
    If (A_PriorHotKey != A_ThisHotKey){
        note := note_lowest + 18
        statusbyte = 128        ; NOTE OFF MESSAGE
        gosub, SendNote
    }Return
$m::
    If (A_PriorHotKey != A_ThisHotKey){
        note := note_lowest + 21
        statusbyte = 144        ; NOTE ON MESSAGE
        gosub, SendNote
    }Return
$m up::
    If (A_PriorHotKey != A_ThisHotKey){
        note := note_lowest + 21
        statusbyte = 128        ; NOTE OFF MESSAGE
        gosub, SendNote
    }Return
$sc033::
    If (A_PriorHotKey != A_ThisHotKey){
        note := note_lowest + 24
        statusbyte = 144        ; NOTE ON MESSAGE
        gosub, SendNote
    }Return
$sc033 up::
    If (A_PriorHotKey != A_ThisHotKey){
        note := note_lowest + 24
        statusbyte = 128        ; NOTE OFF MESSAGE
        gosub, SendNote
    }Return
$.::
    If (A_PriorHotKey != A_ThisHotKey){
        note := note_lowest + 27
        statusbyte = 144        ; NOTE ON MESSAGE
        gosub, SendNote
    }Return
$. up::
    If (A_PriorHotKey != A_ThisHotKey){
        note := note_lowest + 27
        statusbyte = 128        ; NOTE OFF MESSAGE
        gosub, SendNote
    }Return
$/::
    If (A_PriorHotKey != A_ThisHotKey){
        note := note_lowest + 30
        statusbyte = 144        ; NOTE ON MESSAGE
        gosub, SendNote
    }Return
$/ up::
    If (A_PriorHotKey != A_ThisHotKey){
        note := note_lowest + 30
        statusbyte = 128        ; NOTE OFF MESSAGE
        gosub, SendNote
    }Return
