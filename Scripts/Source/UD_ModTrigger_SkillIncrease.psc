;/  File: UD_ModTrigger_SkillIncrease
    It triggers on player's skill increase
    
    NameFull: On Skill Increase
    
    Parameters in DataStr:
        [0]     String      Skill name (for skill names see https://ck.uesp.net/wiki/Actor_Value)
                                OneHanded
                                TwoHanded
                                Marksman (Archery)
                                Block
                                Smithing
                                HeavyArmor
                                LightArmor
                                Pickpocket
                                Lockpicking
                                Sneak
                                Alchemy
                                Speechcraft (Speech)
                                Alteration
                                Conjuration
                                Destruction
                                Illusion
                                Restoration
                                Enchanting

        [1]     Int         (optional) Minimum delta to trigger
                            Default value: 0

        [2]     Float       (optional) Base probability to trigger on event (in %)
                            Default value: 100.0%

        [3]     Float       (optional) Probability to trigger that is proportional to the accumulated value (delta)
                            Default value: 0.0%

        [4]     Int         (optional) Repeat
                            Default value: 0 (False)

        [5]     Int         (script) Accumulated value (delta)

    Example:
        Destruction,,,,1    It triggers on every increase of the magic skill of Destruction
        OneHanded,3,50      It triggers once with a 50% chance on OneHanded skill increase starting from the third increase

/;
Scriptname UD_ModTrigger_SkillIncrease extends UD_ModTrigger

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
Bool Function SkillIncreased(UD_Modifier_Combo akModifier, UD_CustomDevice_RenderScript akDevice, String asSkill, Int aiValue, String aiDataStr, Form akForm1)
    String loc_skill        = GetParamStr(akModifier, aiDataStr, 0, "")
    If asSkill != loc_skill
        Return False
    EndIf
    Int loc_min_delta       = GetParamInt(akModifier, aiDataStr, 1, 0,      "Input")
    Float loc_prob_base     = GetParamFlt(akModifier, aiDataStr, 2, 100.0,  "Probability")
    Float loc_prob_accum    = GetParamFlt(akModifier, aiDataStr, 3, 0.0,    "Probability")
    Bool loc_repeat         = GetParamBln(akModifier, aiDataStr, 4, False)

    If BaseTriggerIsActive(aiDataStr, 5) && RandomFloat(0.0, 100.0) < 100.0 * akModifier.MultVerboseness
        PrintNotification(akDevice, ;/ reacted /;"in response to your new knowledge.")
    EndIf

    Return TriggerOnValueDelta(akDevice, akModifier.NameAlias, aiDataStr, afValueDelta = 1, afMinAccum = loc_min_delta, afProbBase = loc_prob_base, afProbAccum = loc_prob_accum, abRepeat = loc_repeat, aiAccumParamIndex = 5)
EndFunction

;/  Group: User interface
===========================================================================================
===========================================================================================
===========================================================================================
/;
String Function GetParamsTableRows(UD_Modifier_Combo akModifier, UD_CustomDevice_RenderScript akDevice, String aiDataStr, Form akForm1)
    String loc_skill        = GetParamStr(akModifier, aiDataStr, 0, "") 
    Int loc_min_delta       = GetParamInt(akModifier, aiDataStr, 1, 0,      "Input")
    Float loc_prob_base     = GetParamFlt(akModifier, aiDataStr, 2, 100.0,  "Probability")
    Float loc_prob_accum    = GetParamFlt(akModifier, aiDataStr, 3, 0.0,    "Probability")
    Bool loc_repeat         = GetParamBln(akModifier, aiDataStr, 4, False)
    String loc_res = ""
    loc_res += UDmain.UDMTF.TableRowDetails("Skill name:",          loc_skill)
    loc_res += UDmain.UDMTF.TableRowDetails("Min delta:",           loc_min_delta)
    loc_res += UDmain.UDMTF.TableRowDetails("Base probability:",    FormatFloat(loc_prob_base, 1) + "%")
    loc_res += UDmain.UDMTF.TableRowDetails("Accumulator weight:",  FormatFloat(loc_prob_accum, 2) + "%")
    loc_res += UDmain.UDMTF.TableRowDetails("Repeat:",              InlineIfStr(loc_repeat, "True", "False"))
    loc_res += UDmain.UDMTF.TableRowDetails("Accumulator:",         FormatFloat(GetParamFlt(akModifier, aiDataStr, 5, 0.0), 0))
    loc_res += UDmain.UDMTF.Paragraph("(Accumulator contains the delta)", asAlign = "center")
    Return loc_res
EndFunction