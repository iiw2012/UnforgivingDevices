;/  File: UD_ModTrigger_ItemDemand
    It triggers with a given chance after actor failed to obtain an item before time expires
    
    NameFull: Item Demand
    
    Parameters in DataStr:
        [0]     Int         (optional) Number of items demanded
                            Default value: 1
        
        [1]     Float       (optional) Base probability to trigger (in %) at the end of the check period if actor failed to obtain items
                            Default value: 100.0%
        
        [2]     Int         (optional) Only stolen items count
                            Default value: 0 (False)
                        
        [3]     Float       (optional) The time given to obtain items (in hours)
                            Default value: 8.0
                        
        [4]     Int         (optional) Repeat
                            Default value: 0 (False)
                        
        [5]     Int         (script) Number of obtained items so far
        
        [6]     Float       (script) Device locked time in the moment of the last trigger (ingame hours).  (-1.0 if it is triggered once with no repeat option)

    Form arguments:
        Form1               Item or Keyword to filter demanded items
        
    Example:
        
/;
Scriptname UD_ModTrigger_ItemDemand extends UD_ModTrigger

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

Bool Function DeviceLocked(UD_Modifier_Combo akModifier, UD_CustomDevice_RenderScript akDevice, String asDataStr, Form akForm1)
    UD_CustomDevice_NPCSlot loc_slot = akDevice.UD_WearerSlot
    loc_slot.RegisterItemEvent(akForm1)
    
    Float loc_timer = akDevice.GetGameTimeLockedTime()
    SetParamFlt(akModifier, akDevice, 6, loc_timer)
    
    Return False
EndFunction

Bool Function DeviceUnlocked(UD_Modifier_Combo akModifier, UD_CustomDevice_RenderScript akDevice, String asDataStr, Form akForm1)
    UD_CustomDevice_NPCSlot loc_slot = akDevice.UD_WearerSlot
    loc_slot.UnregisterItemEvent(akForm1)
    
    Return False
EndFunction

Bool Function TimeUpdateHour(UD_Modifier_Combo akModifier, UD_CustomDevice_RenderScript akDevice, Float afGameHoursSinceLastCall, String asDataStr, Form akForm1)
    Float loc_timer = akDevice.GetGameTimeLockedTime()
    Int loc_min_count   = GetParamInt(akModifier, asDataStr, 0, 1,      "Input")
    Float loc_prob1     = GetParamFlt(akModifier, asDataStr, 1, 100.0,  "Probability")
    Bool loc_stolen     = GetParamBln(akModifier, asDataStr, 2, False)
    Float loc_period    = GetParamFlt(akModifier, asDataStr, 3, 8.0,    "-Input")
    Bool loc_repeat     = GetParamBln(akModifier, asDataStr, 4, False)
    Int loc_acc         = GetParamInt(akModifier, asDataStr, 5, 0)
    Float loc_last      = GetParamFlt(akModifier, asDataStr, 6, 0.0)
    
    ; triggered once and no repeat option
    If loc_last < 0.0
        Return False
    EndIf

    If RandomFloat(0.0, 100.0) < 30.0 * akModifier.MultVerboseness
        PrintNotification(akDevice, ;/ reacted /;"because of the items in your inventory. An image of an " + akForm1.GetName() + " appears in front of your eyes for a second.")
    EndIf
    
    If loc_period > 0 && (loc_last + loc_period) < loc_timer
    ; it is not the time yet
        Return False
    EndIf
        
    If loc_acc >= loc_min_count
        loc_acc = 0
        If !loc_repeat
        ; triggered once
            loc_last = -1.0
        Else
            loc_last = loc_timer
        EndIf
        SetParamInt(akModifier, akDevice, 5, loc_acc)
        SetParamFlt(akModifier, akDevice, 6, loc_last)
        Return False
    EndIf

    If RandomFloat(0.0, 100.0) < (loc_prob1)
        loc_acc = 0
        If !loc_repeat
        ; triggered once
            loc_last = -1.0
        Else
            loc_last = loc_timer
        EndIf
        SetParamInt(akModifier, akDevice, 5, loc_acc)
        SetParamFlt(akModifier, akDevice, 6, loc_last)
        Return True
    EndIf
    Return False
EndFunction

