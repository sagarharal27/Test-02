public class temp {
        
        List<Account> lstupdate;
    
        public void diplayingContactofEternus() {
        List<Account> listacc=[select a.id,a.name,(Select id,name from Contacts)
                                   from Account a where a.name='Eternus'];
            if(listacc!=null && listacc.size()>0){
                lstupdate=new list<Account>();
                
                for(Account acc:listacc){
                    if(acc.Contacts!=null && acc.Contacts.size()>0){
                        integer counter=0;
                    	for(Contact ct:acc.Contacts){
                                            	
                        	counter++;
                    	}
                        acc.contact_count__c=counter;
                        lstupdate.add(acc);
                   	}
                   else{
                	system.debug('Records not found');
            	   }
                }
              update lstupdate;  
            }
            else{
                system.debug('Records not found');
            }
             
        }
}