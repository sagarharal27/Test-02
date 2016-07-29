/***************************************************************************************************
Class : SOAPServiceOfLead
Created Date : 19/8/2015
Description : This is webService provided to create ,delete and update the lead from another org
***************************************************************************************************/
global with sharing class SOAPServiceOfLead {
    
    // Web service method to create lead
    webService static WrapperForLead createNewLead (String strFirstName, String strLastname,
                                            		String strStatus, String strCompany,
                                            		String strEmail, String strPhone) {
        
        String showMessage;
        // Creating fields of lead
        WrapperForLead wrapperInstance = new WrapperForLead();
        Lead leadObj = new Lead();
        if((String.isNotBlank(strLastname))||(String.isNotBlank(strCompany))||(String.isNotBlank(strStatus))) {                                             
        	leadObj.LastName = strLastname;
        	leadObj.FirstName = strFirstName;
        	leadObj.Status = strStatus;
        	leadObj.Company = strCompany;
        	leadObj.Email = strEmail;
        	leadObj.Phone = strPhone;
        	try{
            	// Inserting lead record 
            	Database.SaveResult results = Database.insert(leadObj); 
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
        	catch(DmlException e) { 
            	wrapperInstance.blIsSuccess = false; 
           	 	wrapperInstance.strleadId = ''; 
            	wrapperInstance.strstatus = e.getMessage();
        	} 
        }
        else {
              wrapperInstance.strstatus = Constants.strErroeMsgForWebservice;
        }
        return wrapperInstance;
           
	}
    
    // Method to delete the lead record 
    webService static WrapperForLead deleteLead(String strFirstName, String strLastname, String strEmail, String strPhone){
        string showMessage;
        // Retriving records having same FirstName
        List<Lead> leadList=[Select Id 
                             From Lead 
                             Where FirstName = :strFirstName AND
                                   LastName = :strLastname AND
                                   Email = :strEmail AND
                                   Phone = :strPhone];
        WrapperForLead wrapperInstance = new WrapperForLead();
            // If record exists,delete the record
            if (!leadList.isEmpty()) {
            	delete leadList;
                wrapperInstance.blIsSuccess = true;
            	wrapperInstance.strstatus = Constants.strSuccess;
            }
            else {
                // If record is not deleted ,show the message
            	wrapperInstance.blIsSuccess = false; 
            	wrapperInstance.strleadId = '';  
            	wrapperInstance.strstatus = Constants.strErroeMsgForWebservice;
            }
        return wrapperInstance;
	}
    // Method to update the lead record
    webService static WrapperForLead updateLead(String strFirstName,String strLastname,String strEmail,String strPhone){
        string showMessage; 
        // Retriving the list form the lead to update      
        List<Lead> leadList = new List<Lead> ([SELECT Id,Phone,Email
                                              FROM Lead
                                              WHERE FirstName = :strFirstName
                                              AND LastName = :strLastname]);
        WrapperForLead wrapperInstance = new WrapperForLead();
       // If lead is not empty 
            if(!leadList.isEmpty()) {
                for(lead lstObj:leadList) {
                	lstObj.Phone = strPhone;
                	lstObj.Email = strEmail;
                }
            // Update the list 
            update leadList;
            wrapperInstance.blIsSuccess = true;
            wrapperInstance.strleadId = ''; 
           	wrapperInstance.strstatus =  Constants.strSuccess;
            }
            else {
                // If record is not updated ,show the message
            	wrapperInstance.blIsSuccess = false; 
            	wrapperInstance.strleadId = ''; 
            	wrapperInstance.strstatus = Constants.strErroeMsgForWebservice;   
            }
        return wrapperInstance;
    }
    
    // Creating wrapper class
    global class wrapperForLead {
        webservice Boolean blIsSuccess;
        webservice String strleadId;
        webservice String strstatus;
        
        // Initializating the variables
         public WrapperForLead() {
            blIsSuccess = false;
            strleadId = '';
            strstatus = '';
         }
    }
}