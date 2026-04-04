;/  File: UD_ModTrigger_DeviceEscAttempt
    It triggers with a given chance after actor's escape attempt
    
    NameFull: On Escape Attempt
    
    Parameters in DataStr:
        [0]     String      Minigame type to trigger:
                                <Empty string>          - Any minigame
                                AbadonPlug_ForceOut
                                Struggle_0              - Normal struggle
                                Struggle_1              - Desperate struggle
                                Struggle_2              - Magic struggle
                                Struggle_3              - Slow struggle
                                Struggle_5              - Useless struggle
                                Lockpick
                                RepairLock
                                Cutting
                                KeyUnlock
                                DHB_Untie
                                IflatablePlug_Inflate
                                IflatablePlug_Deflate
                                PanelGag_Unplug
                                Plug_ForceOut
                            (partial string matches are also counts)
                            Default: ""
                                
        [1]     Int         (optional) Minimum number of escape attempts to trigger
                            Default value: 0

        [2]     Float       (optional) Base probability to trigger (in %)
                            Default value: 100.0%

        [3]     Float       (optional) Probability to trigger that is proportional to the accumulated value (of consecutive attempts)
                            Default value: 0.0%

        [4]     Int         (optional) Repeat
                            Default value: 0 (False)
                            
        [5]     Int         (optional) React on all equipped devices
                            Default value: 0 (False)

        [6]     Int         (script) Number of consecutive attempts so far

    Example:
        
/;
Scriptname UD_ModTrigger_DeviceEscAttempt extends UD_ModTrigger

import UnforgivingDevicesMain
import UD_Native

;/  Group: Overrides
===========================================================================================
===========================================================================================
===========================================================================================
/;

;/  Group: Events Processing
===========================================================================================
===========================================================================================
===========================================================================================
/;
Bool Function MinigameEndedAsync(UD_Modifier_Combo akModifier, UD_CustomDevice_RenderScript akDevice, UD_CustomDevice_RenderScript akMinigameDevice, String asMinigameName, String asDataStr, Form akForm1)
    If BaseTriggerIsActive(asDataStr, 6) == False
        Return False
    EndIf
    If akDevice.IsUnlocked
        Return False
    EndIf
    
    String loc_minigame     = GetParamStr(akModifier, akDevice, asDataStr, 0, "")
    Int loc_min_value       = GetParamInt(akModifier, akDevice, asDataStr, 1, 0,          "Input")
    Float loc_prob_base     = GetParamFlt(akModifier, akDevice, asDataStr, 2, 100.0,      "Probability")
    Float loc_prob_accum    = GetParamFlt(akModifier, akDevice, asDataStr, 3, 0.0,        "Probability")
    Bool loc_repeat         = GetParamBln(akModifier, akDevice, asDataStr, 4, False)
    Bool loc_all            = GetParamBln(akModifier, akDevice, asDataStr, 5, False)
    
    If !loc_all && akDevice != akMinigameDevice
        Return False
    EndIf
    If StringUtil.GetLength(loc_minigame) > 0 && StringUtil.Find(asMinigameName, loc_minigame) < 0
        Return False
    EndIf
    If TriggerOnValueDelta(akDevice, akModifier.NameAlias, asDataStr, afValueDelta = 1, afMinAccum = loc_min_value, afProbBase = loc_prob_base, afProbAccum = loc_prob_accum, abRepeat = loc_repeat, aiAccumParamIndex = 6)
        Return True
    Else
        If BaseTriggerIsActive(asDataStr, 4) && RandomFloat(0.0, 100.0) < 30.0 * akModifier.MultVerboseness
            If akDevice == akMinigameDevice
                PrintNotification(akDevice, ;/ reacted /;"the moment you stopped trying to escape out of it.")
            Else
                PrintNotification(akDevice, ;/ reacted /;"the moment you stopped trying to escape out of another contraption.")
            EndIf
        EndIf
        Return False
    EndIf
EndFunction

;/  Group: User interface
===========================================================================================
===========================================================================================
===========================================================================================
/;
String Function GetParamsTableRows(UD_Modifier_Combo akModifier, UD_CustomDevice_RenderScript akDevice, String asDataStr, Form akForm1)
    String loc_minigame     = GetParamStr(akModifier, akDevice, asDataStr, 0, "Any",      "Input")
    Int loc_min_value       = GetParamInt(akModifier, akDevice, asDataStr, 1, 0,          "Input")
    Float loc_prob_base     = GetParamFlt(akModifier, akDevice, asDataStr, 2, 100.0,      "Probability")
    Float loc_prob_accum    = GetParamFlt(akModifier, akDevice, asDataStr, 3, 0.0,        "Probability")
    Bool loc_repeat         = GetParamBln(akModifier, akDevice, asDataStr, 4, False)
    Bool loc_all            = GetParamBln(akModifier, akDevice, asDataStr, 5, False)
    
    String loc_res = ""
    loc_res += UDmain.UDMTF.TableRowDetails("Minigame:",                loc_minigame)
    loc_res += UDmain.UDMTF.TableRowDetails("Threshold value:",         loc_min_value As String)
    loc_res += UDmain.UDMTF.TableRowDetails("Base probability:",        FormatFloat(loc_prob_base, 1) + "%")
    loc_res += UDmain.UDMTF.TableRowDetails("Accumulator weight:",      FormatFloat(loc_prob_accum, 2) + "%")
    loc_res += UDmain.UDMTF.TableRowDetails("Repeat:",                  InlineIfStr(loc_repeat, "True", "False"))
    loc_res += UDmain.UDMTF.TableRowDetails("React on all devices:",    InlineIfStr(loc_all, "True", "False"))
    loc_res += UDmain.UDMTF.TableRowDetails("Accumulator:",             FormatFloat(GetParamFlt(akModifier, akDevice, asDataStr, 6, 0.0), 0))
    loc_res += UDmain.UDMTF.Paragraph("(Accumulator contains the number of consecutive orgasms)", asAlign = "center")
    Return loc_res
EndFunction
