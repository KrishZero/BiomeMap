#Requires AutoHotkey v2.0
#Include json.ahk

SendDiscordAlert(message, title := "", color := "16777215", footer := "", imageUrl := "", localImagePath := "") {
    webhookUrl := "https://discord.com/api/webhooks/1292218528400932958/2h9ZAgHH7StqoUtw4p0C5ykMGlPmMXucN9I29YsEIhU127vvqnOaPVWOIQGZ8vlggV9O"

    try {
        if (localImagePath && FileExist(localImagePath)) {
            ; Handle local image file upload
            boundary := "------------------------" . Format("{:016X}", Random(0, 0xFFFFFFFFFFFFFFFF))
            
            request := ComObject("WinHttp.WinHttpRequest.5.1")
            request.Open("POST", webhookUrl, false)
            request.SetRequestHeader("Content-Type", "multipart/form-data; boundary=" . boundary)

            ; Create embed structure
            embed := Map(
                "description", message,
                "color", color
            )

            if (title)
                embed["title"] := title

            if (footer)
                embed["footer"] := Map("text", footer)

            ; Create payload
            payload := Map(
                "username", "BiomeMap",
                "embeds", [embed]
            )

            ; Prepare multipart form data
            CRLF := "`r`n"
            body := "--" . boundary . CRLF
            body .= "Content-Disposition: form-data; name=`"payload_json`"" . CRLF
            body .= "Content-Type: application/json" . CRLF . CRLF
            body .= JSON.Stringify(payload) . CRLF

            ; Add file data
            body .= "--" . boundary . CRLF
            body .= "Content-Disposition: form-data; name=`"file`"; filename=`"" . localImagePath . "`"" . CRLF
            body .= "Content-Type: application/octet-stream" . CRLF . CRLF

            ; Read file binary data
            fileObj := FileOpen(localImagePath, "r")
            fileData := fileObj.Read()
            fileObj.Close()

            ; Combine everything
            body .= fileData . CRLF
            body .= "--" . boundary . "--" . CRLF

            request.Send(body)
        } else {
            ; Handle regular message with optional image URL
            request := ComObject("WinHttp.WinHttpRequest.5.1")
            request.Open("POST", webhookUrl, false)
            request.SetRequestHeader("Content-Type", "application/json")

            ; Create embed structure
            embed := Map(
                "description", message,
                "color", color
            )

            if (title)
                embed["title"] := title

            if (footer)
                embed["footer"] := Map("text", footer)

            if (imageUrl)
                embed["image"] := Map("url", imageUrl)

            ; Create payload
            payload := Map(
                "username", "BiomeMap",
                "embeds", [embed]
            )

            request.Send(JSON.Stringify(payload))
        }

        if (request.Status != 204) {
            MsgBox("Failed to send Discord alert. Status: " request.Status "`nResponse: " request.ResponseText)
            return false
        }
        return true
    } catch Error as err {
        MsgBox("Failed to send Discord alert: " err.Message)
        return false
    }
}

; Example usage:
; SendDiscordAlert("Hello with URL image!", "Title", "16777215", "Footer", "https://example.com/image.png")
; SendDiscordAlert("Hello with local image!", "Title", "16777215", "Footer", "", "C:\path\to\image.png")