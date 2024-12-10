#Requires AutoHotkey v2.0

#Include gdipAll.ahk 
#Include %A_ScriptDir%/Main.ahk

; Base resolution (1080p)
BaseWidth := 1920
BaseHeight := 1080

; Target resolution
CurrentWidth := A_ScreenWidth
CurrentHeight := A_ScreenHeight

; Scaling factors
ScaleX := CurrentWidth / BaseWidth
ScaleY := CurrentHeight / BaseHeight

; Original 1080p selection values
x := 0
y := 907
w := 270
h := 23

; Scale values for the current resolution
x := Round(x * ScaleX)
y := Round(y * ScaleY)
w := Round(w * ScaleX)
h := Round(h * ScaleY) 
  
; Initialize the toggle    
  
; Function to take a screenshot  
TakeScreenshot() {  
   ; Create a bitmap from the screen  
   pToken := Gdip_Startup()  
   pBitmap := Gdip_BitmapFromScreen(x "|" y "|" w "|" h)  
  
   ; Save the bitmap to a file  
   Gdip_SaveBitmapToFile(pBitmap, A_ScriptDir "\screenshot.png")  
  
   ; Cleanup  
   Gdip_DisposeImage(pBitmap)  
   Gdip_Shutdown(pToken)  
}  
  
; Loop to take screenshots  
Loop {  
   if (toggle = "On") {  
      TakeScreenshot()  
   }  
   Sleep 1000 
}