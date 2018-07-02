window.$catch={
    'saveSize': 300, 'list_save':[]
}
;function initDocumentPage(){
    $('#saveBreakDownBtn').off('click').on('click', saveBreakDown_eve);
    $('#saveBreakDownSubmitBtn').off('click').on('click', saveBreakDownSubmit_eve);
}

;function saveBreakDown_eve(e){
    $('#isSubmit').val(false);
    setBreakDownBatch(saveBreakDownBudgetMonthly);
}
;function saveBreakDownSubmit_eve(e){
    $('#isSubmit').val(true);
    setBreakDownBatch(saveBreakDownBudgetMonthly);
}
;function setBreakDownBatch(callBackAction){
    document.getElementById('loading-curtain-div').style.display = '';
    conUnformatNum('accountBDDataTable');   //formate Currency for number
    $catch.list_save = [];  //clear save list
    
    var list_bm = [], list_tr = $('#accountBDDataTable tbody tr.repeatcls').toArray();
    while(list_tr.length > 0){
        var bm = list_tr.shift();
        setAccountId(bm, list_bm);
    //    setBudgetMonthly(bm, list_bm);
    }
    
    if(list_bm.length == 0){
        document.getElementById('loading-curtain-div').style.display = 'none';
        return;
    }

    for(var i=0,len=list_bm.length; i<len; i+=$catch.saveSize){
        $catch.list_save.push( JSON.stringify(list_bm.slice(i,i+$catch.saveSize)) );
    }
    /*
    for(var i=0,len=list_bm.length; i<len; i+=$catch.saveSize){
        var t = '{"BudgetMonthly" : '+ JSON.stringify(list_bm.slice(i,i+$catch.saveSize)) +'}';
        $catch.list_save.push(t);
    }
    */
    list_bm = [];
    $('[id*=hiddjsonid]').val($catch.list_save.shift());
    
    callBackAction();
    
    ;function setAccountId(bm, list_bm){
        list_bm.push(bm.getAttribute('aid'));
    }
    
    ;function setBudgetMonthly(bm, list_bm){
        for(var i=1; i<=12; i++){
        var Direct={"cId": bm.getAttribute('aid'), "filterId":"", "fYear":CONFIG.budget_year, "bType":"Direct", 
                    "isoCode":"", "fMonth": i, "budget":0, "budgetTBRNY":0, "budgetDocumentCurrency":0},
            POS=Object.clone(Direct), CMA=Object.clone(Direct);
            POS.bType = "POS";
            CMA.bType = "CMA";
            list_bm.push(Direct);
            list_bm.push(POS);
            list_bm.push(CMA);
        }
    }
}

;function saveBreakDownBudgetMonthlyComplete(){
    if($catch.list_save.length == 0){
        saveBreakDownBudgetDetail();    //this is action function save detail sobject
        return;
    }
    $('[id*=hiddjsonid]').val($catch.list_save.shift());
    saveBreakDownBudgetMonthly();   //this is action function
}
;function saveBreakDownBudgetDetailComplete(){

    conFormatNum('accountBDDataTable'); //formate Currency
    document.getElementById('loading-curtain-div').style.display = 'none';
}





function productRowMouseEffect(trId, effect)
{
	var allTr = document.getElementsByTagName("tr"); 	
	//alert(trId);		
	for(var i=0; i<allTr.length; i++){
		if(allTr[i].className.indexOf(trId) != -1){
			if(effect == 'over'){
				allTr[i].style.backgroundColor = '#E3F3FF';
			}
			else{
				if(allTr[i].className.indexOf('Qzone')!= -1){
					allTr[i].style.backgroundColor = '#E4EDF7';
				}
				else{
					allTr[i].style.backgroundColor = '#FFF';
				}
			}
		}
	}
} 
function showDisplays(className, buttonId, title, tableName){
	var theTable = G$(tableName);
	var allTr = theTable.getElementsByTagName("tr");
	var buttonCol = G$(buttonId);	
	
	if(title=='Show'){
		buttonCol.title = 'Hide';
		buttonCol.className = 'hideTableListButton';
		for(var i=0; i<allTr.length; i++)
		{
			if(allTr[i].className.indexOf('accountData_'+className) != -1)
			{
				allTr[i].style.display = '';
			}
		}
		checkAllDisplays('Hide', tableName);					
	}
	else{
		buttonCol.title = 'Show';
		buttonCol.className = 'showTableListButton';
		for(var i=0; i<allTr.length; i++)
		{
			if(allTr[i].className.indexOf('accountData_'+className) != -1)
			{
				allTr[i].style.display = 'none';
			}
		}
		checkAllDisplays('Show', tableName);					
	}
}
function checkAllDisplays(title, tableName){
	var theTable = G$(tableName);
	var allImg = theTable.getElementsByTagName("img");
	var buttonCol = G$("allAccountBtn");
	var allShow = 'true';
	if(title == 'Hide'){
		buttonCol.title = 'Hide';
		buttonCol.className = 'hideTableListButton';
	}
	else{
		for(var i=0; i<allImg.length; i++)
		{
			if(allImg[i].id.indexOf('_accountBtn') != -1 && allImg[i].style.display != 'none'){
				if(allImg[i].title == 'Hide') allShow = 'false';
			}
		}
		if(allShow == 'true') {
			buttonCol.title = 'Show';
			buttonCol.className = 'showTableListButton';
		}
	}
}
function showAllDisplays(buttonId, tableName){
	var theTable = G$(tableName);
	var allTr = theTable.getElementsByTagName("tr");
	var buttonCol = G$(buttonId);
	var title = buttonCol.title;
	if(buttonCol.title=='Show'){
		buttonCol.title = 'Hide';
		buttonCol.className = 'hideTableListButton';	
	}
	else{
		buttonCol.title = 'Show';
		buttonCol.className = 'showTableListButton';					
	}
	for(var i=0; i<allTr.length; i++)
	{	
		if(allTr[i].className.indexOf('accountBtn_') != -1){
			var className = allTr[i].className.substring(allTr[i].className.indexOf('_')+1, allTr[i].className.length);
			showDisplays(className, className+'_accountBtn', title, tableName);
		}
	}
}

function executeCal(fieldId, accType, fieldName){
	var format = document.getElementById("localFormat").value;
	var sep;
	var dec;
	if(format == 'de') {
		sep = '.';
		dec = ',';
	}
	else{
		sep = ',';
		dec = '.';
	}
	var rtype = fieldId.substring(fieldId.length-1, fieldId.length);
	var fieldprefix = fieldId.substring(0, fieldId.length-1);
	var prefix = fieldId.substring(0, fieldId.indexOf(accType+'_'));
	// market growth & price change 
	if(fieldName == 'MG' || fieldName == 'PC' || fieldName == 'PI'){
		G$(fieldId).value = unformateNum(G$(fieldId).value, dec, 1);
		if(G$(fieldId).value >= 999.5) {
			alert('Too large value! Please correct.');
			G$(fieldId).value = 0.0;
		}
		G$(fieldId).value = FormatNum(G$(fieldId).value, sep, dec, 1);		
	}
	else{
		G$(fieldId).value = unformateNum(G$(fieldId).value, dec, 0);
		if(G$(fieldId).value.length > 12){
			alert('Too large value! Please correct.');
			G$(fieldId).value = 0;
		}
		G$(fieldId).value = FormatNum(G$(fieldId).value, sep, dec, 0);
	}

	// calculate self detail
	calSelfDetail(prefix, rtype, accType, sep, dec);
	
	// calculate total detail
	calTotalDetail(fieldprefix, prefix, accType, sep, dec);
	
	// calculate total accounts
	if(accType == 'AD') calTotalAccounts(rtype, sep, dec);
	
	// calculate total budget
	calTotalBudget(rtype, sep, dec);
	
	// calculate total budget detail
	calTotalBudgetDetail(rtype, fieldName, sep, dec);
	
	/*
	// In other accounts if Customer Growth changed, then change the FCY
	if(accType=='OAD' && fieldName == 'MG'){
		var newFCY = (1+unformateNum(G$(fieldId).value, dec, 1)/100)*unformateNum(G$(prefix+'OAD_BCYRR_'+rtype).innerHTML, dec, 0);
		G$(prefix+'OAD_FCY_'+rtype+'Output').innerHTML = FormatNum(newFCY, sep, dec, 0);
		G$(prefix+'OAD_FCY_'+rtype).value = FormatNum(newFCY, sep, dec, 0);
		executeCal(prefix+'OAD_FCY_'+rtype, 'OAD', 'FCY')
	}*/							   
}

