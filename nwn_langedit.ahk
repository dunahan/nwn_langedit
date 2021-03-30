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
  
  Gui, 1: Add, Tab3, x6 y6 w720 h405 vTabA, %Tabs%
  Gui, 1: Tab, 1
  {
    Gui, 1: Add, Button,    x18 y36            gLoadFile           , Datei laden
    Gui, 1: Add, Text,      x96 y42 h18  w500  vLoadFile           , <<PFAD>>
    Gui, 1: Add, DDL,       x18 y60            vDdlView  gDdlView  , 
    
    Gui, 1: Add, TreeView,  x18 y84 h300 w600  vtTreeView ; ReadOnly -WantF2
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
  Gui, 1: +E0x80000000
  Gui, 1: Show, center autosize, %NAME%
  WinSet, exstyle, -0x80000, %NAME%
}
Return    ; <<<===  Main ending

LoadFile: ; LoadFile command
{
  FileSelectFile, a, 3, , Wähle Json-Datei, JSON-File (*.json)
  SplitPath, a, , , , File                    ; Strip out Filename
  If a = 
  {
    MsgBox, Nichts gewählt...
    GuiControl, , DdlView, |
    TV_Delete()
  }
  
  Else
  {
    GuiControl, , DdlView, |                  ; empty it first
    TV_Delete()
    GuiControl, , LoadFile, %a%               ; update path
    LoadFile := a                             ; save that in a var too
    FileRead, b, %a%
    
    c := JSON.Load(b)
    if (c["__data_type"] == "GIT ")
      d = Leer|AreaProperties|Creature List|Door List|Encounter List|Placeable List|SoundList|StoreList|TriggerList|WaypointList
    
    GuiControl, , DdlView, % d                ; update DDL
  }
  
  b = 
  c = 
  d = 
}
Return    ; Ends

DdlView:
{
  TV_Delete()
  Gui, Submit, NoHide
  FileRead, a, %LoadFile%
  b := JSON.Load(a)
  c := b[DdlView]
  
  if (DdlView <> "Leer")
  {
    GuiControl, , Content, % Obj2Str(c)           ; update Debug
    GuiControl, -Redraw, tTreeView
    {
      Pa := TV_Add(DdlView)                       ; TODO: find a way to add all the stuff?
      for index, wert in c
      {
        s .= index " = " wert "`n"
        Ch := TV_Add(index, Pa)
              TV_Add(wert,  Ch)
        
;       if (index == "value")
;       {
;         d := c["value"]
;         for subin in d
;         {
;           if (subin)
;           {
;             Va := TV_Add(subin, Ch)
;                   TV_Add(subin, Va)
;             
;             if (suboi == "value")
;             {
;               e := d["value"]
;               for suboi, subwi in e
;               {
;                 Vc := TV_Add(suboi, Va)
;                       TV_Add(subwi, Vc)
;               }
;             }
;           }
;         }
;       }
      }
      MsgBox, % s
    }
    GuiControl, +Redraw, tTreeView
  }
  else
  {
    GuiControl, , Content, 
    TV_Delete()
  }
  
  a = 
  b = 
  c = 
  d = 
  s = 
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
  ExitApp