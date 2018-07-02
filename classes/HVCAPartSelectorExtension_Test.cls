@isTest
private class HVCAPartSelectorExtension_Test {

    public static testMethod void testExtension(){
        HVCA_Part_Selector__c hvca = new HVCA_Part_Selector__c();
        
        
        Part_Selector_Conductor_OD__c psco =  new Part_Selector_Conductor_OD__c();
        psco.Name = '650';
        psco.Compact_Diameter__c = 0.845;
        psco.Compressed_Diameter__c = 0.901 ;
        psco.Concentric_Diameter__c = 0.929;
        insert psco;
        
        List<Part_Selector_Insulation_OD__c> insulationList = new List<Part_Selector_Insulation_OD__c>();
        Part_Selector_Insulation_OD__c psio = new Part_Selector_Insulation_OD__c();
        psio.Name = 'Termination_1';
        psio.Start_Range__c  = 0;
        psio.End_Range__c = 158;
        psio.Type__c = 'Termination';
            insulationList.add(psio);
        
        Part_Selector_Insulation_OD__c psio2 = new Part_Selector_Insulation_OD__c();
        psio2.Start_Range__c = 0;
        psio2.End_Range__c = 158;
        psio2.Name = 'Splice1';
        psio2.Type__c = 'Splice';
        psio2.Voltage__c = '145';
            insulationList.add(psio2);        
            
        insert insulationList;
        
        List<PartSelectorOutput__c> partSelectorOutputs = new List<PartSelectorOutput__c>();
        PartSelectorOutput__c pso = new PartSelectorOutput__c();
        pso.Name = 'Composite';
        pso.Output__c = 'C';
            partSelectorOutputs.add(pso);
        PartSelectorOutput__c pso1 = new PartSelectorOutput__c();
        pso1.Name = 'EPR';
        pso1.Output__c = 'E';
            partSelectorOutputs.add(pso1);        
        PartSelectorOutput__c pso2 = new PartSelectorOutput__c();
        pso2.Name = 'Copper Wire';
        pso2.Output__c = 'W';
            partSelectorOutputs.add(pso2);
        PartSelectorOutput__c pso3 = new PartSelectorOutput__c();
        pso3.Name = '50 mm * 130 mm';
        pso3.Output__c = 'I';
            partSelectorOutputs.add(pso3);  
        PartSelectorOutput__c pso4 = new PartSelectorOutput__c();
        pso4.Name = 'Three Piece';
        pso4.Output__c = 'I';
        	partSelectorOutputs.add(pso4); 
        
        PartSelectorOutput__c pso5 = new PartSelectorOutput__c();
        pso5.Name = 'Wraparound';
        pso5.Output__c = 'W';
        	partSelectorOutputs.add(pso5); 
        
        insert partSelectorOutputs;
        
        List<Part_Selector_46_69_Output__c> partSelector46_69Outputs = new List<Part_Selector_46_69_Output__c> ();        
        Part_Selector_46_69_Output__c psOutput1 = new Part_Selector_46_69_Output__c();
        psOutput1.Type__c = 'Terminal_InsulationOD';
        psOutput1.Start_Range__c  =0;
        psOutput1.End_Range__c = 158;
        psOutput1.Name = 'Terminal_InsulationOD_3';
        psOutput1.Output__c ='D';
            partSelector46_69Outputs.add(psOutput1);
        
        Part_Selector_46_69_Output__c psOutput2 = new Part_Selector_46_69_Output__c();
        psOutput2.Type__c = 'Splice_InsulationOD';
        psOutput2.Start_Range__c  =2;
        psOutput2.End_Range__c = 158;
        psOutput2.Name = 'Splice_InsulationOD_2';
        psOutput2.Output__c = 'C';
            partSelector46_69Outputs.add(psOutput2);
        
        Part_Selector_46_69_Output__c psOutput3 = new Part_Selector_46_69_Output__c();
        psOutput3.Type__c = 'GIS_InsulationOD';
        psOutput3.Start_Range__c  =0;
        psOutput3.End_Range__c = 157;
        psOutput3.Name = 'GIS_InsulationOD';
        psOutput3.Output__c = 'E';
            partSelector46_69Outputs.add(psOutput3);
        
        insert partSelector46_69Outputs;
        
        List<Part_Selector_Document_Table__c> documentTables = new List<Part_Selector_Document_Table__c>();
        Part_Selector_Document_Table__c psdt = new Part_Selector_Document_Table__c();
        psdt.Name = 'OHVT-145C';
        psdt.Offer_Drawing__c = '/servlet/servlet.FileDownload?file=01555000000fqoV';
        psdt.Offer_Drawing_Name__c = 'OfferDrawing-OHVT-145C(3392)';
        psdt.Part_Description__c = 'OHVT-145C';
        psdt.Pricing__c = 5616.00;
            documentTables.add(psdt);
        
        Part_Selector_Document_Table__c psdt2 = new Part_Selector_Document_Table__c();
        psdt2.Name = 'EHVS-145C SB';
        psdt2.Offer_Drawing__c = '/servlet/servlet.FileDownload?file=01555000000fqoV';
        psdt2.Offer_Drawing_Name__c = 'OfferDrawing-OHVT-145C(3392)';
        psdt2.Part_Description__c = 'EHVS-145T Inline';
        psdt2.Pricing__c = 5616.00;
            documentTables.add(psdt2);
        
        insert documentTables ;
            
        List<Part_Selector_Plastic_Clamps__c>   clampList = new List<Part_Selector_Plastic_Clamps__c>();
            Part_Selector_Plastic_Clamps__c pc1 = new Part_Selector_Plastic_Clamps__c();
            pc1.Name = 'Flat Mount';
        	pc1.Mounting_Version__c = 'FLAT MOUNT';
            pc1.Cable_Start_Range__c = 0;
            pc1.Cable_End_Range__c = 200;
            pc1.AUTHORIZED_DISTRIBUTOR__c = 987;
            pc1.ELITE_DISTRIBUTOR__c = 0;
            pc1.TRADE__c = 0;
         clampList.add(pc1);
        	Part_Selector_Plastic_Clamps__c pc2 = new Part_Selector_Plastic_Clamps__c();
            pc2.Name = 'FLAT MOUNT with Compression Springs 1';
        	pc2.Mounting_Version__c = 'FLAT MOUNT with Compression Springs';
            pc2.Cable_Start_Range__c = 0;
            pc2.Cable_End_Range__c = 200;
            pc2.AUTHORIZED_DISTRIBUTOR__c = 987;
            pc2.ELITE_DISTRIBUTOR__c = 0;
            pc2.TRADE__c = 0;        
        clampList.add(pc2);
        	Part_Selector_Plastic_Clamps__c pc3 = new Part_Selector_Plastic_Clamps__c();
            pc3.Name = 'SLIDER PLATE';
        	pc3.Mounting_Version__c = 'SLIDER PLATE';
            pc3.Cable_Start_Range__c = 0;
            pc3.Cable_End_Range__c = 200;
            pc3.AUTHORIZED_DISTRIBUTOR__c = 987;
            pc3.ELITE_DISTRIBUTOR__c = 0;
            pc3.TRADE__c = 0;        
        clampList.add(pc3);
        	Part_Selector_Plastic_Clamps__c pc4 = new Part_Selector_Plastic_Clamps__c();
            pc4.Name = 'STRUT NUT';
        	pc4.Mounting_Version__c = 'STRUT NUT';
            pc4.Cable_Start_Range__c = 0;
            pc4.Cable_End_Range__c = 200;
            pc4.AUTHORIZED_DISTRIBUTOR__c = 987;
            pc4.ELITE_DISTRIBUTOR__c = 0;
            pc4.TRADE__c = 0;        
        clampList.add(pc4);
        
        insert clampList;
         
        List<Part_Selector_Output_Price_Table__c> priceTables = new List<Part_Selector_Output_Price_Table__c>();
        Part_Selector_Output_Price_Table__c priceTable = new Part_Selector_Output_Price_Table__c();        
        priceTable.Name = 'EHVS-6920-W';
        priceTable.AUTHORIZED_DISTRIBUTOR__c = 546;
        priceTable.ELITE_DISTRIBUTOR__c = 546;
        priceTable.Trade__c = 454;
        priceTables.add(priceTable);
        
        Part_Selector_Output_Price_Table__c priceTable1 = new Part_Selector_Output_Price_Table__c();        
        priceTable1.Name = 'EHVT-690-SG';
        priceTable1.AUTHORIZED_DISTRIBUTOR__c = 546;
        priceTable1.ELITE_DISTRIBUTOR__c = 546;
        priceTable1.Trade__c = 454;
        priceTables.add(priceTable1);
        
        insert priceTables;
        
        
        ApexPages.StandardController sc = new ApexPages.StandardController(hvca);
        HVCAPartSelectorExtension hvcaExtension = new HVCAPartSelectorExtension(sc);
        PageReference pageRef = Page.HVCA_PartSelector2;
        //pageRef.getParameters().put('id', String.valueOf(testAccountPlanInsert.Id));
        Test.setCurrentPage(pageRef);
        Test.startTest();
            hvca.Splice_Conductor_OD__c =  55;  
            hvca.Splice_Insulation_OD__c =  55.5;
            hvcaExtension.save();
            hvca.Conductor_OD__c  = 14.5;
            hvca.Conductor_Type__c = 'Compact Diameter';
            hvca.Insulator_Type__c = 'Composite';
            hvca.Insulation_Material__c  = 'EPR';
        	hvca.Conductor_Material__c = 'Aluminum';
            hvca.Insulation_OD__c = 55.5;
            hvca.Outer_Jacket_OD__c = 85.5;
            hvca.Cable_Lug__c = '50 mm * 130 mm';
            hvca.Shielding_Type__c = 'Copper Wire';
            hvca.Termination_Operating_Voltage__c = '145';
            hvca.GIS_Operating_Voltage__c = '145';
        	hvca.Installation_Type__c = 'Cold Applied';
        	hvca.Splice_Installation_Type__c = 'Cold Applied';
        	hvca.GIS_Design__c = 'Transformer';
        	hvca.isSpliceChecked__c = true;
        	hvca.isTerminationChecked__c = true;
        	hvca.Dry_Oil_Field__c = 'PHVX';
        	hvca.Housing_Length__c = '15';
            hvca.Conductor_Section__c = '650';        
            hvca.Splice_Operating_Voltage__c = '145';
            hvca.Splice_Size_Transition__c = 'Yes';
        	hvca.Splice_Design__c = 'Three Piece';   
        	hvca.Splice_Shield_Continuity__c = '10';
        	hvca.Splice_Outer_Protection__c = 'Wraparound';
            hvca.Splice_Type__c = 'Inline';
            hvca.Installation_Type__c = 'Cold Applied';
         	hvca.isTerminationChecked__c = true;
        	hvca.isFlatMount__c = true;
        	hvca.isSpliceChecked__c = true;
        	hvca.isGISChecked__c = true;
        	hvca.Creepage_distance__c = '6100';
        	hvca.isAccessoriessChecked__c = true;
            hvcaExtension.save();
        	if(hvca.id ==null) insert hvca;
            hvca.Termination_Operating_Voltage__c = '46';
           
            hvca.GIS_Operating_Voltage__c = '46';
            hvca.Application__c = 'Outdoor';
                  
            HVCAPartSelectorExtension.OutputWrapper output = new  HVCAPartSelectorExtension.OutputWrapper();
        		output.priceMap =  new Map<String,HVCAPartSelectorExtension.OutputPriceWrapper>();
            hvca.Splice_Shielding_Type__c = 'Copper Wire';
            hvcaExtension.save();
            hvcaExtension.upload();
            hvcaExtension.back();
            hvcaExtension.backToOpp();
            hvcaExtension.fetchConductorOd();
            hvcaExtension.spliceAdditionSection();
            hvcaExtension.toggleGISSection();
            hvcaExtension.toggleSpliceSection();
            hvcaExtension.toggleTransitionSection();
            hvcaExtension.spliceHeatShrinkDocumentTable(output);    
            hvcaExtension.terminationEHVTDcouments(output);    
            hvcaExtension.generateQuote();
            hvcaExtension.saveRecord();
            hvcaExtension.submitForApproval();
            hvcaExtension.toggleAccessoriessSection();
        	
            hvca.Termination_Operating_Voltage__c = '46';
            hvca.Splice_Operating_Voltage__c = '69';
        
            hvca.GIS_Operating_Voltage__c = '46';
        hvcaExtension.save();
            hvca.Application__c = null;
            hvca.Splice_Type__c = null;
            
            
            hvca.Splice_Shielding_Type__c = null;
            hvcaExtension.save();
        
            hvca.Termination_Operating_Voltage__c = '145';
            hvca.Insulator_Type__c =null;
            hvcaExtension.save();
            hvca.Conductor_Type__c = 'Compressed Diameter';
            hvcaExtension.fetchConductorOd();
            hvca.Conductor_Type__c = 'Concentric Diameter';
            hvcaExtension.fetchConductorOd();
        Test.stopTest();
    }
    
