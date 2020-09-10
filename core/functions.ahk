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
  change = "positive"
}

if value between 120 and 127
{
  change = "negative"
}



; Get modifier key state

if !getKeyState("Ctrl") and !getKeyState("Alt") and !getKeyState("Shift")
{
  mode = "none"
}

if (getKeyState("Shift") and !getKeyState("Ctrl") and !getKeyState("Alt"))
{
  mode = "shift"
}
if !getKeyState("Shift") and getKeyState("Ctrl") and !getKeyState("Alt")
{
  mode = "ctrl"
}

if !getKeyState("Shift") and getKeyState("Ctrl") and getKeyState("Alt")
{
  mode = "ctrl + alt"
}

if getKeyState("Shift") and getKeyState("Ctrl") and !getKeyState("Alt")
{
  mode = "ctrl + shift"
}

if !getKeyState("Shift") and !getKeyState("Ctrl") and getKeyState("Alt")
{
  mode = "alt"
}

if getKeyState("Shift") and !getKeyState("Ctrl") and getKeyState("Alt")
{
  mode = "alt + shift"
}

if getKeyState("Shift") and getKeyState("Ctrl") and getKeyState("Alt")
{
  mode = "ctrl + alt + shift"
}


