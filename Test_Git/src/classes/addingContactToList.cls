/************************************************************************
 Class Name: addingContactToList
 Created Date:14/7/2015
 Description: This class performs SOQL query
*************************************************************************/ 
public class addingContactToList {
    //method to display contacts
	public void displayingContact(){
		list<contact> listcon =[select id,name from contact];
        
        if(listcon!=null && listcon.size()>0){
            for(contact con:listcon){
				System.debug(con+'List of contact ');
       		}
        }
        else{
            system.debug('Records not found');
        }
    }
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
    
    //selecting active users
	public void displayingActiveUser(){
		list<user> listuser= [select Id,Username from user where IsActive=TRUE];
        //null check of list
        if(listuser!=null && listuser.size()>0){
			map<Id,User> mapActiveUser=new map<Id,User>();
            for(User userobj:listuser){
				mapActiveUser.put(userobj.Id,userobj);
            }
			system.debug(mapActiveUser+'Active users');
        }
        else{
            system.debug('Records not found');
        }
	}
    
    //Displaying record of account depending on enrollnment year
    public void accountPicklistOfYear() {
        List<Account> listAccount;
        listAccount = [Select Name, Id, Enrollnment_Year__c 
                              			From Account  
                              			where Enrollnment_Year__c ='2013;2014' OR Enrollnment_Year__c ='2010' ]; 
                                      	                        			
        for( Account objAcc : listAccount) {  
    		if(objAcc.Enrollnment_Year__c=='2010'){
    			system.debug('List of records  '+objAcc);
    			}
            	else{
					system.debug('List of records  '+objAcc);                
            	}
    
    		}
    	}
    //displyas record which are not in maharashtra and kerala
	public void recordNotHavingBillingState(){
		list<Account> listacc= [select Id,
                                 		name,
                                 		Billing_State__c
                                 from account
                                 where Billing_State__c
                                 NOT IN('Maharashtra','Kerala')
                                 ORDER by Billing_state__c
                                 DESC nulls last limit 1000];
		if(listacc!=null && listacc.size()>0){
		  system.debug(listacc + 'Records not having billing state maharashtra and kerala');
		}
		else{
		    system.debug('Records not found');
		}
    }
    
    //Displaying records of opportunity
    public void recordsHavingGreaterAmount() {
  		list<Opportunity> listacc= [select Id,name,Amount
                                 	from Opportunity 
                                 	where Amount >10000
                                 	ORDER by CreatedDate
                                 	ASC offset 5 all rows];
		//Null check for list
        if(listacc!=NULL && listacc.size()>0){
			system.debug(listacc+'Records of opportunity');
        }
        else{
        	system.debug('Records not found');
        }
	}
}