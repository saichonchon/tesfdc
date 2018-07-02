var hideTextArea = new Array();
	
	function initCommentHideParams(){
		hideTextArea.push({ cNumber: "1", qNumber: "1", showOnFlag:"All"});
		hideTextArea.push({ cNumber: "1", qNumber: "2", showOnFlag:"True"});
		hideTextArea.push({ cNumber: "1", qNumber: "3", showOnFlag:"False"});
		hideTextArea.push({ cNumber: "2", qNumber: "1", showOnFlag:"True"});
		hideTextArea.push({ cNumber: "2", qNumber: "2", showOnFlag:"False"});
		hideTextArea.push({ cNumber: "2", qNumber: "3", showOnFlag:"False"});
		hideTextArea.push({ cNumber: "2", qNumber: "4", showOnFlag:"False"});
		hideTextArea.push({ cNumber: "2", qNumber: "5", showOnFlag:"True"});
		hideTextArea.push({ cNumber: "3", qNumber: "1", showOnFlag:"False"});
		hideTextArea.push({ cNumber: "3", qNumber: "2", showOnFlag:"True"});
		hideTextArea.push({ cNumber: "3", qNumber: "3", showOnFlag:"False"});
		hideTextArea.push({ cNumber: "3", qNumber: "4", showOnFlag:"False"});
		hideTextArea.push({ cNumber: "4", qNumber: "1", showOnFlag:"False"});
		hideTextArea.push({ cNumber: "4", qNumber: "2", showOnFlag:"True"});
		hideTextArea.push({ cNumber: "4", qNumber: "3", showOnFlag:"False"});
		hideTextArea.push({ cNumber: "4", qNumber: "4", showOnFlag:"True"});
		hideTextArea.push({ cNumber: "4", qNumber: "5", showOnFlag:"False"});
		//console.log('initCommentHideParams::',hideTextArea);
	}
	
	function setCommentState(cNum,qNum,val){
		for(var i=0;i<hideTextArea.length;i++){
			var obj = hideTextArea[i];
			if(obj.cNumber == cNum && obj.qNumber == qNum){
				var showFlag = obj.showOnFlag;
				//console.log('cNum:',cNum,'qNum:',qNum,'showFlag:',showFlag,'value:',val);
				if(val == 'True'){
					if(showFlag == "All"){
						$("textarea[html-cnum='"+ cNum +"'][html-qnum='"+ qNum +"']").show();
					}
					if(showFlag == 'True'){
						$("textarea[html-cnum='"+ cNum +"'][html-qnum='"+ qNum +"']").show();
					}
					if(showFlag == 'False'){
						$("textarea[html-cnum='"+ cNum +"'][html-qnum='"+ qNum +"']").hide();
					}
				}
				if(val == 'False'){
					if(showFlag == "All"){
						$("textarea[html-cnum='"+ cNum +"'][html-qnum='"+ qNum +"']").show();
					}
					if(showFlag == 'True'){
						$("textarea[html-cnum='"+ cNum +"'][html-qnum='"+ qNum +"']").hide();
					}
					if(showFlag == 'False'){
						$("textarea[html-cnum='"+ cNum +"'][html-qnum='"+ qNum +"']").show();
					}
				}
			}
		}
	}
	
	function toggleCategory(obj){
		var currElement = $(obj);
		var currArrow = currElement.attr('html-arrow');
		if(currArrow == 'down'){
			currElement.removeClass("img_down");
			currElement.addClass("img_right");
			currElement.attr('html-arrow','right');
			currElement.parent().next().hide();
		}
		
		if(currArrow == 'right'){
			currElement.removeClass("img_right");
			currElement.addClass("img_down");
			currElement.attr('html-arrow','down');
			currElement.parent().next().show();
		}
	}
	
	function checkRadioValue(element,isYes){
		var currElement = $(element); 
		if(isYes){
			currElement.parent().parent().next().find('span.span_commentYes_class').show();
			currElement.parent().parent().next().find('span.span_commentNo_class').hide();
			setCommentState(currElement.attr("html-cnum"),currElement.attr("html-qnum"),"True");
			if(currElement.attr("html-cnum") == '1' && currElement.attr("html-qnum") == '1'){
				$("div.img_arrow_class").each(function(){
					var curr_obj = $(this);
					//console.log('curr_obj::',curr_obj);
					if(curr_obj.attr("html-num") == '2' || curr_obj.attr("html-num") == '3'){
						curr_obj.removeClass("img_right");
						curr_obj.addClass("img_down");
						curr_obj.attr('html-arrow','down');
						curr_obj.parent().show();
						curr_obj.parent().next().show();
					}
					if( curr_obj.attr("html-num") == '4'){
						curr_obj.removeClass("img_down");
						curr_obj.addClass("img_right");
						curr_obj.attr('html-arrow','right');
						curr_obj.parent().hide();
						curr_obj.parent().next().hide();
					}
				});
				$("div.div_category_class").each(function(){
					var curr_obj = $(this);
					if( curr_obj.attr("html-num") == '4'){						
						curr_obj.hide();						
					}else{
						curr_obj.show();						
					}					
				});
			} else if(currElement.attr("html-cnum") == '0') {
				$("div.img_arrow_class").each(function(){
					var curr_obj = $(this);
					//console.log('curr_obj::',curr_obj);
					if(curr_obj.attr("html-num") != '0'){
						curr_obj.removeClass("img_down");
						curr_obj.addClass("img_right");
						curr_obj.attr('html-arrow','right');
						curr_obj.parent().hide();
						curr_obj.parent().next().hide();
					}
				});
				$("div.div_category_class").each(function(){
					var curr_obj = $(this);
					if(curr_obj.attr("html-num") != '0'){
						curr_obj.hide();
					}
				});				
			}
		}else{
			currElement.parent().parent().next().find('span.span_commentYes_class').hide();
			currElement.parent().parent().next().find('span.span_commentNo_class').show();
			setCommentState(currElement.attr("html-cnum"),currElement.attr("html-qnum"),"False");
			if(currElement.attr("html-cnum") == '1' && currElement.attr("html-qnum") == '1'){
				$("div.img_arrow_class").each(function(){
					var curr_obj = $(this);
					curr_obj.removeClass("img_right");
					curr_obj.addClass("img_down");
					curr_obj.attr('html-arrow','down');
					curr_obj.parent().show();
					curr_obj.parent().next().show();
				});
				$("div.div_category_class").each(function(){
					var curr_obj = $(this);
					curr_obj.show();
				});
			} else if(currElement.attr("html-cnum") == '0') {
				$("div.img_arrow_class").each(function(){					
					var curr_obj = $(this);					
					if(curr_obj.attr("html-num") == '1' || curr_obj.attr("html-num") == '0'){
						curr_obj.removeClass("img_right");
						curr_obj.addClass("img_down");
						curr_obj.attr('html-arrow','down');						
						curr_obj.parent().show();
						curr_obj.parent().next().show();
					}else{
						curr_obj.removeClass("img_down");
						curr_obj.addClass("img_right");
						curr_obj.attr('html-arrow','right');
						curr_obj.parent().hide();
						curr_obj.parent().next().hide();
					}
				});
				$("div.div_category_class").each(function(){
					var curr_obj = $(this);
					if(curr_obj.attr("html-num") == '1' || curr_obj.attr("html-num") == '0'){
						curr_obj.show();
					}else{
						curr_obj.hide();
					}
				});	
			}
		}
		$("#save_btn").removeAttr("disabled");
		$("#save_btn").removeClass("save_btn_css");
		//activateSaveButton();
	}
	
	
	function hideDetailChecklist(){
		$("td.td_radio_class").each(function(){
			if($(this).attr("html-cNum") == '0') {
				var radioValue = $(this).attr("html-qans");
				console.log('---radioValue:::' + radioValue);
				if(radioValue != 'False') {
					$("div.img_arrow_class").each(function(){					
						var curr_obj = $(this);					
						if(curr_obj.attr("html-num") != '0'){
							curr_obj.removeClass("img_down");
							curr_obj.addClass("img_right");
							curr_obj.attr('html-arrow','right');
							curr_obj.parent().hide();
							curr_obj.parent().next().hide();
						}
					});
					$("div.div_category_class").each(function(){
						var curr_obj = $(this);
						if(curr_obj.attr("html-num") != '0'){
							curr_obj.hide();
						}
					});
				}
				if(radioValue == 'True' || radioValue == 'False') {
					$("#save_btn").removeAttr("disabled");
					$("#save_btn").removeClass("save_btn_css");
					//activateSaveButton();
				}
			}
		});
		$("div.img_down").each(function(){
			var curr_obj = $(this);
			//console.log('hideDetailChecklist::',curr_obj);
			/*if(curr_obj.attr("html-num") != '1' && curr_obj.attr("html-num") != '0'){
				curr_obj.removeClass("img_down");
				curr_obj.addClass("img_right");
				curr_obj.attr('html-arrow','right');
				curr_obj.parent().next().hide();
			}*/
			if(curr_obj.attr("html-num") != '0' && curr_obj.attr("html-num") != '1'){
				curr_obj.removeClass("img_down");
				curr_obj.addClass("img_right");
				curr_obj.attr('html-arrow','right');
				curr_obj.parent().hide();
				curr_obj.parent().next().hide();
			}
		});
		$("div.div_category_class").each(function(){
			var curr_obj = $(this);
			/*if(curr_obj.attr("html-num") == '1'){
				curr_obj.show();
			}*/
			if(curr_obj.attr("html-num") != '0' && curr_obj.attr("html-num") != '1'){
				curr_obj.hide();				
			}
		});
	}
	
	function populateAnswer(){
		$("td.td_radio_class").each(function(){
			var radioName = $(this).attr("html-qid");
			var radioValue = $(this).attr("html-qans");
			var cNum = $(this).attr("html-cNum"); //added by Tangyong Li 2018-01-26
			
			if(radioValue != ''){
				$("input[name='"+ radioName +"'][value='"+ radioValue +"']").attr("checked",true);
				if(radioValue == 'True'){
					var currElement = $("input[name='"+ radioName +"'][value='"+ radioValue +"']");
					currElement.parent().parent().next().find('span.span_commentYes_class').show();
					currElement.parent().parent().next().find('span.span_commentNo_class').hide();
					if(currElement.attr("html-cnum") == '1' && currElement.attr("html-qnum") == '1'){
						$("div.img_arrow_class").each(function(){
							var curr_obj = $(this);
							//console.log('curr_obj::',curr_obj);
							if(curr_obj.attr("html-num") == '2' || curr_obj.attr("html-num") == '3'){
								curr_obj.removeClass("img_right");
								curr_obj.addClass("img_down");
								curr_obj.attr('html-arrow','down');
								curr_obj.parent().show();
								curr_obj.parent().next().show();
							}
							if( curr_obj.attr("html-num") == '4'){
								curr_obj.removeClass("img_down");
								curr_obj.addClass("img_right");
								curr_obj.attr('html-arrow','right');
								curr_obj.parent().hide();
								curr_obj.parent().next().hide();
							}
						});
						$("div.div_category_class").each(function(){
							var curr_obj = $(this);
							if(curr_obj.attr("html-num") == '4'){
								curr_obj.hide();
							}else{
								curr_obj.show();								
							}
						});
					}
				}
				if(radioValue == 'False'){
					var currElement = $("input[name='"+ radioName +"'][value='"+ radioValue +"']");
					currElement.parent().parent().next().find('span.span_commentYes_class').hide();
					currElement.parent().parent().next().find('span.span_commentNo_class').show();
					if(currElement.attr("html-cnum") == '1' && currElement.attr("html-qnum") == '1'){
						$("div.img_arrow_class").each(function(){
							var curr_obj = $(this);
							curr_obj.removeClass("img_right");
							curr_obj.addClass("img_down");
							curr_obj.attr('html-arrow','down');
							curr_obj.parent().show();
							curr_obj.parent().next().show();
						});
						$("div.div_category_class").each(function(){
							var curr_obj = $(this);							
							curr_obj.show();									
						});
					}
				}
				
				var cNum = $(this).attr("html-cnum");
				var qNum = $(this).attr("html-qnum");
				setCommentState(cNum,qNum,radioValue);
			}else{
				var cNum = $(this).attr("html-cnum");
				var qNum = $(this).attr("html-qnum");
				$("textarea[html-cnum='"+ cNum +"'][html-qnum='"+ qNum +"']").hide();
			}
			
			if(cNum == '0' && radioValue == 'True') return false; //added by Tangyong Li 2018-01-26
		});
		//$("input[name='a6d0q000000028GAAQ']:checked").val();
		hideLoading();
	}
	

	
	function saveAllQuestions(){
		showLoading();
		var list_objs = new Array(); 
		
		var list_showCategorys = new Array();
		$("div.img_arrow_class").each(function(){
			if($(this).hasClass("img_down")){
				list_showCategorys.push($(this).attr("html-num"));
			}
		});
		
		var showlistSize = 0;
		var answerCounter = 0;
		$("td.td_radio_class").each(function(){
			var qId = $(this).attr("html-qid");
			var qValue = $("input[name='"+ qId +"']:checked").val();
			console.log('---qValue:::' + qValue);
			var qComment = $("textarea[html-qid='"+ qId +"']").val();
			qComment = trim(qComment);
			if(qValue == null || qValue == ''){qValue = '';}
			var obj = new Object();
			obj.str_questionId = qId;
			obj.str_questionAnswer = qValue;
			obj.str_questionComment = qComment;
			list_objs.push(obj);
			
			var cId = $(this).attr("html-cnum");
			if($.inArray(cId, list_showCategorys) > -1){
				showlistSize = showlistSize + 1;
				if(qValue != ''){
					answerCounter = answerCounter + 1;
				}
			}
		});
		console.log('saveAllQuestions:',list_objs);
		
		if(answerCounter == showlistSize
		||( $("input[html-cnum='0']:checked")== 'True' )){
			$("input[id*='hidden_param_formCompleted']").val("true");
		}else{
			$("input[id*='hidden_param_formCompleted']").val("false");
		}
		console.log('answerCounter::',answerCounter,'::showlistSize::',showlistSize);
		var str_json = JSON.stringify(list_objs);
		$("input[id*='hidden_param_saveAnswerJson']").val(str_json);
		saveActionFunction();
	}
	
	function disableSaveButton(){		
		$("#save_btn").attr("disabled","disabled");
		$("#save_btn").addClass("save_btn_css");
	}
	function activateSaveButton(){		
		$("#save_btn").removeAttr("disabled");
		$("#save_btn").removeClass("save_btn_css");		
	}
	function showLoading(){
		$("#Loading_Panel").show();
	}
	
	function hideLoading(){
		$("#Loading_Panel").hide();
	}
	
	function reloadPage(){
		location.reload(true);
	}
	
	function trim(str){
		return str.replace(/(^\s*)|(\s*$)/g, "");
	}