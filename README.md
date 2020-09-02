# Documentation

## Files

| File | Description |
| --- | -- |
| rules.ahk | Rules for transforming midi input to keypresses or any other output |
| hotkeys.ahk | Examples of HOTKEY generated midi messages to be output - the easy way! |
| hotkeys_alt.ahk | Examples of HOTKEY generated midi messages to be output - the BEST way! |

## MIDI Messages

Midi messages: Here is a good reference https://stackoverflow.com/questions/29481090/explanation-of-midi-messages
Example message: 10010011 00011011 0111111
Where the first byte is the status byte, 2nd byte is the data1 byte, and 3rd byte is the data 2 byte
 status        data1        data2
10010011 00011011 0111111


status | Type of message (note on/off, CC, program change... etc + the midi channel)
data1 | midi note# (for note messages), cc# (for CC messages)
data2 | midi note Velocity (for note on/off messages, CC value (for CC messages)

--------------- old readme below--------------

Generic Midi App - renamed from Generic Midi Program
  Basic structural framework for a midi program in ahk.
  The description of what this is for is contained in the first post on the topic Midi Input/Output Combined at the ahk forum.
  Please read it, if you want to know more.
  I have added a few more examples for different midi data types as well as more, meaningful (I hope), documentation to the script.
  You are strongly encouraged to visit http://www.midi.org/techspecs/midimessages.php (decimal values), to learn more
  about midi data.  It will help you create your own midi rules.

  I have combined much of the work of others here.
  You will need to create your own midi rules;
    By creating or modifying if statements in the section of the rules.ahk file.
    By creating hotkeys that generate midi messages in the hotkeyTOmidi.ahk file.

  I don't claim to be an expert on this, just a guy who pulled disparate things together.
  I really need help from someone to add sysex functionality.

  * Notes - All midi in/out lib stuff is included in Midi_In_Out_Lib.ahk, besides winmm.dll (part of windows).
*/
