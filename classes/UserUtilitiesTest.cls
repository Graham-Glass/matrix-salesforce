@isTest
private class UserUtilitiesTest {

    static testMethod void updateMatrixCredentialsTest(){
        //no settings exist
        User testUser = new User(Username='test_matrixlms_15052015@test.com', Email='test@test.com', Alias='test', LastName='test', CommunityNickname='test', TimeZoneSidKey='America/Los_Angeles', LocaleSidKey='en_US', EmailEncodingKey='ISO-8859-1', ProfileId='00e1a000000VfUqAAK', LanguageLocaleKey='en_US');
        insert testUser;
        UserUtilities.updateMatrixCredentials(testUser.Id, '123456', '1234', 'testuser', 'pass00', 'api_key_1234567890');
        
        User updatedUser = [SELECT matrixlms__Matrix_Username__c, matrixlms__Matrix_Userid__c, matrixlms__Matrix_Password__c FROM User WHERE Id = :testUser.Id];
        System.assertEquals('123456', updatedUser.matrixlms__Matrix_Userid__c);
        System.assertEquals('testuser', updatedUser.matrixlms__Matrix_Username__c);
        System.assertEquals('pass00', updatedUser.matrixlms__Matrix_Password__c);
        
        matrixlms__Matrix_Setting__c updatedSchoolId = [SELECT matrixlms__Value__c FROM matrixlms__Matrix_Setting__c WHERE Name = 'schoolId'];
        System.assertEquals('1234', updatedSchoolId.matrixlms__Value__c);
        
        matrixlms__Matrix_Setting__c updatedApiKey = [SELECT matrixlms__Value__c FROM matrixlms__Matrix_Setting__c WHERE Name = 'apiKey'];
        System.assertEquals('api_key_1234567890', updatedApiKey.matrixlms__Value__c);
        
        Contact testContact = new Contact(Email='test@test.com', LastName='test');
        insert testContact;
        UserUtilities.updateMatrixCredentials(testContact.Id, '123456', '1235', 'testuser', 'pass00', 'api_key_1234567891');
        
        Contact updatedContact = [SELECT matrixlms__Matrix_Username__c, matrixlms__Matrix_Userid__c, matrixlms__Matrix_Password__c FROM Contact WHERE Id = :testContact.Id];
        System.assertEquals('123456', updatedContact.matrixlms__Matrix_Userid__c);
        System.assertEquals('testuser', updatedContact.matrixlms__Matrix_Username__c);
        System.assertEquals('pass00', updatedContact.matrixlms__Matrix_Password__c);
        
        updatedSchoolId = [SELECT matrixlms__Value__c FROM matrixlms__Matrix_Setting__c WHERE Name = 'schoolId'];
        System.assertEquals('1235', updatedSchoolId.matrixlms__Value__c);
        
        updatedApiKey = [SELECT matrixlms__Value__c FROM matrixlms__Matrix_Setting__c WHERE Name = 'apiKey'];
        System.assertEquals('api_key_1234567891', updatedApiKey.matrixlms__Value__c);
        
        //now try again with settings already inserted
        
        UserUtilities.updateMatrixCredentials(testUser.Id, '123456', '1236', 'testuser', 'pass00', 'api_key_1234567892');
        
        updatedUser = [SELECT matrixlms__Matrix_Username__c, matrixlms__Matrix_Userid__c, matrixlms__Matrix_Password__c FROM User WHERE Id = :testUser.Id];
        System.assertEquals('123456', updatedUser.matrixlms__Matrix_Userid__c);
        System.assertEquals('testuser', updatedUser.matrixlms__Matrix_Username__c);
        System.assertEquals('pass00', updatedUser.matrixlms__Matrix_Password__c);
        
        updatedSchoolId = [SELECT matrixlms__Value__c FROM matrixlms__Matrix_Setting__c WHERE Name = 'schoolId'];
        System.assertEquals('1236', updatedSchoolId.matrixlms__Value__c);
        
        updatedApiKey = [SELECT matrixlms__Value__c FROM matrixlms__Matrix_Setting__c WHERE Name = 'apiKey'];
        System.assertEquals('api_key_1234567892', updatedApiKey.matrixlms__Value__c);
        
        UserUtilities.updateMatrixCredentials(testContact.Id, '123456', '1237', 'testuser', 'pass00', 'api_key_1234567893');
        
        updatedContact = [SELECT matrixlms__Matrix_Username__c, matrixlms__Matrix_Userid__c, matrixlms__Matrix_Password__c FROM Contact WHERE Id = :testContact.Id];
        System.assertEquals('123456', updatedContact.matrixlms__Matrix_Userid__c);
        System.assertEquals('testuser', updatedContact.matrixlms__Matrix_Username__c);
        System.assertEquals('pass00', updatedContact.matrixlms__Matrix_Password__c);
        
        updatedSchoolId = [SELECT matrixlms__Value__c FROM matrixlms__Matrix_Setting__c WHERE Name = 'schoolId'];
        System.assertEquals('1237', updatedSchoolId.matrixlms__Value__c);
        
        updatedApiKey = [SELECT matrixlms__Value__c FROM matrixlms__Matrix_Setting__c WHERE Name = 'apiKey'];
        System.assertEquals('api_key_1234567893', updatedApiKey.matrixlms__Value__c);
    }
    
