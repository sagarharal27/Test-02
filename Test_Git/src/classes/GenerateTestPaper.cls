public with sharing class GenerateTestPaper {
    
    public List<Proffesor__c> listProf{get; set;}
    public List<Standard__c>StandardList{get; set;}
    public List<Subject__c> SubjectList{get; set;}
    public List<Chapter__c> chapterList{get; set;}
    public List<Topic__c> topicList{get; set;}
    public List<Question__c> questionList{get; set;}
    public List<Question__c> qList{get;set;}
    public List<Question__c> validateMarksList{set; get;}
    public List<Id> idList ;
     
    public List<selectOption> listOfSelectSubject{get; set;}
    public List<selectOption> listOfSelectChapter{get; set;}
    public List<selectOption> listOfSelectTopic{get; set;}
    public List<selectOption> listOfStandardOption{get; set;}
    public List<selectOption> listOfMarksOptions{get; set;}
    public List<wrapperForSelectQuestions> wrapList{get;set;}
    
    public Id profID{get; set;}
    public String profName{get;set;}
    public String password{get;set;} 
    public String strSubject{get; set;} 
    public String strStandard{get; set;}
    
    public String strMarks{get; set;}
    public String sub{get; set;}
    public Integer totalMarks;
    
    public String strQue{get; set;}
    public String strAns{get; set;}
    
    public String holdSubject{get; set;}
    public List<String> listholdChapter{get; set;}
    public List<String> listHoldTopic{get; set;}
    public List<String> listHoldQue{get; set;}
       
    public Proffesor__c profInstance{get; set;}
    public Subject__c subInstance{get;set;}
    public Question__c queInstance{get;set;}
    
    public Boolean hideMarks{get;set;}
    public Boolean hideChapter{get;set;}
    public Boolean hideTopic{get;set;}
    public Boolean getQue{get ;set;}
    public Boolean hideQue{get; set;}
    public Boolean hideQueVar{get; set;}
    public Boolean hideButton{get; set;}
    public Boolean tempAlert{get; set;}
    public Boolean hideBlockOfPDFButtons{get; set;} 
    
    public GenerateTestPaper() {
        system.debug('----into constructor -------------------->');
        listOfSelectChapter = new List<selectOption>();
        listOfSelectTopic = new List<selectOption>();
        listOfMarksOptions = new List<selectOption>();
        validateMarksList = new List<Question__c>();
        
        StandardList = new List<Standard__C>();
        SubjectList = new List<Subject__c>();
        listProf = new List<Proffesor__c>();
        chapterList = new List<Chapter__c>();
        topicList = new List<Topic__c>();
        questionList = new List<Question__c>();
        qList = new List<Question__c>();
        idList = new List<Id>();
        
        listHoldTopic = new List<String>();
        listHoldQue = new List<string>();
        listholdChapter = new List<string>();
        
        profInstance = new Proffesor__c();
        subInstance = new Subject__c();
        queInstance = new Question__c();
        
        wrapList = new List<wrapperForSelectQuestions>();
        hideMarks = false;
        hideChapter = false;
        hideTopic = false;
        getQue = false;
        hideQue = false;
        hideQueVar = false;
        hideButton = true;
        tempAlert = false;
        hideBlockOfPDFButtons = false;
        
        sub = '';
        strMarks = '10';
        strQue = 'Que)';
        strAns = 'Ans)';
        totalMarks = 0;
    }
/*---------------------------------Show subject Name on PDF---------------------------------------*/
    public void gettingID() {
        List<Subject__c> subList = new List<Subject__c>();
        Id i = Id.valueOf(strSubject);
        subList = [select Id,Subject_Name__c from Subject__c where Id = :i];
            for(Subject__c sInstance : subList) {
                sub = sInstance.Subject_Name__c;
            }
    }
    public void disableQueButton() {
        hideButton = false;
    }
/*------------------------------ Get Login with new user------------------------------------------*/
    // Fuction to get login with new user
    public PageReference redirectWithNewUser() {
        if((string.isBlank(profName)) || (string.isBlank(password)) ||
            (string.isBlank(strStandard))) {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.info,
                                        System.Label.InValidUserNameAndPassword));
            return null;
            }
        else {
            try {
                profInstance.Proffesor_Name__c = profName;
                profInstance.password__c = password;
                profInstance.Standard__c = strStandard;
                insert profInstance;
            
                profID = apexpages.currentpage().getparameters().get('idOfProf');
                PageReference  newPage = Page.GenerateTestPaper;
                newPage.getParameters().put('idOfProf',profID);
                newPage.getParameters().put('nameOfStandard',strStandard);
                newPage.setRedirect(True);
                Return newPage;
            }
            catch(Exception e){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.info,
                'This User is already present.Plese login for further operation'));
                return null;
            }
        }
    }
