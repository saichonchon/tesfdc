
    .accIconsDiv div{
        width:28px;
        height:28px;
        border:1px solid #d4d4d4;
        border-radius: 4px;
        margin:6px;
        text-align:center;
        float:left;
    }
    .accIconsDiv{
        height: 40px;
        background: #fff;
        margin-bottom: 2px;
    }
    
    .goodIcon{
        width:17px;
        height:18px;
        margin-top: 5px;
        background-position:0px -24px !important;
    }
    .rightIcon{
        width:22px;
        height:13px;
        margin-top: 7px;
        background-position:0px -1px !important;
    }
    .questionIcon{
        width:8px;
        height:14px;
        margin-top: 7px;
        background-position:0px -51px !important;
    }
    
    .settingIcon{
        width:18px;
        height:15px;
        margin-top: 6px;
        background-position:-2px -32px !important;
    }
    .yearIcon{
        width:20px;
        height:11px;
        margin-top: 8px;
        background-position:-30px -26px !important;
    }
    .lampIcon{
        width:11px;
        height:18px;
        margin-top: 5px;
        background-position:-31px -52px !important;
    }
    
    .dotIcon{
        width:16px;
        height:16px;
        margin-top: 6px;
        background-position:-63px 0px !important;
    }
    .squareIcon{
        width:12px;
        height:12px;
        margin-top: 8px;
        background-position:-62px -25px !important;
    }
    
    .oneIcon{
        width:22px;
        height:8px;
        margin-top: 10px;
        background-position:-87px -3px !important;
    }
    .twoIcon{
        width:20px;
        height:15px;
        margin-top: 6px;
        background-position:-91px -26px !important;
    }
    .threeIcon{
        width:22px;
        height:13px;
        margin-top: 7px;
        background-position:-89px -52px !important;
    }
    
    .sureIcon{
        width:18px;
        height:18px;
        margin-top: 5px;
        background-position:-118px 0px !important;
    }

    
    .ctcName{
        color:#ffffff;
    }
	.textSpan{
		width: 180px;
		display: block;
		float: left;
		overflow: hidden;
		white-space: nowrap;
		text-overflow: ellipsis;
	}
	.addStyle{
		background-position: -22px -25px !important;
	}
	.cancelStyle{
		background-position: -250px -25px !important;
	}
    
    body {
        padding:0;
        margin:0;    
        width:100%;
        height:100%;
        font-family:'Open Sans', 'Helvetica Neue', Helvetica, Arial, sans-serif;    
        /*background-color:#eaedef;*/
    }
    
    .checkboxDiv {
		padding: 5px 0px 0px 10px;
	}
    
    .pageContent{
	    margin-top: 115px;
	    /*margin-bottom: 48px;
	    overflow: auto;*/
	    position: relative;
	    width: 100%;
	    
	    -moz-user-select: none;
    }
    .demo {
      width:100%;
      background-color:#fff;
      position: relative;
      /*overflow:auto;  */
      /*margin-top:35px;
      margin-bottom:25px;*/
    }
    
    
    .window {
        box-shadow: 2px 2px 19px #e0e0e0;
        -o-box-shadow: 2px 2px 19px #e0e0e0;
        -webkit-box-shadow: 2px 2px 19px #e0e0e0;
        -moz-box-shadow: 2px 2px 19px #e0e0e0;
        border-radius: 4px;
        -moz-border-radius: 0.5em;
		position: absolute;
        color: #80b5c4;
        width: 212px;
        border: 1px solid #00667e;
        -webkit-transition: -webkit-box-shadow 0.15s ease-in;
        -moz-transition: -moz-box-shadow 0.15s ease-in;
        -o-transition: -o-box-shadow 0.15s ease-in;
        transition: box-shadow 0.15s ease-in;
        z-index: 200;
        background: #fff;
    }
    .itemContent {
    	background: #fff;
    }
    .focus, .window:hover{
        border: 1px solid #f5c47e;
    }
    .isAccount:hover{
    	border:1px solid #00667e;
    }
    
    
    .itemWrapper{
        height:37px;
        color: #000;
        font-size: 13px;
        font-weight: bold;
    }
    .itemIcon {
        height: 22px;
        padding: 0px 8px 0px 9px;
        text-align: right;
        color: #000;
        font-size: 13px;
        font-weight: bold;
    }
    .focus .itemHeader, .window:hover .itemHeader {
        background: #ee8b02;
        color: #ffffff;
    }
    .pad4 span, .pad5 span {
	    padding-left: 5px;
	}
	.pad4 span {
	    padding-left: 5px;
	    overflow: hidden;
		white-space: nowrap;
		text-overflow: ellipsis;
		float: left;
		display: block;
		width: 200px;
		height: 18px;
	}
    .itemHeader{
    	cursor:move;
    	background: #00667e;
    	height:32px;
    	border-top-left-radius: 4px;
		border-top-right-radius: 4px;
	}
    .isAccount {
    	border:1px solid #00667e;
    }
    .pageTitle{
        width:100%;
        height:35px;
        line-height: 35px;
        text-align:center;
        color:#fff;
        position: fixed;
        top:80px;
        z-index:664;
        filter: progid:DXImageTransform.Microsoft.gradient( startColorstr='#474747', endColorstr='#1e1e1e',GradientType=0 ); 
        background: linear-gradient(#474747, #1e1e1e);
    }
    .pageFoot{
        width:100%;
        height:47px;
        text-align:center;
        color:#fff;
        position: fixed;
        bottom:0px;
        z-index:664;
        border-top:1px solid #da8d00;
        filter: progid:DXImageTransform.Microsoft.gradient( startColorstr='#f9b40f', endColorstr='#f19505',GradientType=0 ); 
        background: linear-gradient(#f9b40f, #f19505);
    }
    .pageFoot input {
        height: 32px;
        display: inline-block;
        font-weight: bold;
        float: left;
        border-radius: 4px;
        border: 1px solid #da8d00;
        filter: progid:DXImageTransform.Microsoft.gradient( startColorstr='#fefefe', endColorstr='#d9d9d9',GradientType=0 ); 
        background: linear-gradient(#fefefe, #d9d9d9);
    }
    .centerDiv{
        width: 475px;
        height: 48px;
        border-left: 1px solid #da8d00;
        border-right: 1px solid #da8d00;
        margin: 0px auto;
    }
    .centerDiv .footContent{
    	float: none;
		width: auto;
		background: initial;
		display: inline-block;
    }
    .centerDiv input{
    	font-family: 'Open Sans','Helvetica Neue',Helvetica,Arial,sans-serif;
        cursor: pointer;
        margin-top: 7px;
    }
    .footContent div {
        height: 48px;
        width: 48px;
        float: left;
        line-height: 48px;
        margin-top: -1px;
        cursor: pointer;
        filter: progid:DXImageTransform.Microsoft.gradient( startColorstr='#444444', endColorstr='#1e1e1e',GradientType=0 ); 
        background: linear-gradient(#444444, #1e1e1e);
        border-left: 1px solid #060606;
        border-right: 1px solid #3d3d3d;
    }
    
    .minusIcon{
        width: 11px;
        height: 4px;
        margin-top: 22px;
        background-position: -90px -90px !important;
    }
    .revertIcon{
        width: 21px;
        height: 21px;
        margin-top: 14px;
        background-position: -115px -75px !important;
    }
    .addIcon{
        width: 15px;
        height: 15px;
        margin-top: 17px;
        background-position: -147px -79px !important;
    }
    .accIconsHover{
        border:1px solid #ee8b02 !important;
        background:#f49f08;
    }
    
    /**********popup**********/
    .windowIconPopup{
        width:259px;
        height:auto;
        padding-bottom: 10px;
        border:1px solid #e48600;
        border-top-right-radius: 4px;
        border-bottom-left-radius: 4px;
        border-bottom-right-radius: 4px;
        background:#f49f08;
        position: absolute;
        color:#965d00;
        z-index: 665;
        display:none;
    }
    .popupTitle{
        width:100%;
        height:30px;
        color:#fff;
        font-weight:bold;
        line-height: 31px;
        border-bottom:1px solid #ffb200;
    }
    .popupContent{
        border-top:1px solid #e48600;
        width:100%;
        height:auto;
    }
    .popupTitle span{
        margin-left: 7px;
    }
    .tag{
        width:99%;
        height:25px;
        background: #fff;
        cursor: pointer;
        border: 1px solid #f49f08;
    }
    .tag span {
        float: left;
    }
    .windowIconPopup .popupContent div span:first-child{
        margin-left:9px;
    }
    .tag span:first-child + span {
        margin: 6px 0px 0px 5px;
    }
    .questionIcon-Y{
        width:17px;
        height:14px;
        margin-top: 7px;
        background-position:-189px 0px !important;
    }
    .questionIcon-B{
        width:17px;
        height:14px;
        margin-top: 7px;
        background-position:-165px 0px !important;
    }
    .squareIcon-Y{
        width:17px;
        height:12px;
        margin-top: 8px;
        background-position:-188px -34px !important;
    }
    .squareIcon-B{
        width:17px;
        height:12px;
        margin-top: 8px;
        background-position:-164px -34px !important;
    }
    .twoSquareIcon-Y{
        width:17px;
        height:12px;
        margin-top: 8px;
        background-position:-184px -17px !important;
    }
    .twoSquareIcon-B{
        width:17px;
        height:12px;
        margin-top: 8px;
        background-position:-160px -17px !important;
    }
    .dotIcon-Y{
        width:17px;
        height:16px;
        margin-top: 6px;
        background-position:-184px -51px !important;
    }
    .dotIcon-B{
        width:17px;
        height:16px;
        margin-top: 6px;
        background-position:-160px -51px !important;
    }
    
    .hiddenBorder{
        width:30px;
        height:1px;
        background:#f49f08;
        margin-top:-1px;
    }
    
    .tagHover, .tagSelect{
        background: #f49f08;
        color:#000;
    }
    .tagHover{
    	border: 1px solid #da6713;
    }
    table td{
  		height: 131px;
	    min-width: 280px;
	    padding: 20px 0;
	    position: relative;
  	}
  	.tmpteamcls table td{
  		height: 25px;
  	}
  	.windowIcon{
  		width:19px;
  		height:19px;
  		display: block;
		position: absolute;
  		left: -22px;
		top: 6px;
		background-position: -1px -81px !important;
  	}
  	.changeBtn {
		position: absolute;
		width: 25px;
		height: 26px;
		border: 1px solid #cfcfcf;
		right: -30px;
		border-radius: 4px;
		top: 2px;
        cursor: pointer;
	}
	.changeBtn div {
		width: 15px;
		height: 15px;
		background: #00667e;
		margin: 5px auto;
		border-radius: 16px;
	}
	.changeBtn div span{
		margin-left: 2px;
		font-weight: bold;
		color: #fff;
	}
	
	/*********************add popup*************************/
	.popup-Add{
        width:531px;
        position: fixed;
        left: 33%;
        top: 26%;
        z-index: 666;
        border-radius: 4px;
        box-shadow: 0px 0px 60px #afafaf;
        background:#ffffff;
        display:none;
    }
    .error-popup{
        width:400px;
        z-index: 666;
        text-align: center;
        background:#ffffff;
        position: fixed;
        padding-bottom: 10px;
        border-radius: 4px;
        margin-left: -205px;
        left:50%;
        top:30%;
        display:none;
    }
    .error-popup p{
        font-weight: bold;
        color:red;
        padding: 10px 10px;
    }
    .popup-title{
        width:100%;
        height:41px;
        filter: progid:DXImageTransform.Microsoft.gradient( startColorstr='#006a82', endColorstr='#005467',GradientType=0 ); /* IE6-9 */
        background: linear-gradient(#006a82, #005467);
        border-top-left-radius: 4px;
        border-top-right-radius: 4px;
    }
    .popup-title span{
        display:inline-block;
        color:#ffffff;
        line-height:41px;
        padding-left:14px;
    }
    .popup-content{
        margin: 10px 23px;
    }
    .popup-content-title{
        border-bottom: 1px solid #000000;
        padding: 8px 0px;
        margin: 15px 0px;
        font-size: 16px;
        clear: both;
    }
    .firstnamecls{
    	
    }
    .lastnamecls{
    	
    }
    .positionnamecls{
    	
    }
    .departmentnamecls{
    	
    }
    .popup-successIcon{
        width:24px;
        height:25px;
        display:inline-block;
        line-height:29px;
        background: url({!URLFOR($Resource.jsCss4OrgChart,'css/ui-lightness/images/icon.png')}) no-repeat;
        background-position: -266px 0px;
    }
    .popup-buttonGray{
        height:28px;
        border:1px solid #cfcfcf;
        padding: 0px 12px;
        border-radius: 6px;
        line-height: 28px;
        font-weight: bold;
        cursor: pointer;
        font-size: 14px;
        filter: progid:DXImageTransform.Microsoft.gradient( startColorstr='#fefefe', endColorstr='#d9d9d9',GradientType=0 ); /* IE6-9 */
        background: linear-gradient(#fefefe, #d9d9d9);
    }
    .popup-buttonCancel{
    	height:28px;
        border:1px solid #cfcfcf;
        padding: 0px 12px;
        border-radius: 6px;
        line-height: 28px;
        font-weight: bold;
        cursor: pointer;
        font-size: 14px;
        filter: progid:DXImageTransform.Microsoft.gradient( startColorstr='#fefefe', endColorstr='#d9d9d9',GradientType=0 ); /* IE6-9 */
        background: linear-gradient(#fefefe, #d9d9d9);
    }
    .popup-buttonYellow{
        height:28px;
        border:1px solid #da8d00;
        padding: 0px 12px;
        border-radius: 6px;
        line-height: 28px;
        font-weight: bold;
        cursor: pointer;
        font-size: 14px;
        color:#ffffff;
        filter: progid:DXImageTransform.Microsoft.gradient( startColorstr='#f9b30f', endColorstr='#ef8f03',GradientType=0 ); /* IE6-9 */
        background: linear-gradient(#f9b30f, #ef8f03);
    }
    .popup-content-partDiv{
        width:34px;
        height:29px;
        line-height:29px;
    }
    .popup-content-partDiv .popup-buttonYellow .popup-buttonGray{
        margin: 11px 0px 0px 42px;
    }
    .popup-button{
        float:right;
        margin:10px 0px;
    }
    
    /*************************pageTop*****************************/
    .floatLoading{
		position: fixed;
		z-index: 66;
		right: 30px;
    	top: 125px;
		color: #006177;
		font-weight: bold;
		margin-left: 870px;
		display: none;
	}
	.floatLoading span{
		display: inline-block;
		margin-top: 7px;
		float: left;
	}
	.floatLoading img{
		display: inline-block;
		margin-top: 0px;
		float: left;
	}
    .floatStyle{
		padding: 10px 0em !important;
		margin: 0px auto;
		width: 1010px;
		background: #ffffff;
    }
    .tab-back{
        width:99px !important;
        height:62px;
        cursor: pointer;
    }
    .backIcon + label{
        margin-top: 14px;
        display: inline-block;
        color:#6d6d6d;
        cursor: pointer; 
    }
    #tabs {
        margin: 0px auto;
		border: 0;
		z-index: 301;
		padding: 0px;
		position: fixed;
		padding-bottom: 5px;
		top: 0;
		width: 100%;
		background: #ffffff;
    }

    #tabs > ul li {
        list-style: none;
        float: left;
        position: relative;
        top: 0;
        margin: 1px 10px 0 0;
        border-bottom-width: 0;
        padding: 0;
        white-space: nowrap;
        filter: progid:DXImageTransform.Microsoft.gradient( startColorstr='#ffffff', endColorstr='#d8d8d8',GradientType=0 ); 
        background: linear-gradient(#fff, #d8d8d8);
        color: #1b1b1b;
        border-radius: 4px;
        border: 1px solid #ccc;
        width: 168px;
    }
    #tabs > ul li.sel {
        filter: progid:DXImageTransform.Microsoft.gradient( startColorstr='#3e3e3e', endColorstr='#272727',GradientType=0 ); 
        background: linear-gradient(#3e3e3e, #272727);
        color: #cfcfcf;
        border: 0;
        border-top: 1px solid #3e3e3e;
        border-bottom: 1px solid #272727;
    }
    #tabs > ul li.sel a {
        color: #fff;
    }
    #tabs > ul li a {
        float: left;
        padding: .5em 0;
        width: 100%;
        text-align: center;
        text-decoration: none;
        line-height: 24px;
        font-size: 14px;
        font-weight: bold;
    }
    #tabs > ul li a span {
        display: block;
        font-size: 12px;
        font-weight: normal;
    }
    #tabs > ul li div{
        width: 175px;
        height: 66px;
        top: -1px;
        left: -1px;
        position: absolute;
        z-index: 11;
        -moz-opacity: 0.7;
        opacity: 0.7;
        filter: progid:DXImageTransform.Microsoft.Alpha(opacity=70);
        background: #ffffff;
    }
    
    /*********************popup***********************/

    #popup-back{
    	filter:Alpha(opacity=60);
        opacity: 0.6;
        position: fixed;
        top: 0;
        left: 0;
        z-index: 665;
        background-color: #000;
        border: none;
        width:100%;
        height:100%;
        display:none;
    }
    
    /***********************loading*******************************/
    #mask {
		position: fixed;
		top: 0px;
		left: 0px;
		width: 100%;
		height: 100%;
		text-align: center;
		z-index: 777;
		background-color: #fff;
		background-repeat: no-repeat;
		background-position: center center;
		background-image: url('/img/loading32.gif');
		filter: alpha(opacity = 85);
		opacity: .85;
		display: none;
	}