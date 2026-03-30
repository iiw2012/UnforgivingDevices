;/  File: UD_ModTrigger_Orgasm
    It triggers with a given chance after actor's orgasm
    
    NameFull: On Orgasm
    
    Parameters in DataStr:
        [0]     Int         (optional) Minimum number of orgasms to trigger
                            Default value: 0

        [1]     Float       (optional) Base probability to trigger (in %)
                            Default value: 100.0%

        [2]     Float       (optional) Probability to trigger that is proportional to the accumulated value (of consecutive orgasms)
                            Default value: 0.0%

        [3]     Int         (optional) Repeat
                            Default value: 0 (False)

        [4]     Int         (script) Number of consecutive orgasms so far

    Example:
        
/;
Scriptname UD_ModTrigger_Orgasm extends UD_ModTrigger

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
Bool Function Orgasm(UD_Modifier_Combo akModifier, UD_CustomDevice_RenderScript akDevice, String asDataStr, Form akForm1)
    Int loc_min_value       = GetParamInt(akModifier, asDataStr, 0, 0,          "Input")
    Float loc_prob_base     = GetParamFlt(akModifier, asDataStr, 1, 100.0,      "Probability")
    Float loc_prob_accum    = GetParamFlt(akModifier, asDataStr, 2, 0.0,        "Probability")
    Bool loc_repeat         = GetParamBln(akModifier, asDataStr, 3, False)

    If BaseTriggerIsActive(asDataStr, 4) && RandomFloat(0.0, 100.0) < 30.0 * akModifier.MultVerboseness
        PrintNotification(akDevice, ;/ reacted /;"while you shudder in the spasms of orgasm.")
    EndIf

    Return TriggerOnValueDelta(akDevice, akModifier.NameAlias, asDataStr, afValueDelta = 1, afMinAccum = loc_min_value, afProbBase = loc_prob_base, afProbAccum = loc_prob_accum, abRepeat = loc_repeat, aiAccumParamIndex = 4)
EndFunction

;/  Group: User interface
===========================================================================================
===========================================================================================
===========================================================================================
/;
String Function GetParamsTableRows(UD_Modifier_Combo akModifier, UD_CustomDevice_RenderScript akDevice, String asDataStr, Form akForm1)
    Int loc_min_value       = GetParamInt(akModifier, asDataStr, 0, 0,          "Input")
    Float loc_prob_base     = GetParamFlt(akModifier, asDataStr, 1, 100.0,      "Probability")
    Float loc_prob_accum    = GetParamFlt(akModifier, asDataStr, 2, 0.0,        "Probability")
    Bool loc_repeat         = GetParamBln(akModifier, asDataStr, 3, False)
    String loc_res = ""
    loc_res += UDmain.UDMTF.TableRowDetails("Threshold value:",         loc_min_value As String)
    loc_res += UDmain.UDMTF.TableRowDetails("Base probability:",        FormatFloat(loc_prob_base, 1) + "%")
    loc_res += UDmain.UDMTF.TableRowDetails("Accumulator weight:",      FormatFloat(loc_prob_accum, 2) + "%")
    loc_res += UDmain.UDMTF.TableRowDetails("Repeat:",                  InlineIfStr(loc_repeat, "True", "False"))
    loc_res += UDmain.UDMTF.TableRowDetails("Accumulator:",             FormatFloat(GetParamFlt(akModifier, asDataStr, 4, 0.0), 0))
    loc_res += UDmain.UDMTF.Paragraph("(Accumulator contains the number of consecutive orgasms)", asAlign = "center")
    Return loc_res
EndFunction