function calSelfDetail(prefix, rtype, accType, sep, dec){
	// Run Rate Business
	G$(prefix+accType+'_RRB_'+rtype).innerHTML = unformateNum(G$(prefix+accType+'_FCY_'+rtype).value, dec, 0) + 
										 	     unformateNum(G$(prefix+accType+'_OEOL_'+rtype).value, dec, 0) + 
										 		 unformateNum(G$(prefix+accType+'_TO_'+rtype).value, dec, 0) + 
										 		 unformateNum(G$(prefix+accType+'_TI_'+rtype).value, dec, 0) +
										 		 unformateNum(G$(prefix+accType+'_TAM_'+rtype).value, dec, 0);
	G$(prefix+accType+'_RRB_'+rtype).innerHTML = FormatNum(G$(prefix+accType+'_RRB_'+rtype).innerHTML, sep, dec, 0);
														 		
	// Adjusted Business
	G$(prefix+accType+'_AB_'+rtype).innerHTML = unformateNum(G$(prefix+accType+'_RRB_'+rtype).innerHTML, dec, 0) + 
											    unformateNum(G$(prefix+accType+'_RRB_'+rtype).innerHTML, dec, 0) * (unformateNum(G$(prefix+accType+'_MG_'+rtype).value, dec, 1)/100) + 
											    unformateNum(G$(prefix+accType+'_RRB_'+rtype).innerHTML, dec, 0) * (unformateNum(G$(prefix+accType+'_PC_'+rtype).value, dec, 1)/100) + 
											    unformateNum(G$(prefix+accType+'_RRB_'+rtype).innerHTML, dec, 0) * (unformateNum(G$(prefix+accType+'_PI_'+rtype).value, dec, 1)/100);
	G$(prefix+accType+'_AB_'+rtype).innerHTML = FormatNum(G$(prefix+accType+'_AB_'+rtype).innerHTML, sep, dec, 0);
	
	// Budget
	G$(prefix+accType+'_CB_'+rtype).innerHTML = unformateNum(G$(prefix+accType+'_AB_'+rtype).innerHTML, dec, 0) + 
												unformateNum(G$(prefix+accType+'_OW_'+rtype).innerHTML, dec, 0);
	G$(prefix+accType+'_CB_'+rtype).innerHTML = FormatNum(G$(prefix+accType+'_CB_'+rtype).innerHTML, sep, dec, 0);
	
	// Total Budget for single account detail
	G$(prefix+accType+'_TB_'+rtype).innerHTML = unformateNum(G$(prefix+accType+'_CB_'+rtype).innerHTML, dec, 0) + 
												unformateNum(G$(prefix+accType+'_AJ_'+rtype).value, dec, 0);
	G$(prefix+accType+'_TB_'+rtype).innerHTML = FormatNum(G$(prefix+accType+'_TB_'+rtype).innerHTML, sep, dec, 0);											
																									   
	// Growth %
	if(unformateNum(G$(prefix+accType+'_FCY_'+rtype).value, dec, 0)==0) G$(prefix+accType+'_GR_'+rtype).innerHTML = FormatNum(100.0, sep, dec, 1);
	else{
		G$(prefix+accType+'_GR_'+rtype).innerHTML = ((unformateNum(G$(prefix+accType+'_CB_'+rtype).innerHTML, dec, 0) + 
												 unformateNum(G$(prefix+accType+'_AJ_'+rtype).value, dec, 0)) /
												 unformateNum(G$(prefix+accType+'_FCY_'+rtype).value, dec, 0) - 1) * 100;
		G$(prefix+accType+'_GR_'+rtype).innerHTML = FormatNum(G$(prefix+accType+'_GR_'+rtype).innerHTML, sep, dec, 1);
	}
}

function calTotalDetail(fieldprefix, prefix, accType, sep, dec){
	// sum of current field
	G$(fieldprefix+'T').innerHTML = unformateNum(G$(fieldprefix+'D').value, dec, 0) + 
	                                unformateNum(G$(fieldprefix+'P').value, dec, 0) + 
	                                unformateNum(G$(fieldprefix+'C').value, dec, 0);
	G$(fieldprefix+'T').innerHTML = FormatNum(G$(fieldprefix+'T').innerHTML, sep, dec, 0);
	
    // Run Rate Business
    G$(prefix+accType+'_RRB_T').innerHTML = unformateNum(G$(prefix+accType+'_RRB_D').innerHTML, dec, 0) + 
    										unformateNum(G$(prefix+accType+'_RRB_P').innerHTML, dec, 0) + 
    										unformateNum(G$(prefix+accType+'_RRB_C').innerHTML, dec, 0);
    G$(prefix+accType+'_RRB_T').innerHTML = FormatNum(G$(prefix+accType+'_RRB_T').innerHTML, sep, dec, 0);										
    										
    // Adjusted Business
    G$(prefix+accType+'_AB_T').innerHTML = unformateNum(G$(prefix+accType+'_AB_D').innerHTML, dec, 0) + 
    									   unformateNum(G$(prefix+accType+'_AB_P').innerHTML, dec, 0) + 
    									   unformateNum(G$(prefix+accType+'_AB_C').innerHTML, dec, 0);
    G$(prefix+accType+'_AB_T').innerHTML = FormatNum(G$(prefix+accType+'_AB_T').innerHTML, sep, dec, 0);
    									   
    // Budget
    G$(prefix+accType+'_CB_T').innerHTML = unformateNum(G$(prefix+accType+'_CB_D').innerHTML, dec, 0) + 
    									   unformateNum(G$(prefix+accType+'_CB_P').innerHTML, dec, 0) + 
    									   unformateNum(G$(prefix+accType+'_CB_C').innerHTML, dec, 0);
    G$(prefix+accType+'_CB_T').innerHTML = FormatNum(G$(prefix+accType+'_CB_T').innerHTML, sep, dec, 0);
    									   
    // Total Budget for single total detail
    G$(prefix+accType+'_TB_T').innerHTML = unformateNum(G$(prefix+accType+'_TB_D').innerHTML, dec, 0) + 
    									   unformateNum(G$(prefix+accType+'_TB_P').innerHTML, dec, 0) + 
    									   unformateNum(G$(prefix+accType+'_TB_C').innerHTML, dec, 0);
    G$(prefix+accType+'_TB_T').innerHTML = FormatNum(G$(prefix+accType+'_TB_T').innerHTML, sep, dec, 0);									   
    									   
    // Market Growth & Price Change & Price Increase
    if(unformateNum(G$(prefix+accType+'_RRB_T').innerHTML, dec, 0)==0){
    	G$(prefix+accType+'_MG_T').innerHTML = FormatNum(100.0, sep, dec, 1);
    	G$(prefix+accType+'_PC_T').innerHTML = FormatNum(100.0, sep, dec, 1);
    	G$(prefix+accType+'_PI_T').innerHTML = FormatNum(100.0, sep, dec, 1);
    }
    else{
    	G$(prefix+accType+'_MG_T').innerHTML = (unformateNum(G$(prefix+accType+'_RRB_D').innerHTML, dec, 0) * (unformateNum(G$(prefix+accType+'_MG_D').value, dec, 1)/100) + 
    											unformateNum(G$(prefix+accType+'_RRB_P').innerHTML, dec, 0) * (unformateNum(G$(prefix+accType+'_MG_P').value, dec, 1)/100) +
    											unformateNum(G$(prefix+accType+'_RRB_C').innerHTML, dec, 0) * (unformateNum(G$(prefix+accType+'_MG_C').value, dec, 1)/100)) / 
    											unformateNum(G$(prefix+accType+'_RRB_T').innerHTML, dec, 0) * 100;
    	
    	G$(prefix+accType+'_MG_T').innerHTML = FormatNum(G$(prefix+accType+'_MG_T').innerHTML, sep, dec, 1);
    														  
    	G$(prefix+accType+'_PC_T').innerHTML = (unformateNum(G$(prefix+accType+'_RRB_D').innerHTML, dec, 0) * (unformateNum(G$(prefix+accType+'_PC_D').value, dec, 1)/100) + 
    											unformateNum(G$(prefix+accType+'_RRB_P').innerHTML, dec, 0) * (unformateNum(G$(prefix+accType+'_PC_P').value, dec, 1)/100) +
    											unformateNum(G$(prefix+accType+'_RRB_C').innerHTML, dec, 0) * (unformateNum(G$(prefix+accType+'_PC_C').value, dec, 1)/100)) / 
    											unformateNum(G$(prefix+accType+'_RRB_T').innerHTML, dec, 0) * 100;
    	G$(prefix+accType+'_PC_T').innerHTML = FormatNum(G$(prefix+accType+'_PC_T').innerHTML, sep, dec, 1);
    	
    	G$(prefix+accType+'_PI_T').innerHTML = (unformateNum(G$(prefix+accType+'_RRB_D').innerHTML, dec, 0) * (unformateNum(G$(prefix+accType+'_PI_D').value, dec, 1)/100) + 
    											unformateNum(G$(prefix+accType+'_RRB_P').innerHTML, dec, 0) * (unformateNum(G$(prefix+accType+'_PI_P').value, dec, 1)/100) +
    											unformateNum(G$(prefix+accType+'_RRB_C').innerHTML, dec, 0) * (unformateNum(G$(prefix+accType+'_PI_C').value, dec, 1)/100)) / 
    											unformateNum(G$(prefix+accType+'_RRB_T').innerHTML, dec, 0) * 100;
    	G$(prefix+accType+'_PI_T').innerHTML = FormatNum(G$(prefix+accType+'_PI_T').innerHTML, sep, dec, 1);							   														  
    }
    // Growth %
	if(unformateNum(G$(prefix+accType+'_FCY_T').innerHTML, dec, 0)==0) G$(prefix+accType+'_GR_T').innerHTML = FormatNum(100.0, sep, dec, 1);
	else{
		G$(prefix+accType+'_GR_T').innerHTML = ((unformateNum(G$(prefix+accType+'_CB_T').innerHTML, dec, 0) + 
												unformateNum(G$(prefix+accType+'_AJ_T').innerHTML, dec, 0)) /
												unformateNum(G$(prefix+accType+'_FCY_T').innerHTML, dec, 0) - 1) * 100
		G$(prefix+accType+'_GR_T').innerHTML = FormatNum(G$(prefix+accType+'_GR_T').innerHTML, sep, dec, 1);
	}    													   
}

