class_name AI_PlayDecisions


enum Play_Decision{
	#Reasons to play
	WillPlay = 1,
	MandatoryPlay,
	PlayToEmptyHand,
	ImpactCombat,
	ResponseToStackResolve,
	AddBoardPresence,
	Removal,
	Tempo,
	CardAdvantage,
	
	#Reasons to play later
	WaitForCombat = 0,
	WaitForEndOfTurn = 0,
	StackNotEmpty = 0,
	AnotherTime = 0,
	
	#Reasons not to play
	CantPlaySpellAbility = 0,
	CantPlayAi = 0,
	CantAfford = 0,
	CantAffordX = 0,
	DoesntImpactCombat = 0,
	DoesntImpactGame = 0,
	MissingLogic = 0,
	MissingNeededCards = 0,
	TimingRestrictions = 0,
	MissingPhaseRestrictions = 0,
	ConditionsNotMet = 0,
	NeedsToPlayCriteriaNotMet = 0,
	StopRunAwayActivations = 0,
	TargetingFailed = 0,
	CostNotAcceptable = 0,
	LifeInDanger = 0,
	WouldDestroyLegend = 0,
	WouldBecomeZeroHealthCreature = 0,
	WouldDestroyEnhancement = 0,
	BadEnterTheFieldEffects = 0,
	CurseEffects = 0
}


	
