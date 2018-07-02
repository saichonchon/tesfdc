public class EventandExhibitionController{
   
   id id;
   public blob file { get; set; }
   public list<EventModules__c> prodlaunchlist{get;set;}
   public ApexPages.StandardController stdCtrl {get; set;}
   public Boolean refreshPage {get; set;}
   public list<Attachment> getcontent(){
      return ContentVersion_installationlist;
    }
   public list<Task> getTaskGeneral(){
      return TaskGenerallist;
    }
   public list<Task> getTaskGeneral1(){
      return TaskGenerallist1;
    }
   public list<Task> getTaskGeneral2(){
      return TaskGenerallist2;
    }
    
   public list<Task> getTaskGeneral3(){
      return TaskGenerallist3;
    }
    
    public list<Task> getTaskGeneral4(){
      return TaskGenerallist4;
    }
    
    public list<Task> getTaskGeneral5(){
      return TaskGenerallist5;
    }
  public list<Task> getTaskGeneral6(){
      return TaskGenerallist6;
    }
    
  public list<Task> getTaskGeneral7(){
      return TaskGenerallist7;
    }
  public list<Attachment> getAttachGeneral(){
      return AttachGenerallist;
    }
    
     public list<Attachment> getProspects(){
      return Prospectslist;
    }
   public list<Attachment> getBooth(){
      return Boothlist;
    }
   public list<Attachment> getSamples(){
      return Sampleslist;
    }
   public list<Attachment> getLiterature(){
      return Literaturelist;
    }
   public list<Attachment> getGiveaways(){
      return Giveawayslist;
    }
   public list<Attachment> getReport(){
      return Reportlist;
    }
   public list<Attachment> getOther(){
      return Otherlist;
    }
     list<Attachment>   AttachGenerallist =new list<Attachment>();
     list<Task>   TaskGenerallist =new list<Task>(); 
     list<Task>   TaskGenerallist1 =new list<Task>(); 
     list<Task>   TaskGenerallist2 =new list<Task>(); 
     list<Task>   TaskGenerallist3 =new list<Task>(); 
     list<Task>   TaskGenerallist4=new list<Task>(); 
     list<Task>   TaskGenerallist5 =new list<Task>(); 
     list<Task>   TaskGenerallist6 =new list<Task>(); 
     list<Task>   TaskGenerallist7 =new list<Task>();
  
    list<Attachment>   ContentVersion_installationlist =new list<Attachment>();
    list<Attachment>   Prospectslist =new list<Attachment>();
    list<Attachment>   Boothlist =new list<Attachment>();
    list<Attachment>   Sampleslist =new list<Attachment>();
    list<Attachment>   Literaturelist =new list<Attachment>();
    list<Attachment>   Giveawayslist =new list<Attachment>();
    list<Attachment>   Reportlist =new list<Attachment>();
    list<Attachment>   Otherlist =new list<Attachment>();
       
    public EventandExhibitionController(ApexPages.StandardController controller) {
        refreshPage=false;
        id = apexpages.currentpage().getparameters().get('id');
        string pd= apexpages.currentpage().getParameters().put('prodlaunchlist[0].id','');
        list<EventModules__c>    prodlaunchlist =[select id,Module_Name__c,Events_Exhibitions__c from EventModules__c where Events_Exhibitions__c =:id]; 
        
         for(integer i=0; i<prodlaunchlist.size();i++){
           for(attachment cv:[select id,ParentId,ownerid,name,body,ContentType,CreatedDate from attachment where ParentId=:prodlaunchlist[i].id]){
              {
              if(prodlaunchlist[i].Module_Name__c=='General information'){
              system.debug('---->1'+cv.name);
              ContentVersion_installationlist.add(cv);
              }
             if(prodlaunchlist[i].Module_Name__c=='Prospects'){
              system.debug('---->2'+cv.name);
              Prospectslist.add(cv);
              }
           if(prodlaunchlist[i].Module_Name__c=='Booth'){
            
             Boothlist.add(cv);
             }
              if(prodlaunchlist[i].Module_Name__c=='Samples'){
            
              Sampleslist.add(cv);
              }
              if(prodlaunchlist[i].Module_Name__c=='Literature'){
            
              Literaturelist.add(cv);
              }
              if(prodlaunchlist[i].Module_Name__c=='Give aways'){
             
              Giveawayslist.add(cv);
              }
              if(prodlaunchlist[i].Module_Name__c=='Report'){
             
              Reportlist.add(cv);
              }
              if(prodlaunchlist[i].Module_Name__c=='Other'){
             
              Otherlist.add(cv);
              }
           }
           }
            for(task t:[select id,Whatid,Subject,RecordTypeid,Whoid,IsVisibleInSelfService,ActivityDate,Status,Ownerid from task where whatid=:prodlaunchlist[i].id]){
         if(prodlaunchlist[i].Module_Name__c=='General information'){
          TaskGenerallist.add(t);
          }
          if(prodlaunchlist[i].Module_Name__c=='Prospects'){
          TaskGenerallist1.add(t);
          }
          if(prodlaunchlist[i].Module_Name__c=='Booth'){
          TaskGenerallist2.add(t);
          }
          if(prodlaunchlist[i].Module_Name__c=='Samples'){
          TaskGenerallist3.add(t);
          }
          if(prodlaunchlist[i].Module_Name__c=='Literature'){
          TaskGenerallist4.add(t);
          }
          if(prodlaunchlist[i].Module_Name__c=='Give aways'){
          TaskGenerallist5.add(t);
          }
          if(prodlaunchlist[i].Module_Name__c=='Report'){
          TaskGenerallist6.add(t);
          }
          if(prodlaunchlist[i].Module_Name__c=='Other'){
          TaskGenerallist7.add(t);
          }
          } 
          } 
        
       }
    
    public pagereference go() {
     if(file != null ){
          list<EventModules__c>    prodlaunchlist =[select id,Module_Name__c,Events_Exhibitions__c from EventModules__c where Events_Exhibitions__c =:id ORDER BY Module_Name__c]; 
          system.debug('====attachin');
          list<Attachment> att = new list<attachment>();   
          attachment attrecords= new attachment();         
          attrecords.ParentId=prodlaunchlist[0].id;
          attrecords.name = prodlaunchlist[0].Module_Name__c;                   
          attrecords.ContentType = 'Attachment';
          attrecords.body = file;
          insert attrecords;       
          ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM, 'Save Completed'));  
          refreshPage=true;
        }
         return null;           
     }
         
    public pagereference go1() {
        if(file != null ){
       list<EventModules__c>    prodlaunchlist =[select id,Module_Name__c,Events_Exhibitions__c from EventModules__c where ( Events_Exhibitions__c =:id)]; 

      attachment attrecords= new attachment();
         attrecords.ParentId=prodlaunchlist[1].id;
         attrecords.name='test';
         attrecords.name = prodlaunchlist[1].Module_Name__c;
         attrecords.ContentType = 'Attachment';
         attrecords.body = file;
         
        //0151600000PWx5b
         insert  attrecords; 
          refreshPage=true; 
          }      
       return null;         
    }
    public pagereference go2() {
     if(file != null ){
       list<EventModules__c>    prodlaunchlist =[select id,Module_Name__c,Events_Exhibitions__c from EventModules__c where Events_Exhibitions__c =:id]; 

      attachment attrecords= new attachment();
         attrecords.ParentId=prodlaunchlist[2].id;
         attrecords.name='test';
         attrecords.name = prodlaunchlist[2].Module_Name__c;
         attrecords.ContentType = 'Attachment';
         attrecords.body = file;
         
        //0151600000PWx5b
         insert  attrecords;  
          refreshPage=true; 
          }    
       return null;             
    }
    
    public pagereference go3() {
     if(file != null ){
       list<EventModules__c>    prodlaunchlist =[select id,Module_Name__c,Events_Exhibitions__c from EventModules__c where Events_Exhibitions__c =:id]; 

     attachment attrecords= new attachment();
         attrecords.ParentId=prodlaunchlist[3].id;
         attrecords.name='test';
         attrecords.name = prodlaunchlist[3].Module_Name__c;
         attrecords.ContentType = 'Attachment';
         attrecords.body = file;
         
        //0151600000PWx5b
         insert  attrecords; 
          refreshPage=true; 
          }      
       return null;            
    }
    public pagereference go4() {
     if(file != null ){
       list<EventModules__c>    prodlaunchlist =[select id,Module_Name__c,Events_Exhibitions__c from EventModules__c where Events_Exhibitions__c =:id]; 

      attachment attrecords= new attachment();
         attrecords.ParentId=prodlaunchlist[4].id;
         attrecords.name='test';
         attrecords.name = prodlaunchlist[4].Module_Name__c;
         attrecords.ContentType = 'Attachment';
         attrecords.body = file;
         
        //0151600000PWx5b
         insert  attrecords; 
          refreshPage=true; 
          }      
       return null;          
    }
    public pagereference go5() {
     if(file != null ){
       list<EventModules__c>    prodlaunchlist =[select id,Module_Name__c,Events_Exhibitions__c from EventModules__c where Events_Exhibitions__c =:id]; 
             attachment attrecords= new attachment();
         attrecords.ParentId=prodlaunchlist[5].id;
         attrecords.name='test';
         attrecords.name = prodlaunchlist[5].Module_Name__c;
         attrecords.ContentType = 'Attachment';
         attrecords.body = file;
         
        //0151600000PWx5b
         insert  attrecords;  
          refreshPage=true; 
          }     
       return null;             
    }
    public pagereference go6() {
     if(file != null ){
       list<EventModules__c>    prodlaunchlist =[select id,Module_Name__c,Events_Exhibitions__c from EventModules__c where Events_Exhibitions__c =:id]; 

      attachment attrecords= new attachment();
         attrecords.ParentId=prodlaunchlist[6].id;
         attrecords.name='test';
         attrecords.name = prodlaunchlist[6].Module_Name__c;
         attrecords.ContentType = 'Attachment';
         attrecords.body = file;
         
        //0151600000PWx5b
         insert  attrecords; 
        
          refreshPage=true;  
          }     
       return null;               
    }
      public pagereference go7() {
       if(file != null ){
       list<EventModules__c>    prodlaunchlist =[select id,Module_Name__c,Events_Exhibitions__c from EventModules__c where Events_Exhibitions__c =:id]; 

       attachment attrecords= new attachment();
         attrecords.ParentId=prodlaunchlist[7].id;
         attrecords.name='test';
         attrecords.name = prodlaunchlist[7].Module_Name__c;
         attrecords.ContentType = 'Attachment';
         attrecords.body = file;
         
        //0151600000PWx5b
         insert  attrecords; 
          refreshPage=true; 
          }      
       return null;            
    }
   public PageReference Newtask(){
          list<EventModules__c>    prodlaunchlist =[select id,Module_Name__c,Events_Exhibitions__c from EventModules__c where Events_Exhibitions__c =:id ORDER BY Module_Name__c];  
          id pd= prodlaunchlist[0].id;
 list<task> ta=[select id,Whatid from task where whatid=:prodlaunchlist[0].id];
          for(task t:ta){
          TaskGenerallist.add(t);
          }
       PageReference pageRef = new PageReference('/00T/e?what_id='+pd +'&retURL=%2F'+pd+'&ent=Task');
        pageRef.setRedirect(true);
        string sampleurl='/00T/e?what_id='+pd +'&retURL=%2F'+pd+'&ent=Task';
        system.debug('=======path'+sampleurl);
        system.debug('=========path'+'/apex/customtask?what_id='+pd +'&retURL=%2F'+pd+'&RecordType=012G0000000qF6R&ent=Task');
        refreshPage=true; 
        return pageRef;
        
   } 
    public pagereference edit(){
  
    list<EventModules__c>    prodlaunchlist =[select id,Module_Name__c,Events_Exhibitions__c from EventModules__c where Events_Exhibitions__c =:id ORDER BY Module_Name__c];  
          id pd= prodlaunchlist[0].id;
          system.debug('=====pd'+pd);
     list<task> ta=[select id,Whatid from task where whatid=:prodlaunchlist[0].id];
     //id ta1=ta[0].id;
     id ta1=(ta.isEmpty()?null:ta[0].id);
     system.debug('=====ta1'+ta1);
     PageReference pageRef = new PageReference('/'+ta1+'/e?retURL=%2F'+pd);
        pageRef.setRedirect(true);
       return pageRef; 
    }
    public pagereference edit1(){
  
    list<EventModules__c>    prodlaunchlist =[select id,Module_Name__c,Events_Exhibitions__c from EventModules__c where Events_Exhibitions__c =:id ORDER BY Module_Name__c];  
          id pd= prodlaunchlist[1].id;
          system.debug('=====pd'+pd);
     list<task> ta=[select id,Whatid from task where whatid=:prodlaunchlist[1].id];
     //id ta1=ta[0].id;
     id ta1=(ta.isEmpty()?null:ta[0].id);
     system.debug('=====ta1'+ta1);
     PageReference pageRef = new PageReference('/'+ta1+'/e?retURL=%2F'+pd);
        pageRef.setRedirect(true);
       return pageRef; 
    }
     public pagereference edit2(){
  
    list<EventModules__c>    prodlaunchlist =[select id,Module_Name__c,Events_Exhibitions__c from EventModules__c where Events_Exhibitions__c =:id ORDER BY Module_Name__c];  
          id pd= prodlaunchlist[2].id;
          system.debug('=====pd'+pd);
     list<task> ta=[select id,Whatid from task where whatid=:prodlaunchlist[2].id];
     //id ta1=ta[0].id;
     id ta1=(ta.isEmpty()?null:ta[0].id);
     system.debug('=====ta1'+ta1);
     PageReference pageRef = new PageReference('/'+ta1+'/e?retURL=%2F'+pd);
        pageRef.setRedirect(true);
       return pageRef; 
    }
     public pagereference edit3(){
  
    list<EventModules__c>    prodlaunchlist =[select id,Module_Name__c,Events_Exhibitions__c from EventModules__c where Events_Exhibitions__c =:id ORDER BY Module_Name__c];  
          id pd= prodlaunchlist[3].id;
          system.debug('=====pd'+pd);
     list<task> ta=[select id,Whatid from task where whatid=:prodlaunchlist[3].id];
     //id ta1=ta[0].id;
     id ta1=(ta.isEmpty()?null:ta[0].id);
     system.debug('=====ta1'+ta1);
     PageReference pageRef = new PageReference('/'+ta1+'/e?retURL=%2F'+pd);
        pageRef.setRedirect(true);
       return pageRef; 
    }
 public pagereference edit4(){
  
    list<EventModules__c>    prodlaunchlist =[select id,Module_Name__c,Events_Exhibitions__c from EventModules__c where Events_Exhibitions__c =:id ORDER BY Module_Name__c];  
          id pd= prodlaunchlist[4].id;
          system.debug('=====pd'+pd);
     list<task> ta=[select id,Whatid from task where whatid=:prodlaunchlist[4].id];
     //id ta1=ta[0].id;
     id ta1=(ta.isEmpty()?null:ta[0].id);
     system.debug('=====ta1'+ta1);
     PageReference pageRef = new PageReference('/'+ta1+'/e?retURL=%2F'+pd);
        pageRef.setRedirect(true);
       return pageRef; 
    }
     public pagereference edit5(){
  
    list<EventModules__c>    prodlaunchlist =[select id,Module_Name__c,Events_Exhibitions__c from EventModules__c where Events_Exhibitions__c =:id ORDER BY Module_Name__c];  
          id pd= prodlaunchlist[5].id;
          system.debug('=====pd'+pd);
     list<task> ta=[select id,Whatid from task where whatid=:prodlaunchlist[5].id];
     //id ta1=ta[0].id;
     id ta1=(ta.isEmpty()?null:ta[0].id);
     system.debug('=====ta1'+ta1);
     PageReference pageRef = new PageReference('/'+ta1+'/e?retURL=%2F'+pd);
        pageRef.setRedirect(true);
       return pageRef; 
    }
     public pagereference edit6(){
  
    list<EventModules__c>    prodlaunchlist =[select id,Module_Name__c,Events_Exhibitions__c from EventModules__c where Events_Exhibitions__c =:id ORDER BY Module_Name__c];  
          id pd= prodlaunchlist[6].id;
          system.debug('=====pd'+pd);
     list<task> ta=[select id,Whatid from task where whatid=:prodlaunchlist[6].id];
     //id ta1=ta[0].id;
     id ta1=(ta.isEmpty()?null:ta[0].id);
     system.debug('=====ta1'+ta1);
     PageReference pageRef = new PageReference('/'+ta1+'/e?retURL=%2F'+pd);
        pageRef.setRedirect(true);
       return pageRef; 
    }
    
    public pagereference edit7(){
  
    list<EventModules__c>    prodlaunchlist =[select id,Module_Name__c,Events_Exhibitions__c from EventModules__c where Events_Exhibitions__c =:id ORDER BY Module_Name__c];  
          id pd= prodlaunchlist[7].id;
          system.debug('=====pd'+pd);
     list<task> ta=[select id,Whatid from task where whatid=:prodlaunchlist[7].id];
     //id ta1=ta[0].id;
     id ta1=(ta.isEmpty()?null:ta[0].id);
     system.debug('=====ta1'+ta1);
     PageReference pageRef = new PageReference('/'+ta1+'/e?retURL=%2F'+pd);
        pageRef.setRedirect(true);
       return pageRef; 
    }
    
    public PageReference Newtask1(){
    list<EventModules__c>    prodlaunchlist =[select id,Module_Name__c,Events_Exhibitions__c from EventModules__c where Events_Exhibitions__c =:id ORDER BY Module_Name__c];  
         
          id pd= prodlaunchlist[1].id;

       PageReference pageRef = new PageReference('/00T/e?what_id='+pd +'&retURL=%2F'+pd+'&ent=Task');
        pageRef.setRedirect(true);
        string sampleurl='/00T/e?what_id='+pd +'&retURL=%2F'+pd+'&RecordType=012G0000000qF6R&ent=Task';
        system.debug('=======path'+sampleurl);
        system.debug('=========path'+'/apex/customtask?what_id='+pd +'&retURL=%2F'+pd+'&ent=Task');
        refreshPage=true; 
        return pageRef;
        
       
   } 
    public PageReference Newtask2(){
   list<EventModules__c>    prodlaunchlist =[select id,Module_Name__c,Events_Exhibitions__c from EventModules__c where Events_Exhibitions__c =:id ORDER BY Module_Name__c];  
          id pd= prodlaunchlist[2].id;

       PageReference pageRef = new PageReference('/00T/e?what_id='+pd +'&retURL=%2F'+pd+'&ent=Task');
        pageRef.setRedirect(true);
        string sampleurl='/00T/e?what_id='+pd +'&retURL=%2F'+pd+'&ent=Task';
        system.debug('=======path'+sampleurl);
        system.debug('=========path'+'/apex/customtask?what_id='+pd +'&retURL=%2F'+pd+'&ent=Task');
        refreshPage=true; 
        return pageRef;
   } 
    public PageReference Newtask3(){
   list<EventModules__c>    prodlaunchlist =[select id,Module_Name__c,Events_Exhibitions__c from EventModules__c where Events_Exhibitions__c =:id ORDER BY Module_Name__c];  
          id pd= prodlaunchlist[3].id;

       PageReference pageRef = new PageReference('/00T/e?what_id='+pd +'&retURL=%2F'+pd+'&ent=Task');
        pageRef.setRedirect(true);
        string sampleurl='/00T/e?what_id='+pd +'&retURL=%2F'+pd+'&ent=Task';
        system.debug('=======path'+sampleurl);
        system.debug('=========path'+'/apex/customtask?what_id='+pd +'&retURL=%2F'+pd+'&ent=Task');
         refreshPage=true; 
        return pageRef;
   } 
    public PageReference Newtask4(){
    list<EventModules__c>    prodlaunchlist =[select id,Module_Name__c,Events_Exhibitions__c from EventModules__c where Events_Exhibitions__c =:id ORDER BY Module_Name__c];  
          id pd= prodlaunchlist[4].id;

       PageReference pageRef = new PageReference('/00T/e?what_id='+pd +'&retURL=%2F'+pd+'&ent=Task');
        pageRef.setRedirect(true);
        string sampleurl='/00T/e?what_id='+pd +'&retURL=%2F'+pd+'&ent=Task';
        system.debug('=======path'+sampleurl);
        system.debug('=========path'+'/apex/customtask?what_id='+pd +'&retURL=%2F'+pd+'&ent=Task');
         refreshPage=true; 
        return pageRef;
   } 
    public PageReference Newtask5(){
    list<EventModules__c>    prodlaunchlist =[select id,Module_Name__c,Events_Exhibitions__c from EventModules__c where Events_Exhibitions__c =:id ORDER BY Module_Name__c];  
          id pd= prodlaunchlist[5].id;

       PageReference pageRef = new PageReference('/00T/e?what_id='+pd +'&retURL=%2F'+pd+'&ent=Task');
        pageRef.setRedirect(true);
        string sampleurl='/00T/e?what_id='+pd +'&retURL=%2F'+pd+'&RecordType=012G0000000qF6R&ent=Task';
        system.debug('=======path'+sampleurl);
        system.debug('=========path'+'/apex/customtask?what_id='+pd +'&retURL=%2F'+pd+'&ent=Task');
        refreshPage=true; 
        return pageRef;
   } 
    public PageReference Newtask6(){
    list<EventModules__c>    prodlaunchlist =[select id,Module_Name__c,Events_Exhibitions__c from EventModules__c where Events_Exhibitions__c =:id ORDER BY Module_Name__c];  
          id pd= prodlaunchlist[6].id;

       PageReference pageRef = new PageReference('/00T/e?what_id='+pd +'&retURL=%2F'+pd+'&ent=Task');
        pageRef.setRedirect(true);
        string sampleurl='/00T/e?what_id='+pd +'&retURL=%2F'+pd+'&ent=Task';
        system.debug('=======path'+sampleurl);
        system.debug('=========path'+'/apex/customtask?what_id='+pd +'&retURL=%2F'+pd+'&ent=Task');
        refreshPage=true; 
        return pageRef;
   }  
   public PageReference Newtask7(){
   list<EventModules__c>    prodlaunchlist =[select id,Module_Name__c,Events_Exhibitions__c from EventModules__c where Events_Exhibitions__c =:id ORDER BY Module_Name__c];  
          id pd= prodlaunchlist[7].id;

       PageReference pageRef = new PageReference('/00T/e?what_id='+pd +'&retURL=%2F'+pd+'&ent=Task');
        pageRef.setRedirect(true);
        string sampleurl='/00T/e?what_id='+pd +'&retURL=%2F'+pd+'&ent=Task';
        system.debug('=======path'+sampleurl);
        system.debug('=========path'+'/apex/customtask?what_id='+pd +'&retURL=%2F'+pd+'&ent=Task');
        refreshPage=true; 
        return pageRef;
   }        
   }