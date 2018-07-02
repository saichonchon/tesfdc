#status_window{
	width:60%;
    position: fixed;
    top: 25%;
    left: 20%;
    z-index: 9999999;
}

#status_content_window{
    border:1px solid #ccc;
    opacity:1;
    z-index: 9999999;
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
    display: block; 
}
        
#status_popcontent{
	padding: 5px 5px;
    overflow-x: hidden; 
    overflow-y: hidden; 
    border-top-width: 1px; 
    border-right-width: 1px; 
    border-bottom-width: 1px; 
    border-left-width: 1px; 
    border-top-style: solid; 
    border-right-style: solid; 
    border-bottom-style: solid; 
    border-left-style: solid; 
    border-top-color: rgb(204, 204, 204); 
    border-right-color: rgb(204, 204, 204); 
    border-bottom-color: rgb(204, 204, 204); 
    border-left-color: rgb(204, 204, 204); 
    border-image: initial; 
    background-color: rgb(246, 246, 246); 
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
    visibility: hidden ;
    display:none;       
}     
   
.addYear{
	display: block;
	text-align:center;
	vertical-align:middle;
}
.inlineTable .inlineTableTd#firstTableTd table .noBorder,#inlineTable .inlineTableTd#firstTableTd table .noBorder{	
	/*
	background:none !important;
	border:0px solid #fff !important;
	border-bottom:1px solid #fff !important;
	border-left:0px solid #fff !important;
	border-right:0px solid #fff !important;	
	height: 24px !important;
    padding: 0 5px 	!important;   
    */   
    border-color:#fff;
    background-color:#fff; 
}

/*
.apexp .detailList .list .headerRow th{
	border-top-width:1.01px;
	border-top-style:solid;
}
.apexp .detailList .list .headerRow th.oppyForecastTop{
	border-top-width:0px;
}
.apexp .detailList .list.listTableLeft .headerRow th.borderTop{
	border-top-color:#ccc;
}
.apexp .detailList .list.tableNoLeftBorder .headerRow th.thyear{
	border-top-color:#ccc/0;
}
.apexp .detailList .list.partList .headerRow th.partTopBorder{
	border-top-color:#ccc/0;
}
*/
.inlineTable .inlineTableTd#firstTableTd table.listTableLeft,
.inlineTable .inlineTableTd#firstTableTd table#listTableLeft{
	border-top-color:#fff;
}
.inlineTable .inlineTableTd#firstTableTd table th.headerNoBorder,
#inlineTable .inlineTableTd#firstTableTd table tr.noBorderTr th,
#inlineTable .inlineTableTd#firstTableTd table tr.noBorderTr td{
	
	border-color:#fff;
    background:none;	
	
	/*
	background:none !important;
	border-bottom:1px solid #fff; 
	*/
	
	/*border-bottom:2px solid #fff\0; */
	
	/*
	border-left:0px solid #fff !important;
	border-right:0px solid #fff !important;	
	*/
	
	/*border-bottom:1px solid #fff !important; 
	border-left:0px solid #fff !important;
	border-right:0px solid #fff !important;	
	padding: 5px 2px 4px 5px;
	font-size: 0.9em;
    font-weight: bold;
    height:20px;
    */
}

.headerleftBorder{
	border-top:1px solid #CCCCCC !important;
	border-left:1px solid #CCCCCC !important;
	text-align:center;
	//padding: 4px 2px 4px 4px !important;
}
.headerTopBorder{
	border-top:1px solid #CCCCCC !important;
	//padding: 4px 2px 4px 4px !important;
}
.trRightBorder{
	border-bottom:1px solid #CCCCCC !important;
	border-top:0px solid #CCCCCC !important;
	border-left:1px solid #CCCCCC !important;
	text-align:right;
}
.trleftBorder{
	//height:24px !important;
	border-left:1px solid #EDEDED !important;
}
.trBottomBorder{
	//height:24px !important;
	border-bottom:1px solid #CCCCCC !important;
	text-align:right;
}
.headerCenter{
	text-align:center;
}
.tdRight{
	text-align:center;
}
.readonly{
	border:none !important;
}

