extends Node

enum chara {GSD, SPR, PRT, FGT, ASN, ACH, BMG, SMG, LMG}
#GSD FGT PRT
#ASN SPR LMG
#BMG SMG ACH

enum vessel {HVY, MED, LGT}
#GSD PRT SPR
#ASN ACH FGT
#BMG SMG LMG

enum element {SUN, LUN, STR}
#GSD FGT BMG
#SPR ASN SMG
#PRT ACH LMG

enum leaders {HRO, BRS, GSH, GEN, DRD, SNP, AMG}
#HRO M
#SNSN BRS F
#SNLN AMG B
#SNST SNP B
#LNLN GEN M
#LNST DRD M
#STST GSH F

func get_character_element(character : chara) -> element:
	var result : element
	match character:
		chara.GSD, chara.FGT, chara.BMG:
			result = element.SUN
		chara.SPR, chara.ASN, chara.SMG:
			result = element.LUN
		chara.PRT, chara.ACH, chara.LMG:
			result = element.STR
		
	
	return result

func get_element_characters(request : element) -> Array[chara]:
	var result : Array[chara] = []
	match request:
		element.SUN:
			result = [chara.GSD, chara.FGT, chara.BMG]
		element.LUN:
			result = [chara.SPR, chara.ASN, chara.SMG]
		element.STR:
			result = [chara.PRT, chara.ACH, chara.LMG]

	return result
