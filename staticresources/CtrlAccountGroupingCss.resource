html,body{ margin:0px; height:100%; }

#loading-curtain-div{top:0px;left:0px;text-align:center;width:100%;height:100%;background-color:#FFF;opacity:0.85;position:fixed;z-index:8000;filter:alpha(opacity=85);background-repeat:no-repeat;background-position:center center;background-image:url('/changemgmt/img/spinner24.gif');}
#saveProgressCover{display: none; top:0px;left:0px;text-align:center;width:100%;height:100%;background-color:#FFF;opacity:0.85;position:fixed;z-index:1000;filter:alpha(opacity=85);background-repeat:no-repeat;background-position:center center; }
#saveProgressCoverBox{display: none; top:0px;left:0px;text-align:center;width:100%;height:100%; position:fixed;z-index:2000; background-repeat:no-repeat;background-position:center center; }

.ref_cover{ position: relative;line-height: 26px;height: 26px;text-align: center; }
.ref_box{
    line-height: 20px;text-align: center;
    display: inline-block;width: 20px;height: 20px;margin-left: 2px;background: #517BC9; color: #fff; cursor: default;
}
.highLighted{
    display: inline-block; background-color: red; width: 4px; height: 28px; position: absolute; margin-left: -2px;
}
.topcls{
    position: absolute; display: block; float: right; right: 0px; top: 0px; font-size: 11px;
}
.btmcls{
      position: absolute; display: block; float: right; right: 0px; bottom: 1px; background-color: rgb(179, 225, 254); font-size: 11px;
}
@-moz-document url-prefix(){
   .highLighted{ margin-left: -2px; }
}
.floatscroll{
    background: transparent; height: 19px; line-height: 19px; display: inline-block;
    overflow-x: auto; overflow-y: hidden; position: fixed; width: 1176px; bottom: 0px; right: 0px;
}
.floatscroll .innerdata{ display: inline-block; height: 0px; line-height:0px; } 

.floatheadcls{position: fixed;z-index: 50;top: 0px;}
.floatheadcls .leftbt{border-bottom: none;}
.floatheadcls .lCellw {background: rgba(241, 241, 241, 0.86);}

.ref_box:hover b.ref_msg{ display: inline-block; }
.ref_msg{ margin-left: 4px;position: absolute;border: 1px solid #E63C3C;background: #fff;height: 19px;
    line-height: 19px; display: none; z-index: 10; color: #000;
}

.absdiv{overflow: hidden;}

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

