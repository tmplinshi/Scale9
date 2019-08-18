#Include <Gdip_All>

pToken := Gdip_Startup()
hBitmap := Scale9_FileToHBitmap("image\9.png", 300, 300, [40,41,43,43])
Gdip_Shutdown(pToken)

Gui, Font, s12
Gui, Add, Pic, Section, image\9.png
Gui, Add, Text, cGray, (Original Size)
Gui, Add, Pic, ys x+100, HBITMAP:%hBitmap%
Gui, Add, Text, cGray, (Resized To 400x400)
Gui, Show,, Scale9 Example 1
Return

GuiEscape:
GuiClose:
ExitApp