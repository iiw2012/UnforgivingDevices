Scriptname UD_CustomDevice_NPCSlot_HitAccum  extends ReferenceAlias

import UnforgivingDevicesMain
import UD_Native

UnforgivingDevicesMain _udmain
UnforgivingDevicesMain Property UDmain
    UnforgivingDevicesMain Function get()
        if !_udmain
            _udmain = UnforgivingDevicesMain.GetUDmain()
        endif
        return _udmain
    EndFunction
EndProperty

UD_CustomDevice_NPCSlot Property NPCSlot Hidden
    UD_CustomDevice_NPCSlot Function Get()
        Return ((Self as ReferenceAlias) as UD_CustomDevice_NPCSlot)
    EndFunction
EndProperty

Int _WeaponHitTaken_Index = 0
Form[] _WeaponHitTaken_Forms
Float[] _WeaponHitTaken_Values

Int _SpellHitTaken_Index = 0
Form[] _SpellHitTaken_Forms
Float[] _SpellHitTaken_Values

Int _SpellCast_Index = 0
Form[] _SpellCast_Forms

State Busy

    Event OnHit(ObjectReference akAggressor, Form akSource, Projectile akProjectile, bool abPowerAttack, bool abSneakAttack, bool abBashAttack, bool abHitBlocked)
    EndEvent
    
    Event OnSpellCast(Form akSource)
    EndEvent
    
    Function RaiseSpellCastEvents()
        If UDmain.TraceAllowed()
            UDmain.Log(Self + "::RaiseSpellCastEvents() Called in a Busy state!", 3)
        EndIf
    EndFunction
    
    Function RaiseSpellHitEvents()
        If UDmain.TraceAllowed()
            UDmain.Log(Self + "::RaiseSpellHitEvents() Called in a Busy state!", 3)
        EndIf
    EndFunction
    
    Function RaiseWeaponHitEvents()
        If UDmain.TraceAllowed()
            UDmain.Log(Self + "::RaiseWeaponHitEvents() Called in a Busy state!", 3)
        EndIf
    EndFunction

EndState

Event OnInit()
    GoToState("")
EndEvent

Event OnHit(ObjectReference akAggressor, Form akSource, Projectile akProjectile, bool abPowerAttack, bool abSneakAttack, bool abBashAttack, bool abHitBlocked)
    if !NPCSlot.isScriptRunning()
        Return
    EndIf
    If akSource as Weapon && akProjectile == None
    ; ignoring weapons with projectile because it's their enchantment
        Float loc_dmg = _CalculatePhysDamage(akAggressor, akSource, akProjectile, abPowerAttack, abSneakAttack, abBashAttack, abHitBlocked)
        If loc_dmg > 0.0
            _OnWeaponHit(akSource as Weapon, loc_dmg)
        EndIf
        If (akSource as Weapon).GetEnchantment() != None
            loc_dmg = _CalculateMagDamage(akAggressor, akSource, akProjectile, abPowerAttack, abSneakAttack, abBashAttack, abHitBlocked)
            If loc_dmg > 0.0
                _OnSpellHit((akSource as Weapon).GetEnchantment(), loc_dmg)
            EndIf
        EndIf
    ElseIf akSource as Spell
        Float loc_dmg = _CalculateMagDamage(akAggressor, akSource, akProjectile, abPowerAttack, abSneakAttack, abBashAttack, abHitBlocked)
        If loc_dmg > 0.0
            _OnSpellHit(akSource as Spell, loc_dmg)
        EndIf
    ElseIf akSource as Enchantment != None && akProjectile == None
        Float loc_dmg = _CalculateMagDamage(akAggressor, akSource, akProjectile, abPowerAttack, abSneakAttack, abBashAttack, abHitBlocked)
        If loc_dmg > 0.0
            _OnSpellHit(akSource as Enchantment, loc_dmg)
        EndIf
    Endif
EndEvent

Function _OnWeaponHit(Weapon akSource, Float afDamage)
    If _WeaponHitTaken_Forms.Length <= _WeaponHitTaken_Index
        _WeaponHitTaken_Forms = Utility.ResizeFormArray(_WeaponHitTaken_Forms, _WeaponHitTaken_Index + 10)
        _WeaponHitTaken_Values = Utility.ResizeFloatArray(_WeaponHitTaken_Values, _WeaponHitTaken_Index + 10)
    EndIf
    _WeaponHitTaken_Forms[_WeaponHitTaken_Index] = akSource
    _WeaponHitTaken_Values[_WeaponHitTaken_Index] = afDamage
    _WeaponHitTaken_Index += 1
EndFunction

Function _OnSpellHit(Form akSource, Float afDamage)
    If _SpellHitTaken_Forms.Length <= _SpellHitTaken_Index
        _SpellHitTaken_Forms = Utility.ResizeFormArray(_SpellHitTaken_Forms, _SpellHitTaken_Index + 10)
        _SpellHitTaken_Values = Utility.ResizeFloatArray(_SpellHitTaken_Values, _SpellHitTaken_Index + 10)
    EndIf
    _SpellHitTaken_Forms[_SpellHitTaken_Index] = akSource
    _SpellHitTaken_Values[_SpellHitTaken_Index] = afDamage
    _SpellHitTaken_Index += 1
