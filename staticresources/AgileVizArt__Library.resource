function resetProjectEpiStoryUI() {
    $(".epicStory_column").sortable({
        connectWith: ".epicStory_column",
        update: updateEpicStory
    });
}

function resetSprintStoryUI() {
    $(".epicStory_column").sortable({
        connectWith: ".epicStory_column",
        cancel: '.effort-hours_input',
        update: updateStory
    });
}

//added by Xia Tong
function resetReleaseStoryUI() {
    $(".epicStory_column").sortable({
        connectWith: ".epicStory_column",
        cancel: '.effort-hours_input',
        update: updateReleaseEpicStory
    });
}

function resetPriorityStoryUI() {
    $(".epicStory_column").sortable({
        connectWith: ".epicStory_column",
        update: updatePriorityStory
    });
}

function addDrag() {
    $('.dragWin').each(function () {
        // var condition="popwin";
        $(this).data('validate', "popwin");

        // make the event draggable using jQuery UI
        $(this).draggable({
            zIndex: 999,
            cursor: "move"
        });
    });
}

function getSingleStory(model, id) {
    AgileVizArt.CtrlProjectEpicStory.getSingleStory(id, function (result, event) {
        $("#loading").css({visibility: 'hidden'});
        var name = '';
        var description = '';
        if (result[0] != null) {
            name = itb_translate_sign_replace(result[0]);
        }
        if (result[1] != null) {
            description = itb_translate_sign_replace(result[1]);
        }

        $("#itb_story_subject").text(name);
        $("#itb_story_description").text(description);
    }, {
        escape: true
    });
}

function detailPop(model, id) {

    $("#mask").show();
    $("#mask").css({
        visibility: 'visible'
    });

    if (model == 'Epic') {
        getSingleStory(model, id);
        $('<div id="itb_story_popwin" style="width:100% !important;" >' + '<div id="itb_story_popcontent">' + '<div id="itb_story_subject" style="font-weight:bold"></div>' + '<div id="breakline">' + '</div>' + '<div id="itb_story_description"></div>' + '<div id="loading">' + '<img src="/changemgmt/img/spinner24.gif"/>' + '</div>' + '</div>' + '<div style="background-color:white;text-align:center">' + '<input type="button" class="btn" value="close" onclick="popRemove()">' + '</input></div></div>').appendTo($("#itb_story_detailwin"));
        
    } else {
        $('<div id="itb_story_popwin" style="width:100% ;height:100%;background-color:white !important;" >' + '<div id="itb_story_popcontent" style="width:100%;top:5px;position:absolute; bottom:25px; padding:0px; margin:0px">' + '<div id="loading">' + '<img src="/changemgmt/img/spinner24.gif"/>' + '</div>' + '<iframe frameborder="0" id="theIframe" width="100%" height="100%" name="theIframe" src="/apex/ExtUserStoryComment?id=' + id + '"/>' + '</div>' + '<div style="width:100%;text-align:center;position:absolute; bottom:0px; padding:0px; margin:0px">' + '<input type="button" class="btn" value="close" onclick="popRemove()">' + '</input></div></div>').appendTo($("#itb_story_detailwin"));
        $("#itb_story_detailwin").css({
            "height": "70%"
        });
        
        //$("#loading").css({visibility: 'hidden'});
    }
    thisoffset = $("#detail_" + id).offset();

    $("#itb_story_detailwin").css({
        "z-index": "99999"
    });
    
}

// added by xia Tong <xia.tong@itbconsult.com>
function releasedetailPop(model, id) {
    $("#mask").show();
    $("#mask").css({
        visibility: 'visible'
    });

    $('<div id="itb_story_popwin" style="width:100% ;height:100%;background-color:white !important;" >' + '<div id="itb_story_popcontent" style="width:100%;top:5px;position:absolute; bottom:25px; padding:0px; margin:0px">' + '<div id="loading">' + '<img src="/changemgmt/img/spinner24.gif"/>' + '</div>' + '<iframe frameborder="0" id="theIframe" width="100%" height="100%" name="theIframe" src="/apex/ExtEpicStoryComment?id=' + id + '"/>' + '</div>' + '<div style="width:100%;text-align:center;position:absolute; bottom:0px; padding:0px; margin:0px">' + '<input type="button" class="btn" value="close" onclick="popRemove()">' + '</input></div></div>').appendTo($("#itb_story_detailwin"));

    $("#itb_story_detailwin").css({
        "height": "70%"
    });
    thisoffset = $("#detail_" + id).offset();

    $("#itb_story_detailwin").css({
        "z-index": "99999"
    });
}



function hideLoading() {
    $("#loading").css({
        visibility: 'hidden'
    });
}

function itb_add_story(id, name) {
    var addid = id;
    var addname = name;
    $("#loading").css({
        visibility: 'hidden'
    });
    $("#mask").show();
    $("#mask").css({
        visibility: 'visible'
    });

    $("<div id='itb_story_popwin' >" + "<div id='itb_story_popcontent'>" + "<div id='breakline'>" + "</div>" + "<div id='itb_story_addProject' align='center'>Project: " + name + "</div>" + "<div id='breakline'>" + "</div>" + "<div id='itb_story_addSubject' align='center'>Subject:<input type='text' id='subject' />" + "</div>" + "<div id='breakline'>" + "</div>" + "<div id='itb_story_addDescription' align='center'>Description:<input type='text' id='description' />" + "</div>" + "<div id='breakline'>" + "</div>" + "<script>var addid='" + addid + "';var addname='" + addname + "'</script><div id='buttons' align='center'><input type='button' value='save' class='btn' onclick='itb_save_story(addid, addname);'/>  <input type='button' value='cancel' class='btn' onclick='popRemove()'/>" + "</div>" + "<div id='loading' style='visibility:hidden'>" + "<img src='/img/loading.gif'/>Loading..." + "</div>" + "</div>" + "<div id='itb_story_winclose' onclick='popRemove()'>" + "</div>" + "</div>").appendTo($("#itb_story_detailwin"));
    thisoffset = $("#detail").offset();
    $("#itb_story_detailwin").css({
        "z-index": 99999
    });
}

function itb_save_story(id, name) {
    $("#loading").css({
        visibility: 'visible'
    });
    AgileVizArt.CtrlSprint.addStory(id, name, document.getElementById('subject').value, document.getElementById('description').value, function (result, event) {});
    popRemove();
}

function showAddStoryDiv() {
    $("#loading").css({
        visibility: 'hidden'
    });
    $("#add_mask").show();
    $("#add_mask").css({
        visibility: 'visible'
    });
    $("#itb_add_story_detailwin").show();
    $("#itb_add_story_detailwin").css({
        visibility: 'visible'
    });
    thisoffset = $("#addStoryDiv").offset();
    $("#itb_add_story_detailwin").css({
        "z-index": 99999
    });
    reloadPage();
}

function reloadPage(){
	$('div.portlet-content').find("strong").css('font-weight','normal');
	$('div.portlet-content').find("strong").css('font-style','normal');
	$('div.portlet-content').find("strong").css('text-decoration','none');
	$('div.portlet-content').find("span").removeAttr("style");
	$('div.portlet-content').find("font").removeAttr("size");
    $('div.portlet-content').find("font").addClass("fontSize");
    $('div.portlet-content').find("ul").css('margin','0px');
    $('div.portlet-content').find("ul").css('padding','0px');
	$('div.portlet-content').find("ol").css('margin','0px');
    $('div.portlet-content').find("ol").css('padding','0px');
    $('div.portlet-content').find("li").css('margin','0px');
    $('div.portlet-content').find("span img").css('display','none');
	$('div.portlet-content').find("span div").removeAttr("style");
}

