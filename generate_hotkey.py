keylist = ("34567890-^\\","wertyuiop@[","asdfghjkl;:","_zxcvbnm,./")
note_relative = 0
# ; : , ` use keycodes when using these keys. 


s1 = """:: 
    If (A_PriorHotKey != A_ThisHotKey){
        note := note_lowest + """ #note
s2_1 = """
        statusbyte = 144	; NOTE ON MESSAGE
        gosub, SendNote """
s2_2 = """
        statusbyte = 128	; NOTE OFF MESSAGE
        gosub, SendNote"""
s3 = """
    }return
"""


out = ""
for col in range(11):
    key = "F" + str(col + 2) 
    out += "$" + key
    out += s1
    out += str(note_relative + (col+1)*3 + 1) #note
    out += s2_1
    out += s3

    out += "$" + key + " up" #key up
    out += s1
    out += str(note_relative + (col+1)*3 + 1) #note
    out += s2_2
    out += s3
print(out)

out=""
for row in range(4):
    for col in range(11):
        key =keylist[row][col]
        if key==";":
            key = "sc027"
        if key==":":
            key = "sc028"
        if key==",":
            key = "sc033"
        if key=="_":
            key = "Shift"
        if key=="\\":
            key = "sc073"
        out += "$" + key
        out += s1
        out += str(note_relative + (col+1)*3 - row) #note
        out += s2_1
        out += s3

        out += "$" + key + " up" #key up
        out += s1
        out += str(note_relative + (col+1)*3 - row) #note
        out += s2_2
        out += s3
print(out)