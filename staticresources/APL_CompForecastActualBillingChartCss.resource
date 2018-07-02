/************** CSS by renjie **************/
#Component {
	width: 1224px;
}

.refreshBtn {
	display: inline-block;  
	width: 100px; 
	height: 35px; 
	line-height: 35px; 
	text-align: center; 
	background: #000000; 
	color: #ffffff; 
	border-radius: 5px;
	margin-left: 10px; 
	cursor: pointer;
}

.exportBtn {
	display: inline-block;  
	width: 100px; 
	height: 35px; 
	line-height: 35px; 
	text-align: center; 
	background: #000000; 
	color: #ffffff; 
	border-radius: 5px;
	margin-left: 10px; 
	cursor: pointer;
}

.AplAmchart {
	height: 250px;
	padding-left:30px;
}

.amGrouping, .relayGrouping, .region, .rsmGrouping, .rsmRelayGrouping, .territoryCode, .productFamily {
	display: inline-block;
	margin: 10px 5px;
	position: relative;
}

.listTitle {
	font-weight: bold;
	background: #91CDF2;
	padding: 5px 5px;
	border: 3px solid #91CDF2;
	color: #ffffff;
	width: 250px;
}

.listText {
	width: 250px;
	border: 3px solid #91CDF2;
	height: 35px;
	line-height: 35px;
	padding: 0 5px;
	display: inline-block;
	overflow: hidden;
	white-space: nowrap;
	vertical-align: middle;
	text-overflow: ellipsis;
	cursor: pointer;
}

.selectArea {
	width: 260px;
	position: absolute;
	z-index: 500;
	background: #ffffff;
	border: 1px solid #91CDF2;
	max-height: 140px;
	overflow-y: auto;
	overflow-x: hidden;
	right: 1px;
	display: none;
}

.selectArea ul {
	list-style: none;
	margin: 0;
	padding: 0;
}

.selectArea ul li {
	margin: 0px 5px;
	padding: 5px 0;
	border-bottom: 1px solid #ececec;
	white-space: nowrap;
	text-overflow: ellipsis;
	overflow: hidden;
}

.selectArea ul li:last-child {
	border-bottom: 0px solid #ececec;
}

/**** loading ****/	
.LoadingDiv {
	position: absolute;
	background: #f1f1f1;
	width: 100%;
	height: 100%;
	top: 0;
	left: 0;
	opacity: 0.9;
	filter:alpha(opacity=90);
	display: none;
	z-index: 999;
}

.LoadingDiv .LoadingImg {
	position: relative;
	left: 50%;
	top: 50%;
}

#actionResult {
	margin: 10px 0;
	position: relative;
	z-index: 1200;
}

.ref_box {
	width: 50px;
	height: 50px;
	line-height: 50px;
	text-align: center;
	display: inline-block;
	background: #6A9CD9;
	margin-left: 10px;
	cursor: pointer;
	color: #ffffff;
}