EndFunction

Event OnSpellCast(Form akSource)
    Spell loc_spell = akSource as Spell
    If loc_spell == None
        Return
    EndIf
    
    If _SpellCast_Forms.Length <= _SpellCast_Index
        _SpellCast_Forms = Utility.ResizeFormArray(_SpellCast_Forms, _SpellCast_Index + 10)
    EndIf
    _SpellCast_Forms[_SpellCast_Index] = akSource
EndEvent

Float Function _CalculatePhysDamage(ObjectReference akAggressor, Form akSource, Projectile akProjectile, bool abPowerAttack, bool abSneakAttack, bool abBashAttack, bool abHitBlocked)
; calculation in the first approximation without taking into account difficulty and perks
    Weapon loc_weapon = akSource as Weapon
    Actor loc_actor = Self.GetActorReference()
    If loc_weapon == None
        Return 5.0 * (1.0 + 0.02 * loc_actor.GetLevel()) * (1.0 + 0.5 * (abPowerAttack as Int))
    ElseIf _IsTrapHit(akAggressor, akSource)
    ; it's a trap!
        Return 30.0 * (1.0 + 0.02 * loc_actor.GetLevel())
    ElseIf loc_weapon.GetFormID() == 0x000001F4
    ; predator
        Return 10.0 * (1.0 + 0.02 * (akAggressor as Actor).GetActorValue("OneHanded")) * (1.0 + 0.5 * (abPowerAttack as Int)) * (1.0 - 0.5 * (abHitBlocked as Int))
    Else
        Float loc_base = fRange(loc_weapon.GetBaseDamage(), 5.0, 100.0)
        Float loc_skill
        If akAggressor as Actor != None
            loc_skill = (akAggressor as Actor).GetActorValue(loc_weapon.GetSkill())
        Else
            loc_skill = loc_actor.GetLevel()
        EndIf
        Return loc_base * (1.0 + 0.02 * loc_skill) * (1.0 + 0.5 * (abPowerAttack as Int)) * (1.0 - 0.5 * (abHitBlocked as Int))
    EndIf
EndFunction

Float Function _CalculateMagDamage(ObjectReference akAggressor, Form akSource, Projectile akProjectile, bool abPowerAttack, bool abSneakAttack, bool abBashAttack, bool abHitBlocked)
    MagicEffect loc_me
    Actor loc_actor = Self.GetActorReference()
    Float loc_magn
    If akSource as Spell
        Spell loc_spell = akSource as Spell
        If !loc_spell.IsHostile()
            Return -1.0
        EndIf
        Int loc_i = loc_spell.GetCostliestEffectIndex()
        loc_me = loc_spell.GetNthEffectMagicEffect(loc_i)
        loc_magn = fRange(loc_spell.GetNthEffectMagnitude(loc_i), 5.0, 100.0)
    ElseIf akSource as Enchantment
        Enchantment loc_ench = akSource as Enchantment
        If !loc_ench.IsHostile()
            Return -1.0
        EndIf
        Int loc_i = loc_ench.GetCostliestEffectIndex()
        loc_me = loc_ench.GetNthEffectMagicEffect(loc_i)
        loc_magn = fRange(loc_ench.GetNthEffectMagnitude(loc_i), 5.0, 100.0)
    Else
        Return 5.0 * (1.0 + 0.02 * loc_actor.GetLevel())
    EndIf
    If loc_me.GetAssociatedSkill() != "Destruction"
        Return -1.0
    EndIf
    If !loc_me.IsEffectFlagSet(0x00000001)
        Return -1.0
    EndIf
    Float loc_skill = 0.0
    If akSource as Spell
        If akAggressor as Actor
            loc_skill = (akAggressor as Actor).GetActorValue("Destruction")
        Else
            loc_skill = loc_actor.GetLevel()
        EndIf
    EndIf
    Return loc_magn * (1.0 + 0.02 * loc_skill)

EndFunction

Bool Function IsConcentrationSpell(Spell akSpell)
    If akSpell == None
        Return False
    EndIf
    Int loc_i = akSpell.GetCostliestEffectIndex()
    MagicEffect loc_me = akSpell.GetNthEffectMagicEffect(loc_i)
    Return loc_me.GetCastingType() == 2
EndFunction

Bool Function IsConcentrationEnch(Enchantment akEnchantment)
    If akEnchantment == None
        Return False
    EndIf
    Int loc_i = akEnchantment.GetCostliestEffectIndex()
    MagicEffect loc_me = akEnchantment.GetNthEffectMagicEffect(loc_i)
    Return loc_me.GetCastingType() == 2
EndFunction

Bool Function _IsTrapHit(ObjectReference akAggressor, Form akSource)
    Return (akAggressor == None && akSource.GetFormID() == 0x000001F4)
EndFunction

