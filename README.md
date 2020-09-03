# Documentation

## Introduction

Midilab is an application written in Autohotkey, that gives you the ability to remap MIDI messages to keystrokes, mouse clicks or mousewheel turns. It's not limited to theses things though. The full power of AHK can be used to transform MIDI input. Be creative.

It also gives you the ability to send MIDI messages by pressing keys on your keyboard or using your mouse or any other HID device. This is a very powerful library, but with rather poor documentation and structure. My aim is to make it universally useful by cleaning up the code and reviving the project.

If you are interested in contributing (this also goes out to the original creator of this project) please go ahead and create a commit, pull request or just ping me on github or by email. I'm happy to receive any support necessary to lift this project to new heights.

## Files

Let's start with a list of files and their purpose.

| File | Description |
| --- | -- |
| rules.ahk | Rules for transforming MIDI input to keypresses or any other output |
| hotkeys.ahk | Examples of hotkey generated MIDI messages to be output - the easy way! |
| hotkeys_alt.ahk | Examples of hotkey generated MIDI messages to be output - the best way! |

## MIDI Messages

References:
- https://stackoverflow.com/questions/29481090/explanation-of-MIDI-messages
- http://www.MIDI.org/techspecs/MIDImessages.php

First parameter is the status byte, 2nd parameter is the data1 byte, and 3rd parameter is the data2 byte

### Example message

| status | data1 | data2 |
|---|---|---|
| 10010011 | 00011011 | 0111111 |

### Parameters explained

| Parameter | Description |
| -- | -- |
| status | Type of message (note on/off, CC, program change... + the MIDI channel) |
| data1 | MIDI note number (for note messages), cc number (for CC messages) |
| data2 | MIDI note velocity (for note on/off messages, cc value (for cc messages) |

## Rules


This section deals with transforming incoming MIDI messages. This means: noteons, noteoffs, continuous controllers (cc) and program change (pc) messages. You can transform the midi input to keystrokes like a macro or transform the midi input to other type of MIDI output. Both are possible in the same script. This script does not, currently, pass the original midi messsage out.

There are a few ways to handle transformations. Set up a filter to detect correct type and data1 val - then run commands or set up filter after type filter (NoteOn, NoteOff, CC or PC). Keep rules together under the proper section, notes, cc, program change etc. Keep them after the statusbyte has been determined. Examples for each type of rule are present.

### Status

statusbyte between 128 and 143 ARE NOTE OFF'S
statusbyte between 144 and 159 ARE NOTE ON'S
statusbyte between 176 and 191 ARE CONTINUOS CONTROLLERS
statusbyte between 192 and 208  ARE PROGRAM CHANGE for data1 values

### Helpers

| status | data1 | data2 |
| - | - | - |
| note on/off | note number | note velocity |
| continuous controller | cc number | cc value |
| program change | pc number | ignored |

### Example code

~~~
ifequal, data1, 20  #if the note number coming in is note # 20
{
  data1 := 21  #shift the note up
  gosub, SendNote  #then send the note out
}
~~~

## Old readme

*This information is deprecated but kept as a reference to older versions.*

Generic MIDI App - renamed from Generic MIDI Program Basic structural framework for a MIDI program in ahk. The description of what this is for is contained in the first post on the topic MIDI Input/Output Combined at the ahk forum. Please read it, if you want to know more. I have added a few more examples for different MIDI data types as well as more, meaningful (I hope), documentation to the script. You are strongly encouraged to visit http://www.MIDI.org/techspecs/MIDImessages.php (decimal values), to learn more about MIDI data.  It will help you create your own MIDI rules.

I have combined much of the work of others here. You will need to create your own MIDI rules; By creating or modifying if statements in the section of the rules.ahk file. By creating hotkeys that generate MIDI messages in the hotkeyTOMIDI.ahk file.  I don't claim to be an expert on this, just a guy who pulled disparate things together. I really need help from someone to add sysex functionality.  Notes - All MIDI in/out lib stuff is included in MIDI_In_Out_Lib.ahk, besides winmm.dll (part of windows).
