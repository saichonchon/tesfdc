function showLoading(){
		$("#loading").show();
		$("#mask").show();
	}
	
	function hideLoading(){
		$("#loading").hide();
		$("#mask").hide();
	}
	
	function changeSelectedSalesHierarchy(){
		showLoading();
		var selectOption = $("#territory option:selected");
		$("#territory option[value=' ']").remove();
		getSelectedMonthlyTargetBookings(selectOption.text().trim(), selectOption.val(), selectOption.attr('salesHierarchyId'), selectOption.attr('terrLevel'));
	}
	
	function doSave(){ 
		showLoading();
		var array_monthlyTargets = [];
		$(".editable_Proposed_Input").each(function(){
			var monthlyTarget = {
				monthAbbrName : $(this).attr('monthName').trim(),
		    	monthNumber : $(this).attr('monthNum').trim(),
		    	monthProposedValue : ($(this).val().trim() == '')? null : $(this).val().trim(),
		    	monthTargetValue : ($(this).attr('targetValue').trim() == '')? null : $(this).attr('targetValue').trim(),
		    	parentMonthlyTargetId : $(this).attr('parentId').trim(),
		    	relatedTerritoryCode : $(this).attr('terrCode').trim(),
		    	relatedTerritoryName : $(this).attr('terrName').trim(),
				relatedTerritoryLevel : $(this).attr('terrLevel').trim(),
		    	relatedGAMCode : ($(this).attr('GAMCode').trim() == '')? null : $(this).attr('GAMCode').trim(),
		    	relatedGAMDescription : ($(this).attr('GAMDesc').trim() == '')? null : $(this).attr('GAMDesc').trim()
			};
			
				array_monthlyTargets.push(monthlyTarget);
			
		});
		$(".editable_Target_Input").each(function(){
			var monthlyTarget = {
				monthAbbrName : $(this).attr('monthName').trim(),
		    	monthNumber : $(this).attr('monthNum').trim(),
		    	monthProposedValue : ($(this).attr('proposedValue').trim() == '')? null : $(this).attr('proposedValue').trim(),
		    	monthTargetValue : ($(this).val().trim() == '')? null : $(this).val().trim(),
		    	parentMonthlyTargetId : $(this).attr('parentId').trim(),
		    	relatedTerritoryCode : $(this).attr('terrCode').trim(),
		    	relatedTerritoryName : $(this).attr('terrName').trim(),
				relatedTerritoryLevel : $(this).attr('terrLevel').trim(),
		    	relatedGAMCode : ($(this).attr('GAMCode').trim() == '')? null : $(this).attr('GAMCode').trim(),
		    	relatedGAMDescription : ($(this).attr('GAMDesc').trim() == '')? null : $(this).attr('GAMDesc').trim()
			};
			
				array_monthlyTargets.push(monthlyTarget);
		
		});
		console.log(array_monthlyTargets);
		if(array_monthlyTargets.length > 0){
			var json_ArrayMonthlyTargets = JSON.stringify(array_monthlyTargets);
			storeMonthlyTargetToDatabase(json_ArrayMonthlyTargets);
		}else{
			hideLoading();
		}
	}
	
	function slideDownRelatedDetailedRow(downArrowEle){
		var $downArrowEle = $(downArrowEle);
		$downArrowEle.hide();
		var probability = $downArrowEle.attr('probability');
		$("img[probability='"+ probability +"'][class*='arrowUp']").show();
		$("."+ probability + 'detailRowStyle').show();
	}
	function slideUpRelatedDetailedRow(upArrowEle){
		var $upArrowEle = $(upArrowEle);
		$upArrowEle.hide();
		var probability = $upArrowEle.attr('probability');
		$("img[probability='"+ probability +"'][class*='arrowDown']").show();
		$("."+ probability + 'detailRowStyle').hide(); 
	}