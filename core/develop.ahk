dev:


Loop
{

  ; Define global keyboard shortcuts here

  if getKeyState("Ctrl") and getKeyState("Alt") and getKeyState("s")
  {

    Sleep 250
    Reload
    Sleep 500

  }

}

return

!^m::

GoSub, Midimon

return

