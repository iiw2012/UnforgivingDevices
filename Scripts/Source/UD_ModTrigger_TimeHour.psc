;/  File: UD_ModTrigger_TimeHour
    It triggers every hour with a given probability
    
    NameFull: Hourly Trigger
    
    Parameters in DataStr:
        [0]     Float       (optional) Hours must pass before trigger
                            Default value: 0.0

        [1]     Float       (optional) Base probability to trigger
                            Default value: 100.0%

        [2]     Float       (optional) The final probability increases with each passed hour by X %
                            Default value: 0.0%

        [3]     Int         (optional) Repeat
                            Default value: 1 (True)

        [4]     Float       (script) Hours passed since last trigger

        [5]     Float       (script) Hours passed since last check. Used to set the initial period offset, and to spread the execution of hour triggers to different moments.

    Example:
                    
/;
Scriptname UD_ModTrigger_TimeHour extends UD_ModTrigger

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
    Float loc_last_check    = GetParamFlt(akModifier, aiDataStr, 5, 0.0)

    If !BaseTriggerIsActive(aiDataStr, 4)
        Return False
    EndIf

    If loc_last_check + afGameHoursSinceLastCall > 1.00
        SetParamFlt(akModifier, akDevice, 5, 0.000)
    Else
    ; using string version for extra precision
        SetParamStr(akModifier, akDevice, 5, FormatFloat(loc_last_check + afGameHoursSinceLastCall, 3))
        Return False
    EndIf

    If RandomFloat(0.0, 100.0) < 15.0 * akModifier.MultVerboseness
        PrintNotification(akDevice, "You feel that your " + akDevice.UD_DeviceType + " pulsing faintly and slowly, as if responding to the passage of time.", aiEffectId = 0)
    EndIf
    If TickTackSound && RandomFloat(0.0, 100.0) < 35.0 * akModifier.MultVerboseness
        TickTackSound.Play(akDevice.GetWearer())
    EndIf

    Return TriggerOnValueDelta(akDevice, akModifier.NameAlias, aiDataStr, afValueDelta = afGameHoursSinceLastCall, afMinAccum = loc_min_value, afProbBase = loc_prob_base, afProbAccum = loc_prob_acc, abRepeat = loc_repeat, aiAccumParamIndex = 4)
EndFunction

Bool Function TimeUpdateHour(UD_Modifier_Combo akModifier, UD_CustomDevice_RenderScript akDevice, Float afGameHoursSinceLastCall, String aiDataStr, Form akForm1)
    Return False
;/    
    Float loc_min_value = MultFloat(GetStringParamInt(aiDataStr, 0, 0, "Input")
    Float loc_prob_base = GetParamFlt(akModifier, aiDataStr, 1, 100.0, "Probability")
    Float loc_prob_acc = GetParamFlt(akModifier, aiDataStr, 2, 0.0, "Probability")
    Bool loc_repeat = GetStringParamInt(aiDataStr, 3, 1) > 0

    If BaseTriggerIsActive(aiDataStr, 4) && RandomFloat(0.0, 100.0) < 30.0 * akModifier.MultVerboseness
        PrintNotification(akDevice, "You feel that your " + akDevice.UD_DeviceType + " pulsing faintly and slowly, as if responding to the passage of time.", aiEffectId = 0)
    EndIf

    Return TriggerOnValueDelta(akDevice, akModifier.NameAlias, aiDataStr, afValueDelta = afGameHoursSinceLastCall, afMinAccum = loc_min_value, afProbBase = loc_prob_base, afProbAccum = loc_prob_acc, abRepeat = loc_repeat, aiAccumParamIndex = 4)
/;
EndFunction

Bool Function DeviceLocked(UD_Modifier_Combo akModifier, UD_CustomDevice_RenderScript akDevice, String aiDataStr, Form akForm1)
; saving a random number in parameter #5 to distribute the hourly triggers evenly throughout the cycle
    Float loc_offset = RandomFloat(-0.45, 0.45)
    SetParamFlt(akModifier, akDevice, 5, loc_offset)
    If UDmain.TraceAllowed()
        UDmain.Log(Self + "::DeviceLocked() loc_offset = " + FormatFloat(loc_offset, 2), 3)
    EndIf
    Return False
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
    loc_res += UDmain.UDMTF.TableRowDetails("Threshold value:",     FormatFloat(loc_min_value, 2) + " hours")
    loc_res += UDmain.UDMTF.TableRowDetails("Base probability:",    FormatFloat(loc_prob_base, 1) + "%")
    loc_res += UDmain.UDMTF.TableRowDetails("Value weight:",        FormatFloat(loc_prob_acc, 1) + "% per hour")
    loc_res += UDmain.UDMTF.TableRowDetails("Repeat:",              InlineIfStr(loc_repeat, "True", "False"))
    loc_res += UDmain.UDMTF.TableRowDetails("Accumulator:",         FormatFloat(loc_accum, 2) + " hours")
    loc_res += UDmain.UDMTF.Paragraph("(Accumulator contains hours passed since the last trigger)", asAlign = "center")
    Return loc_res
EndFunction