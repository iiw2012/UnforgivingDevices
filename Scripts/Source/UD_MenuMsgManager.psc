Scriptname UD_MenuMsgManager extends Quest Conditional

Bool                    Property Ready = False                  Auto Hidden

UnforgivingDevicesMain  Property UDmain                         Auto

UD_MenuTextFormatter    Property UDMTF                          Auto

String[]                Property NoButtons                      Auto Hidden
Float[]                 Property NoValues                       Auto Hidden

Message                 Property MsgTemplate                    Auto

Bool                    Property currentMenu_button0 = false    Auto Conditional Hidden
Bool                    Property currentMenu_button1 = false    Auto Conditional Hidden
Bool                    Property currentMenu_button2 = false    Auto Conditional Hidden
Bool                    Property currentMenu_button3 = false    Auto Conditional Hidden
Bool                    Property currentMenu_button4 = false    Auto Conditional Hidden
Bool                    Property currentMenu_button5 = false    Auto Conditional Hidden
Bool                    Property currentMenu_button6 = false    Auto Conditional Hidden
Bool                    Property currentMenu_button7 = false    Auto Conditional Hidden
Bool                    Property currentMenu_button8 = false    Auto Conditional Hidden
Bool                    Property currentMenu_button9 = false    Auto Conditional Hidden

Event OnInit()
    RegisterForSingleUpdate(20.0)
EndEvent

Function OnUpdate()
    if UDmain.WaitForReady()
        Update()
    endif
EndFunction

Function Update()
    _Modes = Utility.CreateStringArray(0)
    NoButtons = Utility.CreateStringArray(0)
    NoValues = Utility.CreateFloatArray(0)
    UnregisterMenuEvents()
    RegisterMenuEvents()
    Ready = True
EndFunction

Function RegisterMenuEvents()
    RegisterForMenu("MessageBoxMenu")
EndFunction

Function UnregisterMenuEvents()
    UnregisterForAllMenus()
EndFunction

;/  Group: Mode Control
===========================================================================================
===========================================================================================
===========================================================================================
/;

String[] _Modes

;/  Function: GetModes

    The function returns all possible operation modes of the script as an array of strings
    
    Returns:
        Array of strings with possible modes
/;
String[] Function GetModes()
    If _Modes.Length == 0
        _Modes = Utility.CreateStringArray(3)
        _Modes[0] = "Legacy"
        _Modes[1] = "PapyrusUI"
    ;   _Modes[2] = "NativeUI"
    EndIf
    Return _Modes
EndFunction

;/  Function: SetMode

    The function sets new operation mode for the script
    
    Parameters:
        abMode                   - New operation mode
/;
Function SetMode(String abMode)
    If abMode == "Legacy"
        abMode = ""
    EndIf
    GoToState(abMode)
EndFunction

;/  Function: GetMode

    The function returns current operation mode of the script
    
    Returns:
        Operation mode
/;
String Function GetMode()
    If GetState() == ""
        Return "Legacy"
    EndIf
    Return GetState()
EndFunction

;/  Function: GetModeIndex

    The function returns index of the current operation mode
    
    Returns:
        Operation mode index
/;
Int Function GetModeIndex()
    If GetState() == ""
        Return 0
    EndIf
    Return GetModes().Find(GetState())
EndFunction

; State: Legacy

Event OnMenuOpen(String MenuName)
EndEvent

Bool Function IsMessageboxOpen()
    Return UI.IsMenuOpen("MessageBoxMenu")
EndFunction

Function ShowMessageBox(String asMessage, Bool abHasHTML = False)
    ; SplitMessageIntoPages should be compatible with both plain and html text if more advanced mode is used
    String[] loc_pages = UDMTF.SplitMessageIntoPages(asMessage)
    Int loc_i = 0
    While loc_i < loc_pages.Length
        ShowSingleMessageBox(loc_pages[loc_i], abHasHTML)
        loc_i += 1
    EndWhile

EndFunction

Function ShowSingleMessageBox(String asMessage, Bool abHasHTML = False)
    If abHasHTML 
        UDMain.Warning(Self + "::ShowSingleMessageBox() Legacy Mode: Can't display HTML text properly!")
    EndIf
    String loc_msg = asMessage
    If StringUtil.GetLength(loc_msg) > 2047
        UDMain.Warning(Self + "::ShowSingleMessageBox() Message is too long to display it on a single page!")
        loc_msg = StringUtil.Substring(loc_msg, 0, 2000) + " [message is too long]"
    EndIf
    Debug.MessageBox(loc_msg)

    ;wait for fucking messagebox to actually get OKd before continuing thread (holy FUCKING shit toad)
    Utility.waitMenuMode(0.3)
    while IsMessageboxOpen()
        Utility.waitMenuMode(0.05)
    EndWhile
EndFunction

Int Function ShowMessageBoxMenu(Message akTemplate, Float[] aafValues, String asMessageOverride, String[] aasButtonsOverride, Bool abHasHTML = False)

    If abHasHTML 
        UDMain.Warning(Self + "::ShowMessageBoxMenu() Legacy Mode: Can't display HTML text properly!")
    EndIf
    
    Int loc_last_btn = -1
    
    If akTemplate == None
        UDMain.Error(Self + "::ShowMessageBoxMenu() Legacy Mode: akTemplate must be specified!")
        Debug.MessageBox("ShowMessageBoxMenu() Legacy Mode: akTemplate must be specified!")
    Else
        loc_last_btn = _showMsgWithValues(akTemplate, aafValues)
    EndIf
    
    Return loc_last_btn
EndFunction
    