function calTotalAccounts(rtype, sep, dec){
	var accountTable = G$('accountTable');
    var allAccountTds = accountTable.getElementsByTagName('span');
    var totalAccounts = 0;
    var taId;
    for(var i=0; i<allAccountTds.length; i++)
	{
		var currentId = allAccountTds[i].id;
		if(currentId.indexOf('AD_TB_'+rtype) != -1 && currentId.indexOf('OAD_TB_'+rtype) == -1){
			totalAccounts = totalAccounts + unformateNum(allAccountTds[i].innerHTML, dec, 0);
		}
		if(currentId.indexOf('AD_TA_'+rtype) != -1){
			taId = currentId;
		}
	}
	var taIdPrefix = taId.substring(0, taId.length-1);
	G$(taId).innerHTML = FormatNum(totalAccounts, sep, dec, 0);
	G$(taIdPrefix+'T').innerHTML = unformateNum(G$(taIdPrefix+'D').innerHTML, dec, 0) + 
								   unformateNum(G$(taIdPrefix+'P').innerHTML, dec, 0) +
								   unformateNum(G$(taIdPrefix+'C').innerHTML, dec, 0);
	G$(taIdPrefix+'T').innerHTML = FormatNum(G$(taIdPrefix+'T').innerHTML, sep, dec, 0);						   
}

function calTotalBudget(rtype, sep, dec){
	var accountTable = G$('accountTable');
    var allAccountTds = accountTable.getElementsByTagName('span');
    var totalBudget = 0;
    var tbId;
    for(var i=0; i<allAccountTds.length; i++)
	{
		var currentId = allAccountTds[i].id;
		if(currentId.indexOf('AD_TB_'+rtype) != -1){
			totalBudget = totalBudget + unformateNum(allAccountTds[i].innerHTML, dec, 0);
		}
		if(currentId.indexOf('TB_TB_'+rtype) != -1){
			tbId = currentId;
		}
	}
	var tbIdPrefix = tbId.substring(0, tbId.length-1);
	G$(tbId).innerHTML = FormatNum(totalBudget, sep, dec, 0);
	G$(tbIdPrefix+'T').innerHTML = unformateNum(G$(tbIdPrefix+'D').innerHTML, dec, 0) + 
								   unformateNum(G$(tbIdPrefix+'P').innerHTML, dec, 0) +
								   unformateNum(G$(tbIdPrefix+'C').innerHTML, dec, 0);
	G$(tbIdPrefix+'T').innerHTML = FormatNum(G$(tbIdPrefix+'T').innerHTML, sep, dec, 0);
	
	// calculate quarterly budget
	calQuarterBudget(tbId, '', '');					   
}

