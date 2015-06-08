@isTest
private class UserDashboardControllerTest {

    static testMethod void TestUserDashboardController(){
        User testUser = new User(Username='test_matrixlms_15052015@test.com', Email='test@test.com', Alias='test', LastName='test', CommunityNickname='test', TimeZoneSidKey='America/Los_Angeles', LocaleSidKey='en_US', EmailEncodingKey='ISO-8859-1', ProfileId='00e1a000000VfUqAAK', LanguageLocaleKey='en_US');
        
        System.runAs(testUser) {
            UserDashboardController controller = new UserDashboardController(); 
            System.assertEquals('Please contact your administrator to set up a MATRIX account for you.', controller.content);
            
            matrixlms__Matrix_Setting__c apiKey = new matrixlms__Matrix_Setting__c(Name='apiKey', matrixlms__Value__c='api_key_1234567890');
            insert apiKey;
            matrixlms__Matrix_Setting__c schoolId = new matrixlms__Matrix_Setting__c(Name='schoolId', matrixlms__Value__c='1234');
            insert schoolId;
            UserDashboardController controller2 = new UserDashboardController(); 
            System.assertEquals('Please contact your administrator to set up a MATRIX account for you.', controller2.content);
        }
        
        User testUser2 = new User(Username='test_matrixlms_15052016@test.com', matrixlms__Matrix_Userid__c='178023', Email='test@test.com', Alias='test', LastName='test', CommunityNickname='test12', TimeZoneSidKey='America/Los_Angeles', LocaleSidKey='en_US', EmailEncodingKey='ISO-8859-1', ProfileId='00e1a000000VfUqAAK', LanguageLocaleKey='en_US');
        System.runAs(testUser2) {
            UserDashboardController controller3 = new UserDashboardController(); 
            System.assertEquals('<iframe id="matrixDetailsFrame" frameborder="0" width="100%" height="300" src="https://www.matrixlms.com/salesforce/user_details?userid=178023&api_key=api_key_1234567890&school_id=1234"></iframe>', controller3.content);
        }
    }
    
}