rules:



; NoteOn Messages

if statusbyte between 144 and 159
{}



; NoteOff Messages

if statusbyte between 128 and 143
{
  MidiInDisplay(%stb%, %statusbyte%, %chan%, %data1%, %data2%)  ; display note off in gui
}



; CC Messages

if statusbyte between 176 and 191
{

  WinGet, application, ProcessName, A
  ;MsgBox, %application%

  ;Ableton Live 10

  if application = Ableton Live 10 Suite.exe
  {

    IfEqual, data1, 51
    {

      if data2 between 1 and 10
      {
        SendInput {Down %data2%}
      }

      if data2 between 120 and 127
      {
        datanew := 128-data2
        SendInput {Up %datanew%}
      }

    }

    IfEqual, data1, 50
    {

      if data2 between 1 and 10
      {
        SendInput {Right %data2%}
      }

      if data2 between 120 and 127
      {
        datanew := 128-data2
        SendInput {Left %datanew%}
      }

    }

  }

  ; Any Application except Live 10

  if application != Ableton Live 10 Suite.exe
  {

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

    IfEqual, data1, 24
    {

      if data2 between 1 and 10
      {
        datanew := (data2)
        SendInput {WheelDown %datanew%}
      }

      if data2 between 120 and 127
      {
        datanew := (128-data2)
        SendInput {WheelUp %datanew%}
      }

    }

    IfEqual, data1, 25
    {

      if data2 between 1 and 10
      {
        datanew := (data2)*4
        SendInput {WheelDown %datanew%}
      }

      if data2 between 120 and 127
      {
        datanew := (128-data2)*4
        SendInput {WheelUp %datanew%}
      }

    }

    IfEqual, data1, 26
    {

      if data2 between 1 and 10
      {
        SendInput {Enter %data2%}
      }

      if data2 between 120 and 127
      {
        datanew := 128-data2
        SendInput {Backspace %datanew%}
      }

    }

    IfEqual, data1, 50
    {

      if data2 between 1 and 10
      {
        SendInput {Right %data2%}
      }

      if data2 between 120 and 127
      {
        datanew := 128-data2
        SendInput {Left %datanew%}
      }

    }

    IfEqual, data1, 51
    {

      if data2 between 1 and 10
      {
        SendInput {Down %data2%}
      }

      if data2 between 120 and 127
      {
        datanew := 128-data2
        SendInput {Up %datanew%}
      }

    }

  }

}

Return