function calTotalBudgetDetail(rtype, fieldName, sep, dec){
	var accountTable = G$('accountTable');
	var allInputTds = accountTable.getElementsByTagName('input'); 
	var tfVal = 0;
	
	var allAccountTds = accountTable.getElementsByTagName('span');
	var tfId;
	var tRRBVal = 0;
	var ttRRBVal = 0;
	var tRRBId;
	
	var tMGVal = 0;
	var ttMGVal = 0;
	var tMGId;
	
	var tPCVal = 0;
	var ttPCVal = 0;
	var tPCId;
	
	var tPIVal = 0;
	var ttPIVal = 0;
	var tPIId;
	
	var tABVal = 0;
	var tABId;
	
	var tCBVal = 0;
	var tCBId;
	
	var tGRId;
	
	// calculate current field total value
	for(var i=0; i<allInputTds.length; i++)
	{
		var currentId = allInputTds[i].id;
		// Market Growth
		if(currentId.indexOf('AD_MG_'+rtype) != -1){
			if(currentId.indexOf('OAD_MG_'+rtype) != -1){
				var fieldPrefix = currentId.substring(0,currentId.indexOf('OAD_'));
				tMGVal = tMGVal + unformateNum(allInputTds[i].value, dec, 1)/100 * unformateNum(G$(fieldPrefix+'OAD_RRB_'+rtype).innerHTML, dec, 0);
				ttMGVal = ttMGVal + unformateNum(G$(fieldPrefix+'OAD_MG_D').value, dec, 1)/100 * unformateNum(G$(fieldPrefix+'OAD_RRB_D').innerHTML, dec, 0) +
						  unformateNum(G$(fieldPrefix+'OAD_MG_P').value, dec, 1)/100 * unformateNum(G$(fieldPrefix+'OAD_RRB_P').innerHTML, dec, 0) + 
						  unformateNum(G$(fieldPrefix+'OAD_MG_C').value, dec, 1)/100 * unformateNum(G$(fieldPrefix+'OAD_RRB_C').innerHTML, dec, 0);
			}			
			else{
				var fieldPrefix = currentId.substring(0,currentId.indexOf('AD_'));
				tMGVal = tMGVal + unformateNum(allInputTds[i].value, dec, 1)/100 * unformateNum(G$(fieldPrefix+'AD_RRB_'+rtype).innerHTML, dec, 0);
				ttMGVal = ttMGVal + unformateNum(G$(fieldPrefix+'AD_MG_D').value, dec, 1)/100 * unformateNum(G$(fieldPrefix+'AD_RRB_D').innerHTML, dec, 0) +
						  unformateNum(G$(fieldPrefix+'AD_MG_P').value, dec, 1)/100 * unformateNum(G$(fieldPrefix+'AD_RRB_P').innerHTML, dec, 0) + 
						  unformateNum(G$(fieldPrefix+'AD_MG_C').value, dec, 1)/100 * unformateNum(G$(fieldPrefix+'AD_RRB_C').innerHTML, dec, 0);
			}
		}
		// Price Change
		else if(currentId.indexOf('AD_PC_'+rtype) != -1){
			if(currentId.indexOf('OAD_PC_'+rtype) != -1){
				var fieldPrefix = currentId.substring(0,currentId.indexOf('OAD_'));
				tPCVal = tPCVal + unformateNum(allInputTds[i].value, dec, 1)/100 * unformateNum(G$(fieldPrefix+'OAD_RRB_'+rtype).innerHTML, dec, 0);
				ttPCVal = ttPCVal + unformateNum(G$(fieldPrefix+'OAD_PC_D').value, dec, 1)/100 * unformateNum(G$(fieldPrefix+'OAD_RRB_D').innerHTML, dec, 0) +
						  unformateNum(G$(fieldPrefix+'OAD_PC_P').value, dec, 1)/100 * unformateNum(G$(fieldPrefix+'OAD_RRB_P').innerHTML, dec, 0) + 
						  unformateNum(G$(fieldPrefix+'OAD_PC_C').value, dec, 1)/100 * unformateNum(G$(fieldPrefix+'OAD_RRB_C').innerHTML, dec, 0);
			}			
			else{
				var fieldPrefix = currentId.substring(0,currentId.indexOf('AD_'));
				tPCVal = tPCVal + unformateNum(allInputTds[i].value, dec, 1)/100 * unformateNum(G$(fieldPrefix+'AD_RRB_'+rtype).innerHTML, dec, 0);
				ttPCVal = ttPCVal + unformateNum(G$(fieldPrefix+'AD_PC_D').value, dec, 1)/100 * unformateNum(G$(fieldPrefix+'AD_RRB_D').innerHTML, dec, 0) +
						  unformateNum(G$(fieldPrefix+'AD_PC_P').value, dec, 1)/100 * unformateNum(G$(fieldPrefix+'AD_RRB_P').innerHTML, dec, 0) + 
						  unformateNum(G$(fieldPrefix+'AD_PC_C').value, dec, 1)/100 * unformateNum(G$(fieldPrefix+'AD_RRB_C').innerHTML, dec, 0);
			}
		}
		// Price Increase
		else if(currentId.indexOf('AD_PI_'+rtype) != -1){
			if(currentId.indexOf('OAD_PI_'+rtype) != -1){
				var fieldPrefix = currentId.substring(0,currentId.indexOf('OAD_'));
				tPIVal = tPIVal + unformateNum(allInputTds[i].value, dec, 1)/100 * unformateNum(G$(fieldPrefix+'OAD_RRB_'+rtype).innerHTML, dec, 0);
				ttPIVal = ttPIVal + unformateNum(G$(fieldPrefix+'OAD_PI_D').value, dec, 1)/100 * unformateNum(G$(fieldPrefix+'OAD_RRB_D').innerHTML, dec, 0) +
						  unformateNum(G$(fieldPrefix+'OAD_PI_P').value, dec, 1)/100 * unformateNum(G$(fieldPrefix+'OAD_RRB_P').innerHTML, dec, 0) + 
						  unformateNum(G$(fieldPrefix+'OAD_PI_C').value, dec, 1)/100 * unformateNum(G$(fieldPrefix+'OAD_RRB_C').innerHTML, dec, 0);
			}			
			else{
				var fieldPrefix = currentId.substring(0,currentId.indexOf('AD_'));
				tPIVal = tPIVal + unformateNum(allInputTds[i].value, dec, 1)/100 * unformateNum(G$(fieldPrefix+'AD_RRB_'+rtype).innerHTML, dec, 0);
				ttPIVal = ttPIVal + unformateNum(G$(fieldPrefix+'AD_PI_D').value, dec, 1)/100 * unformateNum(G$(fieldPrefix+'AD_RRB_D').innerHTML, dec, 0) +
						  unformateNum(G$(fieldPrefix+'AD_PI_P').value, dec, 1)/100 * unformateNum(G$(fieldPrefix+'AD_RRB_P').innerHTML, dec, 0) + 
						  unformateNum(G$(fieldPrefix+'AD_PI_C').value, dec, 1)/100 * unformateNum(G$(fieldPrefix+'AD_RRB_C').innerHTML, dec, 0);
			}
		}
		
		// other fields
		else if(currentId.indexOf('AD_'+fieldName+'_'+rtype) != -1){
			tfVal = tfVal + unformateNum(allInputTds[i].value, dec, 0);
		}		
	}
	for(var i=0; i<allAccountTds.length; i++)
	{		
		var currentId = allAccountTds[i].id;
		// sum values
		// total Run Rate Business
		if(currentId.indexOf('AD_RRB_'+rtype) != -1){
			tRRBVal = tRRBVal + unformateNum(allAccountTds[i].innerHTML, dec, 0);
		}
		// total Adjusted Business
		else if(currentId.indexOf('AD_AB_'+rtype) != -1){
			tABVal = tABVal + unformateNum(allAccountTds[i].innerHTML, dec, 0);
		}
		// total Budget
		else if(currentId.indexOf('AD_CB_'+rtype) != -1){
			tCBVal = tCBVal + unformateNum(allAccountTds[i].innerHTML, dec, 0);
		}
		// total Run Rate Business
		else if(currentId.indexOf('TB_RRB_'+rtype) != -1){
			tRRBId = currentId;
		}
		// total Market Growth
		else if(currentId.indexOf('TB_MG_'+rtype) != -1){
			tMGId = currentId;
		}
		// total Price Change
		else if(currentId.indexOf('TB_PC_'+rtype) != -1){
			tPCId = currentId;
		}
		// total Price Increase
		else if(currentId.indexOf('TB_PI_'+rtype) != -1){
			tPIId = currentId;
		}
		// total Adjusted Business
		else if(currentId.indexOf('TB_AB_'+rtype) != -1){
			tABId = currentId;
		}
		// total Budget
		else if(currentId.indexOf('TB_CB_'+rtype) != -1){
			tCBId = currentId;
		}
		// growth %
		else if(currentId.indexOf('TB_GR_'+rtype) != -1){
			tGRId = currentId;
		}
		// get ids
		else if(currentId.indexOf('TB_'+fieldName+'_'+rtype) != -1){
			tfId = currentId;
		}
				
	}
	// calculate total value
	if(fieldName != 'MG' && fieldName != 'PC' && fieldName != 'PI') calTotalVal(tfId, tfVal, sep, dec);
	ttRRBVal = calTotalVal(tRRBId, tRRBVal, sep, dec);
	calTotalVal(tABId, tABVal, sep, dec);
	calTotalVal(tCBId, tCBVal, sep, dec);
	
	// Market Growth & Price Change
	if(tRRBVal ==0 && isNaN(tRRBVal)){
		G$(tMGId).innerHTML = FormatNum(100.0, sep, dec, 1);
		G$(tPCId).innerHTML = FormatNum(100.0, sep, dec, 1);
		G$(tPIId).innerHTML = FormatNum(100.0, sep, dec, 1);
	}
	else {
		G$(tMGId).innerHTML = FormatNum((tMGVal / tRRBVal) * 100, sep, dec, 1);
		G$(tPCId).innerHTML = FormatNum((tPCVal / tRRBVal) * 100, sep, dec, 1);
		G$(tPIId).innerHTML = FormatNum((tPIVal / tRRBVal) * 100, sep, dec, 1);
	}
	if(ttRRBVal == 0 && isNaN(ttRRBVal)){
		G$(tMGId.substring(0, tMGId.length-1)+'T').innerHTML = '100';
		G$(tPCId.substring(0, tPCId.length-1)+'T').innerHTML = '100';
		G$(tPIId.substring(0, tPIId.length-1)+'T').innerHTML = '100';
	}
	else{
		G$(tMGId.substring(0, tMGId.length-1)+'T').innerHTML = FormatNum((ttMGVal / ttRRBVal) * 100, sep, dec, 1);
		G$(tPCId.substring(0, tPCId.length-1)+'T').innerHTML = FormatNum((ttPCVal / ttRRBVal) * 100, sep, dec, 1);
		G$(tPIId.substring(0, tPIId.length-1)+'T').innerHTML = FormatNum((ttPIVal / ttRRBVal) * 100, sep, dec, 1);
	}
	// Growth %
	var tbFieldPrefix = tGRId.substring(0, tGRId.indexOf('TB_'));
	if(unformateNum(G$(tbFieldPrefix+'TB_FCY_'+rtype).innerHTML, dec, 0)==0) G$(tGRId).innerHTML = FormatNum(100.0, sep, dec, 1);	
	else{
		G$(tGRId).innerHTML = (unformateNum(G$(tbFieldPrefix+'TB_TB_'+rtype).innerHTML, dec, 0) /
						       unformateNum(G$(tbFieldPrefix+'TB_FCY_'+rtype).innerHTML, dec, 0) - 1) * 100;
		G$(tGRId).innerHTML = FormatNum(G$(tGRId).innerHTML, sep, dec, 1);
	}
	if(unformateNum(G$(tbFieldPrefix+'TB_FCY_T').innerHTML, dec, 0)==0) G$(tbFieldPrefix+'TB_GR_T').innerHTML = FormatNum(100.0, sep, dec, 1);
	else{
		G$(tbFieldPrefix+'TB_GR_T').innerHTML = (unformateNum(G$(tbFieldPrefix+'TB_TB_T').innerHTML, dec, 0) /
						       					 unformateNum(G$(tbFieldPrefix+'TB_FCY_T').innerHTML, dec, 0) - 1) * 100;
		G$(tbFieldPrefix+'TB_GR_T').innerHTML = FormatNum(G$(tbFieldPrefix+'TB_GR_T').innerHTML, sep, dec, 1);				       					 
	}		
}

