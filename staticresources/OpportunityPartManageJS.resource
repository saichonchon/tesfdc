function OpenAccountLookupPopup(oppPartId, oppyId, index){
	document.getElementById("selectedOppyPartnerId").value = oppyId;
	document.getElementById("selectedIndex").value = index;
	itb_j$("#mask").show();
	itb_j$("#mask").css({
		visibility : 'visible'
	});	
 	itb_j$(   
	  '<div id="status_content_window" style="width:100% !important;" >' + '<div id="status_popcontent">'
	   + '<div id="loading">'
	   + '<img src="/changemgmt/img/spinner24.gif"/>'
	   + '</div>'
	   + '<iframe frameborder="0" id="theIframe" width="100%" height="400px" name="theIframe" src="/apex/CtrlSearchAccountForOppyPartner"/>'
	   + '</div>'
	   + '<div style="background-color:white;text-align:center">'
	   + '</div></div>').appendTo(itb_j$("#status_window_account"));


       	
   	itb_j$("#status_window_account").css({"top":120, "left":(screen.width-700)/2,  "z-index":99999});
           
	itb_j$("#status_window_account").css({
		"z-index" : 99999
	});		
}


function OpenSearchPartNumberInDetail(oppPartId, oppyId){
	document.getElementById("selectedProposalPartId").value = oppyId;
	//alert(document.getElementById("selectedProposalPartId").value);
	itb_j$("#mask").show();
	itb_j$("#mask").css({
		visibility : 'visible'
	});	
 	itb_j$(   
	  '<div id="status_content_window" style="width:100% !important;" >' + '<div id="status_popcontent">'
	   + '<div id="loading">'
	   + '<img src="/changemgmt/img/spinner24.gif"/>'
	   + '</div>'
	   + '<iframe frameborder="0" id="theIframe" width="100%" height="400px" name="theIframe" src="/apex/CtrlSearchPartForPartNumberDetail"/>'
	   + '</div>'
	   + '<div style="background-color:white;text-align:center">'
	   + '</div></div>').appendTo(itb_j$("#status_window"));

       	
   	itb_j$("#status_window").css({"top":120, "left":(screen.width-600)/2,  "z-index":99999});
           
	itb_j$("#status_window").css({
		"z-index" : 99999
	});			
}

function OpenSearchGPL(oppPartId, oppyId, index){
	document.getElementById("selectedProposalPartId").value = oppyId;
	var url = '/apex/CtrlSearchGPL?index='+index;
	//alert(document.getElementById("selectedProposalPartId").value);
	itb_j$("#mask").show();
	itb_j$("#mask").css({
		visibility : 'visible'
	});	
 	itb_j$(   
	  '<div id="status_content_window" style="width:100% !important;" >' + '<div id="status_popcontent">'
	   + '<div id="loading">'
	   + '<img src="/changemgmt/img/spinner24.gif"/>'
	   + '</div>'
	   + '<iframe frameborder="0" id="theIframe" width="100%" height="312px" name="theIframe" src=' + url + '/>'
	   + '</div>'
	   + '<div style="background-color:white;text-align:center">'
	   + '</div></div>').appendTo(itb_j$("#status_window"));

       	
   	itb_j$("#status_window").css({"top":120, "left":(screen.width-600)/2,  "z-index":99999});
           
	itb_j$("#status_window").css({
		"z-index" : 99999
	});		
}

function OpenLookupPopup(oppPartId, oppyId){
	document.getElementById("selectedProposalPartId").value = oppyId;
	//alert(document.getElementById("selectedProposalPartId").value);
	itb_j$("#mask").show();
	itb_j$("#mask").css({
		visibility : 'visible'
	});	
 	itb_j$(   
	  '<div id="status_content_window" style="width:100% !important;" >' + '<div id="status_popcontent">'
	   + '<div id="loading">'
	   + '<img src="/changemgmt/img/spinner24.gif"/>'
	   + '</div>'
	   + '<iframe frameborder="0" id="theIframe" width="100%" height="400px" name="theIframe" src="/apex/CtrlSearchPartForProposal"/>'
	   + '</div>'
	   + '<div style="background-color:white;text-align:center">'
	   + '</div></div>').appendTo(itb_j$("#status_window"));

       	
   	itb_j$("#status_window").css({"top":120, "left":(screen.width-600)/2,  "z-index":99999});
           
	itb_j$("#status_window").css({
		"z-index" : 99999
	});		
}
function OpenSalesPartSearchPopup(){

	var partnerToken = '';
	if(window.location.href.indexOf('/partner/') > -1) {
		partnerToken = '/partner';		
	}

	itb_j$("#mask_SalesPart").show();
	itb_j$("#mask_SalesPart").css({
		visibility : 'visible'
	});	
 	itb_j$(   
	  '<div id="status_content_window" style="width:100% !important;" >' + '<div id="status_popcontent">'
	   + '<div id="loading">'
	   + '<img src="/changemgmt/img/spinner24.gif"/>'
	   + '</div>'
	   + '<iframe frameborder="0" id="theIframe" width="100%" height="400px" name="theIframe" src="' + partnerToken + '/apex/CtrlSearchPartForSales"/>'
	   + '</div>'
	   + '<div style="background-color:white;text-align:center">'
	   + '</div></div>').appendTo(itb_j$("#status_window_SalesPart"));
	   
       	
   itb_j$("#status_window_SalesPart").css({"top":120, "left":(screen.width-600)/2,  "z-index":99999});
           
	itb_j$("#status_window_SalesPart").css({
		"z-index" : 99999
	});		
}