    public static testMethod void testExtension2(){
        HVCA_Part_Selector__c hvca = new HVCA_Part_Selector__c();
        
        
        Part_Selector_Conductor_OD__c psco =  new Part_Selector_Conductor_OD__c();
        psco.Name = '650';
        psco.Compact_Diameter__c = 0.845;
        psco.Compressed_Diameter__c = 0.901 ;
        psco.Concentric_Diameter__c = 0.929;
        insert psco;
        
        List<Part_Selector_Insulation_OD__c> insulationList = new List<Part_Selector_Insulation_OD__c>();
        Part_Selector_Insulation_OD__c psio = new Part_Selector_Insulation_OD__c();
        psio.Name = 'Termination_1';
        psio.Start_Range__c  = 53;
        psio.End_Range__c = 58;
        psio.Type__c = 'Termination';
            insulationList.add(psio);
        
        Part_Selector_Insulation_OD__c psio2 = new Part_Selector_Insulation_OD__c();
        psio2.Start_Range__c = 53;
        psio2.End_Range__c = 58;
        psio2.Name = 'Splice1';
        psio2.Type__c = 'Splice';
        psio2.Voltage__c = '145';
            insulationList.add(psio2);        
            
        insert insulationList;
        
        List<PartSelectorOutput__c> partSelectorOutputs = new List<PartSelectorOutput__c>();
        PartSelectorOutput__c pso = new PartSelectorOutput__c();
        pso.Name = 'Composite';
        pso.Output__c = 'C';
            partSelectorOutputs.add(pso);
        PartSelectorOutput__c pso1 = new PartSelectorOutput__c();
        pso1.Name = 'EPR';
        pso1.Output__c = 'E';
            partSelectorOutputs.add(pso1);        
        PartSelectorOutput__c pso2 = new PartSelectorOutput__c();
        pso2.Name = 'Copper Wire';
        pso2.Output__c = 'W';
            partSelectorOutputs.add(pso2);
        PartSelectorOutput__c pso3 = new PartSelectorOutput__c();
        pso3.Name = '50 mm * 130 mm';
        pso3.Output__c = 'I';
            partSelectorOutputs.add(pso3);
              PartSelectorOutput__c pso4 = new PartSelectorOutput__c();
        pso4.Name = 'Three Piece';
        pso4.Output__c = 'I';
        	partSelectorOutputs.add(pso4); 
        
        PartSelectorOutput__c pso5 = new PartSelectorOutput__c();
        pso5.Name = 'Wraparound';
        pso5.Output__c = 'W';
        	partSelectorOutputs.add(pso5); 
        
        insert partSelectorOutputs;
        
        List<Part_Selector_46_69_Output__c> partSelector46_69Outputs = new List<Part_Selector_46_69_Output__c> ();        
        Part_Selector_46_69_Output__c psOutput1 = new Part_Selector_46_69_Output__c();
        psOutput1.Type__c = 'Terminal_InsulationOD';
        psOutput1.Start_Range__c  =50;
        psOutput1.End_Range__c = 58;
        psOutput1.Name = 'Terminal_InsulationOD_3';
        psOutput1.Output__c ='D';
            partSelector46_69Outputs.add(psOutput1);
        
        Part_Selector_46_69_Output__c psOutput2 = new Part_Selector_46_69_Output__c();
        psOutput2.Type__c = 'Splice_InsulationOD';
        psOutput2.Start_Range__c  =52;
        psOutput2.End_Range__c = 58;
        psOutput2.Name = 'Splice_InsulationOD_2';
        psOutput2.Output__c = 'C';
            partSelector46_69Outputs.add(psOutput2);
        
        Part_Selector_46_69_Output__c psOutput3 = new Part_Selector_46_69_Output__c();
        psOutput3.Type__c = 'GIS_InsulationOD';
        psOutput3.Start_Range__c  =50;
        psOutput3.End_Range__c = 57;
        psOutput3.Name = 'GIS_InsulationOD';
        psOutput3.Output__c = 'E';
            partSelector46_69Outputs.add(psOutput3);
        
        insert partSelector46_69Outputs;
        
        List<Part_Selector_Document_Table__c> documentTables = new List<Part_Selector_Document_Table__c>();
        Part_Selector_Document_Table__c psdt = new Part_Selector_Document_Table__c();
        psdt.Name = 'OHVT-145C';
        psdt.Offer_Drawing__c = '/servlet/servlet.FileDownload?file=01555000000fqoV';
        psdt.Offer_Drawing_Name__c = 'OfferDrawing-OHVT-145C(3392)';
        psdt.Part_Description__c = 'OHVT-145C';
        psdt.Pricing__c = 5616.00;
            documentTables.add(psdt);
        
        Part_Selector_Document_Table__c psdt7 = new Part_Selector_Document_Table__c();
        psdt7.Name = 'EHVS-Inline';
        psdt7.Offer_Drawing__c = '/servlet/servlet.FileDownload?file=01555000000fqoV';
        psdt7.Offer_Drawing_Name__c = 'OfferDrawing-OHVT-145C(3392)';
        psdt7.Part_Description__c = 'EHVS-Inline';
        psdt7.Pricing__c = 5616.00;
            documentTables.add(psdt7);
        
          
        Part_Selector_Document_Table__c psdt8 = new Part_Selector_Document_Table__c();
        psdt8.Name = 'PHVX-145';
        psdt8.Offer_Drawing__c = '/servlet/servlet.FileDownload?file=01555000000fqoV';
        psdt8.Offer_Drawing_Name__c = 'OfferDrawing-OHVT-145C(3392)';
        psdt8.Part_Description__c = 'PHVX-145';
        psdt8.Pricing__c = 5616.00;
            documentTables.add(psdt8);
        
        Part_Selector_Document_Table__c psdt2 = new Part_Selector_Document_Table__c();
        psdt2.Name = 'EHVS-145C SB';
        psdt2.Offer_Drawing__c = '/servlet/servlet.FileDownload?file=01555000000fqoV';
        psdt2.Offer_Drawing_Name__c = 'OfferDrawing-OHVT-145C(3392)';
        psdt2.Part_Description__c = 'EHVS-145T Inline';
        psdt2.Pricing__c = 5616.00;
            documentTables.add(psdt2);
        
        Part_Selector_Document_Table__c psdt3 = new Part_Selector_Document_Table__c();
        psdt3.Name = 'EHVT-Indoor';
        psdt3.Offer_Drawing__c = '/servlet/servlet.FileDownload?file=01555000000fqoV';
        psdt3.Offer_Drawing_Name__c = 'OfferDrawing-OHVT-145C(3392)';
        psdt3.Part_Description__c = 'EHVT-Indoor';
        psdt3.Pricing__c = 5616.00;
            documentTables.add(psdt3);
        
        Part_Selector_Document_Table__c psdt4 = new Part_Selector_Document_Table__c();
        psdt4.Name = 'OHVT-46C';
        psdt4.Offer_Drawing__c = '/servlet/servlet.FileDownload?file=01555000000fqoV';
        psdt4.Offer_Drawing_Name__c = 'OfferDrawing-OHVT-145C(3392)';
        psdt4.Part_Description__c = 'OHVT-46C';
        psdt4.Pricing__c = 5616.00;
            documentTables.add(psdt4);
        
        Part_Selector_Document_Table__c psdt5 = new Part_Selector_Document_Table__c();
        psdt5.Name = 'PHVX-46';
        psdt5.Offer_Drawing__c = '/servlet/servlet.FileDownload?file=01555000000fqoV';
        psdt5.Offer_Drawing_Name__c = 'OfferDrawing-OHVT-145C(3392)';
        psdt5.Part_Description__c = 'PHVX-46';
        psdt5.Pricing__c = 5616.00;
            documentTables.add(psdt5);
        
        Part_Selector_Document_Table__c psdt6 = new Part_Selector_Document_Table__c();
        psdt6.Name = 'EHVS-145Three ';
        psdt6.Offer_Drawing__c = '/servlet/servlet.FileDownload?file=01555000000fqoV';
        psdt6.Offer_Drawing_Name__c = 'OfferDrawing-OHVT-145C(3392)';
        psdt6.Part_Description__c = 'EHVS-145Three Piece Inline';
        psdt6.Pricing__c = 5616.00;
            documentTables.add(psdt6);
        
        insert documentTables;
        
             
        List<Part_Selector_Plastic_Clamps__c>   clampList = new List<Part_Selector_Plastic_Clamps__c>();
            Part_Selector_Plastic_Clamps__c pc1 = new Part_Selector_Plastic_Clamps__c();
            pc1.Name = 'Flat Mount';
        	pc1.Mounting_Version__c = 'FLAT MOUNT';
            pc1.Cable_Start_Range__c = 0;
            pc1.Cable_End_Range__c = 200;
            pc1.AUTHORIZED_DISTRIBUTOR__c = 987;
            pc1.ELITE_DISTRIBUTOR__c = 0;
            pc1.TRADE__c = 0;
         clampList.add(pc1);
        	Part_Selector_Plastic_Clamps__c pc2 = new Part_Selector_Plastic_Clamps__c();
            pc2.Name = 'FLAT MOUNT with Compression Springs 1';
        	pc2.Mounting_Version__c = 'FLAT MOUNT with Compression Springs';
            pc2.Cable_Start_Range__c = 0;
            pc2.Cable_End_Range__c = 200;
            pc2.AUTHORIZED_DISTRIBUTOR__c = 987;
            pc2.ELITE_DISTRIBUTOR__c = 0;
            pc2.TRADE__c = 0;        
        clampList.add(pc2);
        	Part_Selector_Plastic_Clamps__c pc3 = new Part_Selector_Plastic_Clamps__c();
            pc3.Name = 'SLIDER PLATE';
        	pc3.Mounting_Version__c = 'SLIDER PLATE';
            pc3.Cable_Start_Range__c = 0;
            pc3.Cable_End_Range__c = 200;
            pc3.AUTHORIZED_DISTRIBUTOR__c = 987;
            pc3.ELITE_DISTRIBUTOR__c = 0;
            pc3.TRADE__c = 0;        
        clampList.add(pc3);
        	Part_Selector_Plastic_Clamps__c pc4 = new Part_Selector_Plastic_Clamps__c();
            pc4.Name = 'STRUT NUT';
        	pc4.Mounting_Version__c = 'STRUT NUT';
            pc4.Cable_Start_Range__c = 0;
            pc4.Cable_End_Range__c = 200;
            pc4.AUTHORIZED_DISTRIBUTOR__c = 987;
            pc4.ELITE_DISTRIBUTOR__c = 0;
            pc4.TRADE__c = 0;        
        clampList.add(pc4);
        
        insert clampList;
        
        List<Part_Selector_Output_Price_Table__c> priceTables = new List<Part_Selector_Output_Price_Table__c>();
        Part_Selector_Output_Price_Table__c priceTable = new Part_Selector_Output_Price_Table__c();        
        priceTable.Name = 'EHVS-6920-W';
        priceTable.AUTHORIZED_DISTRIBUTOR__c = 546;
        priceTable.ELITE_DISTRIBUTOR__c = 546;
        priceTable.Trade__c = 454;
        priceTables.add(priceTable);
        
        Part_Selector_Output_Price_Table__c priceTable1 = new Part_Selector_Output_Price_Table__c();        
        priceTable1.Name = 'EHVT-690-SG';
        priceTable1.AUTHORIZED_DISTRIBUTOR__c = 546;
        priceTable1.ELITE_DISTRIBUTOR__c = 546;
        priceTable1.Trade__c = 454;
        priceTables.add(priceTable1);
        
        insert priceTables;
        ApexPages.StandardController sc = new ApexPages.StandardController(hvca);
        HVCAPartSelectorExtension hvcaExtension = new HVCAPartSelectorExtension(sc);
        PageReference pageRef = Page.HVCA_PartSelector2;
        //pageRef.getParameters().put('id', String.valueOf(testAccountPlanInsert.Id));
        Test.setCurrentPage(pageRef);
        Test.startTest();
            hvca.Splice_Conductor_OD__c =  55;  
            hvca.Splice_Insulation_OD__c =  55.5;
            hvcaExtension.save();
            hvca.Conductor_OD__c  = 14.5;
            hvca.Conductor_Type__c = 'Compact Diameter';
            hvca.Insulator_Type__c = 'Composite';
            hvca.Insulation_Material__c  = 'EPR';
        	hvca.Conductor_Material__c = 'Aluminum';
            hvca.Insulation_OD__c = 55.5;
            hvca.Outer_Jacket_OD__c = 85.5;
            hvca.Cable_Lug__c = '50 mm * 130 mm';
            hvca.Shielding_Type__c = 'Copper Wire';
            hvca.Termination_Operating_Voltage__c = '69';
            hvca.GIS_Operating_Voltage__c = '69';
        	hvca.Installation_Type__c = 'Heat Shrink';
        	hvca.Splice_Installation_Type__c = 'Heat Shrink';
        	hvca.GIS_Design__c = 'Transformer';
        	hvca.Creepage_distance__c = '6100';
        	hvca.Dry_Oil_Field__c = 'PHVX';
        	hvca.Housing_Length__c = '15';
            hvca.Conductor_Section__c = '650';        
            hvca.Splice_Operating_Voltage__c = '69';
            hvca.Splice_Size_Transition__c = 'Yes';
        	hvca.Splice_Design__c = 'Three Piece';   
        	hvca.Splice_Shield_Continuity__c = '10';
        	hvca.Splice_Outer_Protection__c = 'Wraparound';
            hvca.Splice_Type__c = 'Inline';
        	hvca.isFlatMount__c = true;
        	hvca.isTerminationChecked__c = true;
        	hvca.isSpliceChecked__c = true;
        	hvca.isGISChecked__c = true;
        	hvca.isAccessoriessChecked__c = true;
        	
            hvcaExtension.save();
        
            hvca.Termination_Operating_Voltage__c = '46';
           
            hvca.GIS_Operating_Voltage__c = '46';
            hvca.Application__c = 'Outdoor';
                  
            
            hvca.Splice_Shielding_Type__c = 'Copper Wire';
            hvcaExtension.save();
            hvcaExtension.upload();
            hvcaExtension.back();
            hvcaExtension.backToOpp();
            hvcaExtension.fetchConductorOd();
            hvcaExtension.spliceAdditionSection();
            hvcaExtension.toggleGISSection();
            hvcaExtension.toggleSpliceSection();
            hvcaExtension.toggleTransitionSection();
        	System.debug(hvcaExtension.eppaName);
        	System.debug(hvcaExtension.isShowEppa);
        	HVCAPartSelectorExtension.OutputWrapper output = new  HVCAPartSelectorExtension.OutputWrapper();
        output.priceMap =  new Map<String,HVCAPartSelectorExtension.OutputPriceWrapper>();
        	HVCAPartSelectorExtension.OutputPriceWrapper outprice = new HVCAPartSelectorExtension.OutputPriceWrapper();
			hvcaExtension.spliceHeatShrinkDocumentTable(output);    
        	hvcaExtension.terminationEHVTDcouments(output); 
        	hvcaExtension.terminationOutputPriceTable = new HVCAPartSelectorExtension.OutputPriceWrapper();
        	hvcaExtension.terminationOutputPriceTable.isTrade = true;
        	hvcaExtension.generateQuote();
        	hvcaExtension.saveRecord();
        	hvcaExtension.submitForApproval();
        	hvcaExtension.toggleAccessoriessSection();

        Test.stopTest();
    }
    