function calQuarterBudget(tTBId, fieldId, fieldName){
	var format = document.getElementById("localFormat").value;
	var sep;
	var dec;
	if(format == 'de') {
		sep = '.';
		dec = ',';
	}
	else{
		sep = ',';
		dec = '.';
	}
	if(fieldId != ''){
		G$(fieldId).value = unformateNum(G$(fieldId).value, dec, 0);
		if(G$(fieldId).value.length > 12){
			alert('Too large value! Please correct.');
			G$(fieldId).value = 0;
		}
		G$(fieldId).value = FormatNum(G$(fieldId).value, sep, dec, 0);
	}
	var qbFieldPrefix = tTBId.substring(0, tTBId.indexOf('TB_'));
	var rtype = tTBId.substring(tTBId.length-1, tTBId.length); 
	G$(qbFieldPrefix+'QB_FQ4_'+rtype).innerHTML = unformateNum(G$(tTBId).innerHTML, dec, 0) - 
											      unformateNum(G$(qbFieldPrefix+'QB_FQ1_'+rtype).value, dec, 0) -
												  unformateNum(G$(qbFieldPrefix+'QB_FQ2_'+rtype).value, dec, 0) -
												  unformateNum(G$(qbFieldPrefix+'QB_FQ3_'+rtype).value, dec, 0);
	G$(qbFieldPrefix+'QB_FQ4_'+rtype).innerHTML = FormatNum(G$(qbFieldPrefix+'QB_FQ4_'+rtype).innerHTML, sep, dec, 0);
	G$(qbFieldPrefix+'HQB_FQ4_'+rtype).value = unformateNum(G$(qbFieldPrefix+'QB_FQ4_'+rtype).innerHTML, dec, 0);
												  
	G$(qbFieldPrefix+'QB_FQ4_T').innerHTML = unformateNum(G$(qbFieldPrefix+'QB_FQ4_D').innerHTML, dec, 0) + 
											 unformateNum(G$(qbFieldPrefix+'QB_FQ4_P').innerHTML, dec, 0) +
											 unformateNum(G$(qbFieldPrefix+'QB_FQ4_C').innerHTML, dec, 0);
	G$(qbFieldPrefix+'QB_FQ4_T').innerHTML = FormatNum(G$(qbFieldPrefix+'QB_FQ4_T').innerHTML, sep, dec, 0);
	G$(qbFieldPrefix+'HQB_FQ4_T').value = unformateNum(G$(qbFieldPrefix+'QB_FQ4_T').innerHTML, dec, 0);
										 
	if(fieldId != '' && fieldName != ''){
		var gbIdPrefix = fieldId.substring(0, fieldId.length-1);	
		G$(gbIdPrefix+'T').innerHTML = unformateNum(G$(gbIdPrefix+'D').value, dec, 0) + 
									   unformateNum(G$(gbIdPrefix+'P').value, dec, 0) +
									   unformateNum(G$(gbIdPrefix+'C').value, dec, 0);		
		G$(gbIdPrefix+'T').innerHTML = FormatNum(G$(gbIdPrefix+'T').innerHTML, sep, dec, 0);
		G$(qbFieldPrefix+'HQB_'+fieldName+'_T').value = unformateNum(G$(gbIdPrefix+'T').innerHTML, dec, 0);
	}
}

function calTotalVal(tfId, tfVal, sep, dec){
	var retVal = 0;
	var tfIdPrefix = tfId.substring(0, tfId.length-1);	
	G$(tfId).innerHTML = FormatNum(tfVal, sep, dec, 0);
	G$(tfIdPrefix+'T').innerHTML = unformateNum(G$(tfIdPrefix+'D').innerHTML, dec, 0) + 
								   unformateNum(G$(tfIdPrefix+'P').innerHTML, dec, 0) +
								   unformateNum(G$(tfIdPrefix+'C').innerHTML, dec, 0);
    retVal = G$(tfIdPrefix+'T').innerHTML;
    G$(tfIdPrefix+'T').innerHTML = FormatNum(G$(tfIdPrefix+'T').innerHTML, sep, dec, 0);
	return retVal;
}