.subloading{top:0px;left:0px;text-align:center;width:100%;height:100%;background-color:#FFF;opacity:0.85;position: relative;  z-index:1000;filter:alpha(opacity=85);background-repeat:no-repeat;background-position:center center;background-image:url('/changemgmt/img/spinner24.gif');}
.tc{text-align: center; margin: 0 auto;}
.tree_box{
    box-shadow: 0 0 5px #ccc; padding: 10px; border-radius: 5px; min-height: 480px;
}
.treebodycls tr td, .treeheadcls tr th{height: 30px;}

.menu_divcls{margin-top: 20px; margin-bottom: 20px;}
.btnmg_left{margin-left: 10px !important;}
.d-content{font-size: 1.2em; font-weight: bold;}

.code_box{ width: 400px; border-bottom: 1px solid #ECE6E6; }
.code_box div{height: 40px; line-height: 50px; }
.code_box div input[type="button"] {margin-left: 30px;}
.code_box div select{width: 120px;}

.menu_code_box{display: inline-block; margin-left: 20px; border-bottom: 1px solid #ECE6E6;}
.group_menu{margin-left: 30px;}


.treecls {min-width: 80%;}
.treecls td:first-child{padding-top: 4px;}
.treecls th, td {padding-left: 5px; padding-right: 5px;}
.treehead{
    /* background: url("/img/alohaSkin/grid_headerbg.gif") repeat-x scroll 0 bottom white; */
    background-color: #186076;
    filter: progid:DXImageTransform.Microsoft.gradient(startColorstr='#25809E', endColorstr='#0d5268', GradientType='0');
    background: -moz-linear-gradient(top, #25809E, #0d5268);
    background: -webkit-gradient(linear, left top, left bottom, color-stop(0.1, #25809E), color-stop(0.9, #0D5268));
    background: -ms-linear-gradient(top, #25809E 1%, #0d5268 90%); 
    color: #FFF; border-top: 1px solid #CBCBCB; border-bottom: 1px solid #CBCBCB;
}
.treeheadleft{ border-left: 1px solid #EDEDED; }
.treeheadright{ border-right: 1px solid #EDEDED; }
.displaynamecls{width: 97%;}

/* START [am, relay] forecast css */

.cp *::selection{ background:transparent !important; }/*webkit*/
.cp *::-moz-selection{ background:transparent important;}/*moz*/
.trt_trt *::selection{ background:transparent !important; }/*webkit*/
.trt_trt *::-moz-selection{ background:transparent important;}/*moz*/
.a_bg{
    filter: progid:DXImageTransform.Microsoft.gradient(startColorstr='#ffffff', endColorstr='#F6E5FC', GradientType='0');
    background: -webkit-gradient(linear, left top, left bottom, color-stop(0.1, #ffffff), color-stop(0.9, #F6E5FC));
    background: -moz-linear-gradient(top, #ffffff, #F6E5FC); /* Firefox */
    background: -ms-linear-gradient(top, #ffffff 1%, #F6E5FC 90%);
}
.c_bg{
    filter: progid:DXImageTransform.Microsoft.gradient(startColorstr='#ffffff', endColorstr='#FFEADF', GradientType='0');
    background: -webkit-gradient(linear, left top, left bottom, color-stop(0.1, #ffffff), color-stop(0.9, #FFEADF));
    background: -moz-linear-gradient(top, #ffffff, #FFEADF); /* Firefox */
    background: -ms-linear-gradient(top, #ffffff 1%, #FFEADF 90%);
}
.g_bg{
    filter: progid:DXImageTransform.Microsoft.gradient(startColorstr='#ffffff', endColorstr='#EBFFE6', GradientType='0');
    background: -webkit-gradient(linear, left top, left bottom, color-stop(0.1, #ffffff), color-stop(0.9, #EBFFE6));
    background: -moz-linear-gradient(top, #ffffff, #EBFFE6); /* Firefox */
    background: -ms-linear-gradient(top, #ffffff 1%, #EBFFE6 90%);
}
.p_bg{
    filter: progid:DXImageTransform.Microsoft.gradient(startColorstr='#ffffff', endColorstr='#FFF8E8', GradientType='0');
    background: -webkit-gradient(linear, left top, left bottom, color-stop(0.1, #ffffff), color-stop(0.9, #FFF8E8));
    background: -moz-linear-gradient(top, #ffffff, #FFF8E8); /* Firefox */
    background: -ms-linear-gradient(top, #ffffff 1%, #FFF8E8 90%);
}
.uix-multiselect .option-element{overflow: hidden;}

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
.inputcls{width: 90%; max-width: 90%; text-align: right;}
.inner_input_cls input[type="text"]{
    width: 97%; text-align: right; height: 15px; line-height: 15px; float: left;
    padding: 0; margin: 0; margin-top: 2px; ;
}
.inner_input_cls span{
    text-align: right; width: 98%; height: 20px; line-height: 20px; float: left; margin-top: 2px;
}

.max_h{ /*max-height: 29px; */}

.emptyfix{border: none !important;}
.t_img{
    width: 15px; height: 15px; background-repeat:no-repeat;
    position: absolute; margin-top: 6px;
}

.tpd_1{padding-left: 5px !important;}
.tpd_2{padding-left: 30px !important;}
.tpd_3{padding-left: 57px !important;}
.tpd_4{padding-left: 84px !important;}
.dpd_1{margin-left: 5px; height: 27px;}
.dpd_2{margin-left: 32px;}
.dpd_3{margin-left: 58px;}
.dpd_new3{margin-left: 84px;}
.dpd_4{margin-left: 84px;}
.dpd_5{margin-left: 110px;}
.cbc_cell{margin-left: 10px;}

.mark_img{
    width: 22px; height: 22px; background-repeat:no-repeat;
    position: relative; float: left; margin-top: 2px;
}
.mark_img.fix{margin-top: 2px;}
.mark_img.a{background-position: 0px 1px !important;}
.mark_img.c{background-position: 0px -29px;!important; margin-top: 3px;}
.mark_img.g{background-position: 0px -58px !important; margin-top: 2px;}
.mark_img.p{background-position: 0px -87px !important; margin-top: 2px;}
.mark_img.p.pfix{margin-left: -27px;}


.t_img.a{background-position: 0px 0px !important;}
.t_img.c{background-position: 0px -16px; margin-left: -24px;}
.t_img.c.fix{margin-left: -18px;}
.t_img.g{background-position: 0px -32px;}
.t_img.g.gfix{margin-left: -10px;}
.t_img.g.gfix.ggfix{margin-left: -26px;}
.t_img.p{background-position: 0px -48px; margin-left: -25px;}
.t_img.p.pfix{margin-left: -27px;}

.t_img.rc{background-position: 0px -16px; margin-left: -19px;}
/*.t_img.p.pfix{margin-left: -76px;}*/
.fw{font-weight: bold;}
.a_css{border-right: 8px solid #494949; /* border-bottom: none !important; */ padding: 0 !important;}
.pd_1.a_css{border-right: 8px solid #494949;/* border-bottom: none !important; */ padding: 0 !important;}
.pd_1.c_css{border-right: 8px solid #aec700; /* border-bottom: none !important; */ padding: 0 !important;}
.pd_2.g_css{border-right: 8px solid #2a718b; /* border-bottom: none !important; */ padding: 0 !important;}
.pd_3.p_css{border-right: 8px solid #85AFEA; /* border-bottom: none !important; */ padding: 0 !important;}

.a_css{border-right: 8px solid #eebbfe; /* border-bottom: none !important; */ padding: 0 !important;}
.c_css{border-right: 8px solid #FEBC9A; /* border-bottom: none !important; */ padding: 0 !important;}
.g_css{border-right: 8px solid #AEF59A; /* border-bottom: none !important; */ padding: 0 !important;}
.p_css{border-right: 8px solid #F7DDA2; /* border-bottom: none !important; */ padding: 0 !important;}

.pd_relaypart.p_css{border-right: 8px solid #85AFEA; border-bottom: none !important; padding: 0 !important;}
.pd_part_relay.p_css{border-right: 8px solid #85AFEA; border-bottom: none !important; padding: 0 !important;}
.leftd_td{width: 100%;height: 26px; /*border-bottom: 1px solid #CBCBCB; */}
.pd_r1{padding-left: 23px !important;}
.pd_r1.a_css{border-right: 8px solid #494949; border-bottom: none !important; padding: 0 !important;}
.pd_r1.c_css{border-right: 8px solid #aec700; border-bottom: none !important; padding: 0 !important;}
.pd_r2.g_css{border-right: 8px solid #2a718b; border-bottom: none !important; padding: 0 !important;}
.pd_r3.p_css{border-right: 8px solid #85AFEA; border-bottom: none !important; padding: 0 !important;}
/*
.overbody tr:hover{ background-color: #e3f3ff; }
.overbodybg{ background-color: #e3f3ff; }
.overbody tr:hover td{ border-bottom: 1px dashed #991FC0 !important;border-top: 1px dashed #991FC0 !important; }
.overbodybg td{ border-bottom: 1px dashed #991FC0 !important;border-top: 1px dashed #991FC0 !important; }
*/



.overbody tr:hover td{ background-color: #e3f3ff !important; }
.overbodybg td{ background-color: #e3f3ff !important; }
.fixinfoh{height: 28px; line-height: 28px;}
.fcell{
    height: 16px; line-height: 16px; width: 16px; text-align: center; margin-left: 8px;
    background-color: #363636; color: #fff; font-size: 1.2em; float: left; margin-top: 6px;
}

.fcell.waiting{
    height: 26px; line-height: 26px; width: 26px; text-align: center; 
    background-color: transparent !important; margin-top: 0px;
    background-repeat:no-repeat;background-position:center center;background-image:url('/changemgmt/img/spinner24.gif');
}
.fcell.fix{margin: 0px 10px;}
.fcell.mlfix{margin-left: 15px;}
.fcell.gpfix{margin-left: 14px;}
.scell{margin-left: 10px; overflow: hidden;}
.snamecell{ width: 150px; white-space: nowrap !important; overflow: hidden; text-overflow: ellipsis; }
.delprduct{ 
    position: absolute !important;  float: none !important; display: inline-block !important; 
    margin-top: 5px !important; margin-left: -11px !important; 
}
.delprduct.fixmglf{ margin-left:-11px !important; }
.delprduct.delloaded{
    background: #FBFBFB url('/changemgmt/img/spinner24.gif') no-repeat center center !important;
    width: 26px; height: 26px; margin-left: -19px !important; margin-top: 1px !important; background-color: transparent !important;
}
.delprduct.fixmglf.delloaded{
    background: #FBFBFB url('/changemgmt/img/spinner24.gif') no-repeat center center !important;
    width: 26px; height: 26px; margin-left: -19px !important; margin-top: 1px !important; background-color: transparent !important;
}
.delprduct:hover div.delpcode{display: inline-block; margin-left: -85px; background: transparent !important;}
.delpcode, .deldn{display: none;}

.cellbox{display: inline-block; }
.pin{
    height: 14px; line-height: 14px; width: 14px; text-align: center; border: 1px solid #DADADA; float: left;
    color: #fff; font-size: 1.2em; margin-left: 10px; background-color: transparent important; margin-top: 6px;
}
.pin.spin{ background-position: -129px -146px; }
.pin.waitingpin{
    height: 26px; line-height: 26px; width: 26px; text-align: center; 
    background-color: transparent !important; margin-top: 1px; border: none;
    background-repeat:no-repeat;background-position:center center;background-image:url('/changemgmt/img/spinner24.gif');
}


.spin.ml{ margin-left: 17px; }
.ml.fix{ margin-left: 10px; }
.pin.fixrelay{margin-left: 17px; }

.pin.relayfc{margin-left: 24.5px;}
.relayfc.fixpin{margin-left: 8.5px;}

.pd_total{padding-left: 18px !important;}
.pd_totalsub{padding-left: 120px !important; font-weight: bold;}
.pd_1{padding-left: 28px !important;}
.cls_other_gb{padding-left: 22px !important;}
.pd_2{padding-left: 60px !important;}
.pd_gpl{padding-left: 50px !important;}
.pd_part{padding-left: 78px !important;}
.pd_relaypart{padding-left: 66px !important;}
.pd_part1{padding-left: 104px !important;}
.pd_part2{padding-left: 132px !important;}
.pd_part_relay{padding-left: 77px !important;}
.pd_3{padding-left: 90px !important;}
.tovhide{white-space:nowrap !important; overflow: hidden;}
.pfix{margin-left: 3px;}

.relay_left{ left: 20px !important;}
@-moz-document url-prefix(){
    .reatcls{float: none; display: inline-block;}
    .fmt_cls{top: -4px;}
    .gplsearch, .othersearch{ left: 8px;}
    .relay_left{ left: 8px !important;}
    .field {position: relative; overflow: hidden;}
    .zidxInput{width: 130px; margin-top: -2px; position: absolute; }
    .pin{margin-top: 5px;}
    .cbc_cell{width: 80px;}
    .scell{margin-left: 10px; width: 100px;} 
    .scell.totalw{width: 230px;}
    .scell.gplw{width: 160px;}
    .scell.partw{width: 120px;}
    .cellbox{ float: left; }    
    .fcell{ margin-top: 5px;}   
    .fcell.fix{margin: 5px 10px 0;}
    .fcell.mlfix{margin-left: 12px;}
    .fcell.gpfix{margin-left: 12px;}
    .fcell.waiting{ margin-top: 0px !important; }
    .pd_part{padding-left: 74px !important;}
    .pfix{margin-left: 0px;}
}
.mgauto{margin: 0 auto;}
.noTabCell{height: 100%;}
.fol{float: left;;}
.ov{overflow: hidden;}
.rCellw{width: auto;}
.lCellw{width: 478px;}
.compwp{width: 100%; position: relative;}
.table_fix{table-layout: fixed !important;}
.mainTabFix{width: 100%; table-layout:fixed; display: table;border-collapse: separate; border-spacing: 0;}
.tabRowFix{table-layout:fixed; display: table-row; border-collapse: separate; border-spacing: 0;}
.tabCellFix{table-layout:fixed; display: table-cell; vertical-align: top;border-collapse: separate;}
.tabRow{ display: table-row; border-collapse: separate; border-spacing: 0;}
.tabCell{ display: table-cell; border-collapse: separate; vertical-align: top;}

.tab_head_left{
    height: 40px;  white-space:nowrap !important; overflow: hidden; text-overflow: ellipsis;
    border-bottom: 1px solid #cbcbcb; border-right: 1px solid #cbcbcb; border-top: 1px solid rgba(177, 176, 176, 0.33);
    border-left: 1px solid rgba(177, 176, 176, 0.33);
}
.tab_head_list td{
    overflow: hidden; text-overflow: ellipsis;
    text-align: center; height: 40px; vertical-align: middle;
    width: 80px !important; min-width: 80px !important; max-width: 80px !important;
    padding-right: 5px; padding-left: 3px;  white-space:nowrap !important;
    border-bottom: 1px solid #cbcbcb; border-top: 1px solid #cbcbcb;
}
.rtbodycls td{
    overflow: hidden; text-overflow: ellipsis;
    text-align: right; height: 30px; vertical-align: middle;
    width: 80px !important; min-width: 80px !important; max-width: 80px !important;
    padding-right: 5px; padding-left: 3px;  white-space:nowrap !important;
    border-bottom: 1px solid #cbcbcb; border-right: 1px solid #cbcbcb;
}
.ltbodycls td{
    overflow: hidden; text-overflow: ellipsis;
    text-align: left; height: 30px; vertical-align: middle;
    padding-right: 5px; padding-left: 3px;  white-space:nowrap !important;
    border-bottom: 1px solid #cbcbcb; border-left: 1px solid #cbcbcb; 
}

.berrormsg{
    margin-left: 35px;position: absolute;border: 1px solid #E63C3C;background: #fff;
}
.refs_d{
    position: absolute;z-index: 10; background: #E4E4E4; cursor: default;
}
.pinstatus{ margin: 3px; border: 1px solid #FFF; }

.ref_head{
    background-color: #186076;
    filter: progid:DXImageTransform.Microsoft.gradient(startColorstr='#25809E', endColorstr='#0d5268', GradientType='0');
    background: -moz-linear-gradient(top, #25809E, #0d5268) !important; /* Firefox */
    background: -webkit-gradient(linear, left top, left bottom, color-stop(0.1, #25809E), color-stop(0.9, #0d5268)) !important;
    background: -ms-linear-gradient(top, #25809E 1%, #0d5268 90%) !important;
    color:#fff;border-right: 1px solid #186076; 
}
.refstatus_d{
    background: rgba(113, 154, 150, 0.298039); text-align:center; left:0px; position: fixed;width: 100%;height: 100%;z-index: 800;top: 0px;
}

.ref_head_list td{
    overflow: hidden; text-overflow: ellipsis;
    text-align: center; height: 40px; vertical-align: middle;
    width: 60px !important; min-width: 60px !important; max-width: 60px !important;
    padding-right: 5px; padding-left: 3px;  white-space:nowrap !important;
    border-bottom: 1px solid #cbcbcb; border-top: 1px solid #cbcbcb;
}
.reft_body_cls td{ border-bottom: 1px solid #cbcbcb; height: 40px; }

.refstatus{ width: 30px;line-height: 30px;height: 30px;background: #D7CBCB;margin: 0 auto; }
.refstatus.err{ background: #C95151; }
.refstatus.scu{ background: #51C957; }
.refstatus.str{ background: #517BC9; }
.reftdbr{border-right: 1px solid #186076;}

.errorcls{ 
    border: 1px solid #248CD5; margin-top: -1px;
    position: absolute; background: #FFF; width: auto; padding: 0px 5px; z-index: 10; margin-left: 3px;
}

.floatheadcls{position: fixed;z-index: 10;top: 0px;}
.floatheadcls .leftbt{border-bottom: none;}

.reatcls{float: right; text-align: left; position: relative; margin-top: 2px;}
.reatcls:before{ display: inline-block; }
.reatcls:after{ clear: right; }
.fmt_cls{height: 21px; line-height: 21px; top: -3px; position: relative;}


.ltbodycls .field{ width: 140px; border-right: 1px solid #cbcbcb; }

.tab_head_data th{padding-left: 5px;}
.tab_head_data th div {text-align: center;}
.cfixmonthw{width: 80px !important; min-width: 80px !important; max-width: 80px !important; vertical-align: middle !important;}
.qtotalCls{width: 80px !important; min-width: 80px !important; max-width: 80px !important; background-color: #F2F5F5;}
.monthCls{
    background-color: #f8f8f8;
    filter: progid:DXImageTransform.Microsoft.gradient(startColorstr='#fcfcfc', endColorstr='#e6e6e6', GradientType='0');
    background: -moz-linear-gradient(top, #fcfcfc, #e6e6e6); /* Firefox */
    background: -webkit-gradient(linear, left top, left bottom, color-stop(0.1, #fcfcfc), color-stop(0.9, #e6e6e6));
    background: -ms-linear-gradient(top, #fcfcfc 1%, #e6e6e6 90%);
    border-right: 1px solid #cbcbcb; color:#585a63;
}
.monthCls.currentc{
    background-color: #A6D7E8;
    filter: progid:DXImageTransform.Microsoft.gradient(startColorstr='#fcfcfc', endColorstr='#A6D7E8', GradientType='0');
    background: -moz-linear-gradient(top, #fcfcfc, #A6D7E8); /* Firefox */
    background: -webkit-gradient(linear, left top, left bottom, color-stop(0.1, #fcfcfc), color-stop(0.9, #A6D7E8));
    background: -ms-linear-gradient(top, #fcfcfc 1%, #A6D7E8 90%);
}
.gototopcls{
    background-color: #0199cb; text-align:center !important;
    display:none; top:85%; left:98%; border:1px solid rgb(32, 127, 158); cursor:pointer; width: 30px; 
    height: 30px; line-height: 30px; position: fixed; font-weight: bold; color: #fff;
}
.bradiuscls{
    border-radius: 7px 7px 7px 7px !important;
    -moz-border-radius: 7px 7px 7px 7px !important;
    -webkit-border-radius: 7px 7px 7px 7px !important;
}
.over{opacity:0.65;filter:alpha(opacity=65);}
.qtotalCls.headbg{ 
    background-color: #186076;
    filter: progid:DXImageTransform.Microsoft.gradient(startColorstr='#25809E', endColorstr='#0d5268', GradientType='0');
    background: -moz-linear-gradient(top, #25809E, #0d5268); /* Firefox */
    background: -webkit-gradient(linear, left top, left bottom, color-stop(0.1, #25809E), color-stop(0.9, #0d5268));
    background: -ms-linear-gradient(top, #25809E 1%, #0d5268 90%);
    color:#fff;border-right: 1px solid #186076; 
}

.exp_coll.echd{ cursor: pointer; }
.exp_coll_box{
    float: right;top: -11px;right: -4px; display: inline-block;
    width: 15px;height: 15px;line-height: 15px; position: absolute;
    background: #084151; color: #f8f8f8;font-size: 1.2em;
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
.feve{background-color: #F1F1F1;}



.relay_qcell{height: 100%; position: relative;}
.relay_qcell .scls{display: block; margin-right: 1px; border-bottom: 1px solid #CBCBCB; height: 19px; line-height: 19px;}


.left_actbg{
    filter: progid:DXImageTransform.Microsoft.gradient(startColorstr='#fefefe', endColorstr='#e5e5e5', GradientType='0');
    background: -moz-linear-gradient(top, #fefefe, #e5e5e5); 
    background: -webkit-gradient(linear, left top, left bottom, color-stop(0.1, #fefefe), color-stop(0.9, #e5e5e5));
    background: -ms-linear-gradient(top, #fefefe 1%, #e5e5e5 90%);
}

.other_d, .gpl_d, .part_d{
    display: block; width: 16px; height: 16px; float: left; line-height: 16px; margin-top: 5px; margin-left: 10px;
}
.cellboxwfix{width: 163px;}
.gplsearch, .othersearch{
    left:9px;display: block; width: 16px; height: 16px; float: left; line-height: 16px; margin-top: 4px; position: relative;
}
.reloadbtn{ margin-left:5px; color:red; float:left; }
.errordiv{
    position: absolute; z-index: 11; background: transparent; height: 28px; line-height: 28px; margin-top: -4px; padding: 0px 3px;
}
.errordiv b.borders{
    border: 1px solid #F61515;margin-left: 5px;height: 30px;line-height: 30px;display: inline-block;padding: 0px 10px;
}
.errpart{
    
}
.addpartbtn, .delpartbtn{width: 100px; z-index: 10; margin-top: 2px !important; margin-left: -3px !important;}
.addpartbtn.top_cls{margin-left: 20px !important; width: auto !important;}
.disabled_btn{
    background: #FBFBFB url('/changemgmt/img/spinner24.gif') no-repeat center center !important;
}

.countryimg{
    top: 2px; position: relative; display:inline-block; width:38px; height:21px; line-height:21px;
    background-repeat:no-repeat; background-position: 100px 1px; 
}

.reload_span{ position: absolute; z-index: 9; }
.reload_span.reload_spanfix{ margin-top: 0px; margin-left: -55px;}
.reload_span:hover b{display: inline-block;}
.reload_img{
    width: 26px; height: 26px; line-height: 26px; display: block;
    float: left; margin-top: 1px; background-position: 0px -1px; margin-left: 4px;
}
.reload_img.fixreload{height: 25px; width: 25px;}
.reload_msg{
    margin-left: 8px; font-size: 1.2em; z-index: 10; display: none;
    position: absolute;height: 26px;line-height: 26px;background-color: #FFF;color: #F00; padding: 0px 5px;
}
.reloadRef{
    position: absolute; top: 1px; cursor: pointer; width: 25px; height: 25px;
}
.popup_main{
    top:0px;left:0px;text-align:center;width:100%;height:100%;background-color:#FFF;opacity:0.85;position:fixed;z-index:100;filter:alpha(opacity=85);background-repeat:no-repeat;background-position:center center;
}
.popup_box{
    z-index: 300;width: 55%; height: 50%; position: fixed; top: 10%;bottom: 10%;margin: 0 auto;
    filter: progid:DXImageTransform.Microsoft.gradient(enabled='true', startColorstr='#7f787676', endColorstr='#7f787676');
    background: rgba(237, 237, 237, 0.4); left: 24%;
    border: 5px solid #9DB3F0; min-height: 500px;
}
.popup_box_title{height: 30px; line-height: 30px; color: #000; font-size: 1.3em; font-weight: bold; text-align: left;}
.popup_box_content{ position: relative; margin:5px 10px 20px; height: 98%; min-height: 490px; overflow: hidden; }
.popup_box_bottom{ margin-top: 20px; text-align: center; }
.popup_box_bottom input[type="button"]{width: 150px; text-align: center;}
.popup_loading{
    font-size: 1.2em; line-height: 200px; color: #F00;
    position: absolute; height: 400px; width: 100%; text-align: center;
    background-color:#FFF;opacity:0.85; z-index:300;filter:alpha(opacity=85);background-repeat:no-repeat;background-position:center center;
    background-image:url('/changemgmt/img/spinner24.gif');
}
.popup_search_input{ height:20px; line-height:20px; width: 220px; margin-right: 10px; }
.uix-multiselect{
    
}
.multiselect-selected-list{margin-right: 3px !important;}
.ui-button-icon-only{width: 20px !important; height: 20px !important; line-height: 20px !important;}
.uix-search{width: 87% !important; height: 20px !important; line-height: 20px !important;}
.header-text{height: 22px !important; line-height: 22px !important;}
.option-element div{height: 25px !important; line-height: 25px !important; padding-left: 5px; text-align: left !important;}


.countryimg.AED{ background-position: 3px -37px; }
.countryimg.ARS{ background-position: -385px -269px; }
.countryimg.AUD{ background-position: -256px -236px; }
.countryimg.AZN{ background-position: -40px -340px; }
.countryimg.BAM{ background-position: -386px 0px; }
.countryimg.BBD{ background-position: -83px -340px; }
.countryimg.BDT{ background-position: -255px -72px; }
.countryimg.BGN{ background-position: -212px -137px; }
.countryimg.BHD{ background-position: -126px -340px; }
.countryimg.BND{ background-position: -170px -340px; }
.countryimg.BRL{ background-position: 3px -301px; }
.countryimg.BYR{ background-position: -212px -340px; }
.countryimg.CAD{ background-position: -126px -170Px; }
.countryimg.CHF{ background-position: -298px -107Px; }
.countryimg.CLP{ background-position: -256px -340px; }
.countryimg.CNY{ background-position: 4px 0px; }
.countryimg.COP{ background-position: -84px -170px; }
.countryimg.CRC{ background-position: -298px -340px; }
.countryimg.CZK{ background-position: -40px -269px; }
.countryimg.DKK{ background-position: -384px -106px; }
.countryimg.DOP{ background-position: -341px -340px; }
.countryimg.EEK{ background-position: -384px -340px; }
.countryimg.EGP{ background-position: 3px -376px; }
.countryimg.EUR{ background-position: 3px -137px; }
.countryimg.FJD{ background-position: -39px -376px; }
.countryimg.GBP{ background-position: -255px -107px; }
.countryimg.GTQ{ background-position: -83px -376px; }
.countryimg.HKD{ background-position: -39px -302px; }
.countryimg.HNL{ background-position: -126px -376px; }
.countryimg.HRK{ background-position: -169px -376px; }
.countryimg.HUF{ background-position: -83px -137px; }
.countryimg.IDR{ background-position: -212px -37px; }
.countryimg.ILS{ background-position: -40px -37px; }
.countryimg.INR{ background-position: -169px -37px; }
.countryimg.ISK{ background-position: 3px -106px; }
.countryimg.JPY{ background-position: -126px -72px; }
.countryimg.KRW{ background-position: -384px -37px; }
.countryimg.KWD{ background-position: -255px -37px; }
.countryimg.KZT{ background-position: -341px -269px; }
.countryimg.LKR{ background-position: -83px -0px; }
.countryimg.LTL{ background-position: -212px -269px; }
.countryimg.LVL{ background-position: -126px -107px; }
.countryimg.MAD{ background-position: -212px -236px; }
.countryimg.MKD{ background-position: -126px -269px; }
.countryimg.MOP{ background-position: -212px -376px; }
.countryimg.MVR{ background-position: -255px -376px; }
.countryimg.MXN{ background-position: -298px -376px; }
.countryimg.MYR{ background-position: -384px -72px; }
.countryimg.NIO{ background-position: -342px -376px; }
.countryimg.NOK{ background-position: -40px -137px; }
.countryimg.NPR{ background-position: -167px -72px; }
.countryimg.NZD{ background-position: -298px -236px; }
.countryimg.OMR{ background-position: -384px -376px; }
.countryimg.PAB{ background-position: -254px -170px; }
.countryimg.PEN{ background-position: 3px -410px; }
.countryimg.PHP{ background-position: -297px -72px; }
.countryimg.PKR{ background-position: -211px -72px; }
.countryimg.PLN{ background-position: -298px -135px; }
.countryimg.QAR{ background-position: -39px -410px; }
.countryimg.RON{ background-position: 3px -170px; }
.countryimg.RSD{ background-position: -83px -410px; }
.countryimg.RUB{ background-position: -298px -269px; }
.countryimg.SAR{ background-position: -126px -410px; }
.countryimg.SEK{ background-position: -341px -107px; }
.countryimg.SGD{ background-position: -299px -37px; }
.countryimg.SVC{ background-position: -169px -410px; }
.countryimg.THB{ background-position: -341px -37px; }
.countryimg.TND{ background-position: -341px -203px; }
.countryimg.TRL{ background-position: -84px -72px; }
.countryimg.TRY{ background-position: -84px -72px; }
.countryimg.TTD{ background-position: -212px -410px; }
.countryimg.TWD{ background-position: -255px -410px; }
.countryimg.UAH{ background-position: -256px -269px; }
.countryimg.USD{ background-position: -39px -170px; }
.countryimg.UYU{ background-position: -298px -410px; }
.countryimg.VEB{ background-position: -341px -410px; }
.countryimg.VEF{ background-position: -341px -410px; }
.countryimg.VND{ background-position: -341px -73px; }
.countryimg.ZAR{ background-position: -170px -235px; }

/* END [am, relay] forecast css */