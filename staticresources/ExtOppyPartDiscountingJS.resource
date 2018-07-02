//var str_priceBreakJson = '{!str_priceBreakJson}';
    //var list_priceBreak = JSON.parse(str_priceBreakJson);
    //var list_oppyPartItems = JSON.parse('{!str_oppyPartJson}');
	
    var orignListPrice = [];
    var currentRowIndex;
    
    var elementWillHide = new Array();
    
    $(document).ready(function() {
        //getListPrice();
        //verifyOfferedPrice();
        //getOrignListPrice();
        hideNoUseStatus();
        bindMousemove();
        setDefaultRadioChecked();
        populateOffsetPercent();
        alignTheFixedHeader();
        resizeWindowAction();
        syncTotalPrice();
        addCommaSeparatorForEachLine();
        hideLoading();
    });
    
    function methodsAfterRender(){
        //getListPrice();
        //verifyOfferedPrice();
        //getOrignListPrice();
        hideNoUseStatus();
        bindMousemove();
        setDefaultRadioChecked();
        populateOffsetPercent();
        alignTheFixedHeader();
        resizeWindowAction();
        addCommaSeparatorForEachLine();
        syncTotalPrice();
    }
    
    function bindMousemove(){
        $(".td_listPrice_class").mouseover(function(e){
        	var salesPriceErrorMessage = $($(e.currentTarget).find("input.price_error_message")).val();
        	if(salesPriceErrorMessage != ''){
				$("#div_salesprice_errorMessage").html(" " + salesPriceErrorMessage);
				$("table.table_salesprice_onmousepopup").hide();
				var mousePos = mousePosition(e);  
                var  xOffset = 20;  
                var  yOffset = 25;  
                $("#div_onMousePopupWindow").css("display","block").css("position","absolute").css("top",(mousePos.y - yOffset - 20) + "px").css("left",(mousePos.x - xOffset + 50) + "px"); 

			}else{
				$("#div_salesprice_errorMessage").html('');
				$("table.table_salesprice_onmousepopup").show();
				var currPartId = $(e.currentTarget).attr('dir');
	            var isNodataFlag = false;
	            var hideLineCounter = 0;
	            var totalLine = $("tr.tr_priceBreakForPage_class").length;
	            $("tr.tr_priceBreakForPage_class").each(function(){
	                if($(this).attr("dir").toLowerCase() == currPartId.toLowerCase()){
	                    $(this).css("display","");  
	                }else{
	                    hideLineCounter = hideLineCounter + 1;
	                    $(this).css("display","none");  
	                }
	            }); 
	            if(hideLineCounter != totalLine){
	                var mousePos = mousePosition(e);  
	                var  xOffset = 20;  
	                var  yOffset = 25;  
	                $("#div_onMousePopupWindow").css("display","block").css("position","absolute").css("top",(mousePos.y - yOffset - 20) + "px").css("left",(mousePos.x - xOffset + 50) + "px");  
	            }
			}
        });
        $(".td_pastQuotes_class").hover(function(e){
        	$("#tbody_pastQuotesWindow").empty();
        	var json_quoteLineItems = $(e.currentTarget).attr('dir');
        	if($(e.currentTarget).find("a.link_pastQuotes_class").length <= 0 ){
        		$("#div_pastQuotesWindow").css("display","none");
        		return null;
        	}else{
        		if($($(e.currentTarget).find("a.link_pastQuotes_class")[0]).is(":hidden")){
        			$("#div_pastQuotesWindow").css("display","none");
        			return null;
        		}
        	}
        	if(json_quoteLineItems == 'true'){
				$(e.currentTarget).find("span.span_pastQuotes_class").each(function(){
					var f1 = $(this).attr('data-soldto');
					var f2 = $(this).attr('data-quantity');
					var f3 = $(this).attr('data-price');
					var lineNo = $(this).attr('data-line');
					var quoteId = $(this).attr('data-quoteid');
					var quoteNum = $(this).attr('data-quotenumber');
					var quoteLineItemId = $(this).attr('data-quotelineitemid');
					var currencyCode =" "+ $(this).attr('data-currencycode');
					var alink = "<a target='_blank' href='/"+quoteLineItemId+"'>"+quoteNum+"</a>";
					var endUser = $(this).attr('data-enduser');
					var str_return = "<tr class='dataRow'><td class='dataCell' style='text-decoration:underline;'>"+alink+"</td>";
					str_return = str_return + "<td onclick='copyTargetPrice("+f3+","+lineNo+",&quot;"+currencyCode+"&quot;);copyRFOlink("+lineNo+",&quot;"+quoteId+"&quot;,&quot;"+quoteNum+"&quot;,&quot;"+quoteLineItemId+"&quot;);' class='dataCell'>"+f1;
					str_return = str_return + "</td><td onclick='copyTargetPrice("+f3+","+lineNo+",&quot;"+currencyCode+"&quot;);copyRFOlink("+lineNo+",&quot;"+quoteId+"&quot;,&quot;"+quoteNum+"&quot;,&quot;"+quoteLineItemId+"&quot;);' class='dataCell'>"+endUser;
					str_return = str_return + "</td><td onclick='copyTargetPrice("+f3+","+lineNo+",&quot;"+currencyCode+"&quot;);copyRFOlink("+lineNo+",&quot;"+quoteId+"&quot;,&quot;"+quoteNum+"&quot;,&quot;"+quoteLineItemId+"&quot;);' class='dataCell'>"+f2;
					str_return = str_return + "</td><td onclick='copyTargetPrice("+f3+","+lineNo+",&quot;"+currencyCode+"&quot;);copyRFOlink("+lineNo+",&quot;"+quoteId+"&quot;,&quot;"+quoteNum+"&quot;,&quot;"+quoteLineItemId+"&quot;);' class='dataCell'>"+f3+currencyCode+"</td></tr>";
					$("#tbody_pastQuotesWindow").append(str_return);
				});
				var mousePos = mousePosition(e);  
	            var  xOffset = 20;  
	            var  yOffset = 25;  
	            $("#div_pastQuotesWindow").css("display","block").css("position","absolute").css("top",(mousePos.y - yOffset - 20) + "px").css("left",(mousePos.x - xOffset - 300) + "px");
        	}else{
        		$("#div_pastQuotesWindow").css("display","none");
        		return null;
        	}
        });
        $("#div_pastQuotesWindow").mouseleave(function(){
        	//console.log('mouseout:::',$("#div_pastQuotesWindow").css("display"));
        	$("#div_pastQuotesWindow").css("display","none");
        });
        $(".td_partNumber_class").mouseover(function(e){
        	$("#tbody_InventoriesWindow").empty();
			$("#leadtime_InventoriesWindow").empty();
        	var hasInventories = false;
        	var leadtime = $($(e.currentTarget).find("span.span_moqAndLeadtime_class")).attr('data-leadtime');
        	var moq = $($(e.currentTarget).find("span.span_moqAndLeadtime_class")).attr('data-moq');
        	var packQty = $($(e.currentTarget).find("span.span_moqAndLeadtime_class")).attr('data-packqty');
        	var maxQty = $($(e.currentTarget).find("span.span_moqAndLeadtime_class")).attr('data-maxqty');
        	var dec_qtyNettable = $($(e.currentTarget).find("span.span_moqAndLeadtime_class")).attr('data-qtynettable');
        	var total_QtyNettable = 0;
        	
        	//console.log('moq::Min_Order_Qty__c::',moq);
        	//console.log('ppq::Primary_Pack_Quantity__c::',packQty);
        	//console.log('max::Max_Qty_in_Standard_lead_time__c::',maxQty);
        	//console.log('leadtime::Lead_Time__c::',leadtime);
        	//console.log('available::Availability__c::',dec_qtyNettable);
        	
			$(e.currentTarget).find("span.span_listInventories_class").each(function(){
				var f0 = $(this).attr('data-leadtime');
				var f1 = $(this).attr('data-name');
				var f2 = $(this).attr('data-quantity');
				var f3 = $(this).attr('data-status');
				
				//added by Tangyong Li 2017-10-09
				var f4 = $(this).attr('data-moq');
				
				var lineNo = $(this).attr('data-line');

				var str_return = "<tr class='dataRow'><td class='dataCell'>" +f1+"</td><td class='dataCell'>"+f2+"</td><td class='dataCell'>"+f3+"</td></tr>";
				$("#tbody_InventoriesWindow").append(str_return);
				hasInventories = true;
				
				if(f2 != null && f2 != ''){
					total_QtyNettable = total_QtyNettable + Number(f2);
				}
			});
			
			if(packQty){
				$("#PackQuantity_InventoriesWindow").html("PPQ: " + packQty);
			}else{
				$("#PackQuantity_InventoriesWindow").html("PPQ: Unknown" );
			}
			if(maxQty){
				$("#MaxQuantity_InventoriesWindow").html("Max Qty in SLT: " + maxQty);
			}else{
				$("#MaxQuantity_InventoriesWindow").html("Max Qty in SLT: Unknown" );
			}
			if(dec_qtyNettable){
				$("#QtyNettable_InventoriesWindow").html("Available: " + dec_qtyNettable);
				//$("#QtyNettable_InventoriesWindow").html("Available: " + total_QtyNettable);
			}else{
				$("#QtyNettable_InventoriesWindow").html("Available: Unknown" );
			}
			if(leadtime){
				$("#leadtime_InventoriesWindow").html("Lead Time: " + leadtime);    			
			}else{
				$("#leadtime_InventoriesWindow").html("Lead Time: Unknown" );
			}
			if(moq){
				$("#MOQ_InventoriesWindow").html("MOQ: " + moq);
			}else{
				$("#MOQ_InventoriesWindow").html("MOQ: Unknown" );
			}

			if(dec_qtyNettable || leadtime || moq || maxQty || packQty){
				var mousePos = mousePosition(e);  
	            var  xOffset = 20;  
	            var  yOffset = 25;  
	            $("#div_InventoriesWindow").css("display","block").css("position","absolute").css("top",(mousePos.y - yOffset - 20) + "px").css("left",(mousePos.x - xOffset + 50) + "px");
        	}
        });
        $(".td_quantity_class").mouseover(function(e){
        	var quantityInfoMessage = $($(e.currentTarget).find("span.span_quantity_infoMessage_class")).attr('data-message');
        	if(quantityInfoMessage != null && quantityInfoMessage != ''){
				$("#div_quantity_infoMessage").html(" " + quantityInfoMessage);
				var mousePos = mousePosition(e);  
                var  xOffset = 20;  
                var  yOffset = 25;  
                $("#div_quantity_onMousePopupWindow").css("display","block").css("position","absolute").css("top",(mousePos.y - yOffset - 20) + "px").css("left",(mousePos.x - xOffset + 50) + "px"); 
			}
        });
    }
    
    function changeAddPartSearchTab(){
    	var buttonArr = document.getElementsByClassName("ttestClassButton");
		var divArr = document.getElementsByClassName("ttestClassDiv");
		for(var i = 0; i < buttonArr.length;i++) {
			buttonArr[i].onclick = function() {
				for(var j = 0; j < buttonArr.length; j++) {
					buttonArr[j].style.backgroundColor = "#dddddd";
					this.style.backgroundColor = "transparent";
					divArr[j].style.display = "none";
					if(this == buttonArr[j]) {
						divArr[j].style.display = "block";
					}
				}
				populateVirtualParts();
			}
		}
		virtualPartsCounter();
    }
    
    function populateVirtualParts(){
    	var str_innerHtml = '';
    	for(var i=0;i<addPartVirtualList.length;i++){
    		str_innerHtml = str_innerHtml + '<tr class="dataRow"><td class="dataCell virtualPartsColumn1_class" onclick="deleteVirtualParts(this);" html-index="'+ i +'" colspan="1">X</td>' 
        					+ '<td class="dataCell virtualPartsColumn2_class" id="" colspan="1"><span id="">'+ addPartVirtualList[i].partName +'</span></td>'
        					+ '<td class="dataCell virtualPartsColumn3_class" id="" colspan="1"><span style="">'+ addPartVirtualList[i].quantity +'</span></td></tr>';
        }
        $("#tbody_virtualParts").empty();
        $("#tbody_virtualParts").append(str_innerHtml);
    }
    
    function virtualPartsCounter(){
    	$("#span_virtualPartsCounter").text(addPartVirtualList.length);
    }
    
    function deleteVirtualParts(obj){
    	var delIndex = $(obj).attr('html-index');
    	//console.log('dexIndex::',delIndex);
    	addPartVirtualList.splice(delIndex,1);
    	//console.log('afterDel::',addPartVirtualList);
    	populateVirtualParts();
    	virtualPartsCounter();
    }
    
    function mousePosition(ev){   
        ev = ev || window.event;   
        if(ev.pageX || ev.pageY){   
            return {x:ev.pageX, y:ev.pageY};   
        }   
        return {   
            x:ev.clientX + document.body.scrollLeft - document.body.clientLeft,   
            y:ev.clientY + document.body.scrollTop + document.body.clientTop   
        };   
    }
    
    function buildTableForQuoteLineItems(obj){
    	var str_return = '';
    	str_return = '<tr class="dataRow" dir="" ><td class="dataCell">'+obj.Energy_Quote_Name__r.Opportunity_Name__r.NDR_Sold_to_Account_Name__c+'</td><td class="dataCell">'+obj.Quantity__c+'</td><td class="dataCell">'+obj.UnitPrice__c+'</td></tr>';
    	return str_return;
    }
    
    function mouseLeave(){
        $("#div_onMousePopupWindow").css("display","none");  
    }
    
    function hideInventoriesWindow(){
        $("#div_InventoriesWindow").css("display","none");  
    }
    
    function hideQuantityPopupWindow(){
        $("#div_quantity_onMousePopupWindow").css("display","none");  
    }
    
    function syncQuantity() {
    	//This method use static table cell number. 
    	currentRowIndex = event.currentTarget.parentNode.parentNode.parentNode.rowIndex;
        console.log('currentRowIndex::',currentRowIndex); 
        var tds = $($("table[id*='myTable'] tr")[currentRowIndex]).children('td');
        var quality = event.target.value;
        var listPrice = '$--';
        
        listPrice = $($(event.currentTarget).parent().parent().next().next().next().next().find('input.targetPrice')).val();
        listPrice = convertIntoNumber(listPrice);
        console.log('listPrice::',listPrice);
        console.log('quality::',quality);

        var totalPrice;
        if(listPrice != '$--') {
            totalPrice = listPrice*quality;
            totalPrice = toDecimal2(totalPrice);
        } else {
            totalPrice = 0;
        }
        //console.log('tds.length::',tds.length);
        if(tds.length >= 10){
        console.log('$(tds[9])::',$(tds[9]));
            if($(tds[9]).length>0){
            	console.log('$($(tds[9])[0])::',$($(tds[9])[0]));
                //$($(tds[9])[0]).text(totalPrice);
                $(tds[9]).find('input.initValueTotal').val(totalPrice);
                $(tds[9]).find('span.span_output_totalPrice').text(convertIntoComma(Number(totalPrice)));
            }
        }
    	
    	syncTotalPrice();
    }
    
    function syncTargetPrice() {
    	//This method use static table cell number. 
    	currentRowIndex = event.currentTarget.parentNode.parentNode.parentNode.rowIndex;
        console.log('currentRowIndex::',currentRowIndex); 
        var tds = $($("table[id*='myTable'] tr")[currentRowIndex]).children('td');
        var listPrice = convertIntoNumber(event.target.value);
        var quality = '$--';
        
        quality = $($(event.currentTarget).parent().parent().prev().prev().prev().prev().find('input.qty')).val();
        console.log('listPrice::',listPrice);
        console.log('quality::',quality);

        var totalPrice;
        if(listPrice != '$--') {
            totalPrice = listPrice*quality;
            totalPrice = toDecimal2(totalPrice);
        } else {
            totalPrice = 0;
        }
        console.log('tds.length::',tds.length);
        if(tds.length >= 10){
        //console.log('$(tds[9])::',$(tds[9]));
            if($(tds[9]).length>0){
            	//console.log('$($(tds[9])[0])::',$($(tds[9])[0]));
                //$($(tds[9])[0]).text(totalPrice);
                $(tds[9]).find('input.initValueTotal').val(totalPrice);
                $(tds[9]).find('span.span_output_totalPrice').text(convertIntoComma(Number(totalPrice)));
            }
        }
    	
    	syncTotalPrice();
    }
    
    function syncTotalPrice(){
    	//This method use static table cell number. 
    	var totalAmount = 0;
    	$("table[id*='myTable'] tbody tr").each(function() {
			var tdsForAll = $(this).find("td");
			if(tdsForAll.length >= 10){
				var currentTotal = Number($(tdsForAll[9]).find('input.initValueTotal').val());
				if(isNaN(currentTotal)){
					currentTotal = 0;
				}
				totalAmount = totalAmount + currentTotal;
			}
        });
        console.log('totalAmount::',toDecimal2(totalAmount));
        $("#span_totalAmount").text(toDecimal2(totalAmount));
        
        console.log('usdExchangeRate::',usdExchangeRate);
        usdExchangeRate = Number(usdExchangeRate);
        
        var totalAmountUSD = totalAmount*usdExchangeRate;
    	$("#span_USDTotalValue").text(toDecimal2(totalAmountUSD));
    	
    	addCommaSeparator();
    	//addCommaSeparatorForEachLine();
        
        //$("input[id*='hidden_param_currencyFromValue']").val(totalAmount);
    	//$("input[id*='hidden_param_currencyFromCode']").val(oppyCurrency);
    	//$("input[id*='hidden_param_currencyToCode']").val('USD');
    	
    	//showLoading();
    	//action_transformCurrencyToUSD();
    }
    
    function syncTotalPriceUSDCallback(){
    	//This method not in use.
    	var totalAmountUSD = $("input[id*='hidden_param_currencyToValue']").val();
    	$("#span_USDTotalValue").text(toDecimal2(totalAmountUSD));
    	hideLoading();
    }
    
    function getListPrice() {
    	//This method not in use.
    	//This method use static table cell number. 
		console.log("list_priceBreak:::::::    ", list_priceBreak);
        $('.listPriceCss :hidden').change(function(e) {
            currentRowIndex = e.currentTarget.parentNode.parentNode.rowIndex;
            console.log('currentRowIndex::',currentRowIndex); 
            var tds = $($("table[id*='myTable'] tr")[currentRowIndex]).children('td');
            var partId = $(e.currentTarget.parentNode).prev().find("input[id=part_Id]").val();
            var quality = e.target.value;
            var listPrice = '$--';
            if(parseFloat(quality).toString() != 'NaN') {
                quality = Number(quality);
                for(var i=0; i<list_priceBreak.length; i++) {
                    if(partId != '' && list_priceBreak[i].Part__c == partId){
                        if(list_priceBreak[i].Quantity_high_end__c != null) {
                            if(quality >= list_priceBreak[i].Quantity_low_end__c && quality <= list_priceBreak[i].Quantity_high_end__c) {
                                listPrice = list_priceBreak[i].List_Price__c;
                                break;
                            }
                        } else {
                            if(quality >= list_priceBreak[i].Quantity_low_end__c) {
                                listPrice = list_priceBreak[i].List_Price__c;
                                break;
                            }
                        }
                    }
                }
            }
            $(e.currentTarget).parent().next().find('span').html(listPrice);
            $(e.currentTarget).parent().next().find('input').val(listPrice);
            console.log($(e.currentTarget).parent().next().next());
            var totalPrice;
            if(listPrice != '$--') {
                totalPrice = listPrice*quality;
                totalPrice = toDecimal2(totalPrice);
            } else {
                totalPrice = '';
            }
            if(tds.length >= 10){
                if($(tds[9]).length>0){
                    $($(tds[9])[0]).text(totalPrice);
                }
            }
        });
    }
    

    function toDecimal2(x) {    
        var f = parseFloat(x);    
        if (isNaN(f)) {    
            return false;    
        }    
        var f = Math.round(x*100)/100;    
        var s = f.toString();    
        var rs = s.indexOf('.');    
        if (rs < 0) {    
            rs = s.length;    
            s += '.';    
        }    
        while (s.length <= rs + 2) {    
            s += '0';    
        }    
        return s;    
    } 
    

    function toDecimal0(x) {    
        var f = parseFloat(x);    
        if (isNaN(f)) {    
            return false;    
        }    
        var f = Math.round(x*100)/100;   
        f= parseInt(f); 
        var s = f.toString();      
        
        return s;    
    }   
    
    function verifyOfferedPrice() {
    	//This method not in use.
    	/*
        var listPrice = $(event.currentTarget).parent().prev().find('input').val();
        listPrice = Number(listPrice);
        console.log(listPrice);
        var currentPrice = event.target.value;
        if(currentPrice > listPrice || parseFloat(currentPrice).toString() == 'NaN') {
            event.target.value = null;
            alert("Target Price shouldn't be higher than Sales Price!");
        }
    	
        $('.OfferedPriceCss :hidden').change(function(e) {
            var listPrice = $(e.currentTarget).parent().prev().find('input').val();
            console.log(listPrice);
            listPrice = Number(listPrice);
            console.log(listPrice);
            var currentPrice = e.target.value;
            if(currentPrice > listPrice || parseFloat(currentPrice).toString() == 'NaN') {
                e.target.value = null;
                alert("Target Price shouldn't be higher than Sales Price!");
            }
        });
        */
    }
    
    
    function getOrignListPrice() {
    	//This method not in use.
		//var list_oppyPartItems = JSON.parse('{!str_oppyPartJson}');
        //console.log('list_oppyPartItems:::  ', list_oppyPartItems);
        //for(var i=0; i<list_oppyPartItems.length; i++) {
            //orignListPrice.push(list_oppyPartItems[i].oppyPart.Sales_Price__c);
        //}
    }
    
    function addPart() {
    	//This method use static table cell number.
        showLoading();
        $($("span[id*=partPopup] textarea[id*=inputSearchText]")[0]).val('');
        $($("span[id*=partPopup] textarea[id*=desSearchText]")[0]).val('');
        
        //var list_partId = [];
        //$("table[id*='partListTable'] input[type='checkbox']").each(function () {
            //if($(this).attr("checked")) {
                //list_partId.push($(this).next().val());
            //}
        //});
        //addOppyPart(JSON.stringify(list_partId));
        
        var list_parts = [];
        $("table[id*='partListTable'] tbody tr").each(function () {
        	if($(this).children('td').length > 6){
        		var checkboxTd = $(this).children('td')[0];
        		var quantityTd = $(this).children('td')[6];
        		var ckbox = $(checkboxTd).find("input[type='checkbox']");
	            if(ckbox.length > 0 && $(ckbox[0]).attr("checked")) {
	                var temp = new Object();
	                temp.partId = $(ckbox[0]).next().val();
	                temp.quantity = $($(quantityTd).find("input[type='number']")[0]).val();
	                temp.partName = $(ckbox[0]).next().next().val();
	                list_parts.push(temp);
	            }
            }else if($(this).children('td').length > 5){
        		var checkboxTd = $(this).children('td')[0];
        		var quantityTd = $(this).children('td')[5];
        		var ckbox = $(checkboxTd).find("input[type='checkbox']");
	            if(ckbox.length > 0 && $(ckbox[0]).attr("checked")) {
	                var temp = new Object();
	                temp.partId = $(ckbox[0]).next().val();
	                temp.quantity = $($(quantityTd).find("input[type='number']")[0]).val();
	                temp.partName = $(ckbox[0]).next().next().val();
	                list_parts.push(temp);
	            }
            }
        });
        
        for(var i=0;i<addPartVirtualList.length;i++){
        	list_parts.push(addPartVirtualList[i]);
        }
        addPartVirtualList = new Array();
        console.log('addPart::',list_parts);
        addOppyPart(JSON.stringify(list_parts));
    }
    
    function addPartNew() {
    	//This method use static table cell number.
        showLoading();
        $($("span[id*=partPopup] textarea[id*=inputSearchText]")[0]).val('');
        $($("span[id*=partPopup] textarea[id*=desSearchText]")[0]).val('');
        
        var list_parts = [];
        $("table[id*='partListTable'] tbody tr").each(function () {
        	if($(this).children('td').length > 6){
        		var checkboxTd = $(this).children('td')[0];
        		var quantityTd = $(this).children('td')[6];
        		var ckbox = $(checkboxTd).find("input[type='checkbox']");
	            if(ckbox.length > 0 && $(ckbox[0]).attr("checked")) {
	                var temp = new Object();
	                temp.partId = $(ckbox[0]).next().val();
	                temp.quantity = $($(quantityTd).find("input[type='number']")[0]).val();
	                temp.partName = $(ckbox[0]).next().next().val();
	                list_parts.push(temp);
	            }
            }else if($(this).children('td').length > 5){
        		var checkboxTd = $(this).children('td')[0];
        		var quantityTd = $(this).children('td')[5];
        		var ckbox = $(checkboxTd).find("input[type='checkbox']");
	            if(ckbox.length > 0 && $(ckbox[0]).attr("checked")) {
	                var temp = new Object();
	                temp.partId = $(ckbox[0]).next().val();
	                temp.quantity = $($(quantityTd).find("input[type='number']")[0]).val();
	                temp.partName = $(ckbox[0]).next().next().val();
	                list_parts.push(temp);
	            }
            }
        });
        console.log('addPart::',list_parts);
        addOppyPartNew(JSON.stringify(list_parts));
    }
    
    function addPartNewNoRefresh() {
    	//This method use static table cell number.
        showLoading();
        $($("span[id*=partPopup] textarea[id*=inputSearchText]")[0]).val('');
        $($("span[id*=partPopup] textarea[id*=desSearchText]")[0]).val('');
        
        var list_parts = [];
        $("table[id*='partListTable'] tbody tr").each(function () {
        	if($(this).children('td').length > 6){
        		var checkboxTd = $(this).children('td')[0];
        		var quantityTd = $(this).children('td')[6];
        		var ckbox = $(checkboxTd).find("input[type='checkbox']");
	            if(ckbox.length > 0 && $(ckbox[0]).attr("checked")) {
	                var temp = new Object();
	                temp.partId = $(ckbox[0]).next().val();
	                temp.quantity = $($(quantityTd).find("input[type='number']")[0]).val();
	                temp.partName = $(ckbox[0]).next().next().val();
	                list_parts.push(temp);
	            }
            }else if($(this).children('td').length > 5){
        		var checkboxTd = $(this).children('td')[0];
        		var quantityTd = $(this).children('td')[5];
        		var ckbox = $(checkboxTd).find("input[type='checkbox']");
	            if(ckbox.length > 0 && $(ckbox[0]).attr("checked")) {
	                var temp = new Object();
	                temp.partId = $(ckbox[0]).next().val();
	                temp.quantity = $($(quantityTd).find("input[type='number']")[0]).val();
	                temp.partName = $(ckbox[0]).next().next().val();
	                list_parts.push(temp);
	            }
            }
        });
        console.log('addPart::',list_parts);
        addOppyPartNewNoRefresh(JSON.stringify(list_parts));
    }
    
    var addPartVirtualList = new Array();
    
    function addPartVirtual() {
    	//This method use static table cell number.
        showLoading();
        $($("span[id*=partPopup] textarea[id*=inputSearchText]")[0]).val('');
        $($("span[id*=partPopup] textarea[id*=desSearchText]")[0]).val('');
        
        $("table[id*='partListTable'] tbody tr").each(function () {
        	if($(this).children('td').length > 6){
        		var checkboxTd = $(this).children('td')[0];
        		var quantityTd = $(this).children('td')[6];
        		var ckbox = $(checkboxTd).find("input[type='checkbox']");
	            if(ckbox.length > 0 && $(ckbox[0]).attr("checked")) {
	                var temp = new Object();
	                temp.partId = $(ckbox[0]).next().val();
	                temp.quantity = $($(quantityTd).find("input[type='number']")[0]).val();
	                temp.partName = $(ckbox[0]).next().next().val();
	                addPartVirtualList.push(temp);
	            }
            }else if($(this).children('td').length > 5){
        		var checkboxTd = $(this).children('td')[0];
        		var quantityTd = $(this).children('td')[5];
        		var ckbox = $(checkboxTd).find("input[type='checkbox']");
	            if(ckbox.length > 0 && $(ckbox[0]).attr("checked")) {
	                var temp = new Object();
	                temp.partId = $(ckbox[0]).next().val();
	                temp.quantity = $($(quantityTd).find("input[type='number']")[0]).val();
	                temp.partName = $(ckbox[0]).next().next().val();
	                addPartVirtualList.push(temp);
	            }
            }
        });
        console.log('addPartVirtualList::',addPartVirtualList);
        showPopup();
    }
    
    function saveParts() {
    	//This method not in use.
    	//This method use static table cell number.
        showLoading();
        updateAllQuantity();
        var isFirstRow = false;
        var list_oppyPartItem = [];
        $("table[id*='myTable'] tbody tr").each(function() {
            //if(!isFirstRow) {
                var tdIndex = 0;
                var oppyPartItem = {oppyPart:{}};
                //console.log('tr::',$(this));
                $(this).find("td").each(function() {
                    oppyPartItem.oppyPart.Opportunity__c = oppyId;
                    //if(tdIndex == 0) {
                    //	if($(this).find("input.checkbox_delete_class").length > 0){
                    //		oppyPartItem.isDelete = $(this).find("input.checkbox_delete_class")[0].checked;
                    //	}
                    //}else if(tdIndex == 1) {
                    //if(tdIndex == 1) {
                    	
                    	//var seq_input = $(this).find("input").val();
                    	//if(seq_input  == null || seq_input == ''){
                    		//oppyPartItem.oppyPart.Seq_No__c = null;
                    	//}else{
                    		//oppyPartItem.oppyPart.Seq_No__c = Number(seq_input);
                    	//}
                    	
                    //}else if(tdIndex == 2) {
                    if(tdIndex == 1) {
                    	oppyPartItem.oppyPart.Status__c = $(this).find("select.selectStatus").val();
                        if(oppyPartItem.oppyPart.Status__c == null || oppyPartItem.oppyPart.Status__c == ''){
                        	oppyPartItem.oppyPart.Status__c = 'Pending';
                        }
                    } else if(tdIndex == 3) {
                        if($(this).find("input").val() != null && $(this).find("input").val() != "") {
                            oppyPartItem.oppyPart.Id = $(this).find("input[id*=oppyPart_Id]").val();
                        }
                        oppyPartItem.oppyPart.part__c = $(this).find("input[id*=part_Id]").val();
                        oppyPartItem.oppyPart.Part_number__c = $(this).find("input[id*=part_Name]").val();
                        oppyPartItem.oppyPart.Proposal_Part_Name_Override__c = $(this).find("input[id*=part_comments]").val();
                    } else if(tdIndex == 4) {
                        oppyPartItem.oppyPart.Quantity__c = $(this).find("input").val();
                        oppyPartItem.oppyPart.Code_for_unit_of_measurement__c = $(this).find("select").val();
                    } else if(tdIndex == 5) {
                        oppyPartItem.oppyPart.Standard_Cost__c = $(this).find("input").val();
                        if(oppyPartItem.oppyPart.Standard_Cost__c == null || oppyPartItem.oppyPart.Standard_Cost__c == ''){
                        	oppyPartItem.oppyPart.Standard_Cost__c = 0;
                        }
                    } else if(tdIndex == 6) {
                        if($(this).find("input[id*='sales_price']").val() != '$--') {
                            oppyPartItem.oppyPart.Sales_price__c = $(this).find("input[id*='sales_price']").val();
                        } 
                        //oppyPartItem.oppyPart.Standard_Cost__c = $(this).find("input[id*='cs75_cost']").val();
						//if($(this).find("input[id*='cs75_cost']").val() == null || $(this).find("input[id*='cs75_cost']").val() == ''){
							//oppyPartItem.oppyPart.Standard_Cost__c = 0;
						//}
                    } else if(tdIndex == 7) {
                        oppyPartItem.oppyPart.NDR_Item_Price_Per__c = $(this).find("select").val();
                    } else if(tdIndex == 8) {
                        oppyPartItem.oppyPart.Offered_Price__c = $(this).find("input").val();
                        if(oppyPartItem.oppyPart.Offered_Price__c == null || oppyPartItem.oppyPart.Offered_Price__c == ''){
                        	oppyPartItem.oppyPart.Offered_Price__c = 0;
                        }
                    } else if(tdIndex == 10) {
                        oppyPartItem.isThisCBC4 = $(this).find("input[type='radio'][name='radio_cbc4']").prop('checked');
                        oppyPartItem.str_CBC4Product = $(this).find("input[type='radio'][name='radio_cbc4']").prop('value');
                    } else if(tdIndex == 12) {
                        oppyPartItem.oppyPart.Energy_Quote_Line_Item__c = $(this).find("input").val();
                        //console.log('Energy_Quote_Line_Item__c::',$(this).find("input").val());
                    } else if(tdIndex == 13) {
                        oppyPartItem.oppyPart.Comments__c = $(this).find("input").val();
                        //console.log('Comments__c::',$(this).find("input").val());
                    }
                    tdIndex++;
                });
                //console.log('tdIndex::',tdIndex,'::',oppyPartItem);
                list_oppyPartItem.push(oppyPartItem);
            //}
            //isFirstRow = false;
        });
        console.log(JSON.stringify(list_oppyPartItem));
        saveOppyParts(JSON.stringify(list_oppyPartItem));
    }
    
    
    function savePartsWithRemoteAction() {
    	//This method use static table cell number.
    	var validator = checkAllValidator();
    	if(!validator){
    		return;
    	}
        showLoading();
        updateAllQuantity();
        var isFirstRow = false;
        var list_oppyPartItem = [];
        $("table[id*='myTable'] tbody tr").each(function() {
            //if(!isFirstRow) {
                var tdIndex = 0;
                var oppyPartItem = {oppyPart:{}};
                //console.log('tr::',$(this));
                $(this).find("td").each(function() {
                    oppyPartItem.oppyPart.Opportunity__c = oppyId;
                    //if(tdIndex == 0) {
                    //	if($(this).find("input.checkbox_delete_class").length > 0){
                    //		oppyPartItem.isDelete = $(this).find("input.checkbox_delete_class")[0].checked;
                    //	}
                    //}else if(tdIndex == 1) {
                    //if(tdIndex == 1) {
                    	//var seq_input = $(this).find("input").val();
                    	//if(seq_input  == null || seq_input == ''){
                    		//oppyPartItem.oppyPart.Seq_No__c = null;
                    	//}else{
                    		//oppyPartItem.oppyPart.Seq_No__c = Number(seq_input);
                    	//}
                    	
                    //}else if(tdIndex == 2) {
                    if(tdIndex == 1) {
                    	var initValue = $(this).find("input.initValue").val();
                    	var currentValue = $(this).find("select.selectStatus").val();
                    	
						//console.log('initValue::status:',initValue);
                    	//console.log('currentValue::status:',currentValue);
                        
                        if(initValue != currentValue){
                        	console.log('status::Not EQUAL');
                        	oppyPartItem.oppyPart.Status__c = currentValue;
                        }
                        
                    } else if(tdIndex == 3) {
                        if($(this).find("input").val() != null && $(this).find("input").val() != "") {
                            oppyPartItem.oppyPart.Id = $(this).find("input[id*=oppyPart_Id]").val();
                        }
                        oppyPartItem.oppyPart.part__c = $(this).find("input[id*=part_Id]").val();
                        oppyPartItem.oppyPart.Part_number__c = $(this).find("input[id*=part_Name]").val();
                        oppyPartItem.oppyPart.Proposal_Part_Name_Override__c = $(this).find("input[id*=part_comments]").val();
                    } else if(tdIndex == 4) {
                    	var initValue = $(this).find("input.initValueQty").val();
                    	var currentValue = $(this).find("input.qty").val();
                    	
						//console.log('initValue::Quantity:',initValue);
                    	//console.log('currentValue::Quantity:',currentValue);
                        
                        if(initValue != currentValue){
                        	oppyPartItem.oppyPart.Quantity__c = currentValue;
                        }
                        
                        var initValue1 = $(this).find("input.initValueUOM").val();
                    	var currentValue1 = $(this).find("select").val();
                    	
						console.log('initValue::UOM:',initValue1);
                    	console.log('currentValue::UOM:',currentValue1);
                        
                        if(initValue1 != currentValue1){
                        	oppyPartItem.oppyPart.Code_for_unit_of_measurement__c =  currentValue1;
                        }
                    
                        if(oppyPartItem.oppyPart.Id == null){
                        	oppyPartItem.oppyPart.Quantity__c = $(this).find("input").val();
                        	oppyPartItem.oppyPart.Code_for_unit_of_measurement__c = $(this).find("select").val();
                        }
                    } else if(tdIndex == 5) {
                    	var isAllowEditCost = $(this).find("input.initValueIsDummy").val();
                    	if(isAllowEditCost != null && isAllowEditCost =='true'){
                    	
	                    	var initValue = $(this).find("input.initValueDummy").val();
	                    	var currentValue = $(this).find("input.dummy").val();
	                    	currentValue = convertIntoNumber(currentValue);
	                    	
							//console.log('initValue::Cost:',initValue);
	                    	//console.log('currentValue::Cost:',currentValue);
	                        
	                        if(Number(initValue) != Number(currentValue)){
	                        	oppyPartItem.oppyPart.Standard_Cost__c = currentValue;
	                        }

                        }
                        if(oppyPartItem.oppyPart.Id == null){
                        	oppyPartItem.oppyPart.Standard_Cost__c = 0;
                        }
                    } else if(tdIndex == 6) {
                        //if($(this).find("input[id*='sales_price']").val() != '$--') {
                            //oppyPartItem.oppyPart.Sales_price__c = $(this).find("input[id*='sales_price']").val();
                        //} 
                        
                    } else if(tdIndex == 7) {
                		var initValue = $(this).find("input.initValuePer").val();
                    	var currentValue = $(this).find("select").val();
                    	
						//console.log('initValue::Per:',initValue);
                    	//console.log('currentValue::Per:',currentValue);
                        
                        if(initValue != currentValue){
                        	oppyPartItem.oppyPart.NDR_Item_Price_Per__c = currentValue;
                        }
                        
						if(oppyPartItem.oppyPart.Id == null){
							oppyPartItem.oppyPart.NDR_Item_Price_Per__c = $(this).find("select").val();
                        }
                    } else if(tdIndex == 8) {
                    	var initValue = $(this).find("input.initValuePrice").val();
                    	var currentValue = $(this).find("input.targetPrice").val();
                    	currentValue = convertIntoNumber(currentValue);
                    	
						console.log('initValue::Price:',initValue);
                    	console.log('currentValue::Price:',currentValue);
                        
                        if(Number(initValue) != Number(currentValue)){
                        	oppyPartItem.oppyPart.Offered_Price__c = currentValue;
                        }
                        if(oppyPartItem.oppyPart.Id == null){
							oppyPartItem.oppyPart.Offered_Price__c = 0;
                        }
                    } else if(tdIndex == 10) {
                    	var isCBC4Checked = $(this).find("input[type='radio'][name='radio_cbc4']").prop('checked');
                    	if(isCBC4Checked){
	                        oppyPartItem.isThisCBC4 = isCBC4Checked;
	                        oppyPartItem.str_CBC4Product = $(this).find("input[type='radio'][name='radio_cbc4']").prop('value');
                        }
                    } else if(tdIndex == 12) {
                        oppyPartItem.oppyPart.Energy_Quote_Line_Item__c = $(this).find("input").val();
                        //console.log('Energy_Quote_Line_Item__c::',$(this).find("input").val());
                    } else if(tdIndex == 13) {
                    	var initValue = $(this).find("input.initValueComment").val();
                    	var currentValue = $(this).find("input.incomments").val();
                    	
						//console.log('initValue::Comment:',initValue);
                    	//console.log('currentValue::Comment:',currentValue);
                        
                        if(initValue != currentValue){
                        	oppyPartItem.oppyPart.Comments__c = currentValue;
                        }
						if(oppyPartItem.oppyPart.Id == null){
							oppyPartItem.oppyPart.Comments__c = '';
                        }
                    }
                    tdIndex++;
                });
                //console.log('tdIndex::',tdIndex,'::',oppyPartItem);
                if(!(oppyPartItem.oppyPart.Status__c == null && 
                	oppyPartItem.oppyPart.Quantity__c == null && 
                	oppyPartItem.oppyPart.Code_for_unit_of_measurement__c == null && 
                	oppyPartItem.oppyPart.Standard_Cost__c == null && 
                	oppyPartItem.oppyPart.NDR_Item_Price_Per__c == null && 
                	oppyPartItem.isThisCBC4 == null && 
                	oppyPartItem.oppyPart.Comments__c == null && 
                	oppyPartItem.oppyPart.Offered_Price__c == null)){
                	list_oppyPartItem.push(oppyPartItem);
                }
            //}
            //isFirstRow = false;
        });
        
        console.log("list_partItems:::total",list_oppyPartItem);

	    if(list_oppyPartItem.length > saveDataLimit){
	    	var temp_partItems = [];
	    	for(var i=0;i<saveDataLimit;i++) {
	    		temp_partItems.push(list_oppyPartItem[i]);
	    	}
	    	var left_partItems = [];
	    	for(var i=saveDataLimit;i<list_oppyPartItem.length;i++) {
	    		left_partItems.push(list_oppyPartItem[i]);
	    	}
	    	remoteActionSave(oppyId,temp_partItems,left_partItems);
	    }else{
	    	remoteActionSave(oppyId,list_oppyPartItem,new Array());
	    }
    }
    
    function deleteOppPart() {
    	//This method use static table cell number.
    	showLoading();
    	var delOppyPartIds = [];
    	$("table[id*='myTable'] tbody tr").each(function() {
    		if($(this).find("input.checkbox_delete_class").length > 0 && $(this).find("input.checkbox_delete_class")[0].checked) {
    			var tdIndex = 0;
    			$(this).find("td").each(function() {
    				if(tdIndex == 2) {
                		delOppyPartIds.push($(this).attr('dir'));
                	}
                	tdIndex++;
    			});
    		}
        });
        deleteOppyParts(JSON.stringify(delOppyPartIds));
    }
    
    function showUploadPop() {
    	showLoading();
    	showUploadPopup();
    }
    
    function showPopup() {
        showLoading();
        showAddPopup();
    }
    
    function checkIfNeedSecoundSearch(){
    	//Added by Buwen Guo 2018-05-09
    	$('button.searchMoreButton').show();
    	$('button.searchButton_class').hide();
    	return ;
    	var searchResult = $("input.input_isSearchNoResult_class").val();
    	//console.log('checkIfNeedSecoundSearch::',searchResult);
    	if(searchResult == 'true'){
			var comfirmbox = confirm("This part doesn't exist.  Would you like to search for other parts that contain the search string?");
			if(comfirmbox){
				showLoading();
	        	getParts2();
			}else{
				hideLoading();
			}
		}else{
			var comfirmbox = confirm("We found an exact match for the String. Would you like to search for other parts that contain the search string?");
			if(comfirmbox){
				showLoading();
	        	getParts2();
			}else{
				hideLoading();
			}
		}
    }
    
    function afterSearch2(){
    	$('button.searchMoreButton').show();
    	$('button.searchButton_class').hide();
    }
    
    function afterSearchTextChange(){
    	console.log('!!!!!!');
    	//Added by Buwen Guo 2018-05-09
    	$('button.searchMoreButton').hide();
    	$('button.searchButton_class').show();
    }
    
    function IsCheckedNeededValidator(){
    	var temp_flag = $("#input_hidden_isSearchSetByComma").val();
    	var isOnlyOneLine = $('table[id*="partListTable"] tbody tr');
    	if(isOnlyOneLine != null && isOnlyOneLine.length == 1){
    		isOnlyOneLine = true;
    	}else{
    		isOnlyOneLine = false;
    	}
    	if(temp_flag == 'true' || isOnlyOneLine){
	    	$("table[id*='partListTable'] input[type='checkbox']").each(function () {
	    		$(this).prop('checked','checked');
	    	});
    	}
    }
    
    function bindEnterClick() {
	    $("textarea[id*='SearchText']").bind('input propertychange', function() {  
			afterSearchTextChange();
		});
        $("textarea[id*='SearchText']").keypress(function(e) {
            console.log('enter::::  ', e.keyCode);
            if(e.keyCode == 13) {
            	showLoading();
        		getParts();
        		return false;
            }
        });
    }
    
    function clearSearch() {
    	$($("span[id*=partPopup] textarea[id*=inputSearchText]")[0]).val('');
        $($("span[id*=partPopup] textarea[id*=desSearchText]")[0]).val('');
        $('#div_displayPartSearchError').hide();
        $('#div_displayPartSearchNoResult').hide();
    }
    
    function cancelPopup() {
    	showLoading();
    	addPartVirtualList = new Array();
        $($("span[id*=partPopup] textarea[id*=inputSearchText]")[0]).val('');
        $($("span[id*=partPopup] textarea[id*=desSearchText]")[0]).val('');
        add_closePopup();
    }
    
    function closeUploadPop() {
    	showLoading();
        closeUploadPopup();
    }
    
    function getPartList() {
        showLoading();
        getParts();
    }
    
    function selectAll() {
        $("table[id*='partListTable'] input[type='checkbox']").each(function () {
            $(this).attr("checked", "checked");
        });
    }
    
    function clearAll() {
        $("table[id*='partListTable'] input[type='checkbox']").each(function () {
            $(this).removeAttr("checked");
        });
    }
    
    function showLoading(){
        $("#Loading_Panel").show();
    }
    
    function hideLoading(){
        $("#Loading_Panel").hide();
    }
    function openEditMode(){
    	//This method use static table cell number.
    	//This method define all the number of tds and the edit mode td width.
		if(isDisplayEditAndAddButton){
			$("#btn_Save").show();
		}		
		$("#btn_Cancel").show();
		$("#btn_Edit").hide();
		$("#delBtn").hide();
		$($("table.fixme tr.headerRow th")[0]).hide();
		$("table.fixme tr.dataRow").each(function(){
			$($(this).children("td")[0]).hide();
		});
		
		var int_editModeColumnNum = 14;            
		var array_editModeCustomWidth = new Array('8%','9%','15%','6%','5%','9%','6%','8%','6%','8%','6%','6%','8%','0%');
		$("table.fixme colgroup col").each(function(i){
			//Because last col width is 0%,IE can't use 0%,so we change int_editModeColumnNum to int_editModeColumnNum -1
			if(i < int_editModeColumnNum-1){
				$(this).prop('width',array_editModeCustomWidth[i]);
			}
		});
		alignTheFixedHeader();
	}
	function openViewMode(){
		if(isDisplayEditAndAddButton){
			$("#btn_Edit").show();			
		}
		$("#btn_Save,#btn_Cancel").hide();
	}
	
    function reloadPage2() {
        //window.location.reload(true);
        //initPage();
        var isError = $("#input_hidden_ishasError").val();
        if(isError == 'true'){
        	return false;
        }
        //console.log('url::',top.document.location.href);
        window.location.href='/apex/ExtOppyPartDiscounting?id='+str_oppyId;
        //parent.location.reload(true);
    }
    
    function delOppyPart(thisObj) {
        if(confirm("Are you sure to delete this row?")) {
            showLoading();
            deleteOppyPart($(thisObj).next().val());
        }
    }
    
    var csvFile;
    //var oppyFiledMap ={OppIdPartNumber:"OppIdPartNumber__c",Opportunity Id:"Opportunity__c",Quality:"Quality__c",Sales Price:"Sales_Price__c"};
    var arr_allDataFromCSV;
    var arr_fieldNameInCSV;
    
    
    function getFileContents(files) {
        showLoading();
        temp_files = files.files;
        if(temp_files.length > 0) {
            csvFile = temp_files[0];
            //console.log('current file::',csvFile);
        }else{
        	hideLoading();
        	return ;
        }
        if(csvFile != null && csvFile.name.indexOf(".csv") != -1) {
            $(files).csv2arr(function(arr){
                arr_allDataFromCSV = arr;
                if(arr_allDataFromCSV != null && arr_allDataFromCSV.length >0){
                    arr_fieldNameInCSV = arr_allDataFromCSV[0];
                }
                console.log(arr_fieldNameInCSV);
                console.log(arr_allDataFromCSV);
                hideLoading();
            });
        } else if(csvFile != null && csvFile.name.indexOf(".xlsx") != -1){
            var e = getEvent();
			var xlsfiles = e.target.files;  
		    var output = "";  
		    var f = xlsfiles[0];  
		    
		    {  
		        var reader = new FileReader();  
		        var name = f.name;  
		        reader.onload = function (e) {  
		  
		            var data = e.target.result;  
		      
		            var arr = fixdata(data);  
		            var wb;
		            //if(rABS) {
                        wb = XX.read(btoa(fixdata(data)), {
                            type: 'base64'
                        });
                    //} else {
                      //  wb = XX.read(data, {
                        //    type: 'binary'
                       // });
                   // }
		  
		            output = JSON.stringify( XX.utils.sheet_to_json(wb.Sheets[wb.SheetNames[0]]) );
		  			console.log('xlsx::',output);
		            ReadExcelX(output);  
		        };  
		  
		        if(rABS) {
                    reader.readAsArrayBuffer(f);
                } else {
                	reader.readAsArrayBuffer(f);
                    //reader.readAsBinaryString(f);
                }
		    }
		    hideLoading();
        } else if(csvFile != null && csvFile.name.indexOf(".xls") != -1){
            var e = getEvent();
			var xlsfiles = e.target.files;  
		    var output = "";  
		    var f = xlsfiles[0];  
		    {  
		        var reader = new FileReader();  
		        var name = f.name;  
		        reader.onload = function (e) {  
		  
		            var data = e.target.result;  
		      
		            var arr = fixdata(data);  
		            var wb = X.read(btoa(arr), { type: 'base64' });  
		  
		            output = process_wb(wb, "json");  
		  			console.log('xls::',output);
		            ReadExcel(output);  
		        };  
		  
		        reader.readAsArrayBuffer(f);  
		    }
		    hideLoading();
        }else{
        	hideLoading();
        }
        
    }
    
    function uploadCsvOppyPart() {
        showLoading();
        if(csvFile == null) {
            alert("Please select a file!");
            hideLoading();
        } else if(csvFile.name.indexOf(".csv") == -1 && csvFile.name.indexOf(".xls") == -1) {
            alert("Please select a file!");
            hideLoading();
        } else if(arr_allDataFromCSV.length < 1){
            alert("No data in this csv file");
            hideLoading();
        } else {
            var list_partItems = [];
            
            if(arrayContains(arr_fieldNameInCSV,'Part Number') || arrayContains(arr_fieldNameInCSV,'Part #')){
            	//the csv has header
            	
	            for(var i=1;i<arr_allDataFromCSV.length;i++) {
	                var partItem = {oppyPart:{Opportunity__c:oppyId}};
	                var csvDataItem = arr_allDataFromCSV[i];
	                for(var j=0;j<csvDataItem.length;j++) {
	                    if(arr_fieldNameInCSV[j] == 'Part Number' || arr_fieldNameInCSV[j].toLowerCase() == 'part number' ||arr_fieldNameInCSV[j] == 'Part #' || arr_fieldNameInCSV[j].toLowerCase() == 'part #') {
	                        partItem.str_partName = csvDataItem[j];
	                    } else if(arr_fieldNameInCSV[j] == 'Quantity' || arr_fieldNameInCSV[j].toLowerCase() == 'quantity') {
	                        partItem.oppyPart.Quantity__c = csvDataItem[j];
	                    } else if(arr_fieldNameInCSV[j] == 'Target Price' || arr_fieldNameInCSV[j].toLowerCase() == 'target price' ||arr_fieldNameInCSV[j] == 'Requested Price' || arr_fieldNameInCSV[j].toLowerCase() == 'requested price') {
	                        partItem.oppyPart.Offered_Price__c = escapeThousandDecimalForEurope(csvDataItem[j]);
	                    } else if(arr_fieldNameInCSV[j] == 'Competitor Name' || arr_fieldNameInCSV[j].toLowerCase() == 'competitor name' ) {
	                        partItem.oppyPart.NDR_Competitor_Name__c = csvDataItem[j];
	                    } else if(arr_fieldNameInCSV[j] == 'Competitor Part Number' || arr_fieldNameInCSV[j].toLowerCase() == 'competitor part number' ) {
	                        partItem.oppyPart.NDR_Competitor_Part_Number__c = csvDataItem[j];
	                    } else if(arr_fieldNameInCSV[j] == 'Competitor Price' || arr_fieldNameInCSV[j].toLowerCase() == 'competitor price' ) {
	                        partItem.oppyPart.Competitor_Price__c = escapeThousandDecimalForEurope(csvDataItem[j]);
	                    }
	                }
	                list_partItems.push(partItem);
	            }
	            
            }else{
            	//the csv has no header
            	
            	for(var i=0;i<arr_allDataFromCSV.length;i++) {
	                var partItem = {oppyPart:{Opportunity__c:oppyId}};
	                var csvDataItem = arr_allDataFromCSV[i];
	                
	                for(var j=0;j<csvDataItem.length;j++) {
	                    if(j == 0) {
	                        partItem.str_partName = csvDataItem[j];
	                    } else if(j == 1) {
	                        partItem.oppyPart.Quantity__c = csvDataItem[j];
	                    } else if(j == 2) {
	                        partItem.oppyPart.Offered_Price__c = escapeThousandDecimalForEurope(csvDataItem[j]);
	                    } else if(j == 3) {
	                        partItem.oppyPart.NDR_Competitor_Name__c = csvDataItem[j];
	                    } else if(j == 4) {
	                        partItem.oppyPart.NDR_Competitor_Part_Number__c = csvDataItem[j];
	                    } else if(j == 5) {
	                        partItem.oppyPart.Competitor_Price__c = escapeThousandDecimalForEurope(csvDataItem[j]);
	                    }
	                }
	                
	                list_partItems.push(partItem);
	            }
	            
            }
            
            console.log('currmaxSeqNumber::',maxSeqNumber);
            
            if(isNaN(parseFloat(maxSeqNumber))){
        		maxSeqNumber = 0;
        	}else{
        		maxSeqNumber = parseFloat(maxSeqNumber);
        	}
        	
            for(var j=0;j<list_partItems.length;j++){
            	
            	//list_partItems[j].oppyPart.Seq_No__c = maxSeqNumber + j + 1;
            }

            console.log("list_partItems::: ", JSON.stringify(list_partItems));
            $("input[id*='hidden_param_oppIdPartNumberJson']").val(JSON.stringify(list_partItems));
            uploadCsvFile();
        }
    }
    
    
    function uploadCsvOppyPartWithRemoteAction() {
        showLoading();
        if(csvFile == null) {
            alert("Please select a file!");
            hideLoading();
        } else if(csvFile.name.indexOf(".csv") == -1 && csvFile.name.indexOf(".xls") == -1) {
            alert("Please select a file!");
            hideLoading();
        } else if(arr_allDataFromCSV.length < 1){
            alert("No data in this csv file");
            hideLoading();
        } else {
            action_deleteAllParts();
        }
    }
    
    function uploadCsvOppyPartWithRemoteAction2(){
    	showLoading();
    	var list_partItems = [];
            
        if(arrayContains(arr_fieldNameInCSV,'Part Number') || arrayContains(arr_fieldNameInCSV,'Part #')){
        	//the csv has header
        	
            for(var i=1;i<arr_allDataFromCSV.length;i++) {
                var partItem = {oppyPart:{Opportunity__c:oppyId}};
                var csvDataItem = arr_allDataFromCSV[i];
                for(var j=0;j<csvDataItem.length;j++) {
                    if(arr_fieldNameInCSV[j] == 'Part Number' || arr_fieldNameInCSV[j].toLowerCase() == 'part number' ||arr_fieldNameInCSV[j] == 'Part #' || arr_fieldNameInCSV[j].toLowerCase() == 'part #' || (trimForNumber(arr_fieldNameInCSV[j]) != null && trimForNumber(arr_fieldNameInCSV[j]).toLowerCase() == 'part number')) {
                        partItem.str_partName = csvDataItem[j];
                    } else if(arr_fieldNameInCSV[j] == 'Quantity' || arr_fieldNameInCSV[j].toLowerCase() == 'quantity' || (trimForNumber(arr_fieldNameInCSV[j]) != null && trimForNumber(arr_fieldNameInCSV[j]).toLowerCase() == 'quantity')) {
                        partItem.oppyPart.Quantity__c = csvDataItem[j];
                    } else if(arr_fieldNameInCSV[j] == 'Target Price' || arr_fieldNameInCSV[j].toLowerCase() == 'target price' ||arr_fieldNameInCSV[j] == 'Requested Price' || arr_fieldNameInCSV[j].toLowerCase() == 'requested price'  || (trimForNumber(arr_fieldNameInCSV[j]) != null && trimForNumber(arr_fieldNameInCSV[j]).toLowerCase() == 'target price')  || (trimForNumber(arr_fieldNameInCSV[j]) != null && trimForNumber(arr_fieldNameInCSV[j]).toLowerCase() == 'target price')) {
                        partItem.oppyPart.Offered_Price__c = escapeThousandDecimalForEurope(csvDataItem[j]);
                    } else if(arr_fieldNameInCSV[j] == 'Competitor Name' || arr_fieldNameInCSV[j].toLowerCase() == 'competitor name' || (trimForNumber(arr_fieldNameInCSV[j]) != null && trimForNumber(arr_fieldNameInCSV[j]).toLowerCase() == 'competitor name')) {
                        partItem.oppyPart.NDR_Competitor_Name__c = csvDataItem[j];
                    } else if(arr_fieldNameInCSV[j] == 'Competitor Part Number' || arr_fieldNameInCSV[j].toLowerCase() == 'competitor part number' || (trimForNumber(arr_fieldNameInCSV[j]) != null && trimForNumber(arr_fieldNameInCSV[j]).toLowerCase() == 'competitor part number') ) {
                        partItem.oppyPart.NDR_Competitor_Part_Number__c = csvDataItem[j];
                    } else if(arr_fieldNameInCSV[j] == 'Competitor Price' || arr_fieldNameInCSV[j].toLowerCase() == 'competitor price' || (trimForNumber(arr_fieldNameInCSV[j]) != null && trimForNumber(arr_fieldNameInCSV[j]).toLowerCase() == 'competitor price') ) {
                        partItem.oppyPart.Competitor_Price__c = escapeThousandDecimalForEurope(csvDataItem[j]);
                    }
                }
                if(partItem.str_partName != null && partItem.str_partName != ''){
                	list_partItems.push(partItem);
                }
            }
            
        }else{
        	//the csv has no header
        	
        	for(var i=0;i<arr_allDataFromCSV.length;i++) {
                var partItem = {oppyPart:{Opportunity__c:oppyId}};
                var csvDataItem = arr_allDataFromCSV[i];
                
                for(var j=0;j<csvDataItem.length;j++) {
                    if(j == 0) {
                        partItem.str_partName = csvDataItem[j];
                    } else if(j == 1) {
                        partItem.oppyPart.Quantity__c = csvDataItem[j];
                    } else if(j == 2) {
                        partItem.oppyPart.Offered_Price__c = escapeThousandDecimalForEurope(csvDataItem[j]);
                    } else if(j == 3) {
                        partItem.oppyPart.NDR_Competitor_Name__c = csvDataItem[j];
                    } else if(j == 4) {
                        partItem.oppyPart.NDR_Competitor_Part_Number__c = csvDataItem[j];
                    } else if(j == 5) {
                        partItem.oppyPart.Competitor_Price__c = escapeThousandDecimalForEurope(csvDataItem[j]);
                    }
                }
                if(partItem.str_partName != null && partItem.str_partName != ''){
                	list_partItems.push(partItem);
                }
            }
            
        }
        
		console.log("list_partItems:::total",list_partItems);
        console.log("list_partItems:::totalSize",list_partItems.length);

        if(list_partItems.length > saveDataLimit){
        	var temp_partItems = [];
        	for(var i=0;i<saveDataLimit;i++) {
        		temp_partItems.push(list_partItems[i]);
        	}
        	var left_partItems = [];
        	for(var i=saveDataLimit;i<list_partItems.length;i++) {
        		left_partItems.push(list_partItems[i]);
        	}
        	remoteActionUpload(oppyId,temp_partItems,left_partItems,true);
        }else{
        	remoteActionUpload(oppyId,list_partItems,new Array(),true);
        }
    }
    
    function arrayContains(arr_data,str_data){
    	var str_result = false;
    	if(arr_data == null || arr_data.length < 1){
    		return false;
    	}
    	for(var i=0;i<arr_data.length;i++) {
    		if(arr_data[i].toLowerCase() == str_data.toLowerCase()){
    			str_result = true;
    		}
    	}
    	return str_result;
    }
    
    function insteadComma(dec){
    	//console.log('suorceDec::'+dec);
    	if(dec == null){
    		return 0;
    	}
    	if(thousandSep == null || thousandSep == '' || decimalSep == null || decimalSep == ''){
    		return dec;
    	}else{
			if(dec.indexOf(thousandSep) > -1){
				if(thousandSep == ','){
					dec = dec.replace(new RegExp(thousandSep, 'g'), '');
				}
				if(thousandSep == '.'){
					dec = dec.replace(/\./g, '');
				}
			}
			//console.log('thDec::'+dec);
			if(dec.indexOf(decimalSep) > -1 && decimalSep != '.'){
				dec = dec.replace(new RegExp(decimalSep, 'g'), '.');
			}
			//console.log('deDec::'+dec);
			return dec;
		}
    }
    
    function clickDownload(a) { 
    	var aLink = document.createElement('a');
    	if(isIE()) {
    		if(getTblData()!=false) {
	        	if (window.navigator.msSaveOrOpenBlob) {  
		            var tabledata =getTblData();
			    	if(tabledata != false){
				    	var blob = new Blob([tabledata], { type: "text/csv" });
				    	navigator.msSaveBlob(blob, "Opportunity Parts.csv");  
				    }
		        }
	        }
    	} else {
    		if(getTblData()!=false) {
		    	var blob = new Blob([getTblData()], { type: "text/csv" });
			    var evt = document.createEvent("HTMLEvents");
			    evt.initEvent("click", false, false);
			    aLink.download = "Opportunity Parts.csv";
			    aLink.href = URL.createObjectURL(blob);
	        	$("#div_linkSection_forchrome").html('');
			    $("#div_linkSection_forchrome").append(aLink);
			    $("#div_linkSection_forchrome").find('a')[0].click();
	        }
    	}
        //aLink.href = "data:text/csv;charset=utf-8,"+encodeURIComponent(getTblData());
    }  
    
    function isIE() {
		if(!!window.ActiveXObject || "ActiveXObject" in window) return true;
		else return false;
	}
    
    function getTblData() {
    	//This method use static table cell number.
        //var list_oppyPartItems = JSON.parse('{!str_oppyPartJson}');
        //console.log(list_oppyPartItems);
        
        //var outStr = "Id,Name,PartName,Quantity__c,Sales_Price__c,Offered_Price__c,Total Unit Sales Price,CurrencyIsoCode,ADM_Product_CBC4_Description__c\n";
        //var outStr = "Part Number,Quantity,Target Price,Target Total,Sales Price,Total Unit Sales Price,CurrencyIsoCode,ADM Product CBC4_Description\n";
        var outStr = "Part Number,Quantity,Target Price,Competitor Name,Competitor Part Number,Competitor Price,Target Total,Customer Price,CBC4 Description,Internal Comments,CurrencyIsoCode,Part Name,Cost,Line GM %\n";
        
        var list_oppPartItemsForExport = new Array();
        
        $("table[id*='myTable'] tbody tr").each(function() {
			var tdIndex = 0;
            var oppyPartItem = new Object();
            //console.log('tr::',$(this));
			$(this).find("td").each(function() {
				if(tdIndex == 0) {
					oppyPartItem.partNumber = $(this).attr("dir");
					if($(this).attr("dir") == null || $(this).attr("dir") == ''){
						oppyPartItem.partNumber = '';
					}
				}else if(tdIndex == 3){
					oppyPartItem.exportName = $(this).find("input[id*='export_Name']").val();
					if($(this).find("input[id*='export_Name']").val() == null || $(this).find("input[id*='export_Name']").val() == ''){
						oppyPartItem.exportName = '';
					}
					oppyPartItem.exportName = trimForNumber(oppyPartItem.exportName);
					
					oppyPartItem.marginCS75 = $(this).find("input[id*='part_MarginCS75']").val();
					if($(this).find("input[id*='part_MarginCS75']").val() == null || $(this).find("input[id*='part_MarginCS75']").val() == ''){
						oppyPartItem.marginCS75 = '';
					}
					oppyPartItem.marginCS75 = trimForNumber(oppyPartItem.marginCS75);
				}else if(tdIndex == 4){
					oppyPartItem.quantity = $(this).find("input.qty").val();
					if($(this).find("input.qty").val() == null || $(this).find("input.qty").val() == ''){
						oppyPartItem.quantity = 0;
					}
					oppyPartItem.quantity = parseInt(oppyPartItem.quantity);
				}else if(tdIndex == 5){
					oppyPartItem.cost = $(this).find("input.initValueDummy").val();
					if($(this).find("input.initValueDummy").val() == null || $(this).find("input.initValueDummy").val() == ''){
						oppyPartItem.cost = 0;
					}
					oppyPartItem.cost = toDecimal2(oppyPartItem.cost);
				}else if(tdIndex == 6){
					oppyPartItem.salesPrice = $(this).find("input[id*='sales_price']").val();
					if($(this).find("input[id*='sales_price']").val() == null || $(this).find("input[id*='sales_price']").val() == ''){
						oppyPartItem.salesPrice = 0;
					}
					oppyPartItem.salesPrice = toDecimal2(oppyPartItem.salesPrice);
					
					oppyPartItem.competitorName = $(this).find("input[id*='competitor_name']").val();
					if($(this).find("input[id*='competitor_name']").val() == null || $(this).find("input[id*='competitor_name']").val() == ''){
						oppyPartItem.competitorName = '';
					}
					
					oppyPartItem.competitorPartNumber = $(this).find("input[id*='competitor_partNumber']").val();
					if($(this).find("input[id*='competitor_partNumber']").val() == null || $(this).find("input[id*='competitor_partNumber']").val() == ''){
						oppyPartItem.competitorPartNumber = '';
					}
					
					oppyPartItem.competitorPrice = $(this).find("input[id*='competitor_price']").val();
					if($(this).find("input[id*='competitor_price']").val() == null || $(this).find("input[id*='competitor_price']").val() == ''){
						oppyPartItem.competitorPrice = 0;
					}
					oppyPartItem.competitorPrice = toDecimal2(oppyPartItem.competitorPrice);
				}else if(tdIndex == 8){
					oppyPartItem.offeredPrice = $(this).find("input.targetPrice").val();
					if($(this).find("input.targetPrice").val() == null || $(this).find("input.targetPrice").val() == ''){
						oppyPartItem.offeredPrice = 0;
					}
					console.log('ssss::',oppyPartItem.offeredPrice);
					oppyPartItem.offeredPrice = toDecimal2(convertIntoNumber(String(oppyPartItem.offeredPrice)));
				} else if(tdIndex == 9) {
					oppyPartItem.targetTotal = toDecimal2($(this).find("input.initValueTotal").val());
				} else if(tdIndex == 10){
					oppyPartItem.cbc4description = $(this).attr("dir");
				} else if(tdIndex == 13){
					oppyPartItem.internalComments = $(this).find("input.incomments").val();
					if($(this).find("input.incomments").val() == null || $(this).find("input.incomments").val() == ''){
						oppyPartItem.internalComments = '';
					}
				}
				tdIndex++;
			});
			list_oppPartItemsForExport.push(oppyPartItem);
        });
        
        for(var i=0; i<list_oppPartItemsForExport.length; i++) {
            var item = list_oppPartItemsForExport[i];
            var totalPrice = '';
            if(item.salesPrice != null && item.quantity != null) {
                totalPrice = item.salesPrice * item.quantity;
            }
            outStr += item.partNumber +"," +
            		(item.quantity ==null ? '' : item.quantity )+ "," +
                    (item.offeredPrice == null ? '': item.offeredPrice ) + "," +
                    
                    (item.competitorName == null ? '': item.competitorName ) + "," +
                    (item.competitorPartNumber == null ? '': item.competitorPartNumber ) + "," +
                    (item.competitorPrice == null ? '': item.competitorPrice ) + "," +
                    
                    (item.targetTotal == null ? '': item.targetTotal ) + "," +
                    (item.salesPrice == null ? '' : item.salesPrice ) + "," +
                    //totalPrice + "," + oppyCurrency + "," + 
                    (item.cbc4description == null ? '' : item.cbc4description) + "," +
                    (item.internalComments == null ? '' : item.internalComments)  + "," +
                    (oppyCurrency == null ? '' : oppyCurrency)  + "," +
                    (item.exportName == null ? '' : item.exportName)  + "," +
                    (item.cost == null ? '' : item.cost)  + "," +
                    (item.marginCS75 == null ? '' : item.marginCS75);
            
            if(i<list_oppPartItemsForExport.length-1) {
                outStr += "\n";
            }
        }
        //console.log(outStr);
        if(outStr == "") {
            outStr = null;
            alert("No data!");
            return false;
        }
        return outStr;
    }
    //Export function script section end
    
    function editParts() {
    	$(".inputData_class").removeClass("slds-hide");
    	$(".outputData_class").addClass("slds-hide");
    	$(".target_inputData_class").next().addClass("slds-hide");
    	$(".link_pastQuotes_class").addClass("slds-hide");
    }
    
    function displayQuoteLineItem(obj){
    	var linkElement = $(obj);
    	$('#div_pastQuotesWindow').show();
    }
    
    function delayHideQuoteLineItem(obj){
    	return false;
    	var linkElement = $(obj);
    	
    	var t = setTimeout("hideQuoteLineItem();",5000);
    }
    
    function hideQuoteLineItem(){
		$("#div_pastQuotesWindow").css("display","none");  
    }
	
	var lastNo = '';
        
    function copyTargetPrice(price,lineNo,currencyFromCode){
    	showLoading();
    	currencyFromCode = trimForNumber(currencyFromCode);
    	$("input[id*='hidden_param_currencyFromValue']").val(price);
    	$("input[id*='hidden_param_currencyFromCode']").val(currencyFromCode);
    	$("input[id*='hidden_param_currencyToCode']").val(oppyCurrency);
    	console.log(price,currencyFromCode,oppyCurrency);
    	lastNo = lineNo;
    	action_transformCurrency();
    }

    function getCurrencyCallback(){
    	//editParts();
    	var price = $("input[id*='hidden_param_currencyToValue']").val();
    	price = toDecimal2(price);
    	console.log('getCurrencyCallback::',price);
    	price = convertIntoComma(Number(price));
    	$("input.target_inputData_class[data-line='"+lastNo+"']").val(price);
    	$("span.targetPriceOutputText_class[data-line='"+lastNo+"']").text(price);
    	lastNo = '';
    	hideQuoteLineItem();
    	savePartsWithRemoteAction();
    	//hideLoading();
    }
    
    function copyRFOlink(lineNo,quoteId,quoteNum,qliId){
    	//console.log('aaa:',$("input.input_rfq_class[data-line='"+lineNo+"']"),qliId);
    	$("input.input_rfq_class[data-line='"+lineNo+"']").val(qliId);
    	$("input.input_rfq_class[data-line='"+lineNo+"']").attr("value",qliId);
    	$("span.span_rfq_quotenumber_edit_class[data-line='"+lineNo+"']").empty();
    	$("span.span_rfq_quotenumber_edit_class[data-line='"+lineNo+"']").append('<a href="/'+quoteId+'" target="_blank" class="link_rfq_class" >'+quoteNum+'</a>');
    	$("span.span_rfq_quotenumber_edit_class[data-line='"+lineNo+"']").show();
    	$("span.span_rfq_quotenumber_default_class[data-line='"+lineNo+"']").hide();
    }
    function setDefaultRadioChecked(){
    	$("input[type='radio'][name='radio_cbc4']").each(function(){
    		var currElement = $(this);
    		if(currElement.attr('data-oppycbc4') == currElement.prop('value')){
    			currElement.prop('checked','checked');		
    		}else{
    			currElement.removeAttr('checked');			
    		}
    	});
		$("input[type='radio'][name='radio_cbc4']").each(function(){
    		var currElement = $(this);
    		if(currElement.attr('checked')){
				currElement.parent().find(".ridioLabel").css('font-weight','bold');
    		}else{
				currElement.parent().find(".ridioLabel").css('font-weight','normal');			
			}
    	});
    }
    function populateOffsetPercent(){
    	$("span.span_offsetPercent_class").each(function(){
    		var currElement = $(this);
    		var dec_targetPrice = $(this).attr('data-targetprice');
    		var dec_bookPrice = $(this).attr('data-bookprice');
    		if(dec_targetPrice == '' || dec_targetPrice == null){
				dec_targetPrice = 0;
			}
			if(dec_bookPrice == '' || dec_bookPrice == null){
				dec_bookPrice = 0;
			}
    		dec_targetPrice = parseFloat(dec_targetPrice);
    		dec_bookPrice = parseFloat(dec_bookPrice);
    		if(dec_targetPrice == 0 || dec_bookPrice == 0){
    			//var str_temp = '0%';
    			var str_temp = '';
    		}else{
    			var str_temp = '('+ toDecimal2(((dec_targetPrice - dec_bookPrice)/dec_bookPrice)*100) + '%)';
    		}
    		currElement.text(str_temp);
    		var str_color = '';
    		if(dec_targetPrice >= dec_bookPrice){
    			str_color = 'green';
    		}else{
    			str_color = 'red';
    		}
    		currElement.css('color',str_color);
    	});
    }
    function populateOffsetPercentOnBlur(element){
    	var currElement = $(element);
    	var itemNum = currElement.attr('data-line');
    	var spans = $("span.span_offsetPercent_class[data-line='"+itemNum+"']");
    	if(spans.length > 0){
    		var span = $(spans[0]);
    		var dec_targetPrice = convertIntoNumber(currElement.val());
			var dec_bookPrice = span.attr('data-bookprice');
			if(dec_targetPrice == '' || dec_targetPrice == null){
				dec_targetPrice = 0;
			}
			if(dec_bookPrice == '' || dec_bookPrice == null){
				dec_bookPrice = 0;
			}
			dec_targetPrice = parseFloat(dec_targetPrice);
			dec_bookPrice = parseFloat(dec_bookPrice);
			if(dec_targetPrice == 0 || dec_bookPrice == 0){
				//var str_temp = '0%';
				var str_temp = '';
			}else{
				var str_temp = '('+ toDecimal2(((dec_targetPrice - dec_bookPrice)/dec_bookPrice)*100) + '%)';
			}
			span.text(str_temp);
			var str_color = '';
			if(dec_targetPrice >= dec_bookPrice){
				str_color = 'green';
			}else{
				str_color = 'red';
			}
			span.css('color',str_color);
    	}
    }
    
    function alignTheFixedHeader(){
    	//This method use static table cell number.
    	
    	//hide the seq# column header
    	//$($("table[id*='myTable'] thead tr.headerRow th")[1]).css('display','none');
    	//return false;
    	
    	if(isAmpics == 'true' || isAmpics == true){
    		console.log('isAmpics:true:',$("table[id*='myTable'] thead tr.headerRow th"));
    		//if($("table[id*='myTable'] thead tr.headerRow th").length > 7){
    			//$($("table[id*='myTable'] thead tr.headerRow th")[7]).css('display','none');
    		//}
    	}else{
    		//console.log('isAmpics::',isAmpics);
    	}
    	
    	
    	if($("table[id*='myTable'] tbody tr").length < 1){
    		var totalWidthUntilTotalPrice = 0;
    		var arr_ths = $("table[id*='myTable'] thead tr.headerRow")[0].childNodes;
    		for(var i=0;i<arr_ths.length;i++){
    			if(i<=8){
    				//console.log('aaa::',$(arr_ths[i]).width());
    				if($(arr_ths[i]).css('display') != 'none'){
    					totalWidthUntilTotalPrice = totalWidthUntilTotalPrice + parseInt($(arr_ths[i]).width()) + 8;
    				}
    			}
    		}
    		
    		//console.log('totalWidthUntilTotalPrice:== 0:'+i+'::'+totalWidthUntilTotalPrice);
    		$("#span_blankWidth").css("width",totalWidthUntilTotalPrice);
    		return false;
    	}
    	
    	var lineTotalWidth = $("table[id*='myTable'] thead tr")[0].offsetWidth;
    	var partNameWidth = 150;
    	if(lineTotalWidth != null){
    		partNameWidth = lineTotalWidth * 0.15;
    	}
    	//console.log('shouldWidth::',partNameWidth);
    	$("table.fixme span.needCalcWidth").each(function(i){
			$(this).css('width',partNameWidth+'px');
		});
    	
    	$("table[id*='myTable'] thead tr.headerRow").css('position','fixed');
    	
    	if($("table[id*='myTable'] thead tr.headerRow.hasReducedHeight").length < 1){
	    	var currTop = parseInt($("table[id*='myTable'] thead tr.headerRow").css("top"));
	    	//if(isDisplayEditAndAddButton == 'false'){
	    	if(isdisplayNoEditMessage == 'false'){
	    		$("table[id*='myTable'] thead tr.headerRow").css("top","56px");
	    	}else{
	    		$("table[id*='myTable'] thead tr.headerRow").css("top","10px");
	    	}
	    	$("table[id*='myTable'] thead tr.headerRow").addClass("hasReducedHeight");
    	}
    	
    	if($("tr.fixedTrclass").length < 1){
    		$("table[id*='myTable'] thead").append('<tr class="fixedTrclass" style="height: 44px;"><th colspan="13">aaa</th></tr>');
    	}
    	
    	var arr_tds = new Array();
    	if($("table[id*='myTable'] tbody tr").length > 0){
    		arr_tds = $("table[id*='myTable'] tbody tr")[0].childNodes;
    	}
    	var arr_ths = $("table[id*='myTable'] thead tr.headerRow")[0].childNodes;
    	var totalWidthUntilTotalPrice = 0;
    	if(arr_ths.length == arr_tds.length){
    		for(var i=0;i<arr_tds.length;i++){
    			$(arr_ths[i]).width($(arr_tds[i]).width() + 7);
    			$(arr_ths[i]).css('max-width',$(arr_tds[i]).width() + 7);
    			$(arr_ths[i]).attr("title",addTitleDescription(i));
    			
    			$(arr_ths[i].childNodes[0]).addClass('div_textOverFlow_class');
    			$(arr_ths[i].childNodes[0]).width($(arr_tds[i]).width());
    			$(arr_ths[i].childNodes[0]).css('max-width',$(arr_tds[i]).width());
    			
    			if(i<=8){
    				if($(arr_tds[i]).css('display') != 'none'){
    					totalWidthUntilTotalPrice = totalWidthUntilTotalPrice + parseInt($(arr_tds[i]).width()) + 7;
    				}
    			}
    		}
    		
    		//console.log('totalWidthUntilTotalPrice::'+i+'::'+totalWidthUntilTotalPrice);
    		$("#span_blankWidth").css("width",totalWidthUntilTotalPrice);
    	}
    	
    	if(isDisplayEditAndAddButton == 'false'){
    		$("table.fixme input.checkbox_delete_class[type='checkbox']").each(function(i){
				$(this).prop('disabled','disabled');
			});
			$("input.checkbox_deleteAll_class").prop('disabled','disabled');
    	}
    }
    
    function resizeWindowAction(){
    	$(window).resize(function() {
			alignTheFixedHeader();
		});
    }
    
    function addTitleDescription(td_index){
    	//This method use static table cell number.
    	var str_return = '';
    	if(td_index == 0){
    		str_return = 'Del';
    	}else if(td_index == 1){
    		str_return = 'Status';
    	}else if(td_index == 2){
    		str_return = 'Part Number';
    	}else if(td_index == 3){
    		str_return = 'Part Name';
    	}else if(td_index == 4){
    		str_return = 'Qty';
    	}else if(td_index == 5){
    		str_return = 'Cost';
    	}else if(td_index == 6){
    		//Modified by Buwen Guo 2017-11-17 from email:Bugs
    		//str_return = 'Book Price/Cost';
    		str_return = 'Cust Std Price';
    	}else if(td_index == 7){
    		str_return = 'Per';
    	}else if(td_index == 8){
    		str_return = 'Target Price';
    	}else if(td_index == 9){
    		str_return = 'Target Total';
    	}else if(td_index == 10){
    		str_return = 'Primary CBC4';
    	}else if(td_index == 11){
    		str_return = 'Past Quotes';
    	}else if(td_index == 12){
    		str_return = 'RSQ#';
    	}else if(td_index == 13){
    		str_return = 'Internal Comments';
    	}
    	return str_return;
    }
    
    function hideNoUseStatus(){
    	$("select.selectStatus option").each(function(content){
			if(($(this).html() != 'Won'&& $(this).html() != 'Lost' && $(this).html() != 'No Bid' && $(this).html() != 'Pending')){
				$(this).css("display","none");
				$(this).remove();
			}
 		})
    }
    
    
     
  
	function to_json(workbook) {  
	    var result = {};  
	    workbook.SheetNames.forEach(function (sheetName) {  
	        var roa = XLS.utils.sheet_to_row_object_array(workbook.Sheets[sheetName]);  
	        if (roa.length > 0) {  
	            result[sheetName] = roa;  
	        }  
	    });  
	    return result;  
	}  
	  
	function fixdata(data) {  
	    var o = "", l = 0, w = 10240;  
	    for (; l < data.byteLength / w; ++l) o += String.fromCharCode.apply(null, new Uint8Array(data.slice(l * w, l * w + w)));  
	    o += String.fromCharCode.apply(null, new Uint8Array(data.slice(l * w)));  
	    return o;  
	}  
	  
	function process_wb(wb,type) {  
	    var output = "";  
	    switch (type) {  
	        case "json":  
	            output = JSON.stringify(to_json(wb), 2, 2);  
	            break;  
	        case "form":  
	            output = to_formulae(wb);  
	            break;  
	        default:  
	            output = to_csv(wb);  
	    }  
	    //if (out.innerText === undefined) out.textContent = output;  
	    //else out.innerText = output;  
	    return output;  
	}   
	  
	function ReadExcel(out) {  
	  
	    //婵″倹鐏夐崣顏囶洣json 閸欘垯浜掓稉宥囨暏鏉烆剚宕�  
	    var exlData = JSON.parse(out);  
	    console.log('ReadExcel::',exlData);
	    
	    var firstSheetName = null;
	    for(var sheetName in exlData){
	    	firstSheetName = sheetName;
	    	break;
	    }
	    
	    
	    if(firstSheetName != null){
	    	var datas = exlData[firstSheetName];
	    	if(datas.length > 0){
	    		var firstData = datas[0];
	    		arr_fieldNameInCSV = new Array();
	    		arr_allDataFromCSV = new Array();
	    		for(var key in firstData){
	    			arr_fieldNameInCSV.push(key);
	    		}
	    		arr_allDataFromCSV.push(arr_fieldNameInCSV);
	    		for(var i=0;i<datas.length;i++){
	    			var everyLine = new Array();
	    			for(var key in datas[i]){
	    				everyLine.push(datas[i][key]);
	    			}
	    			arr_allDataFromCSV.push(everyLine);
	    		}
	    	}
	    }
	    
	    
	}  
	
	function ReadExcelX(out) {  
	  
	    //婵″倹鐏夐崣顏囶洣json 閸欘垯浜掓稉宥囨暏鏉烆剚宕�  
	    var datas = JSON.parse(out);  
    	console.log('ReadExcelX::',datas);
    	
    	if(datas.length > 0){
    		var firstData = datas[0];
    		arr_fieldNameInCSV = new Array();
    		arr_allDataFromCSV = new Array();
    		for(var key in firstData){
    			arr_fieldNameInCSV.push(key);
    		}
    		arr_allDataFromCSV.push(arr_fieldNameInCSV);
    		for(var i=0;i<datas.length;i++){
    			var everyLine = new Array();
    			for(var key in datas[i]){
    				everyLine.push(datas[i][key]);
    			}
    			arr_allDataFromCSV.push(everyLine);
    		}
    	}

	}  
	 
    
    function getEvent(){
    	return window.event||arguments[0];
    }
    
    
    function alignTheFixedHeaderForPartListTable(){
    	if($("table[id*='partListTable'] tbody tr").length < 1){
    		return false;
    	}
    	
    	$("table[id*='partListTable'] thead tr.headerRow").css('position','fixed');
    	
    	if($("table[id*='partListTable'] thead tr.headerRow.hasReducedHeight").length < 1){
    		if(isIE()) {
    			var currTop = parseInt($("table[id*='partListTable'] thead tr.headerRow")[0].offsetTop);
    		}else{
	    		var currTop = parseInt($("table[id*='partListTable'] thead tr.headerRow").css("top"));
	    	}
	    	console.log('currTop::',currTop);
	    	$("table[id*='partListTable'] thead tr.headerRow").css("top",currTop-1);
	    	$("table[id*='partListTable'] thead tr.headerRow").addClass("hasReducedHeight");
    	}
    	
    	if($("tr.fixedTrPartListTableclass").length < 1){
    		$("table[id*='partListTable'] thead").append('<tr class="fixedTrPartListTableclass" style="height: 26px;"><th colspan="6">aaa</th></tr>');
    	}
    	
    	var arr_tds = new Array();
    	if($("table[id*='partListTable'] tr").length > 0){
    		arr_tds = $("table[id*='partListTable'] tbody tr")[0].childNodes;
    	}
    	var arr_ths = $("table[id*='partListTable'] thead tr.headerRow")[0].childNodes;
    	if(arr_ths.length == arr_tds.length){
    		for(var i=0;i<arr_tds.length;i++){
    			$(arr_ths[i]).width($(arr_tds[i]).width() + 7);
    			$(arr_ths[i]).css('max-width',$(arr_tds[i]).width() + 7);
    			
    			$(arr_ths[i].childNodes[0]).width($(arr_tds[i]).width());
    			$(arr_ths[i].childNodes[0]).css('max-width',$(arr_tds[i]).width());
    		}
    	}
    	
    }
    
    
    function saveERPforPricingPicklist(){
    	showLoading();
    	$("input[id*='hidden_param_ERPforPricingValue']").val($("#select_ERPforPricingPicklist").val());
    	saveERP();
    }
    
    
    function saveERPforPricingPicklistOncomplete(){
    	var result=$("#input_hidden_isSaveERPhasError").val();

    	if(result != null && result != '' && result !='success'){
    		hideLoading();
    	}else{
    		console.log('reload:::');
			reloadPage();
    		hideLoading();
		}
    }
    
    function delBtnControll() {
    	var displayDelBtn = false;
    	var totalCheckbox = $(".checkbox_delete_class").length;
    	var int_checked = 0;
    	var int_unchecked = 0;
    	$(".checkbox_delete_class").each(function(){
    		if($(this).attr("checked")) {
    			displayDelBtn = true;
    			int_checked = int_checked +1;
    		}else{
    			int_unchecked = int_unchecked +1;
    		}
    	});
    	if(displayDelBtn) {
			$("#delBtn").removeClass("slds-hide");
    	} else {
    		$("#delBtn").addClass("slds-hide");
    	}
    	
    	if(int_checked == totalCheckbox){
    		$("input.checkbox_deleteAll_class").attr("checked","checked");
    	}else{
    		$("input.checkbox_deleteAll_class").removeAttr("checked");
    	}
    }
    
    function searchSalesHierarchy(){
    	showLoading();
    	var enteredName = $("#input_enteredTerritoryName").val();
    	if(enteredName != null && enteredName != ''){
    		searchSH(enteredName);
    	}else{
    		hideLoading();
    	}
    }
    
    function showTerritorySelect(){
    	hideLoading();
    	$("#div_select_territory").show();
    }
    
    function saveSalesHierarchy(){
    	showLoading();
    	var map_shId_shType = JSON.parse($("#hid_list_territory").val());
    	var selectTerritoryId = $("#select_territoryPicklist").val();
    	//if(selectTerritoryId != null && selectTerritoryId != ''){
    	if(selectTerritoryId != null && selectTerritoryId != '' && map_shId_shType[selectTerritoryId] == 'Sales Hierarchy (AM)'){
    		saveTerritory(selectTerritoryId);
    	}else{
    		hideLoading();
    		alert('This territory is not an AM Sales Hierarchy. Please select another or contact your BU Admin for support.');
    	}
    }
    
    function checkSaveTerritoryResult(){
    	var result=$("#input_hidden_isSaveTerritoryhasError").val();

    	if(result != null && result != '' && result !='success'){
    		hideLoading();
    	}else{
    		console.log('reload:::');
			reloadPage();
    		hideLoading();
		}
    }
    
    
    function escapeThousandDecimalForEurope(dec){
    	//console.log('suorceDec::'+dec);
    	if(dec == null){
    		return 0;
    	}
    	if(thousandSep == null || thousandSep == '' || decimalSep == null || decimalSep == ''){
    		return dec;
    	}else{
			if(dec.indexOf(thousandSep) > -1){
				if(thousandSep == ','){
					dec = dec.replace(new RegExp(thousandSep, 'g'), '');
				}
				if(thousandSep == '.'){
					//dec = dec.replace(/\./g, '');
				}
			}
			//console.log('thDec::'+dec);
			if(dec.indexOf(decimalSep) > -1 && decimalSep != '.'){
				dec = dec.replace(new RegExp(decimalSep, 'g'), '.');
			}
			//console.log('deDec::'+dec);
			return dec;
		}
    }
    
    
    function updateQuantity(){
    	if(currentOppyERP != 'SAP (except ANZPAC)'){
	    	currentRowIndex = event.currentTarget.parentNode.parentNode.parentNode.rowIndex;
	        console.log('currentRowIndex::',currentRowIndex); 
	        var tds = $($("table[id*='myTable'] tr")[currentRowIndex]).children('td');
	        
	        var quality = event.target.value;
			var moq = $(event.currentTarget).attr('data-moq');
	        console.log('moq::',moq);
	        console.log('quality::',quality);
	
	        if(Number(toDecimal2(quality)) < Number(toDecimal2(moq))) {
	            event.target.value = toDecimal0(moq);
	        } 
	        console.log('event.target.value::',event.target.value);
        }
		syncQuantity();
    }
    
    
    function updateAllQuantity(){
	    if(currentOppyERP != 'SAP (except ANZPAC)'){
	        $("table[id*='myTable'] tbody tr").each(function() {
				var tdIndex = 0;
				$(this).find("td").each(function() {
	                if(tdIndex == 4) {
	                    var input_quantity = $(this).find("input");
	                    var quality = input_quantity.val();
						var moq = input_quantity.attr('data-moq');
						console.log('all::quality:'+quality+'::moq::'+moq);
						
						if(Number(toDecimal2(quality)) < Number(toDecimal2(moq))) {
				            $(this).find("input").val(toDecimal0(moq));
				        } 
	                }
	                tdIndex++;
	            });
			});
		}
    }
    
    
    function checkAllOppPart(){
    	$("input.checkbox_delete_class").each(function() {
    		$(this).prop('checked','checked');
    	});
    	deleteOppPart();
    }
    
    function selectAllCheckbox(obj){
    	//console.log('All.selected',obj.checked);
    	if(obj.checked){
	    	$("input.checkbox_delete_class").each(function() {
	    		$(this).prop('checked','checked');
	    	});
	    	$("#delBtn").removeClass("slds-hide");
    	}else{
	    	$("input.checkbox_delete_class").each(function() {
	    		$(this).removeAttr("checked");
    		});
    		$("#delBtn").addClass("slds-hide");
    	}
    }
    
    function addCommaSeparator(){
    	var total_currency = $("#span_totalAmount").text();
    	var total_usd = $("#span_USDTotalValue").text();
    	
    	if(total_currency == null || total_currency == ''){
    		total_currency = 0.00;
    	}else{
    		total_currency = Number(total_currency);
    	}
    	
    	if(total_usd == null || total_usd == ''){
    		total_usd = 0.00;
    	}else{
    		total_usd = Number(total_usd);
    	}
    	
    	int_total_currency = parseInt(Number(total_currency));
    	dec_total_currency = getDecimal(total_currency);
    	int_total_usd = parseInt(Number(total_usd));
    	dec_total_usd = getDecimal(total_usd);
    	
    	var str_total_currency = '' + toThousands(int_total_currency) + dec_total_currency;
    	var str_total_usd = '' + toThousands(int_total_usd) + dec_total_usd;
    	
    	$("#span_totalAmount").text(str_total_currency);
    	$("#span_USDTotalValue").text(str_total_usd);
    }
    
    function toThousands(num) {
    	if(thousandSep == null || thousandSep == ''){
    		thousandSep = ',';
    	}
	    var num = (num || 0).toString(), result = '';
	    while (num.length > 3) {
	        result = thousandSep + num.slice(-3) + result;
	        num = num.slice(0, num.length - 3);
	    }
	    if (num) { result = num + result; }
	    return result;
	}
	
	function getDecimal(num) {
		if(decimalSep == null || decimalSep == ''){
    		decimalSep = '.';
    	}
	    var result = '';
	    num = ''+num;
	    if(num.indexOf('.') > -1){
	    	var b = num.split(".");
			result = decimalSep + b[1];
			if(b[1].length == 1){
				result = result + '0';
			}
	    }else{
	    	result = decimalSep + '00';
	    }
	    return result;
	}
	
	function addCommaSeparatorForEachLine(){
		$("table[id*='myTable'] tbody tr").each(function() {
			var tdIndex = 0;
			$(this).find("td").each(function() {
				if(tdIndex == 5) {
                    var input_cost = $(this).find("input.initValueDummy").val();
                    var span_cost = convertIntoComma(Number(toDecimal2(input_cost)));
					$(this).find('span.span_output_cost_class').text(span_cost);
					$(this).find('input.dummy').val(span_cost);
                }
                if(tdIndex == 6) {
                    var input_sales = $(this).find("input[id*='sales_price']").val();
                    var span_sales = convertIntoComma(Number(toDecimal2(input_sales)));
					$(this).find('span.span_output_salesPrice_class').text(span_sales);
                }
				if(tdIndex == 8) {
                    var input_price = $(this).find("input.initValuePrice").val();
                    var span_price = convertIntoComma(Number(input_price));
					$(this).find('span.targetPriceOutputText_class').text(span_price);
					$(this).find('input.target_inputData_class').val(span_price);
                }
                if(tdIndex == 9) {
                    var input_total = $(this).find("input.initValueTotal").val();
                    var span_total = convertIntoComma(Number(input_total));
					$(this).find('span.span_output_totalPrice').text(span_total);
					$(this).find('input.targetPrice').val(span_price);
                }
                tdIndex++;
            });
		});
	}
		

	function convertIntoComma(num){
		//1234.56 --> 1,234.56
		var result = '';
		if(num == null || num == '' || num == 0){
    		num = 0.00;
    	}else{
    		num = Number(num);
    	}
    	int_num = parseInt(Number(num));
    	dec_num = getDecimal(num);
    	
    	result = '' + toThousands(int_num) + dec_num;
		return result;
	}
	
	function convertIntoNumber(str){
		//1,234.56 --> 1234.56
		var result = '';
		console.log('thousandSep::',thousandSep);
		console.log('decimalSep::',decimalSep);
		
		if(str != null && str != ''){
			str = trimForNumber(str);
			if(str.indexOf(thousandSep) > -1 || str.indexOf(decimalSep) > -1){
				if(decimalSep == '.'){
					if(str.indexOf(decimalSep) > -1){
						//have decimal dot
						if(str.indexOf(thousandSep) > -1){
							//have thousand comma
							var isValidNumber = /^(-)?\d{1,3}(,\d{3})*(.\d+)?$/.test(String(str));
							if(isValidNumber){
								result = str.replace(/,/g, '');
							}else{
								result = 'error';
							}
						}else{
							//no thousand comma
							result = str;
						}
					}else{
						//no decimal dot
						if(str.indexOf(thousandSep) > -1){
							//have thousand comma
							var isValidNumber = /^(-)?\d{1,3}(,\d{3})*(.\d+)?$/.test(String(str));
							if(isValidNumber){
								result = str.replace(/,/g, '');
							}else{
								result = 'error';
							}
						}else{
							//no thousand comma
							result = str;
						}
					}
					result = Number(result);
				}else{
					if(str.indexOf(decimalSep) > -1){
						//have decimal comma
						if(str.indexOf(thousandSep) > -1){
							//have thousand dot
							var isValidNumber = /^(-)?\d{1,3}(.\d{3})*(,\d+)?$/.test(String(str));
							if(isValidNumber){
								result = str.replace(/\./g, '');
								result = result.replace(/,/g, '.');
							}else{
								result = 'error';
							}
						}else{
							//no thousand dot
							result = str.replace(/,/g, '.');
						}
					}else{
						//no decimal comma
						if(str.indexOf(thousandSep) > -1){
							//have thousand dot
							var isValidNumber = /^(-)?\d{1,3}(.\d{3})*(,\d+)?$/.test(String(str));
							if(isValidNumber){
								result = str.replace(/\./g, '');
							}else{
								result = 'error';
							}
						}else{
							//no thousand dot
							result = str;
						}
					}
					result = Number(result);
				}
			}else{
				//no comma,dot number.
				result = Number(str);
			}
		}else{
			result = 0;
		}
		return result;
	}
	
	
	//remove dot,comma,space at string's start and end.
	function trimForNumber(str){
		//console.log('str::',str);
		while (str.charAt(0) == '.' || str.charAt(0) == ',' || str.charAt(0) == ' ') {
			str = str.substring(1);
		}
		while (str.charAt(str.length-1) == '.' || str.charAt(str.length-1) == ',' || str.charAt(str.length-1) == ' ') {
			str = str.substring(0,str.length-1);
		}
		return str;
	}
	
	function targetPriceInputValidator(htmlObj){
		var input = $(htmlObj);
		if(isNaN(convertIntoNumber(input.val()))){
			input.css('border-color','red');
			input.css('box-shadow','0 0 3px red');
			alert('Please enter a correct number!');
		}else{
			input.css('border-color','');
			input.css('box-shadow','');
			syncTargetPrice();
			//verifyOfferedPrice();
			populateOffsetPercentOnBlur(htmlObj);
		}
	}
	
	function costInputValidator(htmlObj){
		var input = $(htmlObj);
		if(isNaN(convertIntoNumber(input.val()))){
			input.css('border-color','red');
			input.css('box-shadow','0 0 3px red');
			alert('Please enter a correct number!');
		}else{
			input.css('border-color','');
			input.css('box-shadow','');
		}
	}
	
	function checkAllValidator(){
		var result = true;
		$("input.targetPrice").each(function(){
			var input = $(this);
			if(isNaN(convertIntoNumber(input.val()))){
				result = false;
				input.css('border-color','red');
				input.css('box-shadow','0 0 3px red');
			}else{
				input.css('border-color','');
				input.css('box-shadow','');
			}
		});
		$("input.dummy").each(function(){
			var input = $(this);
			if(isNaN(convertIntoNumber(input.val()))){
				result = false;
				input.css('border-color','red');
				input.css('box-shadow','0 0 3px red');
			}else{
				input.css('border-color','');
				input.css('box-shadow','');
			}
		});
		if(!result){
			alert('Please enter a correct number!');
		}
		return result;
	}
	
	function chooseTerritory(terrObj) {
		var map_shId_shType = JSON.parse($("#hid_list_territory").val());
		var terriId = $(terrObj).val();
		if(map_shId_shType[terriId] != 'Sales Hierarchy (AM)') {
			alert('This territory is not an AM Sales Hierarchy. Please select another or contact your BU Admin for support.');
		}
	}