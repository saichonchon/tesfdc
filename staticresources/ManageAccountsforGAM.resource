function OpenAccountLookupPopup(oppPartId, oppyId, index){
	document.getElementById("selectedOppyPartnerId").value = oppyId;
	//alert('The oppy Id is '+oppyId);
	document.getElementById("selectedIndex").value = index;
	//alert('The index value is '+index);
	itb_j$("#mask").show();
	itb_j$("#mask").css({
		visibility : 'visible'
	});	
 	itb_j$(   
	  '<div id="status_content_window" style="width:100% !important;" >' + '<div id="status_popcontent">'
	   + '<div id="loading">'
	   + '<img src="/changemgmt/img/spinner24.gif"/>'
	   + '</div>'
	   + '<iframe frameborder="0" id="theIframe" width="100%" height="400px" name="theIframe" src="/apex/SearchAccountsforGAM"/>'
	   + '</div>'
	   + '<div style="background-color:white;text-align:center">'
	   + '</div></div>').appendTo(itb_j$("#status_window_account"));


       	
   	itb_j$("#status_window_account").css({"top":120, "left":(screen.width-700)/2,  "z-index":99999});
           
	itb_j$("#status_window_account").css({
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
		        
		
