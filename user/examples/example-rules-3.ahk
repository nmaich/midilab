rules:



; Get foreground application

WinGet, application, ProcessName, A
inc := value
dec := 128-value
type := type
ccnum := number

;MsgBox, %application%



; Define global vars for functions

global change, number, type



; Defince helper vars or functions

if value between 1 and 10
{
  change = "positive"
}

if value between 120 and 127
{
  change = "negative"
}



; Process note-on messages

if type = "noteon"
{
  ; No rules set
}



; Process note-off messages

if type = "noteoff"
{
  MidiInDisplay(%type%, %statusbyte%, %chan%, %number%, %value%)  ; display note off in gui
}



; Process cc messages

if type = "cc"
{



  ;Only if Ableton Live 10 active

  if application = Ableton Live 10 Suite.exe
  {

    SendKey(50, "Left", "Right")

    SendKey(51, "Up", "Down")

  }



  ; Any Application except Live 10

  if application != Ableton Live 10 Suite.exe
  {

    ; Only when all modifier keys are off, process these commands

    if !getKeyState("Ctrl") and !getKeyState("Alt") and !getKeyState("Shift")

    {

      ; Complex rules for multi key combinations

      SendCode(22,"+{Left}","+{Right}")

      SendCode(23,"+{Up}","+{Down}")

;
;       if ccnum = 23
;       {
;
;         if change = "negative"
;         {
;           SendInput {Shift down}{Up %dec%}{Shift up}
;         }
;
;         if change = "positive"
;         {
;           SendInput {Shift down}{Down %inc%}{Shift up}
;         }
;
;       }

      SendCode(26,"!{Up}", "{Enter}")


/*

      if ccnum = 26
      {

        if change = "negative"
        {
          SendInput {Alt down}{Up %dec%}{Alt up}
        }

        if change = "positive"
        {
          SendInput {Enter}
        }

      }

*/

      ; Simple rules for single key macros
      ; cc, key1, key2, repeat-keypress

      SendKey(24, "Up", "Down", 8)

      SendKey(25, "WheelUp", "WheelDown", 2)

      SendKey(50, "Left", "Right")

      SendKey(51, "Up", "Down")

      SendCode(33, "{Left}", "{Right}")

    }

    ; Only when modifiers key Ctrl is on

    if getKeyState("Shift") and !getKeyState("Ctrl")
    {

      if ccnum = 50
      {

        if change = "negative"
        {
          SendInput {Shift down}{Left %dec%}
        }

        if change = "positive"
        {
          SendInput {Shift down}{Right %inc%}
        }

      }

      if ccnum = 51
      {

        if change = "negative"
        {
          SendInput {Shift down}{Up %dec%}
        }

        if change = "positive"
        {
          SendInput {Shift down}{Down %inc%}
        }

      }

    }

    if getKeyState("Ctrl") and getKeyState("Shift")
    {

      SendKey(50, "Left", "Right", 1, "Ctrl", "Shift")

    }


    if getKeyState("Ctrl") and !getKeyState("Shift")
    {

      SendKey(50, "Left", "Right", 1, "Ctrl")

      SendCode(33, "^+{Left}", "^+{Right}")

      SendCode(22, "{Ctrl down}{Shift down}{Tab}{Shift up}", "{Ctrl down}{Tab}")

    }

    ; Only when modifier key Alt is on

    if getKeyState("Alt")
    {

      SendCode(22, "{Alt down}{Shift down}{Tab}{Shift up}", "{Alt down}{Tab}")

    }


  } ; End application filter

} ; End statusbyte cc

Return