function showNewCommentStoryDiv(storyId, column) {
    var alias = column / 100;

    $("#loading").css({
        visibility: 'hidden'
    });
    $("#comment_mask").show();
    $("#comment_mask").css({
        visibility: 'visible'
    });
    $("#itb_comment_story_detailwin").show();
    $("#itb_comment_story_detailwin").css({
        visibility: 'visible'
    });
    thisoffset = $("#new_" + storyId).offset();

    $("#itb_comment_story_detailwin").css({
        "z-index": 99999
    });
}

function showCommentStoryDiv(storyId, status, column, typeid, typename, option, assName, assId, delName, delId) {
	
	$("[id$=commentSection]").find("iframe").contents().find("body").contents().remove();
	$("[id$=commentSection]").find("iframe").contents().find("body").contents().empty();
	$("[id$=subjectSectionInputFieldSubject]").val("");
	
	$("[id$=commentType] option:[text='Discussion']").attr("selected", true);
	
    $('.commentStoryComment').attr("value", "");
    if ('requirement' === typename.toLowerCase()) {
        $('.storyUrgencyLabel').hide();
        $('.storyPriorityLabel').show();
        $('.storySeverityLabel').hide();
        $('.commentStoryUrgency').hide();
        $('.commentStoryPriority').attr("value", document.getElementById(option).value);
        $('.commentStoryPriority').show();
        $('.commentStorySeverity').hide();
    } else if ('issue' === typename.toLowerCase()) {
        $('.storyUrgencyLabel').show();
        $('.storyPriorityLabel').hide();
        $('.storySeverityLabel').hide();
        $('.commentStoryUrgency').attr("value", document.getElementById(option).value);
        $('.commentStoryUrgency').show();
        $('.commentStoryPriority').hide();
        $('.commentStorySeverity').hide();
    } else if ('defect' === typename.toLowerCase()) {
        $('.storyUrgencyLabel').hide();
        $('.storyPriorityLabel').hide();
        $('.storySeverityLabel').show();
        $('.commentStoryUrgency').hide();
        $('.commentStoryPriority').hide();
        $('.commentStorySeverity').attr("value", document.getElementById(option).value);
        $('.commentStorySeverity').show();
    }


    $('#itb_comment_story_popcontent .detailList:first tr:first td:last span input').attr("value", assName);
    $('#itb_comment_story_popcontent .detailList:first tr:first td:last input:first').attr("value", assId);
    $('#itb_comment_story_popcontent .detailList:first tr:first td:last input:nth-child(2)').attr("value", assName);
    $('#itb_comment_story_popcontent .detailList:first tr:last td:last span input').attr("value", delName);
    $('#itb_comment_story_popcontent .detailList:first tr:last td:last input:first').attr("value", delId);
    $('#itb_comment_story_popcontent .detailList:first tr:last td:last input:nth-child(2)').attr("value", delName);
    document.getElementById("commentStoryId").value = storyId;
    document.getElementById("commentStoryType").value = typename;
    var statusDiv = document.getElementById("itb_comment_story_popcontent");
    var selArr = statusDiv.getElementsByTagName("select");
    for (var i = 0; i < selArr.length; i++) {
        if (selArr[i].className == 'commentStoryStatus') {
            selArr[i].value = document.getElementById(status).value;
        }
    }
    var alias = column / 100;

    $("#loading").css({
        visibility: 'hidden'
    });
    $("#comment_mask").show();
    $("#comment_mask").css({
        visibility: 'visible'
    });
    $("#itb_comment_story_detailwin").show();
    $("#itb_comment_story_detailwin").css({
        visibility: 'visible'
    });
    thisoffset = $("#detail_" + storyId).offset();

    $("#itb_comment_story_detailwin").css({
        "z-index": 1000
    });
}

function hideAddStoryDiv() {
    $("#itb_add_story_detailwin").hide();
    $("#itb_add_story_detailwin").css({
        visibility: 'hidden'
    });
    $("#add_mask").css({
        visibility: 'hidden'
    });
    $("#add_mask").hide();
    reloadPage();
}

function hideCommentStoryDiv() {
    $('.commentStoryComment').attr("value", "");
    $("#itb_comment_story_detailwin").hide();
    $("#itb_comment_story_detailwin").css({
        visibility: 'hidden'
    });
    $("#comment_mask").css({
        visibility: 'hidden'
    });
    $("#comment_mask").hide();
}

function popRemove() {
    var oU1 = document.getElementById("itb_story_detailwin");
    oU1.style.height = "";
    $("#itb_story_popwin").remove();
    $("#mask").css({
        visibility: 'hidden'
    });
    $("#mask").hide();
}


	/**
	* This method is used to handling click events.
	*
	@author Yuliang Ye
	@created 2012-05-11
	@version 1.0
	@since 24.0
	*
	@param column			
	@param defaultSize		
	*
	@return 			null
	*
	@changelog
	*2012-05-11 Yuliang Ye <yuliang.ye@itbconsult.com>
	* - Created
	*/

function resetStoryUI_new(column, defaultSize) {

    $(".epicStory").prepend("<span class='ui-icon ui-icon-minusthick'></span>").end().find(".portlet-content");

    $("#Backlog").find("#Must").prepend("<span class='ui-icon ui-icon-minusthick effort-hours_input'></span>").end().find(".portlet-content");
    $("#Backlog").find("#Should").prepend("<span class='ui-icon ui-icon-minusthick effort-hours_input'></span>").end().find(".portlet-content");
    $("#Backlog").find("#Could").prepend("<span class='ui-icon ui-icon-plusthick effort-hours_input'></span>").end().find(".portlet-content");
    $("#Backlog").find("#Would").prepend("<span class='ui-icon ui-icon-plusthick effort-hours_input'></span>").end().find(".portlet-content");

	$("#Backlog").find("#Could").find(".portlet").css("display", "none");
	$("#Backlog").find("#Would").find(".portlet").css("display", "none");

    $("#Backlog .ui-icon").click(

    function () {
        var id = $(this).parent().attr("id");
        if ($(this).hasClass("ui-icon-plusthick")) {
            $(this).parent().parent().find("#" + id).find(".portlet").css("display", "block");
            
        } else {
            $(this).parent().parent().find("#" + id).find(".portlet").css("display", "none");
        }
        $(this).toggleClass("ui-icon-plusthick").toggleClass("ui-icon-minusthick");
    });
    
    $("#Epic Stories").find("#Must").prepend("<span class='ui-icon ui-icon-minusthick effort-hours_input'></span>").end().find(".portlet-content");
    $("#Epic Stories").find("#Should").prepend("<span class='ui-icon ui-icon-minusthick effort-hours_input'></span>").end().find(".portlet-content");
    $("#Epic Stories").find("#Could").prepend("<span class='ui-icon ui-icon-plusthick effort-hours_input'></span>").end().find(".portlet-content");
    $("#Epic Stories").find("#Would").prepend("<span class='ui-icon ui-icon-plusthick effort-hours_input'></span>").end().find(".portlet-content");

	$("#Epic Stories").find("#Could").find(".portlet").css("display", "none");
	$("#Epic Stories").find("#Would").find(".portlet").css("display", "none");

    $("#Epic Stories .ui-icon").click(

    function () {
        var id = $(this).parent().attr("id");
        if ($(this).hasClass("ui-icon-plusthick")) {
            $(this).parent().parent().find("#" + id).find(".portlet").css("display", "block");
            
        } else {
            $(this).parent().parent().find("#" + id).find(".portlet").css("display", "none");
        }
        $(this).toggleClass("ui-icon-plusthick").toggleClass("ui-icon-minusthick");
    });

    $(".epicStory .ui-icon").click(
	
    function () {
        if ($(this).hasClass("ui-icon-minusthick")) {
            $(this).parent(".epicStory:first").next().find(".portlet").find(".portlet-header .ui-icon").removeClass("ui-icon-minusthick").addClass("ui-icon-plusthick");

            $(this).parent(".epicStory:first").next().find(".portlet").find(".portlet-content").css("display", "none");
        } else {
            $(this).parent(".epicStory:first").next().find(".portlet").find(".portlet-header .ui-icon").removeClass("ui-icon-plusthick").addClass("ui-icon-minusthick");
            $(this).parent(".epicStory:first").next().find(".portlet").find(".portlet-content").css("display", "block");
        }
        $(this).toggleClass("ui-icon-minusthick").toggleClass("ui-icon-plusthick");
    });

    $(".portlet").addClass("ui-widget ui-widget-content ui-helper-clearfix ui-corner-all").find(".portlet-header").addClass("ui-widget-header ui-corner-all").prepend("<span class='ui-icon ui-icon-minusthick'></span>").end().find(".portlet-content");

    $(".portlet-header .ui-icon").click(
	
    function () {
        $(this).toggleClass("ui-icon-minusthick").toggleClass("ui-icon-plusthick");
        $(this).parents(".portlet:first").find(".portlet-content").toggle();
    });

    $(".epicStory_column").disableSelection();
    itb_translate_sign(column, defaultSize);
    if(defaultSize == 0)Collapse('userstory');
}


