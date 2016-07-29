/*************************************************************************************************
Class : TestSOAPLeadOperation
Created Date : 23/8/2015
Description : This test class performs test cases for Lead Operations using SOAP webservices 
**************************************************************************************************/
@isTest
public class TestSOAPLeadOperation {

    static List<Lead> listLead = new List<Lead>() ;
    static List<Lead> leadListCheck = new List<Lead>() ;
    
    // Test method 1:Creting a lead with valid inputs
    static testMethod void creationOfLead() {
        listLead = TestDatafactory.leadData(10);
        insert listLead;
        SOAPServiceOfLead.createNewLead('Pooja','Jadhav','Open - Not Contacted',
                                        'Eternus','pooja@gmail.com','1111111' );
         
        leadListCheck = [select id from Lead];
        System.assertEquals(11,leadListCheck.size());
    }
    // Test method 2:Creting a lead with invalid inputs
    static testMethod void creationFailOfLead() {
        listLead = TestDatafactory.leadData(10);
        insert listLead;
        SOAPServiceOfLead.createNewLead('Pooja','','Open - Not Contacted',
                                        'Eternus','pooja.com','1111111' );
         
        leadListCheck = [select id from Lead]; 
        System.assertEquals(10,leadListCheck.size());
    }
    // Test method 3 : Deleting a lead with invalid inputs
    static testMethod void deletionOfLead() {
        listLead = TestDatafactory.leadData(10);
        insert listLead;
        SOAPServiceOfLead.deleteLead('TestFirst','TestLast1',
                                     'p@eternussolutions.com','11111112' );
         
        leadListCheck = [select id from Lead];
        System.assertEquals(9,leadListCheck.size());
    }
    // Test method 4 : Deleting a lead with invalid inputs
    static testMethod void deletionFailOfLead() {
        listLead = TestDatafactory.leadData(10); 
        insert listLead;
        SOAPServiceOfLead.deleteLead('TestFirst','',
                                     'p@com','11111112' );
         
        leadListCheck = [select id from Lead];
        System.assertEquals(10,leadListCheck.size());
    }
    // Test method 5 : Updating a lead with valid inputs
    static testMethod void updationOfLead() {
        listLead = TestDatafactory.leadData(10);
        insert listLead;
        SOAPServiceOfLead.updateLead('TestFirst','TestLast1',
                                     'p@gmail.com','999999' );
         
        leadListCheck = [select id from Lead where Email = :'p@gmail.com'];
        System.assertEquals(1,leadListCheck.size());
    }
    // Test method 6 : Updating a lead with invalid inputs
    static testMethod void updationFailOfLead() {
        listLead = TestDatafactory.leadData(10);
        insert listLead;
        SOAPServiceOfLead.updateLead('TestFirst','pooja',
                                     'p2gmail.com','99asdf9999' );
         
        leadListCheck = [select id from Lead where Email = :'p2gmail.com' ];
        System.assertEquals(0,leadListCheck.size());
    }
}