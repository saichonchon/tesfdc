/**
 * This function changes formated number into unformated number.
 * Require:N/A.
 * params
 * str - formated number, e.g. "1,234.56", "5k".
 * seperator - ',', or '.'
 * decimal - decimal point "." or ","
 * setScale - decimal digits
 * return pure number
 * Fuqi Tan <fuqi.tan@itbconsult.com>
 *  */
function unformateNum(str,decimal,setScale){
	str=''+str;
	var regEndWithK=/[K,k]{1}$/;
	var regEndWithM=/[M,m]{1}$/;
	var regEndWithB=/[B,b]{1}$/;
	var regEndWithT=/[T,t]{1}$/;
	var regLtZero=/^-/;
	var isEndWithK=regEndWithK.test(str);
	var isEndWithM=regEndWithM.test(str);	
	var isEndWithB=regEndWithB.test(str);
	var isEndWithT=regEndWithT.test(str);
	var isLtZero=regLtZero.test(str);
	var otherchar=new RegExp("[^\\d\\"+decimal+"]","g");
	
	str=str.replace(otherchar,'');	
	str=str.replace(decimal,'.');//replace with decimal
	
	str=parseFloat(str);	
	if(isNaN(str)) str=0;
	if(isEndWithK){
		str*=1000;
	}else if(isEndWithM){
		str*=1000000;
	}else if(isEndWithB){
		str*=1000000000;
	}else if(isEndWithT){
		str*=1000000000000;
	}
	if(setScale>=0){
		//str=str.toFixed(setScale);	
		var asistNum=Math.pow(10,setScale);
		str=Math.round(str*asistNum)/asistNum;
	}
	if(isLtZero){
		str=-str;
	}
	return str;	
}

/**
 * This function changes unformated number into formated number.
 * Require: function unformateNum
 * params
 * num - formated number, e.g. "1234.56".
 * seperator - ',', or '.'
 * decimal - decimal point "." or ","
 * setScale - decimal digits
 * return number with format, e.g "1,234.56".
 * Fuqi Tan <fuqi.tan@itbconsult.com>
 *  */
function FormatNum(num,seperator,decimal,setScale){	
	if(isNaN(num)) {
		num=unformateNum(num,decimal,setScale); // change into number with function unformateNum.
	}
	
	var result=num<0?'-':'';
	var asistNum=Math.pow(10,setScale);
	num=Math.round(num*asistNum)/asistNum;
	num=(''+num).replace(/^-/,'');	
	var numint,numdec,numlen,deduct,position;	
	position=num.lastIndexOf('.');
	if(position>=0){
		numdec=num.substr(position+1);
		
		if(position>0)numint=num.substring(0,position);
	}else{
		numint=num;
		numdec='';
	}
	
	while(numdec.length<setScale){
			numdec+='0';
	}
	numlen=numint.length; 
	while(numlen>3){
		deduct=numlen%3;
		deduct=(deduct==0?3:deduct);
			result+=numint.substr(0,deduct)+seperator;
			numint=numint.substr(deduct);
			numlen=numlen-deduct;		
	}
	result+=numint; 
	if(setScale>0){
		result=result+decimal+numdec;
	}	
	return result;
}

function hiddenBlock(divId){
	G$(divId).style.display="none";
}	
		
function showBlock(divId){
	G$(divId).style.display="";
}
function G$(a){
	return document.getElementById(a);
}