/**
	* This method is used to handling click events.
	*
	@author Yuliang Ye
	@created 2012-04-16
	@version 1.0
	@since 24.0
	*
	@param column			
	@param defaultSize		
	*
	@return 			null
	*
	@changelog
	*2012-04-16 Yuliang Ye <yuliang.ye@itbconsult.com>
	* - Created
	*/
function resetStoryUIBacklog(column, defaultSize) {
 
    $(".epicStory .ui-icon").click(
    
    function () {
        if ($(this).hasClass("ui-icon-minusthick")) {
            $(this).parent(".epicStory:first").next().find(".portlet").find(".portlet-header .ui-icon").removeClass("ui-icon-minusthick").addClass("ui-icon-plusthick");
            $(this).parent(".epicStory:first").next().find(".portlet").find(".portlet-content").css("display", "none");
        } else {
            $(this).parent(".epicStory:first").next().find(".portlet").find(".portlet-header .ui-icon").removeClass("ui-icon-plusthick").addClass("ui-icon-minusthick");
            $(this).parent(".epicStory:first").next().find(".portlet").find(".portlet-content").css("display", "block");
        }
        $(this).toggleClass("ui-icon-minusthick").toggleClass("ui-icon-plusthick");
    });

    $(".portlet-header .ui-icon").click(

    function () {
        $(this).toggleClass("ui-icon-minusthick").toggleClass("ui-icon-plusthick");
        $(this).parents(".portlet:first").find(".portlet-content").toggle();   
    });
    
    $(".epicStory_column").disableSelection();
	itb_translate_sign(column, defaultSize);
}

/**
	* This method is used to handling click events.
	*
	@author Yuliang Ye
	@created 2012-04-16
	@version 1.0
	@since 24.0
	*
	@param column			
	@param defaultSize		
	*
	@return 			null
	*
	@changelog
	*2012-04-16 Yuliang Ye <yuliang.ye@itbconsult.com>
	* - Created
	*/
function resetStoryUI(column, defaultSize) {
   $(".epicStory").prepend("<span class='ui-icon ui-icon-minusthick'></span>").end().find(".portlet-content");

    //$("#Backlog").find("#Must").prepend("<span class='ui-icon ui-icon-plusthick effort-hours_input'></span>").end().find(".portlet-content");
    //$("#Backlog").find("#Should").prepend("<span class='ui-icon ui-icon-plusthick effort-hours_input'></span>").end().find(".portlet-content");
    //$("#Backlog").find("#Could").prepend("<span class='ui-icon ui-icon-plusthick effort-hours_input'></span>").end().find(".portlet-content");
    //$("#Backlog").find("#Would").prepend("<span class='ui-icon ui-icon-plusthick effort-hours_input'></span>").end().find(".portlet-content");
	
	$(".portlet").addClass("ui-widget ui-widget-content ui-helper-clearfix ui-corner-all").find(".portlet-header").addClass("ui-widget-header ui-corner-all").prepend("<span class='ui-icon ui-icon-minusthick'></span>").end().find(".portlet-content");
	
    $("#Backlog .ui-icon").click(

    function () {
        var id = $(this).parent().attr("id");
        if ($(this).hasClass("ui-icon-minusthick")) {
            $(this).parent().parent().find("#" + id).find(".portlet-header").find(".ui-icon").removeClass("ui-icon-minusthick").addClass("ui-icon-plusthick");
            $(this).parent().parent().find("#" + id).find(".portlet-content").css("display", "none");
        } else {
            $(this).parent().parent().find("#" + id).find(".portlet-header").find(".ui-icon").removeClass("ui-icon-plusthick").addClass("ui-icon-minusthick");
            $(this).parent().parent().find("#" + id).find(".portlet-content").css("display", "block");
        }
        $(this).toggleClass("ui-icon-minusthick").toggleClass("ui-icon-plusthick");
    });

    $(".epicStory .ui-icon").click(

    function () {
        if ($(this).hasClass("ui-icon-minusthick")) {
            $(this).parent(".epicStory:first").next().find(".portlet").find(".portlet-header .ui-icon").removeClass("ui-icon-minusthick").addClass("ui-icon-plusthick");

            $(this).parent(".epicStory:first").next().find("#Must").find(".ui-icon").removeClass("ui-icon-minusthick").addClass("ui-icon-plusthick");
            $(this).parent(".epicStory:first").next().find("#Should").find(".ui-icon").removeClass("ui-icon-minusthick").addClass("ui-icon-plusthick");
            $(this).parent(".epicStory:first").next().find("#Could").find(".ui-icon").removeClass("ui-icon-minusthick").addClass("ui-icon-plusthick");
            $(this).parent(".epicStory:first").next().find("#Would").find(".ui-icon").removeClass("ui-icon-minusthick").addClass("ui-icon-plusthick");

            $(this).parent(".epicStory:first").next().find(".portlet").find(".portlet-content").css("display", "none");
        } else {
            $(this).parent(".epicStory:first").next().find(".portlet").find(".portlet-header .ui-icon").removeClass("ui-icon-plusthick").addClass("ui-icon-minusthick");

            $(this).parent(".epicStory:first").next().find("#Must").find(".ui-icon").removeClass("ui-icon-plusthick").addClass("ui-icon-minusthick");
            $(this).parent(".epicStory:first").next().find("#Should").find(".ui-icon").removeClass("ui-icon-plusthick").addClass("ui-icon-minusthick");
            $(this).parent(".epicStory:first").next().find("#Could").find(".ui-icon").removeClass("ui-icon-plusthick").addClass("ui-icon-minusthick");
            $(this).parent(".epicStory:first").next().find("#Would").find(".ui-icon").removeClass("ui-icon-plusthick").addClass("ui-icon-minusthick");

            $(this).parent(".epicStory:first").next().find(".portlet").find(".portlet-content").css("display", "block");
        }
        $(this).toggleClass("ui-icon-minusthick").toggleClass("ui-icon-plusthick");
    });

    $(".portlet-header .ui-icon").click(

    function () {
        $(this).toggleClass("ui-icon-minusthick").toggleClass("ui-icon-plusthick");
        $(this).parents(".portlet:first").find(".portlet-content").toggle();
    });

    $(".epicStory_column").disableSelection();
    itb_translate_sign(column, defaultSize);
}

