html,body{ margin:0px; height:100%; }
input{outline:none !important;} 

#loading-curtain-div{top:0px;left:0px;text-align:center;width:100%;height:100%;background-color:#FFF;opacity:0.85;position:fixed;z-index:8000;filter:alpha(opacity=85);background-repeat:no-repeat;background-position:center center;background-image:url('/changemgmt/img/spinner24.gif');}

.bodyDiv{ background: #fbfcfb; }
.ref_cover{
    position: relative;line-height: 20px;height: 20px;text-align: center;
}
.ref_box{
    line-height: 20px;text-align: center;
    display: inline-block;width: 35px;height: 20px;margin-left: 2px;background: #517BC9; color: #fff; cursor: default;
}
.ref_msg{ margin-left: 4px;position: absolute;border: 1px solid #E63C3C;background: #fff;height: 19px;
    line-height: 19px; display: none; z-index: 10; color: #000;
}
.ref_box:hover b.ref_msg{ display: inline-block; }
.w-drop-box{
    display: inline-block; float: right; width: 5px; height: 100%; background: rgb(246, 73, 73);
    position: absolute; top: 0px; right: 0px; cursor: ew-resize; 
}
.w-drop-unselect{
    moz-user-select: -moz-none; -moz-user-select: none; -o-user-select:none; -khtml-user-select:none;
    -webkit-user-select:none; -ms-user-select:none; user-select:none;
}

.floatscroll{
    background: transparent; height: 19px; line-height: 19px; display: inline-block;
    overflow-x: auto; overflow-y: hidden; position: fixed; width: 1176px; bottom: 0px; right: 0px;
}
.floatscroll .innerdata{ display: inline-block; height: 0px; line-height:0px; } 

.floatheadcls{position: fixed;z-index: 50;top: 0px;}
.floatheadcls .leftbt{border-bottom: none;}
.floatheadcls .lCellw {background: rgba(241, 241, 241, 0.86);}

.csd_menu_div{ text-align: center; height: 40px; line-height: 40px; }
.distable{display: table ;}
.btncls{
	width: 90px; height: 25px; outline: none; border: 1px solid rgba(252, 159, 57, 0.93) !important; 
	border-bottom: 2px solid #FF8400 !important; background: #ea8f2d !important; border-radius: 2px !important; 
	color: #fff !important; font-weight: bold !important; font-size: 1.1em !important;
}
.btncls:hover{ background: #ECA14C !important; }
.btncls:active{ background: #F88400 !important; }

.btnlevel1{
	outline: none !important;border: 1px solid #6D82EC !important; background: #6D82EC !important;
	border-radius: 2px !important;color: #fff !important; font-weight: bold !important; margin-right: 20px !important; 
}
.btnlevel1:hover{ background: #78A5F6 !important; }
.btnlevel1:active{ background: #3475EB !important; }

.btnlevel2{
	outline: none !important;border: 1px solid #C03BE9 !important; background: #CE6DEC !important;
	border-radius: 2px !important;color: #fff !important; font-weight: bold !important; margin-right: 20px !important; 
}

.btnlevel2:active{ background: #BD1AF0 !important; }

.btnlevel3{
	outline: none !important;border: 1px solid #ECA336 !important; background: #ECB96D !important;
	border-radius: 2px !important;color: #fff !important; font-weight: bold !important; margin-right: 20px !important; 
}
.btnlevel3:active{ background: #F09917 !important; }
/**start commons class*/
.mgauto{margin: 0 auto;}
.minh{min-height: 30px;}
.minhfix{min-height: 40px;}
.noTabCell{height: 100%;}
.fol{float: left;}
.ov{overflow: hidden;}
.rCellw{width: auto;}
.lCellw{width: 478px;}
.compwp{width: 100%; position: relative;}
.table_fix{table-layout: fixed !important;}
.mainTabFix{width: 100%; table-layout:fixed; display: table;border-collapse: separate; border-spacing: 0 !important;}
.tabRowFix{table-layout:fixed; display: table-row; border-collapse: separate; border-spacing: 0 !important;}
.tabCellFix{table-layout:fixed; display: table-cell; vertical-align: top;border-collapse: separate;}
.tabRow{ display: table-row; border-collapse: separate; border-spacing: 0 !important;}
.tabCell{ display: table-cell; border-collapse: separate; vertical-align: top;}
.ftb{font-weight: bold;}
.nhide{display: none !important;}
.bg_border_none {border-left: none !important;}
.subloading{top:0px;left:0px;text-align:center;width:100%;height:100%;background-color:#FFF;opacity:0.85;position: relative;  z-index:1000;filter:alpha(opacity=85);background-repeat:no-repeat;background-position:center center;background-image:url('/changemgmt/img/spinner24.gif');}
.pdnone{padding: 0px !important;}
.dn{display: none;}
.ofhide{overflow: hidden;}
.cp{cursor: pointer;}
.cpp{cursor: pointer;}
.cpp.watingpin{
    height: 26px; line-height: 26px; width: 26px; text-align: center; 
    background-color: transparent !important; border: none;
    background-repeat:no-repeat;background-position:center center;background:no-repeat url('/changemgmt/img/spinner24.gif') !important;
}
.trt_trt{cursor: pointer;}
.tc{text-align: center;}
.position_r{ position: relative;}

.pd_lr{padding-right: 5px; padding-left: 3px;}
.border_tb{border-bottom: 1px solid #cbcbcb; border-top: 1px solid #cbcbcb;}
.border_b{border-bottom: 1px solid #cbcbcb; }
.border_r{border-right: 1px solid #cbcbcb; }
.trhfix{height: 40px; vertical-align: middle; }
.td_hfix {height: 25px; vertical-align: middle;}
.fixthh{height: 25px; vertical-align: middle; white-space:nowrap !important;}
.inputcls{width: 90%; max-width: 90%; text-align: right;}
.inner_input_cls input[type="text"]{
	width: 97%; text-align: right; height: 15px; line-height: 15px; float: left;
	padding: 0; margin: 0; margin-top: 2px; ;
}
.inner_input_cls span{
	text-align: right; width: 98%; height: 20px; line-height: 20px; float: left; margin-top: 2px;
}
.emptyfix{border: none !important;}
.btnmgr{margin-right: 20px !important;}
/**end commons class*/

/**start quarter head class*/
.tabbotm{border-bottom: 1px solid #cbcbcb;}
.current_cls{overflow: hidden;}
.fixthh{height: 25px; vertical-align: middle; white-space:nowrap !important;}
.tab_head_left{
	height: 40px;  white-space:nowrap !important; overflow: hidden; text-overflow: ellipsis;
	border-right: 1px solid #cbcbcb; border-top: 1px solid rgba(177, 176, 176, 0.33);
    border-left: 1px solid rgba(177, 176, 176, 0.33);
}
.tab_head_list td{
	overflow: hidden; text-overflow: ellipsis;
	text-align: center; height: 40px; vertical-align: middle;
	width: 80px !important; min-width: 80px !important; max-width: 80px !important;
	padding-right: 5px; padding-left: 3px;  white-space:nowrap !important;
	/* border-top: 1px solid #cbcbcb; */
}
.tab_head_data th{}
.tab_head_data th div {text-align: center;}
.cfixmonthw{width: 80px !important; min-width: 80px !important; max-width: 80px !important; vertical-align: middle !important;}
.qtotalCls{width: 80px !important; min-width: 80px !important; max-width: 80px !important; background-color: #F2F5F5;}

.monthCls{
	background-color: #f8f8f8; color:#585a63;
	filter: progid:DXImageTransform.Microsoft.gradient(startColorstr='#fdfdfd', endColorstr='#f0f0f0', GradientType='0');
	background: -moz-linear-gradient(top, #fdfdfd, #f0f0f0); /* Firefox */
	background: -webkit-gradient(linear, left top, left bottom, color-stop(0.1, #fdfdfd), color-stop(0.9, #f0f0f0));
	background: -ms-linear-gradient(top, #fdfdfd 1%, #f0f0f0 90%);
	border-right: 1px solid #cbcbcb; border-right: 1px solid rgba(56, 56, 56, 0.33); 
	border-top: 1px solid #cbcbcb; border-top: 1px solid rgba(177, 176, 176, 0.33);
}

.monthCls.historicalcls{
	background-color: #ffcc99;
	filter: progid:DXImageTransform.Microsoft.gradient(startColorstr='#FFE4C8', endColorstr='#FDC892', GradientType='0');
	background: -moz-linear-gradient(top, rgba(255, 228, 200, 0.72), rgba(255, 204, 153, 0.76)); /* Firefox */
	background: -webkit-gradient(linear, left top, left bottom, color-stop(0.1, rgba(255, 228, 200, 0.72)), color-stop(0.9, rgba(255, 204, 153, 0.76)));
	background: -ms-linear-gradient(top, rgba(255, 228, 200, 0.72), rgba(255, 204, 153, 0.76));
}
.monthCls.currentcls{
	
}
.monthCls.futurecls{
	background-color: #A6D7E8;
	filter: progid:DXImageTransform.Microsoft.gradient(startColorstr='#fcfcfc', endColorstr='#A6D7E8', GradientType='0');
	background: -moz-linear-gradient(top, rgba(199, 235, 255, 0.8), rgba(108, 205, 238, 0.66)); /* Firefox */
	background: -webkit-gradient(linear, left top, left bottom, color-stop(0.1, rgba(199, 235, 255, 0.8)), color-stop(0.9, rgba(108, 205, 238, 0.66)));
	background: -ms-linear-gradient(top, rgba(199, 235, 255, 0.8), rgba(108, 205, 238, 0.66));
}

.bradiuscls{
	border-radius: 7px 7px 7px 7px !important;
	-moz-border-radius: 7px 7px 7px 7px !important;
	-webkit-border-radius: 7px 7px 7px 7px !important;
}

.qtotalCls.headbg{ 
	background-color: #186076;
	filter: progid:DXImageTransform.Microsoft.gradient(startColorstr='#298FB1', endColorstr='#2D8CAC', GradientType='0');
	background: -moz-linear-gradient(top, #298FB1, #2D8CAC); /* Firefox */
	background: -webkit-gradient(linear, left top, left bottom, color-stop(0.1, #298FB1), color-stop(0.9, #2D8CAC));
	background: -ms-linear-gradient(top, #298FB1 1%, #2D8CAC 90%);
	color:#fff;border-right: 1px solid #10708D; 
}

.exp_coll.echd{ cursor: pointer; }
.exp_coll_box{
	float: right;top: -11px;right: -3px; display: inline-block;
	width: 15px;height: 15px;line-height: 15px; position: absolute;
	background: #33748A; color: #f8f8f8;font-size: 1.2em; border-radius: 2px;
	filter: progid:DXImageTransform.Microsoft.gradient(startColorstr='#79B2C5', endColorstr='#77B0C4', GradientType='0');
	background: -moz-linear-gradient(top, #79B2C5, #77B0C4); /* Firefox */
	background: -webkit-gradient(linear, left top, left bottom, color-stop(0.1, #79B2C5), color-stop(0.9, #77B0C4));
	background: -ms-linear-gradient(top, #79B2C5 1%, #77B0C4 90%);
}

.qtotalCls:hover b:last-child{
	filter: progid:DXImageTransform.Microsoft.gradient(startColorstr='#47AECF', endColorstr='#66CEF3', GradientType='0');
	background: -moz-linear-gradient(top, #47AECF, #66CEF3); /* Firefox */
	background: -webkit-gradient(linear, left top, left bottom, color-stop(0.1, #47AECF), color-stop(0.9, #66CEF3));
	background: -ms-linear-gradient(top, #47AECF 1%, #66CEF3 90%);
}

.th_historicalcls{
	/* border-right: 1px solid #363636; */
	/*
	background-color: #363636;  color: #f8f8f8;
	background: -moz-linear-gradient(top, #616161, #696969);  
	background: -webkit-gradient(linear, left top, left bottom, color-stop(0.1, #616161), color-stop(0.9, #696969));
	background: -ms-linear-gradient(top, #616161 1%, #696969 90%);
	*/
	border-right: 1px solid rgba(56, 56, 56, 0.33);
	background-color: #ffcc99;
	filter: progid:DXImageTransform.Microsoft.gradient(startColorstr='#FDC892', endColorstr='#FFE4C8', GradientType='0');
	background: -moz-linear-gradient(top, rgba(255, 204, 153, 0.76), rgba(255, 228, 200, 0.72)); /* Firefox */
	background: -webkit-gradient(linear, left top, left bottom, color-stop(0.1, rgba(255, 204, 153, 0.76)), color-stop(0.9, rgba(255, 228, 200, 0.72)));
	background: -ms-linear-gradient(top, rgba(255, 204, 153, 0.76), rgba(255, 228, 200, 0.72));
	
	border-top-left-radius: 2px;border-top-right-radius: 2px; 
}

.th_currentcls{
	/* border-right: 1px solid #AECF00; */
	/*
	background-color: #AECF00;  color: #f8f8f8;
	background: -moz-linear-gradient(top, #BEE200, #B6D801);  
	background: -webkit-gradient(linear, left top, left bottom, color-stop(0.1, #BEE200), color-stop(0.9, #B6D801));
	background: -ms-linear-gradient(top, #BEE200 1%, #B6D801 90%);
	*/
	background-color: #fdfdfd;
	filter: progid:DXImageTransform.Microsoft.gradient(startColorstr='#f0f0f0', endColorstr='#fdfdfd', GradientType='0');
	background: -moz-linear-gradient(top, #f0f0f0, #fdfdfd); /* Firefox */
	background: -webkit-gradient(linear, left top, left bottom, color-stop(0.1, #f0f0f0), color-stop(0.9, #fdfdfd));
	background: -ms-linear-gradient(top, #f0f0f0 1%, #fdfdfd 90%);
	border-right: 1px solid rgba(56, 56, 56, 0.33);
	border-top-left-radius: 2px; border-top-right-radius: 2px; 
}
.th_futurecls{
	/* border-right: 1px solid #DAD9D9; */
	/*
	background-color: #e7e7e7;  color: #363636;
	background: -moz-linear-gradient(top, #F0F0F0, #EEEEEE); 
	background: -webkit-gradient(linear, left top, left bottom, color-stop(0.1, #F0F0F0), color-stop(0.9, #EEEEEE));
	background: -ms-linear-gradient(top, #F0F0F0 1%, #EEEEEE 90%);
	*/
	background-color: #A6D7E8;
	filter: progid:DXImageTransform.Microsoft.gradient(startColorstr='#A6D7E8', endColorstr='#fcfcfc', GradientType='0');
	background: -moz-linear-gradient(top, rgba(108, 205, 238, 0.66), rgba(199, 235, 255, 0.8)); /* Firefox */
	background: -webkit-gradient(linear, left top, left bottom, color-stop(0.1, rgba(108, 205, 238, 0.66)), color-stop(0.9, rgba(199, 235, 255, 0.8)));
	background: -ms-linear-gradient(top, rgba(108, 205, 238, 0.66), rgba(199, 235, 255, 0.8));
	
	border-top-left-radius: 2px; border-top-right-radius: 2px;
}

.th_historicalcls div{min-height: 26px; line-height: 26px;}
.th_currentcls div{min-height: 26px; line-height: 26px;}
.th_futurecls div{min-height: 26px; line-height: 26px;}
/**end quarter head class*/
	
/**START body class*/
.level1, .level2, .level3, .totcls *::selection{ background:transparent !important; }/*webkit*/
.level1, .level2, .level3, .totcls *::-moz-selection{ background:transparent important;}/*moz*/
.lev0{border-right: 8px solid #94A5FC; padding: 0 !important;}
.lev1{border-right: 8px solid #eebbfe; padding: 0 !important;}
.lev2{border-right: 8px solid #eebbfe; padding: 0 !important;}
.lev3{border-right: 8px solid #FEBC9A; padding: 0 !important;}
.lev4{border-right: 8px solid #AEF59A; padding: 0 !important;}

.level1 span.fcell {
    background-color: #6D82EC; 
    background: -moz-linear-gradient(top, #8699F8, #6D82EC);
    background: -webkit-gradient(linear, left top, left bottom, color-stop(0.1, #8699F8), color-stop(0.9, #6D82EC));
    background: -ms-linear-gradient(top, #8699F8, #6D82EC);
}
.level2 span.fcell {
    background-color: #CE6DEC; 
    background: -moz-linear-gradient(top, rgba(246, 93, 236, 0.76), rgba(222, 45, 220, 0.72));
    background: -webkit-gradient(linear, left top, left bottom, color-stop(0.1, rgba(246, 93, 236, 0.76)), color-stop(0.9, rgba(222, 45, 220, 0.72)));
    background: -ms-linear-gradient(top, rgba(246, 93, 236, 0.76), rgba(222, 45, 220, 0.72));
}
.level3 span.fcell { 
    background-color: #FEBC9A; 
    background: -moz-linear-gradient(top, rgba(240, 170, 98, 0.76), rgba(227, 128, 53, 0.72));
    background: -webkit-gradient(linear, left top, left bottom, color-stop(0.1, rgba(240, 170, 98, 0.76)), color-stop(0.9, rgba(227, 128, 53, 0.72)));
    background: -ms-linear-gradient(top, rgba(240, 170, 98, 0.76), rgba(227, 128, 53, 0.72));
}
.level4 span.fcell { 
    background-color: #AEF59A; 
    background: -moz-linear-gradient(top, rgba(105, 233, 79, 0.76), rgba(55, 208, 69, 0.72));
    background: -webkit-gradient(linear, left top, left bottom, color-stop(0.1, rgba(105, 233, 79, 0.76)), color-stop(0.9, rgba(55, 208, 69, 0.72)));
    background: -ms-linear-gradient(top, rgba(105, 233, 79, 0.76), rgba(55, 208, 69, 0.72));
}

.addsoldbtn{
	height: 20px; z-index: 5; position: absolute; left: 18px; display: none; 
}	
.search_img{
    width: 16px; height: 16px; cursor: pointer; 
    position: relative; top: 3px; display: inline-block; background-repeat: repeat-x;
}
.search_img:HOVER input{
	display: block; left: 0px; top: -3px; z-index: 18;
}
.del_img{
	width: 16px; height: 16px; line-height: 16px; display: inline-block; z-index: 10;
	cursor: pointer; margin-left: 6px; top: 2px; position: absolute; right: -303px;
}
.del_img.l2{ right: -274px; }
.del_img.l3{ right: -244px; }
.del_img:HOVER input{ position: absolute; display: block; left: -46px; top: -3px; }
.del_img:HOVER input.btnlevel2{ position: absolute; display: block; left: -34px; top: -3px; }
.del_img:HOVER input.btnlevel3{ position: absolute; display: block; left: -30px; top: -3px; }
.del_img:hover span{
	position: fixed;display: inline-block;z-index: 90;background: red;margin-left: 28px; padding: 1px 8px;
}
.del_msg{ display: none; }
@-moz-document url-prefix(){
	.del_img:HOVER input{ position: absolute; display: block; left: -53px; top: -3px; }
	.del_img:HOVER input.btnlevel2{ position: absolute; display: block; left: -42px; top: -3px; }
	.del_img:HOVER input.btnlevel3{ position: absolute; display: block; left: -38px; top: -3px; }
}
.min_partbox{ min-height: 15px; min-width: 17px; }

.reload_span{position: absolute; z-index: 15;}
.reload_span:hover b.reload_msg{
	height: 25px;line-height: 25px;margin-left: 2px; display: inline-block;
	background: rgb(235, 110, 110); padding: 0px 5px; position: fixed;
}
.reload_img{
	width: 25px; height: 25px; line-height: 25px; display: block;
	float: left; background-position: 0px -1px;
}
.reload_msg{display: none;}

.rtbodycls td{
	overflow: hidden; text-overflow: ellipsis;
	text-align: right; height: 30px; vertical-align: middle;
	width: 80px !important; min-width: 80px !important; max-width: 80px !important;
	padding-right: 5px; padding-left: 3px;  white-space:nowrap !important;
	border-bottom: 1px solid #cbcbcb; border-right: 1px solid #cbcbcb;
}
.ltbodycls td{
	text-align: left; height: 30px; vertical-align: middle; overflow: hidden;
	padding-right: 5px; padding-left: 3px;  white-space:nowrap !important;
	border-bottom: 1px solid #cbcbcb; text-overflow: ellipsis;
}
/*
.overbody tr:hover td{ background-color: #e3f3ff !important; }
.overbodybg td{ background-color: #e3f3ff !important; }
*/
.overbody tr.level0:hover td{ background-color: #f3f3f3 !important; }
.overbody tr.level1:hover td{ background-color: #e3f3ff !important; }
.overbody tr.level2:hover td{ background-color: #FBF0FF !important; }
.overbody tr.level2_2:hover td{ background-color: #F5F5F5 !important; }
.overbody tr.level3:hover td{ background-color: #FFF4EF !important; }
.overbody tr.level4:hover td{ background-color: #F3FFF0 !important; }

.level0.overbodybg td{ background-color: #f3f3f3 !important; }
.level1.overbodybg td{ background-color: #e3f3ff !important; }
.level2.overbodybg td{ background-color: #FBF0FF !important; }
.level2_2.overbodybg td{ background-color: #F5F5F5 !important; }
.level3.overbodybg td{ background-color: #FFF4EF !important; }
.level4.overbodybg td{ background-color: #EDFFE8 !important; }

.overbody tr.rlevel0:hover td{ background-color: #f3f3f3 !important; }
.overbody tr.rlevel1:hover td{ background-color: #e3f3ff !important; }
.overbody tr.rlevel2:hover td{ background-color: #FBF0FF !important; }
.overbody tr.rlevel2_2:hover td{ background-color: #F5F5F5 !important; }
.overbody tr.rlevel3:hover td{ background-color: #FFF0E8 !important; }
.overbody tr.rlevel4:hover td{ background-color: #F3FFF0 !important; }

.rlevel0.overbodybg td{ background-color: #f3f3f3 !important; }
.rlevel1.overbodybg td{ background-color: #e3f3ff !important; }
.rlevel2.overbodybg td{ background-color: #FBF0FF !important; }
.rlevel2_2.overbodybg td{ background-color: #F5F5F5 !important; }
.rlevel3.overbodybg td{ background-color: #FFF0E8 !important; }
.rlevel4.overbodybg td{ background-color: #F3FFF0 !important; }

.ltbodycls td:last-child{ border-right: 1px solid #cbcbcb; }
.ltbodycls td:first-child{ border-left: 1px solid #cbcbcb; }
.fieldwidth{ width: 130px !important; }
.dis_ib{ display: inline; height: auto; position: relative; }
@-moz-document url-prefix(){ .dis_ib {display: inline;} }
.namecell{display: inline;}
.fontcell{ font-size: 1.3em; display: inline-block; top: 2px; height: 22px; line-height: 22px; position: relative; }
.fcell{
	height: 16px; line-height: 16px; width: 15px; text-align: center; display: inline-block;
	background-color: #363636; color: #fff; font-size: 1.2em; position: relative;
	background: -moz-linear-gradient(top, rgba(66, 66, 66, 0.76), rgba(19, 19, 19, 0.72)); /* Firefox */
	background: -webkit-gradient(linear, left top, left bottom, color-stop(0.1, rgba(66, 66, 66, 0.76)), color-stop(0.9, rgba(19, 19, 19, 0.72)));
	background: -ms-linear-gradient(top, rgba(66, 66, 66, 0.76), rgba(19, 19, 19, 0.72));

}
.aspcell.wating{
	height: 26px; line-height: 26px; width: 26px; text-align: center; 
	background-color: transparent !important; display: inline-block;
	background-repeat:no-repeat;background-position:center center;background:url('/changemgmt/img/spinner24.gif') !important;
}
.aspcell.reload_img{
	float: none; display: inline-block;	cursor: pointer; position: relative;
}
.aspcell.reload_img:hover b{
	display: inline-block; position: fixed; background: rgb(253, 87, 87); margin-left: 25px; z-index: 10; padding: 0px 7px;
}
.fcell.wating{
	height: 26px; line-height: 26px; width: 26px; text-align: center; 
	background-color: transparent !important; 
	background-repeat:no-repeat;background-position:center center;background: no-repeat url('/changemgmt/img/spinner24.gif') !important;
}
.del_img.wating{
	height: 26px; line-height: 26px; width: 26px; text-align: center; 
	background-color: transparent !important; position: absolute; top: -3px;
	background-repeat:no-repeat;background-position:center center;background-image:url('/changemgmt/img/spinner24.gif');
}

.cellbox{display: inline-block; }
.pin{
	height: 14px; line-height: 14px; width: 14px; text-align: center; border: 1px solid #DADADA; 
	color: #fff; font-size: 1.2em; margin-left: 10px; background-color: transparent !important; cursor: pointer;
}
.pin.spin{ background-position: -129px -146px; }
.pin.watingpin{
	height: 26px; line-height: 26px; width: 26px; text-align: center; 
	background-color: transparent !important; border: none;
	background-repeat:no-repeat;background-position:center center;background-image:url('/changemgmt/img/spinner24.gif');
}
.pppin{position: relative;  top: 3px;}
.mgleft{margin-left: 5px;}
.mgleft.l2{margin-left: 34px;}
.mgleft.l3{margin-left: 63px;}
.mgleft1{margin-left: 5px;}
.mgleft22{margin-left: 34px;}
.mgleft2{margin-left: 60px;}
.mgleft3{margin-left: 90px;}
.mgleft4{margin-left: 129px;}

.textcss{ text-decoration: underline; cursor: pointer;}
.textcss:hover{ color: rgb(73, 87, 248); font-weight: bold; }

.inputcls{width: 90%; max-width: 90%; text-align: right;}

.berrormsg{ margin-left: 35px;position: absolute;border: 1px solid #E63C3C;background: #fff; display: none;}
.refs_d{ position: absolute;z-index: 10; background: #F8F8F8; cursor: default;  z-index: 20;}
.ref_head{
	background-color: #186076;
	filter: progid:DXImageTransform.Microsoft.gradient(startColorstr='#25809E', endColorstr='#0d5268', GradientType='0');
	background: -moz-linear-gradient(top, #25809E, #0d5268) !important; /* Firefox */
	background: -webkit-gradient(linear, left top, left bottom, color-stop(0.1, #25809E), color-stop(0.9, #0d5268)) !important;
	background: -ms-linear-gradient(top, #25809E 1%, #0d5268 90%) !important;
	color:#fff;border-right: 1px solid #186076; 
}

.refstatus_d{
	background: rgba(113, 154, 150, 0.298039); text-align:center; left:0px; position: fixed;width: 100%;height: 100%;z-index: 9000;top: 0px;
}

.ref_head_list td{
	overflow: hidden; text-overflow: ellipsis;
	text-align: center; height: 40px; vertical-align: middle;
	width: 60px !important; min-width: 60px !important; max-width: 60px !important;
	padding-right: 5px; padding-left: 3px;  white-space:nowrap !important;
	border-bottom: 1px solid #cbcbcb; border-top: 1px solid #cbcbcb;
}
.reft_body_cls td{
	border-bottom: 1px solid #cbcbcb; height: 40px;
}

.refstatus{
	width: 30px;line-height: 30px;height: 30px;background: #D7CBCB;margin: 0 auto;
}
.refstatus.err{ background: #C95151; }
.refstatus.scu{ background: #51C957; }
.refstatus.str{ background: #517BC9; }
.reftdbr{border-right: 1px solid #186076;}
.refstatus:hover b{display: block !important; padding: 0px 10px;}
/**END body class*/
	

/** START edit box */
	
#edit_right_tbody tr:hover{ background: #e3f3ff; }	

#edit_thead tr.tab_head_data th{border-top: 1px solid #cbcbcb;}
#edit_thead tr.tab_head_list td{border-bottom: 1px solid #cbcbcb;}
.popup_box.editbox{ width: 80% !important; left: 10%; min-height: 245px; max-height: 245px; top: 28%;}
.editboxbottom{margin-top: 10px; width: 100%; height: 30px; line-height: 30px; text-align: center;}
.editheadfix{border-top: 1px solid #cbcbcb; border-left:1px solid #cbcbcb; border-bottom: 1px solid #cbcbcb;}
.editleftw{width: 180px !important;}	
.edittitle{color: rgb(35, 56, 211); height: 30px; line-height: 30px; position: relative;text-align: center;font-weight: bold;font-size: 1.5em;}
.editboxcontent{width: 99%; position: relative; height: 99%;overflow: hidden;}
.editboxpack{ display: inline-block;position: relative;margin-top: 5px;margin-left: 8px;width: 100%;height: 100%;overflow: hidden; }

.changecolor{color: rgb(0, 10, 255);}
/** END edit box */

/** START POPUP BOX */
.popup_main{
	top:0px;left:0px;text-align:center;width:100%;height:100%;background-color:#FFF;opacity:0.85;position:fixed;z-index:100;filter:alpha(opacity=85);background-repeat:no-repeat;background-position:center center;
}
.popup_box{
	z-index: 300;width: 55%; height: 50%; position: fixed; top: 10%;bottom: 10%;margin: 0 auto;
	filter: progid:DXImageTransform.Microsoft.gradient(enabled='true', startColorstr='#7f787676', endColorstr='#7f787676');
	background: rgba(237, 237, 237, 0.4); left: 24%;
	border: 5px solid #9DB3F0; min-height: 500px; box-shadow: 1px 2px 5px #616161;
}

.popup_box_content{ position: relative; margin:5px 10px 20px; height: 98%; min-height: 490px; overflow: hidden; }
.popup_box_title{ color: #000; font-size: 1.3em; font-weight: bold; text-align: left; padding: 4px 0px 0px; position: relative;}
.popup_box_box{ height: 410px; margin-top: 10px; margin-bottom: 10px; }
.popup_box_box_title{ height: 26px; overflow: hidden; height: auto;}
.popup_box_box_content{ background: rgb(247, 247, 247); height: 385px; overflow-y: scroll; }
.popup_box_bottom{ margin-top: 10px; text-align: center; }
.popup_box_bottom input[type="button"]{width: 150px; text-align: center;}

.popup_loading{
	font-size: 1.2em; line-height: 200px; color: #F00;
	position: absolute; height: 425px; width: 100%; text-align: center;
	background-color:#FFF;opacity:0.85; z-index:300;filter:alpha(opacity=85);background-repeat:no-repeat;background-position:center center;
	background-image:url('/changemgmt/img/spinner24.gif');
}

#popupbody tr:hover{ background: #e3f3ff; }

.tdheight{height: 25px;}
.tdborder_br{ border-bottom: 1px solid #cbcbcb; border-right: 1px solid #cbcbcb;}
.pupup_tab{
	border-top: 1px solid #cbcbcb; border-left: 1px solid #cbcbcb; width: 100%;
}
.popup_td{padding: 0px 7px; }
#popuphead td{
	background: #9DB3F0; font-weight: bold; font-size: 1.2em;
}
.popup_ckboxtd{
	width: 30px; text-align: center;
}
/** END POPUP BOX */
	
/** START Progress bar*/
#saveProgressCover{display: none; top:0px;left:0px;text-align:center;width:100%;height:100%;background-color:#FFF;opacity:0.85;position:fixed;z-index:1000;filter:alpha(opacity=85);background-repeat:no-repeat;background-position:center center; }
#saveProgressCoverBox{display: none; top:0px;left:0px;text-align:center;width:100%;height:100%; position:fixed;z-index:2000; background-repeat:no-repeat;background-position:center center; }

.progressbar{	
	width:650px;font-size:80%;border:1px #000 solid; margin:20px auto;padding:15px;
	position:relative;-moz-border-radius: 3px;-webkit-border-radius: 3px; text-align: center; top: 40%;
}
.progresserror{
	width: 300px; position: absolute; right: 8%; 
	border:1px solid #AAA; -moz-border-radius: 3px;-webkit-border-radius: 3px;
}
.progress_tab{
	width: 100%; table-layout: fixed; text-align: right;
}

.progress_td{height: 25px; text-align: right; padding: 0px 5px; font-weight: bold;}
.progress_br{border-right: 1px solid #AAA;}
.progress_bt{border-bottom: 1px solid #AAA;}
.p_scuess{ color: #65B914; }
.p_error{ color: #E02E21; }
.showerror{
	width: 600px; position: absolute; background-color: #FFF; right: 8%; z-index: 5000;
	border: 1px solid #AAA;-moz-border-radius: 3px;-webkit-border-radius: 3px;top: 10%;
}
.ui-progressbar { position: relative; }
.progress-label {
    position: absolute; left: 50%; top: 19px;
    font-weight: bold; text-shadow: 1px 1px 0 #fff;
}
.progressbarbtn_div{ top: 41%; position: relative; padding: 10px; background-color: #0E7CED;}
.restsoldtobox{
	display: none; z-index: 9000; width: 46%;height: 200px;background: #fff;top: 27%; left: 28%; 
	position: absolute; text-align: center; border: 1px solid #A2A2A2;
}
.restsoldbtn{
	height: 30px;line-height: 30px; position: relative;
}
.restsoldmsg{
	position: relative;height: 110px;line-height: 110px; position: relative;
	color: red;font-size: 1.2em;font-weight: bold;
}
/** END Progress bar*/

