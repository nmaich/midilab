dev:


Loop
{

  ; Define global keyboard shortcuts here

  if getKeyState("LCtrl", "P") and getKeyState("LAlt", "P") and getKeyState("S", "P")
  {

    Sleep 250
    Reload
    Sleep 5000

  }

}

return