function resetStoryUItmp(column, defaultSize) {
    $(".epicStory").prepend("<span class='ui-icon ui-icon-minusthick'></span>").end().find(".portlet-content");

    $(".epicStory .ui-icon").click(

    function () {
        if ($(this).hasClass("ui-icon-minusthick")) {
            $(this).parents(".epicStory:first").nextAll(".epicStory_column:first").children(".portlet").find(".portlet-header .ui-icon").removeClass("ui-icon-minusthick");
            $(this).parents(".epicStory:first").nextAll(".epicStory_column:first").children(".portlet").find(".portlet-header .ui-icon").addClass("ui-icon-plusthick");
            $(this).parents(".epicStory:first").nextAll(".epicStory_column:first").children(".portlet").find(".portlet-content").css("display", "none");
        } else {
            $(this).parents(".epicStory:first").nextAll(".epicStory_column:first").children(".portlet").find(".portlet-header .ui-icon").removeClass("ui-icon-plusthick");
            $(this).parents(".epicStory:first").nextAll(".epicStory_column:first").children(".portlet").find(".portlet-header .ui-icon").addClass("ui-icon-minusthick");
            $(this).parents(".epicStory:first").nextAll(".epicStory_column:first").children(".portlet").find(".portlet-content").css("display", "block");
        }
        $(this).toggleClass("ui-icon-minusthick").toggleClass("ui-icon-plusthick");
    });

    $(".portlet").addClass("ui-widget ui-widget-content ui-helper-clearfix ui-corner-all").find(".portlet-header").addClass("ui-widget-header ui-corner-all").prepend("<span class='ui-icon ui-icon-minusthick'></span>").end().find(".portlet-content");


    $(".portlet-header .ui-icon").click(

    function () {
        $(this).toggleClass("ui-icon-minusthick").toggleClass("ui-icon-plusthick");
        $(this).parents(".portlet:first").find(".portlet-content").toggle();
    });

    $(".epicStory_column").disableSelection();
    itb_translate_sign(column, defaultSize);
}

function updateEpicStory(event, ui) {
    sforce.connection.sessionId = sessionId;

    var esArr = [];
    var esIds = '';
    var versions = '';
    var ranks = '';
    var priority = ui.item[0].parentNode.id;

    if (ui.sender == null) {
        esArr = $(this).sortable("toArray");
        for (var i = 0; i < esArr.length; i++) {
            var esid = esArr[i].substring(esArr[i].indexOf('_') + 1);
            if (document.getElementById('priority_' + esid).value == priority) {
                esIds += esid + ';';
                versions += document.getElementById('version_' + esid).value + ';';
                ranks += document.getElementById('rank_' + esid).value + ';';
            }
        }
        priority = ui.item[0].parentNode.id;
    } else if (ui.sender != null) {
        esArr = [];
        esIds = '';
        versions = '';
        ranks = '';
        priority = ui.item[0].parentNode.id;
        esArr = $(this).sortable("toArray");
        for (var i = 0; i < esArr.length; i++) {
            var esid = esArr[i].substring(esArr[i].indexOf('_') + 1);
            esIds += esid + ';';
            versions += document.getElementById('version_' + esid).value + ';';
            ranks += document.getElementById('rank_' + esid).value + ';';
        }
    }

    if (esIds.length > 0) {
        AgileVizArt.CtrlProjectEpicStory.updateEpicStory(
        esIds, versions, ranks, priority, function (result, event) {
            if (result != '') {
                document.getElementById('errorDiv_ep').innerHTML = '';
                $.each(
                result, function (key, val) {
                    if (key.indexOf('error_') != -1) {
                        document.getElementById('errorDiv_ep').innerHTML += val + '<br/>';
                    } else {
                        document.getElementById('version_' + key).value = val.substring(
                        0, val.indexOf('_'));
                        var sstr = val.substring(val.indexOf('_') + 1);
                        document.getElementById('rank_' + key).value = sstr.substring(
                        0, sstr.indexOf('_'));
                        document.getElementById('priority_' + key).value = sstr.substring(sstr.indexOf('_') + 1);
                        document.getElementById(key).value = sstr.substring(sstr.indexOf('_') + 1);
                    }
                });
            }
        });
    }
}

/**
	* This method is used to move and update the updateStory.
	*
	@author Yuliang Ye
	@created 2012-04-16
	@version 1.0
	@since 24.0
	*
	@param event			
	@param ui		
	*
	@return null
	*
	@changelog
	*2012-04-16 Yuliang Ye <yuliang.ye@itbconsult.com>
	* - Created
	*/

