rules:



; NoteOn Messages

if statusbyte between 144 and 159
{}



; NoteOff Messages

if statusbyte between 128 and 143
{
  MidiInDisplay(%type%, %statusbyte%, %chan%, %number%, %value%)  ; display note off in gui
}



; CC Messages

if statusbyte between 176 and 191
{

  WinGet, application, ProcessName, A
  ;MsgBox, %application%

  ;Ableton Live 10

  if application = Ableton Live 10 Suite.exe
  {

    IfEqual, number, 51
    {

      if value between 1 and 10
      {
        SendInput {Down %value%}
      }

      if value between 120 and 127
      {
        datanew := 128-value
        SendInput {Up %datanew%}
      }

    }

    IfEqual, number, 50
    {

      if value between 1 and 10
      {
        SendInput {Right %value%}
      }

      if value between 120 and 127
      {
        datanew := 128-value
        SendInput {Left %datanew%}
      }

    }

  }

  ; Any Application except Live 10

  if application != Ableton Live 10 Suite.exe
  {

    if getKeyState("LCtrl", "P") != true and getKeyState("LAlt", "P") != true

    {

      IfEqual, number, 22
      {

        if value between 1 and 10
        {
          SendInput {Shift down}{Right %value%}{Shift up}
        }

        if value between 120 and 127
        {
          datanew := 128-value
          SendInput {Shift down}{Left %datanew%}{Shift up}
        }

      }

      IfEqual, number, 23
      {

        if value between 1 and 10
        {
          SendInput {Shift down}{Down %value%}{Shift up}
        }

        if value between 120 and 127
        {
          datanew := 128-value
          SendInput {Shift down}{Up %datanew%}{Shift up}
        }

      }

      IfEqual, number, 24
      {

        if value between 1 and 10
        {
          datanew := (value) * 8
          SendInput {Down %datanew%}
        }

        if value between 120 and 127
        {
          datanew := (128-value) * 8
          SendInput {Up %datanew%}
        }

      }

      IfEqual, number, 25
      {

        if value between 1 and 10
        {
          datanew := (value)*4
          SendInput {WheelDown %datanew%}
        }

        if value between 120 and 127
        {
          datanew := (128-value)*4
          SendInput {WheelUp %datanew%}
        }

      }

      IfEqual, number, 26
      {

        if value between 1 and 10
        {
          SendInput {Enter %value%}
        }

        if value between 120 and 127
        {
          datanew := 128-value
          SendInput {Backspace %datanew%}
        }

      }

      IfEqual, number, 50
      {

        if value between 1 and 10
        {
          SendInput {Right %value%}
        }

        if value between 120 and 127
        {
          datanew := 128-value
          SendInput {Left %datanew%}
        }

      }

      IfEqual, number, 51
      {

        if value between 1 and 10
        {
          SendInput {Down %value%}
        }

        if value between 120 and 127
        {
          datanew := 128-value
          SendInput {Up %datanew%}
        }

      }

    }

    if getKeyState("LCtrl", "P")
    {

      IfEqual, number, 50
      {

        if value between 1 and 10
        {
          SendInput {Ctrl down}{Tab %value%}
        }

        if value between 120 and 127
        {
          datanew := 128-value
          SendInput {Ctrl down}{Shift down}{Tab %datanew%}{Shift up}
        }

      }

    }

    if getKeyState("LAlt", "P")
    {

      IfEqual, number, 50
      {

        if value between 1 and 10
        {
          SendInput {Alt down}{Tab %value%}
        }

        if value between 120 and 127
        {
          datanew := 128-value
          SendInput {Alt down}{Shift down}{Tab %datanew%}{Shift up}
        }

      }

    }

  }

}

Return
