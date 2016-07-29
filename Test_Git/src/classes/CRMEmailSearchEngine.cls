/***************************************************************************************************
Class : CRMEmailSearchEngine
Created Date : 31/8/2015
Description : This class is for accessing email mail services
***************************************************************************************************/
global class CRMEmailSearchEngine implements Messaging.InboundEmailHandler {
    global Messaging.InboundEmailResult handleInboundEmail(Messaging.InboundEmail email,
                                                           Messaging.InboundEnvelope envelope) {
    
    // creating instance for objects
    //Contact conInstance;
    Email__c emailInstance;
    Query__c queryInstance;
    Send_Response__c resInstace;
    
    List<Case> caseList = new List<Case>();
    List<Contact> conList = new List<Contact>();
    String[] lines = new String[]{};

    // Creating Instance for email result
   // Messaging.InboundEmail.TextAttachment attachmenttext = new Messaging.InboundEmail.TextAttachment();
    Messaging.InboundEmailResult result = new Messaging.InboundEmailresult();
     
    Contact conInstance = new Contact();
    conInstance.FirstName = email.fromname.substring(0,email.fromname.indexOf(' '));
    conInstance.LastName = email.fromname.substring(email.fromname.indexOf(' '));
    conInstance.Email = envelope.fromAddress;
    insert conInstance;
    System.debug('------conInstance----- '+conInstance.Id);
        
     if (email.textAttachments != null && email.textAttachments  .size() > 0) {
         conList = [select id,FirstName from Contact where FirstName = :email.fromname];
         if(conList.size() == 0) {
        //if([select count() from Contact where FirstName = :email.fromname] == 0) 
            conInstance = new Contact(); 
            conInstance.Email = email.FromAddress;
            conInstance.LastName = email.FromName;
            insert conInstance;
        }
        else {
            conInstance.Email = email.FromAddress;
            conInstance.LastName = email.FromName;
        }
        
        String[] inputvalues = new String[]{};
        
            // Inserting CSV attachment to org
            for (integer i = 0 ; i < email.textAttachments .size() ; i++) {
            
                Attachment attachment = new Attachment();
                attachment.ParentId = conInstance.Id;
                attachment.Name = email.textAttachments[i].filename; 
                attachment.Body = Blob.valueOf(email.textAttachments[i].body); 
                insert attachment;
                System.debug('------attachment----- '+attachment);
            
                //Converting blob to string
                Blob tempBlob = attachment.Body;
                System.debug('----tempBlob---'+tempBlob);
            
                String myString = tempBlob.toString();
                System.debug('----myString---'+myString);
                
                lines = myString.split('\n');
                System.debug('----lines---'+lines);
                
                Case caseInstance;
                for(Integer j=1; j < lines.size(); j++) {

                    inputvalues = lines[j].split(',');
                    System.debug('----inputvalues---'+inputvalues);


                    caseInstance = new Case();
                    /*caseInstance.Status = inputvalues[0];
                         System.debug('----inputvalues[0]---'+inputvalues[0]);*/
                    String statusValue = inputvalues[0].substringBetween('"','"');
                         System.debug('----statusValue---'+statusValue);
                    caseInstance.Status = statusValue;
                        
                    /*caseInstance.Origin = inputvalues[1].trim();       
                         System.debug('----inputvalues[1]---'+inputvalues[1]);*/
                    String originValue = inputvalues[0].substringBetween('"','"');
                         System.debug('----originValue---'+originValue);
                    caseInstance.Origin = originValue;
                        
                    System.debug('----caseInstance---'+caseInstance);
                    caseList.add(caseInstance);
                    System.debug('----caseList---'+caseList);
                }
            }
        try { 
            insert caseList;
        }
        catch(Exception e) {
            System.debug('Error Occured');
        }
    
    }
    return result;
                                                           }
}
        /*string body = email.plainTextBody;
        //body = body.substringBetween(Constants.strSubQueryStart, Constants.strSubQueryEnd);
        
        List<Email__c> listEmail = new List<Email__c>();
        List <Contact> conList = [select id from Contact where Email = :email.FromAddress];
        
        try {
            
            // Check if body is not blank
            if(string.isNotBlank(email.plainTextBody)) {
                
                //if in correct format
                if((string.isNotBlank(email.plainTextBody.substringBetween(Constants.strSubQueryStart, Constants.strSubQueryEnd)))) {
                  
                        // Creating contact for sender of an email
                          if([select count() from Contact where Email = :email.fromaddress] == 0) {
                             conInstance = new Contact(); 
                             conInstance.Email = email.FromAddress;
                             conInstance.LastName = email.FromName;
                             insert conInstance;
                          }
                          // Retriving all contacts which are already present
                          Contact ContactInstance =[Select Name, Email from Contact
                                                    where Email = :email.fromaddress];
                          system.debug('----ContactInstance--->'+ContactInstance);
                          // Assigning values to fields of email object 
                          Email__c emailObj = new Email__c(Contact__c = ContactInstance.Id,
                                                           From_Address__c = email.fromAddress,
                                                           Name = email.fromAddress,
                                                           Body__c =email.plainTextBody, 
                                                           Subject__c = email.Subject);
                          listEmail.add(emailObj);
                          // Inserting values
                          insert listEmail;
                
                          // Assigninig values to query and inserting it
                          queryInstance = new Query__c();
                          String strBody = emailObj.Body__c.substringBetween(Constants.strSubQueryStart,Constants.strSubQueryEnd);
                          //String query = strBody.substringAfter('Query:');
                          queryInstance.Query_Of_User__c = strBody;
                          queryInstance.EmailandContact__c = emailObj.Id;
                          insert queryInstance;
                
                          // Assigninig values to Send_Response__c and inserting it
                          resInstace = new Send_Response__c();
                          resInstace.QueryJunction__c = queryInstance.Id;
                          resInstace.ContactJunction__c = ContactInstance.Id;
                          insert resInstace;
                        
                          result.message = Constants.strMessageToUser;
                          result.success = true;
                      }
                 else {
                // If query format is not correct Replay back to sender with instructions
                    result.message = Constants.strGreetToSender+
                                     Constants.strMessage+
                                     Constants.strFormat+
                                     Constants.strFormatInstruction+
                                     Constants.strExpectedFormat+
                                     Constants.strThanks;
                    system.debug('--message--->'+result.message);
                    result.success = false;
                 }
            }
            else {
            // If query format is not correct Replay back to sender with instructions
                result.message = Constants.strGreetToSender+
                                 Constants.strMessage+
                                 Constants.strFormat+
                                 Constants.strFormatInstruction+
                                 Constants.strExpectedFormat+
                                 Constants.strThanks;
                system.debug('--message--->'+result.message);
                result.success = false;
            }
        }
        catch(Exception ex) {
                        system.debug('--into catch-->'+ex.getMessage());
                        result.message = ex.getMessage();
                        result.success = false;
        }
                                                           
        // return the result
        return result;
    }*/