/*------------------------------ Get Login with Old user------------------------------------------*/
    // Page redirection to standard option
    public PageReference redirectToStandardOption() {
        if(string.isBlank(profName)||string.isBlank(strStandard)||string.isBlank(password)) {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,
            'Please enter username, password and standard to login'));
            return null;
        }
        else {
            listProf = [select id,Proffesor_Name__c from Proffesor__c
                        where Proffesor_Name__c = :profName];
         
            System.debug('----listProf-----'+listProf);
            if(listProf.size() == 0) {
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,
                                        'Invalid User'));
                return null;
            }
            else {                  
                System.debug('----listProf-----'+listProf);
                System.debug('----strStandard-----'+strStandard);
                profID = apexpages.currentpage().getparameters().get('idOfProf');
                PageReference newPage = Page.GenerateTestPaper;
                newPage.getParameters().put('idOfProf',profID);
                newPage.getParameters().put('nameOfStandard',strStandard);
                newPage.setRedirect(True);
                Return newPage;
            }
        }
    }
    public void hideBlockOfMarks() {
        wrapList.clear();
        system.debug('strSubject:::' +strSubject);
        if(strSubject == null) {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,
            'Please select subject first'));
        }
        else{
            hideMarks = true;
            getOptionsForMarks();
        }
    }
/*------------------------------ show options for marks------------------------------------------*/
    public List<selectoption> getOptionsForMarks() {
        listOfMarksOptions = new List<selectOption>();
        listOfMarksOptions.add(new SelectOption('10','10'));
        listOfMarksOptions.add(new SelectOption('30','30'));
        listOfMarksOptions.add(new SelectOption('40','40'));
        return listOfMarksOptions;
    }
/*------------------------------ options for standard------------------------------------------*/    
    // List of all standard fields
    public List<selectoption> getOptionsForStandard() {
        listOfStandardOption = new List<selectOption>();
        StandardList = [select id, Standard_Name__c from Standard__c]; 
       
            for(Standard__c stdInstance : StandardList) {
                listOfStandardOption.add(new Selectoption(stdInstance.Standard_Name__c,
                                                        stdInstance.Standard_Name__c));
            }
        return listOfStandardOption;
    }
/*------------------------------ Options for subjects------------------------------------------*/
    // List of all subjects
    public List<selectOption> getallSubjects() {
       
       strStandard = apexpages.currentpage().getparameters().get('nameOfStandard');
       listOfSelectSubject = new List<selectOption>();
       SubjectList = [select id, Subject_Name__c from Subject__c 
                       where subToStd__r.Standard_Name__c = :strStandard];
        
        System.debug('----SubjectList-----'+SubjectList);  
        for(Subject__c subjectInstance : SubjectList) {
            listOfSelectSubject.add(new Selectoption(subjectInstance.Id,
                                                        subjectInstance.Subject_Name__c));
        } 
        System.debug('----listOfSelectSubject-----'+listOfSelectSubject);
        return listOfSelectSubject;
    } 
/*-----------------------------------options for chapter------------------------------------------*/
    public void hideBlockOfChapter() {
        hideChapter = true;
        getallChapter();
    }
    public void hideQueBlock() {
        hideQueVar = true;
    }
