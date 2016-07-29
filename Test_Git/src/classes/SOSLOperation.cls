/****************************************************************************
 Class Name: childToParentOperations
 Created Date:14/7/2015
 Description: This class performs operation from child object to parent
				
*****************************************************************************/
public class SOSLOperation {
    //finding a word in data
    public void findingWordInObjects(){ 
    	List<List<SObject>> searchList = [FIND 'Test' IN NAME FIELDS RETURNING contact(name), account(name),lead(name),user(name)];
 
     	contact[] conList = ((List<contact>)searchList[0]);
     	account[] accList = ((List<account>)searchList[1]);
     	lead[] leadList = ((List<lead>)searchList[2]);
     	user[] userList = ((List<user>)searchList[3]);
		
        if(conlist!=null && conlist.size()>0){
        	for(contact objcon:conList) 
            	system.debug(objcon+'Displaying Result of contact');
        }
         else
               system.debug('Records not found'); 
        
        if(accList!=null && accList.size()>0)
        	for(account objacc:accList) {
           		system.debug(objacc+'Displaying Result of account');
        	}
        else
        	system.debug('Records not found'); 
        
        if(leadList!=null && leadList.size()>0){
        	for(lead objlead:leadList)
				system.debug(objlead+'Displaying Result of lead.');
        }
        else
        	system.debug('Records not found'); 
        
        if(userList!=null && userList.size()>0){ 
        	for(user objuser:userList)
           		system.debug(objuser+'Displaying Result of user');
        }
        else
        	system.debug('Records not found');
     }
                  
}