Bool Function ItemAdded(UD_Modifier_Combo akModifier, UD_CustomDevice_RenderScript akDevice, Form akItemForm, Int aiItemCount, ObjectReference akSourceContainer, Bool abIsStolen, String asDataStr, Form akForm1)
    If !_IsValidForm(akForm1, akItemForm)
        Return False
    EndIf
    If UDmain.TraceAllowed()
        UDmain.Log("UD_ModTrigger_ItemDemand::ItemAdded() akItemForm = " + akItemForm + " abIsStolen = " + abIsStolen, 3)
    EndIf
    
    Int loc_min_count   = GetParamInt(akModifier, asDataStr, 0, 1,      "Input")
    Float loc_prob1     = GetParamFlt(akModifier, asDataStr, 1, 100.0,  "Probability")
    Bool loc_stolen     = GetParamBln(akModifier, asDataStr, 2, False)
    Float loc_period    = GetParamFlt(akModifier, asDataStr, 3, 8.0,    "-Input")
    Bool loc_repeat     = GetParamBln(akModifier, asDataStr, 4, False)
    Int loc_acc         = GetParamInt(akModifier, asDataStr, 5, 0)
    Float loc_last      = GetParamFlt(akModifier, asDataStr, 6, 0.0)

    ; triggered once and no repeat option
    If loc_last < 0.0
        Return False
    EndIf
        
    If RandomFloat(0.0, 100.0) < 30.0 * akModifier.MultVerboseness
        PrintNotification(akDevice, ;/ reacted /;"because of the items in your inventory. An image of an " + akForm1.GetName() + " appears in front of your eyes for a second.")
    EndIf

    If loc_stolen && !abIsStolen
        Return False
    EndIf
    
    loc_acc += aiItemCount
    
    Int loc_consume = aiItemCount
    If loc_acc > loc_min_count
        loc_consume -= loc_acc - loc_min_count
        loc_acc = loc_min_count
    EndIf
    ; consume items (should it be an option?)
    akDevice.GetWearer().RemoveItem(akItemForm, loc_consume)

    SetParamInt(akModifier, akDevice, 5, loc_acc)
    
    Return False
EndFunction

Bool Function ItemRemoved(UD_Modifier_Combo akModifier, UD_CustomDevice_RenderScript akDevice, Form akItemForm, Int aiItemCount, ObjectReference akDestContainer, String asDataStr, Form akForm1)
    Return False
EndFunction

;/  Group: User interface
===========================================================================================
===========================================================================================
===========================================================================================
/;
String Function GetParamsTableRows(UD_Modifier_Combo akModifier, UD_CustomDevice_RenderScript akDevice, String asDataStr, Form akForm1)
    String loc_res = ""
    Int loc_min_count   = GetParamInt(akModifier, asDataStr, 0, 1,      "Input")
    Float loc_prob1     = GetParamFlt(akModifier, asDataStr, 1, 100.0,  "Probability")
    Bool loc_stolen     = GetParamBln(akModifier, asDataStr, 2, False)
    Float loc_period    = GetParamFlt(akModifier, asDataStr, 3, 8.0,    "-Input")
    Bool loc_repeat     = GetParamBln(akModifier, asDataStr, 4, False)
    Int loc_acc         = GetParamInt(akModifier, asDataStr, 5, 0)
    Float loc_last      = GetParamFlt(akModifier, asDataStr, 6, 0.0)
    
    loc_res += UDmain.UDMTF.TableRowDetails("Num. of items demanded:",  loc_min_count As String)
    loc_res += UDmain.UDMTF.TableRowDetails("Base probability:",        FormatFloat(loc_prob1, 1) + "%")
    loc_res += UDmain.UDMTF.TableRowDetails("Only stolen items:",       InlineIfStr(loc_stolen, "True", "False"))
    loc_res += UDmain.UDMTF.TableRowDetails("Time to get items:",       FormatFloat(loc_period, 1) + " hours")
    loc_res += UDmain.UDMTF.TableRowDetails("Repeat:",                  InlineIfStr(loc_repeat, "True", "False"))
    loc_res += UDmain.UDMTF.TableRowDetails("Items obtained:",          loc_acc As String)
    loc_res += UDmain.UDMTF.TableRowDetails("Timestamp:",               FormatFloat(loc_last, 2))
    Return loc_res
EndFunction
