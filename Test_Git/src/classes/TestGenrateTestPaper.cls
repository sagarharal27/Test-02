@isTest
private class TestGenrateTestPaper {

    static testMethod void getLoginWithOldUser() {
        Proffesor__c profInstance = new Proffesor__c();
        GenerateTestPaper controllerInstance = new GenerateTestPaper();
        
        PageReference loginPage = page.LoginPageOfTest;
        loginPage.getParameters().put('idOfProf',profInstance.Id);
        loginPage.getParameters().put('nameOfProf',profInstance.Proffesor_Name__c);
        loginPage.getParameters().put('nameOfStandard',profInstance.Standard__c);
        loginPage.getParameters().put('password',profInstance.password__c);
        PageReference testReference = controllerInstance.redirectToStandardOption();
        Test.setCurrentPage(testReference);
        system.assertEquals('/apex/generatetestpaper',controllerInstance.redirectToStandardOption().getUrl());
    }
    static testMethod void selectRadioButtonForStandard() {
        List<Standard__c> listOfStd = TestDatafactory.dataForStandard(5); 
        insert listOfStd; 
        /*List<Standard__c> listStd = new List<Standard__c>(); 
        for( Integer i = 0; i < 5; i++ ) {
            listStd.add(new Standard__c (Standard_Name__c = '9 th'+i));
        }
        insert listStd;*/
        
        GenerateTestPaper contollerInstance = new GenerateTestPaper();
        List<SelectOption> SelectStandardOptions = contollerInstance.getOptionsForStandard();
        system.assertEquals(5,SelectStandardOptions.size());
        
         
    }
    static testMethod void selectRadioButtonForSubject() { 
        List<Standard__c> listStd = new List<Standard__c>();
        for( Integer i = 0; i < 5; i++ ) {
            listStd.add(new Standard__c (Standard_Name__c = '9 th'+i));
        }
        insert listStd;
        
        List<Subject__c> listSub = new List<Subject__c>();
        for( Integer i = 0; i < 5; i++ ) {
            listSub.add(new Subject__c (Subject_Name__c = 'History'+i,subToStd__c = listStd[0].Id));
        }
        insert listSub;
        
        GenerateTestPaper contollerInstance = new GenerateTestPaper();
        List<SelectOption> SelectSubjectOptions = contollerInstance.getallSubjects();
        List<Subject__c> listSub1 = new List<Subject__c>();
        listSub1 = [select id from Subject__c];
        system.assertEquals(5,listSub1.size());
    }
    static testMethod void selectRadioButtonForMarks() {
        GenerateTestPaper contollerInstance = new GenerateTestPaper();
        List<SelectOption> SelectMarksOptions = contollerInstance.getOptionsForMarks();
        
        system.assertEquals(3,SelectMarksOptions.size());
    }
    static testMethod void selectRadioButtonForChapters() {
        List<Standard__c> listStd = new List<Standard__c>();
        for( Integer i = 0; i < 5; i++ ) {
            listStd.add(new Standard__c (Standard_Name__c = '9 th'+i));
        }
        insert listStd;
        
        List<Subject__c> listSub = new List<Subject__c>();
        for( Integer i = 0; i < 5; i++ ) {
            listSub.add(new Subject__c (Subject_Name__c = 'History'+i,subToStd__c = listStd[0].Id));
        }
        insert listSub;
        
        List<Chapter__c> listChap = new List<Chapter__c>();
        for(Integer i = 0; i < 5; i++) {
            listChap.add(new Chapter__c(Chapter_Name__c = 'chapter'+i,ChapToSub__c = listSub[0].Id));
        }
        insert listChap;
        
        GenerateTestPaper contollerInstance = new GenerateTestPaper();
        List<SelectOption> SelectChapterOptions = contollerInstance.getallChapter();
        List<Chapter__c> listChap1 = new List<Chapter__c>();
        listChap1 = [select id from Chapter__c];
        system.assertEquals(5,listChap1.size());
    }
    static testMethod void selectRadioButtonForTopics() {
        List<Standard__c> listStd = new List<Standard__c>();
        for( Integer i = 0; i < 5; i++ ) {
            listStd.add(new Standard__c (Standard_Name__c = '9 th'+i));
        }
        insert listStd;
        
        List<Subject__c> listSub = new List<Subject__c>();
        for( Integer i = 0; i < 5; i++ ) {
            listSub.add(new Subject__c (Subject_Name__c = 'History'+i,subToStd__c = listStd[0].Id));
        }
        insert listSub;
        
        List<Chapter__c> listChap = new List<Chapter__c>();
        for(Integer i = 0; i < 5; i++) {
            listChap.add(new Chapter__c(Chapter_Name__c = 'chapter'+i,ChapToSub__c = listSub[0].Id));
        }
        insert listChap;
        
        List<Topic__c> listTopic = new List<Topic__c>();
        for(Integer i = 0; i < 5; i++) {
            listTopic.add(new Topic__c(Topic_Name__c = 'chapter'+i,ChapToTopic__c = listChap[0].Id));
        }
        insert listTopic;
        
        GenerateTestPaper contollerInstance = new GenerateTestPaper();
        List<SelectOption> SelectTopicsOptions = contollerInstance.getallTopic();
        List<Topic__c> listTopic1 = new List<Topic__c>();
        listTopic1 = [select Id from Topic__c];
        system.assertEquals(5,listTopic1.size());
    }
    
 }