/*-----------------------------------Getting list of all chapters---------------------------------*/
    // List of all chapter
    public List<selectOption> getallChapter() {
        hideMarks = true;
        chapterList = new List<Chapter__c>();
        listOfSelectChapter = new List<SelectOption>(); 
        
        chapterList = [select id,ChapToSub__c, Chapter_Name__c
                       from Chapter__c
                       where ChapToSub__c = :strSubject];
        
        for(Chapter__c chapInstance : chapterList) {
            listOfSelectChapter.add(new Selectoption(chapInstance.Id,chapInstance.Chapter_Name__c));
        }
        System.debug('----listOfSelectChapter-----'+listOfSelectChapter);
        return listOfSelectChapter;
    }
/*---------------------------------Displaying block of Topics-------------------------------------*/
    // List of all topics
    public void hideBlockOfTopics() { 
        if(listholdChapter.isEmpty()) {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,
                                 'Please select Chapter first'));
        }
        else {
            hideTopic = true;
            getallTopic();
        }
    }
/*-----------------------------------options for topic------------------------------------------*/
    // List of all Topics
    public List<selectOption> getallTopic() {
        listOfSelectTopic = new List<selectOption>();
        topicList = new List<Topic__c>();
        
        topicList = [select Topic_Name__c from Topic__c where ChapToTopic__c  IN :listholdChapter];
        System.debug('----topicList-----'+topicList);
  
            for(Topic__c topicInstance : topicList) {
                listOfSelectTopic.add(new Selectoption(topicInstance.Topic_Name__c,
                                                        topicInstance.Topic_Name__c));
            }
            System.debug('----listOfSelectTopic-----' + listOfSelectTopic);
            return listOfSelectTopic;
    } 
    // gettiong List of all questions
    public void getAllQuestions() {
        getQue = true;
        allQuestion();
    }
/*------------------------------select  questions------------------------------------------*/
    // Generating List of all questions
    public List<Question__c> allQuestion() {
        getQue = true;
        List<Id> idList = new List<Id>();
        topicList = new List<Topic__c>();
        
        topicList = [SELECT Id FROM Topic__c WHERE Topic_Name__c IN :listHoldTopic];
        System.debug('----listHoldTopic-----'+listHoldTopic);
       
        for(Topic__c topInstance : topicList) {
            idList.add(topInstance.Id);
            System.debug('----idList-----'+idList);
        }
        questionList = new List<Question__c>(); 
        questionList = [select id,MCQ__c,
                               Theory_Question__c,
                               marks__c,
                               Option_1__c,
                               Option_2__c,
                               Option_3__c,
                               Option_4__c,
                               Answer__c,
                               Theory_Answer__c
                        from Question__c
                        where QueToTopic_del__c IN : idList];
        return questionList;
    }
/*------------------------------validation of marks------------------------------------------*/
 
    public void validationOfMarks() { 
        System.debug('tempAlert-----'+tempAlert);
        //String instance = ApexPages.currentpage().getParameters().get('wrapperId'); 
        system.debug('---validationOfMarks called through action function ------->');
        system.debug('------getParameters--------->'+ApexPages.currentpage().getParameters().get('wrapperId'));
        
        string temp = ApexPages.currentpage().getParameters().get('wrapperId');
        temp = temp.substringBetween('index=',',');
        system.debug('--temp-->'+temp);
        
        Integer tempIndex = Integer.valueOf(temp);
        system.debug('--tempIndex-->'+tempIndex);
        
        wrapperForSelectQuestions wrapperTemp;
        for(wrapperForSelectQuestions wrapper : wrapList){
            if(wrapper.index == tempIndex){
                system.debug('----milalela wrapper------->'+wrapper);
                wrapperTemp = wrapper;
            }
        }
        totalMarks = 0;
        Question__c que = new Question__c();
        
        for(wrapperForSelectQuestions wrapper : wrapList){
            if(wrapper.blSelect == true){
                totalMarks += Integer.valueOf(wrapper.que.marks__c);
            }
        } 
        System.debug('----totalMarks-----'+totalMarks);
        
        if(totalMarks > integer.valueof(strMarks)) {
            System.debug('\n\n\n---strMarks-----'+strMarks);//////////////////////
            
            tempAlert =  true;
            System.debug('tempAlert-----'+tempAlert);
          }
        }
