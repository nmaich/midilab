rules:



; Get foreground application

#Include core/functions.ahk



; Process cc messages

if type = cc
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

    ;Upper Dials

    ;CC1

    SendCode(1, "{Up}", "{Down}")
    SendCode(1, "{Up}", "{Down}", "Ctrl", 4)
    SendCode(1, "^+d{Up}!{Right}", "{Enter}", "Alt")
    SendCode(1, "{Shift down}{Up}", "{Shift down}{Down}", "Shift")

    SendCode(1, "^+{Up}", "^+{Down}", "Ctrl + Alt")
    SendCode(1, "+{Up 4}", "+{Down 4}", "Ctrl + Shift")
    SendCode(1, "^+d{Up}!{Right}", "^d", "Alt + Shift")

    ;CC2

    SendCode(2, "{Up}", "{Down}",, 2)
    SendCode(2, "{Up}", "{Down}", "Ctrl", 16)

    SendCode(3, "^+{Up}", "^+{Down}")

    SendCode(4, "^+d{Up}!{Right}", "^d")

    SendCode(5, "{Ctrl down}{Shift down}{Tab}{Shift up}", "{Ctrl down}{Tab}")
    SendCode(5, "{Ctrl down}{Shift down}{Tab}{Shift up}", "{Ctrl down}{Tab}", "Ctrl")

    ; Lower Dials

    ; CC9

    SendCode(9, "{Left}", "{Right}")
    SendCode(9, "^{Left}", "^{Right}", "Ctrl")
    SendCode(9, "{Backspace}", "{Delete}", "Alt")
    SendCode(9, "{Shift down}{Left}", "{Shift down}{Right}", "Shift")

    SendCode(9, "^{Backspace}", "^{Delete}", "Ctrl + Alt")
    SendCode(9, "^+{Left}", "^+{Right}", "Ctrl + Shift")

    SendCode(10, "^{Left}", "^{Right}")
    SendCode(10, "!{Left}", "!{Right}", "Ctrl")
    SendCode(10, "^{Backspace}", "^{Delete}", "Alt")
    SendCode(10, "{Shift down}^{Left}", "{Shift down}^{Right}", "Shift")

    SendCode(13, "{Alt down}{Shift down}{Tab}{Shift up}", "{Alt down}{Tab}")
    SendCode(13, "{Alt down}{Shift down}{Tab}{Shift up}", "{Alt down}{Tab}", "Alt")

  } ; End application filter

} ; End statusbyte cc



; Process note-on messages

if type = noteon
{
  ; No rules set
}



; Process note-off messages

if type = noteoff
{
  ; No rules active
}



; Process program change

if type = pc
{
  ; No rules active
}
