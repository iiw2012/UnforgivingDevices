Scriptname UD_MCM_Page_ModsTags extends UD_MCM_Page

import UnforgivingDevicesMain
import UD_Native

UDCustomDeviceMain Property UDCDmain
    UDCustomDeviceMain Function Get()
        return UDmain.UDCDmain
    EndFunction
EndProperty

UD_UserInputScript Property UDUI
    UD_UserInputScript Function Get()
        return UDmain.UDUI
    EndFunction
EndProperty

String[] UD_ModTags_Array
Int UD_ModTags_StartIndex
Int UD_ModTags_EndIndex
Int UD_ModTags_Hint_T
Function PageReset(Bool abLockMenu)
    Int UD_LockMenu_flag = FlagSwitch(!abLockMenu)
    SetCursorFillMode(LEFT_TO_RIGHT)
    AddHeaderOption("$UD_CUSTOMMOD_TAGLIST")
    AddHeaderOption("")

    UD_ModTags_Hint_T = AddTextOption("$UD_CUSTOMMOD_TAGLIST_HINT", "$-INFO-", FlagSwitch(True))
    AddEmptyOption()

    UD_ModTags_Array = UDMain.UDMOM.GetModifiersTags()
    PapyrusUtil.SortStringArray(UD_ModTags_Array)
    Int loc_i = 0
    UD_ModTags_StartIndex = -1
    While loc_i < UD_ModTags_Array.Length
        String loc_tag = UD_ModTags_Array[loc_i]
        Int loc_temp = AddToggleOption(_GetTagInfoString(loc_tag, False), UDCDmain.UDPatcher.IsModifierTagEnabled(loc_tag), UD_LockMenu_flag)
        If UD_ModTags_StartIndex < 0 
            UD_ModTags_StartIndex = loc_temp
        EndIf
        loc_i += 1
    EndWhile
    UD_ModTags_EndIndex = UD_ModTags_StartIndex + loc_i

    If UDMain.TraceAllowed() && False
        UDMain.Log(Self + "::resetModifierTagsPage() Tags = [\n" + PapyrusUtil.StringJoin(UD_ModTags_Array, "\n") + "\n]")
    EndIf
EndFunction

Function PageOptionSelect(Int aiOption)
    if (aiOption >= UD_ModTags_StartIndex && aiOption < UD_ModTags_EndIndex)
        Int loc_index = aiOption - UD_ModTags_StartIndex
        String loc_tag = UD_ModTags_Array[loc_index]
        UDCDMain.UDPatcher.ToggleModifierTag(loc_tag)
        SetToggleOptionValue(aiOption, UDCDMain.UDPatcher.IsModifierTagEnabled(loc_tag))
    EndIf
EndFunction

Function PageInfo(int aiOption)
    if (aiOption >= UD_ModTags_StartIndex && aiOption < UD_ModTags_EndIndex)
        Int loc_index = aiOption - UD_ModTags_StartIndex
        String loc_tag = UD_ModTags_Array[loc_index]
        SetInfoText(_GetTagInfoString(loc_tag, True))
    ElseIf (aiOption == UD_ModTags_Hint_T)
        SetInfoText("$UD_CUSTOMMOD_TAGLIST_HINT_INFO")
    EndIf
EndFunction

String Function _GetTagInfoString(String asTag, Bool abInfo)
    String t = "a"
    If StringUtil.GetNthChar(asTag, StringUtil.GetLength(asTag) - 1) == "-"
        asTag = StringUtil.Substring(asTag, 0, StringUtil.GetLength(asTag) - 1) + "M"
    ElseIf StringUtil.GetNthChar(asTag, StringUtil.GetLength(asTag) - 1) == "+"
        asTag = StringUtil.Substring(asTag, 0, StringUtil.GetLength(asTag) - 1) + "P"
    EndIf
    String loc_res = "$UD_CUSTOMMOD_TAG_"
    Int loc_n = StringUtil.GetLength(asTag)
    Int loc_i = 0
    While loc_i < loc_n
        String loc_char = StringUtil.GetNthChar(asTag, loc_i)
        Int loc_code = StringUtil.AsOrd(loc_char)
        If loc_code >= 65 && loc_code <= 90             ; Upper case Latin
            loc_res += StringUtil.AsChar(loc_code)
        ElseIf loc_code >= 97 && loc_code <= 122        ; Lower case Latin
            loc_code -= 32
            loc_res += StringUtil.AsChar(loc_code)
        Else
            loc_res += loc_char
        EndIf
        loc_i += 1
    EndWhile
    If abInfo
        Return loc_res + "_INFO"
    Else
        Return loc_res
    EndIf
EndFunction