/*------------------------------------creating wrapList------------------------------------------*/
    // List of questions in wrapper List
    public List<wrapperForSelectQuestions> getwrapList() {
        questionList = allQuestion();
        System.debug('\n\n\n---questionList-----'+questionList);
        Integer index = 1;
            for(Question__c q :questionList) {
                wrapperForSelectQuestions wrapInstance = new wrapperForSelectQuestions(q,index);
                index++;
                wrapList.add(wrapInstance);
                
            }
            System.debug('----wrapList-----'+wrapList);
            return wrapList;
    }
/*----------------------------------Displaying block of Questions---------------------------------*/
    // getting list of wrapper 
    public void getQueList() {
        wrapList.clear();
        if(listHoldTopic.isEmpty()) {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,
                             'Please select Topics first'));
        }
        else {
            hideQue = true;
            getwrapList();
        }
    }
/*------------------------------------generating pdf of Questions---------------------------------*/
    // Method to generate pdf
    public string getPdfData() {
        if(ApexPages.currentPage().getParameters().get('p')!=null)
            return 'pdf';
        else
            return null;
    }
    
    public pageReference generatePdf() {
        Unit_Test__c testInstance;
        Questions_In_Test__c jInstance;
        List<Questions_In_Test__c> lstQue = new List<Questions_In_Test__c>();
        
        testInstance = new Unit_Test__c();
        insert testInstance;
        
        system.debug('------qList----->'+qList);
        String testName = string.valueOf(testInstance.name);
        
        for(Question__c qInstance : qList) {
            lstQue.add(new Questions_In_Test__c(JunctionToTest__c = testInstance.Id,
                                            JunctionToQue__c=qInstance.Id));
        }
        system.debug('------testInstanceID----->'+testInstance.ID);
        insert lstQue;
        
        // PDF generation of questions
        pageReference pdf = page.PDFOfQuestions;
        pdf.getParameters().put('p','p');
        system.debug('------pageReference----->'+pdf);
        return pdf;
    }
/*------------------------------------generating pdf of Answers-----------------------------------------*/
    // Method to generate pdf
    public string getPdfAnswers() { 
        if(ApexPages.currentPage().getParameters().get('p')!=null)
            return 'pdf';
        else
            return null;
    }
    public pageReference generateAnswersPdf() {
        pageReference pdf = page.PDFOfAnswers;
        pdf.getParameters().put('p','p');
        return pdf;
    }
/*------------------------------------get que from wraper-----------------------------------------*/
    // Getting list of all selected questions on page
   public void getSelectedFromWrapper() { 
        System.debug('-\n\n\n\n\n\n\n--wrapList-----'+ wrapList+'\n\n\n\n\n\n\n');
        qList.clear();
       
        for(wrapperForSelectQuestions wp : wrapList) {
            if(wp.blSelect) {
                System.debug('-\n\n\n\n\n\n\n--wp.que-----'+ wp.que+'\n\n\n\n\n\n\n');
                qList.add(wp.que);
            }
             System.debug('-n--qList-----'+ qList);
        }
        generatePdf();
    } 
/*----------------------------------------wrapper-------------------------------------------------*/
    // Wrapper class
    public with sharing class wrapperForSelectQuestions {
        public Integer index{get;set;}
        public Question__c que{get; set;}
        public Boolean blSelect{get; set;}
        // Constructor for wrapper class
        public wrapperForSelectQuestions(Question__c que,Integer index) {
            this.index = index;
            this.que = que;
            blSelect = false;
        }
    }
/*-----------------------------------showPDFButtons-------------------------------------------------*/
    public void showPDFButtons() {
        hideBlockOfPDFButtons = true;
    }
}