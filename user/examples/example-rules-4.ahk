rules:



; Get foreground application

#Include core/functions.ahk



; Process cc messages

if type = "cc"
{



  ;Only if Ableton Live 10 active

  if application = Ableton Live 10 Suite.exe
  {

    SendKey(9, "Left", "Right")

    SendKey(10, "Up", "Down")

  }



  ; Any Application except Live 10

  if application != Ableton Live 10 Suite.exe
  {



    ; Only when all modifier keys are off, process these commands

    if mode = "none"

    {

      ; Complex rules for multi key codes

      SendCode(1,"+{Left}","+{Right}")

      SendCode(2,"+{Up}","+{Down}")

      SendKey(3, "Up", "Down", 4)

      SendKey(4, "WheelUp", "WheelDown", 2)

      SendCode(5, "{Left}", "{Right}")

      SendKey(9, "Left", "Right")

      SendKey(10, "Up", "Down")

      SendCode(11,"!{Up}", "{Enter}")

      SendCode(12, "^+d", "^d")

    }



    ; Only when modifiers key Ctrl is on

    if mode = "shift"
    {

      SendCode(9,"{Shift down}{Left}","{Shift down}{Right}")

      SendCode(10,"{Shift down}{Up}","{Shift down}{Down}")

    }



    ; Only Ctrl active

    if mode = "ctrl"
    {

      SendKey(9, "Left", "Right", 1, "Ctrl")

      SendKey(10, "Up", "Down", 4)

      SendCode(5, "^+{Left}", "^+{Right}")

      SendCode(1, "{Ctrl down}{Shift down}{Tab}{Shift up}", "{Ctrl down}{Tab}")

    }



    ; Only Alt active

    if mode = "alt"
    {

      SendCode(1, "{Alt down}{Shift down}{Tab}{Shift up}", "{Alt down}{Tab}")

    }



    ; Ctrl & Shift active

    if mode = "ctrl + shift"
    {

      SendKey(9, "Left", "Right", 1, "Ctrl", "Shift")

      SendCode(10, "+{Up 4}", "+{Down 4}")

    }



    ; Ctrl & Alt active

    if mode = "ctrl + alt"
    {

      SendCode(9, "^{Backspace}", "^{Delete}")

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
