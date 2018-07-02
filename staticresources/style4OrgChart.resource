/** DISABLE TEXT SELECTION (SET ON BODY WHEN DRAGGING IS OCCURRING) **/
._jsPlumb_drag_select * {
    -webkit-touch-callout: none;
    -webkit-user-select: none;
    -khtml-user-select: none;
    -moz-user-select: -moz-none;
    -ms-user-select: none;
    user-select: none
}

/** OPEN SANS FONT **/
@font-face {
  font-family: 'Open Sans';
  font-style: normal;
  font-weight: 400;
}

/** PAGE STRUCTURE **/
body {
    padding:0;
    margin:0;    
    font-family:'Open Sans', 'Helvetica Neue', Helvetica, Arial, sans-serif;    
    /*background-color:#eaedef;*/
   
}


.demo {
  position: relative;
  width:100%;
  background-color:#fff;    
  /*height:563px;*/
  overflow:auto;  
  /*margin-top:35px;
  margin-bottom:25px;*/
}

/* demo elements */
a, a:visited {
    /*text-decoration:none;*/
    /*color:#057D9F;        */
    color:#455;
    font-weight: bold;
    border-radius:0.2em;
    -webkit-transition: color 0.15s ease-in;
    -moz-transition: color 0.15s ease-in;
    -o-transition: color 0.15s ease-in;
    transition: color 0.15s ease-in;
}

a:hover {
    color:#7AB02C;
}

a:active {
  color:#FF2300;
}


.selected {
	color:orange !important;
}

.window, .label { 
    text-align:left;
    z-index:24;
	cursor:pointer;
	box-shadow: 2px 2px 19px #aaa;
   -o-box-shadow: 2px 2px 19px #aaa;
   -webkit-box-shadow: 2px 2px 19px #aaa;
   -moz-box-shadow: 2px 2px 19px #aaa;
    
}
path, ._jsPlumb_endpoint { cursor:pointer; }

.cmd { 
  color:white;
  margin-right:25px;
}

.cmd:hover { 
  color:#FF2300;
  text-decoration: underline;
}
.cmd:active {
  color:#FF2300;
}

.label {
  font-size:13px; 
  padding:8px;
  padding:8px;
}

.component { 
  border:1px solid #346789; 
  border-radius:0.5em;        
  opacity:0.8; 
  filter:alpha(opacity=80);
  background-color:white;
  color:black;
  padding:0.5em;   
  font-size:0.8em;
}

.component:hover {
    /*border:1px solid #123456;*/
    box-shadow: 2px 2px 19px #444;
   -o-box-shadow: 2px 2px 19px #444;
   -webkit-box-shadow: 2px 2px 19px #444;
   -moz-box-shadow: 2px 2px 19px #fff;
    opacity:0.9;
    filter:alpha(opacity=90);
}

.window {
    background-color:#eff;
    box-shadow: 2px 2px 19px #e0e0e0;
    -o-box-shadow: 2px 2px 19px #e0e0e0;
    -webkit-box-shadow: 2px 2px 19px #e0e0e0;
    -moz-box-shadow: 2px 2px 19px #e0e0e0;
    -moz-border-radius:0.5em; 
    position:absolute;    
    color:#455;/*black*/
    width:150px; 
    height:125px;
       
    -webkit-transition: -webkit-box-shadow 0.15s ease-in;
    -moz-transition: -moz-box-shadow 0.15s ease-in;
    -o-transition: -o-box-shadow 0.15s ease-in;
    transition: box-shadow 0.15s ease-in;
}

.window:hover {
    box-shadow: 2px 2px 19px #444;
   -o-box-shadow: 2px 2px 19px #444;
   -webkit-box-shadow: 2px 2px 19px #444;
   -moz-box-shadow: 2px 2px 19px #fff;
    opacity:0.9;
    filter:alpha(opacity=90);
}

.window a {
    font-family:helvetica;
}

/** Z-INDEX **/

._jsPlumb_connector { z-index:526; }
._jsPlumb_endpoint { z-index:19; }
._jsPlumb_overlay { z-index:20; }


/** ELEMENTS **/
/*
#chart-demo .window { 
	border: 1px dotted #d4e06b;
	width: 100px;
	height: 100px;
	line-height: 20px;	
}
#addNewContactDiv .window { 
	border: 1px dotted #d4e06b;
	width: 100px;
	height: 100px;
	line-height: 20px;	
}
*/
#picklistEmpty{color:#f00;}
.itemHeader{height:32px;}
.itemWrapper{height:68px;}
.icon4Branch{width:12px;height:12px;text-align:center;line-height:12px;border-radius: 2px;}
.redIcon{border:1px solid #faa;}
.itemHeader{cursor:move;}
.itemHeader:hover{background:#dee;}
.isHide{display: none;}
/** ELEMENT POSITIONS **/
.Row1 {top:10px;}
.Row2 {top:200px;}
.Row3 {top:400px;}
.Row4 {top:600px;}
.Row5 {top:800px;}
.Row6 {top:1000px;}
.Row7 {top:1200px;}
.Row8 {top:1400px;}
.Column1{left:10px;}
.Column2{left:210px;}
.Column3{left:410px;}
.Column4{left:610px;}
.Column5{left:650px;}
.bgGray{background: #999;}
.radius3{border-radius: 3px;}
.radius5{border-radius: 3px;}

.pf{position: fixed;}
.w200{width:200px;}
.w150{width:150px;}
.p20{padding: 20px;}
.l20{left:20px;}
.h200{height:200px;}
.fl{float:left;}
.clear{clear:both;}
.pad2{padding: 2px;}
.pad5{padding: 2px 10px;}