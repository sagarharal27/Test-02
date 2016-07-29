/************************************************************************
 Class Name: Aggregate_function
 Created Date:14/7/2015
 Description: This class performs an aggregate functions
*************************************************************************/ 
public class aggregateFunctions {
	
    //method to calculate sum of opp.record which are closed
    public void sumOfAllClosedOpportunity(){
       // Date startdate=date.newInstance(2012,1,1);
		//Date enddate=date.newInstance(2015,8,20);
        
        List<AggregateResult> aggreResult = [Select SUM(opp.Amount) sum,CloseDate 
                                             From Opportunity opp 
                                             where CloseDate = LAST_N_MONTHS:2
                                             group by CloseDate];
        
        if(aggreResult!=NULL && aggreResult.size()>0){
            map<Integer,Double> mapYeartoSum = new map <Integer,Double>();
            
            for(AggregateResult alist : aggreResult){
                Date dateobj=Date.valueOf(alist.get('CloseDate'));
                Integer year=dateobj.year();
                Double amount = Double.valueOf(alist.get('sum'));
                
                if(mapYeartoSum.size()>0 && mapYeartoSum.containsKey(year))
                {
                    Double tempamount = mapYeartoSum.get(year);
                    amount = amount + tempamount;
                }
                mapYeartoSum.put(year,amount);
                system.debug(mapYeartoSum + 'mapYeartoSum::');
    		 }
    		system.debug(mapYeartoSum+'Map of Opportunity Records');  
  	 	}
        else{
            system.debug('Records not found');
        }
    }
   //method to display distinct Lead records on basis of 'Lead Source'having greater than 10 lead 
	public void AggregateLeadSource(){
	AggregateResult[] leadresults = [SELECT COUNT_DISTINCT(Name) , LeadSource
                                    FROM Lead
                                    where Leadsource<>null
                                    Group By LeadSource
                                    Having COUNT_DISTINCT(Name) > 8 
                                   ]; 
    for(AggregateResult aggreobj : leadresults){
		System.debug(aggreobj+'Records of lead ');
     }
	}
   //method to display distinct Lead records on basis of 'Lead Source' (map of map)
	public void mapOfmapOnLeadRecord(){
        Map<String, Map<String, Integer>> leadStatusMap = new Map<String, Map<String, Integer>>();
        AggregateResult[] result = [ SELECT COUNT(Name) leadCount,
                                    					Status,
                                    					LeadSource
                                    
                                    FROM Lead
                                    where Leadsource<>null
                              		GROUP BY LeadSource, Status];
        
			for(AggregateResult arrResult: result){
				//If outer map doesnot contain key
				if(!leadStatusMap.containsKey(String.valueOf(arrResult.get('Leadsource')))) {
                	
                  //put value(inner map) with the key
					leadStatusMap.put(String.valueOf(arrResult.get('Leadsource')),
                    new Map<String, Integer> {String.valueOf(arrResult.get('Status')) => Integer.valueOf(arrResult.get('leadCount'))});
                }
            	// If outer map contains key
            	else {
                	leadStatusMap.get(String.valueOf(arrResult.get('LeadSource'))).put(
                    String.valueOf(arrResult.get('Status')), Integer.valueOf(arrResult.get('leadCount')));
            	}
            
        	}
        	system.debug('--- leadStatusMap : ' + leadStatusMap);
    }
        
		/*Map<String, Map<String, Integer>> leadStatusMap = new Map<String, Map<String, Integer>>();
        AggregateResult[] result = [SELECT COUNT_DISTINCT(Name) leadCount,
                                      					 Status ,
                                      					 LeadSource
                                     FROM Lead
                                     GROUP BY LeadSource, Status ];
        
        map<String, Integer> innerMap=new map<String, Integer>();
        for(AggregateResult arr: result)
        	{
               innerMap.put(String.valueOf(arr.get('Status')),Integer.valueOf(arr.get('leadCount')));
                
                //for(AggregateResult arr1: result){ 
               		
                    leadStatusMap.put(String.valueOf(arr1.get('LeadSource')),innerMap);
                //} 
                
             }
        system.debug(leadStatusMap+'Displaying map');
        }*/
}