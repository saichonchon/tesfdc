.outerwrapper{
	width:100%;
}
.wrapper{
	margin-top:15px;
	width:100%;	
}
.whiteBg{
	background-color:#fff;
}
.headerCenter{
	text-align:left;
}
.inputItem, .outputItem{
	width:70px !important;
	text-align:right !important;
	margin:0px;
}
table.list tbody tr.headerRow th.headerCenter.borderTop{							
	border-top:1px solid #ccc;
	border-top:1.5px solid #cccccc\0;		
	border-left:1px solid #ccc;
}
.headerRow{
	height:20px;
}
.tdOne{
	text-align:left;
}
.tdTwo{
	height:24px !important;
	padding:0px 5px !important;
	border-left:none !important;
	text-align:right;
	vertical-align: middle !important;
}
.tableNoLeftBorder{
	border-left-width:0px !important;
}
table.inlineTable{
	border-collapse: collapse !important;
}
.trleftBorder{
	//height:24px !important;
	border-left:1px solid #CCCCCC !important;
}
.trrightBorder{
	//height:24px !important;
	border-right:1px solid #CCCCCC !important;
}
.noBorder{	
	background:none !important;
	border:0px solid #fff !important;
	border-bottom:1px solid #fff !important;
	border-left:0px solid #fff !important;
	border-right:0px solid #fff !important;	
	height: 24px !important;
    padding: 0 5px 	!important;    
}
.borderTop{							
	border-top:1px solid #E3DEB8 !important;
	border-top:1.5px solid #E3DEB8\0;		
	//border-left:1px solid #ccc;
}

.helpOrb {
    background-image: url("/img/help/helpOrbs.gif");
    background-position: 0 0;
    height: 15px;
    width: 20px;
}

#rejectReasonDiv{
	width:30%;
    position: fixed;
    top: 25%;
    left: 25%;
    opacity:1;
    z-index: 9999999;   
    border:1px solid #ccc;   
    border-top-width: 6px; 
    border-right-width: 6px; 
    border-bottom-width: 6px; 
    border-left-width: 6px;  
    border-top-style: solid; 
    border-right-style: solid; 
    border-bottom-style: solid; 
    border-left-style: solid; 
    border-image: initial; 
    border-top-left-radius: 10px; 
    border-top-right-radius: 10px; 
    border-bottom-right-radius: 10px; 
    border-bottom-left-radius: 10px; 
    -webkit-box-shadow: rgb(0, 0, 0) 1px 1px 5px; 
    border-top-color: rgb(221, 221, 221); 
    border-right-color: rgb(221, 221, 221); 
    border-bottom-color: rgb(221, 221, 221); 
    border-left-color: rgb(221, 221, 221);
    //visibility: hidden ;
    //display:none;
}
#mask {   
    position: absolute;   
    top: 0;   
    left: 0;   
    width:100%;   
    height:100%;    
    background: gray;   
    opacity:0.8;
    filter: ALPHA(opacity = 80);   
    z-index: 100;   
    //visibility: hidden ;
    //display:none;       
}