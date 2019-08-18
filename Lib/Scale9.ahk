/*
	Functions:
		Scale9_BitmapToBitmap(pBitmap, NewWidth, NewHeight, SizeArray, bDisposeImage := true)
		Scale9_FileToBitmap(FileName, NewWidth, NewHeight, SizeArray)

		Scale9_BitmapToHBitmap(pBitmap, NewWidth, NewHeight, SizeArray, bDisposeImage := true, Background=0xffffffff)
		Scale9_FileToHBitmap(FileName, NewWidth, NewHeight, SizeArray, Background=0xffffffff)

	Example:
		#Include <Gdip_All>

		pToken := Gdip_Startup()
		hBitmap := Scale9_FileToHBitmap("test.png", 400, 400, [40,41,43,43])
		Gdip_Shutdown(pToken)

		Gui, Add, Pic,, HBITMAP:%hBitmap%
		Gui, Show
*/

Scale9_BitmapToBitmap(pBitmap, NewWidth, NewHeight, SizeArray, bDisposeImage := true) {
	return Scale9.ScaleBitmap(pBitmap, NewWidth, NewHeight, SizeArray, bDisposeImage)
}

Scale9_BitmapToHBitmap(pBitmap, NewWidth, NewHeight, SizeArray, bDisposeImage := true, Background=0xffffffff) {
	if pBitmapNew := Scale9.ScaleBitmap(pBitmap, NewWidth, NewHeight, SizeArray, bDisposeImage)
	{
		hBitmap := Gdip_CreateHBITMAPFromBitmap(pBitmapNew, Background)
		Gdip_DisposeImage(pBitmapNew)
		return hBitmap
	}
}

Scale9_FileToBitmap(FileName, NewWidth, NewHeight, SizeArray) {
	if pBitmap := Gdip_CreateBitmapFromFile(FileName)
		return Scale9.ScaleBitmap(pBitmap, NewWidth, NewHeight, SizeArray)
}

Scale9_FileToHBitmap(FileName, NewWidth, NewHeight, SizeArray, Background=0xffffffff) {
	if pBitmap := Gdip_CreateBitmapFromFile(FileName)
	{
		pBitmapNew := Scale9.ScaleBitmap(pBitmap, NewWidth, NewHeight, SizeArray)
		hBitmap := Gdip_CreateHBITMAPFromBitmap(pBitmapNew, Background)
		Gdip_DisposeImage(pBitmapNew)
		return hBitmap
	}
}

class Scale9
{
	ScaleBitmap(pBitmap, NewWidth, NewHeight, SizeArray, bDisposeImage := true) {
		if (SizeArray.MaxIndex() != 4)
			throw "SizeArray parameter incorrect"

		Gdip_GetImageDimensions(pBitmap, ImageW, ImageH)

		oNineArea := this.GetNineArea(ImageW, ImageH, SizeArray*)
		oNineArea_New := this.ResizeNineArea(oNineArea, NewWidth, NewHeight)

		pBitmapNew := Gdip_CreateBitmap(NewWidth, NewHeight)
		G := Gdip_GraphicsFromImage(pBitmapNew)
		Gdip_SetSmoothingMode(G, 4)
		Gdip_SetInterpolationMode(G, 7)

		for key, dest in oNineArea_New {
			Gdip_DrawImage(G, pBitmap, dest[1], dest[2], dest[3], dest[4], oNineArea[key]*)
		}
		if bDisposeImage
			Gdip_DisposeImage(pBitmap)
		Gdip_DeleteGraphics(G)

		return pBitmapNew
	}

	GetNineArea(ImageWidth, ImageHeight, LeftSize, TopSize, RightSize, BottomSize) {
		centerW := ImageWidth - LeftSize - RightSize
		centerH := ImageHeight - TopSize - BottomSize

		o := {}

		o.top1 := [0,              0,  LeftSize, TopSize]
		o.top2 := [LeftSize,         0, centerW, TopSize]
		o.top3 := [LeftSize+centerW, 0, RightSize, TopSize]

		o.center1 := [0             , TopSize, LeftSize, centerH]
		o.center2 := [LeftSize        , TopSize, centerW, centerH]
		o.center3 := [LeftSize+centerW, TopSize, RightSize, centerH]

		o.bottom1 := [0             , TopSize+centerH, LeftSize, BottomSize]
		o.bottom2 := [LeftSize        , TopSize+centerH, centerW, BottomSize]
		o.bottom3 := [LeftSize+centerW, TopSize+centerH, RightSize, BottomSize]

		return o
	}

	ResizeNineArea(oNineArea, NewImageWidth, NewImageHeight) {
		o := {}
		for k, v in oNineArea
			o[k] := v.Clone()

		centerW := NewImageWidth - o.top1.3 - o.top3.3
		centerH := NewImageHeight - o.top1.4 - o.bottom1.4

		o.top2.3    := centerW
		o.bottom2.3 := centerW

		o.center1.4 := centerH
		o.center3.4 := centerH

		o.center2.3 := centerW
		o.center2.4 := centerH

		o.top3.1    := o.top1.3 + centerW
		o.center3.1 := o.top1.3 + centerW
		o.bottom3.1 := o.top1.3 + centerW

		o.bottom1.2 := o.top1.4 + centerH
		o.bottom2.2 := o.top1.4 + centerH
		o.bottom3.2 := o.top1.4 + centerH

		return o
	}
}



