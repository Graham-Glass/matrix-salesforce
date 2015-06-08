@RestResource(urlMapping='/User/*')
                                
global with sharing class UserUtilities {
  
    webservice static void updateMatrixCredentials(String salesforce_userid, String matrix_userid, String school_id, String username, String password, String api_key) {
        List<User> current_user_query = [SELECT matrixlms__Matrix_Username__c, matrixlms__Matrix_Userid__c, matrixlms__Matrix_Password__c FROM User WHERE Id = :salesforce_userid];
        if(current_user_query.isEmpty()){
            Contact current_user = [SELECT matrixlms__Matrix_Username__c, matrixlms__Matrix_Userid__c, matrixlms__Matrix_Password__c FROM Contact WHERE Id = :salesforce_userid];
            current_user.matrixlms__Matrix_Username__c = username;
            current_user.matrixlms__Matrix_Userid__c = matrix_userid;
            current_user.matrixlms__Matrix_Password__c = password;
            try {
                Database.update(current_user);
            }
            catch (DmlException e) {
                System.debug(e.getMessage());
            }
        }else{
            User current_user = current_user_query.get(0);
            current_user.matrixlms__Matrix_Username__c = username;
            current_user.matrixlms__Matrix_Userid__c = matrix_userid;
            current_user.matrixlms__Matrix_Password__c = password;
            try {
                Database.update(current_user);
            }
            catch (DmlException e) {
                System.debug(e.getMessage());
            }
        }
        
        List<matrixlms__Matrix_Setting__c> school_id_query = [SELECT Name, matrixlms__Value__c FROM matrixlms__Matrix_Setting__c WHERE Name = 'schoolId'];
        if(school_id_query.isEmpty()){
            try {
                matrixlms__Matrix_Setting__c new_school_id_obj = new matrixlms__Matrix_Setting__c();
                new_school_id_obj.Name = 'schoolID';
                new_school_id_obj.matrixlms__Value__c = school_id;
                Database.insert(new_school_id_obj);
            }
            catch (DmlException e) {
                System.debug(e.getMessage());
            }
        }else{
            matrixlms__Matrix_Setting__c school_id_obj = school_id_query.get(0);
            school_id_obj.matrixlms__Value__c = school_id;
            try {
                Database.update(school_id_obj);
            }
            catch (DmlException e) {
                System.debug(e.getMessage());
            }
        }
        
        List<matrixlms__Matrix_Setting__c> api_key_query = [SELECT Name, matrixlms__Value__c FROM matrixlms__Matrix_Setting__c WHERE Name = 'apiKey'];
        if(api_key_query.isEmpty()){
            try {
                matrixlms__Matrix_Setting__c new_api_key_obj = new matrixlms__Matrix_Setting__c();
                new_api_key_obj.Name = 'apiKey';
                new_api_key_obj.matrixlms__Value__c = api_key;
                Database.insert(new_api_key_obj);
            }
            catch (DmlException e) {
                System.debug(e.getMessage());
            }
        }else{
            matrixlms__Matrix_Setting__c api_key_obj = api_key_query.get(0);
            api_key_obj.matrixlms__Value__c = api_key;
            try {
                Database.update(api_key_obj);
            }
            catch (DmlException e) {
                System.debug(e.getMessage());
            }
        }
    }
    
    webservice static void deleteMatrixCredentials(String salesforce_userid) {
        User current_user = [SELECT matrixlms__Matrix_Username__c, matrixlms__Matrix_Userid__c, matrixlms__Matrix_Password__c FROM User WHERE Id = :salesforce_userid];
        current_user.matrixlms__Matrix_Username__c = '';
        current_user.matrixlms__Matrix_Userid__c = '';
        current_user.matrixlms__Matrix_Password__c = '';
        try {
            Database.update(current_user);
        }
        catch (DmlException e) {
            System.debug(e.getMessage());
        }
    }
    
    webservice static void saveMatrixURL(String salesforce_userid, String portal_url) {
        List<matrixlms__Matrix_Setting__c> portal_url_query = [SELECT Name, matrixlms__Value__c FROM matrixlms__Matrix_Setting__c WHERE Name = 'portalUrl'];
        if(portal_url_query.isEmpty()){
            try {
                matrixlms__Matrix_Setting__c new_portal_url_obj = new matrixlms__Matrix_Setting__c();
                new_portal_url_obj.Name = 'portalUrl';
                new_portal_url_obj.matrixlms__Value__c = portal_url;
                Database.insert(new_portal_url_obj);
            }
            catch (DmlException e) {
                System.debug(e.getMessage());
            }
        }else{
            matrixlms__Matrix_Setting__c portal_url_obj = portal_url_query.get(0);
            portal_url_obj.matrixlms__Value__c = portal_url;
            try {
                Database.update(portal_url_obj);
            }
            catch (DmlException e) {
                System.debug(e.getMessage());
            }
        }
    }
    
    webservice static void addMatrixUser(String salesforce_userid) {
        String api_url = getAddUserUrl(salesforce_userid);
        String response = makeHTTPCall(api_url);
        saveMatrixUserid(response, salesforce_userid);
    }
    
    public static String getAddUserUrl(String salesforce_userid) {
        matrixlms__Matrix_Setting__c school_id = [SELECT matrixlms__Value__c FROM matrixlms__Matrix_Setting__c WHERE Name = 'schoolId'];
        matrixlms__Matrix_Setting__c api_key = [SELECT matrixlms__Value__c FROM matrixlms__Matrix_Setting__c WHERE Name = 'apiKey'];
    
        String first_name = '';
        String last_name = '';
        String email = '';
        
        List<User> current_user_query = [SELECT FirstName, LastName, Email FROM User WHERE Id = :salesforce_userid];
        if(current_user_query.isEmpty()){
            Contact current_user = [SELECT FirstName, LastName, Email FROM Contact WHERE Id = :salesforce_userid];
            first_name = EncodingUtil.urlEncode(current_user.FirstName, 'UTF-8');
            last_name = EncodingUtil.urlEncode(current_user.LastName, 'UTF-8');
            email = current_user.Email;
        }else{
            User current_user = current_user_query.get(0);
            first_name = EncodingUtil.urlEncode(current_user.FirstName, 'UTF-8');
            last_name = EncodingUtil.urlEncode(current_user.LastName, 'UTF-8');
            email = current_user.Email;
        }
        
        return 'https://www.matrixlms.com/api/add_user?account_types=student&salesforce=true&send_login_instructions=true&api_key='+api_key.matrixlms__Value__c+'&school_id='+school_id.matrixlms__Value__c+'&first_name='+first_name+'&last_name='+last_name+'&email='+email;
    }
    
    public static String makeHTTPCall(String api_url) {
        // Instantiate a new http object
        Http h = new Http();
    
         // Instantiate a new HTTP request, specify the method (GET) as well as the endpoint
        HttpRequest req = new HttpRequest();
        req.setEndpoint(api_url);
        req.setMethod('GET');
    
        // Send the request, and return a response
        HttpResponse res = h.send(req);
        return res.getBody();
    }
    
    public static void saveMatrixUserid(String response, String salesforce_userid) {
        JSONParser parser = JSON.createParser(response);
        String matrix_userid = '';
        while (parser.nextToken() != null) {
            if ((parser.getCurrentToken() == JSONToken.FIELD_NAME) && 
                (parser.getText() == 'id')) {
                // Get the value.
                parser.nextToken();
                // Compute the grand total price for all invoices.
                matrix_userid = parser.getText();
            }
        }
        
        List<User> current_user_query = [SELECT FirstName, LastName, Email FROM User WHERE Id = :salesforce_userid];
        if(current_user_query.isEmpty()){
            Contact current_user = [SELECT matrixlms__Matrix_Userid__c FROM Contact WHERE Id = :salesforce_userid];
            current_user.matrixlms__Matrix_Userid__c = matrix_userid;
            try {
                Database.update(current_user);
            }
            catch (DmlException e) {
                System.debug(e.getMessage());
            }
        }else{
            User current_user = current_user_query.get(0);
            current_user.matrixlms__Matrix_Userid__c = matrix_userid;
            try {
                Database.update(current_user);
            }
            catch (DmlException e) {
                System.debug(e.getMessage());
            }
        }
    }
    
}