function updateStory(event, ui) {
    sforce.connection.sessionId = sessionId;
    var esArr = [];
    var esIds = '';
    var versions = '';
    var ranks = '';
    var source = document.getElementById('source').value;
    var sprintId = '';
    if (ui.sender == null) {
        var status = $("#" + ui.item[0].parentNode.id).parent().attr("id");
        if (status == 'Backlog') {
            var prioritys = ui.item[0].parentNode.id;
            status = $("#" + prioritys).parent().attr("id");
        } else {
            status = ui.item[0].parentNode.id;
        }
        var tmpprioritys = '';
        if (this.parentNode.id == 'Backlog') {
            $(this).children("div").each(function (index) {
                esArr[index] = $(this).attr("id");
            });
        } else {
            esArr = $(this).sortable("toArray");
        }
        for (var i = 0; i < esArr.length; i++) {
            var esid = esArr[i].substring(esArr[i].indexOf('_') + 1);
            var priVal = document.getElementById('priority_' + esid).value;
            if (priVal == "") {
                priVal = "Would";
                prioritys = "";
            }
            if (status != 'Backlog') {
                if (document.getElementById('category_' + esid).value == status) {
                    tmpprioritys += document.getElementById('priority_' + esid).value + ';';
                    esIds += esid + ';';
                    versions += document.getElementById('version_' + esid).value + ';';

                    if (document.getElementById('sprintrank_' + esid).value != '') {
                        ranks += document.getElementById('sprintrank_' + esid).value + ';';
                    } else {
                        ranks += document.getElementById('rank_' + esid).value + ';';
                    }
                } 
            } else {
                if (document.getElementById('category_' + esid).value == status && priVal == prioritys) {
                    tmpprioritys += prioritys + ';';
                    esIds += esid + ';';
                    versions += document.getElementById('version_' + esid).value + ';';

                    ranks += document.getElementById('rank_' + esid).value + ';';
                } 
            }
        }
        source = document.getElementById('source').value;
    } else if (ui.sender != null) {
        var prioritys = '';
        var tmpprioritys = '';
        var status = ui.item[0].parentNode.id;
        status = $("#" + status).parent().attr("id");
        if (source == 'Backlog') {
            if (status != 'Backlog') {
                sprintId = ui.item[0].parentNode.id;
                status = ui.item[0].parentNode.id;
            } else {
                prioritys = ui.item[0].parentNode.id;
                status = $("#" + prioritys).parent().attr("id");
            }
        } else {
            sprintId = document.getElementById('usSid').value;
            status = ui.item[0].parentNode.id;
        }
        source = document.getElementById('source').value;
        esArr = [];
        esIds = '';
        versions = '';
        ranks = '';

        if (this.parentNode.id == 'Backlog') {
            $(this).children("div").each(function (index) {
                esArr[index] = $(this).attr("id");
            });
        } else {
            esArr = $(this).sortable("toArray");
        }
        for (var i = 0; i < esArr.length; i++) {
            var esid = esArr[i].substring(esArr[i].indexOf('_') + 1);
            esIds += esid + ';';
            if (status == 'Backlog') {
                ranks += document.getElementById('rank_' + esid).value + ';';
                tmpprioritys += prioritys + ';';
            } else {
                tmpprioritys += document.getElementById('priority_' + esid).value + ';';
                if (document.getElementById('sprintrank_' + esid).value != '') {
                    ranks += document.getElementById('sprintrank_' + esid).value + ';';
                } else {
                    ranks += document.getElementById('rank_' + esid).value + ';';
                }
            }

            versions += document.getElementById('version_' + esid).value + ';';
        }
    }

    if (esIds.length > 0) {
        var showVelocity = document.getElementById('showVelocity').value;
        var totalPoints;
	    if(showVelocity == 'true' || showVelocity == 'True' ){
	    	totalPoints= document.getElementById('projectVelocity').value;
	    }
        AgileVizArt.CtrlSprint.updateNewBacklogVelocity(
        esIds, versions, ranks, status, sprintId, source, tmpprioritys, showVelocity, function (result, event) {
            if (result != '') {
                document.getElementById('errorDiv_ep').innerHTML = '';
                $.each(
                result, function (key, val) {
                    if (key.indexOf('error_') != -1) {
                        document.getElementById('errorDiv_ep').innerHTML += val + '<br/>';
                    } else {
                        if (key.indexOf('Sprint_') != -1) {
                            var spid = key.substring(val.indexOf('Sprint_') + 8);
                            if (val.indexOf('SprintVelocity_') != -1 && val.indexOf('_ReleaseVelocity_') != -1) {
                                var velocitySp = val.substring(val.indexOf('SprintVelocity_') + 15, val.indexOf('_ReleaseVelocity_'));
                                var velocityRe = val.substring(val.indexOf('_ReleaseVelocity_') + 17);

                                changeFlag(spid, velocitySp, velocityRe, totalPoints);
                            }
                        } else {
                            document.getElementById('version_' + key).value = val.substring(0, val.indexOf('_'));
                            var sstr = val.substring(val.indexOf('_') + 1);
                            document.getElementById('rank_' + key).value = sstr.substring(0, sstr.indexOf('_'));
                            var cstr = sstr.substring(sstr.indexOf('_') + 1);
                            document.getElementById('sprintrank_' + key).value = cstr.substring(0, cstr.indexOf('_'));
                            var cstr1 = cstr.substring(cstr.indexOf('_') + 1);
                            document.getElementById('category_' + key).value = cstr1.substring(0, cstr1.indexOf('_'));

                            var cstr2 = cstr1.substring(0, cstr1.indexOf('_'));

                            if (cstr2 == 'Backlog') {
                                document.getElementById('hidden_' + 'Backlog').value = 'Backlog';
                                document.getElementById(key).value = 'Backlog';
                            } else {
                                document.getElementById('hidden_' + cstr2).value = cstr2;
                                document.getElementById(key).value = cstr2;
                            }

                            var cstr3 = cstr1.substring(cstr1.indexOf('_') + 1);
                            document.getElementById('storycommentSt_' + key).value = cstr3.substring(0, cstr3.indexOf('_'));

                            var ctr4 = cstr3.substring(cstr3.indexOf('_') + 1);
                            document.getElementById('priority_' + key).value = ctr4.substring(0, ctr4.indexOf('_'));

                            if (ctr4.substring(ctr4.indexOf('_') + 1) == 'Requirement') {
                                document.getElementById('urgPrySe_' + key).value = document.getElementById('priority_' + key).value;
                            }
                        }

                    }
                });
            }
        });
    }
}

// added by xia Tong
function updateReleaseEpicStory(event, ui) {
    sforce.connection.sessionId = sessionId;
    var esArr = [];
    var esIds = '';
    var versions = '';
    var ranks = '';
    var sprintId = '';
    if (ui.sender == null) {
		var priority = '';    
       	var column = $("#" + ui.item[0].parentNode.id).parent().attr("id");
        if (column == 'Backlog') {
            priority = ui.item[0].parentNode.id;
            column = $("#" + priority).parent().attr("id");
        } else {
            column = ui.item[0].parentNode.id;
        }
        var tmpprioritys = '';
        if (this.parentNode.id == 'Backlog') { // for priority column
            $(this).children("div").each(function (index) {
                esArr[index] = $(this).attr("id");
            });
        } else {
            esArr = $(this).sortable("toArray"); // put all ids of ES into a array
        }
        for (var i = 0; i < esArr.length; i++) {
            var esid = esArr[i];
            var priVal = document.getElementById('priority_' + esid).value;
            if (priVal == "") {
                priVal = "Would";
                prioritys = "";
            }
            if (column != 'Backlog') {
                if (document.getElementById('category_' + esid).value == column) {
                	tmpprioritys += document.getElementById('priority_' + esid).value + ';';
                    esIds += esid + ';';
                    versions += document.getElementById('version_' + esid).value + ';';
 					ranks += document.getElementById('rank_' + esid).value + ';';
                } 
            } 
            else {
                if (document.getElementById('category_' + esid).value == column && priVal == priority) {
                	tmpprioritys += priority + ';';
                    esIds += esid + ';';
                    versions += document.getElementById('version_' + esid).value + ';';
                    ranks += document.getElementById('rank_' + esid).value + ';';
                }
            }
        }
    } else if (ui.sender != null) {
        var priority = '';
        var tmpprioritys = '';
        var column = $("#" + ui.item[0].parentNode.id).parent().attr("id");
        if (column == 'Backlog') {
            priority = ui.item[0].parentNode.id;
        } else {
            column = ui.item[0].parentNode.id;
        }
        esArr = [];
        esIds = '';
        versions = '';
        ranks = '';

        if (column == 'Backlog') {
            $(this).children("div").each(function (index) {
                esArr[index] = $(this).attr("id");
            });
        } else {
            esArr = $(this).sortable("toArray");
        }
        for (var i = 0; i < esArr.length; i++) {
          	var esid = esArr[i];
          	if (column == 'Backlog') {
                tmpprioritys += priority + ';';
            } else {
                tmpprioritys += document.getElementById('priority_' + esid).value + ';';
            }
            esIds += esid + ';';
            versions += document.getElementById('version_' + esid).value + ';';
            ranks += document.getElementById('rank_' + esid).value + ';';
        }
    }

    if (esIds.length > 0) {
        AgileVizArt.CtrlProjectReleaseManagement.updateReleaseEpicStory(
        esIds, versions, ranks, column, tmpprioritys, function (result, event) {
            if (result != '') {
                document.getElementById('errorDiv_ep').innerHTML = '';
                $.each(
                result, function (key, val) {
                    if (key.indexOf('error_') != -1) {
                        document.getElementById('errorDiv_ep').innerHTML += val + '<br/>';
                    } else {
                        document.getElementById('version_' + key).value = val.substring(0, val.indexOf('_'));
                        var sstr = val.substring(val.indexOf('_') + 1);
                        document.getElementById('rank_' + key).value = sstr.substring(0, sstr.indexOf('_'));
                        var cstr = sstr.substring(sstr.indexOf('_') + 1);
                        document.getElementById('category_' + key).value = cstr.substring(0, cstr.indexOf('_'));
                        var cstr1 = cstr.substring(cstr.indexOf('_') + 1);
                        document.getElementById('priority_' + key).value = cstr1;
                    }
                });
            }
        });
    }
}


