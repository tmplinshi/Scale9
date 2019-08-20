#SingleInstance, force
#Include <Gdip_All>
SetBatchLines -1
UseGDIP() ; by just me - https://www.autohotkey.com/boards/viewtopic.php?t=8050

OnMessage(0x133, "WM_CTLCOLOREDIT")
OnMessage(0x138, "WM_CTLCOLORSTATIC")
OnMessage(0x111, "WM_COMMAND")

EditStyles := "+Multi -E0x200 -0x200000 -Wrap -WantReturn"
; +Multi    EM_SETMARGIN only works for multi-line edit control
; -E0x200   Remove edit control's border
; -0x200000 Remove scrollbar

Gui, +HWNDhGUI +LastFound
Gui, Margin, 60, 30
Gui, Color, 0x1B435D
Gui, Font, s12 c0x9EBACA, Microsoft YaHei UI
Gui, Add, Text, xm, Username
Gui, Add, Edit, %EditStyles% xm y+10 hwndhEdit1 h35 w300
Gui, Add, Text, xm, Password
Gui, Add, Edit, %EditStyles% xm y+10 hwndhEdit2 h35 w300 Password
Gui, Add, Text, xm, Comment
Gui, Add, Edit, xm y+10 hwndhEdit3 h100 w300 +Multi -E0x200 -0x200000 -Wrap +ReadOnly, ReadOnly

PostMessage, 0xCC, Asc("*"), 0,, ahk_id %hEdit2%

; Create hBrush
SizeArray := [3, 3, 3, 3]
ImageObj := { "normal"  : "image\edit-normal.png"
             , "focus"   : "image\edit-focus.png"
             , "disabled": "image\edit-disabled.png" }

global g_hBrush := {}
g_hBrush[hEdit1] := CreateHBrush(hEdit1, SizeArray, ImageObj, 0xFF1B435D)
g_hBrush[hEdit2] := g_hBrush[hEdit1] ; Edit2 has the same size as Edit1
g_hbrush[hEdit3] := CreateHBrush(hEdit3, SizeArray, ImageObj, 0xFF1B435D)

; EM_SETMARGIN
EditSetMargin(hEdit1, 7, 7, 7, 7)
EditSetMargin(hEdit2, 7, 7, 7, 7)
EditSetMargin(hEdit3, 7, 7, 7, 7)

Gui, Show,, Scale9 Example 2
WinSet, Redraw
Return

GuiClose:
ExitApp

WM_COMMAND(wParam, lParam) {
	static EN_SETFOCUS := 0x0100, EN_KILLFOCUS := 0x0200, EN_CHANGE := 0x0300
	nCode := wParam >> 16
	If (nCode = EN_KILLFOCUS || nCode = EN_CHANGE)
		DllCall("InvalidateRect", "ptr", lParam, "ptr", 0, "int", 1)
}

WM_CTLCOLOREDIT(wParam, lParam) {
	Critical

	Status := (lParam = DllCall("GetFocus", "ptr")) ? "focus" : "normal"

	DllCall("SetBkMode", "ptr", wParam, "uint", 1)
	DllCall("SetTextColor", "ptr", wParam, "uint", 0xffffff)
	Return g_hBrush[lParam][Status]
}

WM_CTLCOLORSTATIC(wParam, lParam) {
	Critical

	WinGetClass, Class, ahk_id %lParam%

	If (Class = "Edit")
	{
		DllCall("SetTextColor", "ptr", wParam, "uint", 0x7F7056)
		DllCall("SetBkMode", "ptr", wParam, "int", 1)
		; Return g_hBrush[lParam]["disabled"]
		Return g_hBrush[lParam]["normal"] ; The edit-normal.png looks better
	}
}

CreateHBrush(hEdit, SizeArray, ImageObj, BkColor := 0xFFFFFFFF) {
	GuiControlGet, Ctrl, Pos, %hEdit%

	oBrush := {}
	For Status, ImageFile in ImageObj
	{
		hBitmap := Scale9_FileToHBitmap(ImageFile, CtrlW, CtrlH, SizeArray, BkColor)
		oBrush[status] := DllCall("CreatePatternBrush", "ptr", hBitmap, "ptr")
		DllCall("DeleteObject", "ptr", hBitmap)
	}
	Return oBrush
}

EditSetMargin(hEdit, mLeft:=0, mTop:=0, mRight:=0, mBottom:=0) {
	VarSetCapacity(RECT, 16, 0 )

	; SendMessage, 0xB2,, &RECT,, ahk_id %hEdit% ; EM_GETMARGIN
	DllCall("GetClientRect", "ptr", hEdit, "ptr", &RECT)
	left   := NumGet(RECT, 0, "Int")
	top    := NumGet(RECT, 4, "Int")
	right  := NumGet(RECT, 8, "Int")
	bottom := NumGet(RECT, 12, "Int")

	NumPut(left + mLeft    , RECT, 0, "Int")
	NumPut(top + mTop      , RECT, 4, "Int")
	NumPut(right - mRight  , RECT, 8, "Int")
	NumPut(bottom - mBottom, RECT, 12, "Int")
	SendMessage, 0xB3, 0x0, &RECT,, ahk_id %hEdit% ; EM_SETMARGIN
}