// The following method is used to the account break down 
function executeABDCal(parentAccId, childAccId, calColumn, inputField){
	var format = document.getElementById("localFormat").value;
	var sep;
	var dec;
	if(format == 'de') {
		sep = '.';
		dec = ',';
	}
	else{
		sep = ',';
		dec = '.';
	}
	
	var theTable = G$("accountBDDataTable");
	inputField.value = unformateNum(inputField.value, dec, 0);
	inputField.value = FormatNum(inputField.value, sep, dec, 0);
	var tbField;
	var currentTbField;
	var lastField;
	var lastTbField;
	var allInputs = theTable.getElementsByTagName("input");
	var allSpans = theTable.getElementsByTagName("span");
	inputVal = unformateNum(inputField.value, dec, 0);

	for(var i=0; i<allSpans.length; i++)
	{
		// total budget field
		if(allSpans[i].className.indexOf('TB'+parentAccId+calColumn) != -1) {
			tbField = allSpans[i];
		}	
		// total budget field of current account
		else if(allSpans[i].className.indexOf(childAccId+parentAccId+'TB') != -1) {
			currentTbField = allSpans[i];
		}
		// the field of last account in the account group
		else if(allSpans[i].className.indexOf('Last'+parentAccId+calColumn) != -1) {
			lastField = allSpans[i];
		}
		// the total field of last account in the account group
		else if(allSpans[i].className.indexOf('Last'+parentAccId+'TB') != -1) {
			lastTbField = allSpans[i];
		}
	}
	var accountSum = 0;
	var groupSum = 0;
	if(calColumn != 'FCY') accountSum = inputVal;
	for(var i=0; i<allInputs.length; i++)
	{
		// sum of current column
		if(allInputs[i].className.indexOf(parentAccId+calColumn) != -1){
			groupSum = groupSum + unformateNum(allInputs[i].value, dec, 0);
		}
		// sum of row column
		else if(calColumn == 'BD'){
			if(allInputs[i].className.indexOf(childAccId+parentAccId+'BP') != -1 || allInputs[i].className.indexOf(childAccId+parentAccId+'BC') != -1){
				accountSum = accountSum + unformateNum(allInputs[i].value, dec, 0);
			}
		}
		else if(calColumn == 'BP'){
			if(allInputs[i].className.indexOf(childAccId+parentAccId+'BD') != -1 || allInputs[i].className.indexOf(childAccId+parentAccId+'BC') != -1){
				accountSum = accountSum + unformateNum(allInputs[i].value, dec, 0);
			}
		}
		else if(calColumn == 'BC'){
			if(allInputs[i].className.indexOf(childAccId+parentAccId+'BD') != -1 || allInputs[i].className.indexOf(childAccId+parentAccId+'BP') != -1){
				accountSum = accountSum + unformateNum(allInputs[i].value, dec, 0);
			}
		}
	}	
	lastField.innerHTML = FormatNum(unformateNum(tbField.innerHTML, dec, 0) - unformateNum(groupSum, dec, 0), sep, dec, 0);
	G$(lastField.id+'Hidden').value = unformateNum(lastField.innerHTML, dec, 0);
	
	if(calColumn != 'FCY'){
		currentTbField.innerHTML = FormatNum(accountSum, sep, dec, 0);
		var lastTbVal = 0
		for(var i=0; i<allSpans.length; i++){
			if(allSpans[i].className.indexOf('Last'+parentAccId+'BD') != -1 || allSpans[i].className.indexOf('Last'+parentAccId+'BP') != -1 || allSpans[i].className.indexOf('Last'+parentAccId+'BC') != -1){
				lastTbVal = lastTbVal + unformateNum(allSpans[i].innerHTML, dec, 0);
			}
		}
		lastTbField.innerHTML = FormatNum(lastTbVal, sep, dec, 0);
	}	
}

// the following method is used to manager review page
function checkIsAll(){
	var allInputs = document.getElementsByTagName("input");
	var isAllChecked = true;
	for(var i=0; i<allInputs.length; i++){
		if(allInputs[i].id != 'allCheck' && allInputs[i].type == 'checkbox' && !allInputs[i].checked){
			isAllChecked = false;
			break;
		}
	}
	document.getElementById("allCheck").checked = isAllChecked;
}
function checkAll(isChecked){
	var allInputs = document.getElementsByTagName("input");
	for(var i=0; i<allInputs.length; i++){
		if(allInputs[i].id != 'allCheck' && allInputs[i].type == 'checkbox'){
			if(isChecked) allInputs[i].checked = true;
			else allInputs[i].checked = false;
		}
	}
}
function calGrowth(field, FCYFieldId, GTHFieldId){
	var format = G$("localFormat").value;
	var sep;
	var dec;
	if(format == 'de') {
		sep = '.';
		dec = ',';
	}
	else{
		sep = ',';
		dec = '.';
	}
	field.value = unformateNum(field.value, dec, 0);
	if(field.value.length > 12){		
		alert('Too large value! Please correct.');
		field.value = 0;		
	}		
	field.value = FormatNum(field.value, sep, dec, 0);
	
	var FCYField = G$(FCYFieldId);
	var GTHField = G$(GTHFieldId);
	if(unformateNum(FCYField.innerHTML, dec, 0) == 0 || unformateNum(field.value, dec, 0) == 0) GTHField.innerHTML = FormatNum(0, sep, dec, 1);
	else{
		GTHField.innerHTML = (unformateNum(field.value, dec, 0) / unformateNum(FCYField.innerHTML, dec, 0) - 1) * 100;
		GTHField.innerHTML = FormatNum(GTHField.innerHTML, sep, dec, 1);
	}	
	
	// calculate last record
	var view = G$("hiddenView").value;
	var allMyBudget = 0;
	var theTable = G$("managerReviewTable");
	var allInputs = theTable.getElementsByTagName("input");
	var allSpans = theTable.getElementsByTagName("span");
	var LastFCYFieldId;
	var lastFieldId;
	var LastGTHFieldId;
	var TotalMyBudgetId;
	for(var i=0; i<allSpans.length; i++){
		if(allSpans[i].id.indexOf('LastFCY') != -1) LastFCYFieldId = allSpans[i].id;
		else if(allSpans[i].id.indexOf('LastGTH') != -1) LastGTHFieldId = allSpans[i].id;
		else if(allSpans[i].id.indexOf('LastBudget') != -1) lastFieldId = allSpans[i].id;
		
		else if(allSpans[i].id.indexOf('outputBudget') != -1 ){
			allMyBudget = allMyBudget + unformateNum(allSpans[i].innerHTML, dec, 0);
		}
	}
	
	for(var i=0; i<allInputs.length; i++){
		if(allInputs[i].type == 'text' && allInputs[i].style.display != 'none')
		{
			if(allInputs[i].id.indexOf('TotalMyBudget') != -1){
				TotalMyBudgetId = allInputs[i].id;
			}
			else if(allInputs[i].id.indexOf('TotalMyBudget') == -1 ){
				if(allInputs[i].value != null){
					allMyBudget = allMyBudget + unformateNum(allInputs[i].value, dec, 0);
				}
			}
		}		
	}	
	G$(lastFieldId).innerHTML = unformateNum(G$(TotalMyBudgetId).value, dec, 0)  - allMyBudget;
	G$(lastFieldId+"Hidden").value = G$(lastFieldId).innerHTML;
	G$(lastFieldId).innerHTML = FormatNum(G$(lastFieldId).innerHTML, sep, dec, 0);
	
	if(unformateNum(G$(LastFCYFieldId).innerHTML, dec, 0) == 0 || unformateNum(G$(lastFieldId).innerHTML, dec, 0) == 0) G$(LastGTHFieldId).innerHTML = FormatNum(0, sep, dec, 1);
	else{
		G$(LastGTHFieldId).innerHTML = (unformateNum(G$(lastFieldId).innerHTML, dec, 0) / unformateNum(G$(LastFCYFieldId).innerHTML, dec, 0) - 1) * 100;
		G$(LastGTHFieldId).innerHTML = FormatNum(G$(LastGTHFieldId).innerHTML, sep, dec, 1);
	}
}

