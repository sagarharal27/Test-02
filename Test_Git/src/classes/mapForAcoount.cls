/************************************************************************
 Class Name: subclass
 Created Date:14/7/2015
 Description: performs map on account
*************************************************************************/ 
public with sharing class mapForAcoount {
    
    //displaying records using map
    public void diplayingRecordsUsingMap(){
        
        List<Account> listAcc = [select id,name from Account];
        if(listAcc!=NULL && listAcc.size()>0){
        	//map having Account name as key
            map<string,id> mapOfAccount=new map<string,id>();
            //map having Account id as key
        	map<id,Account> mapOfAcc=new map<id,Account>();
            
            for(Account acc:listAcc){
               	mapOfAccount.put(acc.Name,acc.Id);
                mapOfAcc.put(acc.Id,acc);
        	}
            //Displaying maps
            system.debug(mapOfAccount+'Account name as Key');
            system.debug(mapOfAcc+'Account ID as Key');
    	}
    }
}