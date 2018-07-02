global class ClsOEMUtil {
    //03-19-2014 Michael Cui: update on DetectOverlappingOEMMapRules method to fix OEM calcutaion production issue.  remove the if logic 
    //when populate 4 static maps(Custmap, PNmap, WWAC_PNmap, Cust_PNmap).
    
    public static list<OEM_Mapping_Rule__c> listOEMMapBatchInput;
    public static Integer CurrentFM;
    public static String CurrentFY;
    public static Boolean checkForActive = false;
    //public static map<string, map<id, set<string>>> WWACmap = new map<string, map<id, set<string>>>();
    public static map<string, set<string>> Custmap = new map<string, set<string>>();
    public static map<string, set<id>> PNmap = new map<string, set<Id>>();
    public static map<string, set<string>> WWAC_PNmap = new map<string, set<string>>();
    public static map<string, set<string>> Cust_PNmap = new map<string, set<string>>();                     
    public static final map<Integer, String> MAP_MONTH = new map<Integer, String>{
        1 => 'Oct',
        2 => 'Nov',
        3 => 'Dec',
        4 => 'Jan',
        5 => 'Feb',
        6 => 'Mar',
        7 => 'Apr',
        8 => 'May',
        9 => 'Jun',
        10 => 'Jul',
        11 => 'Aug',
        12 => 'Sep'        
    };          
    public static final map<String, Integer> MAP_MONTHLABELNUMBER = new map<String, Integer>{
        'Jan' => 4,
        'Feb' => 5,
        'Mar' => 6,
        'Apr' => 7,
        'May' => 8,
        'Jun' => 9,
        'Jul' => 10,
        'Aug' => 11,
        'Sep' => 12,
        'Oct' => 1,
        'Nov' => 2,
        'Dec' => 3
    };    
     public static final map<String, Integer> MAP_MONTHCALENDARNUMBER = new map<String, Integer>{
        'Jan' => 1,
        'Feb' => 2,
        'Mar' => 3,
        'Apr' => 4,
        'May' => 5,
        'Jun' => 6,
        'Jul' => 7,
        'Aug' => 8,
        'Sep' => 9,
        'Oct' => 10,
        'Nov' => 11,
        'Dec' => 12
    };   

    //Validation routine checking if mappings match criteria with any lower priority mappings
    //according only to values evaluated by the lower priority type
    public static list<OEM_Mapping_Rule__c> ValidateOEMMapRulesByType(list<OEM_Mapping_Rule__c> ListAll)
    {
        list<OEM_Mapping_Rule__c> UseMaps = new list<OEM_Mapping_Rule__c>();
        list<OEM_Mapping_Rule__c> DeleteMaps = new list<OEM_Mapping_Rule__c>();
        
        map<string, integer> TypeRank = new map<String, integer>();
        TypeRank.put('WWAC', 1);
        TypeRank.put('Customer', 2);
        TypeRank.put('PN', 3);
        TypeRank.put('WWAC+PN', 4);
        TypeRank.put('Customer+PN', 5);
        
        map<String, OEM_Mapping_Rule__c> DerivedKeys = new map<String, OEM_Mapping_Rule__c>();
        
        map<String, OEM_Mapping_Rule__c> TypeMap = new map<String, OEM_Mapping_Rule__c>();
        
        system.debug('***** JNV - ' + ListAll.size());
        
        //filter out duplicates and overrides
        for(OEM_Mapping_Rule__c oem : ListAll) 
        {
            String tempKey = string.valueOf(oem.OEM__r.OEM__r.Id);
            Id OEMAcctId = oem.OEM__r.OEM__r.Id;
            oem.Tech_Isvalid__c = true;
            
            if(oem.Type__c == 'WWAC')
            {
                tempKey += oem.WWAC__c;
                if(!DerivedKeys.containskey(tempKey))
                {
                    DerivedKeys.put(tempKey, oem);
                }
            }
            else if(oem.Type__c == 'Customer')
            {
                //Customer level
                tempKey += oem.Sold_To_Account_Code__c.leftpad(8).replace(' ', '0') ;
                if(!DerivedKeys.containskey(tempKey))
                {
                    DerivedKeys.put(tempKey, oem);
                }
                else 
                {
                    if(TypeRank.get(DerivedKeys.get(tempKey).Type__c) < TypeRank.get('Customer'))
                    {
                        DerivedKeys.put(tempKey, oem);
                    }
                }                       
            }       
            else if(oem.Type__c == 'PN')
            {
                //PN Level
                tempKey += string.valueOf(oem.Part_Number__c);
                if(!DerivedKeys.containskey(tempKey))
                {
                    DerivedKeys.put(tempKey, oem);
                }
                else 
                {
                    if(TypeRank.get(DerivedKeys.get(tempKey).Type__c) < TypeRank.get('PN'))
                    {
                        DerivedKeys.put(tempKey, oem);
                    }
                }               
            }
            else if(oem.Type__c == 'WWAC+PN')
            {
                //2014-04-03 Michael Cui: comments.
                //WWAC level
                /*
                tempKey = string.valueOf(oem.OEM__r.OEM__r.Id) + oem.WWAC__c;
                if(!DerivedKeys.containskey(tempKey))
                {
                    DerivedKeys.put(tempKey, oem);
                }
                else 
                {
                    if(TypeRank.get(DerivedKeys.get(tempKey).Type__c) < TypeRank.get('WWAC+PN'))
                    {
                        DerivedKeys.put(tempKey, oem);
                    }
                }
                
                //PN level
                tempKey = string.valueOf(oem.OEM__r.OEM__r.Id) + string.valueOf(oem.Part_Number__c);
                if(!DerivedKeys.containskey(tempKey))
                {
                    DerivedKeys.put(tempKey, oem);
                }
                else 
                {
                    if(TypeRank.get(DerivedKeys.get(tempKey).Type__c) < TypeRank.get('WWAC+PN'))
                    {
                        DerivedKeys.put(tempKey, oem);
                    }
                }*/
                
                //Combination
                tempKey = string.valueOf(oem.OEM__r.OEM__r.Id) + oem.WWAC__c + string.valueOf(oem.Part_Number__c);
                if(!DerivedKeys.containskey(tempKey))
                {
                    DerivedKeys.put(tempKey, oem);
                }
                else 
                {
                    if(TypeRank.get(DerivedKeys.get(tempKey).Type__c) < TypeRank.get('WWAC+PN'))
                    {
                        DerivedKeys.put(tempKey, oem);
                    }
                }                                           
            }
            else if(oem.Type__c == 'Customer+PN')
            {
                //2014-04-03 Michael Cui: comments.
                //Customer level
                /*
                tempKey = string.valueOf(oem.OEM__r.OEM__r.Id) + oem.Sold_To_Account_Code__c.leftpad(8).replace(' ', '0') ;
                if(!DerivedKeys.containskey(tempKey))
                {
                    DerivedKeys.put(tempKey, oem);
                }
                else 
                {
                    if(TypeRank.get(DerivedKeys.get(tempKey).Type__c) < TypeRank.get('Customer+PN'))
                    {
                        DerivedKeys.put(tempKey, oem);
                    }
                }
                
                //PN level
                tempKey = string.valueOf(oem.OEM__r.OEM__r.Id) + string.valueOf(oem.Part_Number__c);
                if(!DerivedKeys.containskey(tempKey))
                {
                    DerivedKeys.put(tempKey, oem);
                }
                else 
                {
                    if(TypeRank.get(DerivedKeys.get(tempKey).Type__c) < TypeRank.get('Customer+PN'))
                    {
                        DerivedKeys.put(tempKey, oem);
                    }
                }*/
                
                //Combination
                tempKey = string.valueOf(oem.OEM__r.OEM__r.Id) + oem.Sold_To_Account_Code__c.leftpad(8).replace(' ', '0')  + string.valueOf(oem.Part_Number__c);
                if(!DerivedKeys.containskey(tempKey))
                {
                    DerivedKeys.put(tempKey, oem);
                }
                else 
                {
                    if(TypeRank.get(DerivedKeys.get(tempKey).Type__c) < TypeRank.get('Customer+PN'))
                    {
                        DerivedKeys.put(tempKey, oem);
                    }
                }
            }                                           
        }
        
        for(OEM_Mapping_Rule__c del : ListAll)
        {
            if(del.Type__c == 'WWAC')
            {
                if(del.id <> DerivedKeys.get(string.valueOf(del.OEM__r.OEM__r.Id) + del.WWAC__c).id)
                {
                    DeleteMaps.add(del);
                    //del.Tech_Isvalid__c = false;
                }
                else
                {
                    UseMaps.add(del);
                    //del.Tech_Isvalid__c = true;
                    //system.debug('***** JNV ' + del.id);
                }
            }
            else if(del.Type__c == 'Customer')
            {
                if(del.id <> DerivedKeys.get(string.valueOf(del.OEM__r.OEM__r.Id) + del.Sold_To_Account_Code__c.leftpad(8).replace(' ', '0') ).id)
                {
                    DeleteMaps.add(del);
                    //del.Tech_Isvalid__c = false;
                }
                else
                {
                    UseMaps.add(del);
                    //del.Tech_Isvalid__c = true;
                    //system.debug('***** JNV ' + del.id);
                }               
            }       
            else if(del.Type__c == 'PN')
            {
                if(del.id <> DerivedKeys.get(string.valueOf(del.OEM__r.OEM__r.Id) + string.valueOf(del.Part_Number__c)).id)
                {
                    DeleteMaps.add(del);
                    //del.Tech_Isvalid__c = false;
                }
                else
                {
                    UseMaps.add(del);
                    //del.Tech_Isvalid__c = true;
                    //system.debug('***** JNV ' + del.id);
                }               
            }
            else if(del.Type__c == 'WWAC+PN')
            {
                if(del.id <> DerivedKeys.get(string.valueOf(del.OEM__r.OEM__r.Id) + del.WWAC__c + string.valueOf(del.Part_Number__c)).id)
                {
                    DeleteMaps.add(del);
                    //del.Tech_Isvalid__c = false;
                }
                else
                {
                    UseMaps.add(del);
                    //del.Tech_Isvalid__c = true;
                    //system.debug('***** JNV ' + del.id);
                }               
            }
            else if(del.Type__c == 'Customer+PN')
            {               
                if(del.id <> DerivedKeys.get(string.valueOf(del.OEM__r.OEM__r.Id) + del.Sold_To_Account_Code__c.leftpad(8).replace(' ', '0')  + string.valueOf(del.Part_Number__c)).id)
                {
                    DeleteMaps.add(del);
                    //del.Tech_Isvalid__c = false;
                }
                else
                {
                    UseMaps.add(del);
                    //del.Tech_Isvalid__c = true;
                    //system.debug('***** JNV ' + del.id);
                }   
            }           
        }
        
        system.debug('***** JNV All - ' + ListAll.size());
        system.debug('***** JNV Valid - ' + UseMaps.size());
        system.debug('***** JNV Delete - ' + DeleteMaps.size());

        //Database.Update(ListAll);
        /*try 
        {           
            Database.Delete(deletemaps);   
        }
        catch(Exception ex){
            system.debug('exception: ' + ex.GetMessage());
        } */         
        
        return UseMaps;             
    }   
    
    public static void DetectOverlappingOEMMapRules(list<OEM_Mapping_Rule__c> ListAll)
    {           
        map<String, OEM_Mapping_Rule__c> DerivedKeys = new map<String, OEM_Mapping_Rule__c>();
                
        system.debug('***** JNV - ' + ListAll.size());
        
        //filter out  overrides
        for(OEM_Mapping_Rule__c oem : ListAll) 
        {                   
            /*if(oem.Type__c == 'WWAC')
            {
                tempKey = oem.WWAC__c;
                if(!DerivedKeys.containskey(tempKey))
                {
                    DerivedKeys.put(tempKey, oem);
                }                                                           
            }
            else */
            if(oem.Type__c == 'Customer')
            {
                if(oem.WWAC__c == null && !CustMap.containskey('blankW'))
                {
                    CustMap.put('blankW', new set<string>());
                    CustMap.get('blankW').add(oem.Sold_To_Account_Code__c.leftpad(8).replace(' ', '0'));                    
                }
                else if(oem.WWAC__c == null)
                {
                    CustMap.get('blankW').add(oem.Sold_To_Account_Code__c.leftpad(8).replace(' ', '0'));                    
                }
                //03-19-2014 Michael Cui: comments the check on WWAC__c
                /*
                else if(!CustMap.containskey(oem.WWAC__c))
                {
                    CustMap.put(oem.WWAC__c, new set<string>());
                    CustMap.get(oem.WWAC__c).add(oem.Sold_To_Account_Code__c.leftpad(8).replace(' ', '0'));
                }               
                else
                {
                    CustMap.get(oem.WWAC__c).add(oem.Sold_To_Account_Code__c.leftpad(8).replace(' ', '0'));
                }*/
                //03-19-2014 Michael Cui: added
                else if(!CustMap.containskey('haveW'))
                {
                    CustMap.put('haveW', new set<string>());
                    CustMap.get('haveW').add(oem.Sold_To_Account_Code__c.leftpad(8).replace(' ', '0'));
                }               
                else
                {
                    CustMap.get('haveW').add(oem.Sold_To_Account_Code__c.leftpad(8).replace(' ', '0'));
                }                                                                               
            }       
            else if(oem.Type__c == 'PN')
            {
                //03-19-2014 Michael Cui:comments the check on Sold_To_Account_Code__c, WWAC__c
                /*
                if(oem.Sold_To_Account_Code__c == null && !PNMap.containskey('blankC'))
                {
                    PNMap.put('blankC', new set<id>());
                    PNMap.get('blankC').add(oem.Part_Number__c);                    
                }
                else if(oem.Sold_To_Account_Code__c == null)
                {
                    PNMap.get('blankC').add(oem.part_number__c);                    
                }
                else if(!PNMap.containskey(oem.Sold_To_Account_Code__c.leftpad(8).replace(' ', '0') ))
                {
                    PNMap.put(oem.Sold_To_Account_Code__c.leftpad(8).replace(' ', '0') , new set<id>());
                    PNMap.get(oem.Sold_To_Account_Code__c.leftpad(8).replace(' ', '0') ).add(oem.Part_Number__c);
                }               
                else
                {
                    PNMap.get(oem.Sold_To_Account_Code__c.leftpad(8).replace(' ', '0') ).add(oem.Part_Number__c);
                }               

                if(oem.WWAC__c == null && !PNMap.containskey('blankW'))
                {
                    PNMap.put('blankW', new set<id>());
                    PNMap.get('blankW').add(oem.Part_Number__c);                    
                }
                else if(oem.WWAC__c == null)
                {
                    PNMap.get('blankW').add(oem.Part_Number__c);                
                }
                else if(!PNMap.containskey(oem.WWAC__c))
                {
                    PNMap.put(oem.WWAC__c, new set<id>());
                    PNMap.get(oem.WWAC__c).add(oem.Part_Number__c);
                }               
                else
                {
                    PNMap.get(oem.WWAC__c).add(oem.Part_Number__c);
                }*/
                //03-19-2014 Michael Cui: added
                if(!PNMap.containskey('PN'))
                {
                    PNMap.put('PN', new set<id>());
                    PNMap.get('PN').add(oem.Part_Number__c);                    
                }
                else 
                {
                    PNMap.get('PN').add(oem.part_number__c);                    
                }                                                   
            }
            else if(oem.Type__c == 'WWAC+PN')
            {   
                //Part Level
                //2014-04-02 Michael Cui
                /*            
                if(oem.Part_Number__c != null)
                {
                    if(!WWAC_PNMap.containskey(oem.Part_Number__c))
                    {
                        WWAC_PNMap.put(oem.Part_Number__c, new set<string>());
                        WWAC_PNMap.get(oem.Part_Number__c).add(oem.wwac__c.leftpad(8).replace(' ', '0') + string.valueOf(oem.Part_Number__c));
                    }
                    else
                    {   
                        WWAC_PNMap.get(oem.Part_Number__c).add(oem.wwac__c.leftpad(8).replace(' ', '0') + string.valueOf(oem.Part_Number__c));
                    }
                }
                
                //WWAC Level            
                if(oem.WWAC__c != null)
                {
                    if(!WWAC_PNMap.containskey(oem.WWAC__c))
                    {
                        WWAC_PNMap.put(oem.WWAC__c, new set<string>());
                        WWAC_PNMap.get(oem.WWAC__c).add(oem.wwac__c.leftpad(8).replace(' ', '0') + string.valueOf(oem.Part_Number__c));
                    }
                    else
                    {   
                        WWAC_PNMap.get(oem.WWAC__c).add(oem.wwac__c.leftpad(8).replace(' ', '0') + string.valueOf(oem.Part_Number__c));
                    }
                }*/                               
                //03-19-2014 Michael Cui:comments the check on Sold_To_Account_Code__c
                //Customer Level
                /*            
                if(oem.Sold_To_Account_Code__c == null && !WWAC_PNMap.containskey('blankC'))
                {
                    WWAC_PNMap.put('blankC', new set<string>());
                    WWAC_PNMap.get('blankC').add(oem.WWAC__c.leftpad(8).replace(' ', '0') + string.valueOf(oem.Part_Number__c));                    
                }
                else if(oem.Sold_To_Account_Code__c == null)
                {
                    WWAC_PNMap.get('blankC').add(oem.WWAC__c.leftpad(8).replace(' ', '0') + string.valueOf(oem.Part_Number__c));                    
                }
                else if(!WWAC_PNMap.containskey(oem.Sold_To_Account_Code__c.leftpad(8).replace(' ', '0') ))
                {
                    WWAC_PNMap.put(oem.Sold_To_Account_Code__c.leftpad(8).replace(' ', '0') , new set<string>());
                    WWAC_PNMap.get(oem.Sold_To_Account_Code__c.leftpad(8).replace(' ', '0') ).add(oem.WWAC__c.leftpad(8).replace(' ', '0') + string.valueOf(oem.Part_Number__c));
                }               
                else
                {
                    WWAC_PNMap.get(oem.Sold_To_Account_Code__c.leftpad(8).replace(' ', '0') ).add(oem.WWAC__c.leftpad(8).replace(' ', '0') + string.valueOf(oem.Part_Number__c));
                }*/
                //03-19-2014 Michael Cui: added
                if(!WWAC_PNMap.containskey('WWACPN'))
                {
                    WWAC_PNMap.put('WWACPN', new set<string>());
                    WWAC_PNMap.get('WWACPN').add(oem.wwac__c.leftpad(8).replace(' ', '0') + string.valueOf(oem.Part_Number__c));
                }
                else
                {   
                    WWAC_PNMap.get('WWACPN').add(oem.wwac__c.leftpad(8).replace(' ', '0') + string.valueOf(oem.Part_Number__c));
                }                   
                
            }
            else if(oem.Type__c == 'Customer+PN')
            {
                //Customer level
                //2014-04-02 Michael Cui
                /*
                if(oem.Sold_To_Account_Code__c != null)
                {
                    if(!Cust_PNMap.containskey(oem.Sold_To_Account_Code__c.leftpad(8).replace(' ', '0') ))
                    {
                        Cust_PNMap.put(oem.Sold_To_Account_Code__c.leftpad(8).replace(' ', '0') , new set<string>());
                        Cust_PNMap.get(oem.Sold_To_Account_Code__c.leftpad(8).replace(' ', '0') ).add(oem.Sold_To_Account_Code__c.leftpad(8).replace(' ', '0') + string.valueOf(oem.Part_Number__c));
                    }
                    else
                    {   
                        Cust_PNMap.get(oem.Sold_To_Account_Code__c.leftpad(8).replace(' ', '0') ).add(oem.Sold_To_Account_Code__c.leftpad(8).replace(' ', '0') + string.valueOf(oem.Part_Number__c));
                    }
                }                   
                
                //PN level              
                if(oem.Part_Number__c != null)
                {
                    if(!Cust_PNMap.containskey(oem.Part_Number__c))
                    {
                        Cust_PNMap.put(oem.Part_Number__c, new set<string>());
                        Cust_PNMap.get(oem.Part_Number__c).add(oem.Sold_To_Account_Code__c.leftpad(8).replace(' ', '0') + string.valueOf(oem.Part_Number__c));
                    }
                    else
                    {   
                        Cust_PNMap.get(oem.Part_Number__c).add(oem.Sold_To_Account_Code__c.leftpad(8).replace(' ', '0') + string.valueOf(oem.Part_Number__c));
                    }
                }                               
                */
                //2014-03-19:Michael Cui: comments checking on WWAC__c
                //WWAC level
                /*
                if(oem.WWAC__c == null && !Cust_PNMap.containskey('blankW'))
                {
                    Cust_PNMap.put('blankW', new set<string>());
                    Cust_PNMap.get('blankW').add(oem.Sold_To_Account_Code__c.leftpad(8).replace(' ', '0') + string.valueOf(oem.Part_Number__c));                    
                }
                else if(oem.WWAC__c == null)
                {
                    Cust_PNMap.get('blankW').add(oem.Sold_To_Account_Code__c.leftpad(8).replace(' ', '0') + string.valueOf(oem.Part_Number__c));                    
                }
                else if(!Cust_PNMap.containskey(oem.WWAC__c))
                {
                    Cust_PNMap.put(oem.WWAC__c, new set<string>());
                    Cust_PNMap.get(oem.WWAC__c).add(oem.Sold_To_Account_Code__c.leftpad(8).replace(' ', '0') + string.valueOf(oem.Part_Number__c));
                }               
                else
                {   
                    Cust_PNMap.get(oem.WWAC__c).add(oem.Sold_To_Account_Code__c.leftpad(8).replace(' ', '0') + string.valueOf(oem.Part_Number__c));
                }*/
                //03-19-2014 Michael Cui: added
                if(!Cust_PNMap.containskey('CustomerPN'))
                {
                    Cust_PNMap.put('CustomerPN', new set<string>());
                    Cust_PNMap.get('CustomerPN').add(oem.Sold_To_Account_Code__c.leftpad(8).replace(' ', '0') + string.valueOf(oem.Part_Number__c));
                }
                else
                {   
                    Cust_PNMap.get('CustomerPN').add(oem.Sold_To_Account_Code__c.leftpad(8).replace(' ', '0') + string.valueOf(oem.Part_Number__c));
                }                                                       
            }                                           
        }       
    }   

    //relic, in case they really do care if non-criteria values on mappings of certain types overlap
    
    //Validation routine checking if mappings match criteria with any lower priority mappings
    //according only to values evaluated by the higher priority type
    //blank values do not count as a match
    public static list<OEM_Mapping_Rule__c> ValidateOEMMapRulesByValues(list<OEM_Mapping_Rule__c> ListAll)
    {
        list<OEM_Mapping_Rule__c> UseMaps = new list<OEM_Mapping_Rule__c>();
        list<OEM_Mapping_Rule__c> DeleteMaps = new list<OEM_Mapping_Rule__c>();
        
        map<string, integer> TypeRank = new map<String, integer>();
        TypeRank.put('WWAC', 1);
        TypeRank.put('Customer', 2);
        TypeRank.put('PN', 3);
        TypeRank.put('WWAC+PN', 4);
        TypeRank.put('Customer+PN', 5);
        
        map<id, string> DerivedKey = new map<id, String>();
        
        map<String, OEM_Mapping_Rule__c> TypeMap = new map<String, OEM_Mapping_Rule__c>();
        
        system.debug('***** JNV - ' + ListAll.size());
        
        //filter out duplicates and overrides
        for(OEM_Mapping_Rule__c oem : ListAll) 
        {
        string tempKey = string.valueOf(oem.OEM__r.OEM__r.Id);
        string blankKey = string.valueOf(oem.OEM__r.OEM__r.Id);     
        oem.Tech_Isvalid__c = true;
        
        if(oem.Part_Number__c == null)
        {
            if(oem.Sold_To_Account_Code__c == null)
            {   
                //WWAC level;
                tempKey += oem.WWAC__c;
            }
            else
            {
                //Customer level
                tempKey += oem.Sold_To_Account_Code__c.leftpad(8).replace(' ', '0') ;
            }
        }
        else
        {
            if(oem.Sold_To_Account_Code__c == null)
            {
                if(oem.WWAC__c == null)
                {
                    //PN level
                    tempKey += string.valueOf(oem.Part_Number__c);
                }
                else
                {
                    //WWAC+PN level
                    tempKey += (oem.WWAC__c + string.valueOf(oem.Part_Number__c));
                }
            }
            else
            {
                //Customer+PN level
                tempKey += (oem.Sold_To_Account_Code__c.leftpad(8).replace(' ', '0')  + string.valueOf(oem.Part_Number__c));
            }
        }
        
        DerivedKey.put(oem.id, tempKey);
        
        if(!TypeMap.containskey(tempKey))
        {
            TypeMap.put(tempKey, oem);
        }
        else 
        {
            if(TypeRank.get(TypeMap.get(tempKey).Type__c) < TypeRank.get(oem.Type__c))
            {
                TypeMap.put(tempKey, oem);
            }
        }
        }
        
        for(OEM_Mapping_Rule__c del : ListAll)
        {
            if(del.id <> TypeMap.get(DerivedKey.get(del.id)).id)
            {
                DeleteMaps.add(del);
                //del.Tech_Isvalid__c = false;
                //system.debug('***** JNV ' + del.oem__c + ' ' + del.type__c + ' ' + del.WWAC__c + ' ' + del.Sold_To_Account_Code__c + ' ' + del.Part_Number__c);               
            }
            else
            {
                UseMaps.add(del);
                //del.Tech_Isvalid__c = true;
                system.debug('***** JNV ' + del.id);
            }
            //system.debug('***** JNV - ' + del.id + ' ' + del.Tech_Isvalid__c);
        }
        
        system.debug('***** JNV All - ' + ListAll.size());
        system.debug('***** JNV Valid - ' + UseMaps.size());
        system.debug('***** JNV Delete - ' + DeleteMaps.size());

        //Database.Update(ListAll);
        /*try 
        {           
            Database.Delete(deletemaps);   
        }
        catch(Exception ex){
            system.debug('exception: ' + ex.GetMessage());
        } */         
        
        return UseMaps;             
    }

    public static list<OEM_Mapping_Rule__c> setOEMMapBatchInput(String FiscalMonth, String FiscalYear)
    {
        list<OEM_Mapping_Rule__c> BatchInput = new list<OEM_Mapping_Rule__c>();

        //04082014 Michael Cui: add OEM_Account__c on query.
        String MapQuery = 'SELECT Id, OEM__c, OEM__r.OEM__r.Id, OEM_Account__c, Sold_To_Account_Code__c, WWAC__c, Part_Number__c, ' +
                          ' Type__c, Tech_IsValid__c, Tech_Billing__c, Tech_MTD_Billing__c, Tech_Booking__c, ' + 
                          ' Tech_Backlog__c, Tech_Latest_SA__c, Allocation__c, Tech_CutOff_Date__c, Active__c, ' +
                          ' Worldwide_Account_Name__c, Sold_To_Account_Name__c ' +
                          ' FROM OEM_Mapping_Rule__c ' +
                          ' where fiscal_year__c =: FiscalYear ' + 
                          ' and fiscal_month__c =: FiscalMonth';
                          
        if(checkForActive)
        {
            MapQuery += ' and active__c = true';
        }           

        list<OEM_Mapping_Rule__c> ListAll = database.query(MapQuery);

        system.debug('***** JNV Batch Retrieval ' + ListAll);
        
        BatchInput = ValidateOEMMapRulesByType(ListAll);
        
        return BatchInput;              
    }
    
    public static void setCurrentFiscalDateValues()
    {
        Period MonthlyBatchPeriod = [SELECT PeriodLabel, FiscalYearSettings.Name FROM Period where type = 'Month' and startdate <= today and enddate >= today];

        CurrentFM = ClsOEMUtil.MAP_MONTHLABELNUMBER.get(MonthlyBatchPeriod.PeriodLabel);
        CurrentFY = MonthlyBatchPeriod.FiscalYearSettings.Name;         
    }   
    
    public static void cloneOEMDetailsAndMaps(String FiscalMonth, String FiscalYear, list<OEM_Details__c> InputDetails, list<OEM_Mapping_Rule__c> InputMappings)
    {
        list<OEM_Details__c> NewDetails = InputDetails.deepClone(false, false, false);
        list<OEM_Mapping_Rule__c> NewRules = InputMappings.deepClone(false, false, false);
        map<Id, Id> OEMParentMap = new map<Id, Id>();
                
        //reset info for new month                              
        for(OEM_Details__c d: NewDetails)
        {
            d.fiscal_month__c = FiscalMonth;
            d.fiscal_year__c = FiscalYear;
            d.CurrencyIsoCode = 'USD';
            d.Billing__c = 0; 
            d.Tech_CutoffDate__c = null;                    
        }
        
        try{                
            //insert so we can get OEM Detail Id's
            insert(NewDetails);
        }
        catch (exception e)
        {
            //if cutoff date specified in details for last month copies to a day next month
            //which does not fall in the right fiscal month, default cut off day to 15th of month
            if(e.getMessage().contains('not within the selected fiscal month'))
            {
                //reset info for new month                              
                for(OEM_Details__c d: NewDetails)
                {
                    d.CutOff_Date__c = '15';                
                }
                
                insert(NewDetails);
            }
            else
            {
                throw(e);
            }
        }
                
        //put into OEM Account id, OEM Detail record (new one for current month) map
        for(OEM_Details__c d2: NewDetails)
        {
            OEMParentMap.put(d2.OEM__c, d2.Id);
        }
                                
        //set values for new current month oem mapping rules                
        for(OEM_Mapping_Rule__c mr : NewRules)
        {
            mr.fiscal_month__c = FiscalMonth;
            mr.fiscal_year__c = FiscalYear;
            mr.CurrencyIsoCode = 'USD';
            mr.Tech_MTD_Billing__c = 0;
            mr.Tech_Booking__c = 0;
            mr.Tech_Backlog__c = 0;
            mr.Tech_Latest_SA__c = 0;
            mr.Tech_Billing__c = 0;          
            mr.Active__c = false;
            mr.OEM__c = OEMParentMap.get(mr.OEM__r.OEM__r.Id);                  
        }
        insert(NewRules);           
    }   

    //Get calendar date for OEM cut off dates, given fiscal month and fiscal year picklist values + calendar day picklist value
    public static date calculateCalendarDate(String FiscalMonth, String FiscalYear, String CalendarDay)
    {
        Integer CalendarMonth = Integer.valueOf(ClsOEMUtil.MAP_MONTHCALENDARNUMBER.get(ClsOEMUtil.MAP_MONTH.get(Integer.valueOf(FiscalMonth))));
        Integer CalendarYear = Integer.valueOf(FiscalYear);
        Integer FM = Integer.valueOf(FiscalMonth);
        if(FM == 1 || FM == 2 || FM == 3)
        {               
            CalendarYear--;
        }
        Date SetDate = date.newInstance(CalendarYear, CalendarMonth, Integer.valueOf(CalendarDay));
        
        return SetDate;         
    }

}