function conFormatNum(tableName){
	var format = document.getElementById("localFormat").value;
	var sep;
	var dec;
	if(format == 'de') {
		sep = '.';
		dec = ',';
	}
	else{
		sep = ',';
		dec = '.';
	}
	if(tableName == 'accountTable'){
		var theTable = G$("accountTable");
		if(theTable != null){
			var allInputs = theTable.getElementsByTagName("input");
			var allSpans = theTable.getElementsByTagName("span");
			for(var i=0; i<allSpans.length; i++){
				if(allSpans[i].innerHTML != '&nbsp;'){
					if(allSpans[i].className != 'helpButton' && allSpans[i].id.indexOf('comments') == -1){
						if(allSpans[i].id.indexOf('MG') != -1 || allSpans[i].id.indexOf('PC') != -1 || allSpans[i].id.indexOf('PI') != -1 || allSpans[i].id.indexOf('GR') != -1 ){
							allSpans[i].innerHTML = FormatNum(allSpans[i].innerHTML, sep, dec, 1);
						}						
						else{	
							allSpans[i].innerHTML = FormatNum(allSpans[i].innerHTML, sep, dec, 0);
						}							
					}
				}							
			}
			for(var i=0; i<allInputs.length; i++){
				if(allInputs[i].value != ''){
					if(allInputs[i].id.indexOf('comments') == -1 && allInputs[i].type != 'hidden'){
						if(allInputs[i].id.indexOf('MG') != -1 || allInputs[i].id.indexOf('PC') != -1 || allInputs[i].id.indexOf('PI') != -1){
							allInputs[i].value = FormatNum(allInputs[i].value, sep, dec, 1);
						}
						else allInputs[i].value = FormatNum(allInputs[i].value, sep, dec, 0);
					}
				}
			}
		}
	}	
	else if(tableName == 'accountBDDataTable'){
		var theTable = G$("accountBDDataTable");
		if(theTable != null){
			var allInputs = theTable.getElementsByTagName("input");
			var allSpans = theTable.getElementsByTagName("span");
			
			for(var i=0; i<allSpans.length; i++){
				allSpans[i].innerHTML = FormatNum(allSpans[i].innerHTML, sep, dec, 0);
			}
			for(var i=0; i<allInputs.length; i++){
				if(allInputs[i].type != 'hidden') allInputs[i].value = FormatNum(allInputs[i].value, sep, dec, 0);
			}
		}
	}
	else if(tableName == 'managerReviewTable'){
		var theTable = G$("managerReviewTable");
		var findCheckBox = false;
		if(theTable != null){
			var allSpans = theTable.getElementsByTagName("span");
			var allInputs = theTable.getElementsByTagName("input");
			for(var i=0; i<allSpans.length; i++){
				//if(allSpans[i].className.indexOf('totalLine') != -1){
					if(allSpans[i].id.indexOf('GTH') != -1 && allSpans[i].innerHTML !='') allSpans[i].innerHTML = FormatNum(allSpans[i].innerHTML, sep, dec, 1);
					else if(allSpans[i].id.indexOf('Status') == -1 && allSpans[i].id.indexOf('Stage') == -1) allSpans[i].innerHTML = FormatNum(allSpans[i].innerHTML, sep, dec, 0);
				//}
			}
			for(var i=0; i<allInputs.length; i++){
				//if(allInputs[i].id.indexOf('TotalMyBudget') != -1) 
				if(allInputs[i].type != 'checkbox' && allInputs[i].type != 'hidden') allInputs[i].value = FormatNum(allInputs[i].value, sep, dec, 0);
				else if(allInputs[i].type == 'checkbox' && allInputs[i].id != 'allCheck'){
					findCheckBox = true;
				}
			}
			if(!findCheckBox) G$('allCheck').style.display = 'none';
		}
	}		
}
function conUnformatNum(tableName){	
	var format = document.getElementById("localFormat").value;
	var dec;
	if(format == 'de') {
		dec = ',';
	}
	else{
		dec = '.';
	}
	if(tableName == 'accountTable'){
		var theTable = G$("accountTable");
		if(theTable != null){
			var allInputs = theTable.getElementsByTagName("input");				
			for(var i=0; i<allInputs.length; i++){
				if(allInputs[i].type != 'hidden'){				
					if(allInputs[i].id.indexOf('MG') != -1 || allInputs[i].id.indexOf('PC') != -1 || allInputs[i].id.indexOf('PI') != -1){
						allInputs[i].value = unformateNum(allInputs[i].value, dec, 1);
					}
					else allInputs[i].value = unformateNum(allInputs[i].value, dec, 0);
				}
			}
		}
	}
	else if(tableName == 'accountBDDataTable'){
		var theTable = G$("accountBDDataTable");
		if(theTable != null){		
			var allInputs = theTable.getElementsByTagName("input");				
			for(var i=0; i<allInputs.length; i++){
				if(allInputs[i].type != 'hidden') allInputs[i].value = unformateNum(allInputs[i].value, dec, 0);
			}
		}
	}
	else if(tableName == 'managerReviewTable'){
		var theTable = G$("managerReviewTable");
		if(theTable != null){		
			var allInputs = theTable.getElementsByTagName("input");				
			for(var i=0; i<allInputs.length; i++){
				if(allInputs[i].type != 'checkbox' && allInputs[i].type != 'hidden') allInputs[i].value = unformateNum(allInputs[i].value, dec, 0);
			}
		}
	}
}

function findCheck(){
	var theTable = G$("managerReviewTable");
	var hasCheck = false;
	if(theTable != null){
		var allInputs = theTable.getElementsByTagName("input");
		for(var i=0; i<allInputs.length; i++){
			if(allInputs[i].type == 'checkbox' && allInputs[i].id != 'allCheck' && allInputs[i].checked){
				hasCheck = true;
				return hasCheck;
			}
		}
	}
	if(!hasCheck) {
		alert("You must select a budget for approval!");
	}
	return hasCheck;	
}

function showReject(){
	G$('mask').style.display = '';
	G$('rejectReasonDiv').style.display = '';	
}

function cancelReject(rejectReasonId){
	G$('rejectReasonDiv').style.display = 'none';
	G$('mask').style.display = 'none';
	G$(rejectReasonId).value = '';
}
function rejectReasonCheck(rejectReasonId){
	//if(G$(rejectReasonId).value.trim() == ''){
	if(theTrim(G$(rejectReasonId).value) == ''){
		alert('You must enter the reject reason!');
		return false;
	}
	G$('rejectReasonDiv').style.display = 'none';
	G$('mask').style.display = 'none';
	return true;
}
function theTrim(inputStr){
	inputStr = inputStr.replace(/^\s+|\s+$/,'');
	return inputStr;
}

