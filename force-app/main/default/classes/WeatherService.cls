public class WeatherService {
    public class WeatherResponse {
        public Location location;
        public Current current;
    }

    public class Location {
        public String name;
        public String region;
        public String country;
    }

    public class Current {
        public Decimal temp_c;
        public Condition condition;  // <--- Esto es lo que faltaba
    }

    public class Condition {
        public String text;
    }
    

    public static String getWeather(String city) {
        System.debug('WeatherResponse: ' + city);

        HttpRequest req = new HttpRequest();
        req.setEndpoint('callout:WeatherAPI/current.json?key=35f020fdba9040f4a35173726252304&q=' + EncodingUtil.urlEncode(city, 'UTF-8') + '&aqi=no');
        req.setMethod('GET');

        Http http = new Http();
        HttpResponse res = http.send(req);
        // imprimir un log para ver la respuesta
        System.debug('Response: ' + res.getBody());
        System.debug('Status: ' + res.getStatus());
        System.debug('StatusCode: ' + res.getStatusCode());
        System.debug('deserialize: ' + res.getBody());
        return '' + res.getBody();// handleResponse(res);
    }

    private static String handleResponse(HttpResponse res) {
        if (res.getStatusCode() == 200) {
            return res.getBody();
        } else {
            throw new CalloutException('Error: ' + res.getStatus());
        }
    }
}