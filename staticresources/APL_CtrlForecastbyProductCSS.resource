html,body{ margin:0px; height:100%; }
input{outline:none !important;} 

#loading-curtain-div{top:0px;left:0px;text-align:center;width:100%;height:100%;background-color:#FFF;opacity:0.85;position:fixed;z-index:8000;filter:alpha(opacity=85);background-repeat:no-repeat;background-position:center center;background-image:url('/changemgmt/img/spinner24.gif');}

.brelaycls{ 
	position: absolute; right: 0; margin-right: 5px; display: inline-block; background-color: #fff; 
	border: 1px solid #D4D2D2; padding: 0px 5px;
}
.ref_cover{ position: relative;line-height: 20px;height: 20px;text-align: center; }
.ref_box{
    line-height: 20px;text-align: center;
    display: inline-block;width: 20px;height: 20px;margin-left: 2px;background: #517BC9; color: #fff; cursor: default;
}
.ref_box:hover b.ref_msg{ display: inline-block; }
.ref_msg{ margin-left: 4px;position: absolute;border: 1px solid #E63C3C;background: #fff;height: 19px;
    line-height: 19px; display: none; z-index: 10; color: #000;
}
.highLighted{
    display: inline-block; background-color: red; width: 4px; height: 28px; position: absolute; margin-top: -6px; margin-left: -2px;
}
.topcls{
    position: absolute; display: block; float: right; right: 0px; top: 0px;
}
.btmcls{
      position: absolute; display: block; float: right; right: 0px; bottom: 0px; background-color: rgb(179, 225, 254);
}
.floatscroll{
    background: transparent; height: 19px; line-height: 19px; display: inline-block;
    overflow-x: auto; overflow-y: hidden; position: fixed; width: 1176px; bottom: 0px; right: 0px;
}
.floatscroll .innerdata{ display: inline-block; height: 0px; line-height:0px; } 

