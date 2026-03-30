;/  File: UD_ModTrigger_StatEvent
    It triggers on the change of statistics value
    
    NameFull: On Statistics Change
    
    Parameters in DataStr:
        [0]     String      Stat event to trigger
                                See https://ck.uesp.net/wiki/ListOfTrackedStats
                                Not all of those stats are working

        [1]     Int         (optional) Minimum accumulated stat value to trigger
                            Default value: 0 (chance on every call)

        [2]     Float       (optional) Probability to trigger on event in %
                            Default value: 100.0%

        [3]     Int         (optional) Repeat
                            Default value: 0 (False)

        [4]     Int         (script) Accumulated delta so far

    Example:
        Locks Picked,10,,1      - Triggers on every 10th lock picked
        Quests Completed,,10    - Triggers on completed quest with 10% probability
        
    Stats:
            asStatName                          aiStatValue

    WORKS:
        Locations Discovered                    (total number)
        Quests Completed                        (total number of completed quests)
        Whiterun Bounty                         <Bounty Value>
        Locks Picked                            (total number)
        Misc Objectives Completed               (total number)
        Skill Book Read                         (total number)
        Armor Made                              (total number)
        Dungeons Cleared                        (total number)
        Most Gold Carried                       (subj)
        Level Increases                         (current accepted level)
        Weapons Made                            (total number)
        Armor Made                              (total number)
        Pockets Picked                          (total number of items, and 1 gold counts as 1 item)

    WORKS BUT USELESS:
        Skill Increases                         <Skill value> (it is useless without skill name, use UD_ModTrigger_SkillIncrease instead)

    IT JUST WORKS (nope)
        Weapons Improved                        NOPE
        Training Sessions                       NOPE
        Potions Used                            NOPE
        Food Eaten                              NOPE
        Ingredients Harvested                   NOPE
        Ingredients Eaten                       NOPE
        Persuasions                             NOPE
        Hours Waiting                           NOPE
        Times Shouted                           NOPE
        Gold Found                              NOPE
        Murders                                 NOPE
        Assaults                                PROBABLY NOT
        Bunnies Slaughtered                     NOPE
        Items Stolen                            NOPE
/;
Scriptname UD_ModTrigger_StatEvent extends UD_ModTrigger

import UnforgivingDevicesMain
import UD_Native

String[] _FrequentEvents

Event OnInit()
    _FrequentEvents = Utility.CreateStringArray(0)
    _FrequentEvents = PapyrusUtil.PushString(_FrequentEvents, "Most Gold Carried")
EndEvent

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
Bool Function StatEvent(UD_Modifier_Combo akModifier, UD_CustomDevice_RenderScript akDevice, String asStatName, Int aiStatValue, String asDataStr, Form akForm1)
    If UDmain.TraceAllowed()
        UDmain.Log("UD_ModTrigger_StatEvent::StatEvent() akModifier = " + akModifier + ", akDevice = " + akDevice + ", asStatName = " + asStatName + ", aiStatValue = " + aiStatValue + ", asDataStr = " + asDataStr, 3)
    EndIf
    If asStatName == "Locks Picked" && UDCDmain.actorInMinigame(akDevice.GetWearer())
    ; in case the wearer picks lock in minigame
        Return False
    EndIf
    If asStatName != GetParamStr(akModifier, asDataStr, 0, "")
        Return False
    EndIf
    Int loc_min_value       = GetParamInt(akModifier, asDataStr, 1, 0,      "Input")
    Float loc_prob_base     = GetParamFlt(akModifier, asDataStr, 2, 100.0,  "Probability")
    Bool loc_repeat         = GetParamBln(akModifier, asDataStr, 3, False)

    Bool loc_rare_events = PapyrusUtil.CountString(_FrequentEvents, asStatName) == 0
    If BaseTriggerIsActive(asDataStr, 4) && RandomFloat(0.0, 100.0) < (2.0 * (1.0 + 9.0 * (loc_rare_events As Int))) * akModifier.MultVerboseness
        PrintNotification(akDevice, ;/ reacted /;"to your actions. You try in vain to understand what caused this response.")
    EndIf
    
    If StringUtil.Find(asStatName, "Bounty") >= 0
        Return TriggerOnValueAbs(akDevice, akModifier.NameAlias, asDataStr, afValueAbs = aiStatValue, afMinValue = loc_min_value, afProbBase = loc_prob_base, abRepeat = loc_repeat, aiLastTriggerValueIndex = 4)
    Else
        Return TriggerOnValueDelta(akDevice, akModifier.NameAlias, asDataStr, afValueDelta = 1, afMinAccum = loc_min_value, afProbBase = loc_prob_base, abRepeat = loc_repeat, aiAccumParamIndex = 4)
    EndIf
    
EndFunction

;/  Group: User interface
===========================================================================================
===========================================================================================
===========================================================================================
/;
String Function GetParamsTableRows(UD_Modifier_Combo akModifier, UD_CustomDevice_RenderScript akDevice, String asDataStr, Form akForm1)
    String loc_stat         = GetParamStr(akModifier, asDataStr, 0, "")
    Int loc_min_value       = GetParamInt(akModifier, asDataStr, 1, 0,      "Input")
    Float loc_prob_base     = GetParamFlt(akModifier, asDataStr, 2, 100.0,  "Probability")
    Bool loc_repeat         = GetParamBln(akModifier, asDataStr, 3, False)
    Float loc_accum         = GetParamFlt(akModifier, asDataStr, 4, 0.0)
    
    String loc_res = ""
    loc_res += UDmain.UDMTF.TableRowDetails("Stat name:",           loc_stat)
    loc_res += UDmain.UDMTF.TableRowDetails("Minimum acc. value:",  loc_min_value)
    loc_res += UDmain.UDMTF.TableRowDetails("Base probability:",    FormatFloat(loc_prob_base, 1) + "%")
    loc_res += UDmain.UDMTF.TableRowDetails("Repeat:",              InlineIfStr(loc_repeat, "True", "False"))
    loc_res += UDmain.UDMTF.TableRowDetails("Accumulator:",         FormatFloat(loc_accum, 0))
    loc_res += UDmain.UDMTF.Paragraph("(Accumulator contains stat change since the last trigger)", asAlign = "center")
    Return loc_res
EndFunction