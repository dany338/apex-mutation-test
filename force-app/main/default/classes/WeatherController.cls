public with sharing class WeatherController {
    @AuraEnabled
    public static String getWeatherDataWithoutCache(String city) {
        return WeatherService.getWeather(city); // ya retorna el JSON directamente
    }

    // 🚀 MÉTODO DE PRUEBA DIRECTA
    @AuraEnabled
    public static String testWeatherBogota() {
        return WeatherService.getWeather('Bogotá');
    }

    @AuraEnabled
    public static String testWeatherMedellin() {
        return WeatherService.getWeather('Medellín');
    }
}