.container{
	//min-width:1000px;
}
.forecastStructures{
	float:left;
	padding-bottom:1px;
	//max-width:600px;
}	
.forecastStructureItem{
	margin-left:0px;
	margin-right:0px;
	width:100px;
	padding:0px 0px;
}
.parts{
	float:left;
}
.number{
	text-align:right;
}	
.styleOne{
	margin-top:2px !important; 
	white-space:nowrap !important;
}	
.styleTwo{
	margin-top:2px !important; 
}	
.styleThree{
	margin-top:2px !important; 
	width:100px !important;  
}	
.styleFour{
	margin-top:-2px !important;
	white-space:nowrap !important; 
	width:170px !important;
}
.styleFive{
	margin-top:-2px !important;
	white-space:nowrap !important; 
	width:200px !important;	
}	
.inputQuantity,.inputQuantityP{
	width:70px !important;
	text-align:right !important;
	margin:0px;
	height:16px;
}
.partLabel{
	height:24px !important;
	padding:0px 5px !important;
	font-size: 1.0em !important;
	text-align:right !important;	
}
.tableNoLeftBorder{
	border-left-width:0px !important;
}
.tdTwo{
	height:24px !important;
	padding:0px 5px !important;
	border-left:none !important;
	text-align:right;
	vertical-align: middle !important;
}	
.tdThree{
	height:24px !important;
	padding:0px 3px !important;
	text-align:right !important;
}
.tdFour{
	height:24px !important;
	padding:0px 3px !important;
	text-align:right !important;
}
.tdFive{
	height:24px !important;
	padding:0px 3px !important;
	border-left:1px #D4DADC solid !important;
	text-align:right !important;
}
.tdSix{
	height:24px !important;
	padding:0px 3px !important;
	border-right:1px #D4DADC solid !important;
}	
.thOne{
	min-width:45px !important;
	text-align:center !important;
	border-right:1px !important;
	border-left:0px !important;
}	
.thTwo{
	min-width:45px !important;
	text-align:center !important;
	border-right:1px !important;
	border-left:0px !important;
}	
.thThree{
	min-width:45px !important; 
	text-align:center !important;
	border-right:2px #E3DEB8 solid !important;
	border-left:0px !important;
}
.trOne{
	padding:0px !important; 
	background-color:transparent !important; 
	border-top:0px !important; 
	vertical-align: middle !important; 
	border-top:0px !important; 
}
.outerwrapper{
	width:100%;	
	float:left;	
}
.wrapper{
	margin-top:15px;
	width:900px;
}
.topButtons{
	margin-left:-60px;
}
.Qzone{
	background-color:#E4EDF7;
}
.Qprice{
	font-weight:bold;
	font-style:italic;
}
.widedataRow{
	height:24px;
	/*border-bottom-width:1px;*/
}

.widedataCell{
 	border-top-width: 0px !important;
 	border-right-width: 0px !important;
 	border-left-width: 0px !important;
 	vertical-align:middle !important;
 }
.twidedataCell{
 	border-top-width: 0px !important;
 	border-right-width: 0px !important;
 	border-left-width: 0px !important;
 	vertical-align:middle !important;
 }
.lwidedataCell{
 	border-top-width: 0px !important;
 	border-right-width: 0px !important;
 	vertical-align:middle !important;
 }
Body .pbBody .inlineTable .inlineTableTd .parts table.list tbody tr.headerRow th.headerCenter.borderTop{							
							/*border-top:1px solid #ccc;
							border-top:1.01px solid #cccccc\0;	*/
							border-color:#ccc;	
							border-left:1px solid #ccc;
						}
.headerRow{
	height:20px;
}
input,.whiteBg{
	background-color:#fff;
}
.pbSubsection .detailList{
	float:left !important;
}
table.inlineTable{
	border-collapse: collapse !important;
	
}
.inlineTable .inlineTableTd{
	padding:0px;	
}
.inlineTable .inlineTableTd#firstTableTd{
	padding-left:1px;	
}
.inlineTable .inlineTableTd#firstTableTd table tr td.controlLongtext span{
	display:block;
	height:15px;
	width:150px;
	-o-text-overflow:ellipsis;
	text-overflow:ellipsis;
	overflow:hidden;
	white-space:nowrap;
}
.inlineTable .inlineTableTd#firstTableTd table tr td.controlLongtextoppy span{
	display:block;
	height:15px;
	width:140px;
	margin:0 auto;
	-o-text-overflow:ellipsis;
	text-overflow:ellipsis;
	overflow:hidden;
	white-space:nowrap;
}
table.inlineTable .parts .list,.yearTablesTable{
	border-collapse: seperate;
	border-spacing: 0px;
}

