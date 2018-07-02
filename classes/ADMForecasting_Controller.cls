/**********************************************************************
Name: ADMForecasting_Controller 
Copyright © 2017
======================================================
======================================================
Purpose: 
-------                                                             
======================================================
TestClass : ADMForecastingController_Test
======================================================
History                                                            
-------                                                            
VERSION      AUTHOR                DATE             DETAIL                  Description
1.0        Altaf ur Rahman      08/15/2017      INITIAL DEVELOPMENT
***********************************************************************/

public Without Sharing class ADMForecasting_Controller {  
    
    public user currentuser{get;set;}
    public string usertype{get;set;}
    public String Comment{get;set;}   
    public string typeofaccount{get;set;}  
    public transient List<Forecast__c> forecastList{get;set;}    
    public List<Forecast_Detail__c> forecastFDList = new List<Forecast_Detail__c>();      
    public List<Forecast_Detail__c> guidenceFDList = new List<Forecast_Detail__c>();    
    public List<Forecast_Detail__c> yoyFDList = new List<Forecast_Detail__c>();        
    public List<Forecast_Detail__c> forecastDetailNewList{get;set;}   
    public List<ForecastWrapper> forecastLineItems{get;set;}    
    public transient List<ActualWrapper> actualLine{get;set;}    
    public transient List<GuidenceWrapper> guidenceLine{get;set;}     
    public  List<YOYWrapper> yoyLine{get;set;}
    public  MTDWrapper MTDLine{get;set;}    
    public List<Forecast_Detail__c> forecastDetailOldList;      
    public  Set<Forecast_Detail__c> oldRecords;      
    public String editforecastId{get;set;} 
    public String viewforecastId{get;set;}   
    public String forecastname{get;set;}   
    List<Forecast__c> forecastlatestcomment = new List<Forecast__c>();
    List<Note> latestcomment=new List<Note>();
    List<Forecast_Detail__c> fdetaillist = new List<Forecast_Detail__c>();
    List<Forecast_Detail__c> latestcommetupdate = new List<Forecast_Detail__c>();    
    public List<CommentsWrapper> viewAllCommentsList{get;set;}    
    public integer countofForecastRecords {get; set;}
    public Map<String, Forecast_Detail__c> objcractual;
    public Map<String, Forecast_Detail__c> objpastactual;
    public String cM1{get;set;}
    public String cM2{get;set;}
    public String cM3{get;set;}
    public String cM4{get;set;}
    public String cM5{get;set;}
    public String cM6{get;set;}
    public String cM7{get;set;}
    public String cM8{get;set;}
    public String cM9{get;set;}
    public String cM10{get;set;}
    public String cM11{get;set;}
    public String cM12{get;set;}
    
    public String nM1{get;set;}
    public String nM2{get;set;}
    public String nM3{get;set;}
    public String nM4{get;set;}
    public String nM5{get;set;}
    public String nM6{get;set;}
    public String nM7{get;set;}
    public String nM8{get;set;}
    public String nM9{get;set;}
    public String nM10{get;set;}
    public String nM11{get;set;}
    public String nM12{get;set;}
    
    public Integer currentMonth{get;set;}
    public String currentQuarter{get;set;}    
    public Boolean showModify {get;set;}      
    public String loggedInUserRegion{get;set;}
    public String userName{get;set;}
    public String userNetworkId{get;set;}    
    public String currentYear{get; set;}
    public String nextYear{get; set;}
    public String pastYear{get; set;}
    public String pPastYear{get; set;}
    public Date currentMonthstartdate{get;set;}
    public integer rowIndex{get;set;}
    public boolean displayTable {get;set;}
    public integer monthmove {get;set;}    
    public integer nomonthday {get;set;}
    public integer counter=0;  //keeps track of the offset
    //public ADM_Custom_Setting__c paginationSize = ADM_Custom_Setting__c.getValues('ADM_Pagination_size');    
    public integer list_size; //sets the page size or number of rows display on page
    public integer total_size;  //used to show user the total size of the list    
    public string portfolio = 'Portfolio';
    public String SalesEngineer;
    public String DistributionManager;
    public String SalesEngineerManager;
    public String RegionalManager;
    public String DemandManager;
   
        
    public void toggleEdit(){       
        try{
            if(showModify == false){                    
                showModify = true;         
            }else{                  
                showModify = false;          
            }
            getforecastPortfolioLineItemRecs();       
        }
        catch(Exception e){
            System.debug('errMessage' + ': ' + e.getMessage());
            ErrorLogging.Log(e, 'ADMForecasting_Controller', 'toggleEdit','');            
        }
    }
    
    public PageReference Exit(){   
        
        PageReference ePage = new pagereference(URL.getSalesforceBaseUrl().toExternalForm());
        ePage.setRedirect(true);
        return ePage; 
        
    }
    
    public PageReference Back(){  
        try{
            PageReference bPage = new pagereference('/apex/ADMEntryScreen');
            bPage.setRedirect(true);
            return bPage;
        }   
        catch(Exception e){
            System.debug('errMessage' + ': ' + e.getMessage());
            ErrorLogging.Log(e, 'ADMForecasting_Controller', 'Back','');
            return null;  
        }
    }
    
    public List<Forecast_Detail__c> getForecastForCancelBack; 
    public List<Forecast_Detail__c> getForecastForCancelCloned{get; set;}
    public void editmethid(){
        system.debug('forecastLineItems---> '+forecastLineItems);              
         if(forecastLineItems == null || forecastLineItems.size() <= 0){
            getforecastPortfolioLineItemRecs();
         }
         
        try{
            if(forecastLineItems.size()>rowIndex){
                getForecastForCancelBack = new List<Forecast_Detail__c>();
                getForecastForCancelCloned = new List<Forecast_Detail__c>();
                getForecastForCancelBack.clear();            
                getForecastForCancelCloned.clear();
                forecastLineItems[rowIndex].isEdit = true;
                getForecastForCancelBack.add(forecastLineItems[rowIndex].FCurrObj);
                getForecastForCancelBack.add(forecastLineItems[rowIndex].FNextObj);
                
                List<YoYWrapper> yoyListRecs = new List<YoYWrapper>();
                yoyListRecs = forecastLineItems[rowIndex].relatedFDetailRecords2;
                if(!yoyListRecs.isEmpty()){
                    getForecastForCancelBack.add(yoyListRecs[0].YoYCurrObj);
                    getForecastForCancelBack.add(yoyListRecs[0].YoYNextObj);                
                    getForecastForCancelCloned.addAll(getForecastForCancelBack.deepClone(true,true,true));
                }System.debug('getForecastForCancelCloned--> '+getForecastForCancelCloned); 
            }    
        }
        catch(Exception e){
            System.debug('errMessage' + ': ' + e.getMessage());
            ErrorLogging.Log(e, 'ADMForecasting_Controller', 'editmethid','');
            
        }
    }
    
    public void cancelMethod(){
        try{
            if(forecastLineItems.size()>rowIndex){
                forecastLineItems[rowIndex].isEdit = false;            
                forecastLineItems[rowIndex].FCurrObj=getForecastForCancelCloned[0];
                forecastLineItems[rowIndex].FNextObj=getForecastForCancelCloned[1];
                if(forecastLineItems[rowIndex].relatedFDetailRecords2 != null){
                    forecastLineItems[rowIndex].relatedFDetailRecords2[0].YoYCurrObj=getForecastForCancelCloned[2];
                    forecastLineItems[rowIndex].relatedFDetailRecords2[0].YoYNextObj=getForecastForCancelCloned[3];            
                } System.debug('forecastLineItems--> '+forecastLineItems[rowIndex]);            
            }
            getDisablePrevious();
            getDisableNext();
        }
        catch(Exception e){
            System.debug('errMessage' + ': ' + e.getMessage());
            ErrorLogging.Log(e, 'ADMForecasting_Controller', 'cancelMethod','');
            
        }
        
    }
    
    public void saveRec(){ 
        try{
            List<Forecast_Detail__c> saveForecastDetailList = new List<Forecast_Detail__c>();  
            List<Forecast_Detail__c> getForecasttoMultiply = new List<Forecast_Detail__c>();
            Set<Forecast_Detail__c> forecastListtoUpdate = new Set<Forecast_Detail__c>();       
            List<Forecast_Detail__c> upsertList = new List<Forecast_Detail__c>();       
            Boolean differ;   
            forecastListtoUpdate.clear();
            
            if(rowIndex != null){
                if(forecastLineItems.size()>rowIndex){
                    getForecasttoMultiply.add(forecastLineItems[rowIndex].FCurrObj);
                    getForecasttoMultiply.add(forecastLineItems[rowIndex].FNextObj);
                    
                    List<YoYWrapper> yoyListRecs = new List<YoYWrapper>();
                    yoyListRecs = forecastLineItems[rowIndex].relatedFDetailRecords2;
                    if(!yoyListRecs.isEmpty()){
                        getForecasttoMultiply.add(yoyListRecs[0].YoYCurrObj);
                        getForecasttoMultiply.add(yoyListRecs[0].YoYNextObj);
                        
                    }          
                }                
            }
            else{
                for(ForecastWrapper foreWrap : forecastLineItems){            
                    
                    getForecasttoMultiply.add(foreWrap.FCurrObj);
                    getForecasttoMultiply.add(foreWrap.FNextObj);  
                    
                    List<YoYWrapper> yoyListRecs = new List<YoYWrapper>();
                    yoyListRecs = foreWrap.relatedFDetailRecords2;
                    if(!yoyListRecs.isEmpty()){                       
                        getForecasttoMultiply.add(yoyListRecs[0].YoYCurrObj);
                        getForecasttoMultiply.add(yoyListRecs[0].YoYNextObj);
                    }             
                }
            }            
            system.debug('getForecasttoMultiply--> '+getForecasttoMultiply);
            if(!getForecasttoMultiply.isEmpty()){
                for(Forecast_Detail__c forecastDet : getForecasttoMultiply){
                    
                    if(forecastDet.M1__c != null){
                        forecastDet.M1__c = forecastDet.M1__c * 1000;
                    }
                    if(forecastDet.M2__c != null){
                        forecastDet.M2__c = forecastDet.M2__c * 1000;
                    }
                    if(forecastDet.M3__c != null){
                        forecastDet.M3__c = forecastDet.M3__c * 1000;
                    }
                    if(forecastDet.M4__c != null){
                        forecastDet.M4__c = forecastDet.M4__c * 1000;
                    }
                    if(forecastDet.M5__c != null){
                        forecastDet.M5__c = forecastDet.M5__c * 1000;
                    }
                    if(forecastDet.M6__c != null){
                        forecastDet.M6__c = forecastDet.M6__c * 1000;
                    }
                    if(forecastDet.M7__c != null){
                        forecastDet.M7__c = forecastDet.M7__c * 1000;
                    }
                    if(forecastDet.M8__c != null){
                        forecastDet.M8__c = forecastDet.M8__c * 1000;
                    }
                    if(forecastDet.M9__c != null){
                        forecastDet.M9__c = forecastDet.M9__c * 1000;
                    }
                    if(forecastDet.M10__c != null){
                        forecastDet.M10__c = forecastDet.M10__c * 1000;
                    }
                    if(forecastDet.M11__c != null){
                        forecastDet.M11__c = forecastDet.M11__c * 1000;
                    }
                    if(forecastDet.M12__c != null){
                        forecastDet.M12__c = forecastDet.M12__c * 1000;
                    }                
            
                    saveForecastDetailList.add(forecastDet);
                }                
            }           
            system.debug('saveForecastDetailList--> '+saveForecastDetailList);
            system.debug('oldRecords--> '+oldRecords);
            if(!saveForecastDetailList.isEmpty() && !oldRecords.isEmpty()){              
                for(Forecast_Detail__c newRecs : saveForecastDetailList){                
                    for(Forecast_Detail__c oldDetRec : oldRecords){     
                        differ = false;
                        if(newRecs.Id != null){     
                            if(oldDetRec.Id == newRecs.Id){                            
                                if(newRecs.Period__c == currentYear){
                                    for(integer j=1; j<currentMonth; j++)
                                    {    
                                        if((Decimal)oldDetRec.get('M'+j +'__c') != null){
                                            newRecs.put('M'+j +'__c', (Decimal)oldDetRec.get('M'+j +'__c'));
                                        }else{
                                            newRecs.put('M'+j +'__c', null); 
                                        }                                                                        
                                    }
                                }                             
                                system.debug('oldDetRec--> '+oldDetRec);
                                system.debug('newRecs--> '+newRecs);  
                                
                                if(oldDetRec.M1__c != newRecs.M1__c){            
                                    differ = true;      
                                }       
                                else if(oldDetRec.M2__c != newRecs.M2__c){             
                                    differ = true;      
                                }       
                                else if(oldDetRec.M3__c != newRecs.M3__c){             
                                    differ = true;      
                                }       
                                else if(oldDetRec.M4__c != newRecs.M4__c){             
                                    differ = true;      
                                }       
                                else if(oldDetRec.M5__c != newRecs.M5__c){            
                                    differ = true;      
                                }       
                                else if(oldDetRec.M6__c != newRecs.M6__c){             
                                    differ = true;      
                                }       
                                else if(oldDetRec.M7__c != newRecs.M7__c){             
                                    differ = true;      
                                }       
                                else if(oldDetRec.M8__c != newRecs.M8__c){            
                                    differ = true;      
                                }       
                                else if(oldDetRec.M9__c != newRecs.M9__c){             
                                    differ = true;      
                                }       
                                else if(oldDetRec.M10__c != newRecs.M10__c){              
                                    differ = true;      
                                }       
                                else if(oldDetRec.M11__c != newRecs.M11__c){                
                                    differ = true;      
                                }       
                                else if(oldDetRec.M12__c != newRecs.M12__c){                             
                                    differ = true;      
                                }                                       
                            }       
                        }                               
                        if(differ){          
                            forecastListtoUpdate.add(newRecs);     
                            system.debug('forecastListtoUpdate if--> '+forecastListtoUpdate);
                        }       
                    }                           
                }       
            }
            
            if(!saveForecastDetailList.isEmpty()){              
                for(Forecast_Detail__c newRecs : saveForecastDetailList){                 
                    if(newRecs.Id == null){
                        if(newRecs.Period__c == currentYear){
                            for(integer j=1; j<currentMonth; j++)
                            {                               
                                newRecs.put('M'+j +'__c', null);                                                                                                    
                            }
                        }
                        forecastListtoUpdate.add(newRecs);  
                        system.debug('forecastListtoUpdate else--> '+forecastListtoUpdate);
                    }
                }
            }
            upsertList.clear();
            upsertList.addAll(forecastListtoUpdate);   
            system.debug('upsertList-->'+upsertList);
            
            if(!upsertList.isEmpty()){                
                // DML statement
                Database.UpsertResult[] srList = Database.upsert(upsertList, false);                
                // Iterate through each returned result
                for (Database.UpsertResult sr : srList) {
                    if (sr.isSuccess()) {
                        // Operation was successful, so get the ID of the record that was processed
                        System.debug('Successfully upsert FD Records :--> ' + sr.getId());
                    }
                    else {
                        // Operation failed, so get all errors                
                        for(Database.Error err : sr.getErrors()) {
                            System.debug('The following error has occurred.');                    
                            System.debug(err.getStatusCode() + ': ' + err.getMessage());
                            System.debug('FD fields that affected this error: ' + err.getFields());
                        }
                    }
                }
            }
            
            system.debug('saveForecastDetailList last--> '+saveForecastDetailList);
            if(!saveForecastDetailList.isEmpty()){
                for(Forecast_Detail__c fDListDividedByThou : saveForecastDetailList){
                if(fDListDividedByThou != null){
                Forecast_Detail__c fdas=objcractual.get(String.valueof(fDListDividedByThou.Parent_Forecast__c));
                Forecast_Detail__c fdpa=objpastactual.get(String.valueof(fDListDividedByThou.Parent_Forecast__c));
                    for(integer j=1; j<13; j++){
                            
                                //added for actual override
                                if(fDListDividedByThou.Type__c == 'Forecast' && fDListDividedByThou.period__c == currentyear){                       
                                
                                if(fdas != null && j< currentMonth){
                                
                                integer lastmonthcnt = currentMonth-1; 
                                if(j == lastmonthcnt)
                                {
                                if(nomonthday>monthmove){
                                
                                if(fdas.get('M'+j +'__c') != Null){ 
                                fDListDividedByThou.put('M'+j +'__c', (decimal)fdas.get('M'+j +'__c')*1000); }                                
                                } }
                                else
                                {
                                    if(fdas.get('M'+j +'__c') != Null){ 
                                    fDListDividedByThou.put('M'+j +'__c', (decimal)fdas.get('M'+j +'__c')*1000);}
                                }  }
                                }
                                //added for yoy override
                                if(fDListDividedByThou.Type__c == 'YoY Variance'  && fDListDividedByThou.period__c == currentyear){
                                    if(j< currentMonth)
                                    {
                                        integer lastmonthcnt = currentMonth-1;
                                        if(j == lastmonthcnt)
                                        {
                                        if(nomonthday>monthmove)
                                        {
                                            if(fdas != Null && fdpa != null){
                                                if(fdas.get('M'+j +'__c') != Null && fdpa.get('M'+j +'__c') != Null)
                                                {                                         
                                                    fDListDividedByThou.put('M'+j +'__c', (decimal)fdas.get('M'+j +'__c')*1000 - (decimal)fdpa.get('M'+j +'__c')*1000);                                         
                                                }                                                
                                                else if(fdas.get('M'+j +'__c') == Null && fdpa.get('M'+j +'__c') != Null)
                                                {                                         
                                                    fDListDividedByThou.put('M'+j +'__c', - (decimal)fdpa.get('M'+j +'__c')*1000);                                         
                                                }
                                                else if(fdas.get('M'+j +'__c') != Null && fdpa.get('M'+j +'__c') == Null)
                                                {                                         
                                                    fDListDividedByThou.put('M'+j +'__c', (decimal)fdas.get('M'+j +'__c')*1000);                                         
                                                }                                            
                                            }
                                            else if(fdas != Null && fdpa == null){
                                            if(fdas.get('M'+j +'__c') != Null)
                                            {                                         
                                                fDListDividedByThou.put('M'+j +'__c', (decimal)fdas.get('M'+j +'__c')*1000);                                         
                                            } }
                                            else if(fdas == Null && fdpa != null){
                                            if(fdpa.get('M'+j +'__c') != Null)
                                            {                                         
                                                fDListDividedByThou.put('M'+j +'__c', - (decimal)fdpa.get('M'+j +'__c')*1000);                                         
                                            } }                              
                                        } }
                                        else
                                        {
                                            if(fdas != Null && fdpa != null){
                                                if(fdas.get('M'+j +'__c') != Null && fdpa.get('M'+j +'__c') != Null)
                                                {                                         
                                                    fDListDividedByThou.put('M'+j +'__c', (decimal)fdas.get('M'+j +'__c')*1000 - (decimal)fdpa.get('M'+j +'__c')*1000);                                         
                                                }                                                
                                                else if(fdas.get('M'+j +'__c') == Null && fdpa.get('M'+j +'__c') != Null)
                                                {                                         
                                                    fDListDividedByThou.put('M'+j +'__c', - (decimal)fdpa.get('M'+j +'__c')*1000);                                         
                                                }
                                                else if(fdas.get('M'+j +'__c') != Null && fdpa.get('M'+j +'__c') == Null)
                                                {                                         
                                                    fDListDividedByThou.put('M'+j +'__c', (decimal)fdas.get('M'+j +'__c')*1000);                                         
                                                }                                            
                                            }
                                            else if(fdas != Null && fdpa == null){
                                            if(fdas.get('M'+j +'__c') != Null)
                                            {                                         
                                                fDListDividedByThou.put('M'+j +'__c', (decimal)fdas.get('M'+j +'__c')*1000);                                         
                                            } }
                                            else if(fdas == Null && fdpa != null){
                                            if(fdpa.get('M'+j +'__c') != Null)
                                            {                                         
                                                fDListDividedByThou.put('M'+j +'__c', -(decimal)fdpa.get('M'+j +'__c')*1000);                                         
                                            } }
                                        }
                                    }                                
                                }
                                //end override
                               if(fDListDividedByThou.get('M'+j +'__c') != null){ 
                                fDListDividedByThou.put('M'+j +'__c', (decimal)fDListDividedByThou.get('M'+j +'__c')/1000);
                            }                            
                        }
                        system.debug('fDListDividedByThou--'+fDListDividedByThou);
                    }                    
                }
            }       
            system.debug('saveForecastDetailList last--> '+saveForecastDetailList);
                   
            if(rowIndex != null){
                if(forecastLineItems.size()>rowIndex){
                    forecastLineItems[rowIndex].isEdit = false;
                }
            }else{
                //toggleEdit();
                 showModify = false;
                 
            }
            getDisablePrevious();
            getDisableNext();
        }
        catch(Exception e){
            System.debug('errMessage' + ': ' + e.getMessage());
            ErrorLogging.Log(e, 'ADMForecasting_Controller', 'saveRec','');            
        }    
    }      
    
    
    public ADMForecasting_Controller() {
        try{
            string PageSize = apexpages.currentpage().getParameters().get('PaginationRecords');               
            System.Debug('PageSizeP :'+PageSize);                            
            if(PageSize != null){
                list_size = Integer.valueOf(PageSize);
                System.Debug('list_sizeP :'+list_size);
            }
            objcractual = new Map<String, Forecast_Detail__c>();
            objpastactual = new Map<String, Forecast_Detail__c>();
            
            Integer portfolioCount = Integer.valueOf(apexpages.currentpage().getParameters().get('portfolioCount'));
            total_size = portfolioCount;
            system.debug('Count of Total  Portfolio Records--> '+total_size);  
            
            showModify = false;
            system.debug('showModify constructor --> '+showModify);
            displayTable = false;        
            monthmove = 7;                
            ADM_Custom_Setting__c monthmoveSetting = ADM_Custom_Setting__c.getValues('ADM_Month_Movement');
            if(monthmoveSetting != null){
                monthmove = Integer.valueof(monthmoveSetting.Value__c);
            }   
            currentuser =new User();
            currentuser = [SELECT Id,ADM_User_Type__c,LocaleSidKey, LanguageLocaleKey, Region__c,FirstName,LastName,Te_Network_Id__c FROM User WHERE Id = : UserInfo.getUserId()];
                        
            loggedInUserRegion = currentuser.Region__c;
            userName = currentuser.FirstName +' '+currentuser.LastName;
            userNetworkId = currentuser.Te_Network_Id__c;
            
            usertype = '';
            SalesEngineer ='';
            DistributionManager ='';
            SalesEngineerManager ='';
            RegionalManager ='';
            DemandManager ='';
            ADM_Custom_Setting__c SEngineer = ADM_Custom_Setting__c.getInstance('ADMSalesEngineer');
            SalesEngineer = SEngineer.Value__c;
       
            ADM_Custom_Setting__c DistyManager = ADM_Custom_Setting__c.getInstance('ADMDistributionManager');
            DistributionManager = DistyManager.Value__c;
       
            ADM_Custom_Setting__c SEngineerMgnr = ADM_Custom_Setting__c.getInstance('ADMSalesEngineerManager');
            SalesEngineerManager = SEngineerMgnr.Value__c;
       
            ADM_Custom_Setting__c RegionalMgnr = ADM_Custom_Setting__c.getInstance('ADMRegionalManager');
            RegionalManager = RegionalMgnr.Value__c;
       
            ADM_Custom_Setting__c DemandMgnr = ADM_Custom_Setting__c.getInstance('ADMDemandManager');
            DemandManager = DemandMgnr.Value__c;

            usertype = currentuser.ADM_User_Type__c;
            
            system.debug('***usertype***' + usertype);
        }
        catch(Exception e){
            System.debug('errMessage' + ': ' + e.getMessage());           
        }        
    }

    
    public void getforecastPortfolioLineItemRecs(){
        
        try{              
            countofForecastRecords= 0;
            Boolean isEdit = false;
            forecastLineItems = new List<ForecastWrapper>();     
            
            /*currentuser =new User();
            currentuser = [SELECT Id,ADM_User_Type__c,LocaleSidKey, LanguageLocaleKey, Region__c,FirstName,LastName,Te_Network_Id__c FROM User WHERE Id = : UserInfo.getUserId()];
            
            
            loggedInUserRegion = currentuser.Region__c;
            userName = currentuser.FirstName +' '+currentuser.LastName;
            userNetworkId = currentuser.Te_Network_Id__c;*/          
            
            oldRecords = new Set<Forecast_Detail__c>();             
            oldRecords.clear(); 
            forecastList = new List<Forecast__c>();
            
            typeofaccount ='';
            string type = apexpages.currentpage().getParameters().get('selectedOptions');   
            typeofaccount = type;
            string subunit = apexpages.currentpage().getParameters().get('ProfitCentre');
            string SoldToCustomer = apexpages.currentpage().getParameters().get('SoldToCust');
            string soldToCustNum = apexpages.currentpage().getParameters().get('SoldToCustNum');
            string WWCustNum = apexpages.currentpage().getParameters().get('WWCNum');
            string WWCustmName = apexpages.currentpage().getParameters().get('WWCustmN');
            string DstrictVal = apexpages.currentpage().getParameters().get('Dstr');
            string RegionVal = apexpages.currentpage().getParameters().get('Reg');
            string userIdVal = apexpages.currentpage().getParameters().get('Userid');
            string cbc3Val = apexpages.currentpage().getParameters().get('cbc3');   
            
            forecastList = ADMEntryScreenHelper.getforecastrec(type, SoldToCustomer, WWCustmName, WWCustNum, RegionVal, DstrictVal, subunit, userIdVal, usertype, currentuser.id, soldToCustNum, cbc3Val,list_size,counter,portfolio);     
            System.Debug('forecastList====>>>'+forecastList);
            System.Debug('forecastListSize====>>>'+forecastList.Size());
            /*Current year and month logic*/
            Date todaydate = System.Today();        
            
            set<String> forecastSet = new Set<String>();
            FiscalYearSettings currentfisobj = [select id,name,EndDate from FiscalYearSettings WHERE StartDate <=: todaydate and EndDate>=: todaydate];
            
            currentYear = currentfisobj.name;
            nextYear = String.valueOf(Integer.ValueOf(currentYear)+1);
            pastYear = String.valueOf(Integer.ValueOf(currentYear)-1);
            pPastYear = String.valueOf(Integer.ValueOf(currentYear)-2);            
            
            /*Fetch monthly actual sales value from external */
            Set<String> forecastexids=new Set<String>();
            Set<String> dailyforecastexids=new Set<String>();
            
            if(forecastList != null)
            {                
                for(Forecast__c forecastforex: forecastList)
                {
                    if(forecastforex.Type__c == 'Portfolio'){
                        if(forecastforex.External_ID__c!=null) {
                            forecastexids.add(forecastforex.External_ID__c+'-'+pastYear);
                            forecastexids.add(forecastforex.External_ID__c+'-'+currentYear);
                            forecastexids.add(forecastforex.External_ID__c+'-'+pPastYear);
                            dailyforecastexids.add(forecastforex.External_ID__c);
                        }   
                        forecastSet.add(forecastforex.Id);
                    }
                }
            } 
            
            countofForecastRecords = forecastSet.size();
            //notes = [SELECT Body,Id,OwnerId,ParentId,Title,CreatedBy.Name, CreatedDate FROM Note WHERE ParentId IN : forecastSet ORDER BY CreatedDate DESC];
            
            List<MonthlyActualSales__x> ExtMonthlyEactualualSales = new List<MonthlyActualSales__x>();
            Map<String, MonthlyActualSales__x> extActual= new Map<String,MonthlyActualSales__x >();
            try {
                ExtMonthlyEactualualSales = ADMEntryScreenHelper.getExMonthlyActualSales(forecastexids);  
                     
                if(ExtMonthlyEactualualSales != null)
                {
                    for(MonthlyActualSales__x singleActual:ExtMonthlyEactualualSales)
                    {                 
                        extActual.put(singleActual.SFDC_EXTERNAL_ID__c,singleActual);
                    }
                }
            }
            catch(ExternalObjectException e){
                System.debug('errMessage' + ': ' + e.getMessage());
                ErrorLogging.Log(e, 'ADMForecasting_Controller', 'ExtMonthlyEactualualSales ','');            
            }             
            /*Fetch daily actual sales value from external */
            List<DailyActualSales__x> ForecastdailyActual = new List<DailyActualSales__x>();
            Map<String, Decimal> mtdActual= new Map<String, Decimal>();
            try {
                ForecastdailyActual =ADMEntryScreenHelper.getExForecastDailyActual(dailyforecastexids);      
                if(forecastdailyActual != null)
                {
                    for(DailyActualSales__x singleddailyActual:forecastdailyActual)
                    {                
                        
                        mtdActual.put(singleddailyActual.SFDC_EXTERNAL_ID__c+'-'+String.valueOf(singleddailyActual.YEAR_ID__c)+'-'+String.valueOf(singleddailyActual.MONTH_ID__c),singleddailyActual.MTD_AMOUNT__c); 
                        
                    }
                }
            }
            catch(ExternalObjectException e){
                System.debug('errMessage' + ': ' + e.getMessage());
                ErrorLogging.Log(e, 'ADMForecasting_Controller', 'ForecastdailyActual','');            
            }      
            
            /*Query to fetch current year all months info from period table*/  
            LIST<period> listperiodcurr = [SELECT StartDate, EndDate FROM Period WHERE type='Month'  AND FiscalYearSettingsId =:currentfisobj.id order by StartDate];
            
            Integer p=0;
            for(period periodmonth: listperiodcurr)
            {
                p++;
                if(periodmonth.StartDate<=todaydate && periodmonth.EndDate>=todaydate)
                {
                    currentMonth=p;
                    currentMonthstartdate=periodmonth.StartDate;
                    break;
                }                
            }
            
            nomonthday = currentMonthstartdate.daysBetween(todaydate)+1;               
            Integer monthincrvar=1;
            
            /*For current year fiscal year months enddate calculate*/
            for(period currperiodmonth: listperiodcurr)
            {              
                Datetime currentyrenddt = Datetime.newInstance(currperiodmonth.EndDate.year(), currperiodmonth.EndDate.month(),currperiodmonth.EndDate.day());
                String enddtstr= currentyrenddt.format('MM/dd/yyyy');
                
                if(monthincrvar == 1)              
                {                     
                    cM1 = enddtstr;                                        
                }
                else if(monthincrvar == 2)
                { 
                    cM2 = enddtstr;               
                }
                else if(monthincrvar == 3)
                { 
                    cM3 = enddtstr;            
                } 
                else if(monthincrvar == 4)
                { 
                    cM4 = enddtstr;               
                }
                else if(monthincrvar == 5)
                { 
                    cM5 = enddtstr;                
                }
                else if(monthincrvar == 6)
                { 
                    cM6 = enddtstr;                 
                }
                else if(monthincrvar == 7)
                { 
                    cM7 = enddtstr;                  
                }
                else if(monthincrvar == 8)
                { 
                    cM8 = enddtstr;                
                }
                else if(monthincrvar == 9)
                { 
                    cM9 = enddtstr;              
                }
                else if(monthincrvar == 10)
                { 
                    cM10 = enddtstr;                  
                }
                else if(monthincrvar == 11)
                { 
                    cM11 = enddtstr;              
                }
                else if(monthincrvar == 12)
                { 
                    cM12 = enddtstr;                              
                }    
                monthincrvar++;               
            }
            
            /*For Next year fiscal year months enddate calculate*/            
            FiscalYearSettings nextfisobj = [select id,name,EndDate from FiscalYearSettings WHERE name =: nextYear];
            
            LIST<period> listperiodnext = [SELECT StartDate, EndDate FROM Period WHERE type='Month'  AND FiscalYearSettingsId =:nextfisobj.id order by StartDate];
            
            Integer monthinnrvar=1;
            
            /*For current year fiscal year months enddate calculate*/
            for(period nxtperiodmonth: listperiodnext)
            {       
                Datetime nxtyrenddt = Datetime.newInstance(nxtperiodmonth.EndDate.year(), nxtperiodmonth.EndDate.month(),nxtperiodmonth.EndDate.day());
                String nxtenddtstr= nxtyrenddt.format('MM/dd/yyyy');
                
                if(monthinnrvar == 1)
                { 
                    nM1 = nxtenddtstr;                
                }
                else if(monthinnrvar == 2)
                { 
                    nM2 = nxtenddtstr;               
                }
                else if(monthinnrvar == 3)
                { 
                    nM3 = nxtenddtstr;            
                } 
                else if(monthinnrvar == 4)
                { 
                    nM4 = nxtenddtstr;               
                }
                else if(monthinnrvar == 5)
                { 
                    nM5 = nxtenddtstr;                
                }
                else if(monthinnrvar == 6)
                { 
                    nM6 = nxtenddtstr;                 
                }
                else if(monthinnrvar == 7)
                { 
                    nM7 = nxtenddtstr;                  
                }
                else if(monthinnrvar == 8)
                { 
                    nM8 = nxtenddtstr;                
                }
                else if(monthinnrvar == 9)
                { 
                    nM9 = nxtenddtstr;              
                }
                else if(monthinnrvar == 10)
                { 
                    nM10 = nxtenddtstr;                  
                }
                else if(monthinnrvar == 11)
                { 
                    nM11 = nxtenddtstr;              
                }
                else if(monthinnrvar == 12)
                { 
                    nM12 = nxtenddtstr;               
                }    
                monthinnrvar++;             
            }
            
            
            if(1 >= currentMonth || currentMonth <= 3){
                currentQuarter = currentYear+'Q2';
            }else if (4 >= currentMonth || currentMonth <= 6){
                currentQuarter = currentYear+'Q3';
            }else if(7 >= currentMonth || currentMonth <= 9){
                currentQuarter = currentYear+'Q4';
            }else if(10 >= currentMonth || currentMonth <= 12){
                currentQuarter = currentYear+'Q1';
            }   
            
            Forecast__c parentForecast;            
            Forecast_Detail__c obCurrent;
            Forecast_Detail__c obNext;
            Forecast_Detail__c obPast;
            
            Forecast_Detail__c obPastActual;
            Forecast_Detail__c obCurrentActual;
            
            Forecast_Detail__c obCurrentGuidence;
            Forecast_Detail__c obNextGuidence;
            
            Forecast_Detail__c obCurrentYoY;
            Forecast_Detail__c obNextYoY;
            
            String Comments;
            String CLastmodifiedname;
            DateTime CLastModifiedDate;
            String CForecastrecID;
            String CForecastrecName;
            
            String SoldToCustomerName;
            String WorldWideAccountName;
            String WordWideAccountNumber; 
            String AccountNum;
            String BCountry;
            String BState;
            String BCity;
            String CBC2;
            String CBC3;
            String CBC4;
            String Region;
            String District;
            String RegSalesMngr;
            String DistSalesMngr;
            String SalesEng;
            String DistMngr;
            String TEUserID;
            List<ADMDistyUserRegions__c> ADMDistyNewObjList = [SELECT id, Name, Regional_Manager__r.Name, Distribution_Manager__r.Name, Region_Code__c, Region_Description__c FROM ADMDistyUserRegions__c];        
            Map<String,String> usrregmap = new Map<String,String>();
            List<ADM_User_Region__c> usrreg = ADM_User_Region__c.getAll().Values();
            if(usrreg != null) {
                for(ADM_User_Region__c rg : usrreg){
                    usrregmap.put(rg.ADM_User_Region_Label__c,rg.ADM_User_Region_Value__c);      
                }                
            }
            System.Debug('usrregmap'+usrregmap);
            
             if((editforecastId  !='' && editforecastId != null) && (Comment !='' && Comment !=null))  {
                addComment();
            }
            
            notes = [SELECT Body,Id,OwnerId,ParentId,Title,CreatedBy.Name, CreatedDate FROM Note WHERE ParentId IN : forecastSet ORDER BY CreatedDate DESC];
            
            for(Forecast__c f : forecastList){
                if(f.Type__c == 'Portfolio'){
                    
                    List<Forecast_Detail__c> fdRec = new List<Forecast_Detail__c>();
                    fdRec = f.Forecast_Details__r;
                    
                    forecastDetailNewList = new List<Forecast_Detail__c>();      
                    forecastDetailNewList.clear(); 
                    forecastFDList = new List<Forecast_Detail__c>();
                    guidenceFDList = new List<Forecast_Detail__c>();    
                    yoyFDList = new List<Forecast_Detail__c>();    
                    forecastFDList.clear();
                    guidenceFDList.clear();
                    yoyFDList.clear();
                    
                    forecastDetailOldList = new List<Forecast_Detail__c>();  
                    forecastDetailOldList.clear();
                    obPastActual = new Forecast_Detail__c();                     
                    obCurrentActual= new Forecast_Detail__c(); 
                    obCurrentGuidence= new Forecast_Detail__c(); 
                    obNextGuidence = new Forecast_Detail__c(); 
                    obCurrentYoY= new Forecast_Detail__c(); 
                    obNextYoY= new Forecast_Detail__c(); 
                    obCurrent= new Forecast_Detail__c();
                    obPast= new Forecast_Detail__c(); 
                    obNext= new Forecast_Detail__c(); 
                    
                    Decimal CurrentyrYoYPercentageval = 0;
                    Decimal NextyrYoYPercentageval = 0;
                    Decimal CurrentyrYoYAmountval = 0;
                    Decimal NextyrYoYAmountval = 0;
                    Decimal PYActualTotal = 0; 
                    Decimal pPastYActualTotal = 0;
                    Decimal currentYActualTotal = 0;
                    
                    Boolean currentfdflg = false;
                    Boolean nextfdflg = false;
                    Boolean currentyoyflg = false;
                    Boolean nextyoyflg = false;
                    Boolean currentGuidanceflg = false;
                    Boolean nextGuidanceflg = false;
                    
                    String fdTypeForecast;
                    String fdTypeActual;
                    String fdTypeGuidance;
                    String fdTypeYoY;
                    
                    
                    obCurrent.clear();
                    obNext.clear();
                    obPast.clear();    
                    obPastActual.clear();
                    obCurrentActual.clear();
                    obCurrentGuidence.clear();
                    obNextGuidence.clear();
                    obCurrentYoY.clear();
                    obNextYoY.clear();
                    
                    parentForecast = new Forecast__c();
                    parentForecast = f;
                    CForecastrecID = f.id;
                    CForecastrecName = f.Name; 
                    if(type=='OEM'){
                        CBC2 = f.GPL__r.CBC2_Description__c;
                        CBC3 = f.GPL__r.CBC3_Description__c;
                        CBC4 = f.GPL__r.CBC4_Description__c;
                        Region = f.Accountid__r.LAYER2_ORGANIZATION_LONG_NM__c;
                        District = f.Accountid__r.LAYER3_ORGANIZATION_LONG_NM__c;
                        RegSalesMngr = f.AccountId__r.Sales_Hierarchy__r.Level_2_Assigned_User_Names__c;
                        DistSalesMngr = f.AccountId__r.Sales_Hierarchy__r.Level_3_Assigned_User_Names__c;
                        SalesEng = f.Accountid__r.Sales_Hierarchy__r.Level_7_Territory_Name__c;
                        DistMngr = null;
                        TEUserID = f.AccountId__r.Account_Manager__r.Te_Network_Id__c ;
                        SoldToCustomerName = f.Accountid__r.Name;
                        WorldWideAccountName = f.Accountid__r.WWCORPACCTNM__c;
                        WordWideAccountNumber = f.Accountid__r.WWCORPACCT__c;
                        BCountry = f.Accountid__r.BillingCountry;
                        BState = f.Accountid__r.BillingState;
                        BCity = f.Accountid__r.BillingCity;
                        AccountNum = f.Accountid__r.AccountNumber;
                    }else if(type=='Distributor'){
                        CBC2 = f.CBC2_Description__c;
                        CBC3 = f.CBC3_Description__c;
                        CBC4 = null;
                        Region = f.Region_Description__c;
                        District = f.District_Description__c;
                        SoldToCustomerName =null;
                        WorldWideAccountName = f.Worldwide_Account_Name__c;
                        WordWideAccountNumber = f.Worldwide_Account_Number__c;
                        BCountry = null;
                        BState = null;
                        BCity = null;
                        AccountNum = f.Worldwide_Account_Number__c;
                        if(ADMDistyNewObjList.Size() > 0) {
                            for(ADMDistyUserRegions__c ur:ADMDistyNewObjList) {
                                if(f.Region__c == ur.Region_Code__c) {
                                    RegSalesMngr = ur.Regional_Manager__r.Name;
                                    DistMngr = ur.Distribution_Manager__r.Name;
                                }
                            }
                        }
                        DistSalesMngr = null;
                        SalesEng = null;
                        if(f.Region__c == usrregmap.get(loggedInUserRegion)){
                            TEUserID = userNetworkId;
                        }else{
                            TEUserID = null;
                        }
                    }
                    MonthlyActualSales__x  Eactual = new MonthlyActualSales__x();
                    MonthlyActualSales__x  EactualPastPYear = new MonthlyActualSales__x();    
                    
                    if(extActual !=null) {                                                                             
                        EactualPastPYear = extActual.get(f.External_Id__c+'-'+pPastYear );
                        //below code is to fetch ppyActuals && PYActuals
                        if(EactualPastPYear != Null){ 
                                                        
                            if(EactualPastPYear.YEARLYTOT_AMOUNT__c  != null){
                                Decimal M1 = EactualPastPYear.YEARLYTOT_AMOUNT__c;
                                M1 = M1.setScale(2, RoundingMode.HALF_EVEN);                                            
                                pPastYActualTotal=M1;
                            }                                                                   
                        }
                                                
                        Eactual = extActual.get(f.External_Id__c+'-'+pastYear );
                        if(Eactual != Null){ 
                                                        
                            fdTypeActual = 'Actuals';                                    
                            if(Eactual.M1_AMOUNT__c != null){
                                Decimal M1 = Eactual.M1_AMOUNT__c;
                                M1 = M1.setScale(2, RoundingMode.HALF_EVEN);
                                obPastActual.M1__c = M1;
                                PYActualTotal+=M1;
                            }                                    
                            if(Eactual.M2_AMOUNT__c != null){
                                Decimal M2 = Eactual.M2_AMOUNT__c;
                                M2 = M2.setScale(2, RoundingMode.HALF_EVEN);
                                obPastActual.M2__c = M2;
                                PYActualTotal+=M2;
                            }
                            if(Eactual.M3_AMOUNT__c != null){
                                Decimal M3 = Eactual.M3_AMOUNT__c;
                                M3 = M3.setScale(2, RoundingMode.HALF_EVEN);
                                obPastActual.M3__c = M3;
                                PYActualTotal+=M3;
                            }
                            if(Eactual.M4_AMOUNT__c != null){
                                Decimal M4 = Eactual.M4_AMOUNT__c;
                                M4 = M4.setScale(2, RoundingMode.HALF_EVEN);
                                obPastActual.M4__c = M4;
                                PYActualTotal+=M4;
                            }
                            if(Eactual.M5_AMOUNT__c != null){
                                Decimal M5 = Eactual.M5_AMOUNT__c;
                                M5 = M5.setScale(2, RoundingMode.HALF_EVEN);
                                obPastActual.M5__c = M5;
                                PYActualTotal+=M5;
                            }
                            if(Eactual.M6_AMOUNT__c != null){
                                Decimal M6 = Eactual.M6_AMOUNT__c;
                                M6 = M6.setScale(2, RoundingMode.HALF_EVEN);
                                obPastActual.M6__c = M6;
                                PYActualTotal+=M6;
                            }
                            if(Eactual.M7_AMOUNT__c != null){
                                Decimal M7 = Eactual.M7_AMOUNT__c;
                                M7 = M7.setScale(2, RoundingMode.HALF_EVEN);
                                obPastActual.M7__c = M7;
                                PYActualTotal+=M7;
                            }
                            if(Eactual.M8_AMOUNT__c != null){
                                Decimal M8 = Eactual.M8_AMOUNT__c;
                                M8 = M8.setScale(2, RoundingMode.HALF_EVEN);
                                obPastActual.M8__c = M8;
                                PYActualTotal+=M8;
                            }
                            if(Eactual.M9_AMOUNT__c != null){
                                Decimal M9 = Eactual.M9_AMOUNT__c;
                                M9 = M9.setScale(2, RoundingMode.HALF_EVEN);
                                obPastActual.M9__c = M9;
                                PYActualTotal+=M9;
                            }
                            if(Eactual.M10_AMOUNT__c != null){
                                Decimal M10 = Eactual.M10_AMOUNT__c;
                                M10 = M10.setScale(2, RoundingMode.HALF_EVEN);
                                obPastActual.M10__c = M10;
                                PYActualTotal+=M10;
                            }
                            if(Eactual.M11_AMOUNT__c != null){
                                Decimal M11 = Eactual.M11_AMOUNT__c;
                                M11 = M11.setScale(2, RoundingMode.HALF_EVEN);
                                obPastActual.M11__c = M11;
                                PYActualTotal+=M11;
                            }
                            if(Eactual.M12_AMOUNT__c != null){
                                Decimal M12 = Eactual.M12_AMOUNT__c;
                                M12 = M12.setScale(2, RoundingMode.HALF_EVEN);
                                obPastActual.M12__c = M12;
                                PYActualTotal+=M12;
                            }
                           objpastactual.put(String.valueof(f.Id),obPastActual);                                      
                        }
                        
                        Eactual = new MonthlyActualSales__x();
                        
                        Eactual = extActual.get(f.External_Id__c+'-'+currentYear);
                        
                        if(Eactual != Null){
                            fdTypeActual = 'Actuals';
                            if(Eactual.M1_AMOUNT__c != null){
                                Decimal CM1 = Eactual.M1_AMOUNT__c;
                                CM1 = CM1.setScale(2, RoundingMode.HALF_EVEN);
                                obCurrentActual.M1__c = CM1;
                            }                                    
                            if(Eactual.M2_AMOUNT__c != null){
                                Decimal CM2 = Eactual.M2_AMOUNT__c;
                                CM2 = CM2.setScale(2, RoundingMode.HALF_EVEN);
                                obCurrentActual.M2__c = CM2;
                            }
                            if(Eactual.M3_AMOUNT__c != null){
                                Decimal CM3 = Eactual.M3_AMOUNT__c;
                                CM3 = CM3.setScale(2, RoundingMode.HALF_EVEN);
                                obCurrentActual.M3__c = CM3;
                            }
                            if(Eactual.M4_AMOUNT__c != null){
                                Decimal CM4 = Eactual.M4_AMOUNT__c;
                                CM4 = CM4.setScale(2, RoundingMode.HALF_EVEN);
                                obCurrentActual.M4__c = CM4;
                            }
                            if(Eactual.M5_AMOUNT__c != null){
                                Decimal CM5 = Eactual.M5_AMOUNT__c;
                                CM5 = CM5.setScale(2, RoundingMode.HALF_EVEN);
                                obCurrentActual.M5__c = CM5;
                            }
                            if(Eactual.M6_AMOUNT__c != null){
                                Decimal CM6 = Eactual.M6_AMOUNT__c;
                                CM6 = CM6.setScale(2, RoundingMode.HALF_EVEN);
                                obCurrentActual.M6__c = CM6;
                            }
                            if(Eactual.M7_AMOUNT__c != null){
                                Decimal CM7 = Eactual.M7_AMOUNT__c;
                                CM7 = CM7.setScale(2, RoundingMode.HALF_EVEN);
                                obCurrentActual.M7__c = CM7;
                            }
                            if(Eactual.M8_AMOUNT__c != null){
                                Decimal CM8 = Eactual.M8_AMOUNT__c;
                                CM8 = CM8.setScale(2, RoundingMode.HALF_EVEN);
                                obCurrentActual.M8__c = CM8;
                            }
                            if(Eactual.M9_AMOUNT__c != null){
                                Decimal CM9 = Eactual.M9_AMOUNT__c;
                                CM9 = CM9.setScale(2, RoundingMode.HALF_EVEN);
                                obCurrentActual.M9__c = CM9;
                            }
                            if(Eactual.M10_AMOUNT__c != null){
                                Decimal CM10 = Eactual.M10_AMOUNT__c;
                                CM10 = CM10.setScale(2, RoundingMode.HALF_EVEN);
                                obCurrentActual.M10__c = CM10;
                            }
                            if(Eactual.M11_AMOUNT__c != null){
                                Decimal CM11 = Eactual.M11_AMOUNT__c;
                                CM11 = CM11.setScale(2, RoundingMode.HALF_EVEN);
                                obCurrentActual.M11__c = CM11;
                            }
                            if(Eactual.M12_AMOUNT__c != null){
                                Decimal CM12 = Eactual.M12_AMOUNT__c;
                                CM12 = CM12.setScale(2, RoundingMode.HALF_EVEN);
                                obCurrentActual.M12__c = CM12;
                            } 
                            if(Eactual.YEARLYTOT_AMOUNT__c  != null){
                                currentYActualTotal =  (Decimal)(Eactual.YEARLYTOT_AMOUNT__c).setScale(2, RoundingMode.HALF_EVEN);                                      
                            }
                            //obCurrentActual.Parent_Forecast__c=f.Id;
                            objcractual.put(String.valueof(f.Id),obCurrentActual);                                             
                        }                              
                    }                
                    if(!fdRec.isEmpty()){                        
                        for(Forecast_Detail__c fd : fdRec){                            
                            if(fd.Parent_Forecast__r.Type__c == 'Portfolio' && fd.Type__c  =='Guidance Forecast'){
                                guidenceFDList.add(fd);
                            }
                            
                            if(fd.Parent_Forecast__r.Type__c == 'Portfolio' && fd.Type__c  =='YoY Variance'){
                                yoyFDList.add(fd);
                            }
                            
                            if(fd.Parent_Forecast__r.Type__c == 'Portfolio' && fd.Type__c  =='Forecast'){
                                forecastFDList.add(fd);
                            }
                        }                      
                        
                        forecastDetailNewList.addAll(guidenceFDList);
                        forecastDetailNewList.addAll(yoyFDList);
                        forecastDetailNewList.addAll(forecastFDList);                        
                        
                        if(!forecastDetailNewList.isEmpty()){                           
                            for(Forecast_Detail__c fd : forecastDetailNewList){                     
                                CLastmodifiedname = fd.LastmodifiedBy.Name;
                                CLastModifiedDate = fd.LastModifiedDate;                                
                               
                                if(fd.Type__c  =='Guidance Forecast'){
                                    if(fd.Period__c == currentYear){
                                        fdTypeGuidance = fd.Type__c;
                                        obCurrentGuidence = fd;
                                        currentGuidanceflg = true;
                                    }if(fd.Period__c == nextYear){
                                        fdTypeGuidance = fd.Type__c;
                                        obNextGuidence = fd;
                                        nextGuidanceflg = true;
                                    }                                
                                }else if(fd.Type__c  == 'YoY Variance'){
                                    if(fd.Period__c == currentYear){
                                        currentyoyflg = true;
                                        fdTypeYoY = fd.Type__c;
                                        obCurrentYoY = fd;
                                        CurrentyrYoYAmountval = fd.Total__c;
                                        if(PYActualTotal > 0){
                                            CurrentyrYoYPercentageval = ((fd.Total__c/PYActualTotal)*100).setScale(2);
                                        }else{
                                            CurrentyrYoYPercentageval = 0;             
                                        }     
                                    }if(fd.Period__c == nextYear){
                                        nextyoyflg = true;
                                        fdTypeYoY = fd.Type__c;
                                        obNextYoY = fd;  
                                        NextyrYoYAmountval = fd.Total__c;
                                        if(currentYActualTotal > 0){
                                            NextyrYoYPercentageval = ((fd.Total__c/currentYActualTotal)*100).setScale(2);
                                        }else{
                                            NextyrYoYPercentageval = 0;                
                                        }               
                                    }                                
                                }else if(fd.Type__c == 'Forecast'){
                                    if(fd.Period__c == currentYear){
                                        currentfdflg = true;        
                                        fdTypeForecast = fd.Type__c;
                                        obCurrent = fd;                            
                                    }if(fd.Period__c == nextYear){
                                        nextfdflg = true;     
                                        fdTypeForecast = fd.Type__c;
                                        obNext = fd;              
                                    }
                                    if(fd.Period__c == pastYear){                                    
                                        obPast = fd;              
                                    }                                
                                }                                                
                            }
                        }
                        
                    }
                    
                    if(currentGuidanceflg == false){
                        fdTypeGuidance = 'Guidance Forecast';
                    }
                    if(nextGuidanceflg == false){
                        fdTypeGuidance = 'Guidance Forecast';
                    }
                    
                    //if the forecast and yoy records are not in database we will be creating them manually below.
                    if(currentfdflg == false)
                    {
                        Forecast_Detail__c fdcrRecord = new Forecast_Detail__c();
                        fdcrRecord.clear();  
                        fdTypeForecast = 'Forecast';
                        fdcrRecord.Parent_Forecast__c=f.id;
                        fdcrRecord.period__C=currentYear;
                        fdcrRecord.Type__c='Forecast';
                        fdcrRecord.CurrencyIsoCode='USD';
                        obCurrent = fdcrRecord;                            
                    }
                    
                    if(nextfdflg == false)
                    {
                        Forecast_Detail__c fdnxtRecord = new Forecast_Detail__c();
                        fdnxtRecord.clear(); 
                        fdTypeForecast = 'Forecast';
                        fdnxtRecord.Parent_Forecast__c=f.id;
                        fdnxtRecord.period__C=nextYear;
                        fdnxtRecord.Type__c='Forecast';
                        fdnxtRecord.CurrencyIsoCode='USD';
                        obNext = fdnxtRecord;                            
                    }
                    if(currentyoyflg == false)
                    {
                        Forecast_Detail__c yoycrRecord = new Forecast_Detail__c();
                        yoycrRecord.clear();                         
                        fdTypeYoY = 'YoY Variance';
                        yoycrRecord.Parent_Forecast__c=f.id;
                        yoycrRecord.period__C=currentYear;
                        yoycrRecord.Type__c='YoY Variance';
                        yoycrRecord.CurrencyIsoCode='USD';
                        obCurrentYoY = yoycrRecord;                            
                    }
                    
                    if(nextyoyflg == false)
                    {
                        Forecast_Detail__c yoynxtRecord = new Forecast_Detail__c();
                        yoynxtRecord.clear();                          
                        fdTypeYoY = 'YoY Variance';
                        yoynxtRecord.Parent_Forecast__c=f.id;
                        yoynxtRecord.period__C=nextYear;
                        yoynxtRecord.Type__c='YoY Variance';
                        yoynxtRecord.CurrencyIsoCode='USD';
                        obNextYoY = yoynxtRecord;                            
                    }                  
                    
                    forecastDetailOldList.add(obCurrent);
                    forecastDetailOldList.add(obNext);
                    forecastDetailOldList.add(obCurrentYoY);
                    forecastDetailOldList.add(obNextYoY);
                    
                    oldRecords.addAll(forecastDetailOldList.deepClone(true,true,true));
                    
                    /*Section for Set MTD Actuals*/                    
                    //Decimal mtdact=(decimal)mtdActual.get(f.External_ID__c+'-'+currentYear+'-'+String.valueOf(currentMonth));
                    Decimal mtdvr=0;
                    Decimal mtdact=0;
                    
                    if(nomonthday>monthmove)
                    {
                        if(mtdActual.get(f.External_ID__c+'-'+currentYear+'-'+String.valueOf(currentMonth)) != null)
                            mtdact=(Decimal)mtdActual.get(f.External_ID__c+'-'+currentYear+'-'+String.valueOf(currentMonth));      
                        
                        
                        if(obCurrent.get('M'+currentMonth+'__c') != null)
                            mtdvr=mtdact-(Decimal)obCurrent.get('M'+currentMonth+'__c');
                        else
                            mtdvr=mtdact;
                    }
                    else
                    {
                        integer lastmonthcnt = currentMonth-1;                                               
                        
                        if(currentMonth == 1)
                        {
                            if(mtdActual.get(f.External_ID__c+'-'+pastYear+'-'+String.valueOf(12)) != null)
                                mtdact=(Decimal)mtdActual.get(f.External_ID__c+'-'+pastYear+'-'+String.valueOf(12)); 
                            
                            if(obPast != null){
                                if(obPast.get('M12__c') != null)
                                    mtdvr=mtdact-(Decimal)obPast.get('M12__c');}
                            else
                                mtdvr=mtdact; 
                        }
                        else
                        {
                            if(mtdActual.get(f.External_ID__c+'-'+currentYear+'-'+String.valueOf(lastmonthcnt)) != null)
                                mtdact=(Decimal)mtdActual.get(f.External_ID__c+'-'+currentYear+'-'+String.valueOf(lastmonthcnt));
                            
                            if(obCurrent.get('M'+lastmonthcnt+'__c') != null)
                                mtdvr=mtdact-(Decimal)obCurrent.get('M'+lastmonthcnt+'__c');
                            else
                                mtdvr=mtdact; 
                        }
                    }                    
                    
                    MTDLine = new MTDWrapper();
                    MTDLine.MTDActual = mtdact;                    
                    MTDLine.MTDVariance = mtdvr;
                    
                    //below code is to fetch ppyActuals && PYActuals                    
                    MTDLine.PYActuals = PYActualTotal;                    
                    MTDLine.PPYActuals = pPastYActualTotal;
                    
                    /*Section for override actual sales for past months*/
                    MonthlyActualSales__x exCurrentActual=extActual.get(f.External_ID__c+'-'+currentYear);                 
                    
                    for(integer j=1; j<currentMonth; j++)
                    {
                        if(exCurrentActual != null)
                        {       
                            integer lastmonthcnt = currentMonth-1;                            
                            
                            if(j == lastmonthcnt)
                            {
                                if(nomonthday>monthmove){
                                    if(exCurrentActual.get('M'+j +'_AMOUNT__c') != Null){   
                                        obCurrent.put('M'+j +'__c',(Decimal)exCurrentActual.get('M'+j +'_AMOUNT__c')); 
                                    }}                            
                            }
                            else
                            {
                                if(exCurrentActual.get('M'+j +'_AMOUNT__c') != Null){
                                    obCurrent.put('M'+j +'__c', (Decimal)exCurrentActual.get('M'+j +'_AMOUNT__c'));                                                   
                                }
                            }
                        }
                        //Added the below code for YOY previous months calculation
                        if(obPastActual != Null && obCurrent != null){
                            if(obPastActual.get('M'+j +'__c') != null && obCurrent.get('M'+j +'__c') != null){                                
                                Decimal monthTotal = (Decimal)obCurrent.get('M'+j +'__c') - (Decimal)obPastActual.get('M'+j +'__c');
                                obCurrentYoY.put('M'+j +'__c',monthTotal);
                            }
                            else if(obPastActual.get('M'+j +'__c') != null && obCurrent.get('M'+j +'__c') == null){
                                obCurrentYoY.put('M'+j +'__c', -(Decimal)obPastActual.get('M'+j +'__c'));
                            }
                            else if(obPastActual.get('M'+j +'__c') == null && obCurrent.get('M'+j +'__c') != null){
                                obCurrentYoY.put('M'+j +'__c', obCurrent.get('M'+j +'__c'));
                            }
                            
                        }
                        else if(obPastActual != Null && obCurrent == null){
                            if(obPastActual.get('M'+j +'__c') != null){
                                obCurrentYoY.put('M'+j +'__c', -(Decimal)obPastActual.get('M'+j +'__c'));
                            }  
                        }
                        else if(obPastActual == Null && obCurrent != null){
                            if(obCurrent.get('M'+j +'__c') != null){
                                obCurrentYoY.put('M'+j +'__c', obCurrent.get('M'+j +'__c'));
                            }  
                        }
                        
                    }            
                    
                    for(integer j=1; j<13; j++){
                        if(obCurrent != null){
                            if(obCurrent.get('M'+j +'__c') != null){
                                obCurrent.put('M'+j +'__c', (decimal)obCurrent.get('M'+j +'__c')/1000);
                            }
                        }
                        if(obNext != null){
                            if(obNext.get('M'+j +'__c') != null){                            
                                obNext.put('M'+j +'__c', (decimal)obNext.get('M'+j +'__c')/1000);
                            }
                        }
                        if(obPastActual != null){
                            if(obPastActual.get('M'+j +'__c') != null){                            
                                obPastActual.put('M'+j +'__c', (decimal)obPastActual.get('M'+j +'__c')/1000);
                            }
                        }
                        if(obCurrentActual != null){
                            if(obCurrentActual.get('M'+j +'__c') != null){                            
                                obCurrentActual.put('M'+j +'__c', (decimal)obCurrentActual.get('M'+j +'__c')/1000);
                            }
                        }
                        if(obCurrentGuidence != null){
                            if(obCurrentGuidence.get('M'+j +'__c') != null){                            
                                obCurrentGuidence.put('M'+j +'__c', (decimal)obCurrentGuidence.get('M'+j +'__c')/1000);
                            }
                        }
                        if(obNextGuidence != null){
                            if(obNextGuidence.get('M'+j +'__c') != null){                            
                                obNextGuidence.put('M'+j +'__c', (decimal)obNextGuidence.get('M'+j +'__c')/1000);
                            }
                        }                    
                        if(obCurrentYoY != null){
                            if(obCurrentYoY.get('M'+j +'__c') != null){                            
                                obCurrentYoY.put('M'+j +'__c', (decimal)obCurrentYoY.get('M'+j +'__c')/1000);
                            }
                        }      
                        if(obNextYoY != null){
                            if(obNextYoY.get('M'+j +'__c') != null){                            
                                obNextYoY.put('M'+j +'__c', (decimal)obNextYoY.get('M'+j +'__c')/1000);
                            }
                        }
                    }            
                    
                    
                    //Below Actual forecastLine wrapper list to display actual FD record
                    actualLine = new List<ActualWrapper>();                    
                    actualLine.clear();                     
                    if(obPastActual != null || obCurrentActual != null){
                        
                        actualLine.add(new ActualWrapper(parentForecast, fdTypeActual, obPastActual, obCurrentActual, CBC2, CBC3, CBC4, Region, District, RegSalesMngr, DistSalesMngr, SalesEng, DistMngr, TEUserID,SoldToCustomerName,WorldWideAccountName,BCountry,BState,BCity,AccountNum));
                    }                    
                    
                    //Below Guidence forecastLine wrapper list to display guidence FD record
                    if(obCurrentGuidence != null || obNextGuidence != null){
                        guidenceLine = new List<GuidenceWrapper>();
                        guidenceLine.clear();
                        guidenceLine.add(new GuidenceWrapper(parentForecast, fdTypeGuidance, obCurrentGuidence, obNextGuidence, CBC2, CBC3, CBC4, Region, District, RegSalesMngr, DistSalesMngr, SalesEng, DistMngr, TEUserID,SoldToCustomerName,WorldWideAccountName,BCountry,BState,BCity,AccountNum));
                    }                    
                    
                    //Below YoY forecastLine wrapper list to display the first row of type forecast (current and next year values)
                    if(obCurrentYoY != null || obNextYoY != null){
                        yoyLine = new List<YOYWrapper>();
                        yoyLine.clear();
                        yoyLine.add(new YOYWrapper(parentForecast, fdTypeYoY, obCurrentYoY, obNextYoY, CBC2, CBC3, CBC4, Region, District, RegSalesMngr, DistSalesMngr, SalesEng, DistMngr, TEUserID,SoldToCustomerName,WorldWideAccountName,BCountry,BState,BCity,AccountNum,CurrentyrYoYPercentageval,NextyrYoYPercentageval,CurrentyrYoYAmountval,NextyrYoYAmountval));
                    }                  
                    viewAllCommentsList = new List<CommentsWrapper>();                  
                    integer countNotes = 0;
                    Comments = '';
                    if(viewAllCommentsList.size()>0){
                        viewAllCommentsList.clear();
                    }
                    if(notes.Size() > 0) {             
                        for(note n: notes) {  
                            if(n.ParentId == f.Id){                            
                                countNotes++;
                                if(countNotes == 1)
                                    Comments = n.Body + ' ' + 'CreatedBy : ' + n.CreatedBy.Name  + ' ' + 'CreatedDate : ' + n.CreatedDate.format();
                                if(countNotes > 5)
                                    break;
                                viewAllCommentsList.add(new CommentsWrapper(n.Body,n.CreatedBy.Name,n.CreatedDate.format()));
                            }
                        }            
                    }  
                    
                    if(parentForecast != null && (obCurrent != null || obNext != null)){
                        forecastLineItems.add(new ForecastWrapper(parentForecast, forecastLineItems.size(), false, fdTypeForecast, obCurrent, obNext, Comments, CLastmodifiedname, CLastModifiedDate, CForecastrecID, CForecastrecName, actualLine, guidenceLine, yoyLine, CBC2, CBC3, CBC4, Region, District, RegSalesMngr, DistSalesMngr, SalesEng, DistMngr, TEUserID, viewAllCommentsList,SoldToCustomerName,WorldWideAccountName,BCountry,BState,BCity,AccountNum,MTDLine));
                        
                    }
                }                         
                
            } 
            editforecastId = null;
            Comment =null;
        }
        catch(Exception e){
            System.debug('errMessage' + ': ' + e.getMessage());
            ErrorLogging.Log(e, 'getforecastPortfolioLineItemRecs', 'getforecastPortfolioLineItemRecs','');            
        }        
    }
    
    
    public PageReference Beginning() { //user clicked beginning
        counter = 0;
        getforecastPortfolioLineItemRecs();
        return null;
    }
    
    public PageReference Previous() { //user clicked previous button
        counter -= list_size;
        getforecastPortfolioLineItemRecs();
        return null;
    }
    
    public PageReference Next() { //user clicked next button
        counter += list_size;
        getforecastPortfolioLineItemRecs();
        return null;
    }
    
    public PageReference End() { //user clicked end
        counter = total_size - math.mod(total_size, list_size);
        getforecastPortfolioLineItemRecs();
        return null;
    }
    
    public Boolean getDisablePrevious() { 
        //this will disable the previous and beginning buttons
        if (counter>0) return false; else return true;
    }
    
    public Boolean getDisableNext() { //this will disable the next and end buttons
        if (counter + list_size < total_size) return false; else return true;
    }
    
    List<Note> notes = new List<Note>();
    public void addComment(){          
        Note noterec = new Note();   
        system.debug('forecastLineItems---> '+forecastLineItems);
        
        system.debug('editforecastId--> '+editforecastId+' comment--> '+Comment);
        if((editforecastId  !='' && editforecastId != null) && (Comment !='' && Comment !=null))  {
            String CurrentUserName;
            try{
                //User CloogedInUsr = [SELECT Id,Name FROM User WHERE Id =: UserInfo.getUserId() LIMIT 1];
                CurrentUserName = UserInfo.getName();                
                noterec = new Note(Title = forecastname, ParentId = editforecastId, Body = Comment);
                
                insert noterec;
               
            }catch(Exception e){
                System.Debug('Exception : '+e.getMessage());                
                ErrorLogging.Log(e, ' ADMForecasting_Controller', 'addComment',forecastname);
                ApexPages.addMessages(e);
            }
            
        }
        
        
        notes = [SELECT Body,Id,OwnerId,ParentId,Title FROM Note WHERE ParentId =: editforecastId ORDER BY CreatedDate DESC OFFSET 5];
        
        if(notes.Size() > 0) {
            // this is going to throw a System.DmlException. if you want to process results, allOrNone must be false
            Database.DeleteResult[] results = database.delete(notes, false);
            for (Database.DeleteResult result : results) {
                system.debug(result.isSuccess());
                system.debug(result.getErrors());
            }
        }  
        //return null;
    }
    
    public class CommentsWrapper{
        public String commentsByUser{get;set;}
        public String createdBy{get;set;}
        public String dateOfComment{get;set;} 
        
        public CommentsWrapper(String commentsByUser, String createdBy, String dateOfComment){
            this.commentsByUser = commentsByUser;
            this.createdBy = createdBy;
            this.dateOfComment = dateOfComment;
        }
    }
    
    public class ForecastWrapper{
        public String latestComment{get;set;}
        public String LastmodifiedByName{get;set;}
        public DateTime LastModifiedDate{get;set;}
        public String ForecastCrecId{get;set;}
        public String ForecastCrecName{get;set;}
        public List<ActualWrapper> relatedFDetailRecords{get;set;}
        public List<GuidenceWrapper> relatedFDetailRecords1{get;set;}
        public List<YoYWrapper> relatedFDetailRecords2{get;set;}        
        public MTDWrapper MTDNewWrapper{get;set;}        
        public Forecast__c forecast{get;set;}
        public String forecastType{get;set;}
        public Forecast_Detail__c FCurrObj{get;set;}
        public Forecast_Detail__c FNextObj{get;set;} 
        public String SoldToCustomerName{get;set;} 
        public String WorldWideAccountName{get;set;}
        public String WordWideAccountNumber{get;set;}  
        public String AccountNum{get;set;}
        public String BCountry{get;set;}
        public String BState{get;set;}
        public String BCity{get;set;}
        public String CBC2{get;set;}
        public String CBC3{get;set;}
        public String CBC4{get;set;}
        public String Region{get;set;}
        public String District{get;set;}
        public String RegSalesMngr{get;set;}
        public String DistSalesMngr{get;set;}
        public String SalesEng{get;set;}
        public String DistMngr{get;set;}
        public String TEUserID{get;set;}        
        public integer rowNo {get;set;}
        public boolean isEdit{get;set;}
        public List<CommentsWrapper> viewAllCommentsLit{get;set;}
        public ForecastWrapper(integer rowNo){
            this.rowNo = rowNo;
        }
        public ForecastWrapper(){}
        public ForecastWrapper(Forecast__c fObj, integer rowNo, Boolean isEdit, String fType, Forecast_Detail__c forecastCurrObj, Forecast_Detail__c forecastNextObj, String lComment,String wLastmodifiedName,DateTime wLastModifiedDate,String wForecastrecID,String wForecastrecName, List<ActualWrapper> FDRecords, List<GuidenceWrapper> FDRecords1, List<YoYWrapper> FDRecords2, String cbc2, String cbc3, String cbc4, String region, String dist, String rsmgnr,String districtsmgnr,String sengineer,String dmngr,String tenid,List<CommentsWrapper> viewAllCommentsLit,String SCustomer,String WCustomer,String BillCountry,String BillState,String BillCity,String accnum,MTDWrapper MtdWrapperObj){
            this.forecast = fObj;
            this.forecastType = fType;
            this.FCurrObj = forecastCurrObj;
            this.FNextObj = forecastNextObj;
            this.latestComment = lComment;
            this.LastmodifiedByName = wLastmodifiedName;
            this.LastModifiedDate = wLastModifiedDate;
            this.ForecastCrecId = wForecastrecID;
            this.ForecastCrecName = wForecastrecName; 
            this.relatedFDetailRecords = FDRecords;
            this.relatedFDetailRecords1 = FDRecords1;
            this.relatedFDetailRecords2 = FDRecords2;            
            this.CBC2 = cbc2;
            this.CBC3 = cbc3;
            this.CBC4 = cbc4;
            this.Region = region;
            this.District = dist;
            this.RegSalesMngr = rsmgnr;
            this.DistSalesMngr = districtsmgnr;
            this.SalesEng = sengineer;
            this.DistMngr = dmngr;
            this.TEUserID = tenid;
            this.rowNo = rowNo;
            this.isEdit = isEdit;
            this.viewAllCommentsLit = viewAllCommentsLit;
            this.SoldToCustomerName = SCustomer;
            this.WorldWideAccountName = WCustomer;
            this.BCountry = BillCountry;
            this.BState = BillState;
            this.BCity = BillCity;
            this.AccountNum = accnum;
            this.MTDNewWrapper = MtdWrapperObj;
        }
    }
    
    public class ActualWrapper{        
        public Forecast__c forecast{get;set;}
        public String forecastType{get;set;}
        public Forecast_Detail__c ACurrObj{get;set;}
        public Forecast_Detail__c ANextObj{get;set;}  
        public String SoldToCustomerName{get;set;} 
        public String WorldWideAccountName{get;set;}
        public String WordWideAccountNumber{get;set;}  
        public String AccountNum{get;set;}
        public String BCountry{get;set;}
        public String BState{get;set;}
        public String BCity{get;set;}      
        public String CBC2{get;set;}
        public String CBC3{get;set;}
        public String CBC4{get;set;}
        public String Region{get;set;}
        public String District{get;set;}
        public String RegSalesMngr{get;set;}
        public String DistSalesMngr{get;set;}
        public String SalesEng{get;set;}
        public String DistMngr{get;set;}
        public String TEUserID{get;set;}
        
        public  ActualWrapper(){}
        public ActualWrapper(Forecast__c fObj,String fType, Forecast_Detail__c actualCurrObj, Forecast_Detail__c actualNextObj, String cbc2, String cbc3, String cbc4, String region, String dist, String rsmgnr,String districtsmgnr,String sengineer,String dmngr,String tenid,String SCustomer,String WCustomer,String BillCountry,String BillState,String BillCity,String accnum){
            this.forecast = fObj;
            this.forecastType = fType;
            this.ACurrObj = actualCurrObj;
            this.ANextObj = actualNextObj;            
            this.CBC2 = cbc2;
            this.CBC3 = cbc3;
            this.CBC4 = cbc4;
            this.Region = region;
            this.District = dist;
            this.RegSalesMngr = rsmgnr;
            this.DistSalesMngr = districtsmgnr;
            this.SalesEng = sengineer;
            this.DistMngr = dmngr;
            this.TEUserID = tenid;
            this.SoldToCustomerName = SCustomer;
            this.WorldWideAccountName = WCustomer;
            this.BCountry = BillCountry;
            this.BState = BillState;
            this.BCity = BillCity;
            this.AccountNum = accnum;
        }
    }
    
    public class GuidenceWrapper{    
        public Forecast__c forecast{get;set;}
        public String forecastType{get;set;}
        public Forecast_Detail__c GCurrObj{get;set;}
        public Forecast_Detail__c GNextObj{get;set;}   
        public String SoldToCustomerName{get;set;} 
        public String WorldWideAccountName{get;set;}
        public String WordWideAccountNumber{get;set;}  
        public String AccountNum{get;set;}
        public String BCountry{get;set;}
        public String BState{get;set;}
        public String BCity{get;set;}     
        public String CBC2{get;set;}
        public String CBC3{get;set;}
        public String CBC4{get;set;}
        public String Region{get;set;}
        public String District{get;set;}
        public String RegSalesMngr{get;set;}
        public String DistSalesMngr{get;set;}
        public String SalesEng{get;set;}
        public String DistMngr{get;set;}
        public String TEUserID{get;set;}
        
        public  GuidenceWrapper(){}
        public GuidenceWrapper(Forecast__c fObj, String fType, Forecast_Detail__c guidenceCurrObj, Forecast_Detail__c guidenceNextObj, String cbc2, String cbc3, String cbc4, String region, String dist, String rsmgnr,String districtsmgnr,String sengineer,String dmngr,String tenid,String SCustomer,String WCustomer,String BillCountry,String BillState,String BillCity,String accnum){
            this.forecast = fObj;
            this.forecastType = fType;
            this.GCurrObj = guidenceCurrObj;
            this.GNextObj = guidenceNextObj;           
            this.CBC2 = cbc2;
            this.CBC3 = cbc3;
            this.CBC4 = cbc4;
            this.Region = region;
            this.District = dist;
            this.RegSalesMngr = rsmgnr;
            this.DistSalesMngr = districtsmgnr;
            this.SalesEng = sengineer;
            this.DistMngr = dmngr;
            this.TEUserID = tenid;
            this.SoldToCustomerName = SCustomer;
            this.WorldWideAccountName = WCustomer;
            this.BCountry = BillCountry;
            this.BState = BillState;
            this.BCity = BillCity;
            this.AccountNum = accnum;
        }
    }
    
    public class YOYWrapper{        
        public Forecast__c forecast{get;set;}
        public String forecastType{get;set;}
        public Forecast_Detail__c YoYCurrObj{get;set;}
        public Forecast_Detail__c YoYNextObj{get;set;}
        public String SoldToCustomerName{get;set;} 
        public String WorldWideAccountName{get;set;}
        public String WordWideAccountNumber{get;set;}  
        public String AccountNum{get;set;}
        public String BCountry{get;set;}
        public String BState{get;set;}
        public String BCity{get;set;}        
        public String CBC2{get;set;}
        public String CBC3{get;set;}
        public String CBC4{get;set;}
        public String Region{get;set;}
        public String District{get;set;}
        public String RegSalesMngr{get;set;}
        public String DistSalesMngr{get;set;}
        public String SalesEng{get;set;}
        public String DistMngr{get;set;}
        public String TEUserID{get;set;}
        public Decimal CurrentyrYoYPercentage{get;set;}
        public Decimal NextyrYoYPercentage{get;set;}
        public Decimal CurrentyrYoYAmount{get;set;}
        public Decimal NextyrYoYAmount{get;set;}
        
        public  YOYWrapper(){}
        public YOYWrapper(Forecast__c fObj, String fType, Forecast_Detail__c yoyCurrentObj, Forecast_Detail__c yoyNextObj, String cbc2, String cbc3, String cbc4, String region, String dist, String rsmgnr,String districtsmgnr,String sengineer,String dmngr,String tenid,String SCustomer,String WCustomer,String BillCountry,String BillState,String BillCity,String accnum,Decimal CurrenyrYoYPercent,Decimal NextyrYoYPercent,Decimal CrtYrYTDAmt,Decimal NxtYrYTDAmt){
            this.forecast = fObj;
            this.forecastType = fType;
            this.YoYCurrObj = yoyCurrentObj;
            this.YoYNextObj = yoyNextObj;             
            this.CBC2 = cbc2;
            this.CBC3 = cbc3;
            this.CBC4 = cbc4;
            this.Region = region;
            this.District = dist;
            this.RegSalesMngr = rsmgnr;
            this.DistSalesMngr = districtsmgnr;
            this.SalesEng = sengineer;
            this.DistMngr = dmngr;
            this.TEUserID = tenid;
            this.SoldToCustomerName = SCustomer;
            this.WorldWideAccountName = WCustomer;
            this.BCountry = BillCountry;
            this.BState = BillState;
            this.BCity = BillCity;
            this.AccountNum = accnum;
            this.CurrentyrYoYPercentage = CurrenyrYoYPercent;
            this.NextyrYoYPercentage = NextyrYoYPercent;
            this.CurrentyrYoYAmount = CrtYrYTDAmt;
            this.NextyrYoYAmount = NxtYrYTDAmt;
        }
    } 
    public class MTDWrapper{
        public Decimal MTDActual{get;set;}
        public Decimal MTDVariance{get;set;}
        public Decimal PYActuals{get;set;}
        public Decimal PPYActuals{get;set;}              
        public MTDWrapper(){}        
    }
}