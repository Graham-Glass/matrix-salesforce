@isTest
private class UserControllerTest {

    static testMethod void TestUserController(){
        User testUser = new User(Username='test_matrixlms_15052015@test.com', Email='test@test.com', Alias='test', LastName='test', CommunityNickname='test', TimeZoneSidKey='America/Los_Angeles', LocaleSidKey='en_US', EmailEncodingKey='ISO-8859-1', ProfileId='00e1a000000VfUqAAK', LanguageLocaleKey='en_US');
        insert testUser;
        ApexPages.currentPage().getParameters().put('id', testUser.Id);
      
        UserController controller = new UserController(); 
        System.assertEquals(testUser.Id, controller.thisuser.Id);
        System.assertEquals('Please go to the MATRIX tab and log into your portal.', controller.content);
        
        //UserUtilities.updateMatrixCredentials(testUser.Id, '123456', '1234', 'testuser', 'pass00', 'api_key_1234567890');
        matrixlms__Matrix_Setting__c apiKey = new matrixlms__Matrix_Setting__c(Name='apiKey', matrixlms__Value__c='api_key_1234567890');
        insert apiKey;
        matrixlms__Matrix_Setting__c schoolId = new matrixlms__Matrix_Setting__c(Name='schoolId', matrixlms__Value__c='1234');
        insert schoolId;
        UserController controller2 = new UserController(); 
        System.assertEquals('<a href="javascript:void(0)" id="addMatrixLink" onclick="addMatrixUser(\''+testUser.Id+'\')">Add to MATRIX</a>', controller2.content);
        
        testUser.matrixlms__Matrix_Userid__c = '178023';
        update testUser;
        UserController controller3 = new UserController(); 
        System.assertEquals('<iframe id="matrixDetailsFrame" frameborder="0" width="100%" height="300" src="https://www.matrixlms.com/salesforce/user_details?userid=178023&api_key=api_key_1234567890&school_id=1234"></iframe>', controller3.content);
    }
    
}