.controlIEborder .controlIETdbug{
	overflow:hidden;
}
.bPageBlock .labelCol{
	padding-left:5px;
}
.bPageBlock table.detailList tbody tr td.data2Col{
	padding-left:10px;
}
Body .bPageBlock.bDetailBlock .pbBody td.data2Col{
	padding-top:0px;
}
body .bRelatedList .pbBody table.list, body .apexp .pbBody table.list.listTableLeft{
	/*
	border-top:1px solid #fff;
	border-top:1.5px solid #fff\0;
	*/
}

.inlineTable .inlineTableTd#firstTableTd table tr td.controlLongtextoppy span.tdheightControl{
			float:left;
			color:#fff;
			margin-left:-10000px;
}
.inlineTable .inlineTableTd#firstTableTd table tr td.controlIETdbug span.tdheightControl{
			float:left;
			color:#fff;
			margin-left:-10000px;
}
td.controlIETdbug span.tdheightControl{
			float:left;
			color:#fff;
			margin-left:-10000px;
}
table.inlineTable table.listTableLeft td select,table.inlineTable td#firstTableTd table.controlIEborder td select{
	font-size:9.5px;
	height:16px;
	min-width:99%;	
}
@-moz-document url-prefix(){table.inlineTable table.listTableLeft td select,table.inlineTable td#firstTableTd table.controlIEborder td select{
	//height:15px;
}}
/*table.inlineTable table .dataCell,table.inlineTable table .widedataCell{min-height:30px;}*/
body{background-color:#fff !important;font-size:12px;} 

#list_TableLeft .oppyHideRow td{
    padding:0px;
    height:15px;   
}
#list_TableLeft .statusTd{
    padding:0px;
}
#inlineTable .inlineTableTd table span{
    white-space: nowrap;
}
#partTable td{
    font-size:12px;
    white-space: nowrap;
    min-width:80px;
    width:80px;
}
.viewDiv span.bomShow,.viewDiv span.bomHide,.editDiv .viewHide{display:"";}
.viewDiv input.bomShow,.viewDiv input.bomHide,.viewDiv .viewHide{display:none;}

// min
//.viewDiv .isManual tbody .bomShow{display:none;}
//.viewDiv .isBom tbody .bomShow{display:"";}

.editDiv .isManual tbody .bomShow,.hide{display:none;}
.editDiv .isManual tbody .bomHide,.show{display:"";}
.editDiv .isBom tbody .bomShow{display:"";}
.editDiv .isBom tbody .bomHide{display:none;}

.editDiv input.bomHide,input.bomShow,.partRate,.priceInput{width:70px;text-align:right;height:16px;}
tr.headerRow th img{cursor:pointer;}
#inlineTable .inlineTableTd{vertical-align:top;}
#yearsTableTr .Ytd{width:100px;min-width:100px;}
#innerWidthToSet{overflow-x:auto;overflow-y:hidden;}
Body .pbBody #inlineTable #firstTableTd table#list_TableLeft tbody tr#tr_leftTable th.headerCenter{border-top:1px solid #ededed\0;border-left:1px solid #EDEDED;}
.iea{color:#fff\0;color:transparent;float:left;margin-left:-600px;}
.sStart{position:absolute;}
.noBorderTr td,.noBorderTr th{border:none;}
body .apexp .pbBody .inlineTable #firstTableTd table.list#list_TableLeft {border-top-color:#fff;}
#popCmt{top:0px;left:0px;text-align: center; width: 100%; height: 100%; background-color: #FFF; opacity: 0.85; position: fixed; z-index: 8000; filter: alpha(opacity = 85); background-repeat: no-repeat; background-position: center center;}
#popCtn{position: absolute;
top: 100px;
left: 300px;
background-color: #f5f5f5;
width: 400px;
height: 200px;
border: 1px solid #eee;
z-index: 8099;}
.titleLine{background-color:#abc;}
.icon_close{width: 25px;height: 25px;border: 1px solid #ccc;font-size: 20px;line-height: 25px;text-align: center;right: 0px;float: right;margin: 1px;cursor: pointer;}
.clear{clear:both;}
.popReasonBody{padding: 10px;font-size: 14px;}
.pop_btn_div{text-align: center;margin-top: 20px;}