Bool        _InjectReady = False
Bool        _InjectMessageHTML = False
String      _InjectMessage = ""
String[]    _InjectButtons

Auto State PapyrusUI

; State: PapyrusUI

    Event OnMenuOpen(String MenuName)
        If UDmain.UDReady()
            If MenuName != "MessageBoxMenu" 
                Return
            Endif
            If _InjectReady
                _InjectReady = False
                String[] loc_args
                If _InjectMessage != ""
                    loc_args = Utility.CreateStringArray(2, "")
                    loc_args[0] = _InjectMessage
                    loc_args[1] = UDMTF.InlineIfString(_InjectMessageHTML, "1", "0")
                    UI.SetBool("MessageBoxMenu", "_root.MessageMenu" + ".MessageText.wordWrap", false)
                    UI.InvokeStringA("MessageBoxMenu", "_root.MessageMenu" + ".SetMessage", loc_args)
                    _InjectMessage = ""
                EndIf
                If _InjectButtons.Length > 0
                ; TODO
                    ; we should wait some time or something weird happens with the button focus
                    Utility.WaitMenuMode(0.1)
                    loc_args = Utility.CreateStringArray(_InjectButtons.Length + 1, "")
                    loc_args[0] = "1"
                    Int loc_i = 1
                    While loc_i < _InjectButtons.Length + 1
                        loc_args[loc_i] = _InjectButtons[loc_i - 1]
                        loc_i += 1
                    EndWhile
                    UI.InvokeStringA("MessageBoxMenu", "_root.MessageMenu" + ".setupButtons", loc_args)
                    _InjectButtons = Utility.CreateStringArray(0)
                EndIf
            EndIf
        Endif
    EndEvent

    Function ShowSingleMessageBox(String asMessage, Bool abHasHTML = False)
        String loc_msg = asMessage
        If StringUtil.GetLength(loc_msg) > 2047
            UDMain.Warning(Self + "::ShowSingleMessageBox() Message is too long to display it on a single page!")
            loc_msg = StringUtil.Substring(loc_msg, 0, 2000) + " [message is too long]"
        EndIf        
        If !abHasHTML
            Debug.MessageBox(loc_msg)
        Else
            Debug.MessageBox("Placeholder")
        
            String[] loc_args
            loc_args = Utility.CreateStringArray(2, "")
            loc_args[0] = loc_msg
            loc_args[1] = "1"

            UI.SetBool("MessageBoxMenu", "_root.MessageMenu" + ".MessageText.wordWrap", false)
            UI.InvokeStringA("MessageBoxMenu", "_root.MessageMenu" + ".SetMessage", loc_args)
        EndIf

        ;wait for fucking messagebox to actually get OKd before continuing thread (holy FUCKING shit toad)
        Utility.waitMenuMode(0.3)
        while IsMessageboxOpen()
            Utility.waitMenuMode(0.05)
        EndWhile
    EndFunction

    Int Function ShowMessageBoxMenu(Message akTemplate, Float[] aafValues, String asMessageOverride, String[] aasButtonsOverride, Bool abHasHTML = False)
        
        _InjectReady = True
        _InjectMessageHTML = abHasHTML
        _InjectMessage = asMessageOverride
        _InjectButtons = aasButtonsOverride
        
        Int loc_last_btn = -1
        
        If akTemplate == None
            ; TODO
            If aasButtonsOverride.Length == 0 || asMessageOverride == ""
                UDMain.Warning(Self + "::ShowMessageBoxMenu() PapyrusUI Mode: If no message template is specified, you must explicitly set the text and menu buttons!")
            EndIf
            _initButtons(aasButtonsOverride)
            loc_last_btn = MsgTemplate.Show()
        Else
            loc_last_btn = _showMsgWithValues(akTemplate, aafValues)
        EndIf
        
        Return loc_last_btn
    EndFunction

EndState

Function _initButtons(String[] aasButtonsOverride)
    currentMenu_button0 = aasButtonsOverride.Length > 0 && aasButtonsOverride[0] != ""
    currentMenu_button1 = aasButtonsOverride.Length > 1 && aasButtonsOverride[1] != ""
    currentMenu_button2 = aasButtonsOverride.Length > 2 && aasButtonsOverride[2] != ""
    currentMenu_button3 = aasButtonsOverride.Length > 3 && aasButtonsOverride[3] != ""
    currentMenu_button4 = aasButtonsOverride.Length > 4 && aasButtonsOverride[4] != ""
    currentMenu_button5 = aasButtonsOverride.Length > 5 && aasButtonsOverride[5] != ""
    currentMenu_button6 = aasButtonsOverride.Length > 6 && aasButtonsOverride[6] != ""
    currentMenu_button7 = aasButtonsOverride.Length > 7 && aasButtonsOverride[7] != ""
    currentMenu_button8 = aasButtonsOverride.Length > 8 && aasButtonsOverride[8] != ""
    currentMenu_button9 = aasButtonsOverride.Length > 9 && aasButtonsOverride[9] != ""
EndFunction

; get value from the array
Float Function _gv(Float[] aafValues, Int aiIndex, Float afDefault = 0.0)
    If aafValues.Length > aiIndex
        Return aafValues[aiIndex]
    Else
        Return afDefault
    EndIf
EndFunction

Int Function _showMsgWithValues(Message akMessage, Float[] vv)
    Return akMessage.Show(_gv(vv, 0), _gv(vv, 1), _gv(vv, 2), _gv(vv, 3), _gv(vv, 4), _gv(vv, 5), _gv(vv, 6), _gv(vv, 7), _gv(vv, 8))
EndFunction