function OpenSalesPartPopup(){

	var partnerToken = '';
	if(window.location.href.indexOf('/partner/') > -1) {
		partnerToken = '/partner';		
	}

	itb_j$("#mask").show();
	itb_j$("#mask").css({
		visibility : 'visible'
	});	
 	itb_j$(   
	  '<div id="status_content_window" style="width:100% !important;" >' + '<div id="status_popcontent">'
	   + '<div id="loading">'
	   + '<img src="/changemgmt/img/spinner24.gif"/>'
	   + '</div>'
	   + '<iframe frameborder="0" id="theIframe" width="100%" height="400px" name="theIframe" src="' + partnerToken + '/apex/CtrlSearchPartForSales"/>'
	   + '</div>'
	   + '<div style="background-color:white;text-align:center">'
	   + '</div></div>').appendTo(itb_j$("#status_window"));
	   
       	
   itb_j$("#status_window").css({"top":120, "left":(screen.width-600)/2,  "z-index":99999});
           
	itb_j$("#status_window").css({
		"z-index" : 99999
	});		
}

function popRemove() {
	itb_j$("#status_content_window").remove();
	itb_j$("#mask").css({
		visibility : 'hidden'
	});
	itb_j$("#mask").hide();
}

            function goAllCheck2(){              
                var checked = document.getElementById("allcheck").checked;
                var list_check = document.getElementsByTagName("input");        
                if(checked){
                    for(var i=0; i<list_check.length; i++){
                        if(list_check[i].type=="checkbox" && list_check[i].id!="allcheck" ){
                            list_check[i].checked = true;
                        }
                    }               
                }
                else {
                    for(var i=0; i<list_check.length; i++){
                        if(list_check[i].type=="checkbox" && list_check[i].id!="allcheck" ){
                            list_check[i].checked = false;
                        }                       
                    }
                }               
            }
            function AllCheck(){ 
            	document.getElementById("allcheck").checked = true;           
                var list_check = document.getElementsByTagName("input");        
                for(var i=0; i<list_check.length; i++){
                    if(list_check[i].type=="checkbox" && list_check[i].id!="allcheck" ){
                        list_check[i].checked = true;
                    }
                }               
                         
            }
            function CancelAllCheck(){    
            	document.getElementById("allcheck").checked = false;          
                var list_check = document.getElementsByTagName("input");        
                for(var i=0; i<list_check.length; i++){
                    if(list_check[i].type=="checkbox" && list_check[i].id!="allcheck" ){
                        list_check[i].checked = false;
                    }                       
                }
                               
            }
            function allCheckVal(cName){
                var ckFlag = 0;             
                var list_check = document.getElementsByTagName("input");            
                var checked = document.getElementById("allcheck");
                for(var i=0; i<list_check.length; i++){ 
                        if(list_check[i].type=="checkbox" && list_check[i].id!="allcheck" && list_check[i].className == cName ){
                            if(!list_check[i].checked){
	                            checked.checked = false;
	                            ckFlag = 1;     
                            }
                        }                   
                }
                if(ckFlag == 0) checked.checked = true;             
            }







		
		
		function checkAllForAddition(cb){  
			var inputElem = document.getElementsByTagName("input");  
			for(var i=0; i<inputElem.length; i++){  
				if(inputElem[i].id.indexOf("checkAddPart")!=-1)
				{
					inputElem[i].checked = cb.checked;
				}  
			}  
		}
		
		function uncheckHeaderCB(){  
			var inputElem = document.getElementsByTagName("input");  
			for(var i=0; i<inputElem.length; i++)  
			{  
				if(inputElem[i].id.indexOf("headerCheckbox")!=-1)
				{
					inputElem[i].checked = false;
				}  
			}  
		}
		/*
		window.onload = new function(){ 
			displayTextArea(); 
		};
		function displayTextArea(){
			Encoder.EncodeType = "entity";		
			var inputTxtAreas = document.getElementsByTagName("textarea");  
			for(var j=0; j<inputTxtAreas.length; j++)  
			{  
				if(inputTxtAreas[j].id.indexOf("decodeText")!=-1)
				{
					inputTxtAreas[j].innerHTML = Encoder.htmlDecode(inputTxtAreas[j].innerHTML);				
				}  
			}  			  
		}
		*/						

		

		function G$(a){
			return document.getElementById(a);
		}

		function showDisplaysSales(trId, elem, title){
			var allTr = document.getElementsByTagName("tr");
			
			if(title=='Show'){
				$(elem).hide();
				$(elem).next().show();
				for(var i=0; i<allTr.length; i++){
					if(allTr[i].className.indexOf(trId) != -1 && allTr[i].className.indexOf('opportunitypartsales') == -1){
						allTr[i].style.display = '';
					}
				}	
			}
			else{
				$(elem).hide();
				$(elem).prev().show();
				for(var i=0; i<allTr.length; i++){
					if(allTr[i].className.indexOf(trId) != -1 && allTr[i].className.indexOf('opportunitypartsales') == -1){
						allTr[i].style.display = 'none';
					}
				}
			}
		} 

		function showDisplaysProposal(trId, elem, title){
			var allTr = document.getElementsByTagName("tr");
			
			if(title=='Show'){
				$(elem).hide();
				$(elem).next().show();
				for(var i=0; i<allTr.length; i++){
					if(allTr[i].className.indexOf(trId) != -1 && allTr[i].className.indexOf('opportunitypartproposal') == -1){
						allTr[i].style.display = '';
					}
				}	
			}
			else{
				$(elem).hide();
				$(elem).prev().show();
				for(var i=0; i<allTr.length; i++){
					if(allTr[i].className.indexOf(trId) != -1 && allTr[i].className.indexOf('opportunitypartproposal') == -1){
						allTr[i].style.display = 'none';
					}
				}
			}
		}

		function ImageOver(MyImage)
		{
		    MyImage.src='{!$Resource.lookup_image_mousedover}'; 
		} 
		function ImageNormal(MyImage)
		{
		    MyImage.src='{!$Resource.lookup_image}'; 
		}

        function goAllCheck(){              
            var checked = document.getElementById("allcheck").checked;
            var list_check = document.getElementsByTagName("input");        
            if(checked){
                for(var i=0; i<list_check.length; i++){
                    if(list_check[i].type=="checkbox" && list_check[i].id!="allcheck" ){
                        list_check[i].checked = true;
                    }
                }               
            }
            else {
                for(var i=0; i<list_check.length; i++){
                    if(list_check[i].type=="checkbox" && list_check[i].id!="allcheck" ){
                        list_check[i].checked = false;
                    }                       
                }
            }               
        }
        function RadioCancelOther(selfId, partId, partName,partDescription){
        	var list_check = document.getElementsByTagName("input"); 
            for(var i=0; i<list_check.length; i++){
                if(list_check[i].type=="checkbox" && list_check[i].id != selfId ){
                    list_check[i].checked = false;
                }
            }
            document.getElementById("selectedPartId").value = partId;
            document.getElementById("selectedPartName").value = partName;
            document.getElementById("selectedPartDescription").value = partDescription;    
        }
        
		function addPart(){
			//alert('similar name:'+document.getElementById("selectedPartName").value);
			//var field = document.getElementById("selectedProposalPartId").value;
			//alert('document.getElementById(field + "_Des").value:'+document.getElementById(field + "_Des"));
			var field = document.getElementById("selectedProposalPartId").value;
			document.getElementById(field + "_Id").value = document.getElementById("selectedPartId").value;
			document.getElementById(field + "_Name").value = document.getElementById("selectedPartName").value;
			//document.getElementById(field + "_Des").value = document.getElementById("selectedPartName").value + ' - ' + document.getElementById("selectedPartDescription").value;
			document.getElementById("{!$Component.searchLookupPanel}").style.display = 'none';
			document.getElementById("{!$Component.resultRadioPanel}").style.display = 'none';
		}
		        
		function OpenSearch(oppPartId, oppyId){
			document.getElementById("searchLookupMode").innerHTML = 'Look up Mode';
			document.getElementById("{!$Component.searchSalesPanel}").style.display = 'none';
			document.getElementById("{!$Component.resultCheckboxPanel}").style.display = 'none';
			document.getElementById("{!$Component.searchLookupPanel}").style.display = 'block';
			document.getElementById("selectedProposalPartId").value = oppyId;
		}
		
		function noenter() {
  			return !(window.event && window.event.keyCode == 13); 
  		}   
  		
  		function commentsMouseOver(){
			$("#proposalPartlistTable").children().eq(1).children('.displayDataRow').each(function (){
				$(this).children().eq(-1).find('input').addClass('CommentsClass');
			});
			$(".CommentsClass").mouseover(function(){
				resetTablesLayout(this);
			});
		}
  		function resetTablesLayout(elem){
  			var thisValue = $(elem).val();
			$(elem).powerFloat({
	    		eventType: "hover",
	    		targetMode: "remind",
	    		target: thisValue,
	    		position: "1-4"
			});
  		}  