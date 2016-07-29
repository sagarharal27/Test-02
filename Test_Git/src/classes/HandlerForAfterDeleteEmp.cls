public with sharing class HandlerForAfterDeleteEmp {
   
    public static List<dreamMap__Employee__c> lstEmp = new List<dreamMap__Employee__c>();
    public static Set<Id> setOfIdDepartment = new Set<Id>();
    
    public static void restoreEmpAfterDeleteDepartment(List<dreamMap__Department__c> lstDepartment) {
        System.debug('into handler==');
        for(dreamMap__Department__c deptObj : lstDepartment) {
            setOfIdDepartment.add(deptObj.Id);
        }
        System.debug('setOfIdDepartment=='+setOfIdDepartment);
        lstEmp = [select id from dreamMap__Employee__c 
                  where
                  dreamMap__Department__c IN :setOfIdDepartment
                  AND isDeleted = true All ROWS ];
        System.debug('lstEmp=='+lstEmp);
        undelete lstEmp;
    }
}