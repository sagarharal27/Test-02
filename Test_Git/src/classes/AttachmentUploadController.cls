public with sharing class AttachmentUploadController {

  public Attachment attachment {
  get {
      if (attachment == null)
        attachment = new Attachment();
      return attachment;
    }
  set;
  }

  public PageReference upload() {

    attachment.OwnerId = UserInfo.getUserId();
    attachment.ParentId = '00328000003lUTm'; // the record the file is attached to
    attachment.IsPrivate = false;
    //attachment.contentType= 'text;charset=UTF-8';

    try {
       
        /*
        List<attachment> lstatt = [select id, body from attachment where id = :attachment.Id] ; 
        System.debug('----lstatt----'+lstatt[0].body);
        System.debug('----lstatt----'+lstatt[0].body.toString());
        */
        
        Blob bl = Blob.valueOf('RESUME'); 
        String str = EncodingUtil.Base64Encode(bl);
        System.debug('Resume word::::'+str);
        
        Blob b1=attachment.body;
        String str1 = EncodingUtil.Base64Encode(b1);
        System.debug('Resume file::::'+str1);
        
        if(str1.contains(str)){
            system.debug('Matched RESUME::::TRUE');
        } 
        else{
            system.debug('Matched RESUME::::FALSE');
        }
        insert attachment;
        
      
    } 
    catch (DMLException e) {
      ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Error uploading attachment'));
      return null;
    } 
    finally {
      attachment = new Attachment(); 
    }

    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,'Attachment uploaded successfully'));
    return null;
  }

}