/***************************************************************************************************
Class : GlobalGiving
Created Date : 22/9/2015
Description : 
***************************************************************************************************/
global with sharing class GlobalGiving {
    
    public List<Response__c> callingWebServiceOfGlobalGivig;
    public List<Response__c> responseList{get;set;}
    public string projectName{get; set;}
    public List<wrapperForSelectResponse> wrapList{get; set;}
    public List<Response__c> resList{get;set;}
    
    public GlobalGiving() {
        wrapList = new List<wrapperForSelectResponse>();
        responseList = new List<Response__c>();
        resList = new List<Response__c>();
    }
    
    // Method to call webservice of Global Giving
    public static List<Response__c> getcallingWebServiceOfGlobalGivig() {
        
        List<Response__c> callingWebServiceOfGlobalGivig = new List<Response__c>();
        
        HttpRequest request = new HttpRequest();
        string hostUrl = ConstantForMMG.strHostURL;
        string gettingProject = ConstantForMMG.strURLForRequiredData;
        string api_key = ConstantForMMG.strAPI_Key;
         
        request.setEndpoint(hostUrl + gettingProject + '?api_key=' + api_key);
        request.setMethod('GET');
        request.setHeader(ConstantForMMG.strContentType,ConstantForMMG.strContentForm); 
        
        // Sending http request 
        Http http = new Http(); 
        HttpResponse response = http.send(request); 
        
        // Getting response
        System.debug(' \n\n\n  Response ' + response.getBody());
        
        Dom.Document doc = new Dom.Document();
        doc.load(response.getBody());
        dom.XmlNode root = doc.getRootElement(); 
        dom.XmlNode[] xrec = root.getChildElements();
        
        System.debug(' \n\n\n  root ' + root);
        System.debug(' \n\n\n  xrec ' + xrec);
        
        for(dom.XmlNode childNode : xrec) {
            system.debug('----intoFor 1----' +childNode.getName());
            Response__c responseInstance = new Response__c();  
            
            for (dom.XmlNode temp : childNode.getchildren()) {
                if (temp.getname() == 'organization') {
                    for(dom.XmlNode temp2 : temp.getchildren()) {
                        if (temp2.getname() == 'name') {
                            responseInstance.globalResponse__c = temp2.gettext().trim();
                        }
                    }
                }
            }
        callingWebServiceOfGlobalGivig.add(responseInstance);
        system.debug('\n\n\n  listOfResponse'+callingWebServiceOfGlobalGivig);
        }
        system.debug('\n\n\n  listInserted');
        return callingWebServiceOfGlobalGivig;
    }
    
    public List<wrapperForSelectResponse> getwrapList() {
        responseList = getcallingWebServiceOfGlobalGivig();
        system.debug('\n\n\n  responseList'+responseList);
        for(Response__c resInstance : responseList) {
            wrapperForSelectResponse wrapInstance = new wrapperForSelectResponse(resInstance);
            wrapList.add(wrapInstance);
            system.debug('\n\n\n ****wrapList'+wrapList);
        }
        return wrapList; 
    }
    
    
    public List<Response__c> getRequiredResponse() {
        getwrapList();
        if(!wrapList.isEmpty()) {
            for(wrapperForSelectResponse wrapInstance : wrapList) {
                if(wrapInstance.res != null && wrapInstance.res.globalResponse__c != null) {
                    system.debug('\n\n\n  projectName---> '+projectName);
                    if(wrapInstance.res.globalResponse__c.startsWith(projectName)) {
                        system.debug('\n\n\n  projectName --- '+projectName);
                        system.debug('\n\n\n  Value---'+wrapInstance.res.globalResponse__c.startsWith(projectName));
                        resList.add(wrapInstance.res);
                    }
                }
            }
        }
        system.debug('\n\n\n  resList' +resList);
        return resList;
    }
    
    public void callRequiredResponseMethod() {
        System.debug('---into callRequiredResponseMethod--');
        System.debug('---projectName--'+projectName);
        if(projectName.length() < 3 || projectName.length() > 20 ) {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.info,
                                System.Label.ErrorMessageForLengthOfCharacter));
            projectName=''; 
        }      
        else {
            getcallingWebServiceOfGlobalGivig();
            getRequiredResponse();
        }
    } 
     
    public with sharing class wrapperForSelectResponse {
        public Response__c res{get; set;}
        // Constructor for wrapper class
        public wrapperForSelectResponse(Response__c res) {
            this.res = res;
        }
    }
}