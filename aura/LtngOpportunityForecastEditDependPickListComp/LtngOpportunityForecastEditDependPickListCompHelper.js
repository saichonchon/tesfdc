({
	helperMethod : function() {
		
	},
    
    doInit: function(comp, event){
        var that=this;
        
        that.initProcessStatusPickList(that, comp);

    },
    
    handlerdependValueChange: function(comp, event) {
    
    	var that=this;
        
        that.initProcessStatusPickList(that, comp);

    },
    
    
    initProcessStatusPickList: function(that, comp){
    	var map_ps=comp.get('v.map_ps'), opp=comp.get('v.opportunity'), rtName=opp['RecordType']['DeveloperName'], 
    		profile=comp.get('v.profile')['Name'], dependValue=comp.get('v.dependValue');
		
    	map_ps = that.getProcessStatus(rtName, profile, map_ps);
        
    //    console.log('map_ps', map_ps);
        
    	if(map_ps.hasOwnProperty(dependValue)){
            var list_options=map_ps[dependValue];
    		list_options = that.getProcessStatusPickList(comp, list_options, profile, rtName, dependValue);
    		comp.set('v.list_ps', list_options);
    	}
    	
    },
    
    getProcessStatusPickList: function(comp, list_options, profile, rtName, dpValue){
    	var selected=comp.get('v.selected'), status=comp.get('v.oStatus');
		
   //     console.log('list_options=>', list_options, '\n profile=>', profile, '\n selected=>', selected, '\n status==>', status, '\n rtName=>', rtName,  '\n dpValue->', dpValue);
        
   //     console.log(rtName, profile, status, selected, list_options);
        
    	switch (true) {
			
			case (rtName == 'Opportunity_Engineering_Project' || rtName == 'Opportunity_Sales_Parts_Only' || 
				  rtName == 'Opportunity_Product_Platform' || rtName == 'TAM') : 
					  if(profile == 'Appliance User w/ Cost' || profile == 'Appliance Standard User' || profileName == 'Appliance Inside Sales Playbook User' || profile == 'Appliance Engineering User w/Cost'){
						  if(status == 'Won' && selected == 'Production'){
							  list_options = list_options.join('___').replace('Pre-prod___', '').split('___');
						  }
					  }else if( (rtName == 'Opportunity_Engineering_Project' || rtName == 'Opportunity_Sales_Parts_Only') && (profile == 'Medical Standard User' || profile == 'Medical User w/Cost')) {
                          if(status == 'Won' && selected == 'Production'){
							  list_options = list_options.join('___').replace('Pre-prod___', '').split('___');
						  }
                      }
				
				break;
			case (rtName == 'DND_Opportunity' ) : 
                if(status == 'Won' && selected == 'Production'){
                    list_options = list_options.join('___').replace('Pre-prod___', '').split('___');
                }
				break;
			case (rtName == 'Channel_Engineering_Opportunity' || rtName == 'Channel_Sales_Opportunity' || 
				  rtName == 'CCR_Opportunity' || rtName == 'NDR_Opportunity') :
	    				
		    		if(profile == 'Channel Distributor Portal Manager' || profile == 'Channel Distributor Portal User' || 
						profile == 'Channel Inside Sales' || profile == 'Channel Insidesales Power - Dialer' || profile == 'Channel Standard User'){

		    			switch(dpValue){
		                    case 'Weak' : list_options = ['Concept']; break;
		                    case '50/50' : list_options = ['Prototyped/Sampled']; break;
		                    case 'Likely' : list_options = ['Quoted']; break;
		                    case 'Commit' : list_options = ['Pre-prod']; break;
		                    case 'Won' : list_options = ['Production']; break;
		                    case 'Dead' : list_options = ['Dead']; break;
		                    case 'Lost' : list_options = ['Lost']; break;
		                }
					}
	    		
	    		break;
			case (rtName == 'IND_Engineering_project' || rtName == 'IND_Sales_Project') :
	    			list_Confidence = ['50/50', 'Won', 'Dead', 'Lost'];
	    			
	    		break;
			case (rtName == 'ADM') :
	    			if(profile == 'ADM Standard User' || profile == 'ADM User w/ cost'){
	    				if(status == 'Won' && selected == 'Production'){
		    				list_options = list_options.join('___').replace('Pre-prod___', '').split('___');
		    			}
                    }
	    		break;
			
			default:
				break;
			
		}
		
        return list_options;
    	
    },
    
    
    event_processStatus_change: function(comp, event) {
        var target=event.currentTarget, value=target.options[target.selectedIndex].value, 
            dpChangeEvent=comp.getEvent("dpChangeEvent"), o={'value': value, 'pid': comp.get('v.uniqueId') },
            dependValue=comp.get('v.dependValue'), fc=comp.get('v.fc');

        dpChangeEvent.setParams({'sJson': JSON.stringify(o)});
        dpChangeEvent.fire();	// Fire the event
    },
    
    getProcessStatus: function(rtName, profile, map_ps){

    	if(profile == 'BU Admin' || profile == 'BU Analyst' || profile == 'Developer' || profile == 'Production Support' || profile == 'System Administrator'){
    		map_ps = {
				'On Hold' : ['Concept', 'Designed', 'Demo', 'Prototyped/Sampled', 'Quoted', 'On Customer AVL'],
				'Weak' : ['Concept', 'Designed', 'Demo', 'Prototyped/Sampled', 'Quoted', 'On Customer AVL'],
				'50/50' : ['Concept', 'Designed', 'Demo', 'Prototyped/Sampled', 'Quoted', 'On Customer AVL', 'Prototyped', 'Sampled'],
				'Likely' : ['Concept', 'Designed', 'Demo', 'Prototyped/Sampled', 'Quoted', 'On Customer AVL'],
				'Commit' : ['Concept', 'Designed', 'Demo', 'Prototyped/Sampled', 'Quoted', 'On Customer AVL', 'Pre-prod'],
				'Won' : ['Pre-prod', 'Production', 'Ramp Down', 'EOL'],
				'Dead' : ['Concept', 'Designed', 'Dead', 'Demo', 'Prototyped/Sampled', 'Quoted', 'On Customer AVL'],
				'Lost' : ['Concept', 'Designed', 'Lost', 'Demo', 'Prototyped/Sampled', 'Quoted', 'On Customer AVL']
			};
    		return map_ps;
    	}
    	
    	switch(true){
    		case (rtName == 'Opportunity_Engineering_Project' || rtName == 'Opportunity_Sales_Parts_Only' || rtName == 'Opportunity_Product_Platform' || rtName == 'TAM') :
                if(profile == 'Appliance Engineering User w/Cost' || profile == 'Appliance Standard User' || profileName == 'Appliance Inside Sales Playbook User' || profile == 'Appliance User w/ Cost'){
                    map_ps = {
	    				'On Hold' : ['Concept', 'Designed'],
	    				'Weak' : ['Concept', 'Designed'],
	    				'50/50' : ['Concept', 'Designed'],
	    				'Likely' : ['Concept', 'Designed'],
	    				'Commit' : ['Concept', 'Designed'],
	    				'Won' : ['Pre-prod', 'Production', 'Ramp Down', 'EOL'],
	    				'Dead' : ['Concept', 'Designed'],
	    				'Lost' : ['Concept', 'Designed']
	    			};
                }else if( (rtName == 'Opportunity_Engineering_Project' || rtName == 'Opportunity_Sales_Parts_Only') && (profile == 'Medical Standard User' || profile == 'Medical User w/Cost')) {
                    map_ps = {
	    				'On Hold' : ['Concept', 'Designed', 'Demo', 'Prototyped/Sampled', 'Quoted'],
	    				'Weak' : ['Concept', 'Designed', 'Demo', 'Prototyped/Sampled', 'Quoted'],
	    				'50/50' : ['Concept', 'Designed', 'Demo', 'Prototyped/Sampled', 'Quoted'],
	    				'Likely' : ['Concept', 'Designed', 'Demo', 'Prototyped/Sampled', 'Quoted'],
	    				'Commit' : ['Concept', 'Designed', 'Demo', 'Prototyped/Sampled', 'Quoted'],
	    				'Won' : ['Pre-prod', 'Production', 'Ramp Down', 'EOL'],
	    				'Dead' : ['Concept', 'Designed', 'Demo', 'Prototyped/Sampled', 'Quoted'],
	    				'Lost' : ['Concept', 'Designed', 'Demo', 'Prototyped/Sampled', 'Quoted']
	    			};
                }
                	
    			break;
    			
    		case (rtName == 'Channel_Engineering_Opportunity' || rtName == 'Channel_Sales_Opportunity' || rtName == 'CCR_Opportunity' || rtName == 'NDR_Opportunity') :
	    			map_ps = {
	    				'On Hold' : [],
	    				'Weak' : ['Concept'],
	    				'50/50' : ['Prototyped/Sampled'],
	    				'Likely' : ['Quoted'],
	    				'Commit' : ['Pre-prod'],
	    				'Won' : ['Production'],
	    				'Dead' : ['Dead'],
	    				'Lost' : ['Lost']
	    			};
    			break;
    			
    		case (rtName == 'ADM') :
	    			map_ps = {
	    				'On Hold' : ['Concept', 'Designed', 'Demo', 'Prototyped/Sampled', 'Quoted'],
	    				'Weak' : ['Concept', 'Designed', 'Demo', 'Prototyped/Sampled', 'Quoted'],
	    				'50/50' : ['Concept', 'Designed', 'Demo', 'Prototyped/Sampled', 'Quoted'],
	    				'Likely' : ['Concept', 'Designed', 'Demo', 'Prototyped/Sampled', 'Quoted'],
	    				'Commit' : ['Concept', 'Designed', 'Demo', 'Prototyped/Sampled', 'Quoted'],
	    				'Won' : ['Pre-prod', 'Production'],
	    				'Dead' : ['Concept', 'Designed', 'Demo', 'Prototyped/Sampled', 'Quoted'],
	    				'Lost' : ['Concept', 'Designed', 'Demo', 'Prototyped/Sampled', 'Quoted']
	    			};
    			break;
    			
    		case (rtName == 'Opportunity_Engineering_Project' || rtName == 'Opportunity_Sales_Parts_Only') :
	    			map_ps = {
	    				'On Hold' : ['Concept', 'Designed', 'Demo', 'Prototyped/Sampled', 'Quoted'],
	    				'Weak' : ['Concept', 'Designed', 'Demo', 'Prototyped/Sampled', 'Quoted'],
	    				'50/50' : ['Concept', 'Designed', 'Demo', 'Prototyped/Sampled', 'Quoted'],
	    				'Likely' : ['Concept', 'Designed', 'Demo', 'Prototyped/Sampled', 'Quoted'],
	    				'Commit' : ['Concept', 'Designed', 'Demo', 'Prototyped/Sampled', 'Quoted'],
	    				'Won' : ['Pre-prod', 'Production', 'Ramp Down', 'EOL'],
	    				'Dead' : ['Concept', 'Designed', 'Demo', 'Prototyped/Sampled', 'Quoted'],
	    				'Lost' : ['Concept', 'Designed', 'Demo', 'Prototyped/Sampled', 'Quoted']
	    			};
    			break;
    			
    		case (rtName == 'DND_Opportunity') :
                    map_ps = {
                        'On Hold' : ['Concept', 'Quoted', 'Designed', 'On Customer AVL'],
                        'Weak' : ['Concept', 'Quoted', 'Designed', 'On Customer AVL'],
                        '50/50' : ['Concept', 'Quoted', 'Designed', 'On Customer AVL'],
                        'Likely' : ['Concept', 'Quoted', 'Designed', 'On Customer AVL'],
                        'Commit' : ['Concept', 'Quoted', 'Designed', 'On Customer AVL'],
                        'Won' : ['Pre-prod', 'Production'],
                        'Dead' : ['Concept', 'Quoted', 'Designed', 'On Customer AVL'],
                        'Lost' : ['Concept', 'Quoted', 'Designed', 'On Customer AVL']
                    };
    			break;

    		case (rtName == 'IND_Engineering_project' || rtName == 'IND_Sales_Project') :
    			map_ps = {
    				'50/50' : ['Concept', 'Demo'],
    				'Likely' : ['Quoted'],
    				'Won' : ['Pre-prod', 'Production'],
    				'Dead' : [],
    				'Lost' : []
    			};
    			break;
    			
			default :
				break;
    	}
    	
    	return map_ps;
    },
    
    
})