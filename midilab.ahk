
Menu, Tray, Icon, C:\Tools\AHK\Icons\Rocket.ico
#Persistent
#SingleInstance , force         	                                                    ; Only run one instance
SendMode Input                              	                                ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%

; Ensures a consistent starting directory.
if A_OSVersion in WIN_NT4,WIN_95,WIN_98,WIN_ME  ; If not Windows XP or greater, quit program
{
  MsgBox This script requires Windows 2000/XP or later.
  ExitApp
}

;*************************************************
version = midilab  ; Version name and number
;*************************************************
readini()                                            ; Load values from the ini file, via the readini function - see Midi_In_Out_Lib.ahk file
gosub, MidiPortRefresh                  ; used to refresh the input and output port lists - see Midi_In_Out_Lib.ahk file
port_test(numports,numports2)   ; test the ports - check for valid ports? - see Midi_In_Out_Lib.ahk file
gosub, midiin_go                            ; opens the midi input port listening routine see Midi_In_Out_Lib.ahk file
gosub, midiout                               ; opens the midi out port see Midi_In_Out_Lib.ahk file
; gosub, midiMon                             ; see below - a monitor gui - see Midi_In_Out_Lib.ahk file  COMMENT THIS OUT IF YOU DON'T WANT DISPLAY
gosub, dev

;*************************************************
;*         VARIBLES TO SET @ STARTUP
;*************************************************

; =============== varibles below are for keyboard cc
channel = 1        ; default channel =1
CC_num = 7         ; CC
CCIntVal = 0       ; Default zero for  CC  (data byte 2)
CCIntDelta = 1     ; Amount to change CC (data byte 2)

/*
  yourVar = 0
  yourVarDelta = 3
  yourVarCCnum = 1 ; modwheel
*/

;*****************************************************************
;   SETTIMER BELOW - ONLY USED WITH hotkeys_alt METHOD
;*****************************************************************
/*
 TODO Make .ini entry for this label - for use with hotkey2midi_2 method only to write it might need a gui too????
*/
;settimer, KeyboardCCs, 50 ; KeyBoardCCs is located in HotKeyTOMidi2.ahk > timer (loop of code) to run the KeyboardCCs at the 70ms interval
; settimer, rules, 70 ; does not seem to work  not needed called during onmessage detect

;*****************************************************************
;   XYMOUSE AND JOYSTICK ROUTINES - NOT USED AT THIS TIME
;*****************************************************************
;gosub, go_xymouse   ; loads the xy mouse  - only use if needed.... maybe make a switch for this?

return ;  Ends autoexec section
;*************************************************
;*          END OF AUTOEXEC SECTION
;*************************************************

;*************************************************
;*          SEND MIDI OUTPUT BASED ON TYPE
;*************************************************

/*
  Questions here - leave these labels and methods or
  have them be part of each rule created - have it send the message by the function call or call these labels
  - make the gui a function call instead of a label and use the same vars that are passed to output function...

*/

;*****************************************************************
;   SEND OUT MIDI CONTIOUS CONTROLLERS - CC'S
;*****************************************************************

RelayCC: ; ===============THIS FOR RELAYING CC'S OR TRANSLATING MIDI CC'S
type := "CC"                                                                                               ; Only used in the midi display - has nothing to do with message output
MidiOutDisplay(type, statusbyte, chan , CC_num, value)                      ; update the midimonitor gui
midiOutShortMsg(h_midiout, (Channel+175), CC_num, CCIntVal)   ; SEND OUT THE MESSAGE > function located in Midi_In_Out_Lib.ahk;MsgBox, 0, ,sendcc triggered , 1 ; for testing purposes only
Return

SendCC: ; ===============use this for converting keypress into midi message
midiOutShortMsg(h_midiout, (Channel+175), CC_num, CCIntVal) ; SEND OUT THE MESSAGE > function located in Midi_In_Out_Lib.ahk
; =============== set vars for display only ;  get these to be the same vars as midi send messages
type := "CC"
statusbyte := (Channel+174)
number = %CC_num%			; set value of the number to the above cc_num for display on the midi out window (only needed if you want to see output)
value = %CCIntVal%
MidiOutDisplay(type, statusbyte, channel, number, value) ; ; update the midimonitor gui
;MsgBox, 0, ,sendcc triggered , 1 ; for testing purposes only
Return

RelayNote:   ;(h_midiout,Note) ; send out note messages ; this should probably be a funciton but... eh
midiOutShortMsg(h_midiout, statusbyte, number, value) ; call the midi funcitons with these params.
type := "NoteOn"
MidiOutDisplay(type, statusbyte, chan, number, value)
Return

SendNote:   ;(h_midiout,Note) ; send out note messages ; this should probably be a funciton but... eh
note = %number%                                      ; this var is added to allow transpostion of a note
vel = %value%
midiOutShortMsg(h_midiout, statusbyte, note, vel) ; call the midi funcitons with these params.
type := "NoteOn"
statusbyte := 144
chan 	= %channel%
number = %Note%			; set value of the number to the above cc_num for display on the midi out window (only needed if you want to see output)
value = %Vel%
MidiOutDisplay(type, statusbyte, chan, number, value)
Return

SendPC: ; Send a progam change message - value is ignored - I think...
midiOutShortMsg(h_midiout, (Channel+191), pc, value)
type := "PC"
statusbyte := 192
chan 	= %channel%
number = %PC%			; set value of the number to the above cc_num for display on the midi out window (only needed if you want to see output)
value =
MidiOutDisplay(type, statusbyte, chan, number, value)
Return

/*
   Method could be developed for other midi messages like after touch...etc.
 */
;*************************************************
;*              INCLUDE FILES -
;*  these files need to be in the same folder
;*************************************************
#Include core.ahk       ; this file replaced the midi in out lib below - for now
#Include rules.ahk              ; this file contains: Rules for manipulating midi input then sending modified midi output.
#Include dev.ahk

;#Include hotkeys.ahk         ; this file contains: examples of HOTKEY generated midi messages to be output - the easy way!
;#Include hotkeys_alt.ahk         ; this file contains: examples of HOTKEY generated midi messages to be output - the BEST way!
;#include joystuff.ahk              ; this file contains: joystick stuff.
;#include xy_mouse.ahk
