public with sharing class UpdateAmountsInOverallMeasures {
	
	public static void CaluclateTotalRunrate(set<String> gamCode){
	set <Overall_Forecast__c> set_ovf= new set <Overall_Forecast__c>();
	list <Overall_Measures__c> lst_ovmMeasures= new list <Overall_Measures__c>();
	list <Overall_Measures__c> ovmTRR = new list <Overall_Measures__c>(); 
	list <Overall_Forecast__c> ovForecast = new list <Overall_Forecast__c>();
	map<Id , list<Overall_Measures__c>> map_LstOvm= new map<Id , list<Overall_Measures__c>>(); 
	map<String , Overall_Measures__c> map_type = new map<String , Overall_Measures__c>(); 
	
	ovForecast = [Select Id,Month_0__c,Month_1__c,Month_2__c,Month_3__c,Month_4__c,Month_5__c,Month_6__c,Month_7__c,Month_8__c,Month_9__c,Month_10__c,Month_11__c,Month_12__c , Month_13__c, Month_14__c, Month_15__c, Month_16__c, Month_17__c , Previous_Month_1__c, Previous_Month_2__c,Previous_Month_3__c,Previous_Month_4__c,Previous_Month_5__c, Previous_Month_6__c, GAM_Code__c , Sales_Hierarchy__c , Sum_of_Total_Demand__c, Name , CurrencyIsoCode from Overall_Forecast__c where  Gam_Code__c IN :gamCode  ];
	lst_ovmMeasures = [Select Id, Month_0__c,Month_1__c,Month_2__c,Month_3__c,Month_4__c,Month_5__c,Month_6__c,Month_7__c,Month_8__c,Month_9__c,Month_10__c,Month_11__c,Month_12__c , Month_13__c, Month_14__c, Month_15__c, Month_16__c, Month_17__c , Previous_Month_1__c, Previous_Month_2__c,Previous_Month_3__c,Previous_Month_4__c,Previous_Month_5__c, Previous_Month_6__c, GAM_Code__c , Sales_Hierarchy__c , Sum_of_Total_Months__c, Name , type__c, CurrencyIsoCode, Overall_Forecast__c,
	Overall_Forecast__r.Month_0__c, Overall_Forecast__r.Month_1__c,Overall_Forecast__r.Month_2__c, Overall_Forecast__r.Month_3__c, Overall_Forecast__r.Month_4__c , Overall_Forecast__r.Month_5__c , Overall_Forecast__r.Month_6__c , Overall_Forecast__r.Month_7__c , Overall_Forecast__r.Month_8__c , Overall_Forecast__r.Month_9__c , Overall_Forecast__r.Month_10__c , Overall_Forecast__r.Month_11__c ,Overall_Forecast__r.Month_12__c , Overall_Forecast__r.Month_13__c , Overall_Forecast__r.Month_14__c, Overall_Forecast__r.Month_15__c , Overall_Forecast__r.Month_16__c , Overall_Forecast__r.Month_17__c , Overall_Forecast__r.Previous_Month_1__c ,Overall_Forecast__r.Previous_Month_2__c, Overall_Forecast__r.Previous_Month_3__c, Overall_Forecast__r.Previous_Month_4__c, Overall_Forecast__r.Previous_Month_5__c, Overall_Forecast__r.Previous_Month_6__c , Overall_Forecast__r.Gam_Code__c, Overall_Forecast__r.Sales_Hierarchy__c  from Overall_Measures__c where Gam_Code__c IN : gamCode and (type__c = 'Total Opportunities' or type__c = 'Total Run Rate')];
	if (!lst_ovmMeasures.isEmpty()){
		for(Overall_Measures__c ovm : lst_ovmMeasures){
			string t = ovm.Overall_Forecast__c+ovm.type__c;
			map_type.put(t,ovm); 
			set_ovf.add(getOvForecast(ovm));
			if(map_LstOvm.containskey(ovm.Overall_Forecast__c)){
				list <Overall_Measures__c> tempLst=map_LstOvm.get(ovm.Overall_Forecast__c);
				tempLst.add(ovm);
				map_LstOvm.put(ovm.Overall_Forecast__c ,tempLst);
			}else if(!map_LstOvm.containskey(ovm.Overall_Forecast__c)){
				list <Overall_Measures__c> tempLst = new list<Overall_Measures__c>();
				tempLst.add(ovm);
				map_LstOvm.put(ovm.Overall_Forecast__c ,tempLst);
			}
		}
	for(Overall_Forecast__c ovf: set_ovf){
		string str1 = ovf.Id+'Total Opportunities';
		string str2 = ovf.Id+'Total Run Rate';	
		if(map_type.containsKey(str2)){
			if(map_LstOvm.containsKey(ovf.Id)){
				for(Overall_Measures__c ovm:map_LstOvm.get(ovf.Id) ){
					if (ovm.Type__c == 'Total Run Rate'){
						if(map_type.containskey(str1)){
							System.Debug('Step1');
							ovm.Sales_Hierarchy__c = ovf.Sales_Hierarchy__c;
							ovm.Month_0__c = ovf.Month_0__c - map_Type.get(str1).Month_0__c;
							ovm.Month_1__c = ovf.Month_1__c - map_Type.get(str1).Month_1__c;
							ovm.Month_2__c = ovf.Month_2__c - map_Type.get(str1).Month_2__c;
							ovm.Month_3__c = ovf.Month_3__c - map_Type.get(str1).Month_3__c;
							ovm.Month_4__c = ovf.Month_4__c - map_Type.get(str1).Month_4__c;
							ovm.Month_5__c = ovf.Month_5__c - map_Type.get(str1).Month_5__c;
							ovm.Month_6__c = ovf.Month_6__c - map_Type.get(str1).Month_6__c;
							ovm.Month_7__c = ovf.Month_7__c - map_Type.get(str1).Month_7__c;
							ovm.Month_8__c = ovf.Month_8__c - map_Type.get(str1).Month_8__c;
							ovm.Month_9__c = ovf.Month_9__c - map_Type.get(str1).Month_9__c;
							ovm.Month_10__c = ovf.Month_10__c - map_Type.get(str1).Month_10__c;
							ovm.Month_11__c = ovf.Month_11__c - map_Type.get(str1).Month_11__c;
							ovm.Month_12__c = ovf.Month_12__c - map_Type.get(str1).Month_12__c;
							ovm.Month_13__c = ovf.Month_13__c - map_Type.get(str1).Month_13__c;
							ovm.Month_14__c = ovf.Month_14__c - map_Type.get(str1).Month_14__c;
							ovm.Month_15__c = ovf.Month_15__c - map_Type.get(str1).Month_15__c;
							ovm.Month_16__c = ovf.Month_16__c - map_Type.get(str1).Month_16__c;
							ovm.Month_17__c = ovf.Month_17__c - map_Type.get(str1).Month_17__c;
							ovm.Previous_Month_1__c = ovf.Previous_Month_1__c - map_Type.get(str1).Previous_Month_1__c;
							ovm.Previous_Month_2__c = ovf.Previous_Month_2__c - map_Type.get(str1).Previous_Month_2__c;
							ovm.Previous_Month_3__c = ovf.Previous_Month_3__c - map_Type.get(str1).Previous_Month_3__c;
							ovm.Previous_Month_4__c = ovf.Previous_Month_4__c - map_Type.get(str1).Previous_Month_4__c;
							ovm.Previous_Month_5__c = ovf.Previous_Month_5__c - map_Type.get(str1).Previous_Month_5__c;
							ovm.Previous_Month_6__c = ovf.Previous_Month_6__c - map_Type.get(str1).Previous_Month_6__c;
							
						}
							else if (!map_type.containskey(str1)){
								System.Debug('Step2');
							ovm.CurrencyIsoCode = 'USD';
							ovm.Type__c= 'Total Run Rate';	
							ovm.Overall_Forecast__c = ovf.Id;
							ovm.Sales_Hierarchy__c = ovf.Sales_Hierarchy__c;
							ovm.Month_0__c = ovf.Month_0__c;
							ovm.Month_1__c = ovf.Month_1__c;
							ovm.Month_2__c = ovf.Month_2__c;
							ovm.Month_3__c = ovf.Month_3__c;
							ovm.Month_4__c = ovf.Month_4__c;
							ovm.Month_5__c = ovf.Month_5__c;
							ovm.Month_6__c = ovf.Month_6__c;
							ovm.Month_7__c = ovf.Month_7__c;
							ovm.Month_8__c = ovf.Month_8__c;
							ovm.Month_9__c = ovf.Month_9__c;
							ovm.Month_10__c = ovf.Month_10__c;
							ovm.Month_11__c = ovf.Month_11__c;
							ovm.Month_12__c = ovf.Month_12__c;
							ovm.Month_13__c = ovf.Month_13__c;
							ovm.Month_14__c = ovf.Month_14__c;
							ovm.Month_15__c = ovf.Month_15__c;
							ovm.Month_16__c = ovf.Month_16__c;
							ovm.Month_17__c = ovf.Month_17__c;
							ovm.Previous_Month_1__c = ovf.Previous_Month_1__c;
							ovm.Previous_Month_2__c = ovf.Previous_Month_2__c;
							ovm.Previous_Month_3__c = ovf.Previous_Month_3__c;
							ovm.Previous_Month_4__c = ovf.Previous_Month_4__c;
							ovm.Previous_Month_5__c = ovf.Previous_Month_5__c;
							ovm.Previous_Month_6__c = ovf.Previous_Month_6__c;
							}
							ovmTRR.add(ovm);
						}
					}
				}
			}
			else if(!map_type.containsKey(str2)){
				Overall_Measures__c ovm= new Overall_Measures__c();
				ovm.Type__c = 'Total Run Rate';
				ovm.Overall_Forecast__c = ovf.ID;
				ovm.CurrencyIsoCode = 'USD';
				ovm.Gam_Code__c = ovf.Gam_Code__c; 
				ovm.Sales_Hierarchy__c = ovf.Sales_Hierarchy__c;
				system.debug('@@@ovm.Sales_Hierarchy__c'+ovm.Sales_Hierarchy__c);
				if(map_type.containskey(str1)){
					System.Debug('Step3');
					ovm.Month_0__c = ovf.Month_0__c - map_Type.get(str1).Month_0__c;
					ovm.Month_1__c = ovf.Month_1__c - map_Type.get(str1).Month_1__c;
					ovm.Month_2__c = ovf.Month_2__c - map_Type.get(str1).Month_2__c;
					ovm.Month_3__c = ovf.Month_3__c - map_Type.get(str1).Month_3__c;
					ovm.Month_4__c = ovf.Month_4__c - map_Type.get(str1).Month_4__c;
					ovm.Month_5__c = ovf.Month_5__c - map_Type.get(str1).Month_5__c;
					ovm.Month_6__c = ovf.Month_6__c - map_Type.get(str1).Month_6__c;
					ovm.Month_7__c = ovf.Month_7__c - map_Type.get(str1).Month_7__c;
					ovm.Month_8__c = ovf.Month_8__c - map_Type.get(str1).Month_8__c;
					ovm.Month_9__c = ovf.Month_9__c - map_Type.get(str1).Month_9__c;
					ovm.Month_10__c = ovf.Month_10__c - map_Type.get(str1).Month_10__c;
					ovm.Month_11__c = ovf.Month_11__c - map_Type.get(str1).Month_11__c;
					ovm.Month_12__c = ovf.Month_12__c - map_Type.get(str1).Month_12__c;
					ovm.Month_13__c = ovf.Month_13__c - map_Type.get(str1).Month_13__c;
					ovm.Month_14__c = ovf.Month_14__c - map_Type.get(str1).Month_14__c;
					ovm.Month_15__c = ovf.Month_15__c - map_Type.get(str1).Month_15__c;
					ovm.Month_16__c = ovf.Month_16__c - map_Type.get(str1).Month_16__c;
					ovm.Month_17__c = ovf.Month_17__c - map_Type.get(str1).Month_17__c;
					ovm.Previous_Month_1__c = ovf.Previous_Month_1__c - map_Type.get(str1).Previous_Month_1__c;
					ovm.Previous_Month_2__c = ovf.Previous_Month_2__c - map_Type.get(str1).Previous_Month_2__c;
					ovm.Previous_Month_3__c = ovf.Previous_Month_3__c - map_Type.get(str1).Previous_Month_3__c;
					ovm.Previous_Month_4__c = ovf.Previous_Month_4__c - map_Type.get(str1).Previous_Month_4__c;
					ovm.Previous_Month_5__c = ovf.Previous_Month_5__c - map_Type.get(str1).Previous_Month_5__c;
					ovm.Previous_Month_6__c = ovf.Previous_Month_6__c - map_Type.get(str1).Previous_Month_6__c;
								
					}
				/*	else if (!map_type.containskey(str1)){
						System.Debug('Step4');
					ovm.CurrencyIsoCode = 'USD';
					ovm.Type__c= 'Total Run Rate';
					ovm.Overall_Forecast__c = ovf.Id;
					ovm.Sales_Hierarchy__c = ovf.Sales_Hierarchy__c;
					ovm.Gam_Code__c = ovf.Gam_Code__c;	
					ovm.Month_0__c = ovf.Month_0__c;
					ovm.Month_1__c = ovf.Month_1__c;
					ovm.Month_2__c = ovf.Month_2__c;
					ovm.Month_3__c = ovf.Month_3__c;
					ovm.Month_4__c = ovf.Month_4__c;
					ovm.Month_5__c = ovf.Month_5__c;
					ovm.Month_6__c = ovf.Month_6__c;
					ovm.Month_7__c = ovf.Month_7__c;
					ovm.Month_8__c = ovf.Month_8__c;
					ovm.Month_9__c = ovf.Month_9__c;
					ovm.Month_10__c = ovf.Month_10__c;
					ovm.Month_11__c = ovf.Month_11__c;
					ovm.Month_12__c = ovf.Month_12__c;
					ovm.Month_13__c = ovf.Month_13__c;
					ovm.Month_14__c = ovf.Month_14__c;
					ovm.Month_15__c = ovf.Month_15__c;
					ovm.Month_16__c = ovf.Month_16__c;
					ovm.Month_17__c = ovf.Month_17__c;
					ovm.Previous_Month_1__c = ovf.Previous_Month_1__c;
					ovm.Previous_Month_2__c = ovf.Previous_Month_2__c;
					ovm.Previous_Month_3__c = ovf.Previous_Month_3__c;
					ovm.Previous_Month_4__c = ovf.Previous_Month_4__c;
					ovm.Previous_Month_5__c = ovf.Previous_Month_5__c;
					ovm.Previous_Month_6__c = ovf.Previous_Month_6__c;
				}*/
				ovmTRR.add(ovm);
				}
			}
	}	else {
		for(Overall_Forecast__c ovf : ovForecast){
		Overall_Measures__c ovm = new Overall_Measures__c();		
		system.debug('Step5');
	ovm.CurrencyIsoCode = 'USD';
							ovm.Type__c= 'Total Run Rate';	
							ovm.Overall_Forecast__c = ovf.Id;
							ovm.Sales_Hierarchy__c = ovf.Sales_Hierarchy__c;
							ovm.Gam_Code__c = ovf.Gam_Code__c;
							ovm.Month_0__c = ovf.Month_0__c;
							ovm.Month_1__c = ovf.Month_1__c;
							ovm.Month_2__c = ovf.Month_2__c;
							ovm.Month_3__c = ovf.Month_3__c;
							ovm.Month_4__c = ovf.Month_4__c;
							ovm.Month_5__c = ovf.Month_5__c;
							ovm.Month_6__c = ovf.Month_6__c;
							ovm.Month_7__c = ovf.Month_7__c;
							ovm.Month_8__c = ovf.Month_8__c;
							ovm.Month_9__c = ovf.Month_9__c;
							ovm.Month_10__c = ovf.Month_10__c;
							ovm.Month_11__c = ovf.Month_11__c;
							ovm.Month_12__c = ovf.Month_12__c;
							ovm.Month_13__c = ovf.Month_13__c;
							ovm.Month_14__c = ovf.Month_14__c;
							ovm.Month_15__c = ovf.Month_15__c;
							ovm.Month_16__c = ovf.Month_16__c;
							ovm.Month_17__c = ovf.Month_17__c;
							ovm.Previous_Month_1__c = ovf.Previous_Month_1__c;
							ovm.Previous_Month_2__c = ovf.Previous_Month_2__c;
							ovm.Previous_Month_3__c = ovf.Previous_Month_3__c;
							ovm.Previous_Month_4__c = ovf.Previous_Month_4__c;
							ovm.Previous_Month_5__c = ovf.Previous_Month_5__c;
							ovm.Previous_Month_6__c = ovf.Previous_Month_6__c;
							
							ovmTRR.add(ovm);
		}
	}
	
			if (ovmTrr.Size()>0){
				System.debug('@@@ovmTRR'+ovmTRR);
				upsert ovmTRR;
				System.debug('@@@ovmTRR!!!'+ovmTRR);
				System.debug('@@@map_type.KeySet!!!'+map_type.keySet());
			}
		
		}
		
	
	public static Overall_Forecast__c getOvForecast(Overall_Measures__c ovMeasures){
		
		Overall_Forecast__c ov = new Overall_Forecast__c(Id = ovMeasures.Overall_Forecast__c);
		ov.Month_0__c = ovMeasures.Overall_Forecast__r.Month_0__c;
		ov.Month_1__c = ovMeasures.Overall_Forecast__r.Month_1__c;
		ov.Month_2__c = ovMeasures.Overall_Forecast__r.Month_2__c;
		ov.Month_3__c = ovMeasures.Overall_Forecast__r.Month_3__c;
		ov.Month_4__c = ovMeasures.Overall_Forecast__r.Month_4__c;
		ov.Month_5__c = ovMeasures.Overall_Forecast__r.Month_5__c;
		ov.Month_6__c = ovMeasures.Overall_Forecast__r.Month_6__c;
		ov.Month_7__c = ovMeasures.Overall_Forecast__r.Month_7__c;
		ov.Month_8__c = ovMeasures.Overall_Forecast__r.Month_8__c;
		ov.Month_9__c = ovMeasures.Overall_Forecast__r.Month_9__c;
		ov.Month_10__c = ovMeasures.Overall_Forecast__r.Month_10__c;
		ov.Month_11__c = ovMeasures.Overall_Forecast__r.Month_11__c;
		ov.Month_12__c = ovMeasures.Overall_Forecast__r.Month_12__c;
		ov.Month_13__c = ovMeasures.Overall_Forecast__r.Month_13__c;
		ov.Month_14__c = ovMeasures.Overall_Forecast__r.Month_14__c;
		ov.Month_15__c = ovMeasures.Overall_Forecast__r.Month_15__c;
		ov.Month_16__c = ovMeasures.Overall_Forecast__r.Month_16__c;
		ov.Month_17__c = ovMeasures.Overall_Forecast__r.Month_17__c;
		ov.Previous_Month_1__c = ovMeasures.Overall_Forecast__r.Previous_Month_1__c;
		ov.Previous_Month_2__c = ovMeasures.Overall_Forecast__r.Previous_Month_2__c;
		ov.Previous_Month_3__c = ovMeasures.Overall_Forecast__r.Previous_Month_3__c;
		ov.Previous_Month_4__c = ovMeasures.Overall_Forecast__r.Previous_Month_4__c;
		ov.Previous_Month_5__c = ovMeasures.Overall_Forecast__r.Previous_Month_5__c;
		ov.Previous_Month_6__c = ovMeasures.Overall_Forecast__r.Previous_Month_6__c;
		ov.GAM_Code__c = ovMeasures.Overall_Forecast__r.Gam_Code__c;
		ov.Sales_Hierarchy__c= ovMeasures.Overall_Forecast__r.Sales_Hierarchy__c;
		
		return ov; 
	} 
	
	public static void CaluclateRemainingRunrate(set<String> gamCode){
	list<Overall_Measures__c> lst_RRR = new list <Overall_Measures__c>();
	list<Overall_Measures__c> lst_TRR = new list <Overall_Measures__c>();
	list<Overall_Measures__c> lst_RRRNew = new list <Overall_Measures__c>();
	list<Overall_Forecast__c> lst_ovf = new list <Overall_Forecast__c>();
	set<Id> set_ovfId = new set <Id>();
	map<Id, Overall_Measures__c> map_RRR = new map<Id, Overall_Measures__c>();
	map<Id, Overall_Measures__c> map_TRR = new map<Id, Overall_Measures__c>();
	map<Id, list<Account_Forecast__c>> map_lstAF = new map<Id, list<Account_Forecast__c>>();
	lst_ovf= [Select Id, Gam_Code__c, Sales_Hierarchy__c from Overall_Forecast__c where Gam_Code__c IN:gamCode]; 
	lst_RRR= [Select Id, Month_0__c,Month_1__c,Month_2__c,Month_3__c,Month_4__c,Month_5__c,Month_6__c,Month_7__c,Month_8__c,Month_9__c,Month_10__c,Month_11__c,Month_12__c , Month_13__c, Month_14__c, Month_15__c, Month_16__c, Month_17__c , Previous_Month_1__c, Previous_Month_2__c,Previous_Month_3__c,Previous_Month_4__c,Previous_Month_5__c, Previous_Month_6__c, GAM_Code__c , Sales_Hierarchy__c , Sum_of_Total_Months__c, Name , type__c, CurrencyIsoCode, Overall_Forecast__c from Overall_Measures__c where Gam_Code__c IN:gamCode and type__c = 'Remaining Accounts Run Rate'];
	lst_TRR= [Select Id, Month_0__c,Month_1__c,Month_2__c,Month_3__c,Month_4__c,Month_5__c,Month_6__c,Month_7__c,Month_8__c,Month_9__c,Month_10__c,Month_11__c,Month_12__c , Month_13__c, Month_14__c, Month_15__c, Month_16__c, Month_17__c , Previous_Month_1__c, Previous_Month_2__c,Previous_Month_3__c,Previous_Month_4__c,Previous_Month_5__c, Previous_Month_6__c, GAM_Code__c , Sales_Hierarchy__c , Sum_of_Total_Months__c, Name , type__c, CurrencyIsoCode, Overall_Forecast__c from Overall_Measures__c where Gam_Code__c IN:gamCode and type__c = 'Total Run Rate'];
		if(!lst_RRR.isEmpty()){
			for (Overall_Measures__c ovm:lst_RRR ){
				map_RRR.Put(ovm.Overall_Forecast__c , ovm);
			}
		}
		if(!lst_TRR.isEmpty()){
			for (Overall_Measures__c ovm:lst_TRR ){
				map_TRR.Put(ovm.Overall_Forecast__c , ovm);
			}
		}
		if(!lst_ovf.isEmpty()){
			for (Overall_Forecast__c ovf:lst_ovf ){
				set_ovfId.add(ovf.Id);
			}
		}
		if(!set_ovfId.isEmpty()){
			for(Account_Forecast__c af:[Select Id, Month_0__c,Month_1__c,Month_2__c,Month_3__c,Month_4__c,Month_5__c,Month_6__c,Month_7__c,Month_8__c,Month_9__c,Month_10__c,Month_11__c,Month_12__c , Month_13__c, Month_14__c, Month_15__c, Month_16__c, Month_17__c , Previous_Month_1__c, Previous_Month_2__c,Previous_Month_3__c,Previous_Month_4__c,Previous_Month_5__c, Previous_Month_6__c, GAM_Code__c , Sum_of_Total_Months__c, Name , CurrencyIsoCode, Overall_Forecast__c from Account_Forecast__c where Overall_Forecast__c IN:set_ovfId]){
				if(map_lstAF.containsKey(af.Overall_Forecast__c)){
					list<Account_Forecast__c> temp = new list<Account_Forecast__c>();
					temp = map_lstAF.get(af.Overall_Forecast__c);
					temp.add(af);
					map_lstAF.put(af.Overall_Forecast__c, temp);
				}
				else if(!map_lstAF.containsKey(af.Overall_Forecast__c)){
					list<Account_Forecast__c> temp = new list<Account_Forecast__c>();
					temp.add(af);
					map_lstAF.put(af.Overall_Forecast__c, temp);
				}
			}
		}
		for (Overall_Forecast__c ovf: lst_ovf){
			if(!map_RRR.ContainsKey(ovf.Id)){
			Overall_Measures__c ovm= new Overall_Measures__c();
			ovm.Overall_Forecast__c = ovf.Id;
			ovm.CurrencyIsoCode= 'USD'; 
			ovm.Gam_Code__c = ovf.Gam_Code__c;
			ovm.Type__c= 'Remaining Accounts Run Rate';
			ovm.Sales_Hierarchy__c = ovf.Sales_Hierarchy__c;
			system.debug('ovm.Sales_Hierarchy__c'+ovm.Sales_Hierarchy__c);
			map_RRR.put(ovf.Id, ovm);
			}
		}
			
		for (Overall_Forecast__c ovf: lst_ovf){
			Decimal TotMonth0 =0;
			Decimal TotMonth1 =0;
			Decimal TotMonth2 =0;
			Decimal TotMonth3 =0;
			Decimal TotMonth4 =0;
			Decimal TotMonth5 =0;
			Decimal TotMonth6 =0;
			Decimal TotMonth7 =0;
			Decimal TotMonth8 =0;
			Decimal TotMonth9 =0;
			Decimal TotMonth10 =0;
			Decimal TotMonth11 =0;
			Decimal TotMonth12 =0;
			Decimal TotMonth13 =0;
			Decimal TotMonth14 =0;
			Decimal TotMonth15 =0;
			Decimal TotMonth16 =0;
			Decimal TotMonth17 =0;
			Decimal TotPreviousMonth1 =0;
			Decimal TotPreviousMonth2 =0;
			Decimal TotPreviousMonth3 =0;
			Decimal TotPreviousMonth4 =0;
			Decimal TotPreviousMonth5 =0;
			Decimal TotPreviousMonth6 =0;
			
			if (map_lstaf.containsKey(ovf.Id)){
				for (Account_Forecast__c af:map_lstaf.get(ovf.Id)){
					TotMonth0 += af.Month_0__c;
					TotMonth1 += af.Month_1__c;
					TotMonth2 += af.Month_2__c;
					TotMonth3 += af.Month_3__c;
					TotMonth4 += af.Month_4__c;
					TotMonth5 += af.Month_5__c;
					TotMonth6 += af.Month_6__c;
					TotMonth7 += af.Month_7__c;
					TotMonth8 += af.Month_8__c;
					TotMonth9 += af.Month_9__c;
					TotMonth10 += af.Month_10__c;
					TotMonth11 += af.Month_11__c;
					TotMonth12 += af.Month_12__c;
					TotMonth13 += af.Month_13__c;
					TotMonth14 += af.Month_14__c;
					TotMonth15 += af.Month_15__c;
					TotMonth16 += af.Month_16__c;
					TotMonth17 += af.Month_17__c; 
					TotPreviousMonth1 += af.Previous_Month_1__c;
					TotPreviousMonth2 += af.Previous_Month_2__c;
					TotPreviousMonth3 += af.Previous_Month_3__c;
					TotPreviousMonth4 += af.Previous_Month_4__c;
					TotPreviousMonth5 += af.Previous_Month_5__c;
					TotPreviousMonth6 += af.Previous_Month_6__c;
				}
			}
			if (map_RRR.ContainsKey(ovf.Id) && map_TRR.ContainsKey(ovf.Id)){
			Overall_Measures__c ovmRRR = map_RRR.get(ovf.Id);  
			Overall_Measures__c ovmTRR = map_TRR.get(ovf.Id);
			ovmRRR.Month_0__c = ovmTRR.Month_0__c - TotMonth0;
			ovmRRR.Month_1__c = ovmTRR.Month_1__c - TotMonth1;
			ovmRRR.Month_2__c = ovmTRR.Month_2__c - TotMonth2;
			ovmRRR.Month_3__c = ovmTRR.Month_3__c - TotMonth3;
			ovmRRR.Month_4__c = ovmTRR.Month_4__c - TotMonth4;
			ovmRRR.Month_5__c = ovmTRR.Month_5__c - TotMonth5;
			ovmRRR.Month_6__c = ovmTRR.Month_6__c - TotMonth6;
			ovmRRR.Month_7__c = ovmTRR.Month_7__c - TotMonth7;
			ovmRRR.Month_8__c = ovmTRR.Month_8__c - TotMonth8;
			ovmRRR.Month_9__c = ovmTRR.Month_9__c - TotMonth9;
			ovmRRR.Month_10__c = ovmTRR.Month_10__c - TotMonth10;
			ovmRRR.Month_11__c = ovmTRR.Month_11__c - TotMonth11;
			ovmRRR.Month_12__c = ovmTRR.Month_12__c - TotMonth12;
			ovmRRR.Month_13__c = ovmTRR.Month_13__c - TotMonth13;
			ovmRRR.Month_14__c = ovmTRR.Month_14__c - TotMonth14;
			ovmRRR.Month_15__c = ovmTRR.Month_15__c - TotMonth15;
			ovmRRR.Month_16__c = ovmTRR.Month_16__c - TotMonth16;
			ovmRRR.Month_17__c = ovmTRR.Month_17__c - TotMonth17;	
			ovmRRR.Previous_Month_1__c = ovmTRR.Previous_Month_1__c - TotPreviousMonth1;
			ovmRRR.Previous_Month_2__c = ovmTRR.Previous_Month_2__c - TotPreviousMonth2;
			ovmRRR.Previous_Month_3__c = ovmTRR.Previous_Month_3__c - TotPreviousMonth3;
			ovmRRR.Previous_Month_4__c = ovmTRR.Previous_Month_4__c - TotPreviousMonth4;
			ovmRRR.Previous_Month_5__c = ovmTRR.Previous_Month_5__c - TotPreviousMonth5;
			ovmRRR.Previous_Month_6__c = ovmTRR.Previous_Month_6__c - TotPreviousMonth6;	
			lst_RRRNew.add(ovmRRR);
			}
		}
		if(!lst_RRRNew.isEmpty()){
			system.debug('@@@@lst_RRRNew'+lst_RRRNew);
		upsert lst_RRRNew;
		}
	}
}