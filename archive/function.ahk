;
; global number, value
;
;
; SendCodeAlternative(num, keycode1, keycode2, multi=1, mod1="none", mod2="none")
; {
;
;   IfEqual, number, %num%
;   {
;
;     if value between 120 and 127
;     {
;
;       datanew := (128-value)*multi
;
;       if (mod1 == "none")
;       {
;         Loop %datanew%
;         SendInput %keycode1%
;       }
;
;       ;MsgBox "%mod1%"
;
;       if (mod1 == "Ctrl") && (getKeyState("Ctrl"))
;       {
;         Loop %datanew%
;         SendInput %keycode1%
;       }
;
;       if (mod1 == "Alt") && (getKeyState("Alt"))
;       {
;         Loop %datanew%
;         SendInput %keycode1%
;       }
;
;
;     }
;
;     if value between 1 and 10
;     {
;
;       datanew := (value)*multi
;
;       if (mod1 == "none")
;       {
;         Loop %datanew%
;         SendInput %keycode2%
;       }
;
;       if (mod1 == "Ctrl") && (getKeyState("Ctrl"))
;       {
;         Loop %datanew%
;         SendInput %keycode2%
;       }
;
;       if (mod1 == "Alt") && (getKeyState("Alt"))
;       {
;         Loop %datanew%
;         SendInput %keycode2%
;       }
;
;     }
;
;   }
;
; }
;
; return
