/***
javascript functions for GSM page
by Fuqi Tan 2013 Nov 15 fuqi.tan@itbconsult.com 
***/
(function($j,bb,_,Mr,hi){
	//borrowed code about scrollbar width --begin
	var scrollbarWidth = 0;
    $j.getScrollbarWidth = function() {
        if ( !scrollbarWidth ) {
            if ( navigator.appVersion.indexOf("MSIE") != -1) {
                var $textarea1 = $j('<textarea cols="10" rows="2"></textarea>')
                .css({ position: 'absolute', top: -1000, left: -1000 }).appendTo('body'),
                    $textarea2 = $j('<textarea cols="10" rows="2" style="overflow: hidden;"></textarea>')
                    .css({ position: 'absolute', top: -1000, left: -1000 }).appendTo('body');
                scrollbarWidth = $textarea1.width() - $textarea2.width();
                $textarea1.add($textarea2).remove();
            } else {
                var $div = $j('<div />')
                .css({ width: 100, height: 100, overflow: 'auto', 
                position: 'absolute', top: -1000, left: -1000 })
                .prependTo('body').append('<div />').find('div').css({ width: '100%', height: 200 });
                scrollbarWidth = 100 - $div.width();
                $div.parent().remove();
            }
        }
        return scrollbarWidth;
    };
    //borrowed code about scrollbar width --end
	var setSize=function(){
        var w = $j(window),
            h = w.height(),
            w = w.width(),
            addW = 0,
            addH = 0;
        $j('#tableDiv').removeClass('hide');
        var unitX = $j('#bthd').children().eq(0),
            unitY = unitX.height(),
            unitX = unitX.width();
        addW = w - 305;
        addW = Math.floor(addW/unitX)*unitX;
        var isWenough = false;
        if(addW  < 8*unitX) addW = 8*unitX;
        if(addW >= 20*unitX){
            addW = 20*unitX;
            isWenough = true;
        }
        //var t_height = $j('#mainTable').height();
        addH = h - 320;
        addH = Math.round(addH/unitY) * unitY;
        if(addH < 125) addH = 125;
        //if(addH > t_height+5) addH = t_height+5;
        $j('#tableDiv').width(295+addW);
        $j('#hDiv').width(addW);
        $j('#vDiv').height(addH);
        var scrollH = $j.getScrollbarWidth();
        var isWadded = false;
        if(scrollH){
            if(t_height > addH){
                addW += scrollH;
                isWadded = true;
            }
            if(isWadded)
            this._addW = addW;
            else
            this._addW = addW + scrollH;

            if(!isWenough)
            addH += scrollH;
            this._addH = addH;
        }
        $j('#fcDiv').width(addW).height(addH);
    };
    var initScroll=function(){
        $j('#fcDiv').scroll(function(){
            var $this = $j(this);
            $j('#hDiv').scrollLeft($this.scrollLeft());
            $j('#vDiv').scrollTop($this.scrollTop());
        });
    };
    
    var testDT = [[0,0,0,2,3,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
            [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
            [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]],
        testDR = [
            [0,0,0,0,0,0,3,0,0,0,0,0,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
            [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
            [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
            [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
            [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
            [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
            [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]
            ];
    //**** begin ***//
    //modify the method of Region to show view
    Mr.Region.prototype.open = function(view){
	  this.$el.empty().append(view.$el.children());
	}
    //define app
    var gsmApp = new Mr.Application();
	gsmApp.addRegions({
	        btnArea: '#selectArea',
	        
	        ALabel: '#Acc_TypeA',
	        AData: '#Data_TypeA',
	        AtotalLabel: '#Total_TypeA',
	        AtotalData: '#DataTotal_TypeA',
	        BLabel: '#Acc_TypeB',
	        BData: '#Data_TypeB',
	        BtotalLabel: '#Total_TypeB',
	        BtotalData: '#DataTotal_TypeB',
	        DirectLabel: '#Total_Direct',
	        Directdata: '#DataTotal_Direct',
	        ChannelLabel: '#Acc_Channel',
	        Channeldata: '#Data_Channel',
	        CtotalLabel: '#Total_Channel',
	        CtotalData: '#DataTotal_Channel',
	        TotalLabel: '#Total',
	        Totaldata: '#DataTotal'
	});
	/*
	gsmApp.on('initialize:after', function() {
	        Backbone.history.start();
	});
	*/
	//define module 'models'
	gsmApp.module('Models',function(md,app,bb,Mr,$j,_){
		md.cfgModel = bb.Model.extend({
			defaults:{
				selectedRegion:'all'
			}
		});
		md.RowItem = bb.Model.extend({defaults:{typeLabel:'',cls:''}});
		//the hierarchy just to form the final acc collection --begin
		md.Rows = bb.Collection.extend({model:md.RowItem});
		md.RegionItem = bb.Model.extend({
			defaults:{
				rows:null // a Rows instance
			}
		});
		md.Regions = bb.Collection.extend();
		md.TotalData = bb.Model.extend({
			defaults:{
				rows:null // a Rows instance
			}
		}); 
		md.AccItem = bb.Model.extend({
			defaults:{
				total:null, // a TotalData instance
				regions:null // a Regions instance
			}
			/*,
			initialize:function(options){
				switch(this.get('AccType'){//when model data changed, trigger subtotal/total re-calculate.
					case 'A':
					this.on('change:data',function(){this.trigger('ATotal');});
					break;
					case 'ATotal':
					this.on('change:data',function(){this.trigger('TotalDirect');});
					break;
					case 'B':
					this.on('change:data',function(){this.trigger('BTotal');});
					break;
					case 'BTotal':
					this.on('change:data',function(){this.trigger('TotalDirect');});
					break;
					case 'TotalDirect':
					this.on('change:data',function(){this.trigger('Total');});
					break;
					case 'Channel':
					this.on('change:data',function(){this.trigger('TotalChannel');});
					break;
					case 'TotalChannel':
					this.on('change:data',function(){this.trigger('Total');});
					break;
				}
			}
			*/
		});
		//the hierarchy just to form the final acc collection --end
		//a type of accounts
		md.Accounts = bb.Model.extend({
			accType:null,
			rows:null
		});
	});
	gsmApp.module('Views',function(md,app,bb,Mr,$j,_){
		md.BtnAreaView = Mr.ItemView.extend({
			template: '#btnAreaTpl'
			/*
			,
			ui:{
				select:'#selectRegion'
			},
			events:{
				'change #selectRegion':'onSelectRegion'
			},
			onSelectRegion:function(){
				var regionName = this.ui.select.val();
				if(!regionName) regionName = 'all';
				this.model.set('selectedRegion',regionName);
				gsmApp.Controller.controller.filterRegion(regionName);
			}
			*/
		});
		
		md.RowItemLabelView = Mr.ItemView.extend({
			tagName:'tr',
			template:'#template-ItemLabel',
			events: {
			    "click .clex":"onClick"
			},
			onClick:function(){this.trigger('clickEx',this.model.get('cls'));}
		});
		md.RowItemDataView = Mr.ItemView.extend({
			tagName:'tr',
			template:'#template-ItemData'
		});
		
		md.AccsLabelView = Mr.CollectionView.extend({//if compositeview,there will be an error
			itemView:md.RowItemLabelView,
			toggleIcon:function($span,flag){
				if(flag){
					$span.children().eq(0).removeClass('hide');
					$span.children().eq(1).addClass('hide');
				}else{
					$span.children().eq(0).addClass('hide');
					$span.children().eq(1).removeClass('hide');
				}
			},
			initialize:function(){
				var self = this;
				self.on('itemview:clickEx',function(itemview,cls){
					//flag == true means currently all items shown, and after click they will be hidden.
					var $span = itemview.$el.find('span.clex').eq(0);
					var flag = $span.children().eq(0).hasClass('hide');
					self.toggleIcon($span,flag);
					//expand or collapse the label area
					var vid = itemview.cid,started = false,isSet = false,startIndex,endIndex,counter = 0;
					self.children.each(function(view){
						if(isSet) return;
						if(started){
							var className = view.model.get('cls');
							console.log('clsName:'+className+' cls:'+cls);
							if(cls == className){
								endIndex = counter;
								started = false;
								isSet = true;return;
							}
							if(cls == 'r0' && className == 'a0'){
								endIndex = counter;
								started = false;
								isSet = true;return;
							}
							if(cls == 'a0' && className == 'r0'){
								self.toggleIcon(view.$el.find('span.clex').eq(0),flag);
							}
							if(flag)view.$el.hide();
							else view.$el.show();
						}else if(vid == view.cid){
							started = true;
							startIndex = counter;
						}
						counter ++;
					});
					if(!isSet) endIndex = counter;
					//expand or collapse the data area
					self.trigger('LabelEx',startIndex,endIndex,flag);
				});
			}
		});
		md.AccsDataView = Mr.CollectionView.extend({
			itemView:md.RowItemDataView
		});
	});
	gsmApp.module('Controller',function(md,app,bb,Mr,$j,_){
		md.controller = function(){
			this.cfgModel = new gsmApp.Models.cfgModel();//set its region name here!!
			this.AllAccTypes = [];
			var rows;
			var accountsTypeA = new gsmApp.Models.Accounts({accType:'A'});//set data here
			rows = new gsmApp.Models.Rows();
			//test data
			var i,a,j,k,g,accLabel,rgLabel,typeLabel,isTypeSet,clsName;
			var mapTotalLabel = gsmLabels.totalLabel;
			var mapRegionLabel = gsmLabels.regionLabel;
			var TestA = {
				type:'A',
				accounts:[
					{accName:'Acc1',
					total:_.clone(testDT),
					regions:[
						{regionName:'regionA',
						data:_.clone(testDR)},
						{regionName:'regionb',
						data:_.clone(testDR)},
						{regionName:'regionc',
						data:_.clone(testDR)}
						]
					},
					{accName:'Acc2',
					total:_.clone(testDT),
					regions:[
						{regionName:'regionA',
						data:_.clone(testDR)},
						{regionName:'regionA',
						data:_.clone(testDR)},
						{regionName:'regionA',
						data:_.clone(testDR)}
						]
					}
				]
			};
			isTypeSet = false;
			for(i in TestA.accounts){
				a = TestA.accounts[i];
				for(j in a.total){
					if(j > 0){
						clsName = 'a1';
						accLabel = mapTotalLabel[j-1];
						typeLabel = '';
					}else{
						clsName = 'a0';
						accLabel = a.accName;
						if(!isTypeSet){
							typeLabel = TestA.type;
							isTypeSet = true;
						}
					}
					rows.add(new gsmApp.Models.RowItem({cls:clsName,typeLabel:typeLabel,label:accLabel,data:a.total[j]}));
				}
				for(j in a.regions){
					g = a.regions[j];
					for(k in g.data){
						k = parseInt(k);
						if(k > 0){
							if(k==6||k==7) clsName = 'r2';
							else clsName = 'r1';
							rgLabel = mapRegionLabel[k-1];
						}else{
							clsName = 'r0';
							rgLabel = g.regionName;
						}
						rows.add(new gsmApp.Models.RowItem({cls:clsName,label:rgLabel,data:g.data[k]}));
					}
				}
			}
			//rows.add(...);
			// ... 
			accountsTypeA.set('rows',rows);
			this.AllAccTypes.push(accountsTypeA);
			
			rows = new gsmApp.Models.Rows();
			var accountsTypeB = new gsmApp.Models.Accounts({accType:'B'});//set data here
			var TestB = {
				type:'B',
				accounts:[
					{accName:'Acc1',
					total:_.clone(testDT),
					regions:[
						{regionName:'regionA',
						data:_.clone(testDR)},
						{regionName:'regionb',
						data:_.clone(testDR)},
						{regionName:'regionc',
						data:_.clone(testDR)}
						]
					},
					{accName:'Acc2',
					total:_.clone(testDT),
					regions:[
						{regionName:'regionA',
						data:_.clone(testDR)},
						{regionName:'regionA',
						data:_.clone(testDR)},
						{regionName:'regionA',
						data:_.clone(testDR)}
						]
					}
				]
			};
			isTypeSet = false;
			for(i in TestB.accounts){
				a = TestB.accounts[i];
				for(j in a.total){
					if(j > 0){
						clsName = 'a1';
						accLabel = mapTotalLabel[j-1];
						typeLabel = '';
					}else{
						clsName = 'a0';
						accLabel = a.accName;
						if(!isTypeSet){
							typeLabel = TestB.type;
							isTypeSet = true;
						}
					}
					rows.add(new gsmApp.Models.RowItem({cls:clsName,typeLabel:typeLabel,label:accLabel,data:a.total[j]}));
				}
				for(j in a.regions){
					g = a.regions[j];
					for(k in g.data){
						k = parseInt(k);
						if(k > 0){
							if(k==6||k==7)clsName = 'r2';
							else clsName = 'r1';
							rgLabel = mapRegionLabel[k-1];
							
						}else{
							clsName = 'r0';
							rgLabel = g.regionName;
						}
						rows.add(new gsmApp.Models.RowItem({cls:clsName,label:rgLabel,data:g.data[k]}));
					}
				}
			}
			//rows.add(...);
			// ... 
			accountsTypeB.set('rows',rows);
			this.AllAccTypes.push(accountsTypeB);
		};
		_.extend(md.controller.prototype,{
			start:function(){
				setSize();
				this.showBtn(this.cfgModel);
				this.showTable(this.accounts);
				//this.getData();
				initScroll();
			},
			showBtn:function(cfgModel){
				var btnView = new gsmApp.Views.BtnAreaView({
					tagName:'div',
					model:cfgModel
				});
				gsmApp.btnArea.show(btnView);
			},
			showTable:function(){
				var View = gsmApp.Views,
					AccLabelView = View.AccLabelView,
					AccDataView = View.AccDataView;
				_.each(this.AllAccTypes,function(accts){
					var labelView = new gsmApp.Views.AccsLabelView({collection:accts.get('rows')});
					var accType = accts.get('accType');
					gsmApp.getRegion(accType+'Label').show(labelView);
					var dataView = new gsmApp.Views.AccsDataView({collection:accts.get('rows')});//AccsDataView
					dataView.listenTo(labelView,'LabelEx',function(start,end,flag){
						console.log('start:'+start+' end:'+end+' flag:'+flag);
						var counter = 0;
						//flag == true, will collapse and hide the items
						if(!flag)
						this.children.each(function(view){
							if(counter > start && counter < end){
								view.$el.show();
							}
							counter ++;
						});
						else
						this.children.each(function(view){
							if(counter > start && counter < end){
								view.$el.hide();
							}
							counter ++;
						});
					});
					gsmApp.getRegion(accType+'Data').show(dataView);
				});
			},
			getData:function(){
				var str1 = 'select Category__c,GSM__c,GSM_Name__c,Profit_Center__c,Region__c,'+
						'RSM_Forecast_Category_Excludes__c,RSM_Forecast_Category_Includes__c from Forecast_Definition__c '+
						'where Region__c = ',
					str2 = ' and GSM__c = '+UserContext.userId + ' group by Category__c,Profit_Center__c';
				var sqls = ['Americas','EMEA','Japan','Korea','Greater China','Rest of APAC'];
				var sfc = sforce.connection;
				_.each(sqls,function(sql){
					sfc.queryAll(
						_query, 
						{onSuccess:function(result, source){console.log(result)},
						onFailure:function(error, source){console.log(error)},
						source:{}
						}
					);
				});
			},
			filterRegion:function(regionName){
				alert('filter with '+regionName);
				//
			},
			findRegionNameByAccType:function(accType){
		        return accType+'Label';
			}
		});
		md.addInitializer(function(){
			var controller = new md.controller();
			controller.start();
		});
	});
	
	$j(function(){gsmApp.start();});
}(jQuery,Backbone,_,Marionette));