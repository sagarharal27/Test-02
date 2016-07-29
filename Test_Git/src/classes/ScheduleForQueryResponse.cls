/************************************************************************
 Class Name: ScheduleForQueryResponse
 Created Date:4/9/2015
 Description: This schedular class for sending response
*************************************************************************/ 
global with sharing class ScheduleForQueryResponse implements Schedulable {
    
    global void  execute(SchedulableContext sc) {
       
        Database.executebatch(new BatchForResponse());
        
    }  

}