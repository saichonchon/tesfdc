public class HVCAPartSelectorExtension {
    
    public HVCA_Part_Selector__c hvca{get;set;}
    public String terminationOutput{get;set;}
    public Boolean isShowInputSecion{get;set;}
    public String spliceOutput{get;set;}
    public String GISOutput{get;set;}
    public Boolean isShowSpliceAdditionSection{get;set;}
    public List<String> documentLinks{get;set;}
    public Boolean isError{get;set;}
    public Part_Selector_Document_Table__c docTable{get;set;}
    public Part_Selector_Document_Table__c spliceDocTable{get;set;}
    public Part_Selector_Document_Table__c gisDocTable{get;set;}
    public Decimal outerJacketOD {get;set;}
    public Part_Selector_Output_Price_Table__c spliceOutputPriceTable1{get;set;}
    public Part_Selector_Output_Price_Table__c terminationOutputPriceTable1{get;set;}
    public OutputPriceWrapper spliceOutputPriceTable{get;set;}
    public OutputPriceWrapper terminationOutputPriceTable{get;set;}
    public List<Part_Selector_Plastic_Clamps__c> plasticCamps{get;set;}
    public List<PlasticCampWrapper> listOfPlasticCamps{get;set;}
    public Boolean isNemaPad{get;set;}
    public Boolean isBasePlater{get;set;}
    public Boolean isCableStrippingTool{get;set;}
    public Boolean isHeatingBlanket{get;set;}
    
    public Boolean isShowTransitionSection {get;set;}
    
    public pageReference getPlasticCamps(){ 
        plasticCamps = new List<Part_Selector_Plastic_Clamps__c>();
        listOfPlasticCamps = new List<PlasticCampWrapper>();
        System.debug('**outerJacketOD**'+outerJacketOD);
        String OD = ApexPages.currentPage().getParameters().get('outerJacketOD') ;
        System.debug('**outerJacketOD**'+outerJacketOD);
        if(outerJacketOD ==null)
            outerJacketOD = OD !=null ? Decimal.valueOf(OD) : hvca.Outer_Jacket_OD__c !=null ? hvca.Outer_Jacket_OD__c : 0  ;
        if(outerJacketOD !=null && outerJacketOD !=0 ){
            System.debug('***outerJacketOD**'+outerJacketOD);
            for(Part_Selector_Plastic_Clamps__c locPlasticCamp : [Select id,AUTHORIZED_DISTRIBUTOR__c,Cable_End_Range__c,Cable_Start_Range__c,CATALOG_NUMBER__c,ELITE_DISTRIBUTOR__c,Mounting_Version__c,TRADE__c  from Part_Selector_Plastic_Clamps__c
                                                                         Where  Cable_Start_Range__c <=: outerJacketOD  AND  Cable_End_Range__c >: outerJacketOD]){
                                                                             plasticCamps.add(locPlasticCamp);
                                                                             PlasticCampWrapper pcw = new PlasticCampWrapper();
                                                                             pcw.plasticCamp = locPlasticCamp;
                                                                             pcw.isInclude = false;
                                                                             listOfPlasticCamps.add(pcw);
            }
        }
        if(hvca.isFlatMount__c || hvca.isStrutNut__c || hvca.isSliderPlate__c || hvca.isFMCompressionString__c){
            isShowCableClamp = true;
            plasticCampPdfTable = prepareClampPdfMap(listOfPlasticCamps);
        }
        
        return null;
    }
    
   public String spliceEppaName{
        get{
            if(hvca.Conductor_OD__c !=null && hvca.Insulation_OD__c !=null){
                spliceEppaName = '-'+Math.ceil(hvca.Conductor_OD__c)  + '/'+  Math.ceil(hvca.Insulation_OD__c);
            }
            if(hvca.Splice_Conductor_OD__c !=null && hvca.Splice_Insulation_OD__c !=null ){
                spliceEppaName += '-'+Math.ceil(hvca.Splice_Conductor_OD__c)  + '/'+  Math.ceil(hvca.Splice_Insulation_OD__c);
            }
            hvca.Connectors_EPPA_047__c = spliceEppaName!=null ? spliceEppaName.removeStart('-') : '';
            return spliceEppaName;
           }set;
        
    }   
    
    public String eppaName{
        get{
            if(hvca.Conductor_OD__c !=null && hvca.Insulation_OD__c !=null){
                eppaName = '-'+Math.ceil(hvca.Conductor_OD__c)  + '/'+  Math.ceil(hvca.Insulation_OD__c);
            }
            hvca.Connectors_EPPA_054__c = eppaName!=null ?  eppaName.removeStart('-') : '';
            return eppaName;
           }set;
        
    }   
    public Boolean isShowEppa{
        get{
            if(hvca.Termination_Operating_Voltage__c == '46' || hvca.Termination_Operating_Voltage__c == '69' )isShowEppa = true;
            return isShowEppa;
        }
        set;
    }
    public Boolean isShowSpliceEppa{
        get{
            if(hvca.Splice_Operating_Voltage__c == '46' || hvca.Splice_Operating_Voltage__c == '69' )isShowEppa = true;
            return isShowEppa;
        }
        set;
    }
    Boolean isConstructer = false;
    public HVCAPartSelectorExtension(ApexPages.StandardController stdController) {  
        System.debug('constructore called***');
        List<String> fields = new List<String> {'Termination_Output__c','Opportunity__r.Id','Splice_Output__c','GIS_Output__c','OwnerId','isAccessoriessChecked__c','isGISChecked__c','isSpliceChecked__c','isTerminationChecked__c'};
            if(!Test.isRunningTest())
            stdController.addFields(fields);
        System.debug('***parameter**'+ApexPages.currentPage().getParameters().get('hvcaId'));
        if(ApexPages.currentPage().getParameters().get('hvcaId')!=null){
            this.hvca = [SELECT  Additional_Comment__c,Additional_Layer__c,Additional_Shield_Comment__c,Additional_Shield_Layer__c,Application__c,
                         Approval_Status__c,Armour__c,Cable_Lug__c,Cable_Manufacturer__c,Comment__c,Conductor_material__c,Conductor_OD__c,Conductor_Section__c,
                         Conductor_Type__c,ConnectionReceivedId,Creepage_distance__c,Dry_Oil_Field__c,
                         GIS_Approved_Price__c,GIS_Basic_Impulse_Level__c,GIS_Design__c,GIS_Final_Approved_Price__c,GIS_List_Price__c,GIS_Offered_Price__c,
                         GIS_Operating_Voltage__c,GIS_Output__c,GIS_Proposed_Price_Comment__c,GIS_Quantity__c,GIS_Short_Circuit_Current_Conductor__c,
                         GIS_Short_Circuit_Current_Shield__c,Housing_Length__c,HVCA_Link__c,Id,Inlet__c,Installation_Angle__c,Installation_Type__c,
                         Insulation_Comment__c,Insulation_Material__c,Insulation_OD__c,Insulation_Thickness__c,Insulator_Type__c,isAccessoriessChecked__c,
                         isAuthorizedDistributor__c,isBasePlateAdapterSelecter__c,isCableStrippingToolSelected__c,IsDeleted,isEliteDistributor__c,
                         isFlatMount__c,isFMCompressionString__c,isGISChecked__c,isGIS_preQuote__c,isHeatingBlanketSelected__c,isNemaPadSelected__c,
                         isSliderPlate__c,isSpliceChecked__c,isSplice_preQuote__c,isStrutNut__c,isTerminationChecked__c,isTermination_preQuote__c,
                         isTradeColoumn__c,LastActivityDate,LastModifiedById,LastModifiedDate,LastReferencedDate,LastViewedDate,Name,Offered_Price__c,
                         Opportunity__c,Outer_Jacket_Comment__c,Outer_Jacket_Material__c,Outer_Jacket_OD__c,Outer_Jacket_Thickness__c,OwnerId,Owner_Name__c,
                         Shielding_Comment__c,Shielding_Thickness__c,Shielding_Type__c,Splice_Approved_Price__c,Splice_Basic_Impulse_Level__c,
                         Splice_Conductor_OD__c,Splice_Design__c,Splice_Final_Approved_Price__c,Splice_Installation_Type__c,Splice_Insulation_OD__c,
                         Splice_List_Price__c,Splice_Offered_Price__c,Splice_Operating_Voltage__c,Splice_Outer_Protection__c,Splice_Output__c,
                         Splice_Proposed_Price_Comment__c,Splice_Quantity__c,Splice_Shielding_Type__c,Splice_Shield_Continuity__c,
                         Splice_Short_Circuit_Current_Conductor__c,Splice_Short_Circuit_Current_Shield__c,Splice_Size_Transition__c,
                         Splice_Type__c,Termination_Approved_Price__c,Termination_Basic_Impulse_Level__c,Termination_Final_Approved_Price__c,
                         Termination_List_Price__c,Termination_Offered_Price__c,Termination_Operating_Voltage__c,Termination_Output__c,
                         Connectors_EPPA_047__c, Connectors_EPPA_054__c, EPPA_RPN_047__c, EPPA_RPN_054__c,
                         Termination_Proposed_Price_Comment__c,Termination_Quantity__c,Termination_Short_Circuit_Current_Shield__c,Splice_Additional_Quantity__c,
                         TerminatiShort_Circuit_Current_Conductor__c,IS_TREFOIL_CABLE_CLAMPS_SLIDER_PLATE__c,IS_TREFOIL_CABLE_CLAMPS_STRUT_NUT__c, Wire_Spec__c FROM HVCA_Part_Selector__c 
                         where id =:ApexPages.currentPage().getParameters().get('hvcaId') ];
        }else{
            this.hvca = (HVCA_Part_Selector__c)stdController.getRecord(); 
        }
        
        System.debug('hvca**'+this.hvca );
      
        if(ApexPages.currentPage().getParameters().get('oppId') != null)
            this.hvca.Opportunity__c = ApexPages.currentPage().getParameters().get('oppId') ;
        
        System.debug('hvca**'+this.hvca.isTerminationChecked__c );
        isShowInputSecion = true;
        isShowSpliceAdditionSection = false;
        System.debug('***hvca.Splice_Size_Transition__c **'+hvca.Splice_Size_Transition__c );
        if(hvca.Splice_Size_Transition__c == 'Yes'){
            isShowSpliceAdditionSection = true;
        }
        isError = false;
        System.debug('hvca**'+this.hvca.isTerminationChecked__c );
        docTable = new Part_Selector_Document_Table__c();
        spliceDocTable = new Part_Selector_Document_Table__c();
        gisDocTable = new Part_Selector_Document_Table__c();
        System.debug('hvca**'+this.hvca.isTerminationChecked__c );
        if(this.hvca.Id!=null){
            isConstructer = true;
            save();
        }  
       
    }
    
    
    
    public List<Attachment> attachments{get{
        attachments = new List<Attachment>();
        if(this.hvca.Id!=null){            
            for(Attachment attach : [Select id,parentId, body,name, description from Attachment where parentId =: this.hvca.Id]){
                attachments.add(attach);
            }
        }
        return attachments;
    }set;}
    
    public pagereference fetchConductorOd(){
         hvca.Conductor_OD__c = prepareConductorOD(hvca.Conductor_Type__c,hvca.Conductor_Section__c);
        return null;
    }
    
     public pagereference fetchSpliceConductorOd(){
         hvca.Splice_Conductor_OD__c = prepareConductorOD(hvca.Splice_Conductor_Type__c,hvca.Splice_Conductor_Section__c);
        return null;
    }
    
    private Decimal prepareConductorOD(String conductorType, String conductorSection ){
        System.debug('called'+conductorType+conductorSection);
        Decimal conductorOD;
        if(conductorType !=null){
            Part_Selector_Conductor_OD__c conductorOdObj = Part_Selector_Conductor_OD__c.getInstance(conductorSection);
            if(conductorOdObj!=null){           
                if(conductorType=='Compact Diameter'){
                    conductorOD = conductorOdObj.Compact_Diameter__c;
                }else if(conductorType =='Compressed Diameter'){
                    conductorOD = conductorOdObj.Compressed_Diameter__c;
                }else if(conductorType== 'Concentric Diameter'){
                    conductorOD = conductorOdObj.Concentric_Diameter__c;
                }
                if(conductorOD !=null)
                    conductorOD = conductorOD /0.039370;                
            }
        }
        System.debug('conductorOD'+conductorOD);
        return conductorOD;
    }
    
    private final String UNDERSCORE = ' - ';
    private final  String SPACE = ' ';
    
    public String buildErrorMessage(List<String> fieldsToCheck){
        Boolean isError = false;
        String errorMessage ;
        for(String fieldName : fieldsToCheck){
            if(hvca.get(fieldName) == null){
                if(!isError) {
                    isError = true;
                    errorMessage = 'Enter ->  ';
                }
                errorMessage += fieldName.removeEnd('__c').replaceAll('_', ' ')+ ', ';                
            }
        }
        if(isError){            
            this.isShowInputSecion = true;
            this.isError = true;
        }
        return errorMessage;
    }
    
    public Map<String,List<Part_Selector_Insulation_OD__c>> preparePartSelectorInsulationOdMap(){
        Map<String,List<Part_Selector_Insulation_OD__c>> partSelectorTypeMap= new Map<String,List<Part_Selector_Insulation_OD__c>>();
        List<Part_Selector_Insulation_OD__c> insulationSettingValues = Part_Selector_Insulation_OD__c.getall().values();
        for(Part_Selector_Insulation_OD__c partSelector : insulationSettingValues){
            if(partSelectorTypeMap.containsKey(partSelector.Type__c)){
                partSelectorTypeMap.get(partSelector.Type__c).add(partSelector);
            }else{
                partSelectorTypeMap.put(partSelector.Type__c, new List<Part_Selector_Insulation_OD__c>{partSelector});
            }
        }
        return partSelectorTypeMap;
    }
    
    public pagereference save(){
        System.debug('**called**8');
        isShowInputSecion = false;
        isError = false;
        OutputWrapper output = new OutputWrapper();
        output.priceMap = new Map<String,OutputPriceWrapper>();
        String errorMessage = buildErrorMessage(new List<String>{'Conductor_Material__c','Insulation_Material__c','Shielding_Type__c','Conductor_OD__c','Insulation_OD__c','Outer_Jacket_OD__c'});
        // ------------------------------Show Error Message if any of required field is missing---------------------------------------------//
        if(errorMessage!=null){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,errorMessage));
            return null;
        }           
        Map<String,List<Part_Selector_Insulation_OD__c>> partSelectorTypeMap = preparePartSelectorInsulationOdMap();
        // ------------------------------Design Termination Output---------------------------------------------//
         System.debug('**hvca.isTerminationChecked__c**'+hvca.isTerminationChecked__c);
        if(hvca.isTerminationChecked__c){
            errorMessage = buildErrorMessage(new List<String>{'Installation_Type__c','Termination_Operating_Voltage__c'});
            System.debug('**errorMessage**'+errorMessage);
            if(errorMessage!=null ){//show Error Message if any of required field for termination heat shrink is missing
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,errorMessage));
                return null;               
            }   
            if(hvca.Installation_Type__c == 'Cold Applied'){             
                errorMessage = buildErrorMessage(new List<String>{'Insulator_Type__c','Cable_Lug__c','Creepage_distance__c'});
                if(errorMessage!=null ){//show Error Message if any of required field for termination cold applied is missing
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,errorMessage));
                    return null;               
                }           
                terminationOutput = terminationOHVTOutput(output);
                output.terminationOutput = terminationOutput;
            }else if(hvca.Installation_Type__c == 'Heat Shrink'){
                isShowEppa = true;
                errorMessage = buildErrorMessage(new List<String>{'Conductor_OD__c','Application__c'});
                if(errorMessage!=null ){//show Error Message if any of required field for termination heat shrink is missing
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,errorMessage));
                    return null;               
                }                 
                terminationOutput = terminationEHVTOutput();          
                System.debug('***terminationOutput***'+terminationOutput);
                if(String.isBlank(terminationOutput) || terminationOutput==null) {
                    terminationOutput = 'No Output with selected  combination. For further assitance please contact TE.';
                    hvca.Termination_Output__c = 'No Output';
                }
                else               
                    terminationEHVTDcouments(output);            
                output.terminationOutput = terminationOutput;
            }
        }
        // ------------------------------Design Splice Output---------------------------------------------//  
        if(hvca.isSpliceChecked__c){
            errorMessage = buildErrorMessage(new List<String>{'Splice_Installation_Type__c','Splice_Operating_Voltage__c'});
            if(errorMessage!=null ){//show Error Message if any of required field for termination cold applied is missing
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,errorMessage));
                return null;               
            }           
            if(hvca.Splice_Installation_Type__c == 'Cold Applied'){ 
                errorMessage = buildErrorMessage(new List<String>{'Splice_Design__c','Splice_Type__c','Splice_Size_Transition__c','Splice_Outer_Protection__c'});
                if(errorMessage!=null ){
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,errorMessage));
                    return null;               
                }  
                output.spliceOutput = spliceEHVSOutput(output,partSelectorTypeMap);
            }else if((hvca.Splice_Installation_Type__c == 'Heat Shrink')){
                if(hvca.Conductor_OD__c!=null){                
                    spliceOutput = spliceHeatShrinkOutput();
                    if(String.isBlank(spliceOutput) || spliceOutput ==null) 
                        spliceOutput = 'No Output with selected  combination. For further assitance please contact TE.';
                    else if(!spliceOutput.contains( 'Please contact'))                  
                        spliceHeatShrinkDocumentTable(output);  
                }
                output.spliceOutput = spliceOutput;
            }
        }
        // ------------------------------Design GIS Output---------------------------------------------//  
        if(hvca.isGISChecked__c){ 
            errorMessage = buildErrorMessage(new List<String>{'GIS_Design__c','Dry_Oil_Field__c','Housing_Length__c'});
            if(errorMessage!=null ){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,errorMessage));
                return null;               
            } 
            gisOutput =  gisColdAppliedOutput();
            output.gisOutput = gisOutput;
            fetchGISDocuments(output);
        }
        if(!String.isBlank(GISOutput)) hvca.GIS_Output__c = GISOutput;
        if(!isConstructer){
            if(hvca.Id ==null)hvca.isShowOffer__c = true;
            upsert hvca;
            //emailOutputService(output,hvca);
        }
        if(hvca.Id ==null){
            insert hvca;
        }
        // ------------------------------Upsert HVCA and send mail to owner ---------------------------------------------//  
        System.debug('attachments **' +attachments);
                getPlasticCamps(); 
        //if(!UserInfo.getUserId().contains('00516000006WbAC'))
        
        return null;
    }
    
    public void fetchGISDocuments(OutputWrapper output){
        String docName = 'PHVX-'+hvca.GIS_Operating_Voltage__c;
        System.debug('***docName*table**'+docName);
        Part_Selector_Document_Table__c documentTable  = Part_Selector_Document_Table__c.getInstance(docName);
        if(documentTable!=null){
            if(documentTable.Offer_Drawing__c!=null)
                documentLinks = documentTable.Offer_Drawing__c.split(',');
            gisDocTable = documentTable;
            hvca.GIS_List_Price__c = documentTable.Pricing__c;
            output.documentMap = new  Map<String,Part_Selector_Document_Table__c>();
            output.documentMap.put('Splice',documentTable);
        }
    }
    
    public void spliceHeatShrinkDocumentTable(OutputWrapper output){
        spliceoutputPriceTable = new outputPriceWrapper();
        hvca.Splice_Output__c = spliceOutput;
        String spliceDesign ;
        spliceDesign =  (PartSelectorOutput__c.getInstance(hvca.Splice_Design__c) !=null) ? (PartSelectorOutput__c.getInstance(hvca.Splice_Design__c).Output__c+SPACE) : (hvca.Splice_Design__c +SPACE);
            
        String docName = 'EHVS-';//+hvca.Splice_Operating_Voltage__c + 'xx-W';//+spliceDesign.trim();
        if(hvca.Splice_Type__c == 'Inline') docName +='Inline';
        else docName += 'SB';
        System.debug('***docName* table**'+docName);
        if(docName!=null){
            Part_Selector_Document_Table__c documentTable =  Part_Selector_Document_Table__c.getInstance(docName);
            if(documentTable!=null && documentTable.Offer_Drawing__c!=null)
                documentLinks = documentTable.Offer_Drawing__c.split(',');
            spliceDocTable = documentTable;
            System.debug('**documentTable**'+documentTable);
            output.documentMap = new  Map<String,Part_Selector_Document_Table__c>();
            output.documentMap.put('Splice',documentTable);
        }
        System.debug('***spliceOutput***'+spliceOutput);
        if(spliceOutput!=null && spliceOutput.length()<15)
            spliceoutputPriceTable.priceOutput = Part_Selector_Output_Price_Table__c.getInstance(spliceOutput.removeEnd('-SB'));
        output.priceMap.put('Splice',spliceoutputPriceTable);
    }
    
    public void terminationEHVTDcouments(OutputWrapper output){
        terminationOutputPriceTable = new outputPriceWrapper();
        hvca.Termination_Output__c     = terminationOutput;
        String docName = 'EHVT-'+hvca.Application__c;
        System.debug('**docName table**'+docName);
        Part_Selector_Document_Table__c documentTable  = Part_Selector_Document_Table__c.getInstance(docName);
        if(documentTable!=null){
            if(documentTable.Offer_Drawing__c!=null)
                documentLinks = documentTable.Offer_Drawing__c.split(',');
            docTable = documentTable;
            //hvca.Termination_List_Price__c = docTable.Pricing__c;
            output.documentMap = new  Map<String,Part_Selector_Document_Table__c>();
            output.documentMap.put('Termination',documentTable);
        }
        System.debug('***terminationOutput**'+terminationOutput);
        if(terminationOutput!=null && terminationOutput.length()<15)
        terminationOutputPriceTable.priceOutput = Part_Selector_Output_Price_Table__c.getInstance(terminationOutput);
        output.priceMap.put('Termination',terminationOutputPriceTable);
    }
    
    /**
     * Prepare GIS output for cold applied 72,145,170 volatges
     * @return gisoutput
     * */    
    public String gisColdAppliedOutput(){
        String GISOutput = 'PHVX'+SPACE+ hvca.GIS_Operating_Voltage__c + SPACE;
        GISOutput +=  (PartSelectorOutput__c.getInstance(hvca.Insulation_Material__c) !=null) ? (PartSelectorOutput__c.getInstance(hvca.Insulation_Material__c).Output__c.removeEnd('_')+SPACE) : (hvca.Insulation_Material__c +SPACE);
            GISOutput +=  (PartSelectorOutput__c.getInstance(hvca.Shielding_Type__c) !=null) ? (PartSelectorOutput__c.getInstance(hvca.Shielding_Type__c).Output__c+SPACE) : (hvca.Shielding_Type__c+SPACE );
                if(hvca.Conductor_OD__c!=null){
                    Decimal conductorOD = hvca.Conductor_OD__c;                        
                    conductorOD = Math.ceil(conductorOD);
                    GISOutput +=  conductorOD +SPACE;
                }
        if(hvca.Insulation_OD__c!=null){
            String insulationString = '';
            for(Part_Selector_46_69_Output__c partSelector : [Select output__c from Part_Selector_46_69_Output__c 
                                                              where Start_Range__c <=: hvca.Insulation_OD__c AND End_Range__c >=: hvca.Insulation_OD__c 
                                                              AND Type__c = 'GIS_InsulationOD' order by Start_Range__c] ){
                                                                  GISOutput +=   partSelector.output__c;            
                                                                  break;
                                                              }
            GISOutput +=  insulationString != null ?  insulationString + UNDERSCORE : '';
        }
        if(hvca.Outer_Jacket_OD__c<=90)
            GISOutput += 'A' + Space;
        else if(hvca.Outer_Jacket_OD__c > 90 && hvca.Outer_Jacket_OD__c <= 110)
            GISOutput += 'B' + Space;   
        return GISOutput;
    }
    public String eppaOutput{get;set;}
    /**
     * Prepare Splice output for cold applied 46, 69 volatges
     * @return cplieOutput
     * */ 
    public String spliceHeatShrinkOutput(){
        String spliceOutput ;
        String conductorSection ='';
        if(hvca.Conductor_Section__c!=null && hvca.Conductor_Section__c.contains('/')){
            conductorSection = hvca.Conductor_Section__c.split('/')[0];
        }else{
            conductorSection = hvca.Conductor_Section__c;
        }
        Integer range = 0;
        if(conductorSection!=null)
        range = Integer.valueof(conductorSection);
        String query = 'Select id, Appliccation_Type__c, Start_Range__c, End_Range__c, Output__c, Voltage__c, Type__c from Part_Selector_46_69_Output__c '
            +'where Voltage__c=\''+hvca.Splice_Operating_Voltage__c+'\' AND Type__c=\'Splice\' AND Appliccation_Type__c='+hvca.Splice_Type__c 
            +'AND Insulation_OD_Start_Range__c<='+ hvca.Insulation_OD__c+' AND Insulation_OD_End_Range__c >='+hvca.Insulation_OD__c
            +'AND Max_Jacket_OD__c <'+ hvca.Outer_Jacket_OD__c +' AND Max_Jacket_OD__c >='+ hvca.Outer_Jacket_OD__c
            +'AND Start_Range__c <='+ range +'AND End_Range__c >='+ range ;
        System.debug('query'+query);
        
        for(Part_Selector_46_69_Output__c part : [Select id, Appliccation_Type__c, Start_Range__c, End_Range__c, Output__c, Voltage__c, Type__c from Part_Selector_46_69_Output__c 
                                                  where Voltage__c=:hvca.Splice_Operating_Voltage__c AND Type__c='Splice' AND Appliccation_Type__c =: hvca.Splice_Type__c
                                                  AND Insulation_OD_Start_Range__c<=: hvca.Insulation_OD__c AND Insulation_OD_End_Range__c >=:hvca.Insulation_OD__c
                                                  AND Max_Jacket_OD__c <: hvca.Outer_Jacket_OD__c AND Max_Jacket_OD_End_Range_c__c >=: hvca.Outer_Jacket_OD__c
                                                  AND Start_Range__c <=: range AND End_Range__c >=: range]){
                                                      System.debug('**part***'+part);
                                                      spliceOutput = part.Output__c;
                                                  }
        String transition_output ;
        if(hvca.Splice_Size_Transition__c == 'Yes'){
            String spliceConductorSection ='0';
            if(hvca.Splice_Conductor_Section__c!=null && hvca.Splice_Conductor_Section__c.contains('/')){
                spliceConductorSection = hvca.Splice_Conductor_Section__c.split('/')[0];
            }else{
                spliceConductorSection = hvca.Splice_Conductor_Section__c;
            }
            Integer conductoreRange =0;
            if(spliceConductorSection!=null)
            conductoreRange = Integer.valueof(spliceConductorSection);
            String queryAdd = 'Select id, Appliccation_Type__c, Start_Range__c, End_Range__c, Output__c, Voltage__c, Type__c from Part_Selector_46_69_Output__c '
                +'where Voltage__c=\''+hvca.Splice_Operating_Voltage__c+'\' AND Type__c=\'Splice\' AND Appliccation_Type__c='+hvca.Splice_Type__c 
                +'AND Insulation_OD_Start_Range__c<='+ hvca.Splice_Insulation_OD__c+' AND Insulation_OD_End_Range__c >='+hvca.Splice_Insulation_OD__c
                +'AND Max_Jacket_OD__c <'+ hvca.Splice_Outer_Jacket_OD__c +' AND Max_Jacket_OD__c >='+ hvca.Splice_Outer_Jacket_OD__c
                +'AND Start_Range__c <='+ conductoreRange +'AND End_Range__c >='+ conductoreRange ;
            System.debug('query add ** '+queryAdd);
            //System.debug('**conductoreRange**'+conductoreRange + '** outer jacket od **'+ hvca.Splice_Outer_Jacket_OD__c +'*insulation od**'+ca.Splice_Insulation_OD__c);
            for(Part_Selector_46_69_Output__c part : [Select id, Appliccation_Type__c, Start_Range__c, End_Range__c, Output__c, Voltage__c, Type__c from Part_Selector_46_69_Output__c 
                                                      where Voltage__c=:hvca.Splice_Operating_Voltage__c AND Type__c='Splice' AND Appliccation_Type__c =: hvca.Splice_Type__c
                                                      AND Insulation_OD_Start_Range__c<=: hvca.Splice_Insulation_OD__c AND Insulation_OD_End_Range__c >=:hvca.Splice_Insulation_OD__c
                                                      AND Max_Jacket_OD__c <: hvca.Splice_Outer_Jacket_OD__c AND Max_Jacket_OD_End_Range_c__c >=: hvca.Splice_Outer_Jacket_OD__c
                                                      AND Start_Range__c <=: conductoreRange AND End_Range__c >=: conductoreRange]){
                                                          System.debug('**part***'+part);
                                                          transition_output = part.Output__c;
                                                      }
        }
        String whereCondition ;
        if(hvca.Insulation_OD__c !=null && hvca.Conductor_OD__c!=null ){
            whereCondition = ' Insulation_OD__c = '+Math.ceil(hvca.Insulation_OD__c) + ' AND Connductor_OD__c = '+Math.ceil(hvca.Conductor_OD__c);
        }
        if(whereCondition!=null && transition_output !=null && String.isNotBlank(transition_output)){
            whereCondition += ' AND Insulation_OD_2__c = '+Math.ceil(hvca.Insulation_OD__c )+ ' AND Connductor_OD_2__c = '+Math.ceil(hvca.Conductor_OD__c);
        }        
        String eppaQuery = 'Select id, Connductor_OD__c, Connductor_OD_2__c,Insulation_OD__c,Insulation_OD_2__c,RPN__c from EPPA_Configuration__c ';
        if(whereCondition!=null){
            whereCondition += ' AND  Connector_Type__c = \'EPPA-047\'';
            eppaQuery += ' where '+whereCondition;
            for(EPPA_Configuration__c eppa : Database.query(eppaQuery)){
                eppaOutput = eppa.RPN__c;
                hvca.EPPA_RPN_047__c = eppaOutput;
            }
        }
        System.debug('eppaQuery'+ eppaQuery);        
        
        
        if(spliceOutput==null || (transition_output!=null && transition_output != spliceOutput)){
            spliceOutput = 'Please contact the PM for offerings to this cable combinations';
        }
        return spliceOutput;
    }
    
    /**
     * Prepare Splice output for cold applied 145, 170 volatgeS
     * @return cplieOutput
     * */ 
    public String spliceEHVSOutput(OutputWrapper output,Map<String,List<Part_Selector_Insulation_OD__c>> partSelectorTypeMap){
        if(hvca.Insulation_OD__c >= 84 && hvca.Splice_Operating_Voltage__c == '145')
        {
            spliceOutput = 'EHVS '+UNDERSCORE+ '170' +SPACE;
             System.debug('>>>>>spliceOutput@ifcndion'+ spliceOutput);
        }
        else 
            spliceOutput = 'EHVS '+UNDERSCORE+ hvca.Splice_Operating_Voltage__c+SPACE;
             System.debug('>>>>>spliceOutput1@ifcndion'+ spliceOutput);
        String volatge = spliceOutput.contains('170') ? '170': hvca.Splice_Operating_Voltage__c;
        String spliceDesign ;
        spliceDesign =  (PartSelectorOutput__c.getInstance(hvca.Splice_Design__c) !=null) ? (PartSelectorOutput__c.getInstance(hvca.Splice_Design__c).Output__c+SPACE) : (hvca.Splice_Design__c +SPACE);
        spliceOutput +=spliceDesign;
        spliceOutput +=  (PartSelectorOutput__c.getInstance(hvca.Insulation_Material__c) !=null) ? (PartSelectorOutput__c.getInstance(hvca.Insulation_Material__c).Output__c.removeEnd('_')+SPACE) : (hvca.Insulation_Material__c +SPACE);
            system.debug('>>>>spliceOutput1>>>>>>>>'+spliceOutput);
            spliceOutput +=  (PartSelectorOutput__c.getInstance(hvca.Splice_Outer_Protection__c) !=null) ? (PartSelectorOutput__c.getInstance(hvca.Splice_Outer_Protection__c).Output__c+SPACE) : (hvca.Splice_Outer_Protection__c+SPACE );
               system.debug('>>>>spliceOutput2>>>>>>>>'+spliceOutput);
                spliceOutput +=  (PartSelectorOutput__c.getInstance(hvca.Splice_Type__c) !=null) ? (PartSelectorOutput__c.getInstance(hvca.Splice_Type__c).Output__c+UNDERSCORE) : (hvca.Splice_Type__c+UNDERSCORE );
                    system.debug('>>>>spliceOutput3>>>>>>>>'+spliceOutput); 
                    spliceOutput +=  (PartSelectorOutput__c.getInstance(hvca.Shielding_Type__c) !=null) ? (PartSelectorOutput__c.getInstance(hvca.Shielding_Type__c).Output__c+SPACE) : (hvca.Shielding_Type__c+SPACE );
                       system.debug('>>>>spliceOutput4>>>>>>>>'+spliceOutput); 
                        if(hvca.Conductor_OD__c!=null){
                            system.debug('>>>>hvca.Conductor_OD__c>>>>>>>>'+hvca.Conductor_OD__c); 
                            Decimal conductorOD = hvca.Conductor_OD__c; 
                            system.debug('>>>>conductorOD>>>>>>>>'+conductorOD); 
                            conductorOD = Math.ceil(conductorOD);
                            system.debug('>>>>conductorOD>>>>>>>>'+conductorOD); 
                            spliceOutput +=  conductorOD +SPACE;
                           system.debug('>>>>spliceOutput5>>>>>>>>'+spliceOutput);   
                        } 
        if(hvca.Insulation_OD__c!=null){
            String insulationString ;
            for(Part_Selector_46_69_Output__c partSelector : [Select output__c from Part_Selector_46_69_Output__c 
                                                              where Start_Range__c <=: hvca.Insulation_OD__c AND End_Range__c >=: hvca.Insulation_OD__c 
                                                              AND Type__c = 'Splice_InsulationOD' AND Voltage__c =: volatge order by Start_Range__c] ){
                                                                  insulationString =   partSelector.output__c;          
                                                                  break;
                                                              }
             System.debug('spliceOutput6***'+spliceOutput);
            spliceOutput +=  insulationString!=null ? insulationString : '' ;
            System.debug('spliceOutput***'+spliceOutput);
        }
        
        if(hvca.Splice_Size_Transition__c == 'Yes'){
            //spliceEHVSAdditionalOutput( output, partSelectorTypeMap);
            spliceOutput +=   (PartSelectorOutput__c.getInstance(hvca.Splice_Shielding_Type__c) !=null) ? (UNDERSCORE + PartSelectorOutput__c.getInstance(hvca.Splice_Shielding_Type__c).Output__c+SPACE) : (UNDERSCORE + hvca.Splice_Shielding_Type__c+SPACE );
             System.debug('***hvca.Splice_Conductor_OD__c(**'+hvca.Splice_Conductor_OD__c);
            if(hvca.Splice_Conductor_OD__c!=null){
                Decimal conductorOD = hvca.Splice_Conductor_OD__c;                        
                conductorOD = Math.ceil(conductorOD);
                spliceOutput +=  conductorOD +SPACE;
            }   
            if(hvca.Splice_Insulation_OD__c!=null){
                String insulationString ;
                for(Part_Selector_46_69_Output__c partSelector : [Select output__c from Part_Selector_46_69_Output__c 
                                                                  where Start_Range__c <=: hvca.Splice_Insulation_OD__c AND End_Range__c >=: hvca.Splice_Insulation_OD__c 
                                                                  AND Type__c = 'Splice_InsulationOD' AND Voltage__c =: volatge order by Start_Range__c] ){
                                                                      insulationString =   partSelector.output__c;          
                                                                      break;
                                                                  }
            
                spliceOutput +=  insulationString!=null ? insulationString : '' ;
            }
        }
        
        String docName = 'EHVS-'+volatge+spliceDesign.trim();
        if(hvca.Splice_Type__c == 'Inline') docName += SPACE+'Inline';
        else docName += SPACE+'SB';
        System.debug('***docName***'+docName);
        for(Part_Selector_Document_Table__c documentTable : [Select Pricing__c, Lead_Times_Days__c, Image__c, Data_Sheet_Name__c, Offer_Drawing_Name__c, Data_Sheet__c, Offer_Drawing__c from Part_Selector_Document_Table__c where name =:docName ]){
            if(documentTable.Offer_Drawing__c!=null)
                documentLinks = documentTable.Offer_Drawing__c.split(',');
            spliceDocTable = documentTable;
            hvca.Splice_List_Price__c = documentTable.Pricing__c;
            output.documentMap = new  Map<String,Part_Selector_Document_Table__c>();
            output.documentMap.put('Splice',documentTable);
        }
        if(String.isBlank(spliceOutput)) {
            spliceOutput = 'No Output with selected  combination. For further assitance please contact TE.';
        }else{
            hvca.Splice_Output__c = spliceOutput;
        }
        return spliceOutput;
    }
    
    private void emailOutputService(OutputWrapper output,HVCA_Part_Selector__c hvca, String message){         
       Messaging.SingleEmailMessage[] MassMail = New List<Messaging.SingleEmailMessage>();  
        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage(); 
        email.setUseSignature(false);
        email.setSaveAsActivity(false);
        Id id = [Select ownerId from HVCA_Part_Selector__c where id=: hvca.Id ].ownerId;
        email.setTargetObjectId(id);
        email.setSubject(message);   
        String body = '<br/>Part Selector Details - <br/><br/>'
            +'Please <a href="'+URL.getSalesforceBaseUrl().toExternalForm()+'/apex/HVCA_PartSelector2?id='+hvca.Id+'">click here</a> for more details <br/><br/>' 
            +'Thank you,<br/>'
            +'TE Connectivity'; 
        email.setHTMLBody(body);
        MassMail.add(email);
        Messaging.sendEmail(MassMail);
    }
    
    /**
     * Prepare Splice output for cold applied 72, 145, 170 volatges
     * @return cplieOutput
     * */ 
    public String terminationOHVTOutput( OutputWrapper output){
        String terminationOutput  ;
        terminationOutput = 'OHVT'+UNDERSCORE+ hvca.Termination_Operating_Voltage__c+SPACE;
        String insulatorType =   (PartSelectorOutput__c.getInstance(hvca.Insulator_Type__c) !=null) ? (PartSelectorOutput__c.getInstance(hvca.Insulator_Type__c).Output__c+SPACE) : (hvca.Insulator_Type__c +SPACE);
            terminationOutput += insulatorType;
        if(hvca.Insulator_Type__c != 'Dry Type'){
            terminationOutput +=  (PartSelectorOutput__c.getInstance(hvca.Insulation_Material__c) !=null) ? (PartSelectorOutput__c.getInstance(hvca.Insulation_Material__c).Output__c.removeEnd('_')+UNDERSCORE) : (hvca.Insulation_Material__c +UNDERSCORE);
            terminationOutput +=  (PartSelectorOutput__c.getInstance(hvca.Shielding_Type__c) !=null) ? (PartSelectorOutput__c.getInstance(hvca.Shielding_Type__c).Output__c+UNDERSCORE) : (hvca.Shielding_Type__c+UNDERSCORE );
            
            if(hvca.Conductor_OD__c!=null){
                Decimal conductorOD = hvca.Conductor_OD__c;                        
                conductorOD = (Integer)conductorOD - math.mod((Integer)conductorOD, 3) + 3;
                terminationOutput +=  conductorOD +SPACE;
            }
            if(hvca.Insulation_OD__c!=null){
                String insulationString = '';                
                for(Part_Selector_46_69_Output__c partSelector : [Select output__c from Part_Selector_46_69_Output__c 
                                                                  where Start_Range__c <=: hvca.Insulation_OD__c AND End_Range__c >=: hvca.Insulation_OD__c 
                                                                  AND Type__c = 'Terminal_InsulationOD' order by Start_Range__c] ){
                                                                     insulationString =   partSelector.output__c; 
                                                                     break;
                }
                terminationOutput +=  insulationString != null ?  insulationString + UNDERSCORE : '';
            }
            
            if(hvca.Outer_Jacket_OD__c<=85)
                terminationOutput += 'A' + Space;
            else if(hvca.Outer_Jacket_OD__c > 85 && hvca.Outer_Jacket_OD__c <110)
                terminationOutput += 'B' + Space;            
            terminationOutput += (PartSelectorOutput__c.getInstance(hvca.Cable_Lug__c)!=null) ? (PartSelectorOutput__c.getInstance(hvca.Cable_Lug__c).Output__c+UNDERSCORE) : (hvca.Cable_Lug__c +UNDERSCORE);
            terminationOutput +=  (PartSelectorOutput__c.getInstance(hvca.Creepage_distance__c) !=null) ? (PartSelectorOutput__c.getInstance(hvca.Creepage_distance__c).Output__c+SPACE) : (hvca.Creepage_distance__c+SPACE );
            terminationOutput += 'S';
        }
        documentLinks = new List<String>();
        String docName = 'OHVT-'+hvca.Termination_Operating_Voltage__c+insulatorType.trim();
        System.debug('**docName**'+docName);
        for(Part_Selector_Document_Table__c documentTable : [Select Pricing__c, Lead_Times_Days__c, Image__c, Data_Sheet_Name__c, Offer_Drawing_Name__c,  Data_Sheet__c, Offer_Drawing__c from Part_Selector_Document_Table__c where name =:docName ]){
            if(documentTable.Offer_Drawing__c!=null)
                documentLinks = documentTable.Offer_Drawing__c.split(',');
            docTable = documentTable;
            hvca.Termination_List_Price__c = documentTable.Pricing__c;
            output.documentMap = new  Map<String,Part_Selector_Document_Table__c>();
            output.documentMap.put('Termination',documentTable);
        }
        if(String.isBlank(terminationOutput) || terminationOutput==null) {
            terminationOutput = 'No Output with selected  combination. For further assitance please contact TE.';
        }else{
            hvca.Termination_Output__c = terminationOutput;                
        }
        return terminationOutput;
    }
    
    /**
     * Prepare Splice output for cold applied 46, 69 volatges
     * @return cplieOutput
     * */ 
    public String terminationEHVTOutput(){
        String terminationOutput ;
        String conductorSection ='';
        if(hvca.Conductor_Section__c!=null && hvca.Conductor_Section__c.contains('/')){
            conductorSection = hvca.Conductor_Section__c.split('/')[0];
        }else{
            conductorSection = hvca.Conductor_Section__c;
        }
        Integer range = Integer.valueof(conductorSection);
        String query = 'Select id, Appliccation_Type__c, Start_Range__c, End_Range__c, Output__c, Voltage__c, Type__c from Part_Selector_46_69_Output__c '
            +'where Voltage__c=\''+hvca.Termination_Operating_Voltage__c+'\' AND Type__c=\'Termination\' AND Appliccation_Type__c=\''+hvca.Application__c 
            +'\' AND Insulation_OD_Start_Range__c<='+ hvca.Insulation_OD__c+' AND Insulation_OD_End_Range__c >='+hvca.Insulation_OD__c
            +' AND Max_Jacket_OD__c <'+ hvca.Outer_Jacket_OD__c +' AND Max_Jacket_OD__c >='+ hvca.Outer_Jacket_OD__c
            +' AND Start_Range__c <='+ range +'AND End_Range__c >='+ range ;
        System.debug('query'+query);
        for(Part_Selector_46_69_Output__c part : [Select id, Appliccation_Type__c, Start_Range__c, End_Range__c, Output__c, Voltage__c, Type__c from Part_Selector_46_69_Output__c 
                                                  where Voltage__c=:hvca.Termination_Operating_Voltage__c AND Type__c='Termination' AND Appliccation_Type__c=:hvca.Application__c 
                                                  AND Insulation_OD_Start_Range__c<=: hvca.Insulation_OD__c AND Insulation_OD_End_Range__c >=:hvca.Insulation_OD__c
                                                  AND  Max_Jacket_OD_End_Range_c__c >=: hvca.Outer_Jacket_OD__c
                                                  AND Start_Range__c <=: range AND End_Range__c >=: range ]){
                                                      System.debug('**part***'+part);
                                                      terminationOutput = part.Output__c;
        }
        String whereCondition ;
        if(hvca.Insulation_OD__c !=null && hvca.Conductor_OD__c!=null ){
            whereCondition = ' Insulation_OD__c = '+Math.ceil(hvca.Insulation_OD__c) + ' AND Connductor_OD__c = '+Math.ceil(hvca.Conductor_OD__c);
        }        
        String eppaQuery = 'Select id, Connductor_OD__c, Connductor_OD_2__c,Insulation_OD__c,Insulation_OD_2__c,RPN__c from EPPA_Configuration__c ';
        if(whereCondition!=null){
            whereCondition += ' AND  Connector_Type__c = \'EPPA-054\'';
            eppaQuery += ' where '+whereCondition;
            for(EPPA_Configuration__c eppa : Database.query(eppaQuery)){
                eppa54RPN = eppa.RPN__c;
                hvca.EPPA_RPN_054__c = eppa54RPN;
            }
        }
        System.debug('eppaQuery'+ eppaQuery);        
        
        return terminationOutput;
        
        
    }
    public String eppa54RPN{get;set;}
    public Attachment attachment {
        get {
            
            if (attachment == null)
                attachment = new Attachment();
            return attachment;
        }
        set;
    }
 
    public Boolean isSuccess{get;set;}
    public PageReference upload() {        
        attachment.OwnerId = UserInfo.getUserId();
        if(hvca.Id == null) upsert hvca;
        attachment.ParentId = this.hvca.Id; // the record the file is attached to
        System.debug('attachment'+attachment);
        System.debug('attachment'+attachment.body);
        
        try {
            String errorMessage ='';
            if(attachment.Name == null){
                errorMessage = 'Please Enter name of document.';
            }else if(attachment.Body == null){
                errorMessage = 'Please attach  document.';
            }
            if(String.isBlank(errorMessage)){
                insert attachment;
                //attachments.add(attachment);
                isSuccess = true;     
                isError = false;
            }
            else {
                isError  = true;
                isSuccess = false;
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,errorMessage));
            }
         
        } catch (DMLException e) {
            isError  = true;
            isSuccess = false;
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Error uploading attachment'));
            return null;
        } finally {
            attachment = new Attachment(); 
            attachment.body = null;
        }
        
        ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,'Attachment uploaded successfully'));
        return null;
    }
    public Boolean isShowCableClamp{get;set;}
    public pageReference generateQuote(){
        System.debug('***isCableStrippingTool**'+isCableStrippingTool);
        
        if(terminationOutputPriceTable!=null){
            if(terminationOutputPriceTable.isTrade){
                hvca.Termination_Approved_Price__c =  terminationOutputPriceTable.priceOutput.Trade__c;   
                hvca.Termination_Offered_Price__c = terminationOutputPriceTable.priceOutput.Trade__c; 
            }else if(terminationOutputPriceTable.isAuthorizedDistributor){
                hvca.Termination_Approved_Price__c =  terminationOutputPriceTable.priceOutput.AUTHORIZED_DISTRIBUTOR__c;   
                hvca.Termination_Offered_Price__c = terminationOutputPriceTable.priceOutput.AUTHORIZED_DISTRIBUTOR__c; 
            }else if(terminationOutputPriceTable.isEliteDistributor){
                hvca.Termination_Approved_Price__c =  terminationOutputPriceTable.priceOutput.ELITE_DISTRIBUTOR__c; 
                hvca.Termination_Offered_Price__c = terminationOutputPriceTable.priceOutput.ELITE_DISTRIBUTOR__c; 
            }
        }else if(docTable!=null && (hvca.Termination_Approved_Price__c ==null || hvca.Termination_Approved_Price__c==0) ){
                hvca.Termination_Approved_Price__c = docTable.Pricing__c;
        }
        
        if(spliceOutputPriceTable!=null){
            if(spliceOutputPriceTable.isTrade){
                hvca.Splice_Approved_Price__c =  spliceOutputPriceTable.priceOutput.Trade__c;   
                hvca.Splice_Offered_Price__c = spliceOutputPriceTable.priceOutput.Trade__c; 
            }else if(spliceOutputPriceTable.isAuthorizedDistributor){
                hvca.Splice_Approved_Price__c =  spliceOutputPriceTable.priceOutput.AUTHORIZED_DISTRIBUTOR__c;  
                hvca.Splice_Offered_Price__c = spliceOutputPriceTable.priceOutput.AUTHORIZED_DISTRIBUTOR__c; 
            }else if(spliceOutputPriceTable.isEliteDistributor){
                hvca.Splice_Approved_Price__c =  spliceOutputPriceTable.priceOutput.ELITE_DISTRIBUTOR__c; 
                hvca.Splice_Offered_Price__c = spliceOutputPriceTable.priceOutput.ELITE_DISTRIBUTOR__c; 
            }
        }else if(spliceDocTable!=null && (hvca.Splice_Approved_Price__c ==null || hvca.Splice_Approved_Price__c==0) ){
                hvca.Splice_Approved_Price__c = spliceDocTable.Pricing__c;
        }
        
        if(gisDocTable!=null &&  (hvca.GIS_Approved_Price__c ==null || hvca.GIS_Approved_Price__c==0) ){
            hvca.GIS_Approved_Price__c = gisDocTable.Pricing__c;
        }
        update hvca;

        if(hvca.isFlatMount__c || hvca.isStrutNut__c || hvca.isSliderPlate__c || hvca.isFMCompressionString__c){
            isShowCableClamp = true;
            
        }
        /*for(PlasticCampWrapper camp : listOfPlasticCamps){
            
            if(camp.isInclude){isShowCableClamp = true;
                               break;
            }
        }*/
        
        
     
        return emailOutputService(hvca);
    }
    public PlasticCampPDF plasticCampPdfTable{get;set;}
    
    private PlasticCampPDF  prepareClampPdfMap(List<PlasticCampWrapper> listOfPlasticCamps){
        PlasticCampPDF  pasticCamp = new PlasticCampPDF();
        List<String> headerList = new List<String> ();
        headerList.add('Mounting Version');
        headerList.add('Catalog Number');
        if(hvca.isTradeColoumn__c) headerList.add('Trade');
        if(hvca.isAuthorizedDistributor__c)headerList.add('Authorized Distributor');
        if(hvca.isEliteDistributor__c)headerList.add('Elite Distributor');
        pasticCamp.headerMap.put('header',headerList);
        for(PlasticCampWrapper camp : listOfPlasticCamps){
            List<String> row = new List<String>();
            if((camp.plasticCamp.Mounting_Version__c == 'FLAT MOUNT' && hvca.isFlatMount__c) || 
               (camp.plasticCamp.Mounting_Version__c == 'STRUT NUT' && hvca.isStrutNut__c) ||
               (camp.plasticCamp.Mounting_Version__c == 'SLIDER PLATE' && hvca.isSliderPlate__c)||
               (camp.plasticCamp.Mounting_Version__c == 'FLAT MOUNT with Compression Springs' && hvca.isFMCompressionString__c) ||
               (camp.plasticCamp.Mounting_Version__c == 'TREFOIL CABLE CLAMPS -SLIDER PLATE' && hvca.IS_TREFOIL_CABLE_CLAMPS_SLIDER_PLATE__c) ||
               (camp.plasticCamp.Mounting_Version__c == 'TREFOIL CABLE CLAMPS -STRUT NUT' && hvca.IS_TREFOIL_CABLE_CLAMPS_STRUT_NUT__c) 
              ){
                   row.add(camp.plasticCamp.Mounting_Version__c);
                   row.add(camp.plasticCamp.CATALOG_NUMBER__c);
                   System.debug('**hvca.isTradeColoumn__c**'+hvca.isTradeColoumn__c);
                   System.debug('**hvca.isAuthorizedDistributor__c**'+hvca.isAuthorizedDistributor__c);
                   System.debug('**hvca.isEliteDistributor__c**'+hvca.isEliteDistributor__c);
                   if(hvca.isTradeColoumn__c) row.add('$'+String.valueof(camp.plasticCamp.TRADE__c));
                   if(hvca.isAuthorizedDistributor__c) row.add('$'+String.valueof(camp.plasticCamp.AUTHORIZED_DISTRIBUTOR__c));
                   if(hvca.isEliteDistributor__c) row.add('$'+String.valueof(camp.plasticCamp.ELITE_DISTRIBUTOR__c));
                   pasticCamp.rowsMap.put(camp.plasticCamp.Mounting_Version__c,row);
               }
        }
        return pasticCamp;
    }    
    
    
    public class PlasticCampPDF{
        public Map<String, List<String>> headerMap {get;set;} 
        public Map<String, List<String>> rowsMap {get;set;}
        public plasticCampPDF(){
            headerMap = new Map<String, List<String>>();
            rowsMap = new Map<String, List<String>>();
        }        
    }
    
    public  pageReference  emailOutputService(HVCA_Part_Selector__c hvca){     
        //plasticCampPdfTable = null;
        //plasticCampPdfTable = prepareClampPdfMap(listOfPlasticCamps);
        //System.debug('plasticCampPdfTable*********'+plasticCampPdfTable);
        
        HVCA_Part_Selector__c hvcaLocal  = [select id, Name, OwnerId, Owner.Name from HVCA_Part_Selector__c where id=: hvca.Id];
        HVCAPartSelectorExtension.sendPdfMethod(hvcaLocal.Id,hvcaLocal.Name,hvcaLocal.Owner.Name, hvcaLocal.OwnerId);
        PageReference pdf;            
        pdf = Page.HVCA_GenerateQuote;
        pdf.getParameters().put('hvcaId',hvca.id);
        pdf.setRedirect(true);        
        System.debug('MAIL SENT');
        return pdf;
    }
    
    @future
    public static void sendPdfMethod(String hvcaId,String hvcaName, String OwnerName, String ownerId){
        Messaging.SingleEmailMessage[] MassMail = New List<Messaging.SingleEmailMessage>(); 
        //System.debug('**status**'+status);
        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage(); 
        email.setUseSignature(false);
        email.setSaveAsActivity(false);
        email.setTargetObjectId(ownerId);  
        if(System.label.Part_Selector_Is_send_test_mail == 'Yes')
            email.setBccAddresses(new List<String>{System.label.Part_Selector_Test_Email});
        String message = 'Your Quote '+hvcaName+' has been ';
        email.setSubject('Offer Proposal for '+hvcaName); 
        Blob attbody;
        Messaging.EmailFileAttachment efa1 = new Messaging.EmailFileAttachment();
        List<Messaging.Emailfileattachment> fileAttachments = new List<Messaging.Emailfileattachment>(); 
        PageReference pdf;            
        pdf = Page.HVCA_GenerateQuote;
        pdf.getParameters().put('hvcaId',hvcaId);

        if(!Test.IsRunningTest()){
            attbody = pdf.getcontentAsPdf();
            System.debug('**attbody**'+attbody);
            //attbody= pdf.getContent();
            efa1.setFileName('Offer Proposal.pdf');
            efa1.setBody(attbody);
            fileAttachments.add(efa1);
        }
        email.setFileAttachments(fileAttachments);
        String body = 'Hi, <br/>'+OwnerName+' <br/><br/>'
            +'Please <a href="'+URL.getSalesforceBaseUrl().toExternalForm()+'/apex/HVCA_PartSelector2?id='+hvcaId+'">click here</a> for more details <br/><br/>' 
            +'Thank you,<br/>'
            +'TE Connectivity'; 
        email.setHTMLBody(body);
        system.debug('body'+body);
        MassMail.add(email);
        System.debug('**email '+email);
        
        //return MassMail;
        
        if(MassMail.size()>0 && !Test.isRunningTest()) Messaging.sendEmail(MassMail);
        ///Messaging.sendEmail(MassMail);
    }
    
    public pageReference saveRecord(){
        System.debug('***hvca***'+hvca);
         System.debug('***hvca***'+hvca.Id);
        if(hvca.Termination_Offered_Price__c != hvca.Termination_List_Price__c && hvca.Termination_Offered_Price__c != hvca.Termination_Approved_Price__c){
            hvca.isShowOffer__c = false;
            hvca.Approval_Status__c = 'Not Submitted';
        }else if( hvca.Splice_Offered_Price__c != hvca.Splice_List_Price__c && hvca.Splice_Offered_Price__c != hvca.Splice_Approved_Price__c){
            hvca.isShowOffer__c = false;
            hvca.Approval_Status__c = 'Not Submitted';
        }else if( hvca.GIS_Offered_Price__c != hvca.GIS_List_Price__c && hvca.GIS_Offered_Price__c != hvca.GIS_Approved_Price__c){
            hvca.isShowOffer__c = false;
            hvca.Approval_Status__c = 'Not Submitted';
        }
        
        upsert hvca;
        return null;
    }
    
    public pageReference submitForApproval(){
        hvca.Approval_Status__c = 'Pending Approval';
        hvca.isShowOffer__c = false;
        update hvca;
        // Create an approval request for the HVCA
        Approval.ProcessSubmitRequest req1 = new Approval.ProcessSubmitRequest();
        req1.setComments('Submitting request for approval automatically');
        req1.setObjectId(hvca.id);
        
        // Submit the approval request for the Opportunity
        if(!Test.isRunningTest())
        Approval.ProcessResult result = Approval.process(req1);
        //Boolean result1 = System.Approval.unlock(hvca.id).isSuccess();
        OutputWrapper output = new OutputWrapper ();
        emailOutputService(output,hvca,'Your HVCA query has been submitted for Approval');
        PageReference pageRef ;        
        if(ApexPages.currentPage().getParameters().get('oppId')!=null){
            pageRef = new PageReference('/'+ApexPages.currentPage().getParameters().get('oppId'));
        }else if(hvca.id!=null){
            pageRef = new PageReference('/'+hvca.Id);
        }
        return pageRef;
    }
    public pagereference back(){
        isShowInputSecion = true;
        attachment = null;
        attachments = null;
        isConstructer = false;
        return null;
    }
    
    public pageReference toggleTransitionSection(){
        hvca.isTerminationChecked__c = ! hvca.isTerminationChecked__c;
        return null;
    }
    
    public pageReference toggleSpliceSection(){
        hvca.isSpliceChecked__c = !hvca.isSpliceChecked__c;
        return null;
    }
    
    public pageReference toggleGISSection(){
        hvca.isGISChecked__c = !hvca.isGISChecked__c;
        return null;
    }
    public pageReference toggleAccessoriessSection(){
        hvca.isAccessoriessChecked__c = !hvca.isAccessoriessChecked__c;
        if(hvca.isAccessoriessChecked__c){
            getPlasticCamps();
        }
        return null;
    }
    
    public pageReference spliceAdditionSection(){
        System.debug('true'+hvca.Splice_Size_Transition__c);
        if(hvca.Splice_Size_Transition__c == 'Yes')
            isShowSpliceAdditionSection = true;
        else
            isShowSpliceAdditionSection = false; 
        return null;
    }
    public PageReference backToOpp(){
        update hvca;
        OutputWrapper output = new OutputWrapper ();
        emailOutputService(output,hvca,'HVCA record details queried by you');
        PageReference pageRef ;        
        if(ApexPages.currentPage().getParameters().get('oppId')!=null){
            pageRef = new PageReference('/'+ApexPages.currentPage().getParameters().get('oppId'));
        }else if(hvca.id!=null){
            pageRef = new PageReference('/'+hvca.Id);
        }
        return pageRef;
    }
    public class OutputWrapper{
        public String terminationOutput;
        public String spliceOutput;
        public String gisOutput;
        public Map<String,Part_Selector_Document_Table__c> documentMap;
        public Map<String,OutputPriceWrapper> priceMap;
    }
    
    public class PlasticCampWrapper{
        public Boolean isInclude{get;set;}
        
        public Part_Selector_Plastic_Clamps__c plasticCamp{get;set;}
    }
    public class OutputPriceWrapper{
        public Part_Selector_Output_Price_Table__c priceOutput{get;set;}
        public Boolean isTrade{get;set;}
        public Boolean isEliteDistributor{get;set;}
        public Boolean isAuthorizedDistributor{get;set;}
        public OutputPriceWrapper(){
            isTrade = false;
            isEliteDistributor = false;
            isAuthorizedDistributor = false;
        }
    }
}