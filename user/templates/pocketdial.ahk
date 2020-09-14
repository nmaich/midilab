;Only if Ableton Live 10 active

if application = Ableton Live 10 Suite.exe
{

  SendKey(9, "Left", "Right")
  SendKey(10, "Up", "Down")

}


; Any Application except Live 10

if application != Ableton Live 10 Suite.exe
{

  ; Advanced ruleset for the MIDI controller "Doepfer PocketDial"
  ; Upper Dials 1 - 8

  ; CC1

  SendCode(1, "{Up}", "{Down}")
  SendCode(1, "{Up}", "{Down}", "Ctrl", 4)
  SendCode(1, "^+d{Up}!{Right}", "{Enter}", "Alt")
  SendCode(1, "{Shift down}{Up}", "{Shift down}{Down}", "Shift")
  SendCode(1, "^+{Up}", "^+{Down}", "Ctrl + Alt")
  SendCode(1, "+{Up 4}", "+{Down 4}", "Ctrl + Shift")
  SendCode(1, "^+d{Up}!{Right}", "^d", "Alt + Shift")

  ; CC2

  SendCode(2, "{Up}", "{Down}",, 2)
  SendCode(2, "{Up}", "{Down}", "Ctrl", 16)

  ; CC3

  SendCode(3, "^+{Up}", "^+{Down}")

  ; CC4

  SendCode(4, "^+d{Up}!{Right}", "^d")

  ; CC5

  SendCode(5, "{Ctrl down}{Shift down}{Tab}{Shift up}", "{Ctrl down}{Tab}")
  SendCode(5, "{Ctrl down}{Shift down}{Tab}{Shift up}", "{Ctrl down}{Tab}", "Ctrl")

  ; Lower Dials 9 - 16

  ; CC9

  SendCode(9, "{Left}", "{Right}")
  SendCode(9, "^{Left}", "^{Right}", "Ctrl")
  SendCode(9, "{Backspace}", "{Delete}", "Alt")
  SendCode(9, "{Shift down}{Left}", "{Shift down}{Right}", "Shift")
  SendCode(9, "^{Backspace}", "^{Delete}", "Ctrl + Alt")
  SendCode(9, "^+{Left}", "^+{Right}", "Ctrl + Shift")

  ; CC10

  SendCode(10, "^{Left}", "^{Right}")
  SendCode(10, "!{Left}", "!{Right}", "Ctrl")
  SendCode(10, "^{Backspace}", "^{Delete}", "Alt")
  SendCode(10, "{Shift down}^{Left}", "{Shift down}^{Right}", "Shift")

  ; CC13

  SendCode(13, "{Alt down}{Shift down}{Tab}{Shift up}", "{Alt down}{Tab}")
  SendCode(13, "{Alt down}{Shift down}{Tab}{Shift up}", "{Alt down}{Tab}", "Alt")

} ; End application filter
