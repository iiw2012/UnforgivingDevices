;/  File: UD_ModTrigger_ItemObtain
    It triggers with a given chance after actor obtains an item
    
    NameFull: On Obtain Item
    
    Parameters in DataStr:
        [0]     Int         (optional) Minimun number of items to trigger
                            Default value: 1
        
        [1]     Float       (optional) Base probability to trigger (in %)
                            Default value: 100.0%
        
        [2]     Float       (optional) Probability to trigger that is proportional to the accumulated value (number of obtained items)
                            Default value: 0.0%
                        
        [3]     Float       (optional) Reset period (in hours). If negative then it triggers once
                            Default value: -1.0 (It triggers once)
                        
        [4]     Int         (optional) Only stolen items count
                            Default value: 0 (False)
                        
        [5]     Int         (script) Number of obtained items so far
        
        [6]     Float       (script) Timestamp of the last trigger. (-1.0 if it is triggered once without repeat option)

    Form arguments:
        Form1               Form or FormList with Forms to filter obtained items. Keywords don't work
    
    Example:
        DataStr = 1,100,0,24,,,        
        Form1   = FoodSweetroll     It will be 100% triggered when wearer receives a Sweet Roll, 
                                    but not more than once every 24 hours
/;
Scriptname UD_ModTrigger_ItemObtain extends UD_ModTrigger

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

Bool Function DeviceLocked(UD_Modifier_Combo akModifier, UD_CustomDevice_RenderScript akDevice, String aiDataStr, Form akForm1)
    UD_CustomDevice_NPCSlot loc_slot = akDevice.UD_WearerSlot
    loc_slot.RegisterItemEvent(akForm1)
    
    Float loc_timer = akDevice.GetGameTimeLockedTime()
    SetParamFlt(akModifier, akDevice, 6, loc_timer)

    If RandomFloat(0.0, 100.0) < 30.0 * akModifier.MultVerboseness
        PrintNotification(akDevice, ;/ reacted /;"because of the items in your inventory. An image of an " + akForm1.GetName() + " appears in front of your eyes for a second.")
    EndIf
    
    Return False
EndFunction

Bool Function DeviceUnlocked(UD_Modifier_Combo akModifier, UD_CustomDevice_RenderScript akDevice, String aiDataStr, Form akForm1)
    UD_CustomDevice_NPCSlot loc_slot = akDevice.UD_WearerSlot
    loc_slot.UnregisterItemEvent(akForm1)
    
    Return False
EndFunction

Bool Function ItemAdded(UD_Modifier_Combo akModifier, UD_CustomDevice_RenderScript akDevice, Form akItemForm, Int aiItemCount, ObjectReference akSourceContainer, Bool abIsStolen, String aiDataStr, Form akForm1)
    If !_IsValidForm(akForm1, akItemForm)
        Return False
    EndIf
    If UDmain.TraceAllowed()
        UDmain.Log("UD_ModTrigger_ItemObtain::ItemAdded() akItemForm = " + akItemForm + " abIsStolen = " + abIsStolen, 3)
    EndIf
    
    Int loc_min_count       = GetParamInt(akModifier, aiDataStr, 0, 1,      "Input")
    Float loc_prob1         = GetParamFlt(akModifier, aiDataStr, 1, 100.0,  "Probability")
    Float loc_prob2         = GetParamFlt(akModifier, aiDataStr, 2, 0.0,    "Probability")
    Float loc_period        = GetParamFlt(akModifier, aiDataStr, 3, -1.0,   "-Input")
    Bool loc_stolen         = GetParamBln(akModifier, aiDataStr, 4, False)
    Int loc_acc             = GetParamInt(akModifier, aiDataStr, 5, 0)
    Float loc_last          = GetParamFlt(akModifier, aiDataStr, 6, 0.0)
    
    If loc_last < 0.0 && loc_period <= 0.0
    ; already triggered with trigger-once settings
        Return False
    EndIf
    
    If RandomFloat(0.0, 100.0) < 30.0 * akModifier.MultVerboseness
        PrintNotification(akDevice, ;/ reacted /;"because of the items in your inventory. An image of an " + akForm1.GetName() + " appears in front of your eyes for a second.")
    EndIf

    Bool loc_result = False
    If loc_stolen && !abIsStolen
        Return False
    EndIf
    Float loc_timer = akDevice.GetGameTimeLockedTime()
    loc_acc += aiItemCount
    
    If (loc_last + loc_period) <= loc_timer && loc_min_count <= loc_acc
        If RandomFloat(0.0, 100.0) < (loc_prob1 + loc_prob2 * loc_acc)
            loc_result = True
            loc_acc = 0
            loc_last = loc_timer
            If loc_period <= 0.0
            ; triggered once
                loc_last = -1.0
            EndIf
        EndIf
    EndIf
    SetParamInt(akModifier, akDevice, 5, loc_acc)
    SetParamFlt(akModifier, akDevice, 6, loc_last)
    
    Return loc_result
EndFunction

Bool Function ItemRemoved(UD_Modifier_Combo akModifier, UD_CustomDevice_RenderScript akDevice, Form akItemForm, Int aiItemCount, ObjectReference akDestContainer, String aiDataStr, Form akForm1)
    Return False
EndFunction

;/  Group: User interface
===========================================================================================
===========================================================================================
===========================================================================================
/;
String Function GetParamsTableRows(UD_Modifier_Combo akModifier, UD_CustomDevice_RenderScript akDevice, String aiDataStr, Form akForm1)
    String loc_res = ""
    Int loc_min_count       = GetParamInt(akModifier, aiDataStr, 0, 1,      "Input")
    Float loc_prob1         = GetParamFlt(akModifier, aiDataStr, 1, 100.0,  "Probability")
    Float loc_prob2         = GetParamFlt(akModifier, aiDataStr, 2, 0.0,    "Probability")
    Float loc_period        = GetParamFlt(akModifier, aiDataStr, 3, -1.0,   "-Input")
    Bool loc_stolen         = GetParamBln(akModifier, aiDataStr, 4, False)
    Int loc_acc             = GetParamInt(akModifier, aiDataStr, 5, 0)
    Float loc_last          = GetParamFlt(akModifier, aiDataStr, 6, 0.0)
    
    loc_res += UDmain.UDMTF.TableRowDetails("Min. num. of items:",  loc_min_count As String)
    loc_res += UDmain.UDMTF.TableRowDetails("Base probability:",    FormatFloat(loc_prob1, 1) + "%")
    loc_res += UDmain.UDMTF.TableRowDetails("Accum weight:",        FormatFloat(loc_prob2, 1) + "%")
    loc_res += UDmain.UDMTF.TableRowDetails("Reset period:",        FormatFloat(loc_period, 1) + " hours")
    loc_res += UDmain.UDMTF.TableRowDetails("Only stolen items:",   InlineIfStr(loc_stolen, "True", "False"))
    loc_res += UDmain.UDMTF.TableRowDetails("Items obtained:",      loc_acc As String)
    loc_res += UDmain.UDMTF.TableRowDetails("Timestamp:",           FormatFloat(loc_last, 2))
    Return loc_res
EndFunction
