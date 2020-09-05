rules:



; Get foreground application

WinGet, application, ProcessName, A

;MsgBox, %application%




; Process note-on messages

if statusbyte between 144 and 159
{
  ; No rules set
}



; Process note-off messages

if statusbyte between 128 and 143
{
  MidiInDisplay(%stb%, %statusbyte%, %chan%, %data1%, %data2%)  ; display note off in gui
}



; Process cc messages

if statusbyte between 176 and 191
{



  ;Only if Ableton Live 10 active

  if application = Ableton Live 10 Suite.exe
  {

    SendKey(50, "Left", "Right", data1, data2)

    SendKey(51, "Up", "Down", data1, data2)

  }



  ; Any Application except Live 10

  if application != Ableton Live 10 Suite.exe
  {

    ; Only when all modifier keys are off, process these commands

    if !getKeyState("LCtrl", "P") and !getKeyState("LAlt", "P") and !getKeyState("Shift", "P")

    {

      ; Complex rules for multi key combinations

      IfEqual, data1, 22
      {

        if data2 between 1 and 10
        {
          SendInput {Shift down}{Right %data2%}{Shift up}
        }

        if data2 between 120 and 127
        {
          datanew := 128-data2
          SendInput {Shift down}{Left %datanew%}{Shift up}
        }

      }

      IfEqual, data1, 23
      {

        if data2 between 1 and 10
        {
          SendInput {Shift down}{Down %data2%}{Shift up}
        }

        if data2 between 120 and 127
        {
          datanew := 128-data2
          SendInput {Shift down}{Up %datanew%}{Shift up}
        }

      }

      IfEqual, data1, 26
      {

        if data2 between 1 and 10
        {
          SendInput {Enter}
        }

        if data2 between 120 and 127
        {
          datanew := 128-data2
          SendInput {Alt down}{Up %datanew%}{Alt up}
        }

      }

      ; Simple rules for single key macros
      ; cc, key1, key2, data1, data2, repeat-keypress

      SendKey(24, "Up", "Down", data1, data2, 8)

      SendKey(25, "WheelUp", "WheelDown", data1, data2, 2)

      SendKey(50, "Left", "Right", data1, data2)

      SendKey(51, "Up", "Down", data1, data2)

      ; SendKey(26, "Alt Up", "Enter", data1, data2)

    }

    ; Only when modifiers key Ctrl is on

    if getKeyState("Shift", "P")
    {

      IfEqual, data1, 50
      {

        if data2 between 1 and 10
        {
          SendInput {Shift down}{Right %data2%}
        }

        if data2 between 120 and 127
        {
          datanew := 128-data2
          SendInput {Shift down}{Left %datanew%}
        }

      }

      IfEqual, data1, 51
      {

        if data2 between 1 and 10
        {
          SendInput {Shift down}{Down %data2%}
        }

        if data2 between 120 and 127
        {
          datanew := 128-data2
          SendInput {Shift down}{Up %datanew%}
        }

      }

    }

    if getKeyState("LCtrl", "P")
    {

      IfEqual, data1, 50
      {

        if data2 between 1 and 10
        {
          SendInput {Ctrl down}{Tab %data2%}
        }

        if data2 between 120 and 127
        {
          datanew := 128-data2
          SendInput {Ctrl down}{Shift down}{Tab %datanew%}{Shift up}
        }

      }

    }

    ; Only when modifier key Alt is on

    if getKeyState("LAlt", "P")
    {

      IfEqual, data1, 50
      {

        if data2 between 1 and 10
        {
          SendInput {Alt down}{Tab %data2%}
        }

        if data2 between 120 and 127
        {
          datanew := 128-data2
          SendInput {Alt down}{Shift down}{Tab %datanew%}{Shift up}
        }

      }

    }


  } ; End application filter

} ; End statusbyte cc

Return
