 rem *** A useless program that does nothing. It's meant to catch if certain
 rem *** capabilities break with batari basic code updates.

 dim _Game_Flags = a


 def _Game_Level=_Game_Flags & $0F
 def _Show_Title=_Game_Flags{4}
 def _Game_in_Play = _Game_Flags{5}
 def _Game_Over    =  	_Game_Flags{6}
 def _Show_Hi_Scores=_Game_Flags{7}

 temp1 = _Game_Level
 if _Show_Title || _Game_Over then goto bailout
 if _Game_in_Play then goto bailout
bailout

