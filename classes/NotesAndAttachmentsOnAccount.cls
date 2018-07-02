public with sharing class NotesAndAttachmentsOnAccount { 

    //Variable Decleration
    public list<attachment> ats {get;set;}
    public list<Note> noteslist {get;set;}    
    Public list<attnotewrapper> Notesandattachments{get; set;}
    Public String Selectednttattid{get; set;}    
    Public List<Attachment > att1 = new List<Attachment >();
    Public List<Note> ntt1 = new List<Note>();
    Public Id UrlAccid{get; set;}
    
    //method to load initial table values 
    public list<attnotewrapper> constructorinit(){
    system.debug('@@@@@@@-constructorinit method called');
        Selectednttattid = null;
        Notesandattachments.clear();
        Notesandattachments = new list<attnotewrapper>();
        UrlAccid = apexpages.currentpage().getparameters().get('id');
        ats = new list<attachment>([SELECT Body,BodyLength,ContentType,CreatedById, CreatedBy.Name, CreatedDate,Description,Id,IsDeleted,IsPrivate,LastModifiedById,LastModifiedDate,Name,OwnerId,ParentId, Parent.Name FROM Attachment where parentid =: UrlAccid ]);  //change '' as dynamic and read from url
        noteslist = new list<Note>([SELECT Body,CreatedById, CreatedBy.Name, CreatedDate,Id,IsDeleted,IsPrivate,LastModifiedById,LastModifiedDate,OwnerId,ParentId,Parent.Name, Title FROM Note where parentid =: UrlAccid ]); 
        if(!ats.isEmpty())
        //system.debug('@@@@@@'+ats);
        for(attachment at: ats){
            if( (at.IsPrivate && at.OwnerId == userInfo.getUserId()) || (!at.IsPrivate) ) Notesandattachments.add(new attnotewrapper(at));
        }
        if(!noteslist.isEmpty())
        for(Note nt: noteslist){
            if( (nt.IsPrivate && nt.OwnerId == userInfo.getUserId() ) || (!nt.IsPrivate) ) Notesandattachments.add(new attnotewrapper(nt));
        }   
        //Notesandattachments.sort();
        return Notesandattachments;
    }
    
    //Constructor
    public NotesAndAttachmentsOnAccount(ApexPages.StandardController controller) {
        
        
        Selectednttattid = null;
        Notesandattachments = new list<attnotewrapper>(); 
        constructorinit();
    }
    // wrapper class for Notes and Attachments
    Public class attnotewrapper{
        public Id id { get; set; }
        public String name { get; set; }
        public string ContentType { get; set; }
        public string temp = 'Note';
        Public string Type {get; set;}
        Public string parentName {get; set;}
        Public string LastModifiedDate{get; set;}
        Public string CreatedBy{get; set;}
        Public Id CreatedbyId{get; set;}
        
        Public attnotewrapper(attachment att){
        this.id = att.id;
        this.name = att.name;
        this.ContentType = att.ContentType;
        this.Type = 'Attachment';
        this.parentName = att.Parent.Name;
        this.LastModifiedDate = att.LastModifiedDate.format();
        this.CreatedBy = att.CreatedBy.Name;
        this.CreatedbyId = CreatedById;
        }
        
        Public attnotewrapper(Note ntt){
        this.id = ntt.id;
        this.name = ntt.Title;
        this.ContentType = temp ; 
        this.Type = 'Note';
        this.parentName = ntt.Parent.Name;
        this.LastModifiedDate = ntt.LastModifiedDate.format();
        this.CreatedBy = ntt.CreatedBy.Name;
        this.CreatedbyId = CreatedById;
        }
        
    }
    
    
    // Method for Delete Action
    Public pagereference DeleteNoteattachment(){
        system.debug('@@@@@@@@@ - DeleteNoteattachment method executed1' +Selectednttattid );
        if(Selectednttattid != null){
        system.debug('@@@@@@@@@ - DeleteNoteattachment method executed2' +Selectednttattid );
            att1 = [select id, name from Attachment where id=:Selectednttattid ];
            
            if (att1.size()>0)
            delete att1;
            else{
            ntt1 = [select id, Title from Note where id=: Selectednttattid ];
            if(ntt1.size()>0)
            delete ntt1 ;
            }
        }      
        
        constructorinit();
        return null;
    }

}