function changeFlag(uiId, v, r, t) {
//alert(v +':'+r+':'+t);
    if (document.getElementById('Velocity_' + uiId) != undefined) {
        var totalPoints, releaseVelocity, Velocity;
        if (t == ''  || t == 'null') {
            t = '0.0';
            totalPoints = 0;
        } else {
            totalPoints = parseFloat(t);
        }

        if (r == '' || r == 'null') {
        	r = '0.0';
            releaseVelocity = 0;
        } else {
            releaseVelocity = parseFloat(r);
        }

        if (v == ''  || v == 'null') {
        	v = '0.0';
            Velocity = 0;
        } else {
            Velocity = parseFloat(v);           
        }
        
        if(t != '0.0'){
        	t = t.substring(0, t.length-1);
        }
        if(r != '0.0'){
        	r = r.substring(0, r.length-1);
        }
        if(v != '0.0'){
        	v = v.substring(0, v.length-1);
        }
        //var title = 'Sprint: ' + Velocity + ' ∅Release: ' + releaseVelocity + ' ∅Project: ' + totalPoints;
        var title = 'Sprint: ' + v + ' ∅Release: ' + r + ' ∅Project: ' + t;
        document.getElementById('Velocity_' + uiId).title = title;
        document.getElementById('Velocity_' + uiId + '_points').innerHTML = v;
        if (Velocity > releaseVelocity && Velocity > totalPoints) {
            document.getElementById('Velocity_' + uiId + '_green').style.display = 'none';
            document.getElementById('Velocity_' + uiId + '_red').style.display = '';
            document.getElementById('Velocity_' + uiId + '_yellow').style.display = 'none';
        } else if ((Velocity >= totalPoints && Velocity < releaseVelocity) || (Velocity <= totalPoints && Velocity > releaseVelocity) ||(Velocity > totalPoints && Velocity <= releaseVelocity) || (Velocity < totalPoints && Velocity >= releaseVelocity)) {
            document.getElementById('Velocity_' + uiId + '_green').style.display = 'none';
            document.getElementById('Velocity_' + uiId + '_red').style.display = 'none';
            document.getElementById('Velocity_' + uiId + '_yellow').style.display = '';
        } else if (Velocity <= totalPoints && Velocity <= releaseVelocity) {
            document.getElementById('Velocity_' + uiId + '_green').style.display = '';
            document.getElementById('Velocity_' + uiId + '_red').style.display = 'none';
            document.getElementById('Velocity_' + uiId + '_yellow').style.display = 'none';
        } else {
            document.getElementById('Velocity_' + uiId + '_green').style.display = 'none';
            document.getElementById('Velocity_' + uiId + '_red').style.display = 'none';
            document.getElementById('Velocity_' + uiId + '_yellow').style.display = 'none';
        }
    }
}

function updatePriorityStory(event, ui) {
    sforce.connection.sessionId = sessionId;
    var doUpdate = false;
    var esArr = [];
    var esIds = '';
    var versions = '';
    var ranks = '';
    var source = '';
    var priority = '';
    if (ui.sender == null) {
        var tmpstatus = '';
        var tmppriority = '';
        var status = ui.item[0].parentNode.id;
        if (status == 'On Hold') {
            status = ui.item[0].parentNode.id;
        } else {
            priority = ui.item[0].parentNode.id;
        }

        esArr = $(this).sortable("toArray");
        for (var i = 0; i < esArr.length; i++) {
            var esid = esArr[i].substring(esArr[i].indexOf('_') + 1);
            if (status != 'On Hold') {
                if (document.getElementById('category_' + esid).value == priority) {
                    esIds += esid + ';';
                    tmpstatus += document.getElementById('storycommentSt_' + esid).value + ';';
                    tmppriority += priority + ';';
                    versions += document.getElementById('version_' + esid).value + ';';

                    ranks += document.getElementById('rank_' + esid).value + ';';
                    source = 'priority';
                    doUpdate = true;
                } else doUpdate = false;
            } else {
                if (document.getElementById('category_' + esid).value == status) {
                    esIds += esid + ';';
                    tmpstatus += status + ';';
                    tmppriority += document.getElementById('priority_' + esid).value + ';';
                    versions += document.getElementById('version_' + esid).value + ';';

                    ranks += document.getElementById('rank_' + esid).value + ';';
                    source = 'status';
                    doUpdate = true;
                } else doUpdate = false;
            }
        }
    } else if (ui.sender != null) {
        var tmpstatus = '';
        var tmppriority = '';
        var status = ui.item[0].parentNode.id;

        doUpdate = true;

        if (status == 'On Hold') {
            status = ui.item[0].parentNode.id;
            source = 'status';
        } else {
            priority = ui.item[0].parentNode.id;
            source = 'priority';
        }

        esArr = [];
        esIds = '';
        versions = '';
        ranks = '';
        esArr = $(this).sortable("toArray");
        for (var i = 0; i < esArr.length; i++) {
            var esid = esArr[i].substring(esArr[i].indexOf('_') + 1);
            esIds += esid + ';';
            if (status == 'On Hold') {
                ranks += document.getElementById('rank_' + esid).value + ';';
                tmppriority += document.getElementById('priority_' + esid).value + ';';
                tmpstatus += status + ';';
            } else {
                tmppriority += priority + ';';
                if (document.getElementById('category_' + esid).value == 'On Hold') {
                    tmpstatus += 'Open;';
                } else {
                    tmpstatus += document.getElementById('storycommentSt_' + esid).value + ';';
                }
                ranks += document.getElementById('rank_' + esid).value + ';';
            }
            versions += document.getElementById('version_' + esid).value + ';';
        }
    }
    if (esIds.length > 0 && doUpdate) {
        AgileVizArt.CtrlPriority.updateBacklog(
        esIds, versions, ranks, tmpstatus, tmppriority, source, function (result, event) {
            if (result != '') {
                document.getElementById('errorDiv_ep').innerHTML = '';
                $.each(
                result, function (key, val) {
                    if (key.indexOf('error_') != -1) {
                        document.getElementById('errorDiv_ep').innerHTML += val + '<br/>';
                    } else {
                        document.getElementById('version_' + key).value = val.substring(
                        0, val.indexOf('_'));

                        var sstr = val.substring(val.indexOf('_') + 1);
                        document.getElementById('rank_' + key).value = sstr.substring(
                        0, sstr.indexOf('_'));
                        var cstr = sstr.substring(sstr.indexOf('_') + 1);
                        document.getElementById('sprintrank_' + key).value = cstr.substring(
                        0, cstr.indexOf('_'));
                        var cstr1 = cstr.substring(cstr.indexOf('_') + 1);

                        document.getElementById('category_' + key).value = cstr1.substring(
                        0, cstr1.indexOf('_'));
                        var cstr2 = cstr1.substring(
                        0, cstr1.indexOf('_'));

                        if (cstr2 == 'On Hold') {
                            document.getElementById('hidden_' + 'On Hold').value = 'On Hold';

                            document.getElementById(key).value = 'On Hold';
                        } else {
                            document.getElementById('hidden_' + cstr2).value = cstr2;

                            document.getElementById(key).value = cstr2;
                        }

                        var cstr3 = cstr1.substring(cstr1.indexOf('_') + 1);
                        document.getElementById('storycommentSt_' + key).value = cstr3.substring(
                        0, cstr3.indexOf('_'));

                        var ctr4 = cstr3.substring(cstr3.indexOf('_') + 1);
                        document.getElementById('priority_' + key).value = ctr4.substring(0, ctr4.indexOf('_'));

                        if (ctr4.substring(ctr4.indexOf('_') + 1) == 'Requirement') {
                            document.getElementById('urgPrySe_' + key).value = document.getElementById('priority_' + key).value;
                        }

                    }
                });
            }
        });
    }
}

