! TaskIT 2.0
!! Running

	[ [ [ 
		
		#message >> Object
		
		TKTBuilder new.
		builder send: #message;
				    to: object;
				   inThisProcess;
					inALocalProcess;
					result.
		
		(Objeto -> mensaje) tkt result.
		
		(Objeto => mensaje) useALocalProcess; result.
				
		future := (Objeto => mensaje) useALocalProcess; future.

		(Objeto => mensaje) useALocalProcess; result.
		
		(Objeto => mensaje) useALocalProcess; result.
		
		(Objeto => mensaje) useTheSameProcess; run.
		
		(Objeto => mensaje) useAnOtherInstance; run.
		
		(Objeto => mensaje) useALocalProcess; loopingForever.
		
		(Objeto => mensaje) useALocalProcess; looping; onServiceFinalization: [ ] onFailure:[]; start.
		
		(Objeto => mensaje) loopingServiceJob.
		
		
		
		
		
		
		
		TKTBuilder 			
	] ] ]