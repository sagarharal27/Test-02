/**************************************************************************************
 Class Name: selectingEnrollnmentYear
 Created Date:11/7/2015
 Description: This class displays Accounts having Enrollnment year as 2010,2013,2014
***************************************************************************************/ 

public class selectingEnrollnmentYear {
    List<Account> listAccount;
    //Displaying record of account depending on enrollnment year
    public void accountPicklistOfTwoYear() {
         listAccount = [Select Name, Id, Enrollnment_Year__c 
                              			From Account  
                              			where Enrollnment_Year__c ='2013;2014' OR Enrollnment_Year__c ='2010' ]; 
                                      	                        			
        for( Account lst : listAccount) {  
    		if(lst.Enrollnment_Year__c=='2010'){
    		system.debug('List of records  '+lst);
    		}
            else{
				system.debug('List of records  '+lst);                
            }
    
    	}
    }
}