Function RaiseSpellCastEvents()
    GoToState("Busy")
    Form[] loc_arr_no_dupes = PapyrusUtil.RemoveDupeForm(_SpellCast_Forms)
    loc_arr_no_dupes = PapyrusUtil.ClearNone(loc_arr_no_dupes)
    If loc_arr_no_dupes.Length > 0 && UDmain.TraceAllowed()
        UDmain.Log(Self + "::RaiseSpellCastEvents() " + _SpellCast_Forms.Length + " event(s) from " + loc_arr_no_dupes.Length + " spells", 3)
    EndIf
    Int loc_form_index = 0
    While loc_form_index < loc_arr_no_dupes.Length
        Form loc_source = loc_arr_no_dupes[loc_form_index]
        If (loc_source as Spell) != None
            Int loc_hits = PapyrusUtil.CountForm(_SpellCast_Forms, loc_source)
            Int loc_dev_index = 0
            While NPCSlot.UD_equipedCustomDevices[loc_dev_index]
                NPCSlot.UD_equipedCustomDevices[loc_dev_index].spellCast(loc_source as Spell, loc_hits)
                loc_dev_index += 1
            EndWhile
        EndIf
        loc_form_index += 1
    EndWhile
    _SpellCast_Forms = Utility.ResizeFormArray(_SpellCast_Forms, 0)
    _SpellCast_Index = 0
    GoToState("")
EndFunction

Function RaiseSpellHitEvents()
    GoToState("Busy")
    Form[] loc_arr_no_dupes = PapyrusUtil.RemoveDupeForm(_SpellHitTaken_Forms)
    If loc_arr_no_dupes.Length > 0 && UDmain.TraceAllowed()
        UDmain.Log(Self + "::RaiseSpellHitEvents() " + _SpellHitTaken_Forms.Length + " event(s) from " + loc_arr_no_dupes.Length + " spell(s)", 3)
    EndIf
    Int loc_form_index = 0
    While loc_form_index < loc_arr_no_dupes.Length
        Form loc_source = loc_arr_no_dupes[loc_form_index]
        If loc_source != None
            Int loc_hits = PapyrusUtil.CountForm(_SpellHitTaken_Forms, loc_source)
            Float loc_damage = _SumHitValues(_SpellHitTaken_Forms, _SpellHitTaken_Values, loc_source)
            Int loc_dev_index = 0
            While NPCSlot.UD_equipedCustomDevices[loc_dev_index]
                NPCSlot.UD_equipedCustomDevices[loc_dev_index].spellHit(loc_source, loc_damage, loc_hits)
                loc_dev_index += 1
            EndWhile
        EndIf
        loc_form_index += 1
    EndWhile
    _SpellHitTaken_Forms = Utility.ResizeFormArray(_SpellHitTaken_Forms, 0)
    _SpellHitTaken_Values = Utility.ResizeFloatArray(_SpellHitTaken_Values, 0)
    _SpellHitTaken_Index = 0
    GoToState("")
EndFunction

Function RaiseWeaponHitEvents()
    GoToState("Busy")
    Form[] loc_arr_no_dupes = PapyrusUtil.RemoveDupeForm(_WeaponHitTaken_Forms)
    loc_arr_no_dupes = PapyrusUtil.ClearNone(loc_arr_no_dupes)
    If loc_arr_no_dupes.Length > 0 && UDmain.TraceAllowed()
        UDmain.Log(Self + "::RaiseWeaponHitEvents() " + _WeaponHitTaken_Forms.Length + " event(s) from " + loc_arr_no_dupes.Length + " weapon(s)", 3)
    EndIf
    Int loc_form_index = 0
    While loc_form_index < loc_arr_no_dupes.Length
        Form loc_source = loc_arr_no_dupes[loc_form_index]
        If (loc_source as Weapon) != None
            Int loc_hits = PapyrusUtil.CountForm(_WeaponHitTaken_Forms, loc_source)
            Float loc_damage = _SumHitValues(_WeaponHitTaken_Forms, _WeaponHitTaken_Values, loc_source)
            Int loc_dev_index = 0
            While NPCSlot.UD_equipedCustomDevices[loc_dev_index]
                NPCSlot.UD_equipedCustomDevices[loc_dev_index].weaponHit(loc_source as Weapon, loc_damage, loc_hits)
                loc_dev_index += 1
            EndWhile
        EndIf
        loc_form_index += 1
    EndWhile
    _WeaponHitTaken_Forms = Utility.ResizeFormArray(_WeaponHitTaken_Forms, 0)
    _WeaponHitTaken_Values = Utility.ResizeFloatArray(_WeaponHitTaken_Values, 0)
    _WeaponHitTaken_Index = 0
    GoToState("")
EndFunction

Float Function _SumHitValues(Form[] aakSources, Float[] aafValues, Form akSource)
    Int loc_hit_index = 0
    Float loc_sum = 0.0
    While loc_hit_index < aakSources.Length
        If aakSources[loc_hit_index] == akSource
            loc_sum += aafValues[loc_hit_index]
        EndIf
        loc_hit_index += 1
    EndWhile
    Return loc_sum
EndFunction