.floatheadcls{position: fixed;z-index: 50;top: 0px;}
.floatheadcls .leftbt{border-bottom: none;}
.floatheadcls .lCellw {background: rgba(241, 241, 241, 0.86);}
.loginascls{
      display: inline-block; border: 1px solid #D4D4D4; padding: 5px 5px; margin-right: 10px; font-weight: bold; color: rgb(1, 0, 255);
}
.artboxopcls{text-align: center;height: 40px;line-height: 40px;}
.artboxopcls1{text-align: center;height: 80px;line-height: 40px;}
.artboxopcls1 .labelbox{ display: inline-block; border: 1px solid #B5B5B5; padding: 0px 5px; margin: 0px 5px; }
.fancytree-title{width: 80%;}
.fancytree-title span.pcls{ display: inline-block; width: 100%; }
.tc{text-align: center;}
.menu_divcls{margin-top: 20px; margin-bottom: 20px;}
.menu_code_box{display: inline-block; margin-left: 20px; border-bottom: 1px solid #ECE6E6;}
.group_menu{margin-left: 30px;}

.treecls {min-width: 80%;}
.treecls td:first-child{padding-top: 4px;}
.treecls th, td {padding-left: 5px; padding-right: 5px;}
.treehead{
    /* background: url("/img/alohaSkin/grid_headerbg.gif") repeat-x scroll 0 bottom white; */
    /*
    background-color: #186076;
    filter: progid:DXImageTransform.Microsoft.gradient(startColorstr='#25809E', endColorstr='#0d5268', GradientType='0');
    background: -moz-linear-gradient(top, #25809E, #0d5268);
    background: -webkit-gradient(linear, left top, left bottom, color-stop(0.1, #25809E), color-stop(0.9, #0D5268));
    background: -ms-linear-gradient(top, #25809E 1%, #0d5268 90%); 
    color: #FFF; border-top: 1px solid #CBCBCB; 
    */
    background-color: #186076;
    filter: progid:DXImageTransform.Microsoft.gradient(startColorstr='#298FB1', endColorstr='#2D8CAC', GradientType='0');
    background: -moz-linear-gradient(top, #298FB1, #2D8CAC); /* Firefox */
    background: -webkit-gradient(linear, left top, left bottom, color-stop(0.1, #298FB1), color-stop(0.9, #2D8CAC));
    background: -ms-linear-gradient(top, #298FB1 1%, #2D8CAC 90%);
    color:#fff;border-right: 1px solid #10708D; 
    border-bottom: 1px solid #CBCBCB;
    
}
.treeheadleft{ border-left: 1px solid #EDEDED; }
.treeheadright{ border-right: 1px solid #EDEDED; }
.treebodycls tr td, .treeheadcls tr th{height: 30px;}
.displaynamecls{width: 80%;}
.requiredInput{position: relative; }
.requiredInput .requiredBlock{ background-color: #c00; position: absolute; left: -4px; width: 3px; top: 1px; bottom: 1px; }


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
.nhide{display: none !important;}
.bg_border_none {border-left: none !important;}
.subloading{top:0px;left:0px;text-align:center;width:100%;height:100%;background-color:#FFF;opacity:0.85;position: relative;  z-index:1000;filter:alpha(opacity=85);background-repeat:no-repeat;background-position:center center;background-image:url('/changemgmt/img/spinner24.gif');}
.pdnone{padding: 0px !important;}
.dn{display: none;}
.ofhide{overflow: hidden;}
.cp{cursor: pointer;}
.trt_trt{cursor: pointer;}
.tc{text-align: center;}
.zidxInput{z-index: 10; }
.p_r{position: relative;}
.pd_lr{padding-right: 5px; padding-left: 3px;}
.border_tb{border-bottom: 1px solid #cbcbcb; border-top: 1px solid #cbcbcb;}
.border_b{border-bottom: 1px solid #cbcbcb; }
.border_r{border-right: 1px solid #cbcbcb; }
.trhfix{height: 40px; vertical-align: middle; }
.td_hfix {height: 25px; vertical-align: middle;}
.fixthh{height: 25px; vertical-align: middle; white-space:nowrap !important;}
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
.tab_head_data th{padding-left: 5px;}
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
    
}
.monthCls.currentcls{
    
}
.monthCls.futurecls{

}
.monthCls.currentc{
    background-color: #A6D7E8;
    filter: progid:DXImageTransform.Microsoft.gradient(startColorstr='#fcfcfc', endColorstr='#A6D7E8', GradientType='0');
    background: -moz-linear-gradient(top, #fcfcfc, #A6D7E8); /* Firefox */
    background: -webkit-gradient(linear, left top, left bottom, color-stop(0.1, #fcfcfc), color-stop(0.9, #A6D7E8));
    background: -ms-linear-gradient(top, #fcfcfc 1%, #A6D7E8 90%);
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
.futuretotalcls{
    background-color: #B9B9B9;
    filter: progid:DXImageTransform.Microsoft.gradient(startColorstr='#298FB1', endColorstr='#2D8CAC', GradientType='0');
    background: -moz-linear-gradient(top, #298FB1, #2D8CAC);
    background: -webkit-gradient(linear, left top, left bottom, color-stop(0.1, #BABABA), color-stop(0.9, #5D5D5D));
    background: -ms-linear-gradient(top, #298FB1 1%, #2D8CAC 90%);
    color: #fff; border-right: 1px solid #10708D;
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
.exp_coll_box.ectotal{
    top: 9px; cursor: pointer;
}
.qtotalCls:hover b:last-child{
    filter: progid:DXImageTransform.Microsoft.gradient(startColorstr='#47AECF', endColorstr='#66CEF3', GradientType='0');
    background: -moz-linear-gradient(top, #47AECF, #66CEF3); /* Firefox */
    background: -webkit-gradient(linear, left top, left bottom, color-stop(0.1, #47AECF), color-stop(0.9, #66CEF3));
    background: -ms-linear-gradient(top, #47AECF 1%, #66CEF3 90%);
}

.th_historicalc{
    background-color: #363636; border-right: 1px solid #363636;color: #f8f8f8;
    background: -moz-linear-gradient(top, #616161, #272727); /* Firefox */
    background: -webkit-gradient(linear, left top, left bottom, color-stop(0.1, #616161), color-stop(0.9, #272727));
    background: -ms-linear-gradient(top, #616161 1%, #272727 90%);
    border-top-left-radius: 10px;border-top-right-radius: 10px;border-top: 1px solid #C4C2C2;
}
.th_current{
    background-color: #AECF00; border-right: 1px solid #AECF00; color: #f8f8f8;
    background: -moz-linear-gradient(top, #AECF00, #9CB321); /* Firefox */
    background: -webkit-gradient(linear, left top, left bottom, color-stop(0.1, #AECF00), color-stop(0.9, #9CB321));
    background: -ms-linear-gradient(top, #AECF00 1%, #9CB321 90%);
    border-top-left-radius: 10px;border-top-right-radius: 10px;border-top: 1px solid #C4C2C2;
}
.th_futurec{
    background-color: #e7e7e7; border-right: 1px solid #DAD9D9;color: #363636;
    background: -moz-linear-gradient(top, #fcfcfc, #e6e6e6); /* Firefox */
    background: -webkit-gradient(linear, left top, left bottom, color-stop(0.1, #fcfcfc), color-stop(0.9, #e6e6e6));
    background: -ms-linear-gradient(top, #fcfcfc 1%, #e6e6e6 90%);
    border-top-left-radius: 10px; border-top-right-radius: 10px; border-top: 1px solid #C4C2C2;
}

.th_historicalcls div{min-height: 26px; line-height: 26px;}
.th_currentcls div{min-height: 26px; line-height: 26px;}
.th_futurecls div{min-height: 26px; line-height: 26px;}

.floatheadcls{position: fixed;z-index: 50;top: 0px;}
.floatheadcls .leftbt{border-bottom: none;}
.floatheadcls .lCellw {background: rgba(241, 241, 241, 0.86);}
/**end quarter head class*/


/**START body class*/
.distable{display: table;}
.level1, .level2, .level3, .totcls *::selection{ background:transparent !important; }/*webkit*/
.level1, .level2, .level3, .totcls *::-moz-selection{ background:transparent important;}/*moz*/
.lev1{border-right: 8px solid #8F8F8F; padding: 0 !important;}
.lev2{border-right: 8px solid #eebbfe; padding: 0 !important;}
.lev3{border-right: 8px solid #FEBC9A; padding: 0 !important;}
.lev4{border-right: 8px solid #AEF59A; padding: 0 !important;}
.lev5{border-right: 8px solid #F7DDA2; padding: 0 !important;}

.level1 span.fcell {
    background-color: #363636;
    /*
    background: -moz-linear-gradient(top, rgba(246, 93, 236, 0.76), rgba(222, 45, 220, 0.72));
    background: -webkit-gradient(linear, left top, left bottom, color-stop(0.1, rgba(246, 93, 236, 0.76)), color-stop(0.9, rgba(222, 45, 220, 0.72)));
    background: -ms-linear-gradient(top, rgba(246, 93, 236, 0.76), rgba(222, 45, 220, 0.72));
    */
}
.level2 span.fcell { 
    background-color: #363636;
    /*
    background: -moz-linear-gradient(top, rgba(240, 170, 98, 0.76), rgba(227, 128, 53, 0.72));
    background: -webkit-gradient(linear, left top, left bottom, color-stop(0.1, rgba(240, 170, 98, 0.76)), color-stop(0.9, rgba(227, 128, 53, 0.72)));
    background: -ms-linear-gradient(top, rgba(240, 170, 98, 0.76), rgba(227, 128, 53, 0.72));
    */
}
.level3 span.fcell { 
    background-color: #363636;
    /*
    background-color: #AEF59A; 
    background: -moz-linear-gradient(top, rgba(105, 233, 79, 0.76), rgba(55, 208, 69, 0.72));
    background: -webkit-gradient(linear, left top, left bottom, color-stop(0.1, rgba(105, 233, 79, 0.76)), color-stop(0.9, rgba(55, 208, 69, 0.72)));
    background: -ms-linear-gradient(top, rgba(105, 233, 79, 0.76), rgba(55, 208, 69, 0.72));
    */
}
.level4 span.fcell { 
    background-color: #363636;
    /*
    background-color: #AEF59A; 
    background: -moz-linear-gradient(top, rgba(105, 233, 79, 0.76), rgba(55, 208, 69, 0.72));
    background: -webkit-gradient(linear, left top, left bottom, color-stop(0.1, rgba(105, 233, 79, 0.76)), color-stop(0.9, rgba(55, 208, 69, 0.72)));
    background: -ms-linear-gradient(top, rgba(105, 233, 79, 0.76), rgba(55, 208, 69, 0.72));
    */
}
.level5 span.fcell { 
    background-color: #363636;
    /*
    background-color: #AEF59A; 
    background: -moz-linear-gradient(top, rgba(105, 233, 79, 0.76), rgba(55, 208, 69, 0.72));
    background: -webkit-gradient(linear, left top, left bottom, color-stop(0.1, rgba(105, 233, 79, 0.76)), color-stop(0.9, rgba(55, 208, 69, 0.72)));
    background: -ms-linear-gradient(top, rgba(105, 233, 79, 0.76), rgba(55, 208, 69, 0.72));
    */
}
.namecell {max-width: 120px;}
.min_partbox{ min-height: 15px; min-width: 17px; }

.reload_span{position: absolute; z-index: 15;}
.reload_span:hover b.reload_msg{
    height: 25px;line-height: 25px;margin-left: 2px; display: inline-block;
    background: rgb(235, 110, 110); padding: 0px 5px; position: absolute;
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

.overbody tr:hover td{ background-color: #e3f3ff !important; }
.overbodybg td{ background-color: #e3f3ff !important; }

.ltbodycls td:last-child{ border-right: 1px solid #cbcbcb; }
.ltbodycls td:first-child{ border-left: 1px solid #cbcbcb; }
.fieldwidth{ width: 130px !important; border-right: 1px solid #cbcbcb; position: relative;}
.commentbtn{ position: absolute;top: 3px;right: 2px; display: none;}
.level1.mark:hover .commentbtn{display: inline-block;}

.popup_boxCmt{
    top: 20% !important; width: 40% !important; min-height: 290px !important; left: 30% !important; max-height: 290px;
}

.mark_img{
    width: 22px; height: 22px; background-repeat:no-repeat; top: -5px; position: absolute; margin-left: -32px;
}

.mark_img.a{background-position: 0px 1px !important; }
.mark_img.c{background-position: 0px -29px;!important;}
.mark_img.g{background-position: 0px -58px !important; }
.mark_img.p{background-position: 0px -87px !important; }


.level2.exp td{
    filter: progid:DXImageTransform.Microsoft.gradient(startColorstr='#ffffff', endColorstr='#F6E5FC', GradientType='0');
    background: -webkit-gradient(linear, left top, left bottom, color-stop(0.1, #ffffff), color-stop(0.9, #F6E5FC));
    background: -moz-linear-gradient(top, #ffffff, #F6E5FC); /* Firefox */
    background: -ms-linear-gradient(top, #ffffff 1%, #F6E5FC 90%);
}
.level3.exp td{
    filter: progid:DXImageTransform.Microsoft.gradient(startColorstr='#ffffff', endColorstr='#FFEADF', GradientType='0');
    background: -webkit-gradient(linear, left top, left bottom, color-stop(0.1, #ffffff), color-stop(0.9, #FFEADF));
    background: -moz-linear-gradient(top, #ffffff, #FFEADF); /* Firefox */
    background: -ms-linear-gradient(top, #ffffff 1%, #FFEADF 90%);
}
.level4.exp td{
    filter: progid:DXImageTransform.Microsoft.gradient(startColorstr='#ffffff', endColorstr='#EBFFE6', GradientType='0');
    background: -webkit-gradient(linear, left top, left bottom, color-stop(0.1, #ffffff), color-stop(0.9, #EBFFE6));
    background: -moz-linear-gradient(top, #ffffff, #EBFFE6); /* Firefox */
    background: -ms-linear-gradient(top, #ffffff 1%, #EBFFE6 90%);
}
.level5.exp td{
    filter: progid:DXImageTransform.Microsoft.gradient(startColorstr='#ffffff', endColorstr='#FFF8E8', GradientType='0');
    background: -webkit-gradient(linear, left top, left bottom, color-stop(0.1, #ffffff), color-stop(0.9, #FFF8E8));
    background: -moz-linear-gradient(top, #ffffff, #FFF8E8); /* Firefox */
    background: -ms-linear-gradient(top, #ffffff 1%, #FFF8E8 90%);
}

.rtbodycls tr.level1 td{ }
.rtbodycls tr.level2 td{
    filter: progid:DXImageTransform.Microsoft.gradient(startColorstr='#ffffff', endColorstr='#F6E5FC', GradientType='0');
    background: -webkit-gradient(linear, left top, left bottom, color-stop(0.1, #ffffff), color-stop(0.9, #F6E5FC));
    background: -moz-linear-gradient(top, #ffffff, #F6E5FC); /* Firefox */
    background: -ms-linear-gradient(top, #ffffff 1%, #F6E5FC 90%);
}
.rtbodycls tr.level3 td{
    filter: progid:DXImageTransform.Microsoft.gradient(startColorstr='#ffffff', endColorstr='#FFEADF', GradientType='0');
    background: -webkit-gradient(linear, left top, left bottom, color-stop(0.1, #ffffff), color-stop(0.9, #FFEADF));
    background: -moz-linear-gradient(top, #ffffff, #FFEADF); /* Firefox */
    background: -ms-linear-gradient(top, #ffffff 1%, #FFEADF 90%);
}
.rtbodycls tr.level4 td{
    filter: progid:DXImageTransform.Microsoft.gradient(startColorstr='#ffffff', endColorstr='#EBFFE6', GradientType='0');
    background: -webkit-gradient(linear, left top, left bottom, color-stop(0.1, #ffffff), color-stop(0.9, #EBFFE6));
    background: -moz-linear-gradient(top, #ffffff, #EBFFE6); /* Firefox */
    background: -ms-linear-gradient(top, #ffffff 1%, #EBFFE6 90%);
}
.rtbodycls tr.level5 td{
    filter: progid:DXImageTransform.Microsoft.gradient(startColorstr='#ffffff', endColorstr='#FFF8E8', GradientType='0');
    background: -webkit-gradient(linear, left top, left bottom, color-stop(0.1, #ffffff), color-stop(0.9, #FFF8E8));
    background: -moz-linear-gradient(top, #ffffff, #FFF8E8); /* Firefox */
    background: -ms-linear-gradient(top, #ffffff 1%, #FFF8E8 90%);
}
.distable{display: table;}
.dis_ib{ display: inline; height: auto; position: relative; }
@-moz-document url-prefix(){ .dis_ib {display: inline;} }
.fontcell{ font-size: 1.3em; display: inline-block; top: 2px; height: 22px; line-height: 22px; position: relative; }
.fcell{
    height: 16px; line-height: 16px; width: 15px; text-align: center; display: inline-block;
    color: #fff; font-size: 1.2em; position: relative;
    
    background: -moz-linear-gradient(top, rgba(66, 66, 66, 0.76), rgba(19, 19, 19, 0.72)); /* Firefox */
    background: -webkit-gradient(linear, left top, left bottom, color-stop(0.1, rgba(66, 66, 66, 0.76)), color-stop(0.9, rgba(19, 19, 19, 0.72)));
    background: -ms-linear-gradient(top, rgba(66, 66, 66, 0.76), rgba(19, 19, 19, 0.72));

}
.reloadRef{
    position: absolute; top: -2px; cursor: pointer; width: 25px; height: 25px;
}
.btn.wating{
    width: 115px;text-align: center;background-color: transparent !important;display: inline-block;
    background-repeat: no-repeat;background-position: center center;
    background: no-repeat url('/changemgmt/img/spinner24.gif') !important;
}
.aspcell.wating{
    height: 26px; line-height: 26px; width: 26px; text-align: center; 
    background-color: transparent !important; display: inline-block;margin-top: -12px; position: absolute;
    background-repeat:no-repeat;background-position:center center;background:no-repeat url('/changemgmt/img/spinner24.gif') !important;
}
.aspcell.reload_img{
    float: none; display: inline-block; cursor: pointer; position: relative;
}
.aspcell.reload_img:hover b{
    display: inline-block; position: fixed; background: rgb(253, 87, 87); margin-left: 25px; z-index: 10; padding: 0px 7px;
}
.cftcell.wating, .cftcells.wating{
    height: 26px; line-height: 26px; width: 26px; text-align: center; 
    background-color: transparent !important; display: inline-block;
    background-repeat:no-repeat;background-position:center center;background:no-repeat url('/changemgmt/img/spinner24.gif') !important;
}
.cftcell.reload_img{
    float: none; display: inline-block; cursor: pointer; position: relative;
}
.cftcell.reload_img:hover b{
    display: inline-block; position: fixed; background: rgb(253, 87, 87); margin-left: 25px; z-index: 10; padding: 0px 7px;
}

.fcell.wating{
    height: 26px; line-height: 26px; width: 26px; text-align: center; 
    background-color: transparent !important; 
    background-repeat:no-repeat;background-position:center center;background:no-repeat url('/changemgmt/img/spinner24.gif') !important;
}
.del_img.wating{
    height: 26px; line-height: 26px; width: 26px; text-align: center; 
    background-color: transparent !important; position: absolute; top: -3px;
    background-repeat:no-repeat;background-position:center center;background:no-repeat url('/changemgmt/img/spinner24.gif') !important;
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
    background-repeat:no-repeat;background-position:center center;background:no-repeat url('/changemgmt/img/spinner24.gif') !important;
}
.partpin{position: relative; top: 3px;}
.mgleftxx{margin-left: 60px;}
.mgleft{margin-left: 5px;}
.mgleft.l2{margin-left: 34px;}
.mgleft.l3{margin-left: 96px;}
.mgleft1{margin-left: 10px;}
.mgleft2{margin-left: 40px;}
.mgleft3{margin-left: 69px;}
.mgleft4{margin-left: 98px;}
.mgleft5{margin-left: 127px;}

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