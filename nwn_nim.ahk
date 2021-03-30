;================================================================================
;  nwn_nim.ahk
;  Author: Tobias Wirth (dunahan@schwerterkueste.de)
;  
;  Fuctions to work with niv's nwn_nim-tools
;================================================================================
; v0.0.0.6
;================================================================================

DEBUG := 1

GetDataTypeFromFile(File) {
  Result = ERROR100
  SplitPath, File, , , FileExt
  
  If (DEBUG = 1)
    MsgBox, 48, nwn_nim.ahk/GetDataTypeFromFile(), % File "`n" FileExt
  
  If InStr(FileExtension, json)
  {
    FileRead, FileExt, %File%
    
    ;If (DEBUG = 1) {
    ;  MsgBox, 48, nwn_nim.ahk/GetDataTypeFromFile(), Json found }
    
    Loop, Parse, FileExt, `n, %A_Space%%A_Tab%
    {
      ;If (DEBUG = 1) {
      ;  MsgBox, 48, nwn_nim.ahk/GetDataTypeFromFile(), Reading Lines }
        
      If InStr(A_LoopField, "__data_type")                                     ; {"__data_type":"DLG ",
      {
        ;if (DEBUG = 1) {
        ;  MsgBox, 36, nwn_nim.ahk/GetDataTypeFromFile(), % A_LoopField
        ;  IfMsgBox, No
        ;    break }
        
        return Result := SubStr(A_LoopField, 16, InStr(A_LoopField, ",") - 16)
      }
    }
  }
}

CountMatches(File, MatchThis) {
  SplitPath, File, , Path
  
  If InStr(Path, "\")
  {
    FileRead, Temp, %File%
    StringReplace, Temp, Temp, %MatchThis%, %MatchThis%, UseErrorLevel
  }
  Else
    StringReplace, Temp, File, %MatchThis%, %MatchThis%, UseErrorLevel
  
  Temp = 
  
  return Result := ErrorLevel
}

MoveDemToLast(String) {
  return SubStr(String, 2, StrLen(String) - 1) "|"
}

DLG_GetEntryLines(File) {
  
}

DLG_GetStartingLines(File) {

}


isLinear(obj) {
  n := obj.count(), i := 1
  loop % (n / 2) + 1
    if (!obj[i++] || !obj[n--])
      return 0
    return 1
}

Obj2Str(obj) { 
  ; from https://gist.github.com/errorseven/3b1e89e4d2f4d50b782f54954b2a97ca
  Linear := isLinear(obj)
  For e, v in obj {
    if (Linear == False) {
      if (IsObject(v)) 
        r .= e ":" Obj2Str(v) ", "
      else {
        r .= e ":"
        if v is number 
          r .= v ", "
        else
          r .= """" v """, " 
      }            
    } else {
      if (IsObject(v)) 
        r .= Obj2Str(v) ", "
      else {
        if v is number 
          r .= v ", "
        else 
          r .= """" v """, " 
      }
    }
  }
  return Linear ? "[" trim(r, ", ") "]"
                : "{" trim(r, ", ") "}"
}


