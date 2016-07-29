global with sharing class SchedularForLead implements Schedulable{
   // public static string cron = '0 0 /3  * * ?'; //after every 3 hours in a day.
    global void  execute(SchedulableContext sc) {
        
       System.schedule('JobOfLead'+system.now(),' 0 0 /3  *  * ? ',new SchedularForLead());
        Database.executebatch(new AvoidDuplicationOfLead());
    }
}