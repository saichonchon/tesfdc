var __dataMap = false,_numSep,_numDec,__numFormat,_CM,
            _CY,_Months,_CMIdx,_mapM2Y,mapM2M,_accData,_mapSaved,_map_Skip,_Comments,
            _deletedCmt,todayYear,todayMonth,//isTrrChanged,
            //isDataEdited,//needRefreshTer,
            _cmtOption,_pfcOption,_parentAcId,_mapAcAc = {},_mapAcPf = {},_sentMap,
            //_addW,_addH,
            _Midx,_totalCols,_monthBatchSize,_colorConfig,g_elem4cmt,_monthsOfCurrency,
            _hasCommentIndicator;
        /** Utils **/
        function getP(el,target){
            do{
                el = el.parentNode;
            }while(el && el.nodeName != target)
            return el;
        }
        function checkNum(n){
            if(n == ''||n == 0) return true;
            var sep = _numSep, dec = _numDec;
            var reg 
            if(sep) {
                reg = new RegExp(
                '^-?[1-9][0-9]{0,2}(?:\\' + 
                sep + 
                '?\\d{3}){0,}(?:\\'+
                dec+
                '\\d\+)?[KkMmBbTt]?$');
            }else{
                reg = new RegExp(
                        '^-?[1-9][0-9]{0,2}(?:' + 
                        '\\d{3}){0,}(?:\\'+
                        dec+
                        '\\d\+)?[KkMmBbTt]?$');
            }
            
            return reg.test(n);
        }
        /** display effect **/
        function collapseQt(el,needNotSetWidth){
            var historyCount = 0,futureCount = 0;
            var $el = $(el),
                cls = $el.find('.qsts'),
                isCollapse,
                i,j,k;
            if(cls.hasClass('qn')){
                cls.removeClass('qn').addClass('qf').text('+');
                isCollapse = true;
            }
            else{
                cls.removeClass('qf').addClass('qn').text('-');
                isCollapse = false;
            }
            var positions = [],
                count = $el.prevAll('th').length,tds,item;
            positions.push(count - 3,count-2,count-1);

            k = _CMIdx;
            tds = $el.parent().children('th');
            for(i=0,j=positions.length;i<j;i++){
                tds.eq(positions[i]).toggleClass('hide');
            }
            $('#mainTbody').children('tr').each(function(){
                var $tds = $(this).children('td'),_j = _CMIdx,_pos = positions;
                for(var i=0;i<_j;i++){
                    $tds.eq(_pos[i]).toggleClass('hide');
                }
            });
            for(i=0,j=tds.length;i<j;i++){
                cls = tds.eq(i).hasClass('hide');

                if(!cls){
                    if(i<=k) {
                        historyCount++;
                    }
                    else if(i==k+1){
                        if(i % 4 == 3)
                        historyCount++;
                        else
                        futureCount ++;  
                    }
                    else futureCount ++;
                }
            }
            var $row1 = $('#tthd').children();
            $row1.eq(0).attr('colspan',historyCount);
            $row1.eq(1).attr('colspan',futureCount);
            if(!needNotSetWidth){
                resetHorizonWidth();
            }
        }
        function resetHorizonWidth(){

            var actualWidth = getActualDataTableWidth();
            var ctnWidth = getDataAreaWidth();
            var leftWidth = 217;

            var scrollH = $.getScrollbarWidth();
            $('#tableDiv').width(leftWidth+ctnWidth+15+scrollH);
            
            $('#hDiv').width(ctnWidth);
            $('#fcDiv').width(ctnWidth);
            $('#headerCtn').width(actualWidth);
            $('#dataAreaCtn').width(actualWidth);
        }
        function expandAcc(el){
            var dirc = 0;
            var $el = $(el);
            
            if($el.attr('class') == 'expIcn'){
                dirc = 1;
                $el.attr('class','clpsIcn');
            }else{
                $el.attr('class','expIcn');
            }
            el = getP(el,'TR');
            var row = $(el);
            if(dirc == 1) row.addClass('active');
            else row.removeClass('active');
            var pos = row.prevAll('tr').length;
            var AccExp,isAccExp = 0;
            do{
                row = row.next();
                if(dirc ==1){
                    if(row.hasClass('M2Acc')){
                        AccExp = row.prev().children().eq(0).find('span.iconDeduct');
                        if(AccExp.length > 0){//all shown
                            isAccExp = 1;
                        }else{//hidden
                            break;
                        }
                    }
                    if(isAccExp == 1 && row.hasClass('acc_start')) break;
                }else{
                    if(row.hasClass('acc_start')) break;
                }

                if(dirc == 0)
                row.addClass('hide');
                else
                row.removeClass('hide');
            }while(row && row.length > 0)

            row = $('#mainTbody').children().eq(pos);
            do{
                row = row.next();
                if(dirc ==1){
                    if(row.hasClass('M2Acc') && isAccExp == 0){
                        break;
                    }
                    if(isAccExp == 1 && row.hasClass('acc_start')) break;
                }else{
                    if(row.hasClass('acc_start')) break;
                }
                if(dirc == 0)
                row.addClass('hide');
                else
                row.removeClass('hide');
            }while(row && row.length > 0)

            row = $('#signTbody').children().eq(pos);
            do{
                row = row.next();
                if(dirc ==1){
                    if(row.hasClass('M2Acc') && isAccExp == 0){
                        break;
                    }
                    if(isAccExp == 1 && row.hasClass('acc_start')) break;
                }else{
                    if(row.hasClass('acc_start')) break;
                }
                if(dirc == 0)
                row.addClass('hide');
                else
                row.removeClass('hide');
            }while(row && row.length > 0)

            if(dirc == 0)
            $('#lTbody').children('.acc_start').each(function(){
                if($(this).find('span').attr('class') == 'clpsIcn'){
                    dirc = 1;
                    return false;
                }
            });
            var $img = $('#ArrowAll');//.children();
            var expLabel = GexpLabel,
                clpLabel = GclpLabel;
            if(dirc ==1){
                $img.attr('class','iconDeduct');//text('-');
                $('#ArrowAll').next().text(clpLabel);
            }else{
                $img.attr('class','iconPlus');
                $('#ArrowAll').next().text(expLabel);
            }
            //checkHeight();
        }
        function expandAccy(el){ 
            var dirc = 0;
            var $el = $(el);
            
            if($el.hasClass('iconPlus')){
                dirc = 1;
                $el.attr('class','iconDeduct');
            }else{
                $el.attr('class','iconPlus');
            }
            el = getP(el,'TR');
            var row = $(el);
            var pos = row.prevAll('tr').length;
            do{
                row = row.next();
                if(row.hasClass('acc_start')) break;
                if(dirc == 0)
                row.addClass('hide');
                else
                row.removeClass('hide');
            }while(row && row.length > 0)
            row = $('#mainTbody').children().eq(pos);
            do{
                row = row.next();
                if(row.hasClass('acc_start')) break;
                if(dirc == 0)
                row.addClass('hide');
                else
                row.removeClass('hide');
            }while(row && row.length > 0)

            row = $('#signTbody').children().eq(pos);
            do{
                row = row.next();
                if(row.hasClass('acc_start')) break;
                if(dirc == 0)
                row.addClass('hide');
                else
                row.removeClass('hide');
            }while(row && row.length > 0)

            //checkHeight();
        }
        function checkHeight(){
            
        }
        // param str -- it can not be ''
        function sToN(str){// only return integer !!
            if(_numSep != null && _numSep != '') {
                str = str.replace(new RegExp('\\'+_numSep,'g'),'');
            }
            str = str.replace(_numDec,'.');
            //added by bin yuan
            var multi = 1000;
            str = Math.round(multi * parseFloat(str));
            return str;
        }
        function cpt(el){
            var $el = $(el),elVal = $el.val();
            if(elVal == '' || elVal == null) elVal = '0';
            if(!checkNum(elVal)){
                alert(GMsgInvalidNum);
                $el.val('').focus();
                return false;
            }
            var idx = $el.parent().prevAll('td').length,
                id = $(getP(el,'TR')).attr('id'),
                data = _accData,
                i,j,cTotal = 0,qTotal = 0,start,arry,lTotal,cM = _CMIdx,totalCols = _totalCols;
            elVal = sToN(elVal);
            
            
            //also update the input color -- begin
            //the input compared not with "previous month forecast" but with "calculated fc proposal"
            //--2014-03-17
            var prevFc = $(getP(el,'TR')).next().children().eq(idx).text();
            if(!$.trim(prevFc)) prevFc = 0;
            else
            prevFc = sToN(prevFc);
            if(isNaN(prevFc)) prevFc = 0;

            var clsName;

            //they are rounded to thousand, so will display 0 in case less than 500
            //therefore judge by 500, not 0
            //AM Colour Highlighting only for CM - CM+1
            
            if(idx > cM && isCurrencyMonth(idx,cM)){
                if(Math.abs(prevFc) >= 500){
                    var diffRate = (elVal - prevFc)/prevFc;
                    clsName = getRateColor(diffRate);
                }else{
                    if(Math.abs(elVal) < 500){
                        clsName = '#fff';
                    }else{
                        //calculated is displayed as 0, but input is not 0, in this case if input > 0 show green
                        if(elVal > 0){
                            clsName = getColor('Green');
                        }else{
                            clsName = getColor('Red');
                        }
                    }
                }
            }else{
                clsName = '#fff';
            }
            $el.attr('class',clsName).parent().css('background-color',clsName);
            //also update the input color -- end
            
            for(i=idx;i>0;i--){//or i >= current Month idx, I think no difference on efficiency
                if(i%4 == 0){
                    start = i;
                    break;
                }
            }
            
            for(i=0,j=data.length;i<j;i++){
                arry = data[i]['ary'];
                if(data[i]['id'] == id){
                    arry[idx] = elVal;
                    lTotal = arry[start+3] = arry[start]+arry[start+1]+arry[start+2];
                    lTotal = nK(lTotal,0);
                    $el = $el.parent();
                    if(idx-start == 0){
                        $el.next().next().next().text(lTotal);
                    }else if(idx-start == 1){
                        $el.next().next().text(lTotal);
                    }else{
                        $el.next().text(lTotal);
                    }
                }
                cTotal += arry[idx];
                qTotal += arry[start+3];
            }
            
            $(el).val(nK(elVal,0));
            
            cTotal = nK(cTotal,0);
            qTotal = nK(qTotal,0);
            $el = $('#line_Total').children();
            $el.eq(idx).text(cTotal);
            $el.eq(start+3).text(qTotal);
            //isDataEdited = true;
        }
        function cal(data){
            var i,j,arry,r,k,g,result = new Array(14),cidx = _CMIdx,subtotal,totalCols = _totalCols;
            for(i=0;i<14;i++){
                result[i] = new Array(totalCols);
                if(i<10 || i == 13)
                for(j=0;j<totalCols;j++) result[i][j] = 0;
                else 
                for(j=0;j<totalCols;j++) result[i][j] = [0,0];
            }
            
            for(i=0,j=data.length;i<j;i++){
                arry = data[i].ary;
                for(k=13;k>=0;k--){
                    if(k!= 13)
                    r = arry[k];
                    else r = arry[31];
                    subtotal = 0;
                    if(k > 9 && k !=13){
                        for(g=0;g<cidx;g++){
                            if(g%4 != 3){
                                result[k][g][0] += arry[k][g]||0;
                                result[k][g][1] += arry[33][g]||0;
                            }
                        }
                    }else{
                        for(g=0;g<totalCols;g++){
                            if(g%4 != 3){
                                if(k!=6){
                                    result[k][g] += r[g]||0;
                                }else if(k==6)
                                    result[k][g] = result[k+1][g] + result[k+2][g];
                                subtotal += result[k][g]||0;
                            }else{
                                result[k][g] = subtotal;
                                subtotal = 0;
                            }
                        }
                    }
                }
            }
            for(i=0;i<totalCols;i++){
                result[5][i] /= result[13][i];//see line 353, [13] hold the value [31]
            }
            
            for(i=10;i<13;i++){
                arry = result[i];
                j = 0;
                for(k=0;k<cidx;k++){
                    if(k%4 != 3){
                        j += arry[k][0];
                        g += arry[k][1];
                        
                        if(arry[k][1] != 0)
                        arry[k] = Math.round(100*arry[k][0]/arry[k][1])/100;
                        else
                        arry[k] = 0;
                    }else{
                        arry[k] = Math.round(100*j/g)/100;
                        j = g = 0;
                    }
                }
            }
            i = $('#line_Total'),j=0;
            
            
            var getC = function (r,c){
               var w = cidx;
               if(c < w){
                   if(r>5 && r < 10 || r<3&&r>0) return true;
               }else if(c==w){
                   if(r > 9 && r < 13) return true;
               }else{
                   if(r > 9 && r < 13 ||r==4||r==5) return true;
                   else if(r == 9 && c-w > 3) return true;
                   else if(r == 2 && c-w > 6) return true;
               }
               return false;
            };
           
            do{
                i.children().each(function(idx){
                    var num = result[j][idx];
                    if(isNaN(num)) num = 0;
                    num = Math.round(num*100)/100;
                    if(idx%4 != 3 && getC(j,idx) && !(num > 0)){
                        //added by bin yuan
                        //$(this).addClass('ck');
                        //End
                    }else{
                        if(j>9){
                            $(this).text(Math.round(100*num)+'%');
                            /* to delete after test
                            if(idx+1 < totalCols)
                                $(this).text(Math.round(100*num)+'%');
                            else{
                                $(this).find('.ts').text(Math.round(100*num)+'%');
                            }
                            */
                        }
                        else{
                            if(j != 5) num = nK(num,0);
                            else{
                                num = n2S(num,2);
                            }
                            $(this).text(num);
                            /* to delete after test
                            if(idx+1 < totalCols)
                                $(this).text(num);
                            else{
                                if(j!= 0)
                                $(this).find('.ts').text(num);
                                else
                                $(this).text(num);
                            }
                            */
                        }
                    }
                });
                j++;
                if(j==10)i = i.next();
                i = i.next();
            }while(j<13 && i.length > 0)
        }
        function getFmMap(){
            var y = todayYear,m = todayMonth,i = _CMIdx,j,ary=[],mapM = ['Oct','Nov','Dec','Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep'],totalCols = _totalCols;
            for(;i>0;i--){//not >= 0
                if(i%4 != 3){
                    m --;
                    if(m < 1){
                        m = 12;
                        y--;
                    }
                }
            }
            for(i=0;i<totalCols;i++){
                if(i%4 != 3){
                    ary.push({year:y,month:mapM[m-1]})
                    m++;
                    if(m > 12){
                        m =1;
                        y ++;
                    }
                }else{
                    ary.push({year:y,month:''})
                }
            }
            return ary;
        }
        function setMonths(){
            //var mapMonth = ['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'];
            //var mapMonth = ['01','02','03','04','05','06','07','08','09','10','11','12'];
            //var mapM = {'Jan':'10', 'Feb': '11', 'Mar' : '12', 'Apr' : '01', 'May' : '02', 'Jun' : '03', 'Jul' : '04', 'Aug' : '05', 'Sep' : '06', 'Oct' : '07', 'Nov' : '08', 'Dec' : '09'};
            var mapM = getFmMap();
            var cMIdx = _CMIdx,$row1 = $('#tthd'),$row2 = $('#bthd');
            var counter = $row1.children().length;
            var i,totalCols = _totalCols,cls,strTh1 = '',strTh2 = '',strTd = '',historyPos = 0,futurePos = 0;
            var historyRightPos = cMIdx - 1 - cMIdx%4;
            
            for(i = 0;i < totalCols;i++){
                    if(i%4 != 3){
                        /*
                        if(i <= cMIdx){
                            if(i==0){
                                strTh1 += '<th class="hyTh">';
                                strTh1 += '<span class="leftSideImgDiv"><img src="'+imgHistoryLeftSide+'"/></span>';
                                strTh1 += '</th>';
                            }else if(i == cMIdx){
                                strTh1 += '<th class="hyTh">';
                                strTh1 += '<div class="rightSideImgDiv"><img src="'+imgHistoryRightSide+'"/></div>';
                                strTh1 += '</th>';
                            }
                            else
                            strTh1 += '<th class="hyTh"></th>';
                        }else{
                            if(i == cMIdx + 1){
                                strTh1 += '<th class="ftTh">';
                                strTh1 += '<span class="leftSideImgDiv"><img src="'+imgFutureLeftSide+'"/></span>';
                                strTh1 += '</th>';
                            }
                            else if(i == totalCols-1){
                                strTh1 += '<th class="ftTh">';
                                strTh1 += '<div class="rightSideImgDiv"><img src="'+imgFutureRightSide+'"/></div>';
                                strTh1 += '</th>';
                            }
                            else
                            strTh1 += '<th class="ftTh"></th>';
                        }
                        */
                        //strTh1 += '<th ></th>';
                        strTd += '<td></td>';
                        strTh2 += '<th><span><div></div></span></th>';
                    }else{
                        
                        if(i <= cMIdx){
                            /*
                            if(historyPos == 0){
                                strTh1 += '<th class="tLbl hyTh"><span class="leftSideImgDiv"><img src="'+imgHistoryLeftSide+'"/></span><div><span class="slBl">' + labelHistory +'</span></div>';
                                if(i == historyRightPos){
                                    strTh1 += '<div class="rightSideImgDiv hide"><img src="'+imgHistoryRightSide+'"/></div>';
                                }
                                strTh1 += '</th>';
                            }else if(i == cMIdx){
                                strTh1 += '<th class="hyTh"><div class="rightSideImgDiv"><img src="'+imgHistoryRightSide+'"/></div></th>';
                            }else{
                                strTh1 += '<th class="hyTh">';
                                if(i == historyRightPos){
                                    strTh1 += '<div class="rightSideImgDiv hide"><img src="'+imgHistoryRightSide+'"/></div>';
                                }
                                strTh1 += '</th>';
                            }
                            */
                            historyPos ++;
                        }
                        else if(i==cMIdx+1){
                            if(i % 4 == 3)
                            historyPos++;
                            else
                            futurePos ++;  
                        }
                            
                        else{
                            /*
                            if(futurePos == 0){
                                strTh1 += '<th class="ftTh"><span class="leftSideImgDiv"><img src="'+imgFutureLeftSide+'"/></span></th>';
                            }else if(i==totalCols-1){
                                strTh1 += '<th class="ftTh"><div class="rightSideImgDiv"><img src="'+imgFutureRightSide+'"/></div></th>';
                            }else 
                            if(futurePos == 1){
                                strTh1 += '<th class="tLbl ftTh"><div><span class="slBl">'+ labelFuture +'</span></div></th>';
                            }else 
                            strTh1 += '<th class="ftTh"></th>';
                            */
                            futurePos ++;
                        }
                        
                        //strTh1 += '<th></th>';
                        strTd += '<td class="ct"></td>';
                        strTh2 += '<th onclick="collapseQt(this);"><div class="qtDiv"><span class="qtxt"><div></div></span><div class="qsts qn">-</div></div></th>';
                    }
            }
            $row1.children().eq(0).attr('colspan',historyPos);
            $row1.children().eq(1).attr('colspan',futurePos);
            if(strTh2 != ''){
                $row2.html(strTh2);
                $('#mainTbody').children().each(function(idx){
                    if(idx > 13) return false;
                    var row = $(this);
                    row.html(strTd);
                    
                    var cls;
                    if(idx > 3){
                        if(idx < 10){
                            cls = 'rt3';
                        }else{
                            cls = 'rt4';
                        }
                    }else if(idx > 0){
                        if(idx == 3){
                            cls = 'rt2';
                        }else{
                            cls = 'rt1';
                        }
                    }
                    row.children().eq(-1).attr('class','ct');
                    if(idx == 10){
                        row.children().eq(3).addClass('pltd').html('<span class="plh">I</span>');
                    }
                });
            }
            
            var _months = _Months;
            var mapY = _mapM2Y;
            //might need further decide Qx
            $('#bthd').children().each(function(idx){
                //if(idx == totalCols) return false;
                    var year,qyear;
                    if(idx %4 == 3){
                        year = mapM[idx]['year'];
                        year = ''+year;
                        if(year.length > 2){
                            year = year.substr(2);
                        }
                        if(idx < cMIdx) this.className = 'Total';
                        else if(idx == cMIdx||idx == cMIdx + 1)this.className = 'Total';//'CM Total';
                        else this.className = 'Total';
                        tmp = _months[idx-1];// the prev td is the last month of this Quarter
                        tmp = Math.round(tmp/3);
                        qyear = ''+mapY[idx-1];
                        if(qyear.length > 2) qyear = qyear.substr(2);
                        $(this).find('.qtxt')
                            .children('div').eq(0).text('Q' + tmp+' / '+qyear);//.end()
                            //.eq(1).text(qyear);
                            //text('Q' + tmp + '/' + qyear);
                    }else{
                        
                        year = mapM[idx]['year'];
                        year = ''+year;
                        if(year.length > 2){
                            year = year.substr(2);
                        }
                        var tmp = mapM[idx]['month'];
                        
                        $(this).find('div').eq(0).text(tmp+' / '+year);//.end().eq(1).text(year);
                        this.className = 'monthLabel';
                        
                    }
            });
        }
        function getMonthsOfCurrency(cmIdx){
            if(_monthsOfCurrency) return _monthsOfCurrency;
            var monthsOfCurrency=[];
            var i=0,ii=cmIdx;
            while(i<4){
                if(ii%4 != 3){
                    monthsOfCurrency.push(ii);
                    i++;
                }
                ii++;
            }
            return _monthsOfCurrency = monthsOfCurrency;
        }
        function isCurrencyMonth(m,cmIdx){
            var monthsOfCurrency = getMonthsOfCurrency(cmIdx);
            for(var i=0,j=monthsOfCurrency.length;i<j;i++){
                if(m == monthsOfCurrency[i]){
                    return true;
                }
            }
            return false;
        }
        function updateData(){
            //define local variable for repeated use
            var d,ac,y,m,_y,_m,count,count1,CY = _CY,CM = _CM,mapM2Y={},mapM2M={},accData = [],acc_Data = [],
                temp,subtotal = [],i,j,f,sbtWeekDay = -1,c1,c2,c3,c4,c5,c6,cc,arry,map_Skip=[],
                itms,ct1,ct2,ct3,map_ewDays,ewDay,totalCols,cmtMap,csum,ii,tmpNum,temMod;
            
            f = $('#theData');
            d = f.text();
            //f.empty();
            f = null;
            d = $.parseJSON(d);
            f = $('#effworkDays').text();
            map_ewDays = $.parseJSON(f);
            count=count1=0;
            //if(!_Months){
                _Months = [];
                temp = $('#fiscalInfo').text();
                temp = $.parseJSON(temp);
                
                arry = [];
                //map_Skip = temp;
                for(y in temp){
                    arry.push(y);
                }
                
                arry.sort();
                
                for(i=0;i<arry.length;i++){
                    y = arry[i];
                    _y = parseInt(y,10);
                    m = temp[y];
                    map_Skip[i] = {year:y,months:m};
                    for(j=0,f=m.length;j<f;j++){ 
                        _Months.push(m[j]);
                        _m = parseInt(m[j],10);
                        mapM2Y[count]=y;
                        mapM2M[count]=_m;
                        
                        count++;
                        if(count%4 == 3){
                            count++;
                            _Months.push(-1);//placeholder, here is a total column.
                        }
                        if(_y < CY||_y==CY && _m < CM){
                            count1 = count;
                        }
                    }
                }
                _totalCols = totalCols = _Months.length;
                _CMIdx = count1;
                _mapM2Y = mapM2Y;
                _mapM2M = mapM2M;
                _map_Skip = map_Skip;
                
                setMonths();
                
            //}
                        //process d
            //set up a map from month to its column,to avoid repeated calculation. -- begin
            count1 = _CMIdx;
            
            count = 0;
            map_Skip = _map_Skip;
            for(i=count1-1;i>=0;i--){
                if(i%4 != 3){
                    count++;
                    //eval('c'+count+'='+i);//eval is not good at efficiency,so abort this way.
                    switch(count){
                        case 1: 
                        c1 = i;break;
                        case 2: 
                        c2 = i;break;
                        case 3: 
                        c3 = i;break;
                        case 4: 
                        c4 = i;break;
                        case 5: 
                        c5 = i;break;
                        case 6: 
                        c6 = i;break;
                    }
                    if(count ==6) break;
                }
            }
            for(i=0;i<13;i++) subtotal[i] = 0;
            var keyY,keyM,Other=_Other;
            var acs = [];
            for(ac in d) acs.push(ac);
            acs.sort(function(a,b){
                if(a=='OTHER') return 1;
                if(b=='OTHER') return -1;
                if(a<b) return -1;
                if(a>b) return 1;
                return 0;
            });
            var cmtLth=0;
            var _booktobill;
            for(var x=0,z=acs.length;x<z;x++){
                ac = acs[x];
                temp = {id:ac,ary:new Array(34)};
                arry = temp.ary;
                for(i=0;i<34;i++) arry[i]=new Array(totalCols);
                if(ac == 'OTHER') temp.Name = Other;
                count = 0;
                ct1 = ct2 = ct3 = -1;
                sbtWeekDay = -1;
                
                for(var ye =0;ye < map_Skip.length;ye ++){
                    y = map_Skip[ye]['year'];
                    if(!temp.Name && d[ac][y]['acctName'])
                    temp.Name = d[ac][y]['acctName'];
                    _y = parseInt(y,10);
                    
                    keyY = map_Skip[ye]['months'];
                    itms = d[ac][y]['map_acctMonthlyFCItem'];
                    for(keyM in keyY){
                        m = keyY[keyM];
                        if(map_ewDays[y] && map_ewDays[y][m])
                            ewDay = map_ewDays[y][m];
                        else
                            ewDay = 20;//default working days
                        if(!itms[m]){
                            for(i=0;i<34;i++){
                                arry[i][count] = 0;
                            }
                            arry[21][count] = ewDay;
                        }else{
                            f = itms[m];
                            if(sbtWeekDay < 0 && count>=count1){
                                if(typeof arry[21][c3] !='undefined' && typeof arry[21][c2]!='undefined' 
                                    &&typeof arry[21][c1] !='undefined')
                                sbtWeekDay = arry[21][c3]+arry[21][c2]+arry[21][c1];
                                else
                                sbtWeekDay = 0;
                            }
                            
                            //calculate currency
                            cc=count-count1;
                            
                            //calculate proposal forecast
                            arry[7][count] = f['demandOpen'];//f['orderBacklog'];
                            arry[8][count] = f['scheAgreements'];
                            //number on page are rounded, so it might display Orders 33,Schedule Agreements 10,but Demand open 42,
                            //they look not equal. The quarter total and Total number are also possibly "not equal" this way.
                            //So round them here.
                            arry[7][count] = roundK(arry[7][count]);
                            arry[8][count] = roundK(arry[8][count]);
                            arry[6][count] = arry[7][count] + arry[8][count];//f['backlog'];

                            if(count < count1){
                                //arry[1][count] = 0;
                                arry[2][count] = '';//by fuqi Aug6 2014, if '', it might cause mistake when calculate the sum.
                                arry[12][count] = f['qtAccuracy'];//Math.round(100*Math.random())/100;
                                if(f['bill']!=0){
                                    arry[10][count] = f['forecast2Month'];///f['bill'];
                                    arry[11][count] = f['forecast6Month'];///f['bill'];
                                }else{
                                    arry[10][count] = 0;
                                    arry[11][count] = 0;
                                }
                            }else{ 
                                arry[2][count] = f['prevMonthFC'];//arry[30][ct1];
                                if(typeof arry[2][count] == 'undefined')
                                arry[2][count] = 0;
                                arry[12][count] = 0;
                            }   
                           
                            arry[3][count] = f['budgetPlanBL'];
                            arry[4][count] = f['demandShipped']||0;//change from "bill" to this filed - 2014-01-23
                            arry[31][count] = f['bill'];//it is hidden,just kept for calculation - 2014-01-23
                            arry[33][count] = arry[4][count]+(f['demandOpen']||0);//these two are needed in calculation of 2M/6M/quarterly - 2014-03-24
                            arry[5][count] = f['bookToBill'];
                            
                            
                            //given values for calculation use
                            
                            arry[13][count] = f['backlog0'];
                            arry[14][count] = f['backlog1'];
                            arry[15][count] = f['backlog2'];
                            arry[16][count] = f['backlog3'];
                            arry[17][count] = f['currency1'];//f['bill'] - f['backlog0'];//f['currency1'];
                            arry[18][count] = f['currency2'];//f['bill'] - arry[14][ct1];//f['currency2'];
                            arry[19][count] = f['currency3'];//f['bill'] - arry[15][ct2];//f['currency3'];
                            arry[20][count] = f['currency4'];//f['bill'] - arry[16][ct3];//f['currency4'];
                            arry[21][count] = ewDay;//f['effectDays'];
                            //currency --begin
                            //if(count >= count1 && count < count1+4){
                            if(isCurrencyMonth(count,count1)){
                                //j = 17+count-count1;// j should be calculated as below
                                csum = 0;
                                for(ii=count1;ii<=count;ii++){
                                    if(ii%4 != 3) csum ++;
                                }
                                j = 16 + csum;
                                /////
                                if(typeof arry[j][c3] !='undefined' && typeof arry[j][c2] !='undefined'&&typeof arry[j][c1] !='undefined'
                                    &&typeof ewDay !='undefined' && sbtWeekDay > 0)
                                {
                                    arry[9][count] = (arry[j][c3]+arry[j][c2]+arry[j][c1])*ewDay/sbtWeekDay;
                                }else
                                arry[9][count] = 0;
                            }else
                                arry[9][count] = 0;
                            //currency --end
                            
                            //the calculated proposal is modified as per requirement on 2014-03-14 --begin
                            /*
                            if(count == count1)
                                arry[1][count] = f['bill']+f['orderBacklog']+(arry[9][count]<0?0:arry[9][count]);
                            else if(count > count1)
                                arry[1][count] = f['orderBacklog']+(arry[9][count]<0?0:arry[9][count]);
                            */
                            arry[1][count] = 0;
                            if(!isNaN(arry[6][count])){
                                arry[1][count] += arry[6][count];
                            }
                            if(!isNaN(arry[9][count])){
                                tmpNum = roundK(arry[9][count]);//reason as above arry[6][count]
                                arry[9][count] = tmpNum;
                                arry[1][count] += tmpNum;
                            }
                            
                            //the calculated proposal is modified as per requirement on 2014-03-14 --end

                            //Backlog at beginning
                            arry[22][count] = f['backlog0'];//month
                            arry[23][count] = count>0 ? arry[14][ct1]:-1;//month-1
                            arry[24][count] = count>1 ? arry[15][ct2]:-1;//month-2
                            arry[25][count] = count>2 ? arry[16][ct3]:-1;//month-3
                            //Average currency
                            if(count == count1){
                                arry[26][count] = (arry[17][c1]+arry[17][c2]+arry[17][c3]+arry[17][c4]+arry[17][c5]+arry[17][c6])/6;//Average currency 1
                                arry[27][count] = (arry[18][c1]+arry[18][c2]+arry[18][c3]+arry[18][c4]+arry[18][c5]+arry[18][c6])/6;//Average currency 2
                                arry[28][count] = (arry[19][c1]+arry[19][c2]+arry[19][c3]+arry[19][c4]+arry[19][c5]+arry[19][c6])/6;//Average currency 3
                                arry[29][count] = (arry[20][c1]+arry[20][c2]+arry[20][c3]+arry[20][c4]+arry[20][c5]+arry[20][c6])/6;//Average currency 4
                            }
                            arry[30][count] = f['fc'];
                            _m = parseInt(m,10);
                            ///////********************
        //if(typeof f['fc'] == 'undefined'){
                            if(count < count1){
                            	//Fuqi on 2014-11-12 : according to new requirement, adjust the logic
                            	/*
                                if(f['bill'] != '')
                                arry[0][count] = f['bill'];
                                else if(arry[2][count] != '')
                                arry[0][count] = arry[2][count];
                                else 
                                arry[0][count] = arry[1][count];
                                */
                                if(f['prevMonthFC'] != ''){
	                                arry[0][count] = f['prevMonthFC'];
                                }else if(f['bill'] != ''){
	                                arry[0][count] = f['bill'];
                                }else 
                                arry[0][count] = arry[1][count];
                            }else{
                            	if(typeof f['fc'] == 'undefined'){
	                                if(arry[2][count]!='')
	                                arry[0][count] = arry[2][count];
	                                else 
	                                arry[0][count] = arry[1][count];
                                }else{
	                                arry[0][count] = f['fc'];
                                }
                            }
        //}else
        //arry[0][count] = f['fc'];
        //********************
                            for(i=0;i<10;i++){
                                if(i == 5) subtotal[i] += (f['bookToBill']||0);
                                else 
                                subtotal[i] += !arry[i][count]?0:arry[i][count];
                            }
                            //keep the comment indicator
                            arry[32][count] = f['comtIndicator'];

                        }
                        if(ct2 >= 0)
                        ct3 = ct2;
                        if(ct1 >= 0)
                        ct2 = ct1;
                        ct1 = count;
                        
                        count++;
                        if(count%4 == 3){
                            for(i=0;i<13;i++){
                                if(i<10){
                                    arry[i][count] = Math.round(100*subtotal[i])/100;
                                    subtotal[i] = 0;
                                }else{
                                    if(count < count1){
                                        if(arry[31][ct3]+arry[31][ct2]+arry[31][ct1] != 0){
                                            //kevin modify
                                            arry[31][count]=arry[31][ct3]+arry[31][ct2]+arry[31][ct1];
                                            arry[i][count] = Math.round(100*(arry[i][ct3]+arry[i][ct2]+arry[i][ct1])/(arry[31][ct3]+arry[31][ct2]+arry[31][ct1]))/100;
                                        }else{
                                            arry[i][count] = 0;
                                        }
                                        
                                    }else arry[i][count] = 0;
                                }
                            }
                            count++;
                            if(cmtLth < count) cmtLth = count;
                        }
                    }
                }
                accData.push(temp);
                acc_Data.push({id:ac,ary:arry[0],cmt:new Array(cmtLth - count1)});
            }
            
            itms = f = arry = temp = d = null;
            _accData = acc_Data;
            acc_Data = null;
            //end process
            temp = '',itms='',d='';
            
            if(accData.length > 0)
            for(i=0,j=accData.length;i<j;i++){
                f = getUnitLStr(accData[i]);
                temp += f[0];
                d += f[1];
                itms += getUnitStr(accData[i]);
            }
            
            $('#lTbody').append(temp);
            $('#mainTbody').append(itms);
            $('#signTbody').append(d);
            f = d = temp = itms = null;
            cal(accData);
            return;
        }
        function roundK(num){
            var isNegative = false;
            if(num < 0){
                isNegative = true;
                num = -num;
            }
            var temMod = num % 1000;
            if(temMod > 500){
                num += (1000 - temMod);
            }else{
                num -= temMod;
            }
            if(isNegative) num = -num;
            return num;
        }
        function nK(num,decNum){
            return nS(num /= 1000,decNum);
        }
        function nS(num,decNum){
            var isNegative = false;
            if(num < 0) {
                isNegative = true;
                num = -num;
            }
            var p = Math.pow(10,decNum);
            num = Math.round(p*num)/p;
           num = n2S(num,decNum);
           if(isNegative) num = '-'+num;
           return num;
        }
        function n2S(num,decNum){ // num must be >= 0
            num = num.toFixed(decNum);
            num = (''+num).split('.');
           var s1 = num[0], s2 = num.length > 1?num[1]:'',
               reg = /(\d+)(\d{3})/,
               sep = _numSep,
               dec = _numDec;
           if(sep != '' && /^\D/.test(sep)){//when sep=='', it can be infinite loop here
               while(reg.test(s1)){
                   s1 = s1.replace(reg,'$1'+ sep + '$2');
               }
           }    
           if(s2 != '')
           num = s1 + dec + s2;
           else 
           num = s1;
           return num;
        }
        function getUnitLStr(acc){
           var tmp = [],j,tmp4Sign=[];
           try{
               tmp.push('<tr class="acc_start"><td class="ca"><span class="acName"><a href="/',acc.id,'" title="',acc.Name,'" target="_blank" class="acName">',acc.Name,'</a></span><span onclick="expandAcc(this);" class="clpsIcn"></span></td></tr>');
               tmp4Sign.push('<tr class="acc_start"><td class="signPh"><span class="sfh">I</span></td></tr>');
               var titleMap = GtitleMap;
               var tin,rcls,dcls,lcls;
               for(j=1;j<13;j++){
                    if(j==7||j==8||j>9) {
                        tin = 'tjn';
                        lcls = 'rowLabel1';
                    }else{
                        tin = 'tin';
                        lcls = 'rowLabel';
                    }
                   //if(j<7 ||j>8) tin = 'tin';
                   //else tin = 'tjn';
                   if(j%2==0) rcls = 'evn';
                   else rcls = 'odd';
                   
                   if(j<3) dcls = ' rt1';
                   else if(j==3) dcls = ' rt2';
                   else if(j< 10) dcls = ' rt3';
                   else dcls = ' rt4';
                   
                   if(j==10){
                        rcls += ' zc M2Acc hide';
                        tmp.push('<tr class="AccyRow evn"><td class="tin rt4"><div class="accrDiv"><span onclick="expandAccy(this);" class="iconPlus"></span></div>',GAccuracy,'</td></tr>');
                        tmp4Sign.push('<tr><td class="rt4"><span class="sfh">I</span></td></tr>');
                   }else if(j>10){
                        rcls += ' zc hide';
                   }
                   tmp.push('<tr class="',rcls,'"><td class="',tin,' ',dcls,'">',titleMap[j-1],'</td></tr>');
                   tmp4Sign.push('<tr class="',rcls,'"><td class="',dcls,'"><span class="sfh">I</span></td></tr>');
               }
               tmp = tmp.join('');
               tmp4Sign = tmp4Sign.join('');
               return [tmp,tmp4Sign];
           }catch(e){
                alert('excetpion');
                if(window.console && console.log) console.log(e);
                return '';
            }
        }
        function getColor(cl){
            var colorCfg = _colorConfig,colorName;
            cl = cl.toUpperCase();
            for(i=0,j=colorCfg.length;i<j;i++){
                if(colorCfg[i]){
                    colorName = colorCfg[i]['colorName'];
                    if(colorName && colorName.toUpperCase().indexOf(cl) >= 0){
                        return colorCfg[i]['color'];
                    }
                }
           }
           return null;
        }
        function getRateColor(rateNum){
            var colorCfg = _colorConfig,hasMax,hasMin,ltMax,gtMin,color='';
            for(i=0,j=colorCfg.length;i<j;i++){
                if(colorCfg[i]){
                    hasMax = hasMin = ltMax = gtMin = false;
                    
                    if(colorCfg[i]['maxValue']){
                        
                        hasMax = true;
                        if(rateNum < colorCfg[i]['maxValue']) ltMax = true;
                    }
                    
                    if(colorCfg[i]['minValue']){
                        
                        hasMin = true;
                        if(rateNum >= colorCfg[i]['minValue']) gtMin = true;
                    }
                    if(hasMax && hasMin){
                        if(ltMax && gtMin){color = colorCfg[i]['color'];break;}
                    }else if(hasMax){
                        if(ltMax){color = colorCfg[i]['color'];break;}
                    }else if(hasMin){
                        if(gtMin) {color = colorCfg[i]['color'];break;}
                    }
                }
           }
           return color;
        }
        function getUnitStr(acc){
           //set up data array
           var cM = _CMIdx;
           var tmp = [],i,j,k,num;
           var arry = acc.ary;
           var imgSrc;
           var imgSrcRed = GcommentSrcRed;
           var imgSrcGreen = GcommentSrcGreen;
           var ttl = GcmtHint;
           var allowEdit = isSaveable;
           var clsName;
           var totalCols = _totalCols;
           var cmtIndicator;
           allowEdit = allowEdit.toLowerCase();
           allowEdit = allowEdit == 'true'?true:false;
           //if(allowEdit && isTrrChanged) allowEdit = false;
           var colorCfg = _colorConfig;//,redCfg,greenredMax,greenMin;
           
           
           tmp.push('<tr class="acc_start" id="',acc.id,'">');

               for(i=0;i<totalCols;i++){
                   num = arry[0][i];
                   if(isNaN(num)) num = 0;
                   num = nK(num,0);
                   cmtIndicator = arry[32][i];
                   if(i <= cM){
                        if(i%4 != 3)
                           tmp.push('<td>',num,'</td>');
                           else
                           tmp.push('<td class="ct">',num,'</td>');
                   }else{
                       if(i%4 != 3){ 
                            //they are rounded to thousand, so will display 0 in case less than 500
                            //therefore judge by 500, not 0
                            if(isCurrencyMonth(i,cM)){
                                if(Math.abs(arry[1][i]) >= 500 && !isNaN(arry[1][i])){
                                    var diffRate = (arry[0][i] - arry[1][i])/arry[1][i];
                                    clsName = getRateColor(diffRate);
                                }else{
                                    if(Math.abs(arry[0][i]) < 500){
                                        clsName = '#fff';
                                    }else{
                                        //calculated is displayed as 0, but input is not 0, 
                                        //in this case if input > 0 show green
                                        if(arry[0][i] > 0)
                                        clsName = getColor('Green');
                                        else
                                        clsName = getColor('Red');
                                    }
                                }
                            }else{//AM Colour Highlighting only for CM - CM+1
                                clsName = '#fff';
                            }

                           if(allowEdit){
                                //Added by bin yuan
                                tmp.push('<td title="',ttl,'" class="',clsName,'" style="background-color:',clsName,'">',
                                '<div class="cmtImg">',
                                '<div class="cmiIcon ',(cmtIndicator?'hasCmts':'hasNoCmt'),'" onclick="cmt(this);">≡</div>',
                                '</div>',
                                '<input class="',clsName,'" type="text" value="',num,'" onchange="cpt(this);" ondblclick="cmt(this);"/></td>');
                           }else{
                                tmp.push('<td title="',ttl,'" class="',clsName,'" style="background-color:',clsName,'">',
                                '<div class="cmtImg">',
                                '<div class="cmiIcon ',(cmtIndicator?'hasCmts':'hasNoCmt'),'" onclick="cmt(this);">≡</div>',
                                '</div><input class="',clsName,'" type="text" value="',num,'"  readonly="readonly" onchange="cpt(this);" ondblclick="cmt(this);"/></td>');
                           }
                       }else
                       tmp.push('<td class="ct">',num,'</td>');
                   }
               }
           

           tmp.push('</tr>');
           var getC = function (r,c){
               var w = cM;
               if(c < w){
                   if(r == 9 || r<3) return true;
               }else if(c==w){
                   if(r > 9 && r < 13) return true;
               }else{
                   if(r > 9 && r < 13 ||r==5) return true;
                   else if(r == 9){
                        if(!isCurrencyMonth(c,w)) return true;
                   }else if(r == 2 && c-w > 6) return true;
               }
               return false;
           };
           var rcls,dcls;
           for(j=1;j<13;j++){
               //if(j%2==0) rcls = 'evn';
               //else rcls = 'odd';
               if(j<3) rcls = ' se1',dcls = 'rt1';
               else if(j==3) rcls = ' se2',dcls = 'rt2';
               else if(j< 10) rcls = ' se3',dcls = 'rt3';
               else if(j==10){
                    dcls = 'rt4';
                    rcls += ' zc M2Acc hide';
                    tmp.push('<tr class="AccyRow"><td></td><td></td><td></td><td class="ct pltd"><span class="plh">I</span></td>');
                    for(k=4;k < totalCols;k++){
                        
                        if(k%4 != 3)
                        tmp.push('<td></td>');
                        else
                        tmp.push('<td class="ct"></td>');
                    }
                    tmp.push('</tr>');
                }else{
                    dcls = 'rt4';
                    rcls += ' zc hide';
                }
               tmp.push('<tr class="',rcls,'">');
               if(j<10){
                    for(i=0;i<totalCols;i++){
                        if(i%4 != 3){
                           num = arry[j][i];
                           if(getC(j,i) && !(num > 0)){
                                //added by bin yuan
                                //tmp.push('<td class="ck"></td>');
                                tmp.push('<td></td>');
                                //End
                           }else{
                                if(j!= 5){
                                    num = nK(num,0);
                               }else{
                                    num = (!arry[31][i]?0:num/arry[31][i]);
                                    num = nS(num,2);
                               }
                               tmp.push('<td>',num,'</td>');
                           }
                       }else{
                            num = arry[j][i];
                            if(j!= 5)
                            num = nK(num,0);
                           else{
                            num = (!arry[31][i]?0:num/arry[31][i]);
                            num = nS(num,2);
                           }
                           tmp.push('<td class="ct">',num,'</td>');
                       }
                   }
               }else{
                   for(i=0;i<totalCols;i++){
                        
                       if(i%4 != 3){
                           num = arry[j][i];
                           if(getC(j,i) && !(num > 0)){
                               //added by bin yuan
                               //tmp.push('<td class="ck"></td>');
                               tmp.push('<td></td>');
                               //End
                           }else{
                               if(arry[33][i] !=0)
                               num = num/arry[33][i];
                               else
                               num = 0;
                               num = Math.round(num*100) + '%';
                               tmp.push('<td>',num,'</td>');
                           }
                       }else{
                           num = arry[j][i];
                           num = Math.round(num*100) + '%';
                           tmp.push('<td class="ct">',num,'</td>');
                       }
                   }
               }
               tmp.push('</tr>');
           }
            tmp = tmp.join('');
            return tmp;
            
        }
        
        /** Data exchange **/
        function getItems(accIds){
            var batchSize = 5,count = 0,sendStr = [];
            for(var i=0,j=accIds.length;i<j;i++){
                if(accIds[i] != false && count < batchSize){
                    count ++;
                    sendStr.push(accIds[i]);
                    accIds[i] = false;
                }else if(count >= batchSize)
                break;
            }
            sendStr = sendStr.join(';');
            getItemsData(sendStr);
        }
        function cmt2(el){
            el = $(el).prev().get(0);
            cmt(el);
        }
        function cmt(el){
            //*****************//check whether user is allowed to edit
            var allowEdit = isSaveable;
            allowEdit = allowEdit.toLowerCase();
            allowEdit = allowEdit == 'true'?true:false;
            //if(!allowEdit)return false;
            if(!allowEdit){
                $('#save_cmt_button').hide();
            }else{
                $('#save_cmt_button').show();
            }
            //if(isTrrChanged) return false;
            //*****************//
            g_elem4cmt = el;
            
            //whether it indicates "hasComments'
            if(el.className && el.className.indexOf('hasCmts') >= 0) {
	            _hasCommentIndicator = true;
            }else {
	            _hasCommentIndicator = false;
            }

            var accId,year,month;
            if(el.nodeName=='INPUT'){
                el = getP(el,'TD');
                month = $(el).prevAll('td').length;
                el = getP(el,'TR');
                accId = $(el).attr('id');
            }else if(el.nodeName=='DIV'){
                el = getP(el,'TD');
                month = $(el).prevAll('td').filter('td').length;
                el = getP(el,'TR');
                accId = $(el).attr('id');
            }
            _parentAcId = accId;
            
            //set values
            var label = $('#bthd').children().eq(month).text(),midx=month-_CMIdx;
            _Midx = midx;
            year = _mapM2Y[month],month = _mapM2M[month];
            $('#popTitle').text(label);
            $('#cmtY').children('input').val(year);
            $('#cmtM').children('input').val(month);
            $('#pAcId').children('input').val(accId);
            $('#popTb').empty();
            $('#popCmt').removeClass('hide');
            $('#popCtn').removeClass('hide');
            $('#loadCtDiv').removeClass('hide');
            
            var data = _accData,found = false,i,cmtInfo;
            for(i=data.length-1;i>=0;i--){
                if(data[i].id == accId){
                    cmtInfo = data[i]['cmt'][midx];
                    break;
                }
            }
            if(cmtInfo){
                $('#loadCtDiv').removeClass('hide');
                _Comments = cmtInfo;
                makeUpCmt(allowEdit);
            }else{
                getCmt();
            }

        }
        function clsPop(){
            saveCmt();
        }
        function addC(){
            var allowEdit = isSaveable;
            allowEdit = allowEdit.toLowerCase();
            allowEdit = allowEdit == 'true'?true:false;
            
            if(!allowEdit) return false;
            var accPl = getAcPl(_parentAcId,'',1); 
            var prPl = getAcPl('','',2); 
            var rowId = 'Fc'+(new Date()).getTime();
            var d = _Comments;
            d.push({
                'id':rowId,
                'fcId':'',
                'acctId': '',
                'profitCenter':'',
                'value':'',
                'comment':''});
            $('#popTb').append(setUpC(rowId,'<select class="" value="" onchange="mc(this,1);">'+accPl,'<select class="" value="" onchange="mc(this,2);">'+prPl,'',''));
            //isDataEdited = true;
        }
        function setUpC(fd,s1,s2,fc,cmt){
            var allowEdit = isSaveable;
            allowEdit = allowEdit.toLowerCase();
            allowEdit = allowEdit == 'true'?true:false;
            if(isNaN(fc) && fc!= 0) fc = ''
            else fc = nK(fc,0);
            if(cmt === null ||typeof cmt == 'undefined') cmt = '';
            return '<tr><td class="pa"><image src="'+GminusSrc+'" onclick="removeC(this);" class="'+
                            fd+'"/></td><td class="pb">'+
                            s1+'</td><td class="pc">'+
                            s2+
                            '</td><td class="pd"><input type="text" value="'+ fc +
                            '" class="numInput" onchange="mc(this,3);"'+ (allowEdit?'':'readonly="readonly"')+'/></td>'+
                            '<td class="pe"><input type="textarea" class="txtInput" value="'+ cmt +'" onchange="mc(this,4);"'+ (allowEdit?'':'readonly="readonly"')+'/></td></tr>';
        }
        function removeC(el){
            var allowEdit = isSaveable;
            allowEdit = allowEdit.toLowerCase();
            allowEdit = allowEdit == 'true'?true:false;
            
            if(!allowEdit) return false;
            //delete from _Comments
            var i,j,d = _Comments,
                rowId = el.className;
            for(i=0,j=d.length;i<j;i++){
                if(d[i]['id'] == rowId){
                    d[i]['value'] = 'deleted';
                    break;
                }
            }
            $(getP(el,'TR')).remove();
            //isDataEdited = true;
        }
        function getAcPl(id,va,tp){
            var accPl = ['<option value="">--None--</option>'],
            i,j,tmp,accs;
            if(tp == 1){
                accs = _mapAcAc[id];
                for(i=0,j=accs.length;i<j;i++){ 
                    tmp = accs[i];
                    if(va == tmp['selectKey'])
                    accPl.push('<option value="',tmp['selectKey'],'" selected="selected">',tmp['selectValue'],'</option>');
                    else
                    accPl.push('<option value="',tmp['selectKey'],'">',tmp['selectValue'],'</option>');
                }
            }else{
                accs = _mapAcPf[id];
                if(accs)
                for(i=0,j=accs.length;i<j;i++){ 
                    tmp = accs[i];
                    if(va == tmp)
                    accPl.push('<option value="',tmp,'" selected="selected">',tmp,'</option>');
                    else
                    accPl.push('<option value="',tmp,'">',tmp,'</option>');
                }
            }
            
            accPl.push('</select>');
            accPl = accPl.join('');
            
            return accPl;
        }
        
        function udpCmt(){
            var el = $(document.getElementById(GcmtPanel));
            var d = $.parseJSON(el.text());
            //el.text('');
            el = null;
            var allowEdit = isSaveable;
            allowEdit = allowEdit.toLowerCase();
            allowEdit = allowEdit == 'true'?true:false;
            
            var pAcId = _parentAcId,map_acpf = _mapAcPf,ac,tmp,i;
            if(!(pAcId in _mapAcAc)){  //they are global
                _mapAcAc[pAcId] = d['list_childAcctOption'];
                tmp = d['map_acctId_set_profitCtrs'];
                for(ac in tmp){
                    if(!(ac in map_acpf)){
                        map_acpf[ac] = tmp[ac];
                    }
                }
            }
            _Comments = d['list_commentItem'];
            d = null;

            makeUpCmt(allowEdit);
        }
        function makeUpCmt(allowEdit){
        	
            var i,j,tmp = _Comments,itm,str = '',pAcId = _parentAcId,selectDisable='',
            	hasCommentIndicator = _hasCommentIndicator;
            //it indicates "has comments" but actually no comments, need mark "delete" for the comment	
            if(hasCommentIndicator && tmp.length == 0) {
            	
	            tmp.push({
	            	acctId: pAcId,
					comment: "",
					fcId: "",
					id: "",
					profitCenter: "null",
					value: "deleted"});
            }
            
            if(!allowEdit) selectDisable = ' disabled="disabled"';
            for(i=0,j=tmp.length;i<j;i++){
                itm = tmp[i];
                if(itm['value'] != 'deleted'){
                    if(!itm['id'])
                    itm['id'] = 'Fz_'+i;
                    //str += setUpC('Fz_'+i,'<select value="'+itm['acctId']
                    str += setUpC(itm['id'],'<select value="'+itm['acctId']
                        +'" onchange="mc(this,1);"'+selectDisable
                        +'>'+getAcPl(pAcId,itm['acctId'],1),
                        '<select value="'
                        +itm['profitCenter']+'" onchange="mc(this,2);"'+selectDisable+'>'+getAcPl(itm['acctId'],itm['profitCenter'],2),
                        itm['value'],itm['comment']);
                }
            }
            $('#popTb').append(str);
            hideLoad();
            str = tmp = itm = null;
        }
        function mc(el,pos){
            var elVal;
            if(pos == 3){
                elVal = $(el).val();
                if(!checkNum(elVal)){
                    alert(GMsgInvalidNum);
                    $(el).val('');
                    return false;
                }   
            }else if(pos == 1){
                elVal = $(el).val();
                var prf = $(getP(el,'TD')).next().find('select'),
                    prfval = prf.val(),
                    prfs = _mapAcPf[elVal],
                    inOption = false;
                if(prfs)
                for(var i=prfs.length -1;i>=0;i--){
                    if(prfval == prfs[i]){
                        inOption = true;
                    }
                }
                if(!inOption) prfval = '';
                
                prf.after('<select value="'+elVal+'" onchange="mc(this,2);">'+getAcPl(elVal,prfval,2)+'</select>').remove();
            }
            var $tds = $(getP(el,'TR')).children(),
                $sel1 = $tds.eq(1).children('select'),
                $sel2 = $tds.eq(2).children('select'),
                accId = $sel1.val(),
                prf = $sel2.val(),
                map_af;
            if(accId && prf){
                changeCmt($tds.eq(0).children('img').attr('class'),accId,prf,$tds.eq(3).children('input').val(),$tds.eq(4).children('input').val(),$tds);
            }
            //isDataEdited = true;
        }
        function changeCmt(rowId,aid,prf,val,cmt,$tds){
            var i,j,d = _Comments,flag = false,_val;
            
            if(val != '')
            _val = sToN(val);
            else
            _val = 0;
            for(i=0,j=d.length;i<j;i++){
                if(d[i]['id'] == rowId){
                    if(rowId.indexOf('Fc') >=0){//new rows
                        d[i]['acctId'] = aid,
                        d[i]['profitCenter'] = prf,
                        d[i]['value'] = _val,
                        d[i]['comment'] = cmt;
                        flag = true;
                    }else if(d[i]['acctId'] == aid && d[i]['profitCenter'] == prf){//only change value and comment
                        d[i]['value'] = _val,
                        d[i]['comment'] = cmt;
                        flag = true;
                    }else{//change accid/profit center on original lines, in this case, original accid need delete in apex code,so mark "deleted"
                        d[i]['value'] = 'deleted';
                        flag = false;
                    }
                    break;
                }
            }
            if(!flag){
                if(i == j)
                    d.push({
                    'id':rowId,
                    'fcId':'',
                    'acctId': aid,
                    'profitCenter':prf,
                    'value':_val,
                    'comment':cmt});
                else{
                    rowId = 'Fc'+(new Date()).getTime();
                    d.splice(i,0,{
                    'id':rowId,
                    'fcId':'',
                    'acctId': aid,
                    'profitCenter':prf,
                    'value':_val,
                    'comment':cmt});
                    $tds.eq(0).children('img').attr('class',rowId);
                }
            }
            $tds.eq(3).children('input').val(val==''?'':nK(_val,0));
        }
        function lg(txt){
            if(window.console) console.log(txt);
        }
        function saveCmt(){
            
            var hasEmpty = false,cmtCount = 0;
            $('#popTb').children().each(function(){
                var tds = $(this).children();
                var aid = tds.eq(1).find('select').val();
                var pid = tds.eq(2).find('select').val();
                if(!aid || !pid){
                    hasEmpty = true;
                    return false;
                }
                cmtCount ++;
            });
            if(hasEmpty){
                alert(msg_AccPrcEmpty);
                return false;
            }
            
            if(cmtCount >0) $(g_elem4cmt).removeClass('hasNoCmt').addClass('hasCmts');
            else $(g_elem4cmt).removeClass('hasCmts').addClass('hasNoCmt');

            //add d into _accData
            var i,j,cmts = _Comments,cItem,hasEmpty = false;
            if(cmts && cmts.length > 0){
                //lg(_Comments);
                var data = _accData,midx = _Midx;//
                for(i=0,j=data.length;i<j;i++){
                    if(data[i]['id'] == _parentAcId){
                        data[i]['cmt'][midx] = _Comments;
                        break;
                    }
                }
                _Comments = null;
            }
            
            $('#popCmt').addClass('hide');
            $('#popCtn').addClass('hide');
            $('#popTb').empty();
            /*
            $('#saveCmtInfo').children('input').eq(0).val(result);
            */
            //lg('end');
        }
        function hideLoad(){
            $('#loadCtDiv').addClass('hide');
        }
        function resetSentMap(){
            var sentMap = {};
            var mapM = _mapM2M;
            var cmIdx = _CMIdx;
            _sentMap = sentMap;
            for(var k in mapM){
                if(parseInt(k) >= cmIdx)
                sentMap[k] = 'unsent';
            }
        }
        //save with JSON
        function saveFC(){
            showLoading();
            var i,j,k,data = _accData,result=[],accid,cmIdx = _CMIdx,arry,mapY=_mapM2Y,mapM = _mapM2M,cmts,batchSize = _monthBatchSize,
            counter = batchSize,sentMap = _sentMap,sentMonth = [],totalCols=_totalCols;
            for(j=cmIdx;j<totalCols && counter < 1000;j++){
                if(j in mapM && sentMap[j] == 'unsent'){
                    sentMonth.push(j);
                    sentMap[j] = 'sent';
                    counter += batchSize;
                }
            }
            for(i = data.length - 1;i>=0;i--){
                arry = data[i];
                accid = arry.id;
                cmts = arry.cmt;
                arry = arry.ary;
                
                //for(j=cmIdx;j<20;j++){
				//Modified by:Buwen Guo 20170628 to skip the current month data
                for(k=1;k<sentMonth.length;k++){
                    //if(j in mapM && sentMap[j] == 'unsent'){
                        j = sentMonth[k];
                        result.push({
                        parentAcctId:accid,
                        year: mapY[j],
                        month:mapM[j],
                        totalForecast:arry[j],
                        commentList: asistFcCmt(cmts[j-cmIdx]) //'commentList':[{acctId:xxx,profitCtr:xxx,comments:['<commnets>....],....]
                        });
                    //}
                }
            }
            result = JSON.stringify(result);
            $('#saveInfo').children('input').val(result);
            saveAction();
            //checkRefTrr();
        }
        function asistFcCmt(d){ 
            if(!d) return null;
            var i,j,k,g,itm,key,map_C = {},result,cmts,str,vf;
            for(i=0,j=d.length;i<j;i++){
                itm = d[i];
                key = itm['acctId'];
                if(itm['profitCenter']) key+=itm['profitCenter'];
                if(key in map_C){
                    map_C[key].push({cmt:itm['comment'],fc:itm['value']});
                    itm['mark'] = -1;
                }else{
                    map_C[key] = [{cmt:itm['comment'],fc:itm['value']}];
                    itm['mark'] = 1;
                }
            }
            result = [];
            
            for(i=0;i<j;i++){
                itm = d[i];
                if(itm['mark'] == 1){
                    if(itm['acctId'] && itm['profitCenter']){
                        key = itm['acctId'];
                        //if(itm['profitCenter']) 
                        key+=itm['profitCenter'];
                        cmts = map_C[key];
                        str = '';
                        for(k=0,g=cmts.length;k<g;k++){
                            vf = cmts[k]['fc'];
                            if(vf != 'deleted')
                            str = str + '<comment value="' + vf + '">' + cmts[k]['cmt'] +'</comment>';
                        }
                        if(str != '')
                        str = '<comments>' + str + '</comments>';
                        result.push({acctId:itm['acctId'],profitCenter:itm['profitCenter'],comment:str});
                    }
                }
            }
            return result;
        }
        
        function hideLoading(){
            $('#pageLoading').addClass('hide');
        }
        function showLoading(){
            $('#pageLoading').removeClass('hide');
        }
        
        function cancelPage(){
            location.href = '/001/o';
        }
        function getActualDataTableWidth(){
            var actualWidth = $('#bthd').children().not('.hide').length;
            return 80*actualWidth+13;
        }
        function getDataAreaWidth(){
            $('#tableDiv').addClass('hide');
            var w = $(window).width()-30;
            $('#tableDiv').removeClass('hide');
            var unitX = 80;//$('#line_Total').children().eq(0).width();
            var leftWidth = 217,leftOuterWidth = 217;
            var allowedWidth;
            
            if(window.ActiveXObject){
                allowedWidth = w - leftOuterWidth-20;//-238;
            }else{
                allowedWidth = w - leftOuterWidth;
            }
            allowedWidth = Math.floor(allowedWidth/unitX)*unitX+13;
            var actualWidth = getActualDataTableWidth();

            if(allowedWidth > actualWidth) allowedWidth = actualWidth;
            return allowedWidth;
        }

        function setSize(){

            ////
            $('#tableDiv').addClass('hide');
            var w = $(window),
                h = w.height(),
                w = w.width()-30,
                addW = 0,
                addH = 0;
            $('#tableDiv').removeClass('hide');
            var unitX = $('#line_Total').children().eq(0),
                unitY = unitX.height(),
                unitX = 80;
            var leftWidth = 217,leftOuterWidth = 217;
            var isIE = !!window.ActiveXObject;
            if(isIE){
                addW = w - leftOuterWidth-20;//-238;
            }else{
                addW = w - leftOuterWidth;
            }
            
            addW = Math.floor(addW/unitX)*unitX+13;
            var isWenough = false;
            if(addW  < 8*unitX) addW = 8*unitX+13;
            if(addW >= 50*unitX){
                addW = 50*unitX+13;
                isWenough = true;//means very large scrren, horizontal scroll bar will not appear
            }
            var actualWidth = $('#headerCtn').children('table').width();
            var resultWidth;
            if(addW > actualWidth){resultWidth = actualWidth;}
            else {resultWidth = addW;}

            var t_height = $('#mainTbody').height();
            addH = h - 320;
            if(isIE){
                addH = h - 340;
            }
            addH = Math.round(addH/25) * 25;
            if(addH < 125) addH = 125;
            if(addH > t_height+5) addH = t_height+5;
    //        $('#btnBlock').width(leftWidth+addW+11);//(202+addW);
            
            $('#tableDiv').width(leftWidth+addW+11);//(202+addW);
            
            $('#hDiv').width(resultWidth);
            
            $('#vDiv').height(addH);
            $('#signDiv').height(addH);
            
            
            var scrollH = $.getScrollbarWidth();
            //if(isIE && scrollH > 2) scrollH += 1;
            if(scrollH){
                //if there are horizontal scroll bar
                if(actualWidth > addW){
                    addH += scrollH;
                }
                //if there are vertical scroll bar
                if(t_height > addH){
                    $('#signDiv').width(10+scrollH);
                    $('#tableDiv').width(leftWidth+addW+15+scrollH);
                }
            }
            $('#fcDiv').width(resultWidth).height(addH);
        }
        
        function eca(el){
            var $el = $(el);
            var dirc = 0;
            var expLabel = GexpLabel,
                clpLabel = GclpLabel;
            if($el.hasClass('iconPlus')){
                dirc = 1;
                $(el).attr('class','iconDeduct').next().text(clpLabel);
            }else{
                $(el).attr('class','iconPlus').next().text(expLabel);
            }
            var clsName,regL = /^\s+/,regR = /\s+$/;
            var mapShow = {};
            if(dirc == 1){
                var showAccuracy;
                $('#lTbody').children().each(function(idx){
                    clsName = this.className;
                    if(this.className != 'acc_start'){
                        if(clsName.indexOf('AccyRow')>=0){
                            if($(this).find('span').eq(0).hasClass('iconPlus'))
                            showAccuracy = false;
                            else showAccuracy = true;
                            this.className = clsName.replace('hide','').replace(regL,'').replace(regR,'');
                        }else if(clsName.indexOf('zc')>=0){
                            if(showAccuracy){
                                this.className = clsName.replace('hide','').replace(regL,'').replace(regR,'');
                                mapShow[idx] = 1;
                            }else{
                                mapShow[idx] = 0;
                            }
                        }else 
                        this.className = clsName.replace('hide','').replace(regL,'').replace(regR,'');
                        
                    }else{
                        $(this).addClass('active')
                        .find('span').eq(-1).attr('class','clpsIcn');
                    }
                });
                $('#mainTbody').children().each(function(idx){
                    clsName = this.className;
                    if(clsName != 'acc_start'){
                        if(clsName.indexOf('zc')>=0){
                            if(mapShow[idx] == 1)
                            this.className = clsName.replace('hide','').replace(regL,'').replace(regR,'');
                        }else
                        this.className = clsName.replace('hide','').replace(regL,'').replace(regR,'');
                    }
                });
                $('#signTbody').children().each(function(idx){
                    clsName = this.className;
                    if(clsName != 'acc_start'){
                        if(clsName.indexOf('zc')>=0){
                            if(mapShow[idx] == 1)
                            this.className = clsName.replace('hide','').replace(regL,'').replace(regR,'');
                        }else
                        this.className = clsName.replace('hide','').replace(regL,'').replace(regR,'');
                    }
                });
            }else{
                $('#mainTbody').children().each(function(){
                    clsName = this.className;
                    if(clsName != 'acc_start'){
                        if(clsName.indexOf('hide') < 0) this.className = clsName + ' hide';
                    }
                });
                $('#lTbody').children().each(function(){
                    clsName = this.className;
                    if(clsName.indexOf('acc_start') < 0){
                        if(clsName.indexOf('hide') < 0) this.className = clsName + ' hide';
                    }else{
                        $(this).removeClass('active').find('span').eq(-1).attr('class','expIcn');
                    }
                });
                $('#signTbody').children().each(function(){
                    clsName = this.className;
                    if(clsName != 'acc_start'){
                        if(clsName.indexOf('hide') < 0) this.className = clsName + ' hide';
                    }
                });
            }
            //checkHeight();
        }
        //save without JSON -- end
        function initTerr(){
        
            var pickedSel = $('#pickedTerr').text(),
                options = $.parseJSON($('#terris').text()),
                j =options.length,
                str = j==1?[]:['<option value="">--All--</option>'],
                i,k;
            
            for(i=0;i<j;i++){
                k = options[i];
                if(pickedSel == k)
                str.push('<option value="',options[i],'" selected="selected">',options[i],'</option>');
                else
                str.push('<option value="',options[i],'">',options[i],'</option>');
            }
            str = str.join('');
            $('#terrCtn').html(str);
        }
        function _checkRefTrr(){//to delete
            if(needRefreshTer){
                needRefreshTer = false;
                doTerr();
            }else
            hideLoading();
        }
        function checkRefTrr(){
             var sentMap = _sentMap, allSent = true;
             var c = window.cc;
             if(!c) c = 1;
             c++
             window.cc = c;
            for(var k in sentMap){
                if(sentMap[k] == 'unsent'){
                    allSent = false;
                    break;
                }
            }
            if(allSent||window.cc >100){
                //hideLoading();
                location.reload();
            }else
            saveFC();
        }
        function _changeTerr(elemVal){//to delete
            $('#territoryVal').children('input').val(elemVal);
            if(elemVal){
                //isTrrChanged = true;
                //$('#btn_save').attr('disabled',true).addClass('disableBtn');
                var needSave = false;
                showLoading();
                doTerr();
                /*
                if(isDataEdited){
                    needSave = confirm(msg_NeedSaveData);
                }
                if(needSave){
                    needRefreshTer = true;
                    saveFC();
                }else{
                    showLoading();
                    doTerr();
                }
                */
            }else{
                //isTrrChanged = false;
                //$('#btn_save').removeAttr('disabled').removeClass('disableBtn');
                showLoading();
                doTerr();
            }
        }
        function changeTerr(elemVal){
            $('#territoryVal').children('input').val(elemVal);
            showLoading();
            doTerr();
        }
        
    function fixIcon4IE(){
        var ary = ['IconFixA','IconFixB'],$el;
        for(var i=0;i<2;i++){
            $el = $('#'+ary[i]);
            if($el.children().length > 0){
                $el.after($el.children());
            }
        }
    }
    function initAccBatchMap(){
        var str = $('#accPfcInfo').text();
        str = $.parseJSON(str);
        var result=0,acId,acc,aid,ac,pfc;
        for(acId in str){
            acc = str[acId];//parent account
            for(aid in acc){
                ac = acc[aid];//account
                for(pfc in ac){
                    result++;
                }
            }
        }
        _monthBatchSize = result;
    }
        function initJobsA(){
            _CY = $('#cYear').text();
            _CY = parseInt(_CY,10);
            _CM = $('#cMonth').text();
            _CM = parseInt(_CM,10);
            var num = $('#numFormat').text();
            num = /1(\D)?234(\D)56/.exec(num);
            if(typeof num[1] == 'undefined')
            _numSep = '';
            else
            _numSep = num[1];
            _numDec = num[2];
            initTerr();
            initAccBatchMap();
        }

        function initJobsB(){
            //isDataEdited = false;
            _mapAcAc = {};
            updateData();
            setSize();
            fixIcon4IE();
            var $fcDiv = $('#fcDiv'),
                $signDiv = $('#signDiv'),
                $hDiv = $('#hDiv'),
                $vDiv = $('#vDiv');
            $fcDiv.scroll(function(){
                var $this = $(this);
                $hDiv.scrollLeft($this.scrollLeft());
            });
            $signDiv.scroll(function(){
                var scrolTop = $(this).scrollTop();
                $fcDiv.scrollTop(scrolTop);
                $vDiv.scrollTop(scrolTop);
            });
            var isIE = !!window.ActiveXObject;
            var isFF = (navigator.userAgent.toLowerCase().indexOf('firefox')>=0);

            if(isFF){
                $fcDiv[0].addEventListener('DOMMouseScroll',function(evt){
                    var deltaY = evt.detail;
                    var scrolTop = $signDiv.scrollTop();
                    if(deltaY > 0){//scroll bar go up
                        scrolTop -=20;
                        if(scrolTop < 0) scrolTop = 0;
                    }else if(deltaY < 0){//scroll bar go down
                        scrolTop +=20;
                        //if(scrolTop < 0) scrolTop = 0;
                    }
                    if(scrolTop >= 0){
                        $fcDiv.scrollTop(scrolTop);
                        $vDiv.scrollTop(scrolTop);
                        $signDiv.scrollTop(scrolTop);
                    }
                },false);
                $vDiv[0].addEventListener('DOMMouseScroll',function(evt){
                    var deltaY = evt.detail;
                    var scrolTop = $signDiv.scrollTop();
                    if(deltaY > 0){//scroll bar go up
                        scrolTop -=20;
                        if(scrolTop < 0) scrolTop = 0;
                    }else if(deltaY < 0){//scroll bar go down
                        scrolTop +=20;
                        //if(scrolTop < 0) scrolTop = 0;
                    }
                    if(scrolTop >= 0){
                        $fcDiv.scrollTop(scrolTop);
                        $vDiv.scrollTop(scrolTop);
                        $signDiv.scrollTop(scrolTop);
                    }
                },false);
            }else{
                $fcDiv.off('mousewheel').on('mousewheel',function(e, deltaa, deltaX, deltaY){
                    
                    if(!isIE){
                        var delta = e.originalEvent;
                        var deltaX,deltaY;

                        if(delta){
                            deltaX = delta.deltaX||delta.wheelDeltaX;
                            deltaY = delta.deltaY||delta.wheelDeltaY;

                            var scrolTop = $signDiv.scrollTop();
                            var scrolLeft = $fcDiv.scrollLeft();
                            if(deltaY > 0){//scroll bar go up
                                scrolTop -=20;
                                if(scrolTop < 0) scrolTop = 0;
                            }else if(deltaY < 0){//scroll bar go down
                                scrolTop +=20;
                                //if(scrolTop < 0) scrolTop = 0;
                            }
                            if(deltaY == 0){
                                if(deltaX > 0){//scroll bar go up
                                    scrolLeft -=30;
                                    if(scrolLeft < 0) scrolLeft = 0;
                                }else{//scroll bar go down
                                    scrolLeft +=30;
                                }
                                if(scrolLeft >= 0){
                                    $fcDiv.scrollLeft(scrolLeft);
                                    $vDiv.scrollLeft(scrolLeft);
                                    $signDiv.scrollLeft(scrolLeft);
                                }
                            }
                            
                            //if(isSafari) scrolTop = -scrolTop;//safari move opposite way...
                            
                            if(scrolTop >= 0){
                                $fcDiv.scrollTop(scrolTop);
                                $vDiv.scrollTop(scrolTop);
                                $signDiv.scrollTop(scrolTop);
                            }
                            
                        }
                        return false;
                    }else{
                        //can only scroll up or down
                        var deltaY = event.wheelDelta;
                        if(deltaY != 0){
                            var scrolTop = $signDiv.scrollTop();
                            scrolTop += deltaY;
                            if(scrolTop < 0) scrolTop = 0;
                            if(scrolTop >= 0){
                                $fcDiv.scrollTop(scrolTop);
                                $vDiv.scrollTop(scrolTop);
                                $signDiv.scrollTop(scrolTop);
                            }
                        }
                    }
                });
                $vDiv.off('mousewheel').on('mousewheel',function(e, deltaa, deltaX, deltaY){
                    if(!isIE){
                        var delta = e.originalEvent;
                        var deltaX,deltaY;
                        if(delta){
                            deltaY = delta.deltaY||delta.wheelDeltaY;

                            var scrolTop = $signDiv.scrollTop();
                            if(deltaY >= 0){//scroll bar go up
                                scrolTop -=20;
                                if(scrolTop < 0) scrolTop = 0;
                            }else{//scroll bar go down
                                scrolTop +=20;
                                //if(scrolTop < 0) scrolTop = 0;
                            }
                            
                            if(scrolTop >= 0){
                                $fcDiv.scrollTop(scrolTop);
                                $vDiv.scrollTop(scrolTop);
                                $signDiv.scrollTop(scrolTop);
                            }
                        }
                        return false;
                    }else{
                        //can only scroll up or down
                        var deltaY = event.wheelDelta;
                        if(deltaY != 0){
                            var scrolTop = $signDiv.scrollTop();
                            scrolTop += deltaY;
                            if(scrolTop < 0) scrolTop = 0;
                            if(scrolTop >= 0){
                                $fcDiv.scrollTop(scrolTop);
                                $vDiv.scrollTop(scrolTop);
                                $signDiv.scrollTop(scrolTop);
                            }
                        }
                    }
                });
            }
            
            $('#mainTbody').children().each(function(idx){
                $(this).hover(function(){
                    $('#lTbody').children().eq(idx).addClass('hv');
                },function(){
                    $('#lTbody').children().eq(idx).removeClass('hv');
                });
            });
            
            $('#lTbody').children().each(function(idx){
                $(this).hover(function(){
                    $('#mainTbody').children().eq(idx).addClass('hv');
                },function(){
                    $('#mainTbody').children().eq(idx).removeClass('hv');
                });
            });
        }
        /** page onload **/
        $(function(){
            initJobsA();
            initJobsB();
            collapseColumns();//////
            collapseRows();//////
            $('#pageLoading').addClass('hide');
        });
        //added functions
        function collapseColumns(){
            var $ths = $('#bthd').children('.Total');
            var thsNum = $ths.length;
            thsNum -= 5;
            $ths.each(function(idx){
                if(idx < 2 || idx > thsNum){
                    collapseQt(this,true);
                }
            });
            resetHorizonWidth();
        }
        function collapseRows(){
            var el = document.getElementById('ArrowAll');
            $(el).attr('class','iconDeduct');
            eca(el);
        }
        function initColor(colorConfig){
            _colorConfig = $.parseJSON(colorConfig);
        }