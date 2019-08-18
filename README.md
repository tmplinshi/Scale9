# Scale9

#### Functions
- Scale9_BitmapToBitmap(pBitmap, NewWidth, NewHeight, SizeArray, bDisposeImage := true)
- Scale9_FileToBitmap(FileName, NewWidth, NewHeight, SizeArray)

- Scale9_BitmapToHBitmap(pBitmap, NewWidth, NewHeight, SizeArray, bDisposeImage := true, Background=0xffffffff)
- Scale9_FileToHBitmap(FileName, NewWidth, NewHeight, SizeArray, Background=0xffffffff)

#### Example
```AutoHotkey
#Include <Gdip_All>

pToken := Gdip_Startup()
hBitmap := Scale9_FileToHBitmap("test.png", 400, 400, [40,41,43,43])
Gdip_Shutdown(pToken)

Gui, Add, Pic,, HBITMAP:%hBitmap%
Gui, Show
```

#### Screenshots

![Scale9 Example 1.png](https://raw.githubusercontent.com/tmplinshi/Scale9/master/screenshot/Scale9%20Example%201.png)

![Scale9 Example 2.png](https://raw.githubusercontent.com/tmplinshi/Scale9/master/screenshot/Scale9%20Example%202.png)