function resizeColumns() {
    var target = Math.max($(".epicStory_column").innerHeight());
    $(".epicStory_column").css("min-height", target);
}

function checkSender(event, ui) {
    if (ui.sender != null) {
        if (ui.item[0].parentNode.id == 'Backlog') {
            alert('dont allowed');
            $("#Backlog").sortable({
                disabled: true
            });
        }
    }
}

function Collapse(type) {
    $(".epicStory_column").children(".portlet").find(".portlet-header .ui-icon").removeClass("ui-icon-minusthick");
    $(".epicStory_column").children(".portlet").find(".portlet-header .ui-icon").addClass("ui-icon-plusthick");
    $(".epicStory").find(".ui-icon").removeClass("ui-icon-minusthick");
    $(".epicStory").find(".ui-icon").addClass("ui-icon-plusthick");
    $(".epicStory_column").children(".portlet").find(".portlet-content").css("display", "none");
}

function itb_longword_dobreak(str, break_type) {
    var strTemp = "";
    var mycount = 0;
    var myStr = str;
    strTemp = str.substr(0, break_type);
    if (myStr.length > break_type) {
        strTemp += "..."
    }
    return strTemp;
}

function itb_wrap_word(column) {
    $(".epicStory_column").children(".portlet").find(".portlet-header .ui-icon").removeClass("ui-icon-plusthick");
    $(".epicStory_column").children(".portlet").find(".portlet-header .ui-icon").addClass("ui-icon-minusthick");
    $(".epicStory").find(".ui-icon").removeClass("ui-icon-plusthick");
    $(".epicStory").find(".ui-icon").addClass("ui-icon-minusthick");
    $(".epicStory_column").children(".portlet").find(".portlet-content").css("display", "block");
    
    

    $(".portlet-content>span").each(function (index) {
        var id = $(this).attr("id") + 'Hidden';
        var str = $("input[id*='" + id + "']").attr("value");
        if (str != "") {
            if ($(this).attr("title") != null) {
                $(this).attr("title", itb_translate_sign_replace($(this).attr("title")));
            }
            $(this).attr("text", str);
            str = itb_longword_dobreak(str, column);
        }
        $(this).html(str);
    });
    
    $(".epicStory_column").children(".portlet").find(".portlet-content").find("strong").css('font-weight','normal');
	$(".epicStory_column").children(".portlet").find(".portlet-content").find("strong").css('font-style','normal');
	$(".epicStory_column").children(".portlet").find(".portlet-content").find("strong").css('text-decoration','none');
	$(".epicStory_column").children(".portlet").find(".portlet-content").find("span").removeAttr("style");
	$(".epicStory_column").children(".portlet").find(".portlet-content").find("font").removeAttr("size");
    $(".epicStory_column").children(".portlet").find(".portlet-content").find("font").addClass("fontSize");
    $('div.portlet-content').find("ul").css('margin','0px');
    $('div.portlet-content').find("ul").css('padding','0px');
	$('div.portlet-content').find("ol").css('margin','0px');
    $('div.portlet-content').find("ol").css('padding','0px');
    $('div.portlet-content').find("li").css('margin','0px');
    $('div.portlet-content').find("span img").css('display','none');
    $('div.portlet-content').find("span div").removeAttr("style");
}

function itb_translate_sign(column, defaultSize) { // to filter the code like "&amp;..." in
    // the portlet-header and
    // portlet-content
    $(".epicStory>span").each(function (index) {
        var str = $(this).text();
        if (str != "") {
            str = itb_longword_dobreak(str, column);
        }
        $(this).html(str);
    });

    $(".epicStory .nolink").each(function (index) {
        var str = $(this).text();
        str = itb_longword_dobreak(str, column);
        $(this).html(str);
    });

    $(".epicStory .link").each(function (index) {
        var stra = $(this).find("a").attr("title");
        stra = itb_longword_dobreak(stra, column);
        $(this).find("a").html(stra);
    });

    $(".portlet-header .title").each(function (index) {
        var str = $(this).find("a").attr("title");
        str = itb_translate_sign_replace(str);
        $(this).attr("title", str);
        if (str != "") {
            str = itb_longword_dobreak(str, column * 2);
        }
        $(this).find("a").html(str);
    });

    $(".portlet-header .effort-hours").each(function (index) {
        var str = $(this).text();
        if (str != "") {
            str = itb_longword_dobreak(str, 4);
        }
        $(this).html(str);
    });
     
	var i,j,s="";
	var d=document.getElementsByTagName("div");  
	
	for(i=0;i<d.length;i++) 
	{                                             
		if(d[i].className=="portlet-content")  
		{                       
		    var d2=d[i].getElementsByTagName("span");     
			var dd=d[i].getElementsByTagName("input");    
		     for(j=0;j<dd.length;j++)   
		     {                           
		   		 s = dd[j].value;
		   		 $(d2[j]).html(s);
		    }
		}
	} 

    /*
    $(".portlet-content>span").each(function (index) {
        var id = $(this).attr("id") + 'Hidden';
        var str = $("input[id*='" + id + "']").attr("value");
        if (str != "" && defaultSize != 0) {
            if ($(this).attr("title") != null) {
                $(this).attr("title", itb_translate_sign_replace($(this).attr("title")));
            }
            $(this).attr("text", str);
            str = itb_longword_dobreak(str, defaultSize);
        } else if (defaultSize == 0) {
            Collapse('');
        }
        $(this).html(str);
    });
    */
}

/**
	* This method is used to remove HTMLTag.
	*
	@author Yuliang Ye
	@created 2012-05-24
	@version 1.0
	@since 24.0
	*
	@param column			
	@param defaultSize		
	*
	@return 			null
	*
	@changelog
	*2012-05-24 Yuliang Ye <yuliang.ye@itbconsult.com>
	* - Created
	*/

