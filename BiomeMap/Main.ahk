#Requires AutoHotkey v2.0
#Include lib/ocr.ahk
#Include lib/discord.ahk

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

; Output the scaled values
MsgBox "Scaled values:`n`nX: " x "`nY: " y "`nW: " w "`nH: " h

global toggle := "Off"
global lastBiome := ""
global currentBiome := ""

myGui := Gui()
myGui.Show("w620 h420")
myGui.SetFont("s30", "Segoe UI")
myGui.Add("Text", "x8 y8 w601 h88 +0x200", "BiomeMap")
myGui.Add("GroupBox", "x8 y120 w171 h125", "Status")
myGui.SetFont("s40", "Segoe UI")
statusText := myGui.Add("Text", "x16 y136 w159 h97 +0x200", toggle)
myGui.OnEvent('Close', (*) => ExitApp())
myGui.Title := "(UI) BiomeMap 『Ctrl + Shift + G to toggle』"

^+g:: {
    global toggle
    if (toggle = "Off") {
        toggle := "On"
        statusText.Value := "On"
        SetTimer(CheckBiome, 5000)
    } else {
        toggle := "Off"
        statusText.Value := "Off"
        SetTimer(CheckBiome, 0)
    }
}

CheckBiome() {
    global currentBiome, lastBiome
    
    currentBiome := OCR.FromRect(x, y, w, h).Text
    
    if (currentBiome && currentBiome != lastBiome) {  ; Only proceed if we have a biome and it's different
        screenshotPath := A_ScriptDir "\screenshot.png"
        
        if InStr(currentBiome, "NORM")
            SendDiscordAlert("Normal Biome", "BiomeMap - Biome Detected", "0", "Made by krish", "")
        else if InStr(currentBiome, "WIND")
            SendDiscordAlert("Windy Biome", "BiomeMap - Biome Detected", "0", "Made by krish", "")
        else if InStr(currentBiome, "SNOW")
            SendDiscordAlert("Snowy Biome", "BiomeMap - Biome Detected", "0", "Made by krish", "")
        else if InStr(currentBiome, "RAIN")
            SendDiscordAlert("Rainy Biome", "BiomeMap - Biome Detected", "0", "Made by krish", "")
        else if InStr(currentBiome, "SAND")
            SendDiscordAlert("Sandstorm Biome", "BiomeMap - Biome Detected", "0", "Made by krish", "")
        else if InStr(currentBiome, "COR")
            SendDiscordAlert("Corruption Biome", "BiomeMap - Biome Detected", "0", "Made by krish", "")
        else if InStr(currentBiome, "HELL")
            SendDiscordAlert("Hell Biome", "BiomeMap - Biome Detected", "0", "Made by krish", "")
        else if InStr(currentBiome, "STAR")
            SendDiscordAlert("Starfall Biome", "BiomeMap - Biome Detected", "0", "Made by krish", "")
        else if InStr(currentBiome, "NU")
            SendDiscordAlert("Null Biome", "BiomeMap - Biome Detected", "0", "Made by krish", "")
        else if InStr(currentBiome, "PUMP")
            SendDiscordAlert("Pumpkin Moon Biome", "BiomeMap - Biome Detected", "0", "Made by krish", "")
        else if InStr(currentBiome, "GRAV")
            SendDiscordAlert("Graveyard Biome", "BiomeMap - Biome Detected", "0", "Made by krish", "")
        else if InStr(currentBiome, "0.")
            SendDiscordAlert("!! GLITCHED BIOME !!", "Biome Started - Glitched", "0", "Made by krish", "")
        
        lastBiome := currentBiome  ; Update the last known biome
    }
}

WinActivate("ahk_exe RobloxPlayerBeta.exe")
Sleep(3200)
