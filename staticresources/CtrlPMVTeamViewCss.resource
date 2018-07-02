html,body{ margin:0px; height:100%; }
ul,li{padding: 0; margin: 0; list-style-type: none;}

#bodyTable td.noSidebarCell{padding: 0px !important;}
#pageLoading{top:0px;left:0px;text-align:center;width:100%;height:100%;background-color:#FFF;opacity:0.85;position:fixed;z-index:8000;filter:alpha(opacity=85);background-repeat:no-repeat;background-position:center center;background-image:url('/changemgmt/img/spinner24.gif');}
#popupLoading{top:0px;left:0px;text-align:center;width:100%;height:100%;background-color /*\**/:#FFF \9; background-color:rgba(60, 60, 60, 0.25); position:fixed;z-index:8000;   filter:alpha(opacity=65); background-repeat:no-repeat;background-position:center center; }

.cp{cursor: pointer;}
.tc{text-align: center;}
.tl{text-align: left;}
.tr{text-align: right;}
.inblock{display: inline-block;}
.provhide{position: relative; overflow: hidden;}
.pr{position: relative;}
.tabdft{ table-layout: fixed; width: 100%; }
.overTab tr:hover{background-color: #e3f3ff !important;}
.searchusertbodycls tr:hover{background-color: #e3f3ff !important;}
.ckTab{background: #ffe3b0 !important;}
.old{background-color: #f4f4f4;}
.readonlycls{cursor: default; background-color:transparent !important;}
.textovhide{
	white-space:nowrap; text-overflow:ellipsis; -o-text-overflow:ellipsis; 
	-icab-text-overflow: ellipsis; -khtml-text-overflow: ellipsis; -moz-text-overflow: ellipsis; 
	-webkit-text-overflow: ellipsis; overflow: hidden;
}
.fontw{font-weight: bold; color: #fff; font-size: 1.1em;}
.designedBtn {
	padding: 5px 10px; color: #333; margin: 1px 0 0 5px;
	border: 1px solid #cfcfcf; background: #E8E8E9 url('/img/alohaSkin/btn_sprite.png') repeat-x right top;
	font-weight: 600; height: 29px; width: auto;
	-moz-border-radius: 5px; -webkit-border-radius: 5px; border-radius: 5px;
	cursor: pointer;font-weight: bold;
}
.searchButton{
	position: absolute;
}
.designedSelect{
	cursor: default; width: 208px;
	display: inline-block; border: 1px solid #cfcfcf; border-radius: 5px;
	margin: 1px; margin-left: 10px; height: 21px; line-height: 21px;padding: 5px 10px;
}
.topSearch .designedBtn{ float: left;}
.designedSelect .text{ 
	display: block; width: 195px;height: 21px;overflow: hidden; float: left;
	white-space:nowrap; text-overflow:ellipsis; -o-text-overflow:ellipsis; 
	-icab-text-overflow: ellipsis; -khtml-text-overflow: ellipsis; -moz-text-overflow: ellipsis; 
	-webkit-text-overflow: ellipsis;
}
.textSelect{
	border: 0px; margin: 0px; padding: 0px; width: 230px; height: 27px; line-height: 27px;
	margin-top /*\**/: 3px\9;
}
.topSelect{border-width: 1px;
    display: inline-block;
    height: 29px;
    line-height: 29px;
    width: 207px;
    border: 1px solid #CFCFCF;
    margin: 1px 5px 0;}
.topInput{
	border: 1px solid #D48D00;
    border-radius: 6px;
    height: 25px;
    width: 226px;
}
.titleDiv2 .topInput{ width: 140px;}
#kamcode{ margin-right: 41px;}
.textSelect{border: 1px solid #D48D00;}
.textSelect:focus { padding: 0px; margin: 0px; margin-top /*\**/: 3px\9; border: 0px;}
.textSelect:after { padding: 0px; margin: 0px; margin-top /*\**/: 3px\9; border: 0px;}
.textSelect:active{ padding: 0px; margin: 0px; margin-top /*\**/: 3px\9; border: 0px;}

@-moz-document url-prefix(){ 
	.textSelect{padding-top: 1px;}
	.textSelect:focus{ border: 0px; padding-top: 1px;}
	.textSelect:after{ padding-top: 1px; border: 0px;}
	.textSelect:active{ padding-top: 1px; border: 0px;}
}

.designedSelect .area{float: right;}
.designedSelect *::selection{ background:transparent !important; }/*webkit*/
.designedSelect *::-moz-selection{ background:transparent important;}/*moz*/
.oppteaminfo *::selection{ background:transparent !important; }/*webkit*/
.oppteaminfo *::-moz-selection{ background:transparent important;}/*moz*/

#teamheadid *::selection{ background:transparent !important; }/*webkit*/
#teamheadid *::-moz-selection{ background:transparent important;}/*moz*/
#oppyheadid *::selection{ background:transparent !important; }/*webkit*/
#oppyheadid *::-moz-selection{ background:transparent important;}/*moz*/

.top{ height:35px; line-height: 35px; width:100%;}

.title{
	width:100%; border-radius: 6px; position: relative; 
   background: linear-gradient(#fab70f, #f49d02);border /*\**/: 1px solid #C37D00 \9; overflow /*\**/: hidden \9;
}
.title_right{border-right: 1px solid #C37D00;}
.title_left{border-left: 1px solid #FFC962;}
.datefixcls{ position: relative; height: 40px; line-height: 40px; float: right;}
.selecteddatelabel{    
	position: absolute; top: 2px; height: 10px; line-height: 10px;
	text-align: left;  padding-left: 15px; font-weight: bold;
}
.menuoppycls{
    filter: progid:DXImageTransform.Microsoft.gradient( startColorstr='#fab70f', endColorstr='#f49d02',GradientType=0 ); /* IE6-9 */
	border-radius: 6px;overflow: hidden;width: 100%;
}
.fieldsetcls{
	margin: 0; float: left;
	padding: 0px 5px; padding-bottom: 5px; margin-left: 3px;
	border: none;
}
.legendcls{
	height: 10px; line-height: 10px;
}
.titleDiv1, .titleDiv2{ height:117px; float:left;}
.titleDiv1{ margin:0px 8px;}
.titleDiv2{ margin:0px 11px;}
.dateonlycls1{display: inline-block;
    float: left;
    line-height: 40px;
    margin-right: 5px;
    position: relative;
    width: 174px;}
.inputSelect{
	padding: 0px 5px;
	display: inline-block; height: 27px; line-height: 27px;border: 1px solid #C37D00; border-radius: 6px;
}
.inputDate{
    width:109px; height:24px; line-height: 24px; background:#c37d00;
    position: relative;border: 1px solid #C37D00; display: inline-block;border-radius: 6px; 
}
.inputDate.fix{margin-left: 0px;}
.inputDate input{
    width:79px; height:23px; line-height:23px;  border: 0px; padding-left: 4px; padding-bottom: 0;
    border-top-left-radius: 6px; border-bottom-left-radius: 6px;font-size: 0.75em;
}
#codeInput{margin: -10px 0 0 8px;}
#codeInput input[type="text"] {
    border-radius: 5px;
    height: 26px;
    line-height:26px;
    width: 100%;
    border: 1px solid #d48d00;
}
#codeInput > div{
	width: 109px;
	float: left;
}
#codeInput .gamcodeDiv{width: 171px; margin-right: 8px;}
#codeInput .amcodeDiv{margin:0px 4px 0px 32px;}
#codeInput input[type="button"] {
    border: 1px solid #ce8c06;
    margin-top: 20px;
}
#codeInput label{
	display: block;
	height: 20px;
	line-height: 20px;
}
.inputDate span{
    width:19px; height:19px; position: absolute; right: 3px; top: 3px;cursor: pointer;
    background-position:-194px -20px !important;
}
.oppSelect{border-radius: 6px;}

.title-Arrow{
    width:20px; height:12px; line-height:12px; display:inline-block; margin: 6px 2px 0 2px;
    background-position: -203px -52px !important;
}
.title_dollar{
	background: linear-gradient(#4f4f4f, #0e0e0e);
    filter: progid:DXImageTransform.Microsoft.gradient( startColorstr='#4f4f4f', endColorstr='#0e0e0e',GradientType=0 ); /* IE6-9 */
    border-radius: 6px;
    color: #FFFFFF;
    float: right;
    font-size: 1.875em;
    font-weight: bold;
    height: 65px;
    line-height: 65px;
    margin-right: 20px;
    text-align: center;
    width: 90%;
}
.team_box{border: 1px solid #CFCFCF; border-radius: 6px; overflow: hidden; margin-top: 20px;}
.team_head{
	filter: progid:DXImageTransform.Microsoft.gradient( startColorstr='#ffffff', endColorstr='#e1e1e1',GradientType=0 ); /* IE6-9 */
	background: linear-gradient(#ffffff, #e1e1e1);
}
.team_hf_h{height: 38px;}
.team_ovhide{height: 39px; overflow: hidden;}
.team_body_h{height: 35px;}
.team_foot{
	filter: progid:DXImageTransform.Microsoft.gradient( startColorstr='#006B82', endColorstr='#005567',GradientType=0 ); /* IE6-9 */
	background: linear-gradient(#006a82, #005567);
}

.team_bl{border-left: 1px solid #b8b8b8;}
.team_br{border-right: 1px solid #ffffff;}
.team_br.none{border-right: none !important;}
.team_bt{border-bottom: 1px solid #d8d8d8;}
.team_bl.botml{border-left: 1px solid #005567 !important;}
.team_br.botmr{border-right: 1px solid #00697c !important;}

.team_div{height: 38px; width: 100%; position: relative;}
.team_div .left{float: left; width: 97%; height: 38px; line-height: 38px; display: inline-block;}
.team_div .headright{width: 1px; height: 38px; border-right: 1px solid #fff;}
.team_div .footright{width: 1px; height: 38px; border-right: 1px solid #00697c;}

.team_orderby{
	color: #919191;width: 15px; height: 15px;line-height: 15px; float: right; 
	margin-top: 11px;margin-left: 10px;
}
#team_head .fix_width table thead tr th.tc span.team_orderby{right: 13px; position: absolute;}
#oppy_head .fix_width table thead tr th.tc span.team_orderby{right: 3px; position: absolute;}
.fix_width table thead tr th.tc span.pdleft{padding-left: 0px;}
@-moz-document url-prefix(){
	.team_orderby{float: none;}
	#team_head table thead tr th:first-child .left:first-child span:last-child{ }
}
.pdleft{padding-left: 10px;}
.pdright{padding-right: 10px;}
.teamviewbody .miximg div{width: 22px; height: 22px; display: inline-block;}
#teamheadid .miximg {cursor: default !important;}
#teamheadid .miximg span.team_orderby{display:none;}

.mix_green {background-position: -124px -81px !important;}
.mix_yellow {background-position: -159px -81px !important;}
.mix_red {background-position: -191px -81px !important;}



.w1{width: 12%;}
.w2{width: 9%;}
.w3{width: 9%;}
.w4{width: 11%;}
.w5{width: 9%;}
.w6{width: 9%;}
.w7{width: 9%;}
.w8{width: 5%;}
.w9{width: 6%;}

.o1{width: 12%;}
.o2{width: 12%;}
.o3{width: 12%;}
.o4{width: 12%;}
.o5{width: 10%;}
.o6{width: 8%;}
.o7{width: 5%;}
.o8{width: 10%;}
.o9{width: 4%;}
@-moz-document url-prefix(){ .o9{width: 58px;} }
.o10{width: 4%;}
.o11{width: 7%;}

.oppyinfomsg{
	display: block;height: 36px;line-height: 36px;margin: 0 auto;position: absolute;
	width: 100%;text-align: center;z-index: 10;
}

.oppyselectfoot{
	
}
.oppyfoot{
	height: 39px; line-height: 39px; display: inline-block; float: left; color: #fff; font-size: 1.2em;
}

.oppprev, .oppnext{ width: 20px; background-color: #d9981b; cursor: pointer; }
.oppprev:hover{opacity:0.85; filter:alpha(opacity=85);}
.oppnext:hover{opacity:0.85; filter:alpha(opacity=85);}
.oppteam{ width: 300px;overflow: hidden; }
.oppteam.nomoer{
	background-color: #d9981b; 
	filter: progid:DXImageTransform.Microsoft.gradient( startColorstr='#d9981b', endColorstr='#f19201',GradientType=0 ); /* IE6-9 */
	background: linear-gradient(#d9981b, #f19201);
}
.progress_cls div{ }
.progress_head{cursor: default !important;}
.projected_cls span{ width: 28px; height: 23px; line-height: 23px; display: inline-block;}
.health_cls span{ width: 28px; height: 23px; line-height: 23px; display: inline-block;}
.size_cls span{ width: 27px; height: 24px; line-height: 24px; display: inline-block;}

.cls_size_empty{background-position: 10px 0px !important;}
.cls_project_empty{background-position: 10px 0px !important;}
.cls_progress_empty{background-position: 10px 0px !important;}
.cls_size_1{background-position: -228px -48px !important;}
.cls_size_2{background-position: -258px -48px !important;}
.cls_size_3{background-position: -165px -48px !important;}
.cls_health_1{background-position: -222px -115px !important;}
.cls_health_2{background-position: -186px -115px !important;}
.cls_health_3{background-position: -151px -115px !important;}

.healthcmtcls{position: absolute;}
.healthcmt_cls {
	width: 100% !important; height: 100% !important; line-height: 100% !important; overflow:  auto;
	display: block !important; white-space: normal !important;
}
.healthheadbox{border: 1px solid #4d91a2; background-color:#fff; border-radius: 6px; width: 160px; height: 95px;}
.healthcontentbox{margin: 10px; text-align: left; height: 74px;overflow-y: auto;overflow-x: hidden;}

.healthimgdiv{height: 12px; margin-top: -2px; margin-top /*\**/: -3px\9;}
@-moz-document url-prefix(){
	.healthimgdiv{ margin-top: -3px; }	
}
.cls_won{background-position: -92px -119px !important;}
.cls_production{background-position: 0 -118px !important;}
.cls_onhold{background-position: -116px -119px !important;}
.cls_project_1{background-position: -34px -119px !important;;}
.cls_project_2{background-position: -66px -117px !important;}
.cls_progress{ width: 10px; height: 10px; display: inline-block; }
.cls_progress.G{ background-position: -6px -62px !important; }
.cls_progress.R{ background-position: -19px -62px !important; }
.cls_progress.Y{ background-position: -35px -62px !important; }

.requiredInput{float: left;  position: relative;}
.requiredInput .requiredBlock{background-color: #C00;position: absolute;left: -4px;width: 3px;top: 3px;bottom: 4px;}



.connstatuscls{
	top:0px;left:0px;text-align:center;width:100%;height:100%; 
	position:fixed;z-index:8011;background: transparent !important;
}
.connbox{
	z-index: 8500; position: relative;top: 15%;bottom: 10%;margin: 0 auto;
	filter: progid:DXImageTransform.Microsoft.gradient(enabled='true', startColorstr='#7f787676', endColorstr='#7f787676');
	background: rgba(121, 119, 119, 0.4); border: 5px solid #7A7979; left: 38%;
	width: 15%; min-width: 280px; height: 240px;  min-height: 240px; 
}
.connboxhead{ }
.connboxtitle{font-size: xx-large;font-weight: bold;color: #D54343;}
.connyear{
	padding-left: 0;float: left;display: inline-block;height: 50px;line-height: 50px;
	width: 100%;margin: 0;padding: 0; background-color: beige; cursor: default;
}
.conborder{border: 1px Solid #7A7979; padding-top: 10px;}
.connerror{
	position: absolute; width: 50%;
	background: #FFF;margin-top: 3px;margin-left: 3px;
	border: 2px solid #EB5959;
}
.connhelp{ height: 30px; line-height: 30px;}
.connhelp div{font-size: 0.9375em;text-align: left; display: inline-block; height: 25px; line-height: 25px;}
.connhelp .con{color: #1F46E2;}
.connhelp .suc{color: #1FE26D; margin-left: 20px;}
.connhelp .err{color: #D34619; margin-left: 20px;}

.firstyear{margin-left: 0px;}
.ulbox{float:left; width: 100%;}
.dyearbox{overflow: hidden; padding: 10px;}

.popup_labcls{float: left;height: 30px;line-height: 30px;width: 20%;}
.popup_footth{padding-top:10px; padding-bottom:30px; text-align: center;}
.popup_search_lab{ margin-right: 10px;font-size: 1.1em;font-weight: bold;}

.popup-Add{
    width: 50%; position: absolute; margin-bottom: 100px; min-width: 820px;
    left: 23%; top: 15%; z-index: 9000; border-radius: 4px; overflow: hidden;
    box-shadow: 0px 0px 60px #afafaf; background:#ffffff;
}
.popup-Edit{
    width: 50%; position: absolute; left: 23%; margin-bottom: 100px; min-width: 820px;
    top: 15%; z-index: 9000; border-radius: 4px; overflow: hidden;
    box-shadow: 0px 0px 60px #afafaf; background:#ffffff;
}
.popup-title{
    width:100%; height:41px;
    filter: progid:DXImageTransform.Microsoft.gradient( startColorstr='#006a82', endColorstr='#005467',GradientType=0 ); /* IE6-9 */
    background: linear-gradient(#006a82, #005467);
    border-top-left-radius: 4px; border-top-right-radius: 4px;
}
.popup-title span{
    display:inline-block; color:#ffffff;
    line-height:41px; padding-left:14px; font-weight: bold;
}
.popup-content{
    margin: 0px 23px;
}
.popup-content input[type="text"]{
 	width:267px; height:27px;
 	border: 1px solid #d8d8d8; border-radius: 4px;
	padding:0px; margin-bottom: 3px;
}
.inputCon input[type="text"]{
 	margin-left:42px; float:left; margin-top:8px;
}
.inputCon{
	position: absolute;width: 100%; z-index: 11;height: 160px; left: 0px;
	background-color:#FFF;opacity:0.85; filter:alpha(opacity=85); background-repeat:no-repeat;
	background-position:center center;background-image:url('/changemgmt/img/spinner24.gif');
	/*
 	margin-bottom: 5px; display: block; width: auto; height: auto; overflow: auto;
 	*/
}
.searchuserLoadingcls{
	position: absolute;width: 100%; z-index: 11;height: 160px; left: 0px; 
	background-color:#FFF;opacity:0.85; filter:alpha(opacity=85); background-repeat:no-repeat;
	background-position:center center;background-image:url('/changemgmt/img/spinner24.gif');
}
.popup-content-title{
    border-bottom: 1px solid #000000; padding: 8px 0px; margin: 15px 0px; font-size: 1em;
    clear: both; color: #1b1b1b; font-weight: bold;
}
.popup-content-partDiv{
	overflow: auto; padding: 5px 0px; margin-bottom:0px; height: 230px; min-height:230px;
}

.popup-buttonGray{
    height:28px; border:1px solid #cfcfcf;
    padding: 0px 12px; border-radius: 6px;
    line-height: 28px; margin-right: 8px; font-weight: bold; font-size: 0.875em;
    filter: progid:DXImageTransform.Microsoft.gradient( startColorstr='#fefefe', endColorstr='#d9d9d9',GradientType=0 ); /* IE6-9 */
    background: linear-gradient(#fefefe, #d9d9d9);
}
.popup-buttonYellow{
    height:28px; border:1px solid #da8d00; padding: 0px 12px;
    border-radius: 6px; line-height: 28px; font-weight: bold;
    font-size: 0.875em; color:#ffffff;
    filter: progid:DXImageTransform.Microsoft.gradient( startColorstr='#f9b30f', endColorstr='#ef8f03',GradientType=0 ); /* IE6-9 */
    background: linear-gradient(#f9b30f, #ef8f03);
}
.popup-content-partDiv .popup-buttonGray{
    width:34px; height:29px; line-height:29px; margin-right:8px;
    margin-bottom: 3px; clear: both; float: left;
}
.tmpteamcls{height: 36px;}
.popup-buttonGray.fix{margin-top: 1px;}
.popup-content-partDiv .popup-buttonYellow{
    margin: 11px 0px 0px 42px;
}
.popup-button{
    float:right; margin-top:40px; padding-bottom:10px;
}



.text-table tr{ height:40px; }
.text-table th{ width:100px; }
.popup-Search{
    width:732px; position: absolute; left: 26%; top: 5%; z-index: 8500; margin-bottom: 200px;
    border-radius: 4px; box-shadow: 0px 0px 60px #afafaf; background:#ffffff; overflow: hidden;
}
.popup-content-left{
    width:370px; height:130px; float:left; position:relative;
}
.popup-content-right{
    width:259px; height:121px; float:right; border-radius: 4px; border:1px solid #cfcfcf;
    filter: progid:DXImageTransform.Microsoft.gradient( startColorstr='#fefefe', endColorstr='#d9d9d9',GradientType=0 ); /* IE6-9 */
    background: linear-gradient(#fefefe, #d9d9d9);
}
.popup-content-right p{ padding: 0px 17px; }
.popup-content-left .popup-buttonYellow{
    right: 0px; bottom: 0px; position: absolute;
}

.popup_usertable_head{ 
	border: 1px solid #cfcfcf; width: 100%;
    filter: progid:DXImageTransform.Microsoft.gradient( startColorstr='#fefefe', endColorstr='#d9d9d9',GradientType=0 );
    background: linear-gradient(#fefefe, #d9d9d9);
}
.popup_usertable_head thead th, .popup-content-partDiv tbody td{height: 32px;}
.th_head_r{border-right:1px solid #cfcfcf;}
.th_head_l{border-left:1px solid #cfcfcf;}
.th_head_pding{padding-left:10px;}

.labelckbox{
	background:#ffffff; width:23px; height:23px; display: inline-block; margin-right: 5px;
    border-radius: 4px; border:1px solid #cfcfcf;
} 
.labelckbox .box{
	width:13px; height:12px; display:inline-block; margin: 6px 0px 0px 6px;
	background-position:-110px -69px;
}


.ulTitle{
    height:32px !important; line-height:32px !important; font-weight:bold;
}
.ulDiv-click{
    filter: progid:DXImageTransform.Microsoft.gradient( startColorstr='#f9b30e', endColorstr='#ef8e03',GradientType=0 ) !important;
    background: linear-gradient(#f9b30e, #ef8e03) !important;
    border:1px solid #da8d00 !important;
}
.fieldsetcls legend{
	font-weight: normal;
}


/********xiaofeng add*********/
.codecls tr {
	line-height: 25px;
}

/********jinming add*********/
/***********chart axis style*************/
.yAxis{
    width: 17px;
    height: 132px;
    position: relative;
    background: #8c5a00;
    color: #FFFFFF;
    font-size: 0.6875em;
    font-weight: bold;
    position: absolute;
	margin: 0px 0px 0px 8px;
}
.xAxis{
    height: 17px;
    width: 176px;
    background: #8c5a00;
    color: #FFFFFF;
    font-size: 0.6875em;
    font-weight: bold;
    position: absolute;
	margin: 132px 0px 0px 25px;
}
.yAxis span{
    display: inline-block;
    margin: 0px 4px;
    position: absolute;
}
.yAxis span:first-child{
	left: 1px;
	top: 3px;
}
.yTitle{
	width: 39px;
	position: absolute;
	top: 61px;
	left: -11px;
    transform: rotate(-90deg); 
    -ms-transform:rotate(-90deg);     /* IE 9 */
    -moz-transform:rotate(-90deg);    /* Firefox */
    -webkit-transform:rotate(-90deg); /* Safari and Chrome */
    -o-transform:rotate(-90deg);  /* Opera */
}
.ylow{
    position: absolute;
    bottom: 3px;
    left: 1px;
}
.xAxis span{
    display: inline-block;
    margin: 1px 5px;
    position: absolute;
}
.xAxis span:first-child{
	left: 3px;
}
.xAxis .xTitle{
    margin: 1px 26px;
    left: 19px;
}
.xlow{
	right: 3px;
}
html[data-useragent*='MSIE 8.0'] .yTitle{
	top: 50px;
	left: 1px;
	filter: progid:DXImageTransform.Microsoft.BasicImage(rotation=3);  /* IE 8 */
}


/********jinming add*********/
.chartDiv{
	width: 340px;
	margin: 5px auto;
	padding: 4px 0px;
	height: 150px;
	background: #fff;
	border-radius: 5px;
	position: relative;
}