function removeHTMLTag(str) {
	str = str.replace(/<\/?[^>]*>/g,''); 
	str = str.replace(/[ | ]*\n/g,'\n'); 
	//str = str.replace(/\n[\s| | ]*\r/g,'\n');
	str=str.replace(/&nbsp;/ig,'');//
	return str;
}


function showDes() {
    if (document.getElementById("ShowDes").value != "") {
        $(".epicStory_column").children(".portlet").find(".portlet-content").css("display", "none");
    }
}

function itb_translate_sign_replace(str) {
    str = str.replace(/&amp;/g, "&");
    str = str.replace(/&quot;/g, "\"");
    str = str.replace(/&#39;/g, "'");
    str = str.replace(/&nbsp;/g, " ");
    str = str.replace(/&#160;/g, " ");
    str = str.replace(/&#60;/g, "<");
    str = str.replace(/&lt;/g, "<");
    str = str.replace(/&gt;/g, ">");
    str = str.replace(/&#62;/g, ">");
    str = str.replace(/&#38;/g, "&");
    str = str.replace(/&copy;/g, "?");
    str = str.replace(/&times;/g, "??");
    str = str.replace(/&devide;/g, "??");
    str = str.replace(/&euro;/g, "?");
    return str;
}

var flag = 0;

function itb_edit_efforthours(storyId, inputId) {
    showDiv(inputId);
    document.getElementById(inputId).focus();
    hideDiv('efDiv_' + storyId);

}

function itb_edit_addComment(storyId, inputId) {
    showDiv(inputId);
    document.getElementById(inputId).focus();
    hideDiv('bubblespeak_' + storyId);
}

function itb_hide_inputEffort(storyId, uiId, inputId) {
    var comment = '';
    comment = document.getElementById(inputId).value;
    var esIds = document.getElementById('hidden_' + storyId).value;
    var versions = document.getElementById('version_' + storyId).value;
    var showVelocity = 'fasle';
    if(document.getElementById('showVelocity') != null){
    	showVelocity = document.getElementById('showVelocity').value;
    }
    var totalPoints;
    if(showVelocity == 'true' || showVelocity == 'True' ){
    	totalPoints= document.getElementById('projectVelocity').value;
    }
    //AgileVizArt.CtrlSprint.updateEPoint(
    AgileVizArt.CtrlSprint.updateEPointAndVelocity(
    	esIds, comment, showVelocity, function (result, event) {
        if (result != '') {
            document.getElementById('errorDiv_ep').innerHTML = '';
            $.each(
            result, function (key, val) {
                if (key.indexOf('error_') != -1) {
                    document.getElementById('errorDiv_ep').innerHTML += val + '<br/>';
                }                 
                else {
                    if (key.indexOf('Sprint_') != -1) {
                        var spid = key.substring(val.indexOf('Sprint_') + 8);
                        if (val.indexOf('SprintVelocity_') != -1 && val.indexOf('_ReleaseVelocity_') != -1) {
                            var velocitySp = val.substring(val.indexOf('SprintVelocity_') + 15, val.indexOf('_ReleaseVelocity_'));
                            var velocityRe = val.substring(val.indexOf('_ReleaseVelocity_') + 17);
                            changeFlag(spid, velocitySp, velocityRe, totalPoints);
                        }
                    } 
                    else {
                		document.getElementById('version_' + key).value = val;
                	}
                }
            });
        }
    });
    if (comment != '') document.getElementById('efDiv_' + storyId).innerHTML = comment;
    else document.getElementById('efDiv_' + storyId).innerHTML = '?'

    flag = 0;
    itb_close_epicEfforthours(storyId, inputId);
}


// added by xia Tong
function itb_hide_inputReleaseEffort(storyId, uiId, inputId) {
    var comment = '';
    comment = document.getElementById(inputId).value;
    var esIds = document.getElementById('hidden_' + storyId).value;
    var versions = document.getElementById('version_' + storyId).value;
    var totalPoints;
    AgileVizArt.CtrlProjectReleaseManagement.updateEPointAndVelocity(
    	esIds, comment, false, function (result, event) {
        if (result != '') {
            document.getElementById('errorDiv_ep').innerHTML = '';
            $.each(
            result, function (key, val) {
                if (key.indexOf('error_') != -1) {
                    document.getElementById('errorDiv_ep').innerHTML += val + '<br/>';
                }                 
                else {
                    if (key.indexOf('Sprint_') != -1) {
                        var spid = key.substring(val.indexOf('Sprint_') + 8);
                        if (val.indexOf('SprintVelocity_') != -1 && val.indexOf('_ReleaseVelocity_') != -1) {
                            var velocitySp = val.substring(val.indexOf('SprintVelocity_') + 15, val.indexOf('_ReleaseVelocity_'));
                            var velocityRe = val.substring(val.indexOf('_ReleaseVelocity_') + 17);
                            changeFlag(spid, velocitySp, velocityRe, totalPoints);
                        }
                    } 
                    else {
                		document.getElementById('version_' + key).value = val;
                	}
                }
            });
        }
    });
    if (comment != '') document.getElementById('efDiv_' + storyId).innerHTML = comment;
    else document.getElementById('efDiv_' + storyId).innerHTML = '?'

    flag = 0;
    itb_close_epicEfforthours(storyId, inputId);
}

var eflag = 0;

function itb_edit_epicEfforthours(storyId, inputId) {
    showDiv(inputId);
    document.getElementById(inputId).focus();
    hideDiv('efDiv_' + storyId);
}

function itb_close_epicEfforthours(storyId, inputId) {
    hideDiv(inputId);
    showDiv('efDiv_' + storyId);
}

function showDiv(showId) {
    document.getElementById(showId).style.display = '';
}

function hideDiv(hideId) {
    document.getElementById(hideId).style.display = 'none';
}

function itb_hide_inputEpicEffort(storyId, uiId, inputId) {
    var comment = document.getElementById(inputId).value;
    uiId = document.getElementById(storyId).value;
    var esIds = document.getElementById('hidden_' + storyId).value;
    var versions = document.getElementById('version_' + storyId).value;
    var ranks = document.getElementById('rank_' + storyId).value;
    var priority = uiId + ';' + comment;

    AgileVizArt.CtrlProjectEpicStory.updateEpicEPoint(esIds, comment, function (
    result, event) {
        if (result != '') {
            document.getElementById('errorDiv_ep').innerHTML = '';
            $.each(result, function (key, val) {
                if (key.indexOf('error_') != -1) {
                    document.getElementById('errorDiv_ep').innerHTML += val + '<br/>';
                } 
                else {
                	document.getElementById('version_' + key).value = val;
                }
            });
        }
    });
    if (comment != '') document.getElementById('efDiv_' + storyId).innerHTML = comment;
    else document.getElementById('efDiv_' + storyId).innerHTML = '?'
    eflag = 0;
    itb_close_epicEfforthours(storyId, inputId);
}

function itb_hide_inputStory() {
    $("#popwin").remove();
}

function fillIn(name, id, namefield, idfield) {
    var winMain = window.opener;
    if (null == winMain) {
        winMain = window.parent.opener;
    }
    var ele = winMain.document.getElementById(namefield);
    ele.value = name;
    ele = winMain.document.getElementById(idfield);
    ele.value = id;
    CloseWindow();
}

function CloseWindow() {
    var winMain = window.opener;
    if (null == winMain) {
        winMain = window.parent.opener;
    }
    winMain.closeLookupPopup();
} 