    static testMethod void deleteMatrixCredentialsTest(){
        User testUser = new User(Username='test_matrixlms_15052015@test.com', Email='test@test.com', Alias='test', LastName='test', CommunityNickname='test', TimeZoneSidKey='America/Los_Angeles', LocaleSidKey='en_US', EmailEncodingKey='ISO-8859-1', ProfileId='00e1a000000VfUqAAK', LanguageLocaleKey='en_US');
        insert testUser;
        UserUtilities.deleteMatrixCredentials(testUser.Id);
        User updatedUser = [SELECT matrixlms__Matrix_Username__c, matrixlms__Matrix_Userid__c, matrixlms__Matrix_Password__c FROM User WHERE Id = :testUser.Id];
        System.assertEquals(null, updatedUser.matrixlms__Matrix_Username__c);
        System.assertEquals(null, updatedUser.matrixlms__Matrix_Userid__c);
        System.assertEquals(null, updatedUser.matrixlms__Matrix_Password__c);
    }
    
    static testMethod void saveMatrixURLTest(){
        User testUser = new User(Username='test_matrixlms_15052015@test.com', Email='test@test.com', Alias='test', LastName='test', CommunityNickname='test', TimeZoneSidKey='America/Los_Angeles', LocaleSidKey='en_US', EmailEncodingKey='ISO-8859-1', ProfileId='00e1a000000VfUqAAK', LanguageLocaleKey='en_US');
        insert testUser;
        UserUtilities.saveMatrixURL(testUser.Id, 'https://sandbox.matrixlms.com/?salesforce=true');
        matrixlms__Matrix_Setting__c updatedPortalUrl = [SELECT matrixlms__Value__c FROM matrixlms__Matrix_Setting__c WHERE Name = 'portalUrl'];
        System.assertEquals('https://sandbox.matrixlms.com/?salesforce=true', updatedPortalUrl.matrixlms__Value__c);
        
        UserUtilities.saveMatrixURL(testUser.Id, 'https://adp.matrixlms.com/?salesforce=true');
        updatedPortalUrl = [SELECT matrixlms__Value__c FROM matrixlms__Matrix_Setting__c WHERE Name = 'portalUrl'];
        System.assertEquals('https://adp.matrixlms.com/?salesforce=true', updatedPortalUrl.matrixlms__Value__c);
    }
    
    static testMethod void getAddUserUrlTest(){
        User testUser = new User(Username='test_matrixlms_15052015@test.com', Email='test@test.com', Alias='test', FirstName='user', LastName='test', CommunityNickname='test', TimeZoneSidKey='America/Los_Angeles', LocaleSidKey='en_US', EmailEncodingKey='ISO-8859-1', ProfileId='00e1a000000VfUqAAK', LanguageLocaleKey='en_US');
        insert testUser;
        matrixlms__Matrix_Setting__c apiKey = new matrixlms__Matrix_Setting__c(Name='apiKey', matrixlms__Value__c='api_key_1234567890');
        insert apiKey;
        matrixlms__Matrix_Setting__c schoolId = new matrixlms__Matrix_Setting__c(Name='schoolId', matrixlms__Value__c='1234');
        insert schoolId;
        String api_url = UserUtilities.getAddUserUrl((String)testUser.Id);
        System.assertEquals('https://www.matrixlms.com/api/add_user?account_types=student&salesforce=true&send_login_instructions=true&api_key=api_key_1234567890&school_id=1234&first_name=user&last_name=test&email=test@test.com', api_url);
        
        Contact testContact = new Contact(FirstName='user', LastName='test', Email='test@test.com');
        insert testContact;
        String api_url2 = UserUtilities.getAddUserUrl((String)testContact.Id);
        System.assertEquals('https://www.matrixlms.com/api/add_user?account_types=student&salesforce=true&send_login_instructions=true&api_key=api_key_1234567890&school_id=1234&first_name=user&last_name=test&email=test@test.com', api_url2);
    }
    
    static testMethod void saveMatrixUseridTest(){
        User testUser = new User(Username='test_matrixlms_15052015@test.com', Email='test@test.com', Alias='test', FirstName='user', LastName='test', CommunityNickname='test', TimeZoneSidKey='America/Los_Angeles', LocaleSidKey='en_US', EmailEncodingKey='ISO-8859-1', ProfileId='00e1a000000VfUqAAK', LanguageLocaleKey='en_US');
        insert testUser;
        UserUtilities.saveMatrixUserid('{"userid": "test", "id": "123456"}', (String)testUser.Id);
        User updatedTestUser = [SELECT matrixlms__Matrix_Userid__c FROM User WHERE Id = :testUser.Id];
        System.assertEquals('123456', updatedTestUser.matrixlms__Matrix_Userid__c);
        
        Contact testContact = new Contact(FirstName='user', LastName='test', Email='test@test.com');
        insert testContact;
        UserUtilities.saveMatrixUserid('{"userid": "test", "id": "123456"}', (String)testContact.Id);
        Contact updatedTestContact = [SELECT matrixlms__Matrix_Userid__c FROM Contact WHERE Id = :testContact.Id];
        System.assertEquals('123456', updatedTestUser.matrixlms__Matrix_Userid__c);
    }
}