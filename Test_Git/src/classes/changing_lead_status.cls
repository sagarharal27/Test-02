/************************************************************************
 Class Name: lead_status
 Created Date:11/1/2015
 Description: This class changes the lead status to Status Changed
*************************************************************************/ 
public class changing_lead_status {
    
    public void compareOppDate() {
        
        List<Opportunity> lstOpp = new List<Opportunity>();
        Date myDate = Date.newInstance(2015, 12, 02);
        System.debug('--------myDate--------'+myDate);
        String strTempDate = String.valueOf(myDate);
        System.debug('--------strTempDate--------'+strTempDate);
        
        lstOpp = [select id,CloseDate,dreamMap__tempDate__c,dreamMap__tempDate1__c from Opportunity];
        System.debug('--------lstOpp--------'+lstOpp);
        
        /*
        for(Opportunity opp : lstOpp) {
            System.debug('--------opp.CloseDate--------'+String.valueOf(opp.CloseDate));
            if(strTempDate == String.valueOf(opp.CloseDate)) {
                System.debug('--------TRUE--------');
            }
            else {
                System.debug('--------False--------');
            }
        }
        */
        for(Opportunity opp : lstOpp) {
            if(String.valueOf(opp.dreamMap__tempDate__c) == String.valueOf(opp.dreamMap__tempDate1__c)) {
                System.debug('--------TRUE Temp Date--------');
            }
            else {
                System.debug('--------False Temp Date--------');
            }
        }
    }
    
    /*
    public void displayChangedLead(){
    List<Lead> LeadList = [Select Id, Name, Status FROM Lead WHERE Status = 'Closed - Not Converted'];
    System.debug(LeadList);
	for(Lead Lobj : LeadList){
		Lobj.Status = 'Status changed';
        }
        Update LeadList;
        System.debug(LeadList);
    }*/
}