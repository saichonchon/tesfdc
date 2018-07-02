var NS4 = (navigator.appName == "Netscape" && parseInt(navigator.appVersion) < 5);

var sf ='default';
var clf ='default';
var rof ='default';

function addOption(theSel, theText, theValue) {
	var newOpt = new Option(theText, theValue);
	var selLength = theSel.length;
	theSel.options[selLength] = newOpt;
}

function deleteOption(theSel, theIndex) {
	var selLength = theSel.length;
	if (selLength > 0) {
		theSel.options[theIndex] = null;
	}
}

function ini(sel,separator,pickType){
	var theSel = document.getElementById(sel);
	var tmp = '';
	if (theSel && separator) {
		for (i = 0; i < theSel.length; i++) {
			tmp += (theSel.options[i].value + separator);
		}
		if (tmp.length > 0)
			tmp = tmp.substring(0, tmp.length - 1);
	}
	if(pickType == "sfields"){
		sf = tmp;
	}
	if(pickType == "clfields"){
		clf = tmp;
	}
	if(pickType == "rofields"){
		rof = tmp;
	}
}

function moveOptions(theSelFrom, theSelTo) {

	var selLength = theSelFrom.length;
	var selectedText = new Array();
	var selectedValues = new Array();
	var selectedCount = 0;

	var i;

	for (i = selLength - 1; i >= 0; i--) {
		if (theSelFrom.options[i].selected) {
			selectedText[selectedCount] = theSelFrom.options[i].text;
			selectedValues[selectedCount] = theSelFrom.options[i].value;
			deleteOption(theSelFrom, i);
			selectedCount++;
		}
	}
	for (i = selectedCount - 1; i >= 0; i--) {
		addOption(theSelTo, selectedText[i], selectedValues[i]);
	}

	if (NS4)
		history.go(0);
}

function doMove(from, to) {
	var theSelFrom = document.getElementById(from);
	var theSelTo = document.getElementById(to);

	if (theSelFrom && theSelTo) {
		moveOptions(theSelFrom, theSelTo);
	}
}

function convertSelectToText(sel, textArea, separator,pickType) {
	var theSel = document.getElementById(sel);
	var theTextArea = document.getElementById(textArea);
	var i;
	var tmp = '';
	if (theSel && theTextArea && separator) {
		theTextArea.value = "";
		for (i = 0; i < theSel.length; i++) {
			tmp += (theSel.options[i].value + separator);
		}
		if (tmp.length > 0)
			tmp = tmp.substring(0, tmp.length - 1);
			theTextArea.value = tmp;
	}
	if(pickType == "fields"){
		if(sf&&sf.length>0){
			var sfArr = sf.split(separator);
			sf="";
			for (i = 0; i < sfArr.length; i++) {
				if(tmp.indexOf(sfArr[i])>-1){
					sf += (sfArr[i] + separator);
				}
			}
			if (sf.length > 0){
				sf = sf.substring(0, sf.length - 1);
			}
		}
		if(clf&&clf.length>0){
			var clfArr = clf.split(separator);
			clf="";
			for (i = 0; i < clfArr.length; i++) {
				if(tmp.indexOf(clfArr[i])>-1){
					clf += (clfArr[i] + separator);
				}
			}
			if (clf.length > 0){
				clf = clf.substring(0, clf.length - 1);
			}
		}
		if(rof&&rof.length>0){
			var rofArr = rof.split(separator);
			rof="";
			for (i = 0; i < rofArr.length; i++) {
				if(tmp.indexOf(rofArr[i])>-1){
					rof += (rofArr[i] + separator);
				}
			}
			if (rof.length > 0){
				rof = rof.substring(0, rof.length - 1);
			}
		}
		rerenderFields(tmp,sf,clf,rof);
	}
	if(pickType == "sfields"){
		sf = tmp;
	}
	if(pickType == "clfields"){
		clf = tmp;
	}
	if(pickType == "rofields"){
		rof = tmp;
	}
}

function move(from, to, sel, textArea, separator,pickType) {
	if (from && to && sel && textArea && separator) {
		doMove(from, to);
		convertSelectToText(sel, textArea, separator,pickType);
	}
	
}

function moveOptionUp(sel, direction, textArea, separator,pickType) {
	var theSel = document.getElementById(sel);
	if (theSel != null) {
		if (direction) {
			if (theSel.selectedIndex > 0) {
				for ( var i = 0; i < theSel.length; i++) {
					if (theSel[i].selected) {
						var oOption = theSel.options[i];
						var oPrevOption = theSel.options[i-- - 1];
						theSel.insertBefore(oOption, oPrevOption);
					}
				}
			}
		} else {
			for ( var i = theSel.length - 1; i >= 0; i--) {
				if (theSel[i].selected) {
					if (i == theSel.length - 1)
						return;
					var oOption = theSel.options[i];
					var oNextOption = theSel.options[i + 1];
					theSel.insertBefore(oNextOption, oOption);
				}
			}
		}
		convertSelectToText(sel, textArea, separator);
	}
}
