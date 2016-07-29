trigger DepartmentTrigger on dreamMap__Department__c (after delete) {
    
    if(trigger.isAfter) {
        HandlerForAfterDeleteEmp.restoreEmpAfterDeleteDepartment(trigger.old);
    }

}