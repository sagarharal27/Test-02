public with sharing class HandlerForAfterDeleteAcc {
    public static List<Contact> lstContacts = new List<Contact>();
    public static Set<Id> setOfIdDepartment = new Set<Id>();
    
    public static void restoreEmpAfterDeleteDepartment(List<Account> lstDepartment) {
        System.debug('into handler==');
        for(Account deptObj : lstDepartment) {
            setOfIdDepartment.add(deptObj.Id); 
        }
        System.debug('setOfIdDepartment=='+setOfIdDepartment);
        lstContacts = [select id from Contact 
                  where
                  accountId IN :setOfIdDepartment
                  AND isDeleted = true All ROWS ];
        System.debug('lstContacts=='+lstContacts);
        undelete lstContacts;
    }
}