rules:



; Get foreground application

#Include core/functions.ahk



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

    if mode = "none"

    {

      ; Complex rules for multi key codes

      SendCode(22,"+{Left}","+{Right}")

      SendCode(23,"+{Up}","+{Down}")

      SendCode(26,"!{Up}", "{Enter}")

      SendCode(33, "{Left}", "{Right}")

      ; Simple rules for single key macros

      SendCode(27, "^+d", "^d")

      SendKey(24, "Up", "Down", 4)

      SendKey(25, "WheelUp", "WheelDown", 2)

      SendKey(50, "Left", "Right")

      SendKey(51, "Up", "Down")

    }



    ; Only when modifiers key Ctrl is on

    if mode = "shift"
    {

      SendCode(50,"{Shift down}{Left}","{Shift down}{Right}")

      SendCode(51,"{Shift down}{Up}","{Shift down}{Down}")

    }



    ; Only Ctrl active

    if mode = "ctrl"
    {

      SendKey(50, "Left", "Right", 1, "Ctrl")

      SendKey(51, "Up", "Down", 4)

      SendCode(33, "^+{Left}", "^+{Right}")

      SendCode(22, "{Ctrl down}{Shift down}{Tab}{Shift up}", "{Ctrl down}{Tab}")

    }



    ; Only Alt active

    if mode = "alt"
    {

      SendCode(22, "{Alt down}{Shift down}{Tab}{Shift up}", "{Alt down}{Tab}")

    }



    ; Ctrl & Shift active

    if mode = "ctrl + shift"
    {

      SendKey(50, "Left", "Right", 1, "Ctrl", "Shift")

      SendCode(51, "+{Up 4}", "+{Down 4}")

    }



  } ; End application filter

} ; End statusbyte cc



; Process note-on messages

if type = "noteon"
{
  ; No rules set
}



; Process note-off messages

if type = "noteoff"
{
  ; No rules active
}



; Process program change

if type = "pc"
{
  ; No rules active
}
