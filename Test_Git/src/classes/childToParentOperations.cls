/****************************************************************************
 Class Name: childToParentOperations
 Created Date:14/7/2015
 Description: This class performs operation from child object to parent
				
*****************************************************************************/ 
public class childToParentOperations {
    //Record having industry as media
    public void havingMediaIndustry(){
         List<Contact> conlist=[select Name,Account.Name
                              	from Contact
                              	where 
                                //Account.active__c= :Constants.strActiveAccount
                              	 Account.Industry= :Constants.strAccountIndustry];
         if(conlist!=Null && conlist.size()>0)
         	System.debug(conlist+'Displaying Recors');
         else
             system.debug('Records not found');
    }
    //Record having name as john
   /* public void recordsWithNameJohn(){
        List<C__c> listObject = [Select c.Id,name,
                                 		c.C_to_B__c,
                                 		c.C_to_A__c
                                 From C__c c
                                 WHERE Name = :ConstantClass.struserName];
        if(listObject!=null && listObject.size()>0) {
        	for(C__c CObj : listObject){
               System.debug(CObj+'Displaying records..');
            }
        }
        else{
            	system.debug('Records not found');    
            }
                
     	}*/
	}