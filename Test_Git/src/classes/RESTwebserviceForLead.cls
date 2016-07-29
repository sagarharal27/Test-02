/*************************************************************************************************************
Class : RESTwebserviceForLead
date : 23/8/2015
Description : This class provides REST webservices ton create delete
***************************************************************************************************************/
@RestResource(urlMapping = '/LeadManipulation/*')
global with sharing class RESTwebserviceForLead {
    
    // Inserting a lead record using @HttpPost
    @HttpPost
    global static WrapperForLead createLead(String strInsertFirstName, String strInsertLastName, 
        									String strInsertCompany, String strInsertStatus, 
        									String strInsertEmail, String strInsertPhone) { 
        
        WrapperForLead wrapperInstance = new WrapperForLead();
        Lead leadObj = new Lead(); 
                                                try{                                       
        if((String.isNotBlank(strInsertLastName))||
           (String.isNotBlank(strInsertCompany))||
           (String.isNotBlank(strInsertStatus))) 
        {
        	leadObj.FirstName = strInsertFirstName; 
        	leadObj.LastName = strInsertLastName; 
        	leadObj.Company = strInsertCompany; 
        	leadObj.Email = strInsertEmail;                                                 
        	leadObj.Phone = strInsertPhone;  
        	leadObj.Status = strInsertStatus; 
        	RestRequest restRequestInstance = RestContext.request;
   
        	// Wrapper class instance 
        	
            	Database.SaveResult results = Database.insert(leadObj);
                //insert leadObj;
                if(results.isSuccess()) {
            		wrapperInstance.blIsSuccess = true;
            		wrapperInstance.strleadId = leadObj.Id; 
            		wrapperInstance.strstatus =  Constants.strSuccess;
            	}
            	else {
                	wrapperInstance.blIsSuccess = false; 
            		wrapperInstance.strleadId = ''; 
            		wrapperInstance.strstatus = Constants.strErroeMsgForWebservice;
            	} 
        }
        else {
        	wrapperInstance.strstatus = Constants.strErroeMsgForWebservice;                                             
        }
                                                }
                                                catch(Exception e) {}
        return wrapperInstance;
    } 
    // HttpDelete is used to insert a lead record
    // Deleting a lead record 
    @HttpDelete 
    global static WrapperForLead deleteLead() {
        RestRequest getParameter = RestContext.request;
        String strDeleteFirstName = getParameter.params.get('FirstName');
        String strDeleteLastName = getParameter.params.get('LastName');
        String strDeleteEmail = getParameter.params.get('Email');
        String strDeletePhone = getParameter.params.get('Phone');
        
        List<Lead> leadListDelete = [SELECT Id 
                                     FROM Lead 
                                     WHERE FirstName = :strDeleteFirstName AND 
                                     		LastName = :strDeleteLastName  AND 
                                     		Email = :strDeleteEmail AND 
                                     		Phone = :strDeletePhone];
        
        System.debug('>>>>>>>>>>>>>>>>>>>>>>>>'+leadListDelete);
        WrapperForLead wrapperInstance = new WrapperForLead();
        if((String.isBlank(strDeleteFirstName))||(String.isBlank(strDeleteLastName))||(String.isBlank(strDeleteEmail))||(String.isBlank(strDeletePhone))) {
        	wrapperInstance.strstatus = Constants.strErroeMsgForWebserviceDelete; 
            return wrapperInstance;
        }
        else {   
            if (!leadListDelete.isEmpty()) {
            	delete leadListDelete;
            	wrapperInstance.blIsSuccess = true; 
            	wrapperInstance.strstatus =  Constants.strSuccess;
            }
        	/*else {
                	wrapperInstance.blIsSuccess = false; 
            		wrapperInstance.strleadId = ''; 
            		wrapperInstance.strstatus = Constants.strErroeMsgForWebserviceDelete;
        	} */
        return wrapperInstance;
		}
    }
    // HttpPatch is used to update a lead record
    // Updating a lead record
     
    @HttpPatch
    global static WrapperForLead leadUpdate( String strUpdateFirstName, String strUpdateLastName,
                                             String strUpdatePhone, String strUpdateEmail) {
        WrapperForLead wrapperInstance = new WrapperForLead();
        List<Lead> leadListUpdate = new List<Lead>();
        
        if((String.isBlank(strUpdateFirstName))||(String.isBlank(strUpdateLastName))) {
            system.debug('-------into else------->');
        	wrapperInstance.strstatus = Constants.strErroeMsgForWebserviceUpdate; 
            return wrapperInstance;
        }
       	else{
       		leadListUpdate = [SELECT Id,FirstName FROM Lead WHERE
                          FirstName = :strUpdateFirstName AND
                          LastName = :strUpdateLastName];
           
        	for(Lead lstObj : leadListUpdate) {
        		lstObj.Phone = strUpdatePhone;
            	lstObj.Email = strUpdateEmail; 
        	}                                                                                                     
        	if (!leadListUpdate.isEmpty()) {
            	update leadListUpdate; 
                for(Integer i = 0 ; i < leadListUpdate.size(); i++) {
            		wrapperInstance.blIsSuccess = true; 
            		wrapperInstance.strleadId = leadListUpdate[i].Id; 
            		wrapperInstance.strstatus =  Constants.strSuccess;
                }
           	}
        	else {
            	wrapperInstance.blIsSuccess = false; 
            	wrapperInstance.strleadId = ''; 
            	wrapperInstance.strstatus = Constants.strErroeMsgForWebserviceUpdate;
        	} 
       	}
    return wrapperInstance;
    }
	// Wrapper class to display fields after DML operations
    global class WrapperForLead {
        public Boolean blIsSuccess;
        public String strleadId;
        public String strstatus;  
        public string strLeadName;
         // Initializating the variables
         public WrapperForLead() {
         	blIsSuccess = false;
            strleadId = '';
            strstatus = '';
            strLeadName = '';
         }
     }
}