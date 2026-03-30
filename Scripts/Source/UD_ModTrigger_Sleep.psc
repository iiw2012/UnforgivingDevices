;/  File: UD_ModTrigger_Sleep
    It triggers with a given chance after sleep
    
    NameFull: On Sleep
    
    Parameters in DataStr:
        [0]     Int         (optional) Minimum sleep duration to trigger (in hours)
                            Default value: 0 hours

        [1]     Float       (optional) Base probability to trigger (in %)
                            Default value: 100.0%

        [2]     Float       (optional) Probability to trigger is proportional to the sleep duration
                            Default value: 0.0%

        [3]     Int         (optional) Normal = 1, interrupted = 2 or any = 0
                            Default value: 0 (Any)

        [4]     Int         (optional) Repeat
                            Default value: 0 (False)

        [5]     Float       (script) Memory

    Example:

/;
Scriptname UD_ModTrigger_Sleep extends UD_ModTrigger

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
Bool Function Sleep(UD_Modifier_Combo akModifier, UD_CustomDevice_RenderScript akDevice, Float afDuration, Bool abInterrupted, String asDataStr, Form akForm1)
    Int loc_min_dur         = GetParamInt(akModifier, asDataStr, 0, 0,      "Input")
    Float loc_prob_base     = GetParamFlt(akModifier, asDataStr, 1, 100.0,  "Probability")
    Float loc_prob_accum    = GetParamFlt(akModifier, asDataStr, 2, 0.0,    "Probability")
    Int loc_ending          = GetParamInt(akModifier, asDataStr, 3, 0)
    Bool loc_repeat         = GetParamBln(akModifier, asDataStr, 4, False)
    If (loc_ending == 2 && !abInterrupted) || (loc_ending == 1 && abInterrupted)
        Return False
    EndIf

    If BaseTriggerIsActive(asDataStr, 5) && RandomFloat(0.0, 100.0) < 30.0 * akModifier.MultVerboseness
        PrintNotification(akDevice, ;/ reacted /;"in response to your awakening from sleep.")
    EndIf

    Return TriggerOnValueAbs(akDevice, akModifier.NameAlias, asDataStr, afValueAbs = afDuration, afMinValue = loc_min_dur, afProbBase = loc_prob_base, afProbAccum = loc_prob_accum, abRepeat = loc_repeat, aiLastTriggerValueIndex = 5)
EndFunction

;/  Group: User interface
===========================================================================================
===========================================================================================
===========================================================================================
/;
String Function GetParamsTableRows(UD_Modifier_Combo akModifier, UD_CustomDevice_RenderScript akDevice, String asDataStr, Form akForm1)
    Int loc_min_dur         = GetParamInt(akModifier, asDataStr, 0, 0,      "Input")
    Float loc_prob_base     = GetParamFlt(akModifier, asDataStr, 1, 100.0,  "Probability")
    Float loc_prob_accum    = GetParamFlt(akModifier, asDataStr, 2, 0.0,    "Probability")
    Int loc_ending          = GetParamInt(akModifier, asDataStr, 3, 0)
    Bool loc_repeat         = GetParamBln(akModifier, asDataStr, 4, False)
    String loc_res = ""
    String loc_frag = ""
    If loc_ending == 0
        loc_frag = "Any"
    ElseIf loc_ending == 1
        loc_frag = "Normal"
    ElseIf loc_ending == 2
        loc_frag = "Interrupted"
    EndIf
    loc_res += UDmain.UDMTF.TableRowDetails("Threshold value:",         loc_min_dur + " hours")
    loc_res += UDmain.UDMTF.TableRowDetails("Base probability:",        FormatFloat(loc_prob_base, 1) + "%")
    loc_res += UDmain.UDMTF.TableRowDetails("Accumulator weight:",      FormatFloat(loc_prob_accum, 2) + "%")
    loc_res += UDmain.UDMTF.TableRowDetails("Sleep condition:",         loc_frag)
    loc_res += UDmain.UDMTF.TableRowDetails("Repeat:",                  InlineIfStr(loc_repeat, "True", "False"))
    Return loc_res
EndFunction
