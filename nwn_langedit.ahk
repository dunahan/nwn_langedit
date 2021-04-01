;================================================================================
;  nwn_langedit.ahk
;  Author: Tobias Wirth (dunahan@schwerterkueste.de)
;================================================================================
; v0.0.0.1
;================================================================================
VERSION := "0.0.0.1"
;================================================================================

#NoTrayIcon
#NoEnv                  ; For performance and combatibility with newer AHK versions
#SingleInstance force

#Include nwn_nim.ahk    ; external funcs, won't blow up main script and maintains readability
#Include JSON.ahk

;================================================================================
;                                                            Persistent Variables
;================================================================================
EXE := A_WorkingDir . "\nwn_langedit.exe"
NAME := "nle_test"
DEBUG := TRUE

;================================================================================
;                                                                    Main Scripts
;================================================================================

Main:     ; <<<===  Main begins
{
  if (DEBUG == TRUE)
    Tabs := "Allgemein|Einstellungen|Debug"
  else
    Tabs := "Allgemein|Einstellungen"
  
  Gui, 1: Add, Tab3, x6 y6 w718 h404 vTabA, %Tabs%
  Gui, 1: Tab, 1
  {
    Gui, 1: Add, DDL,       x18  y42            vDdlView  gDdlView  , Laden|
    Gui, 1: Add, Text,      x150 y46 h18  w600  vFile               , <<PFAD>>
    Gui, 1: Add, TreeView,  x18  y66 h330 w690  vtTreeView +WantF2
  }
  
  Gui, 1: Tab, 2
  {
    Gui, 1: Add, Text, , Hier sind die entsprechenden Buttons zu installieren!!!
  }
  
  if (DEBUG == TRUE)
  {
    Gui, 1: Tab, 3
    {
      Gui, 1: Add, Edit,    x18 y36 h360 w690  vContent  -Wrap     , 
    }
  }
  
  Gui, 1: Submit, NoHide
  Gui, 1: Show, Center Autosize, %NAME%
  WinSet, ExStyle, -0x80000, %NAME%
}
Return    ; <<<===  Main ending

DdlView:
{
  Gui, Submit, NoHide                             ; submit data
  
  if (DdlView == "Laden")                         ; Load choosen
  {
    TV_Delete()                                   ; empty treeview
    FileSelectFile, File, 3, , , JSON-File (*.json)
    GuiControl, , File, %File%                    ; clear up before adding
    FileRead, data, %File%                        ; take path from previous FileSelectFile
    obj := JSON.Load(data)                        ; JSON.Load by cocobelgica (from github)
    
    GuiControl, , DdlView, |                      ; clear up before adding
    if (obj["__data_type"]== "GIT ")
    {
      s =
      c =
      for i in obj
        s .= i "|"
        
      MsgBox, 48, , Laden der Datei abgeschlossen
      StrReplace(s, "|", "|", c)
      CountDdlContent := c
      ddlcont := StrReplace(s, "__data_type", "Laden")
    }
    
    GuiControl, , DdlView, % ddlcont              ; update DDL
  }
  else
  {
    TV_Delete()                                   ; empty treeview
    GuiControl, -Redraw, tTreeView                ; pause redrawing the treeview
    
    if (DdlView <> "AreaProperties")
    {
      s =
      c =
      for i in obj[DdlView].value[1]
        s .= i "|"
    }
    else
    {
      s = 
      c = 
      for i in obj[DdlView]["value"]
        s .= i "|"
    }
    
;    Loop, %items%
;    {
;       if (obj[DdlView].value[%A_Index%][__struct_id].value > 0)
;         loops := loops + 1
;    }
    
    StrReplace(s, "|", "|", c)
    s := SubStr(s, 1, StrLen(s)-1)
    s := StrReplace(s, "__struct_id", c-1)
    
    GuiControl, -Redraw, tTreeView
    Pa := TV_Add(DdlView)
    if (DdlView <> "AreaProperties")
    {
      for i, w in obj[DdlView]
      {
        Ch := TV_Add(i, Pa)
              TV_Add(w,  Ch)
        if (i == "value")
        {
          t := SubStr(s, InStr(s, "|")+1, StrLen(s)-InStr(s, "|"))
          Loop, Parse, t, "|"
          {
            MsgBox % A_LoopField
            if (A_LoopField)
            {
              Ba := TV_Add(A_LoopField, Ch)                       ; TODO how to add the items?
                    TV_Add(obj[DdlView].value[1][A_LoopField].value, Ba)
            }
          }
        }
      }
    }
    else
    {
      for i, w in obj[DdlView]
      {
        Ch := TV_Add(i, Pa)
              TV_Add(w,  Ch)
        if (i == "value")
        {
          t := SubStr(s, InStr(s, "|")+1, StrLen(s)-InStr(s, "|"))
          Loop, Parse, t, "|"
          {
            if (A_LoopField)
            {
              Ba := TV_Add(A_LoopField, Ch)
                    TV_Add(obj[DdlView]["value"][A_LoopField]["value"], Ba)
            }
          }
        }
      }
    }
    
    GuiControl, +Redraw, tTreeView                ; redraw it
  }
}
Return

;================================================================================
;                                             Following Funcs needs only this app
;================================================================================



;================================================================================
;                                                    Ending and closing the GUI's
;================================================================================


; Ends app and destroys program
GuiClose:
GuiEscape:
  Pa = 
  Ch = 
  Ba = 
  t = 
  i = 
  w = 
  s = 
  c = 
  data = 
  File = 
  DdlView = 
  obj := ""
  ExitApp