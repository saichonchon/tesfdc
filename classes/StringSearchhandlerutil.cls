Public without sharing class StringSearchhandlerutil{
   
    public static string search(String totstr,String soldToAccountName){
        
        String DistributorNot_str = Label.NDR_Distributor_Not_Defined_Picklist_Value;
        System.debug('@@@@'+DistributorNot_str);
        String original_str= totstr;
        String Distributorupdatestr;
        String tempstring= soldToAccountName.remove('.');
        String[] str=tempstring.split(' '); 
        String Search_str = str[0].toLowerCase();
        totStr=totStr.toLowerCase();    
                                                   
        if(totStr.contains(Search_str)){
            System.debug(totstr );
            
            integer idx = totStr.indexOf(Search_str);
            System.debug('idx is'+idx );
                
            String stroccurbefore= original_str.substring(0, idx);
            integer index = stroccurbefore.lastIndexOf(',');
            System.debug(stroccurbefore);
            System.debug('index is'+index );
            if(index == -1)
            {
                stroccurbefore=stroccurbefore.substring(0);
            }
            else{
                stroccurbefore=stroccurbefore.substring(index+1);
            }
            System.debug(stroccurbefore);
            
            String stroccurafter= original_str.substring(idx);
            System.debug(stroccurafter);
            integer commaidx= stroccurafter.indexOf(',');
            System.debug(commaidx);
            if(commaidx != -1)
                stroccurafter= stroccurafter.substring(0, commaidx);
                
            String finalStr = stroccurbefore+stroccurafter;
            System.debug(finalStr);
                
                Distributorupdatestr = finalStr;  
       
            }
            else{
                 Distributorupdatestr = DistributorNot_str;
            } 
        return Distributorupdatestr;            
    }
}