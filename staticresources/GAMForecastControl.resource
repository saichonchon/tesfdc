    function computeVerticalTotal(textIdToUpdate, columnAndNumb, uniqueForBlock) {
	    var inputElem = document.getElementsByTagName("input");
	    var tempTotal = 0;
	    var toFind = '';
	    toFind = ''+columnAndNumb+''+uniqueForBlock;
	    //teisCol00_gam
	    for(var i=0; i<inputElem.length; i++)  {
	        if (inputElem[i].className.indexOf(toFind) !== -1) {
	        	tempTotal = tempTotal + parseInputText(inputElem[i].value);
	        }   
	    } 
	    //alert('the total value is ' +tempTotal);
	    document.getElementById(textIdToUpdate).innerHTML = toMoney(tempTotal, 0);
    }
    function computeHorizontalTotal(changedField, rowAndNumb, uniqueForBlock, targetRunRatePanel) {
        //changedField = this
        //rowAndNumb = teisRow01_
        //uniqueForBlock = gam, 1803881082, remaining

        
        //first get the opportunity column value
        var targetOppy = document.getElementsByTagName("span");
        var targetOppyValue = 0;
        var lookingFor = '';
        lookingFor = ''+rowAndNumb+''+uniqueForBlock;
        //alert('we are looking for '+lookingFor);
        for(var i = 0; i < targetOppy.length; i++) {
            if(targetOppy[i].className.indexOf(lookingFor) !== -1) {
	            targetOppyValue = parseInputText(targetOppy[i].innerHTML);
	            //alert(targetOppy[i] +' parsed is '+ parseInt(targetOppy[i].innerHTML));
	            //alert('the targetOppy is just ' +targetOppy[i]);
	            //alert('the targetOppy innerHTML is just ' +targetOppy[i].innerHTML);
	            //alert('the targetOppy innerHTML parsed is just ' +parseInt(targetOppy[i].innerHTML));
            } 
        }
        
        //second get the total demand that was just changed
        var targetDemandValue = 0;
        targetDemandValue = parseInputText(changedField.value);
        //alert('the new input value is '+targetDemandValue);
        
        //third calculate the difference
        var difference = 0;
        //alert('targetDemandValue is '+targetDemandValue +' and targetOppyValue is ' +targetOppyValue); 
        difference = targetDemandValue - targetOppyValue;
        
        //fourth get the targetRunRate column and set it to the difference
        var targetRR = document.getElementsByTagName("span");
        for(var i = 0; i < targetRR.length; i++) {
            if(targetRR[i].className.indexOf(('diff_teisOppyRow'+rowAndNumb.substring(7,10)+''+uniqueForBlock)) !== -1) {
                //diff_teisOppyRow00_gam
                targetRR[i].innerHTML = toMoney(difference, 0);
            } 
        }
        
        //fifth calculate and set the total run rate (also doing this vertical calculation)
        var totalVertTemp = 0;
        var targetRRagain = document.getElementsByTagName("span");
        for(var i = 0; i < targetRRagain.length; i++) {
            if(targetRRagain[i].className.indexOf(('teisCol01_'+uniqueForBlock)) !== -1) {
	            totalVertTemp = totalVertTemp + parseInputText(targetRRagain[i].innerHTML);
	            //parseInt(inputElem[i].value);
	            //parseInt(targetOppy[i].innerHTML);
            }
        }
        document.getElementById(targetRunRatePanel).innerHTML = toMoney(totalVertTemp, 0);
    } 
    function computeAccountTotals(rowClassName, accountNumber) {
        //this,'teisRow00_a',Overall_Forecast__c.Name
        
        //update 1: update the account header called teisHead_a111111082
        //update 1: step 1: calculate the correct header total by finding all of the teisCol00_a11111 and summing them
        var headTotal = 0;
        var teisAccounts = document.getElementsByTagName("input");
        for(var i = 0; i < teisAccounts.length; i++) {
            if(teisAccounts[i].className.indexOf(('teisCol00_a'+accountNumber)) !== -1) {
                //check for account number so we know we are not totaling with the wrong account data, we only want this one!
                headTotal = headTotal + parseInputText(teisAccounts[i].value);
                //alert('headTotal is '+headTotal);
            }
        }
        
        //update 1: step 2: find the appropriate account header and set the total that we previously calculated
        //teisHead_aOverallForecast-000000001
        var teisAcctHead = document.getElementsByTagName("div");
        for(var i = 0; i < teisAcctHead.length; i++) {
            if(teisAcctHead[i].className.indexOf(('teisHead_a'+accountNumber)) !== -1) {
                teisAcctHead[i].innerHTML = toMoney(headTotal, 0);
            } 
        }
        //update 1: done
        
        computeRemaining(rowClassName);
    }    
    function computeRemaining(rowClassName) {
        //update 2: update the Reamaining Accounts Run Rate for the specific month
        //update 2: step 1: obtain the total run rate value for the gam code first (for that month)
        var teisGamCodeForThisMonth = document.getElementsByTagName("span");
        var rowNumToUpdate = 0;
        rowNumToUpdate = rowClassName.substring(7,9);
        //alert('We are going to update row: '+rowNumToUpdate);
        var teisGamCodeTotalValueForThisMonth = 0;
        //alert('Looking for '+('diff_teisOppyRow'+rowNumToUpdate+'_gam'));
        for(var i = 0; i < teisGamCodeForThisMonth.length; i++) {
            if(teisGamCodeForThisMonth[i].className.indexOf(('diff_teisOppyRow'+rowNumToUpdate+'_gam')) !== -1) {
	            teisGamCodeTotalValueForThisMonth = parseInputText(teisGamCodeForThisMonth[i].innerHTML);
	            //alert('the teisGamCodeTotalValueForThisMonth is '+teisGamCodeTotalValueForThisMonth);
            }
        }
        //update 2: step 2: obtain the total for all of the accounts (for that same month)
        var teisAccountsForThisMonth = document.getElementsByTagName("input");
        var teisAccountTotalOfIndividuals = 0;
        for(var i = 0; i < teisAccountsForThisMonth.length; i++) {
            if(teisAccountsForThisMonth[i].className.indexOf(('teisRow'+rowNumToUpdate+'_a')) !== -1) {
                //note that we are doing just a starts with search, because we want all accounts
                teisAccountTotalOfIndividuals = teisAccountTotalOfIndividuals + parseInputText(teisAccountsForThisMonth[i].value);
                //lesson learned
                //to get the value from an input box just use .value
                //to get the value from a span or div use .innerHTML
            }
        }
        //update 2: step 3: take the total run rate from gam code and subtract the total for all of the accounts (for the same month)
        var calculatedRemaining = 0;
        calculatedRemaining = teisGamCodeTotalValueForThisMonth - teisAccountTotalOfIndividuals;
        
        //update 2: step 4: set the remaining run rate to the div teisRemaining00
        var teisRemaining = document.getElementsByTagName("div");
        for(var i = 0; i < teisRemaining.length; i++) {
            if(teisRemaining[i].className.indexOf(('teisRemaining'+rowNumToUpdate)) !== -1) {
                //alert('found '+'teisRemaining'+rowNumToUpdate);
                teisRemaining[i].innerHTML = toMoney(calculatedRemaining, 0);
            } 
        }
        if(calculatedRemaining < 0) {
            alert('Warning: Exception Account Forecast is greater than total Account Forecast by '+calculatedRemaining+'.  Please Total Demand Forecast or Decrease Exception Account Forecast.  Total Account Forecast must be greater than Exception Forecast.')
        } 
        //update 2: done
        
        
        //update 3: update the total for the remaining run rate
        //update 3: step 1: get the total of the new remaining values, but only for a year
        var teisRemainingAll = document.getElementsByTagName("div");
        var teisRemainingAllValue = 0;
        for(var i = 0; i < teisRemainingAll.length; i++) {
            if(teisRemainingAll[i].className.indexOf(('teisRemaining00')) !== -1
                || teisRemainingAll[i].className.indexOf(('teisRemaining01')) !== -1
                || teisRemainingAll[i].className.indexOf(('teisRemaining02')) !== -1
                || teisRemainingAll[i].className.indexOf(('teisRemaining03')) !== -1
                || teisRemainingAll[i].className.indexOf(('teisRemaining04')) !== -1
                || teisRemainingAll[i].className.indexOf(('teisRemaining05')) !== -1
                || teisRemainingAll[i].className.indexOf(('teisRemaining06')) !== -1
                || teisRemainingAll[i].className.indexOf(('teisRemaining07')) !== -1
                || teisRemainingAll[i].className.indexOf(('teisRemaining08')) !== -1
                || teisRemainingAll[i].className.indexOf(('teisRemaining09')) !== -1
                || teisRemainingAll[i].className.indexOf(('teisRemaining10')) !== -1
                || teisRemainingAll[i].className.indexOf(('teisRemaining11')) !== -1) {
                	teisRemainingAllValue = teisRemainingAllValue + parseInputText(teisRemainingAll[i].innerHTML);
            } 
        }
        //update 3: step 2: set the div teisRemainingHead to the previously calculated total value
        var teisRemainingHead = document.getElementsByTagName("div");
        for(var i = 0; i < teisRemainingAll.length; i++) {
            if(teisRemainingHead[i].className.indexOf(('teisRemainingHead')) !== -1) {
                teisRemainingHead[i].innerHTML = toMoney(teisRemainingAllValue, 0);
            } 
        }
        //update 3: done
        
        //may need to write a parse class to properly handle commas, decimal places or dollar signs
    }
    function zeroOutInputBoxes() {
		var allInputBoxes = document.getElementsByTagName("input");
		for(var i = 0; i < allInputBoxes.length; i++) {
			if(allInputBoxes[i].type == 'text') {
				if(allInputBoxes[i].value == '') {
					allInputBoxes[i].value = 0;
				} else if(allInputBoxes[i].value == '0.00') {
					allInputBoxes[i].value = 0;
				} else if (allInputBoxes[i].value.indexOf('.') !== -1) {
					//} else if (allInputBoxes[i].value.indexOf('.00') !== -1) {
					var positionOfDecimalsToIgnore = 0;
					positionOfDecimalsToIgnore = allInputBoxes[i].value.indexOf('.');
					allInputBoxes[i].value = allInputBoxes[i].value.substring(0, positionOfDecimalsToIgnore);
				}
			}
		}
    }
	function parseInputText(currencyIn) {
    	//var currencyIn = "$1,100.32";
    	//var tempReplaced = currencyIn.replace(/[^0-9\.]+/g,"");
    	var tempReplaced = currencyIn.replace(/[^0-9\.\-]+/g,"");
		var finalNumber = 0;
		if (tempReplaced.indexOf('.') !== -1) {
			var positionOfDecimalsToIgnore = 0;
			positionOfDecimalsToIgnore = tempReplaced.indexOf('.');
			finalNumber = Number(tempReplaced.substring(0, positionOfDecimalsToIgnore));
		} else {
			finalNumber = Number(tempReplaced);
		}
		//if(!isNaN(parseInt(inputElem[i].value)))
		if(!isNaN(finalNumber)) {
			return finalNumber;
		}
		return 0;
    }
    
	/* 
	decimal_sep: character used as deciaml separtor, it defaults to '.' when omitted
	thousands_sep: char used as thousands separator, it defaults to ',' when omitted
	*/
	function toMoney(n, decimals, decimal_sep, thousands_sep) { 
	   var c = isNaN(decimals) ? 2 : Math.abs(decimals), //if decimal is zero we must take it, it means user does not want to show any decimal
	   d = decimal_sep || '.', //if no decimal separator is passed we use the dot as default decimal separator (we MUST use a decimal separator)
	
	   /*
	   according to [http://stackoverflow.com/questions/411352/how-best-to-determine-if-an-argument-is-not-sent-to-the-javascript-function]
	   the fastest way to check for not defined parameter is to use typeof value === 'undefined' 
	   rather than doing value === undefined.
	   */   
	   t = (typeof thousands_sep === 'undefined') ? ',' : thousands_sep, //if you don't want to use a thousands separator you can pass empty string as thousands_sep value
	
	   sign = (n < 0) ? '-' : '',
	
	   //extracting the absolute value of the integer part of the number and converting to string
	   i = parseInt(n = Math.abs(n).toFixed(c)) + '', 
	
	   j = ((j = i.length) > 3) ? j % 3 : 0; 
	   return '$' + sign + (j ? i.substr(0, j) + t : '') + i.substr(j).replace(/(\d{3})(?=\d)/g, "$1" + t) + (c ? d + Math.abs(n - i).toFixed(c).slice(2) : ''); 
	}

    function validate()
    {
       var ovf0Obj = document.getElementById("{!$Component.entirePageForm.OV0}");
       var ovf1Obj = document.getElementById("{!$Component.entirePageForm.OV1}");
       var ovf2Obj = document.getElementById("{!$Component.entirePageForm.OV2}");
       var ovf3Obj = document.getElementById("{!$Component.entirePageForm.OV3}");
       var ovf4Obj = document.getElementById("{!$Component.entirePageForm.OV4}");
       var ovf5Obj = document.getElementById("{!$Component.entirePageForm.OV5}");
       var ovf6Obj = document.getElementById("{!$Component.entirePageForm.OV6}");
       var ovf7Obj = document.getElementById("{!$Component.entirePageForm.OV7}");
       var ovf8Obj = document.getElementById("{!$Component.entirePageForm.OV8}");
       var ovf9Obj = document.getElementById("{!$Component.entirePageForm.OV9}");
       var ovf10Obj = document.getElementById("{!$Component.entirePageForm.OV10}");
       var ovf11Obj = document.getElementById("{!$Component.entirePageForm.OV11}");
       var ovf12Obj = document.getElementById("{!$Component.entirePageForm.OV12}");
       var ovf13Obj = document.getElementById("{!$Component.entirePageForm.OV13}");
       var ovf14Obj = document.getElementById("{!$Component.entirePageForm.OV14}");
       var ovf15Obj = document.getElementById("{!$Component.entirePageForm.OV15}");
       var ovf16Obj = document.getElementById("{!$Component.entirePageForm.OV16}");
       var ovf17Obj = document.getElementById("{!$Component.entirePageForm.OV17}");
       var ovb0Obj = document.getElementById("{!$Component.entirePageForm.OVB0}");
       var ovb1Obj = document.getElementById("{!$Component.entirePageForm.OVB1}");
       var ovb2Obj = document.getElementById("{!$Component.entirePageForm.OVB2}");
       var ovb3Obj = document.getElementById("{!$Component.entirePageForm.OVB3}");
       var ovb4Obj = document.getElementById("{!$Component.entirePageForm.OVB4}");
       var ovb5Obj = document.getElementById("{!$Component.entirePageForm.OVB5}");
       var ovb6Obj = document.getElementById("{!$Component.entirePageForm.OVB6}");
       var ovb7Obj = document.getElementById("{!$Component.entirePageForm.OVB7}");
       var ovb8Obj = document.getElementById("{!$Component.entirePageForm.OVB8}");
       var ovb9Obj = document.getElementById("{!$Component.entirePageForm.OVB9}");
       var ovb10Obj = document.getElementById("{!$Component.entirePageForm.OVB10}");
       var ovb11Obj = document.getElementById("{!$Component.entirePageForm.OVB11}");
       var ovb12Obj = document.getElementById("{!$Component.entirePageForm.OVB12}");
       var ovb13Obj = document.getElementById("{!$Component.entirePageForm.OVB13}");
       var ovb14Obj = document.getElementById("{!$Component.entirePageForm.OVB14}");
       var ovb15Obj = document.getElementById("{!$Component.entirePageForm.OVB15}");
       var ovb16Obj = document.getElementById("{!$Component.entirePageForm.OVB16}");
       var ovb17Obj = document.getElementById("{!$Component.entirePageForm.OVB17}");
       var ova0Obj = document.getElementById("{!$Component.entirePageForm.OVA0}");
       var ova1Obj = document.getElementById("{!$Component.entirePageForm.OVA1}");
       var ova2Obj = document.getElementById("{!$Component.entirePageForm.OVA2}");
       var ova3Obj = document.getElementById("{!$Component.entirePageForm.OVA3}");
       var ova4Obj = document.getElementById("{!$Component.entirePageForm.OVA4}");
       var ova5Obj = document.getElementById("{!$Component.entirePageForm.OVA5}");
       var ova6Obj = document.getElementById("{!$Component.entirePageForm.OVA6}");
       var ova7Obj = document.getElementById("{!$Component.entirePageForm.OVA7}");
       var ova8Obj = document.getElementById("{!$Component.entirePageForm.OVA8}");
       var ova9Obj = document.getElementById("{!$Component.entirePageForm.OVA9}");
       var ova10Obj = document.getElementById("{!$Component.entirePageForm.OVA10}");
       var ova11Obj = document.getElementById("{!$Component.entirePageForm.OVA11}");
       var ova12Obj = document.getElementById("{!$Component.entirePageForm.OVA12}");
       var ova13Obj = document.getElementById("{!$Component.entirePageForm.OVA13}");
       var ova14Obj = document.getElementById("{!$Component.entirePageForm.OVA14}");
       var ova15Obj = document.getElementById("{!$Component.entirePageForm.OVA15}");
       var ova16Obj = document.getElementById("{!$Component.entirePageForm.OVA16}");
       var ova17Obj = document.getElementById("{!$Component.entirePageForm.OVA17}");
       
       
       if(trim(ovf0Obj.value) == "" ||trim(ovf1Obj.value) == "" ||trim(ovf2Obj.value) == "" || trim(ovf3Obj.value) == "" ||trim(ovf4Obj.value) == "" ||trim(ovf5Obj.value) == "" || trim(ovf6Obj.value) == "" ||trim(ovf7Obj.value) == "" ||trim(ovf8Obj.value) == "" ||trim(ovf9Obj.value) == "" ||trim(ovf10Obj.value) == "" ||trim(ovf11Obj.value) == "" || trim(ovf12Obj.value) == "" || trim(ovf13Obj.value) == "" || trim(ovf14Obj.value) == "" || trim(ovf15Obj.value) == "" || trim(ovf16Obj.value) == "" || trim(ovf17Obj.value) == "" || trim(ovb0Obj.value) == "" ||trim(ovb1Obj.value) == "" ||trim(ovb2Obj.value) == "" || trim(ovb3Obj.value) == "" ||trim(ovb4Obj.value) == "" ||trim(ovb5Obj.value) == "" || trim(ovb6Obj.value) == "" ||trim(ovb7Obj.value) == "" ||trim(ovb8Obj.value) == "" ||trim(ovb9Obj.value) == "" ||trim(ovb10Obj.value) == "" ||trim(ovb11Obj.value) == "" || trim(ovb12Obj.value) == "" || trim(ovb13Obj.value) == "" || trim(ovb14Obj.value) == "" || trim(ovb15Obj.value) == "" || trim(ovb16Obj.value) == "" || trim(ovb17Obj.value) == "") 
       {
       		alert("Forecast or Booking values cannot updated with null values!");
            return false;
       }
        else {
        actionsave();
        return true;
        }                   
     }
   
	