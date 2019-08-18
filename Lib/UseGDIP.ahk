UseGDIP(Params*) {
   Static GdipObject := ""
   Static GdipModule := ""
   Static GdipToken  := ""
   Static Load := UseGDIP()
   If (GdipModule = "") {
      If !(GdipModule := DllCall("LoadLibrary", "Str", "Gdiplus.dll", "UPtr")) {
         MsgBox, 262160, UseGDIP, The Gdiplus.dll could not be loaded!`n`nThe program will exit!
         ExitApp
      }
      Else {
         VarSetCapacity(SI, 24, 0), NumPut(1, SI, 0, "UInt") ; size of 64-bit structure
         If DllCall("Gdiplus.dll\GdiplusStartup", "PtrP", GdipToken, "Ptr", &SI, "Ptr", 0) {
            MsgBox, 262160, UseGDIP, GDI+ could not be startet!`n`nThe program will exit!
            ExitApp
         }
         GdipObject := {Base: {__Delete: Func("UseGDIP").Bind(GdipModule, GdipToken)}}
      }
   }
   Else If (Params[1] = GdipModule) && (Params[2] = GdipToken) {
      DllCall("Gdiplus.dll\GdiplusShutdown", "Ptr", GdipToken)
      DllCall("FreeLibrary", "Ptr", GdipModule)
   }
}