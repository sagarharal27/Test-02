public with sharing class ScheduleControllerMMG {
    public List<OpportunityLineItemSchedule> lstOppLineItemSch;
    public Map<Id,Map<Id,Map<String,List<OpportunityLineItemSchedule>>>> mapOppLineItemSch{get;set;}
    public Map<Id,String> displayOppName{get; set;}
    public Map<Id,String> displayOppLineItemName{get; set;}
    
    public OpportunityLineItemSchedule oppSch{get; set;}
    public Id oppSchId{get; set;}
    public List<String> listOfDisplayMonths{get; set;}
    
    //Contructor
    public ScheduleControllerMMG() {
        
        mapOppLineItemSch = new Map<Id,Map<Id,Map<String,List<OpportunityLineItemSchedule>>>>();
        
        lstOppLineItemSch = new List<OpportunityLineItemSchedule>();
        oppSch = new OpportunityLineItemSchedule();
        
        displayOppName = new Map<Id,String>();
        displayOppLineItemName = new Map<Id,String>();
        
        listOfDisplayMonths = new List<String>();
        getlistOfDisplayMonths();
        getlstOppLineItemSch();
    }

/*---------------------------------------Getting all values in map--------------------------------*/
    public void getlstOppLineItemSch() {
        
        lstOppLineItemSch = [SELECT Quantity,
                                    Revenue,
                                    ScheduleDate,
                                    CreatedById,
                                    OpportunityLineItem.Id,
                                    OpportunityLineItem.Name,
                                    OpportunityLineItem.Opportunity.Id,
                                    OpportunityLineItem.Opportunity.Name
                             FROM OpportunityLineItemSchedule
                             WHERE createdById=:UserInfo.getUserId() AND
                             ScheduleDate >=: system.today()];
        System.debug('-----lstOppLineItemSch----'+lstOppLineItemSch);
        
        if(!lstOppLineItemSch.isEmpty()) {
            for(OpportunityLineItemSchedule oppSch : lstOppLineItemSch) {
            
                if(mapOppLineItemSch.containsKey(oppSch.OpportunityLineItem.Opportunity.Id)) {
                    displayOppName.put(oppSch.OpportunityLineItem.Opportunity.Id,oppSch.OpportunityLineItem.Opportunity.Name);
                    System.debug('-----displayOppName----'+displayOppName);
                    Map<Id,Map<String,List<OpportunityLineItemSchedule>>> innerMap = mapOppLineItemSch.get(oppSch.OpportunityLineItem.Opportunity.Id);
                
                    if(innerMap != null) {
                        if(innerMap.containskey(oppSch.OpportunityLineItem.Id)) {
                            displayOppLineItemName.put(oppSch.OpportunityLineItem.Id,oppSch.OpportunityLineItem.Name);
                            System.debug('-----displayOppLineItemName----'+displayOppLineItemName);
                            Map<String,List<OpportunityLineItemSchedule>> innerMostMap = innerMap.get(oppSch.OpportunityLineItem.Id);
                    
                                if(innerMostMap != null ) {
                                    if(innerMostMap.containsKey(convertNumberToMonth(oppSch.ScheduleDate.month()))) {
                                        innerMostMap.get(convertNumberToMonth(oppSch.ScheduleDate.month())).add(oppSch);
                                    }
                                    else{ 
                                        innerMostMap.put(convertNumberToMonth(oppSch.ScheduleDate.month()) , new List<OpportunityLineItemSchedule>{oppSch});
                                    }
                                }
                        }
                    }
                    else {  
                        Map<String,List<OpportunityLineItemSchedule>> innerMostmap = new Map<String,List<OpportunityLineItemSchedule>>();
                        innerMostmap.put(convertNumberToMonth(oppSch.ScheduleDate.month()), new List<OpportunityLineItemSchedule> {oppSch});
                        innerMap.put(oppSch.OpportunityLineItem.Id,innerMostMap);
                    }
                }
                else {
                    Map<Id,Map<String,List<OpportunityLineItemSchedule>>> innerMap = new Map<Id,Map<String,List<OpportunityLineItemSchedule>>>();
                    innerMap.put(oppSch.OpportunityLineItem.Id, new Map<String,List<OpportunityLineItemSchedule>> {convertNumberToMonth(oppSch.ScheduleDate.month())=>new List<OpportunityLineItemSchedule> {oppSch}} );
                    mapOppLineItemSch.put(oppSch.OpportunityLineItem.Opportunity.Id, innerMap);
                }
            }
        }
        System.debug('----mapOppLineItemSch----'+mapOppLineItemSch);  
    }
/*---------------------------------------Saving values in Quantity--------------------------------*/
    public void saveValuesInQuantity() {
        
        List<OpportunityLineItemSchedule> listOfSchedule = new List<OpportunityLineItemSchedule>();
        
        if(mapOppLineItemSch != null) {
        
            for(Id OppId : mapOppLineItemSch.keySet()) {
                Map<Id,Map<String,List<OpportunityLineItemSchedule>>> mapOppLineItemSch1 = mapOppLineItemSch.get(OppId);
            
                for(Id LineItemId : mapOppLineItemSch1.keySet()) {
                    Map<String,List<OpportunityLineItemSchedule>> mapOppSch = mapOppLineItemSch1.get(LineItemId);
                
                    for(String strMonth : mapOppSch.keySet()) {
                        listOfSchedule.addAll(mapOppSch.get(strMonth));
                    }
                }
            }
        }
        try {
            update listOfSchedule;    
        }
        catch(Exception e) {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,
                     'Can not Update the value. Enter Valid Inputs.'));
        }
        
    }
/*------------------------------------------displaying months name--------------------------------*/
    public List<String> getlistOfDisplayMonths() {
        List<Integer> listOfMonths = new List<Integer>();
        listOfDisplayMonths = new List<String>();

        Date fiscalYearEndDate;
        
        Integer orgFiscalMonth = [SELECT FiscalYearStartMonth
                                  FROM Organization].FiscalYearStartMonth;
        Integer currentFiscalMonth = system.Today().month(); 
       
        for(Integer i = currentFiscalMonth ; i <= 12; i++) {
            currentFiscalMonth++;
            listOfMonths.add(i);
            System.debug('----listOfMonths----'+listOfMonths);
        }
        for(Integer j = 1 ; j < orgFiscalMonth; j++) {
            listOfMonths.add(j);
            System.debug('----New listOfMonths----'+listOfMonths);
        }
        for(integer k : listOfMonths) {
            listOfDisplayMonths.add(convertNumberToMonth(k));
            System.debug('----listOfDisplayMonths----'+listOfDisplayMonths);
        }       
        return listOfDisplayMonths;
    }
/*---------------------------------------convert month into string--------------------------------*/
    public static String convertNumberToMonth(Integer monthNumber) {
        String currentMonth = '';
        if(monthNumber == 1) {
            return 'JAN';
        }
        else if(monthNumber == 2) {
            return 'FEB';
        }
        else if(monthNumber == 3) {
            return 'MAR';
        }
        else if(monthNumber == 4) {
            return 'APR';
        }
        else if(monthNumber == 5) {
            return 'MAY';
        }
        else if(monthNumber == 6) {
            return 'JUN';
        }
        else if(monthNumber == 7) {
            return 'JUL';
        }   
        else if(monthNumber == 8) {
            return 'AUG';
        }
        else if(monthNumber == 9) {
            return 'SEPT';
        }
        else if(monthNumber == 10) {
            return 'OCT';
        }
        else if(monthNumber == 11) {
            return 'NOV';
        }
        else if(monthNumber == 12) {
            return 'DEC';
        }
        else {
            return '';
        }
    }
}