    public static testMethod void testExtension3(){
        HVCA_Part_Selector__c hvca = new HVCA_Part_Selector__c();
        
        
        Part_Selector_Conductor_OD__c psco =  new Part_Selector_Conductor_OD__c();
        psco.Name = '650';
        psco.Compact_Diameter__c = 0.845;
        psco.Compressed_Diameter__c = 0.901 ;
        psco.Concentric_Diameter__c = 0.929;
        insert psco;
        
        List<Part_Selector_Insulation_OD__c> insulationList = new List<Part_Selector_Insulation_OD__c>();
        Part_Selector_Insulation_OD__c psio = new Part_Selector_Insulation_OD__c();
        psio.Name = 'Termination_1';
        psio.Start_Range__c  = 53;
        psio.End_Range__c = 58;
        psio.Type__c = 'Termination';
            insulationList.add(psio);
        
        Part_Selector_Insulation_OD__c psio2 = new Part_Selector_Insulation_OD__c();
        psio2.Start_Range__c = 53;
        psio2.End_Range__c = 58;
        psio2.Name = 'Splice1';
        psio2.Type__c = 'Splice';
        psio2.Voltage__c = '145';
            insulationList.add(psio2);        
            
        insert insulationList;
        
        List<PartSelectorOutput__c> partSelectorOutputs = new List<PartSelectorOutput__c>();
        PartSelectorOutput__c pso = new PartSelectorOutput__c();
        pso.Name = 'Composite';
        pso.Output__c = 'C';
            partSelectorOutputs.add(pso);
        PartSelectorOutput__c pso1 = new PartSelectorOutput__c();
        pso1.Name = 'EPR';
        pso1.Output__c = 'E';
            partSelectorOutputs.add(pso1);        
        PartSelectorOutput__c pso2 = new PartSelectorOutput__c();
        pso2.Name = 'Copper Wire';
        pso2.Output__c = 'W';
            partSelectorOutputs.add(pso2);
        PartSelectorOutput__c pso3 = new PartSelectorOutput__c();
        pso3.Name = '50 mm * 130 mm';
        pso3.Output__c = 'I';
            partSelectorOutputs.add(pso3);
              PartSelectorOutput__c pso4 = new PartSelectorOutput__c();
        pso4.Name = 'Three Piece';
        pso4.Output__c = 'I';
        	partSelectorOutputs.add(pso4); 
        
        PartSelectorOutput__c pso5 = new PartSelectorOutput__c();
        pso5.Name = 'Wraparound';
        pso5.Output__c = 'W';
        	partSelectorOutputs.add(pso5); 
        
        insert partSelectorOutputs;
        
        List<Part_Selector_46_69_Output__c> partSelector46_69Outputs = new List<Part_Selector_46_69_Output__c> ();        
        Part_Selector_46_69_Output__c psOutput1 = new Part_Selector_46_69_Output__c();
        psOutput1.Type__c = 'Terminal_InsulationOD';
        psOutput1.Start_Range__c  =50;
        psOutput1.End_Range__c = 58;
        psOutput1.Name = 'Terminal_InsulationOD_3';
        psOutput1.Output__c ='D';
            partSelector46_69Outputs.add(psOutput1);
        
        Part_Selector_46_69_Output__c psOutput2 = new Part_Selector_46_69_Output__c();
        psOutput2.Type__c = 'Splice_InsulationOD';
        psOutput2.Start_Range__c  =52;
        psOutput2.End_Range__c = 58;
        psOutput2.Name = 'Splice_InsulationOD_2';
        psOutput2.Output__c = 'C';
            partSelector46_69Outputs.add(psOutput2);
        
        Part_Selector_46_69_Output__c psOutput3 = new Part_Selector_46_69_Output__c();
        psOutput3.Type__c = 'GIS_InsulationOD';
        psOutput3.Start_Range__c  =50;
        psOutput3.End_Range__c = 57;
        psOutput3.Name = 'GIS_InsulationOD';
        psOutput3.Output__c = 'E';
            partSelector46_69Outputs.add(psOutput3);
        
        insert partSelector46_69Outputs;
        
        List<Part_Selector_Document_Table__c> documentTables = new List<Part_Selector_Document_Table__c>();
        Part_Selector_Document_Table__c psdt = new Part_Selector_Document_Table__c();
        psdt.Name = 'OHVT-145C';
        psdt.Offer_Drawing__c = '/servlet/servlet.FileDownload?file=01555000000fqoV';
        psdt.Offer_Drawing_Name__c = 'OfferDrawing-OHVT-145C(3392)';
        psdt.Part_Description__c = 'OHVT-145C';
        psdt.Pricing__c = 5616.00;
            documentTables.add(psdt);
        
        Part_Selector_Document_Table__c psdt7 = new Part_Selector_Document_Table__c();
        psdt7.Name = 'EHVS-Inline';
        psdt7.Offer_Drawing__c = '/servlet/servlet.FileDownload?file=01555000000fqoV';
        psdt7.Offer_Drawing_Name__c = 'OfferDrawing-OHVT-145C(3392)';
        psdt7.Part_Description__c = 'EHVS-Inline';
        psdt7.Pricing__c = 5616.00;
            documentTables.add(psdt7);
        
          
        Part_Selector_Document_Table__c psdt8 = new Part_Selector_Document_Table__c();
        psdt8.Name = 'PHVX-145';
        psdt8.Offer_Drawing__c = '/servlet/servlet.FileDownload?file=01555000000fqoV';
        psdt8.Offer_Drawing_Name__c = 'OfferDrawing-OHVT-145C(3392)';
        psdt8.Part_Description__c = 'PHVX-145';
        psdt8.Pricing__c = 5616.00;
            documentTables.add(psdt8);
        
        Part_Selector_Document_Table__c psdt2 = new Part_Selector_Document_Table__c();
        psdt2.Name = 'EHVS-145C SB';
        psdt2.Offer_Drawing__c = '/servlet/servlet.FileDownload?file=01555000000fqoV';
        psdt2.Offer_Drawing_Name__c = 'OfferDrawing-OHVT-145C(3392)';
        psdt2.Part_Description__c = 'EHVS-145T Inline';
        psdt2.Pricing__c = 5616.00;
            documentTables.add(psdt2);
        
        Part_Selector_Document_Table__c psdt3 = new Part_Selector_Document_Table__c();
        psdt3.Name = 'EHVT-Indoor';
        psdt3.Offer_Drawing__c = '/servlet/servlet.FileDownload?file=01555000000fqoV';
        psdt3.Offer_Drawing_Name__c = 'OfferDrawing-OHVT-145C(3392)';
        psdt3.Part_Description__c = 'EHVT-Indoor';
        psdt3.Pricing__c = 5616.00;
            documentTables.add(psdt3);
        
        Part_Selector_Document_Table__c psdt4 = new Part_Selector_Document_Table__c();
        psdt4.Name = 'OHVT-46C';
        psdt4.Offer_Drawing__c = '/servlet/servlet.FileDownload?file=01555000000fqoV';
        psdt4.Offer_Drawing_Name__c = 'OfferDrawing-OHVT-145C(3392)';
        psdt4.Part_Description__c = 'OHVT-46C';
        psdt4.Pricing__c = 5616.00;
            documentTables.add(psdt4);
        
        Part_Selector_Document_Table__c psdt5 = new Part_Selector_Document_Table__c();
        psdt5.Name = 'PHVX-46';
        psdt5.Offer_Drawing__c = '/servlet/servlet.FileDownload?file=01555000000fqoV';
        psdt5.Offer_Drawing_Name__c = 'OfferDrawing-OHVT-145C(3392)';
        psdt5.Part_Description__c = 'PHVX-46';
        psdt5.Pricing__c = 5616.00;
            documentTables.add(psdt5);
        
        Part_Selector_Document_Table__c psdt6 = new Part_Selector_Document_Table__c();
        psdt6.Name = 'EHVS-145Three ';
        psdt6.Offer_Drawing__c = '/servlet/servlet.FileDownload?file=01555000000fqoV';
        psdt6.Offer_Drawing_Name__c = 'OfferDrawing-OHVT-145C(3392)';
        psdt6.Part_Description__c = 'EHVS-145Three Piece Inline';
        psdt6.Pricing__c = 5616.00;
            documentTables.add(psdt6);
        
        insert documentTables;
        
             
        List<Part_Selector_Plastic_Clamps__c>   clampList = new List<Part_Selector_Plastic_Clamps__c>();
            Part_Selector_Plastic_Clamps__c pc1 = new Part_Selector_Plastic_Clamps__c();
            pc1.Name = 'Flat Mount';
        	pc1.Mounting_Version__c = 'FLAT MOUNT';
            pc1.Cable_Start_Range__c = 0;
            pc1.Cable_End_Range__c = 200;
            pc1.AUTHORIZED_DISTRIBUTOR__c = 987;
            pc1.ELITE_DISTRIBUTOR__c = 0;
            pc1.TRADE__c = 0;
         clampList.add(pc1);
        	Part_Selector_Plastic_Clamps__c pc2 = new Part_Selector_Plastic_Clamps__c();
            pc2.Name = 'FLAT MOUNT with Compression Springs 1';
        	pc2.Mounting_Version__c = 'FLAT MOUNT with Compression Springs';
            pc2.Cable_Start_Range__c = 0;
            pc2.Cable_End_Range__c = 200;
            pc2.AUTHORIZED_DISTRIBUTOR__c = 987;
            pc2.ELITE_DISTRIBUTOR__c = 0;
            pc2.TRADE__c = 0;        
        clampList.add(pc2);
        	Part_Selector_Plastic_Clamps__c pc3 = new Part_Selector_Plastic_Clamps__c();
            pc3.Name = 'SLIDER PLATE';
        	pc3.Mounting_Version__c = 'SLIDER PLATE';
            pc3.Cable_Start_Range__c = 0;
            pc3.Cable_End_Range__c = 200;
            pc3.AUTHORIZED_DISTRIBUTOR__c = 987;
            pc3.ELITE_DISTRIBUTOR__c = 0;
            pc3.TRADE__c = 0;        
        clampList.add(pc3);
        	Part_Selector_Plastic_Clamps__c pc4 = new Part_Selector_Plastic_Clamps__c();
            pc4.Name = 'STRUT NUT';
        	pc4.Mounting_Version__c = 'STRUT NUT';
            pc4.Cable_Start_Range__c = 0;
            pc4.Cable_End_Range__c = 200;
            pc4.AUTHORIZED_DISTRIBUTOR__c = 987;
            pc4.ELITE_DISTRIBUTOR__c = 0;
            pc4.TRADE__c = 0;        
        clampList.add(pc4);
        
        insert clampList;
        
        List<Part_Selector_Output_Price_Table__c> priceTables = new List<Part_Selector_Output_Price_Table__c>();
        Part_Selector_Output_Price_Table__c priceTable = new Part_Selector_Output_Price_Table__c();        
        priceTable.Name = 'EHVS-6920-W';
        priceTable.AUTHORIZED_DISTRIBUTOR__c = 546;
        priceTable.ELITE_DISTRIBUTOR__c = 546;
        priceTable.Trade__c = 454;
        priceTables.add(priceTable);
        
        Part_Selector_Output_Price_Table__c priceTable1 = new Part_Selector_Output_Price_Table__c();        
        priceTable1.Name = 'EHVT-690-SG';
        priceTable1.AUTHORIZED_DISTRIBUTOR__c = 546;
        priceTable1.ELITE_DISTRIBUTOR__c = 546;
        priceTable1.Trade__c = 454;
        priceTables.add(priceTable1);
        
        insert priceTables;
      
        
        Test.startTest();
            hvca.Splice_Conductor_OD__c =  55;  
            hvca.Splice_Insulation_OD__c =  55.5;
            hvca.Conductor_OD__c  = 14.5;
            hvca.Conductor_Type__c = 'Compact Diameter';
            hvca.Insulator_Type__c = 'Composite';
            hvca.Insulation_Material__c  = 'EPR';
        	hvca.Conductor_Material__c = 'Aluminum';
            hvca.Insulation_OD__c = 55.5;
            hvca.Outer_Jacket_OD__c = 85.5;
            hvca.Cable_Lug__c = '50 mm * 130 mm';
            hvca.Shielding_Type__c = 'Copper Wire';
            hvca.Termination_Operating_Voltage__c = '69';
            hvca.GIS_Operating_Voltage__c = '69';
        	hvca.Installation_Type__c = 'Heat Shrink';
        	hvca.Splice_Installation_Type__c = 'Heat Shrink';
        	hvca.GIS_Design__c = 'Transformer';
        	hvca.Creepage_distance__c = '6100';
        	hvca.Dry_Oil_Field__c = 'PHVX';
        	hvca.Housing_Length__c = '15';
            hvca.Conductor_Section__c = '650';        
            hvca.Splice_Operating_Voltage__c = '69';
            hvca.Splice_Size_Transition__c = 'Yes';
        	hvca.Splice_Design__c = 'Three Piece';   
        	hvca.Splice_Shield_Continuity__c = '10';
        	hvca.Splice_Outer_Protection__c = 'Wraparound';
            hvca.Splice_Type__c = 'Inline';
        	hvca.isFlatMount__c = true;
        	hvca.isTerminationChecked__c = true;
        	hvca.isSpliceChecked__c = true;
        	hvca.isGISChecked__c = true;
        	hvca.isAccessoriessChecked__c = true;
        	hvca.Termination_List_Price__c  = 100;
            hvca.Application__c = 'Outdoor';
                  
            
            hvca.Splice_Shielding_Type__c = 'Copper Wire';
        	insert hvca;
            PageReference pageRef = Page.HVCA_GenerateQuote;
            pageRef.getParameters().put('hvcaId', String.valueOf(hvca.Id));
            Test.setCurrentPage(pageRef);
            ApexPages.StandardController sc = new ApexPages.StandardController(hvca);
            HVCAPartSelectorExtension hvcaExtension = new HVCAPartSelectorExtension(sc);           
            hvcaExtension.upload();
            hvcaExtension.back();
            hvcaExtension.backToOpp();
            hvcaExtension.fetchConductorOd();
            hvcaExtension.spliceAdditionSection();
            hvcaExtension.toggleGISSection();
            hvcaExtension.toggleSpliceSection();
            hvcaExtension.toggleTransitionSection();
        	System.debug(hvcaExtension.eppaName);
        	System.debug(hvcaExtension.isShowEppa);
        	HVCAPartSelectorExtension.OutputWrapper output = new  HVCAPartSelectorExtension.OutputWrapper();
        output.priceMap =  new Map<String,HVCAPartSelectorExtension.OutputPriceWrapper>();
        	HVCAPartSelectorExtension.OutputPriceWrapper outprice = new HVCAPartSelectorExtension.OutputPriceWrapper();
			hvcaExtension.spliceHeatShrinkDocumentTable(output);    
        	hvcaExtension.terminationEHVTDcouments(output); 
        	hvcaExtension.terminationOutputPriceTable = new HVCAPartSelectorExtension.OutputPriceWrapper();
        	hvcaExtension.terminationOutputPriceTable.isTrade = true;
        	hvcaExtension.generateQuote();
        	hvcaExtension.saveRecord();
        	hvcaExtension.submitForApproval();
        	hvcaExtension.toggleAccessoriessSection();
        	hvca.Approval_Status__c = 'Approvad';
        	hvca.Offered_Price__c = 150;
        	update hvca;
        	hvca.Approval_Status__c = 'Rejected';
        	update hvca;

        Test.stopTest();
    }
}