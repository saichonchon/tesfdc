html,body{ margin:0px; height:100%; }
ul,li{margin: 0; padding: 0;}
#bodyTable td.noSidebarCell{padding: 0px !important;}
html[data-useragent*='MSIE 10.0'] td.border_b {
	border-bottom-width:thin !important;
}
html[data-useragent*='MSIE 9.0'] td.border_b {
	border-bottom-width:thin !important;
}
html[data-useragent*='MSIE 8.0'] .th_futurec {
	filter: progid:DXImageTransform.Microsoft.gradient(startColorstr='#fcfcfc', endColorstr='#e6e6e6', GradientType='0');
}
html[data-useragent*='MSIE 8.0'] .th_historicalc {
	filter: progid:DXImageTransform.Microsoft.gradient(startColorstr='#616161', endColorstr='#272727', GradientType='0');
}
::-webkit-scrollbar{ width: 11px;height: 11px; }
::-webkit-scrollbar-track { background-color: #fff; border-radius: 8px; }
::-webkit-scrollbar-thumb {  
	border-radius: 8px;
	-webkit-box-shadow: 0 0 1px rgba(255,255,255,.4);
	background-color: rgba(0,0,0,.4);
}
::-webkit-scrollbar-thumb:hover {  
	background-color: rgba(0,0,0,.6);
	-webkit-box-shadow: 0 0 1px rgba(255,255,255,.6);
}

#compbodyall{margin-top: 15px;}
.disabled{ background: none repeat scroll 0 0 #ddd !important;}
.p_r{position: relative;}
.dn{display: none !important;}
.db{display: block;}
.fwb{font-weight: bold;}
.ov{overflow: hidden;}
.vv{visibility: visible;}
.tc{text-align: center;}
.tr{text-align: right;}
.tl{text-align: left;}
.fol{float: left}
.va_impl{vertical-align: middle !important;}
.mgauto{margin: 0 auto;}
.hd{cursor: pointer;}
.pd_r{padding-right: 5px; padding-left: 3px;}
.border_r{border-right: 1px solid #cbcbcb;/*#2A6E6F;*/}
.border_l{border-left: 1px solid #cbcbcb;}
.border_t{border-top: 1px solid #cbcbcb;}
.border_b{border-bottom: 1px solid #cbcbcb; overflow: hidden; text-overflow: ellipsis;}
.border_sb{border-bottom: 0.1px solid #f0f3f3;}
.border_b1{border-bottom: 1px solid #cbcbcb;}
.pdtb{padding: 5px 0;}
.pdtr{padding-right: 5px !important;}
.fix_b{height: 1px; line-height: 1px; margin-left: -56px;margin-top: -1px;
        min-width: 55px !important;display: list-item;float: left;list-style:none;background-color: #f0f3f3;
}
.connstatuscls{
	top:0px;left:0px;text-align:center;width:100%;height:100%; 
	position:fixed;z-index:8011;background: transparent !important;
}
.connbox{
z-index: 8500;width: 40%; height: 50%; position: relative;top: 15%;bottom: 10%;margin: 0 auto;
filter: progid:DXImageTransform.Microsoft.gradient(enabled='true', startColorstr='#7f787676', endColorstr='#7f787676');
background: rgba(121, 119, 119, 0.4);
border: 5px solid #7A7979;min-height: 500px; min-width: 730px; 
}
.connboxhead{height: 1px;line-height: 1px;}
.connboxtitle{font-size: xx-large;font-weight: bold;color: #D54343;}
.connyear{
padding-left: 0;float: left;display: inline-block;height: 50px;line-height: 50px;
width: 50px;margin: 0;padding: 0;margin-left: 5px;
background-color: beige; cursor: default;
}

.connerror{
position: absolute; width: 50%;
background: #FFF;margin-top: 3px;margin-left: 3px;
border: 2px solid #EB5959;
}
.bbb{border-bottom: 5px solid #7A7979;}
.connobj{padding: 0;font-size: 16px;font-weight: bold;padding-top: 10px;}
.connhelp{position: absolute;right: 10px;top: 12px;}
.connhelp div{font-size: 15px;text-align: left; height: 25px; line-height: 25px;}
.connhelp .con{color: #1F46E2;}
.connhelp .suc{color: #1FE26D;}
.connhelp .err{color: #D34619;}


.firstyear{margin-left: 0px;}
.ulbox{float:left; }
.dyearbox{overflow: hidden; padding: 10px;}

.lhb_fix{height: 0.5px;line-height:0.5px; position: absolute; width: 50px; margin-top: -0.5px;}
.lhb_fix.bg{background: #f0f3f3;}
.compmenucls{height: 50px; line-height: 50px; background-color: #ec912e;}
.designedBtn {
	padding: 5px 10px; color: #333; margin: 1px;
	border: 1px solid #D37707; background: #E8E8E9 url('/img/alohaSkin/btn_sprite.png') repeat-x right top;
	font-weight: 600; font-size: 11px; border-radius: :5px;
	-moz-border-radius: 5px; -webkit-border-radius: 5px;
	border-radius: 5px; font-family: Arial,Helvetica,sans-serif;
	cursor: pointer;
}
.ml{margin-left: 15%;}

.ldm_wh{min-height: 25px; min-width:228px;}

.compwp{width: 100%; position: relative;}

.clear{clear:both; height: 0px; width: 0px;}
#loading-curtain-div{top:0px;left:0px;text-align:center;width:100%;height:100%;background-color:#FFF;opacity:0.85;position:fixed;z-index:8000;filter:alpha(opacity=85);background-repeat:no-repeat;background-position:center center;background-image:url('/changemgmt/img/spinner24.gif');}

.cw_fix{width: 50px; text-overflow: ellipsis;}
.mainTabFix{width: 100%; table-layout:fixed; display: table;border-collapse: separate; border-spacing: 0;}
.tabRowFix{table-layout:fixed; display: table-row; border-collapse: separate; border-spacing: 0;}
.tabCellFix{table-layout:fixed; display: table-cell;vertical-align: top;border-collapse: separate;}
.tabRow{ display: table-row; border-collapse: separate; border-spacing: 0;}
.tabCell{ display: table-cell; border-collapse: separate; vertical-align: top;}
.cellwb{word-break: break-word;}
.noTabCell{height: 100%;}
.rCellw{width: auto;}
.lCellw{width: 278px;}
.lcell_empty{float: left; height: 79px; min-height: 79px; visibility: visible;}



.alb_r{border-right: 1px solid #fff; }
.alb_t{border-top: 1px solid #f0f3f3;}

.alhb_l{border-left: 1px solid #fff;}
.alhb_l_1{border-left: 1px solid #f0f3f3;}

.lbbg{background-color: #FFFFF4;}
.folw{ float: left;width: 100%; }

.pd_0_0{padding-left: 8px;}
.pd_l_0{padding-left: 5px;}
.pd_l_1{padding-left: 25px;}
.pd_l_1.pno{padding-left: 0px !important;}
.pd_l_2{padding-left: 45px;}
.pd_l_3{padding-left: 85px;}


.futurec{
	background-color: #f8f8f8; 
	filter: progid:DXImageTransform.Microsoft.gradient(startColorstr='#fcfcfc', endColorstr='#e6e6e6', GradientType='0');
	background: -moz-linear-gradient(top, #fcfcfc, #e6e6e6); /* Firefox */
	background: -webkit-gradient(linear, left top, left bottom, color-stop(0.1, #fcfcfc), color-stop(0.9, #e6e6e6));
	background: -ms-linear-gradient(top, #fcfcfc 1%, #e6e6e6 90%);
	border-right: 1px solid #cbcbcb; color:#585a63;
}
.currentc{
	background-color: #f8f8f8 /*538dd5*/; 
	filter: progid:DXImageTransform.Microsoft.gradient(startColorstr='#fcfcfc', endColorstr='#e6e6e6', GradientType='0');
	background: -moz-linear-gradient(top, #fcfcfc, #e6e6e6); /* Firefox */
	background: -webkit-gradient(linear, left top, left bottom, color-stop(0.1, #fcfcfc), color-stop(0.9, #e6e6e6));
	background: -ms-linear-gradient(top, #fcfcfc 1%, #e6e6e6 90%);
	border-right: 1px solid #cbcbcb /*538dd5*/; color:#585a63;
}
.historicalc{
	background-color: #f8f8f8; 
	filter: progid:DXImageTransform.Microsoft.gradient(startColorstr='#fcfcfc', endColorstr='#e6e6e6', GradientType='0');
	background: -moz-linear-gradient(top, #fcfcfc, #e6e6e6); /* Firefox */
	background: -webkit-gradient(linear, left top, left bottom, color-stop(0.1, #fcfcfc), color-stop(0.9, #e6e6e6));
	background: -ms-linear-gradient(top, #fcfcfc 1%, #e6e6e6 90%);
	border-right: 1px solid #cbcbcb; color:#585a63;
}
.futurec.currentc1{/* background-color: #cbcbcb !important; border-right: 1px solid #cbcbcb; */}
.datatotalcls{float:left; width: 100%;}
.dataTabcls{width: 100%; table-layout: fixed;}
.dTabcls{width: 100%;}


.datatotal{background-color: #e8b014;}
.datainput{background-color: #ffcc99;}
.dataquarterly{background-color: #ccccff;}
.nobg{background-color: #f5f5f5 !important;}
.nodatabg.inbg{background-color: #f0f3f3;}

.current_fixcls{text-align: center; }

.fix_lh{line-height: 30px;height:30px; width: 100%;}
.fixthh{height: 25px; vertical-align: middle; white-space:nowrap !important;}
.trh{height: 29px; vertical-align: middle; white-space:nowrap !important;}
.lineh{line-height: 29px;}
.trhfix{height: 40px; vertical-align: middle; }
.trlh{line-height: 40px; vertical-align: middle;}


.left_bg{
	background-color: #f8f8f8;
	filter: progid:DXImageTransform.Microsoft.gradient(startColorstr='#fcfcfc', endColorstr='#e6e6e6', GradientType='0');
	background: -moz-linear-gradient(top, #fcfcfc, #e6e6e6); /* Firefox */
	background: -webkit-gradient(linear, left top, left bottom, color-stop(0.1, #fcfcfc), color-stop(0.9, #e6e6e6));
	background: -ms-linear-gradient(top, #fcfcfc 1%, #e6e6e6 90%);
}

.th_historicalc{
background-color: #363636; 
background: -moz-linear-gradient(top, #616161, #272727); /* Firefox */
background: -webkit-gradient(linear, left top, left bottom, color-stop(0.1, #616161), color-stop(0.9, #272727));
background: -ms-linear-gradient(top, #616161 1%, #272727 90%);
border-top-left-radius: 10px;
border-top-right-radius: 10px;
border-top: 1px solid #C4C2C2;
border-right: 1px solid #363636;color: #f8f8f8;
}
.th_futurec{
background-color: #e7e7e7; 
background: -moz-linear-gradient(top, #fcfcfc, #e6e6e6); /* Firefox */
background: -webkit-gradient(linear, left top, left bottom, color-stop(0.1, #fcfcfc), color-stop(0.9, #e6e6e6));
background: -ms-linear-gradient(top, #fcfcfc 1%, #e6e6e6 90%);
border-top-left-radius: 10px;
border-top-right-radius: 10px;
border-top: 1px solid #C4C2C2;
border-right: 1px solid #f8f8f8;color: #363636;
}
.head_historicalc{
	text-align: left !important;overflow: hidden;position: relative;
}
.absdiv{position: absolute;}
.head_futurec{
	text-align: left !important; padding-left: 10px;
}
.usdbox{
	border-top-right-radius: 8px;border-bottom-right-radius: 8px;
	height: 30px; line-height:30px; top: 8px; padding-left: 5px; padding-right: 5px;
	float: right; position: absolute; right: 20px; color: #fff;
filter: progid:DXImageTransform.Microsoft.gradient(startColorstr='#E48A27', endColorstr='#f0b373', GradientType='1');
background: -moz-linear-gradient(top right, #f0b373, #E48A27); /* Firefox */
background: -webkit-gradient(linear, right bottom, left bottom, color-stop(0.1, #f0b373), color-stop(0.9, #E48A27));
background: -ms-linear-gradient(top, #f0b373 1%, #E48A27 90%);
}
.ps_msg{height: 25px;line-height: 25px;width: 180px;background-color: rgb(250, 179, 179);}

.qtotalw{width: 70px;}
.cfixmonthw{width: 70px !important; min-width: 70px !important; max-width: 70px !important;}
.cfixqtotalw{width: 70px !important; min-width: 70px !important; max-width: 70px !important; background-color: #e6e6e6;}
.cfixqtotalw.headbg{ 
	background-color: #186076;
	filter: progid:DXImageTransform.Microsoft.gradient(startColorstr='#25809E', endColorstr='#0d5268', GradientType='0');
	background: -moz-linear-gradient(top, #25809E, #0d5268); /* Firefox */
	background: -webkit-gradient(linear, left top, left bottom, color-stop(0.1, #25809E), color-stop(0.9, #0d5268));
	background: -ms-linear-gradient(top, #25809E 1%, #0d5268 90%);
	color:#fff;border-right: 1px solid #186076; 
}
.cfixw{width: 70px !important; min-width: 70px !important; max-width: 70px !important;}
.cfixcurentmonthw{width: 70px !important; min-width: 70px !important; max-width: 70px !important;}

.vvcls{visibility: hidden;}

.in_idbg{
background-color: #f6b400;
font-size: 1.2em;
font-weight: bold;
}

.ftsize{
font-size: 1.2em;
font-weight: bold;
}

.not_total td.cfixqtotalw{
	background-color: #DBDBDB !important;
}
.totalbg{background-color: #E0E0E0; }
.dTabbg{
	background-color: #363636; 
	filter: progid:DXImageTransform.Microsoft.gradient(startColorstr='#616161', endColorstr='#272727', GradientType='0');
	background: -moz-linear-gradient(top, #616161, #272727); /* Firefox */
	background: -webkit-gradient(linear, left top, left bottom, color-stop(0.1, #616161), color-stop(0.9, #272727));
	background: -ms-linear-gradient(top, #616161 1%, #272727 90%);
	color: #fff; font-weight: bold; font-size: 1.2em; 
}
.left_titlebg{
	font-size: 1.2em;
font-weight: bold;
filter: progid:DXImageTransform.Microsoft.gradient(startColorstr='#ffffff', endColorstr='#e0e0e0', GradientType='0');
	background: -moz-linear-gradient(top, #fff, #e0e0e0); /* Firefox */
background: -webkit-gradient(linear, left top, left bottom, color-stop(0.1, #fff), color-stop(0.9, #e0e0e0));
background: -ms-linear-gradient(top, #fff 1%, #e0e0e0 90%);
}
.left_titlebg.coll{
filter: progid:DXImageTransform.Microsoft.gradient(startColorstr='#E4C55D', endColorstr='#f19f00', GradientType='0');
background: -moz-linear-gradient(top, #E4C55D, #f19f00); /* Firefox */
background: -webkit-gradient(linear, left top, left bottom, color-stop(0.1, #E4C55D), color-stop(0.9, #f19f00));
background: -ms-linear-gradient(top, #E4C55D 1%, #f19f00 90%);
}

.collapse_left{
border-left: 8px solid #f19f00;
}
.cmtimg{width: 16px; border: 0; height: 16px; background-position: 0 0; float: left; margin-left: 5px;}
.commentimg{width: 16px; border: 0; height: 16px; background-position: 0 0; float: left; margin-left: 5px;}
.pcentdatacls{position: absolute; z-index: 10; background: #FDFDFD; margin-top: 3px;}
.pcentdataTab{border-top:1px solid #B3AFAF; border-left:1px solid #B3AFAF; border-right:1px solid #B3AFAF;  width: 100%;}
.pcentdataTd{padding-left: 5px; padding-right:5px; border-bottom : 1px solid #B3AFAF; border-right : 1px solid #B3AFAF;}

.bgov{/* background-color: #e3f3ff;  #ffffee; */ border-bottom: 1px dashed #991FC0 !important;border-top: 1px dashed #991FC0 !important;}
.bgov td{/* background-color: #e3f3ff !important; */ border-bottom: 1px dashed #991FC0 !important;border-top: 1px dashed #991FC0 !important;}
.bgov td.dTabbg1{background-color: #fff !important; border-bottom: none !important; border-top:none !important;}


.bgopov{opacity:0.65;filter:alpha(opacity=65);}
.inputtrbg{ }
.inputcls{width: 92%; max-width: 70px;}

.fold_box{
	float: right;top: -11px;right: -4px; display: inline-block;
	width: 15px;height: 15px;line-height: 15px; position: absolute;
	background: #084151; color: #f8f8f8;font-size: 1.2em;
}
.exp_right{
	border-right: 1px solid #8D8D8D !important;
}
.eve{ background-color: #F1F1F1;}
#pageLoading{top:0px;left:0px;text-align:center;width:100%;height:100%;background-color:#FFF;opacity:0.85;position:fixed;z-index:8000;filter:alpha(opacity=85);background-repeat:no-repeat;background-position:center center;background-image:url('/changemgmt/img/spinner24.gif');}
.hide{display:none;}

.clear{clear:both;}
.hbx{
overflow:hidden;float:left;}
.hwbx{width:1700px;}
.vbx{overflow:hidden;float:left;}
.hvbx{
    overflow-x:auto;
    overflow-y:scroll;
}

.cTable{border-collapse:collapse;}
#Theader{font-weight:bold;font-size:0.9em;}
#Theader th{padding:5px 0px;text-align:center;}
.hy{background-color:#8f8f8f;width:85px;}/*#ccc*/
.Total{cursor:pointer;}
.qsts{float:right;position:relative;}
.qsts div{position:absolute;width:10px;height:19px;
    margin-left: -13px;cursor:pointer;}
.leftC{float:left;border-collapse: collapse;}
.leftC td{padding:5px 0px;}
.acName{display: inline-block;
    width:164px;
    overflow: hidden;
    white-space: nowrap;
    text-overflow: ellipsis;
    }
.ca{width:178px;padding:5px 0px;border-right:1px solid #f0f3f3;}
span.cfh{margin-left:-500px;font-weight:bold;font-size:0.9em;}
.ca span{cursor:pointer;}
.ct{background-color:#b0c6dd;}/*#DCE6F1;*/
.ck{background-color:#F2F2F2;}/*#F2F2F2;*/
#ArrowAll img{cursor:pointer;}
.expSpan,.clpsSpan{display:inline-block;width:11px;height:11px;cursor:pointer;}

#tthd .hy,#tthd .CM,#tthd .nM{border-top:1px solid #f0f3f3;}
.rfa td{border-top:1px solid #FFF;}
#bthd,#mainTbody tr,#lTbody tr,.rfb {border-bottom:1px solid #f0f3f3;}
.odd{background-color:#fff;}
.evn{background-color:#eef7ff;}/*#eff;*/
.odd:hover{background-color:#e3f3ff;}
.evn:hover{background-color:#e3f3ff;}

#mainTbody tr:hover{background-color:#bdd6ef;}/*e3f3ff*/
#mainTbody tr:hover .ck{background-color:#bdd6ef;}
#mainTbody tr:hover .ct{background-color:#bdd6ef;}
.hv .ck, .hv .ct{background-color:#bdd6ef;}
#lTbody tr:hover{background-color:#bdd6ef;}
.hv{background-color:#bdd6ef;}

#mainTbody tr td{width:85px;min-width:85px;word-wrap:break-word;white-space:normal;padding:5px 0px;text-align:right;}
#mainTbody tr td input{width:65px;margin:-5px 0px;text-align:right;}
.leftC tr td.tin{padding-left:16px;border-right:1px solid #f0f3f3;text-align:left;}
.leftC tr td.tjn{padding-left:32px;border-right:1px solid #f0f3f3;text-align:left;}
.CM{color:#fff;background-color:#0a30a3;width:85px;}/*#538dd5*/
#tthd .CM{-webkit-gradient(linear,0 0,0 bottom,from(#f00),to(rgba(0,0,255,0.5)))}
#bthd .CM{-webkit-gradient(linear,0 0,0 bottom,from(#fcc),to(#fff))}
.nM{background-color:#7da53e;width:85px;}/*#c4d79b*/

.cmI{cursor:pointer;}
#popCmt{position:fixed;top:0px;left:0px;width:100%;height:100%;background:#f8f8f8;opacity:0.8;
    filter:ALPHA(opacity=80);z-index:1000;}
#popCtn{width:600px;height:470px;position:fixed;top:45%;left:50%;margin-left:-300px;
    margin-top:-225px;z-index:9999;border:8px double #eee;border-radius:5px;background-color:#FFF;
    -webkit-box-shadow:1px 3px 5px #aaa;-moz-box-shadow:1px 3px 5px #aaa;box-shadow:1px 3px 5px #aaa;}
.titleLine{background-color:#aca;width:600px;border-bottom:1px solid #aaa;
    border-radius:3px;font-size:20px;text-align:center;}
.icon_close{border-width:1px;border-style:solid;border-color:#bbb;
    height:20px;width:20px;text-align:center;
    line-height:20px;cursor:pointer;float:right;font-size:20px;margin:1px;}
.icon_close:hover{border-color:#aaa;font-weight:bold;}
#popCtn table.hdfw td{font-weight:bold;}
#popCtn table td.pa{width:30px;min-width:30px;max-width:30px;}
#popCtn table td.pb{width:100px;min-width:100px;max-width:100px;}
#popCtn table td.pc{width:100px;min-width:100px;max-width:100px;}
#popCtn table td.pd{width:100px;min-width:100px;max-width:100px;}
#popCtn table td.pe{width:250px;min-width:250px;max-width:250px;}
.pb select, .pc select{width:80px;}
#popCtn table td{padding:5px 0px; }
#popCtn table td input.numInput{width:80px;text-align:right;}
#popCtn table td input.txtInput{width:220px;}
#ptbCtn{height:380px;overflow-y:auto;overflow-x:hidden;}

