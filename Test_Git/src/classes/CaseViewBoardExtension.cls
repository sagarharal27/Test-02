public class CaseViewBoardExtension {
    
    List<Case> lstCases ;
    
    public void CaseViewBoardExtension(){ 
        lstCases = new List<Case>();
        getLocationOfCase();
    }
    
    
    public void getLocationOfCase() {
        
        String caseAccountAddress;
        Decimal latitude;
        Decimal longitude;
        List<String> accBillingAddress = new List<String>();
        
        lstCases = [select Id, AccountId, contactId, Status, Priority, Account.BillingAddress
                    from Case];
        
        if(!lstCases.isEmpty()) {
            for(Case cases : lstCases) {
                accBillingAddress.add(String.valueOf(cases.Account.BillingAddress));
                
            }
        }
    }
                /*
                if(cases.Account.BillingAddress != null) {
                    caseAccountAddress = String.valueOf(cases.Account.BillingAddress);
                    HttpRequest request = new HttpRequest();
                
                    String url = 'http://maps.googleapis.com/maps/api/geocode/json?address='+EncodingUtil.urlEncode(JSON.serialize(caseAccountAddress),'UTF-8')+'&sensor=false';
                    request.setEndpoint(url);
                    request.setMethod('GET');
                
                    Http http = new Http(); 
                    HttpResponse response = http.send(request);
                    System.debug('Response========' + response.getBody());
                    
                    String jsonBody = response.getBody();
                    JSONParser parser = JSON.createParser(jsonBody);
                    
                    while (parser.nextToken() != null) {
                        if ((parser.getCurrentToken() == JSONToken.FIELD_NAME) &&
                            (parser.getText() == 'lat')) {
                                parser.nextToken();
                                latitude = parser.getDecimalValue();
                                system.debug('latitude====='+latitude);
                        }
                    
                        if ((parser.getCurrentToken() == JSONToken.FIELD_NAME) &&
                            (parser.getText() == 'lng')) {
                                parser.nextToken();
                                longitude = parser.getDecimalValue();
                                system.debug('longitude======'+longitude);
                        }
                    } 
                }
                
                wrapperLocation wrapObj = new wrapperLocation();
                List<wrapperLocation> wrapList = new List<wrapperLocation>();
                if(latitude != null){
                    wrapObj.latitudeWrap = latitude;
                }
                if(longitude != null){
                    wrapObj.longitudeWrap = longitude;
                }
                wrapList.add(wrapObj);
                system.debug('wrapList======'+wrapList);
            }
        }
    }*/
   
    public class wrapperLocation{
        public Decimal latitudeWrap {get; set;}
        public Decimal longitudeWrap {get; set;}
        public wrapperLocation wrapObj {get; set;}
        public List<wrapperLocation> wrapList{get; set;}
        
        
    }
}