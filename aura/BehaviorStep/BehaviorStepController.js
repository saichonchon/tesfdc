({
	handleBehaviorSelect : function(cmp, evt) {
		var componentRequested = evt.getParam("message");
		var currentBehavior = cmp.get("v.behaviorArea");

		if(currentBehavior.length == 0 || (currentBehavior.length == 1 && currentBehavior[0].type != componentRequested)) {	
			$A.createComponent(
					componentRequested,
					{
						"solutionId": cmp.get("v.solutionId")
					},
					function(newCmp){
						if (cmp.isValid()) {
							cmp.set("v.behaviorArea", newCmp);
						}
					}
			);	
		}
	},
	
	handleBehaviorSave : function(cmp, evt) {
		cmp.set("v.behaviorArea", "");
	}			
})