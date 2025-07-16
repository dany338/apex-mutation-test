public class FlowInvoker {
    public static void invocarFlowConAccountId(Id accountId) {
        // Definir los inputs del Flow
        Map<String, Object> inputs = new Map<String, Object>{
            'accountId' => accountId
        };

        // Llamar el Flow autolanzado
        Flow.Interview.Tarea_creada_por_Flow flowInstance = new Flow.Interview.Tarea_creada_por_Flow(inputs);
        flowInstance.start();
    }
}