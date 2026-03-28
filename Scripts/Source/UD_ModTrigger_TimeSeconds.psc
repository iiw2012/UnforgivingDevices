;/  File: UD_ModTrigger_TimeSeconds
    It triggers every few seconds with a given probability
    
    NameFull: Fast Trigger
    
    Parameters in DataStr:
        [0]     Float       (optional) Hours must pass before trigger
                            Default value: 0.0

        [1]     Float       (optional) Base probability to trigger (per in-game hour)
                            Default value: 100.0%

        [2]     Float       (optional) The final probability increases with each passed hour by X %
                            Default value: 0.0%

        [3]     Int         (optional) Repeat
                            Default value: 1 (True)

        [4]     Float       (script) Hours passed since last trigger

    Example:
                    
/;
Scriptname UD_ModTrigger_TimeSeconds extends UD_ModTrigger

import UnforgivingDevicesMain
import UD_Native

Sound       Property TickTackSound      Auto

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
Bool Function TimeUpdateSeconds(UD_Modifier_Combo akModifier, UD_CustomDevice_RenderScript akDevice, Float afGameHoursSinceLastCall, Float afRealSecondsSinceLastCall, String aiDataStr, Form akForm1)
    Float loc_min_value     = GetParamFlt(akModifier, aiDataStr, 0, 0,      "Input")
    Float loc_prob_base     = GetParamFlt(akModifier, aiDataStr, 1, 100.0,  "Probability")
    Float loc_prob_acc      = GetParamFlt(akModifier, aiDataStr, 2, 0.0,    "Probability")
    Bool loc_repeat         = GetParamBln(akModifier, aiDataStr, 3, False)
    
    If !BaseTriggerIsActive(aiDataStr, 4)
        Return False
    EndIf
    
    If RandomFloat(0.0, 100.0) < 1.0 * akModifier.MultVerboseness
        PrintNotification(akDevice, "You feel that your " + akDevice.UD_DeviceType + " pulsing fast, as if responding to the passage of time.", aiEffectId = 0)
    EndIf
    If TickTackSound && RandomFloat(0.0, 100.0) < 5.0 * akModifier.MultVerboseness
        TickTackSound.Play(akDevice.GetWearer())
    EndIf

    Return TriggerOnValueDelta(akDevice, akModifier.NameAlias, aiDataStr, afValueDelta = afGameHoursSinceLastCall, afMinAccum = loc_min_value, afProbBase = loc_prob_base, afProbAccum = loc_prob_acc, abRepeat = loc_repeat, aiAccumParamIndex = 4)
EndFunction

;/  Group: User interface
===========================================================================================
===========================================================================================
===========================================================================================
/;
String Function GetParamsTableRows(UD_Modifier_Combo akModifier, UD_CustomDevice_RenderScript akDevice, String aiDataStr, Form akForm1)
    Float loc_min_value     = GetParamFlt(akModifier, aiDataStr, 0, 0,      "Input")
    Float loc_prob_base     = GetParamFlt(akModifier, aiDataStr, 1, 100.0,  "Probability")
    Float loc_prob_acc      = GetParamFlt(akModifier, aiDataStr, 2, 0.0,    "Probability")
    Bool loc_repeat         = GetParamBln(akModifier, aiDataStr, 3, False)
    Float loc_accum         = GetParamFlt(akModifier, aiDataStr, 4, 0.0)
    
    String loc_res = ""
    loc_res += UDmain.UDMTF.TableRowDetails("Threshold value:",         FormatFloat(loc_min_value, 2) + " hours")
    loc_res += UDmain.UDMTF.TableRowDetails("Base probability:",        FormatFloat(loc_prob_base, 1) + "%")
    loc_res += UDmain.UDMTF.TableRowDetails("Value weight:",            FormatFloat(loc_prob_acc, 1) + "% per hour")
    loc_res += UDmain.UDMTF.TableRowDetails("Repeat:",                  InlineIfStr(loc_repeat, "True", "False"))
    loc_res += UDmain.UDMTF.TableRowDetails("Accumulator:",             FormatFloat(loc_accum, 2) + " hours")
    loc_res += UDmain.UDMTF.Paragraph("(Accumulator contains hours passed since the last trigger)", asAlign = "center")
    Return loc_res
EndFunction