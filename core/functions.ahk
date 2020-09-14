WinGet, application, ProcessName, A
inc := value
dec := 128-value
type := type
ccnum := number

;MsgBox, %application%



; Define global vars for functions

global change, number, type, mode



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
