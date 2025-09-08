@isTest
private class WeatherControllerTest {
    
    // Mock class for WeatherService
    public class WeatherServiceMock implements HttpCalloutMock {
        private String responseBody;
        
        public WeatherServiceMock(String responseBody) {
            this.responseBody = responseBody;
        }
        
        public HTTPResponse respond(HTTPRequest req) {
            HttpResponse res = new HttpResponse();
            res.setStatusCode(200);
            res.setStatus('OK');
            res.setBody(this.responseBody);
            return res;
        }
    }
    
    @isTest static void testGetWeatherDataWithoutCache() {
        // Setup mock response
        String mockWeatherData = '{"location":{"name":"TestCity","region":"TestRegion","country":"TestCountry"},"current":{"temp_c":20.0,"condition":{"text":"Sunny"}}}';
        Test.setMock(HttpCalloutMock.class, new WeatherServiceMock(mockWeatherData));
        
        Test.startTest();
        String result = WeatherController.getWeatherDataWithoutCache('TestCity');
        Test.stopTest();
        
        System.assertEquals(mockWeatherData, result, 'Should return weather data from WeatherService');
        System.assert(result.contains('TestCity'), 'Result should contain the city name');
        System.assert(result.contains('temp_c'), 'Result should contain temperature data');
    }
    
    @isTest static void testGetWeatherDataWithoutCacheConCiudadVacia() {
        // Test with empty city name
        String mockWeatherData = '{"error":{"message":"City parameter is required"}}';
        Test.setMock(HttpCalloutMock.class, new WeatherServiceMock(mockWeatherData));
        
        Test.startTest();
        String result = WeatherController.getWeatherDataWithoutCache('');
        Test.stopTest();
        
        System.assertEquals(mockWeatherData, result, 'Should handle empty city name');
    }
    
    @isTest static void testTestWeatherBogota() {
        // Test the specific Bogotá method
        String mockBogotaData = '{"location":{"name":"Bogotá","region":"Bogota D.C.","country":"Colombia"},"current":{"temp_c":18.5,"condition":{"text":"Partly cloudy"}}}';
        Test.setMock(HttpCalloutMock.class, new WeatherServiceMock(mockBogotaData));
        
        Test.startTest();
        String result = WeatherController.testWeatherBogota();
        Test.stopTest();
        
        System.assertEquals(mockBogotaData, result, 'Should return Bogotá weather data');
        System.assert(result.contains('Bogotá'), 'Result should contain Bogotá');
    }
    
    @isTest static void testTestWeatherMedellin() {
        // Test the specific Medellín method
        String mockMedellinData = '{"location":{"name":"Medellín","region":"Antioquia","country":"Colombia"},"current":{"temp_c":24.0,"condition":{"text":"Clear"}}}';
        Test.setMock(HttpCalloutMock.class, new WeatherServiceMock(mockMedellinData));
        
        Test.startTest();
        String result = WeatherController.testWeatherMedellin();
        Test.stopTest();
        
        System.assertEquals(mockMedellinData, result, 'Should return Medellín weather data');
        System.assert(result.contains('Medellín'), 'Result should contain Medellín');
    }
    
    @isTest static void testMultipleCallsConsistency() {
        // Test that multiple calls work consistently
        String mockWeatherData = '{"location":{"name":"ConsistentCity","region":"TestRegion","country":"TestCountry"},"current":{"temp_c":22.0,"condition":{"text":"Consistent"}}}';
        Test.setMock(HttpCalloutMock.class, new WeatherServiceMock(mockWeatherData));
        
        Test.startTest();
        String result1 = WeatherController.getWeatherDataWithoutCache('ConsistentCity');
        String result2 = WeatherController.getWeatherDataWithoutCache('ConsistentCity');
        Test.stopTest();
        
        System.assertEquals(result1, result2, 'Multiple calls should return consistent results');
        System.assertEquals(mockWeatherData, result1, 'First call should return correct data');
        System.assertEquals(mockWeatherData, result2, 'Second call should return correct data');
    }
    
    @isTest static void testWeatherControllerWithSpecialCharacters() {
        // Test with city names containing special characters
        String mockWeatherData = '{"location":{"name":"São Paulo","region":"São Paulo","country":"Brazil"},"current":{"temp_c":25.0,"condition":{"text":"Sunny"}}}';
        Test.setMock(HttpCalloutMock.class, new WeatherServiceMock(mockWeatherData));
        
        Test.startTest();
        String result = WeatherController.getWeatherDataWithoutCache('São Paulo');
        Test.stopTest();
        
        System.assertEquals(mockWeatherData, result, 'Should handle special characters in city names');
        System.assert(result.contains('São Paulo'), 'Result should contain the city name with special characters');
    }
    
    @isTest static void testAuraEnabledAnnotations() {
        // Test that methods are properly annotated for Aura/LWC usage
        // This is more of a structural test to ensure the methods exist and are accessible
        
        String mockData = '{"test": "data"}';
        Test.setMock(HttpCalloutMock.class, new WeatherServiceMock(mockData));
        
        Test.startTest();
        // These should not throw exceptions if properly annotated
        String result1 = WeatherController.getWeatherDataWithoutCache('Test');
        String result2 = WeatherController.testWeatherBogota();
        String result3 = WeatherController.testWeatherMedellin();
        Test.stopTest();
        
        System.assertNotEquals(null, result1, 'getWeatherDataWithoutCache should return a result');
        System.assertNotEquals(null, result2, 'testWeatherBogota should return a result');
        System.assertNotEquals(null, result3, 'testWeatherMedellin should return a result');
    }
    
    @isTest static void testErrorHandling() {
        // Test error response handling
        String errorResponse = '{"error":{"code":1006,"message":"No matching location found."}}';
        Test.setMock(HttpCalloutMock.class, new WeatherServiceMock(errorResponse));
        
        Test.startTest();
        String result = WeatherController.getWeatherDataWithoutCache('NonExistentCity');
        Test.stopTest();
        
        System.assertEquals(errorResponse, result, 'Should return error response');
        System.assert(result.contains('error'), 'Result should contain error information');
    }
}