#Requires AutoHotkey v2.0

class JSON {
    static Stringify(obj) {
        if IsObject(obj) {
            if obj is Array {
                items := []
                for value in obj
                    items.Push(this.Stringify(value))
                return "[" this.Join(items) "]"
            } else if obj is Map {
                items := []
                for key, value in obj
                    items.Push(this.Stringify(key) ":" this.Stringify(value))
                return "{" this.Join(items) "}"
            }
        }
        
        if Type(obj) = "String"
            return '"' this.Escape(obj) '"'
        
        return obj
    }

    static Escape(str) {
        str := StrReplace(str, "\", "\\")
        str := StrReplace(str, "`"", "\`"")
        str := StrReplace(str, "`n", "\n")
        str := StrReplace(str, "`r", "\r")
        str := StrReplace(str, "`t", "\t")
        return str
    }

    static Join(arr) {
        result := ""
        for index, value in arr {
            if (index > 1)
                result .= ","
            result .= value
        }
        return result
    }
}