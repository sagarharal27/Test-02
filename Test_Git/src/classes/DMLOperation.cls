/****************************************************************************
 Class Name: DMLOperation
 Created Date:14/7/2015
 Description: This class displays record of opportunity having amount
				greater than 10000
*****************************************************************************/ 
public class DMLOperation {
    //inserting record to lead
     public void DMLInsertRecord(){
     	List<Lead> LlistofLead = new List<Lead>(); 
      	for(Integer i=0; i<10 ;i++){ 
        	Lead leadL = new Lead(LastName='Testing'+i, Company='Test pvt ltd Inc.',
        	Status='Status changed', Unique__c= 'Test no'+i);
        	LlistofLead.add(leadL);
        }  
  		
     	try {
         	insert LlistofLead;
     	}
        
     	catch(DMLException e){ 
         
         	for (Integer i = 0; i < e.getNumDml(); i++){
             	System.debug(e.getDmlMessage(i));
         	}
         
         Logs__c error=new Logs__c();
         string strErrorType=e.getTypeName();
         string strError=e.getMessage();
        // string strFieldEffected=e.getDmlFieldNames();
         
         error.Error_type__c = strErrorType;
         error.Error__c = strError;
         //error.Field_Effected__c= strFieldEffected
         insert error;
     }
   }
    

    
    //deleting record fron account which are inactive 
	public void DMLdeleteInactiveRecord() {
  		List<Account> accountList= [Select id, name from Account Where Active__c ='No' And CreatedDate = LAST_90_DAYS];
    	if(accountList!=null && accountList.size()>0){
    	   for(Account acc:accountList ) {  
        	   System.debug(acc+'Displaying Records..');
    	   }
    	}
    	else{
            system.debug('Records not found');
        }
     Delete accountList;  
	}
    
    //upserting records to aseet
	public void assetRecord(){
    	list<Asset> assetlist =  new list<Asset>();
        for(integer i=0;i<5;i++){
            assetlist.add(new Asset(Name='Test1'+i,Line_Item_Id__c='ItemNo'+i,AccountId='00128000004UkTX'));
        }
        try{
            upsert assetlist Line_Item_Id__c;
            system.debug(assetlist + 'assetlist::');
           }
    
    catch(DMLException e){
    	system.debug('Exception Occured:'+e);
        }
    
    }
}