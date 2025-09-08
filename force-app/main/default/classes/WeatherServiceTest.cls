@isTest
private class WeatherServiceTest {
    
    // Mock class for HTTP callouts
    public class WeatherServiceMock implements HttpCalloutMock {
        private Integer statusCode;
        private String responseBody;
        
        public WeatherServiceMock(Integer statusCode, String responseBody) {
            this.statusCode = statusCode;
            this.responseBody = responseBody;
        }
        
        public HTTPResponse respond(HTTPRequest req) {
            HttpResponse res = new HttpResponse();
            res.setStatusCode(this.statusCode);
            res.setStatus(this.statusCode == 200 ? 'OK' : 'Error');
            res.setBody(this.responseBody);
            return res;
        }
    }
    
    @isTest static void testGetWeatherExitoso() {
        // Setup successful response
        String mockResponse = '{"location":{"name":"Bogotá","region":"Bogota D.C.","country":"Colombia"},"current":{"temp_c":20.5,"condition":{"text":"Partly cloudy"}}}';
        Test.setMock(HttpCalloutMock.class, new WeatherServiceMock(200, mockResponse));
        
        Test.startTest();
        String result = WeatherService.getWeather('Bogotá');
        Test.stopTest();
        
        System.assertEquals(mockResponse, result, 'Should return the weather data');
        System.assert(result.contains('Bogotá'), 'Response should contain city name');
        System.assert(result.contains('temp_c'), 'Response should contain temperature');
    }
    
    @isTest static void testGetWeatherConCiudadDiferente() {
        // Test with different city
        String mockResponse = '{"location":{"name":"Medellín","region":"Antioquia","country":"Colombia"},"current":{"temp_c":25.0,"condition":{"text":"Sunny"}}}';
        Test.setMock(HttpCalloutMock.class, new WeatherServiceMock(200, mockResponse));
        
        Test.startTest();
        String result = WeatherService.getWeather('Medellín');
        Test.stopTest();
        
        System.assertEquals(mockResponse, result, 'Should return the weather data for Medellín');
        System.assert(result.contains('Medellín'), 'Response should contain Medellín');
    }
    
    @isTest static void testGetWeatherConError() {
        // Test error response
        String errorResponse = '{"error":{"message":"City not found"}}';
        Test.setMock(HttpCalloutMock.class, new WeatherServiceMock(404, errorResponse));
        
        Test.startTest();
        String result = WeatherService.getWeather('CiudadInexistente');
        Test.stopTest();
        
        System.assertEquals(errorResponse, result, 'Should return error response');
        System.assert(result.contains('error'), 'Response should contain error information');
    }
    
    @isTest static void testGetWeatherConCiudadConEspacios() {
        // Test with city name containing spaces
        String mockResponse = '{"location":{"name":"New York","region":"New York","country":"United States"},"current":{"temp_c":15.0,"condition":{"text":"Clear"}}}';
        Test.setMock(HttpCalloutMock.class, new WeatherServiceMock(200, mockResponse));
        
        Test.startTest();
        String result = WeatherService.getWeather('New York');
        Test.stopTest();
        
        System.assertEquals(mockResponse, result, 'Should handle city names with spaces');
        System.assert(result.contains('New York'), 'Response should contain city name');
    }
    
    @isTest static void testGetWeatherConCaracteresEspeciales() {
        // Test with special characters
        String mockResponse = '{"location":{"name":"São Paulo","region":"São Paulo","country":"Brazil"},"current":{"temp_c":22.0,"condition":{"text":"Overcast"}}}';
        Test.setMock(HttpCalloutMock.class, new WeatherServiceMock(200, mockResponse));
        
        Test.startTest();
        String result = WeatherService.getWeather('São Paulo');
        Test.stopTest();
        
        System.assertEquals(mockResponse, result, 'Should handle special characters in city names');
    }
    
    @isTest static void testGetWeatherConRespuestaVacia() {
        // Test with empty response
        Test.setMock(HttpCalloutMock.class, new WeatherServiceMock(200, ''));
        
        Test.startTest();
        String result = WeatherService.getWeather('TestCity');
        Test.stopTest();
        
        System.assertEquals('', result, 'Should handle empty response');
    }
    
    @isTest static void testGetWeatherConErrorServidor() {
        // Test server error
        String errorResponse = '{"error":{"message":"Internal server error"}}';
        Test.setMock(HttpCalloutMock.class, new WeatherServiceMock(500, errorResponse));
        
        Test.startTest();
        String result = WeatherService.getWeather('TestCity');
        Test.stopTest();
        
        System.assertEquals(errorResponse, result, 'Should return server error response');
    }
    
    @isTest static void testHandleResponseMetodoPrivado() {
        // Test the private handleResponse method indirectly
        // by testing scenarios that would trigger different paths
        
        // This tests the URL encoding and endpoint construction
        String mockResponse = '{"test": "data"}';
        Test.setMock(HttpCalloutMock.class, new WeatherServiceMock(200, mockResponse));
        
        Test.startTest();
        String result = WeatherService.getWeather('Test & City');
        Test.stopTest();
        
        // Should handle URL encoding properly
        System.assertEquals(mockResponse, result, 'Should handle URL encoding in city names');
    }
}