({
	helperMethod : function() {
		
	},
	
	doInit: function(comp, event){
        
        var that=this, profile=comp.get('v.profile'), opp=comp.get('v.opportunity'), list_Confidence=comp.get('v.list_Confidence'),
        	part=comp.get('v.fc');

        list_Confidence = that.checkOptions(profile, opp, part, list_Confidence);

        that.createOptions(comp, list_Confidence, part['part']['Status__c'], opp, profile);
    },
	
	
	createOptions: function(comp, list_data, selected, opp, profile){
		var list_compOptions=[];
        
		for(var i=0, data; data=list_data[i]; i++){
		
            var config={markup: 'aura:html', attributes: {tag: 'option', body: data, HTMLAttributes: {value: data}}, HTMLAttributes: {value: data}};
			if(data == selected){
				config['attributes']['HTMLAttributes']['selected'] = 'selected';
			}
            
            if(profile['Name'] != 'BU Admin' && profile['Name'] != 'BU Analyst' && profile['Name'] != 'Developer' && profile['Name'] != 'Production Support' && profile['Name'] != 'System Administrator'){
                if(opp['RecordType']['DeveloperName'] == 'IND_Engineering_project' || opp['RecordType']['DeveloperName'] == 'IND_Sales_Project'){
                    if(data != 'Dead' && data != 'Lost'){
                        config['attributes']['HTMLAttributes']['disabled'] = 'disabled';
                    }
                }
            }
            
            
			$A.createComponent(
	            config['markup'], config['attributes'],
	            function(newComp){
	                if (comp.isValid()) {
	                    list_compOptions.push(newComp);
	                }
	            }
	        );
		}
		comp.set("v.body", list_compOptions);
	},
	
	checkOptions: function(profile, opp, part, list_Confidence){
		var proName=profile['Name'], rtName=opp['RecordType']['DeveloperName'];

		switch (true) {
			case (rtName == 'Opportunity_Engineering_Project' || rtName == 'Opportunity_Sales_Parts_Only' || 
				  rtName == 'Opportunity_Product_Platform' || rtName == 'TAM') : 
				
					if(proName == 'Appliance User w/ Cost' || proName == 'Appliance Standard User' || profileName == 'Appliance Inside Sales Playbook User' || proName == 'Appliance Engineering User w/Cost'){
						if(part['status'] == 'Won'){
		    				list_Confidence = ['Won'];
		    			}
					}else if( (rtName == 'Opportunity_Engineering_Project' || rtName == 'Opportunity_Sales_Parts_Only') && (proName == 'Medical Standard User' || proName == 'Medical User w/Cost')) {
                        if(part['status'] == 'Won'){
		    				list_Confidence = ['Won'];
		    			}
                    }
				
				break;
			case (rtName == 'DND_Opportunity' ) : 
                if (proName != 'BU Admin' && proName != 'BU Analyst' && proName != 'Developer' &&  proName != 'Production Support' && proName != 'System Administrator' ) {
                    if(part['status'] == 'Won'){
                        list_Confidence = ['Won'];
                    }
                }
                
				break;
			case (rtName == 'Channel_Engineering_Opportunity' || rtName == 'Channel_Sales_Opportunity' || 
				  rtName == 'CCR_Opportunity' || rtName == 'NDR_Opportunity') :
	    				
		    		if(proName == 'Channel Distributor Portal Manager' || proName == 'Channel Distributor Portal User' || 
						proName == 'Channel Inside Sales' || proName == 'Channel Insidesales Power - Dialer' || proName == 'Channel Standard User'){
                        if(part['status'] == 'Won'){
                            list_Confidence = ['Won'];
                        }else{
                            list_Confidence = ['Weak', '50/50', 'Likely', 'Commit', 'Won', 'Dead', 'Lost'];	//.splice($.inArray('On Hold', list_Confidence), 1);
                        }
					}
	    		
	    		break;
			case (rtName == 'IND_Engineering_project' || rtName == 'IND_Sales_Project') :
			
	    			list_Confidence = ['50/50', 'Likely', 'Won', 'Dead', 'Lost'];	//[part['status']];
	    			
	    		break;
			case (rtName == 'ADM') :
	    		
	    		break;
			
			default:
				break;
		}
	
		return list_Confidence;
	},
	
	
	
})