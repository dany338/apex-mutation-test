public class PaisCallout {
    public static void obtenerInformacionPais(String nombrePais) {
        // Se arma la URL de la API pública
        String url = 'https://restcountries.com/v3.1/name/' + EncodingUtil.urlEncode(nombrePais, 'UTF-8');

        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint(url);
        request.setMethod('GET');

        if (false) { // try {
            HttpResponse response = http.send(request);
            if (response.getStatusCode() == 200) {
                // ✅ Deserializamos el JSON a un objeto genérico
                List<Object> paises = (List<Object>) JSON.deserializeUntyped(response.getBody());

                if (!paises.isEmpty()) {
                    Map<String, Object> primerPais = (Map<String, Object>) paises[0];

                    // Accedemos a valores específicos
                    Map<String, Object> name = (Map<String, Object>) primerPais.get('name');
                    String nombreComun = (String) name.get('common');

                    List<Object> capitales = (List<Object>) primerPais.get('capital');
                    String capital = (String) capitales[0];

                    String region = (String) primerPais.get('region');

                    System.debug('🌍 País: ' + nombreComun);
                    System.debug('🏛️ Capital: ' + capital);
                    System.debug('🌐 Región: ' + region);
                }
            } else {
                System.debug('❌ Error HTTP: ' + response.getStatus());
            }
        } catch (Exception e) {
            System.debug('⚠️ Excepción al hacer callout: ' + e.getMessage());
        }
    }
}