function findTheNextInput($elem){
	if($elem.length===0) return;
	var tdCount,nextRow,nextTd,rowNum;
	if($elem[0].tagName.toUpperCase()==='INPUT'){
		tdCount=$elem.parent().prevAll().length;
		nextRow=$elem.parent().parent().next();
	}else if($elem[0].tagName.toUpperCase()==='TEXTAREA'){
		tdCount=3;
		nextRow=$elem.parent().parent().next();
	}else if($elem[0].tagName.toUpperCase()==='TD'||$elem[0].tagName.toUpperCase()==='TH'){
		tdCount=$elem.prevAll().length;
		nextRow=$elem.parent().next();
	}
	
	if(nextRow&&nextRow.find('textarea').length>0){		
		setSelect(nextRow.find('textarea'));			
		return;	
	}else{
		while(nextRow&&nextRow.children().length===6){ //make sure the tr has 7 td
			nextRow=nextRow.next();
		}
	
		if(!nextRow){nextRow=$('#accountTable').find('tbody').children().eq(0);}
		rowNum=nextRow.prevAll().length; 
		
		if(nextRow.length>0&&!nextRow.hasClass('itbtablereturn')){		
			nextTd=nextRow.children().eq(tdCount); 
		}else if(nextRow.hasClass('itbtablereturn')){		
			tdCount++;
			if(tdCount<6){
				nextRow=$('#accountTable').find('tbody').children().eq(rowNum-18);
				nextTd=nextRow.children().eq(tdCount);
			}
			else {						
				if(nextRow.next().find('textarea').length>0){
					
					setSelect(nextRow.next().find('textarea'));	
					return;	
				}else{
					for(var i=rowNum+1;i<$('#accountTable').find('tbody').children().length;i++){
						if($('#accountTable').find('tbody').children().eq(i).find('input[type!="hidden"]').length>0){
							nextRow=$('#accountTable').find('tbody').children().eq(i);
							break;
						}
					}
					tdCount=3;
					nextTd=nextRow.children().eq(tdCount);
				}
			}
		}else if(nextRow.length===0){
			
			tdCount++;
			if(tdCount<6){
				nextRow=$('#accountTable').find('tbody').children().eq(rowNum-4);
				nextTd=nextRow.children().eq(tdCount);
			}else{
				return;
			}
		}
		
		if(nextTd.find('input[type!="hidden"]').length>0){
			setSelect(nextTd.find('input[type!="hidden"]'));		
		}else{
			findTheNextInput(nextTd);
		}
	}
}
function findThePrevInput($elem){
	if($elem.length===0) return;
	var tdCount,prevRow,prevTd,rowNum; 
	if($elem[0].tagName.toUpperCase()==='INPUT'){
		tdCount=$elem.parent().prevAll().length;		
		prevRow=$elem.parent().parent().prev();
	}else if($elem[0].tagName.toUpperCase()==='TEXTAREA'){
		
		tdCount=5;		
		prevRow=$elem.parent().parent().prev();
	}else if($elem[0].tagName.toUpperCase()==='TD'||$elem[0].tagName.toUpperCase()==='TH'){
		tdCount=$elem.prevAll().length;
		prevRow=$elem.parent().prev();
	}
	
	if(prevRow&&prevRow.find('textarea').length>0){
		setSelect(prevRow.find('textarea'));			
		return;
	}else{	
		rowNum=prevRow.prevAll().length; 
		if(prevRow.length>0&&!prevRow.hasClass('itbprevreturn')){
			prevTd=prevRow.children().eq(tdCount);		
		}else if(prevRow.hasClass('itbprevreturn')){
			
			tdCount--;
			
			if(tdCount>2){
				if($('#accountTable').find('tbody').children().length>rowNum+20){
					prevRow=$('#accountTable').find('tbody').children().eq(rowNum+20);
					
				}else{
					prevRow=$('#accountTable').find('tbody').children().eq(-1);
					
				}
				
				prevTd=prevRow.children().eq(tdCount);
			}else{
				if(rowNum>0){
					for(var i=rowNum;i>=0;i--){
						if($('#accountTable').find('tbody').children().eq(i).find('textarea').length>0){
							setSelect($('#accountTable').find('tbody').children().eq(i).find('textarea'));	
							break;			
						}
					}
					return;
				}else{
					return;
				}
				
				tdCount=5;
				prevTd=prevRow.children().eq(tdCount);
				
			}
		}else if(prevRow.length===0){
			tdCount--;
			if(tdCount>=2){
				prevRow=$('#accountTable').find('tbody').children().eq(21);
				prevTd=prevRow.children().eq(tdCount);
			}else{
				return;
			}
		}
		if(prevTd.find('input[type!="hidden"]').length>0){
			setSelect(prevTd.find('input'));		
		}else{
			findThePrevInput(prevTd);
		}	
	}
}
function setSelectionRange(input, selectionStart, selectionEnd) {
		
		  if (input.setSelectionRange) {
		    input.focus();
		    input.setSelectionRange(selectionStart, selectionEnd);
		  }
		  else if (input.createTextRange) {
		    var range = input.createTextRange();
		    range.collapse(true);
		    range.moveEnd('character', selectionEnd);
		    range.moveStart('character', selectionStart);
		        
		    range.select();
		        
		  }
}
function setSelect($el){ 
		var contentLength;
		if($el[0].tagName.toUpperCase()==='TEXTAREA'){
			contentLength=$el.text().length; 
		}else {
			if(!$el||!($el.val()||$el.val()=='')){
				return false;
			}else if($el.val()===''){
				$el.val(0);
			}
			contentLength=$el.val().length;
		}
		
		
		var el=$el.get(0);
		setSelectionRange(el,0,contentLength);	
}
function findBDPrevInput($elem){
	if($elem.length===0) return;
	var prevRow,prevTd,tdCount,rowNum;
	if($elem[0].tagName.toUpperCase()==='INPUT'){
		prevRow=$elem.parent().parent();
		tdCount=$elem.parent().prevAll().length;		
	}else{
		prevRow=$elem.parent();
		tdCount=$elem.prevAll().length;
	}
	rowNum=prevRow.prevAll().length;
	prevRow=prevRow.prev();
	
	
	
	
	if(!prevRow||prevRow.length===0){
		tdCount--;
		if(tdCount>2){
			prevRow=$('#accountBDDataTable').find('tbody').find('tr.itbbdreturn').eq(1).prev();
			prevTd=prevRow.children().eq(tdCount);
		}else{
			return;
		}
	}else if(prevRow.hasClass('itbbdreturn')){
		tdCount--;
		if(tdCount>2){
			do{
				prevRow=prevRow.next();
			}while(prevRow&&prevRow.next().length>0&&!prevRow.hasClass('itbbdreturn'))
			
			prevRow=prevRow.prev();
			
			prevTd=prevRow.children().eq(tdCount);
			
		}else{				
			prevRow=prevRow.prev();
			tdCount=6;
			prevTd=prevRow.children().eq(tdCount);
		}
	}else{
		prevTd=prevRow.children().eq(tdCount);
	}
	if(prevTd.find('input[type!="hidden"]').length>0){
		setSelect(prevTd.find('input'));		
	}else{
		findBDPrevInput(prevTd);
	}	
	
}
function findBDNextInput($elem){
	if($elem.length===0) return;
	var nextRow,nextTd,tdCount,rowNum;
	
	if($elem[0].tagName.toUpperCase()==='INPUT'){
		nextRow=$elem.parent().parent();
		tdCount=$elem.parent().prevAll().length;		
	}else{
		nextRow=$elem.parent();
		tdCount=$elem.prevAll().length;
	}
	rowNum=nextRow.prevAll().length;
	nextRow=nextRow.next();
	if(!nextRow||nextRow.length===0){
		tdCount++;
		if(tdCount<7){
			nextRow=$('#accountBDDataTable').find('tbody').find('tr.itbbdreturn').eq(-1).next();
			nextTd=nextRow.children().eq(tdCount);
		}else{
			return;
		}
	}else if(nextRow.hasClass('itbbdreturn')){
		tdCount++;
		if(tdCount<7){
			do{
				nextRow=nextRow.prev();
			}while(nextRow&&!nextRow.hasClass('itbbdreturn'))
			nextRow=nextRow.next();
			nextTd=nextRow.children().eq(tdCount);
		}else{				
			nextRow=nextRow.next();
			tdCount=3;
			nextTd=nextRow.children().eq(tdCount);
		}
	}else{
		nextTd=nextRow.children().eq(tdCount);
	}
	if(nextTd.find('input[type!="hidden"]').length>0){
		setSelect(nextTd.find('input'));		
	}else{
		findBDNextInput(nextTd);
	}	
}
$(document).ready(function(){
	$('input',$('#accountTable')).live('keydown',function(event){
		if(event.shiftKey&&event.keyCode==9){
			findThePrevInput($(this));
			return false;
		}else if(event.keyCode==9||event.keyCode==13){
			findTheNextInput($(this));
			return false;
		}
	});
	$('textarea',$('#accountTable')).live('keydown',function(event){
		if(event.shiftKey&&event.keyCode==9){
			findThePrevInput($(this));
			return false;
		}else if(event.keyCode==9||event.keyCode==13){
			findTheNextInput($(this));
			return false;
		}
	});
	$('input',$('#accountBDDataTable')).live('keydown',function(event){
		if(event.shiftKey&&event.keyCode==9){
			findBDPrevInput($(this));
			return false;
		}else if(event.keyCode==9||event.keyCode==13){
			findBDNextInput($(this));
			return false;
		}
	});
	if(G$('accountTable') != null)conFormatNum('accountTable');
	else if(G$('accountBDDataTable') != null) conFormatNum('accountBDDataTable');
	else if(G$('managerReviewTable') != null)conFormatNum('managerReviewTable');
});



function addListener (element, event, fn, params) {
    var eventHandler = ( params ? function(){ fn.call(params) } : fn );

    if (window.attachEvent) {
        element.attachEvent('on' + event, eventHandler);
    } else {
        element.addEventListener(event, eventHandler, false);
    }
}
Object.clone = function(sObj){ 
    if(typeof sObj !== "object"){return sObj;}
    var s = (sObj.constructor == Array ? [] : {});
    for(var i in sObj){
        s[i] = Object.clone(sObj[i]); 
    }
    return s;
}  