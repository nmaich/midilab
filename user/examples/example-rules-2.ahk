rules:



; Get foreground application

WinGet, application, ProcessName, A
inc := value
dec := 128-value
type := type
ccnum := number

;MsgBox, %application%



; Define global vars for functions

global cc, number, type



; Defince helper vars or functions

if value between 1 and 10
{
  cc = "positive"
}

if value between 120 and 127
{
  cc = "negative"
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

      if ccnum = 22
      {

        if cc = "negative"
        {
          SendInput {Shift down}{Left %dec%}{Shift up}
        }

        if cc = "positive"
        {
          SendInput {Shift down}{Right %inc%}{Shift up}
        }

      }

      if ccnum = 23
      {

        if cc = "negative"
        {
          SendInput {Shift down}{Up %dec%}{Shift up}
        }

        if cc = "positive"
        {
          SendInput {Shift down}{Down %inc%}{Shift up}
        }

      }

      if ccnum = 26
      {

        if cc = "negative"
        {
          SendInput {Alt down}{Up %dec%}{Alt up}
        }

        if cc = "positive"
        {
          SendInput {Enter}
        }

      }

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

        if cc = "negative"
        {
          SendInput {Shift down}{Left %dec%}
        }

        if cc = "positive"
        {
          SendInput {Shift down}{Right %inc%}
        }

      }

      if ccnum = 51
      {

        if cc = "negative"
        {
          SendInput {Shift down}{Up %dec%}
        }

        if cc = "positive"
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

/*

      if ccnum = 22
      {

        if cc = "negative"
        {
          SendInput {Ctrl down}{Shift down}{Tab %dec%}{Shift up}
        }

        if cc = "positive"
        {
          SendInput {Ctrl down}{Tab %inc%}
        }

      }

*/

    }

    ; Only when modifier key Alt is on

    if getKeyState("Alt")
    {

      if ccnum = 22
      {

        if cc = "negative"
        {
          SendInput {Alt down}{Shift down}{Tab %dec%}{Shift up}
        }

        if cc = "positive"
        {
          SendInput {Alt down}{Tab %inc%}
        }

      }

    }


  } ; End application filter

} ; End statusbyte cc

Return
