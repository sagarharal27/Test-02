public class testTransaction{
public static void testMethod1(){

Account ac =   new account(name = 'test1rahul');
insert(ac);
system.debug('================ac==================='+ac);
Contact con = new contact(accountid = ac.id);
insert con;
}

}