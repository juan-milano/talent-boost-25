readme.md 

### Características principales de Prometheus:
#### Recopilación de métricas:
Prometheus recolecta métricas de sistemas y aplicaciones mediante un modelo de "pull" (extracción).
Los sistemas monitoreados exponen métricas en un formato específico, y Prometheus las recopila periódicamente.
#### Almacenamiento de series de tiempo:
Las métricas se almacenan en una base de datos de series de tiempo, lo que permite analizar su comportamiento a lo largo del tiempo.
#### Lenguaje de consulta (PromQL):
PromQL es un lenguaje poderoso que permite consultar y analizar métricas para generar gráficos, alertas y paneles.
#### Alertas:
Prometheus incluye un sistema de alertas que notifica cuando se detectan condiciones anómalas en las métricas.
#### Integración con Kubernetes:
Prometheus es ampliamente utilizado para monitorear clústeres de Kubernetes, proporcionando visibilidad sobre el estado y el rendimiento del clúster.

### Historia
#### 2012: Desarrollo inicial en SoundCloud.
#### 2015: Prometheus se convirtió en un proyecto de código abierto y ganó popularidad rápidamente en la comunidad de DevOps.
#### 2016: Prometheus fue aceptado como el segundo proyecto en la Cloud Native Computing Foundation (CNCF), después de Kubernetes.
#### Actualidad: Prometheus es uno de los sistemas de monitoreo más utilizados en el mundo, especialmente en entornos de Kubernetes y aplicaciones nativas de la nube.


###Conceptos Básicos de Prometheus
#### Métricas
Las métricas son datos numéricos que representan el estado o el comportamiento de un sistema. Ejemplos comunes incluyen:
Uso de CPU.
Uso de memoria.
Tasa de solicitudes HTTP.
Latencia de las solicitudes.
En Prometheus, las métricas se almacenan como series de tiempo, es decir, secuencias de valores recopilados a lo largo del tiempo.

#### Modelo de Datos
Prometheus utiliza un modelo de datos basado en etiquetas (labels). Cada métrica tiene un nombre y un conjunto de etiquetas que la identifican de manera única. Por ejemplo:
http_requests_total{method="GET", status="200"}: Número total de solicitudes HTTP GET con código de estado 200.
Las etiquetas permiten filtrar y agrupar métricas de manera flexible.

### Componentes Principales

#### Prometheus Server:
Recopila y almacena métricas.
Ejecuta consultas PromQL.

#### Exporters:
Herramientas que exponen métricas de sistemas o aplicaciones.
Ejemplos: Node Exporter (métricas de servidores), kube-state-metrics (métricas de Kubernetes).

#### Alertmanager:
Gestiona alertas generadas por Prometheus.
Envía notificaciones a canales como Slack, Email, etc.

#### Client Libraries:
Bibliotecas para instrumentar aplicaciones y exponer métricas a Prometheus.

### Lenguaje de Consulta (PromQL)
#### Series de Tiempo
En Prometheus, una serie de tiempo es una secuencia de valores recopilados a lo largo del tiempo. Cada serie de tiempo está identificada por:
Un nombre de métrica (ej: http_requests_total).
Un conjunto de etiquetas (labels) que la describen (ej: method="GET", status="200").

Ejemplo de una serie de tiempo:

http_requests_total{method="GET", status="200", instance="10.0.0.1:8080"}

### Tipos de Datos en PromQL
PromQL maneja cuatro tipos de datos:
#### Instant Vector: Un conjunto de series de tiempo con un solo valor por serie (en un momento específico).
Ejemplo: http_requests_total{method="GET"}.
#### Range Vector: Un conjunto de series de tiempo con múltiples valores por serie (en un rango de tiempo).
Ejemplo: http_requests_total{method="GET"}[5m].
#### Scalar: Un valor numérico simple (sin etiquetas).
Ejemplo: 42.
#### String: Un valor de texto (usado principalmente en alertas).

#### Operadores Aritméticos
Permiten realizar cálculos matemáticos entre métricas.
Suma (+), Resta (-), Multiplicación (*), División (/), Módulo (%), Potencia (^).
Ejemplo:
http_requests_total{method="GET"} * 2

#### Operadores de Comparación
Permiten comparar métricas y filtrar resultados.
Igual (==), No igual (!=), Mayor que (>), Menor que (<), Mayor o igual (>=), Menor o igual (<=).
Ejemplo:
http_requests_total{method="GET"} > 100

#### Operadores Lógicos
Permiten combinar condiciones.
AND (and), OR (or), NOT (unless).
Ejemplo:
http_requests_total{method="GET"} > 100 and http_requests_total{method="POST"} < 50

### Funciones de Agregación
Las funciones de agregación permiten combinar múltiples series de tiempo en una sola métrica.
#### Agregadores Comunes
sum(): Suma los valores de varias series.
avg(): Calcula el promedio.
min(): Devuelve el valor mínimo.
max(): Devuelve el valor máximo.
count(): Cuenta el número de series.
Ejemplo:

sum(http_requests_total) by (method)
Agrupa las métricas por el label method y suma los valores.

#### Agregadores con Agrupación
Puedes usar by o without para controlar cómo se agrupan las series.
by: Agrupa por las etiquetas especificadas.
sum(http_requests_total) by (method, status)
without: Agrupa excluyendo las etiquetas especificadas.
sum(http_requests_total) without (instance)

### Funciones de Transformación
#### rate()
Calcula la tasa de cambio por segundo para un range vector. Es útil para métricas de contadores (counters).
Ejemplo:

rate(http_requests_total[5m])
Devuelve la tasa de solicitudes HTTP por segundo en los últimos 5 minutos.

#### increase()
Calcula el incremento total en un rango de tiempo.
Ejemplo:

increase(http_requests_total[1h])
Devuelve el número total de solicitudes HTTP en la última hora.

#### histogram_quantile()
Calcula cuantiles para métricas de tipo histograma.
Ejemplo:

histogram_quantile(0.95, sum(rate(http_request_duration_seconds_bucket[5m])) by (le))
Devuelve el percentil 95 de la latencia de las solicitudes HTTP.

#### delta()
Calcula la diferencia entre el primer y el último valor en un rango de tiempo.
Ejemplo:

#### delta(cpu_usage_total[1h])
Devuelve el cambio en el uso de CPU en la última hora.

### Ejemplos Prácticos de Consultas PromQL
#### Uso de CPU por Nodo
sum(rate(container_cpu_usage_seconds_total[5m])) by (node)
Calcula la tasa de uso de CPU por nodo en los últimos 5 minutos.

#### Tasa de Solicitudes HTTP por Método
rate(http_requests_total{method="GET"}[5m])
Devuelve la tasa de solicitudes HTTP GET por segundo en los últimos 5 minutos.

#### Latencia del 95º Percentil
histogram_quantile(0.95, sum(rate(http_request_duration_seconds_bucket[5m])) by (le))
Calcula el percentil 95 de la latencia de las solicitudes HTTP.

#### Alertas para Uso de Memoria Alto
container_memory_usage_bytes > 1e9
Devuelve las series de tiempo donde el uso de memoria es mayor a 1 GB.

#### Número de Pods en Ejecución
count(kube_pod_status_phase{phase="Running"})
Cuenta el número de pods en estado "Running".

### Operadores Lógicos en Alertas
#### Combinar Condiciones con and
http_requests_total{method="GET"} > 100 and http_errors_total > 10
Activa una alerta si hay más de 100 solicitudes GET y más de 10 errores.

#### Exclusión con unless
http_requests_total unless http_errors_total > 10
Devuelve las métricas de solicitudes HTTP, excluyendo aquellas con más de 10 errores.

### Despliegue de Prometheus en Kubernetes

#### Agrega el repositorio de Helm de Prometheus:
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts

#### Instala Prometheus usando el chart kube-prometheus-stack:
helm install prometheus prometheus-community/kube-prometheus-stack

#### Configuración de Node Exporter
helm install node-exporter prometheus-community/prometheus-node-exporter
kubectl get pods -l app=prometheus-node-exporter

(prometheus.yml):
Scrape_configs:
  - job_name: 'node-exporter'    
Kubernetes_sd_configs:
      - role: node
    Relabel_configs:
      - source_labels: [__address__]
        regex: '(.*):10250'
        replacement: '${1}:9100'
        target_label: __address__

### Configuración de cAdvisor
#### ¿Qué es cAdvisor?
cAdvisor (Container Advisor) es una herramienta que recopila métricas de los contenedores en un nodo de Kubernetes, como:
- Uso de CPU y memoria por contenedor.
- Uso de red y disco.
- Estadísticas de procesos.
#### Instalación de cAdvisor

cAdvisor ya está integrado en el kubelet (el agente de Kubernetes que gestiona los nodos), por lo que no es necesario instalarlo manualmente. Sin embargo, debes asegurarte de que Prometheus esté configurado para recopilar métricas de cAdvisor.

#### Configuración en Prometheus
Agrega un trabajo de scraping para cAdvisor en el archivo prometheus.yml:
Scrape_configs:
- job_name: 'cadvisor'
Kubernetes_sd_configs:
- role: node
scheme: https
 Tls_config:
 insecure_skip_verify: true
bearer_token_file: /var/run/secrets/kubernetes.io/serviceaccount/token
Relabel_configs:
- source_labels: [__address__]
regex: '(.*):10250'
replacement: '${1}:4194'
        target_label: __address__

#### Dashboards en Grafana
Importar Dashboards para Node Exporter y cAdvisor
Importa los siguientes dashboards oficiales:
Node Exporter: ID 1860.
cAdvisor: ID 14282.
Estos dashboards proporcionan visualizaciones preconfiguradas para las métricas recopiladas por Node Exporter y cAdvisor.

---
### Exporters para Kubernetes
####  kube-state-metrics es un exporter que recopila métricas sobre el estado de los objetos de Kubernetes, como pods, nodos, deployments y servicios.

#### Métricas clave:
Estado de los pods: kube_pod_status_phase.
Recursos solicitados y límites: kube_pod_container_resource_requests_cpu_cores.
Estado de los nodos: kube_node_status_condition.

#### Instalación:
kube-state-metrics suele estar incluido en el chart kube-prometheus-stack. Si no, puedes instalarlo manualmente:
helm install kube-state-metrics bitnami/kube-state-metrics

#### cAdvisor
cAdvisor (Container Advisor) recopila métricas de los contenedores en cada nodo, como uso de CPU, memoria y red.

#### Métricas clave:
Uso de CPU: container_cpu_usage_seconds_total.
Uso de memoria: container_memory_usage_bytes.
Uso de red: container_network_receive_bytes_total.

#### Configuración:
cAdvisor está integrado en el kubelet, por lo que no requiere instalación adicional. Solo asegúrate de que Prometheus esté configurado para recopilar métricas de cAdvisor (ver Módulo 2).

#### Node Exporter
Node Exporter recopila métricas de los nodos, como uso de CPU, memoria, disco y red.

#### Métricas clave:
Uso de CPU: node_cpu_seconds_total.
Uso de memoria: node_memory_MemAvailable_bytes.
Uso de disco: node_filesystem_usage_bytes.

#### Configuración:
Node Exporter suele estar incluido en el chart kube-prometheus-stack. Si no, puedes instalarlo manualmente:
helm install node-exporter prometheus-community/prometheus-node-exporter

### Alertas Básicas en Prometheus
Prometheus permite configurar alertas basadas en métricas. Estas alertas se gestionan a través de Alertmanager, que puede enviar notificaciones a canales como Slack, Email, etc.

#### Configuración de Reglas de Alertas
Las reglas de alertas se definen en un archivo YAML. Aquí tienes algunos ejemplos:
##### Alerta por Uso de CPU Alto:
groups:- name: node_alerts
    rules:
      - alert: HighCPUUsage
        expr: sum(rate(node_cpu_seconds_total[5m])) by (node) > 0.8
        for: 5m
        labels:
          severity: critical
        annotations:
          summary: "High CPU usage on {{ $labels.node }}"
          description: "CPU usage on {{ $labels.node }} is above 80% for 5 minutes."


##### Alerta por Memoria Baja:

- alert: LowMemory
  expr: node_memory_MemAvailable_bytes / node_memory_MemTotal_bytes < 0.2
  for: 10m
  labels:
    severity: warning
  annotations:
    summary: "Low memory on {{ $labels.node }}"
    description: "Available memory on {{ $labels.node }} is below 20% for 10 minutes."


Alerta por Pods Fallidos:
- alert: FailedPods
  expr: kube_pod_status_phase{phase="Failed"} > 0
  for: 5m
  labels:
    severity: critical
  annotations:
    summary: "Failed pods in {{ $labels.namespace }}"
    description: "There are failed pods in namespace {{ $labels.namespace }}

##### Configuración de Alertmanager
Alertmanager gestiona las alertas generadas por Prometheus. Para configurarlo:
Crea un archivo de configuración (alertmanager.yml):

global:
  resolve_timeout: 5m
route:
  receiver: 'email-notifications'
  routes:
    - match:
        severity: 'critical'
      receiver: 'slack-notifications'
receivers:
  - name: 'email-notifications'
    email_configs:
      - to: 'admin@example.com'
  - name: 'slack-notifications'
    slack_configs:
      - api_url: 'https://hooks.slack.com/services/...'


##### Aplica la configuración:

kubectl create secret generic alertmanager-config --from-file=alertmanager.yml

#### Dashboards en Grafana
##### Importar Dashboards
Grafana proporciona dashboards preconfigurados para Kubernetes. Puedes importarlos usando sus IDs:
- Kubernetes Cluster Monitoring: ID 315.
- Kubernetes Node Monitoring: ID 1860.
- Kubernetes Pods Monitoring: ID 6417.

##### Crear Dashboards Personalizados
Puedes crear dashboards personalizados en Grafana usando consultas PromQL. Por ejemplo:
Uso de CPU por Namespace:
sum(rate(container_cpu_usage_seconds_total[5m])) by (namespace)
Uso de Memoria por Nodo:
node_memory_MemAvailable_bytes


#### Introducción a Grafana

##### ¿Qué es Grafana?
Grafana es una herramienta de visualización de datos de código abierto que permite crear dashboards interactivos para monitorear métricas. Es ampliamente utilizado en combinación con Prometheus para visualizar métricas de sistemas, aplicaciones y clústeres de Kubernetes.

##### Características principales de Grafana:
- Visualización flexible: Gráficos, tablas, paneles de estado, etc.
- Integración con múltiples fuentes de datos: Prometheus, Loki, InfluxDB, MySQL, etc.
- Dashboards personalizables: Paneles configurables y arrastrables.
- Alertas: Configuración de alertas basadas en métricas.

##### Instalación de Grafana en Kubernetes
La forma más sencilla de instalar Grafana en Kubernetes es utilizando Helm.
##### Pasos para instalar Grafana con Helm:
Agrega el repositorio de Helm de Grafana:
repo add grafana https://grafana.github.io/helm-charts
helm repo update

##### Instala Grafana:
helm install grafana grafana/grafana
##### Verifica la instalación:
kubectl get pods -l app.kubernetes.io/name=grafana
##### Accede a Grafana:
Obtén la contraseña inicial:
kubectl get secret grafana -o jsonpath="{.data.admin-password}" | base64 --decode
Accede a la interfaz web en http://<grafana-service-ip>:3000.

##### Conexión de Grafana con Prometheus
Para visualizar métricas en Grafana, debes configurar Prometheus como una fuente de datos (datasource).
##### Pasos para configurar Prometheus como Datasource:
Inicia sesión en Grafana (puerto 3000).
Ve a Configuration > Data Sources.
Haz clic en Add data source.
Selecciona Prometheus.
Configura la URL del servidor de Prometheus (ej: http://prometheus-server:9090).
Haz clic en Save & Test para verificar la conexión.

#### Creación de Dashboards Básicos
Grafana permite crear dashboards personalizados utilizando consultas PromQL. A continuación, te mostramos cómo crear un dashboard básico.
##### Crear un Nuevo Dashboard
Haz clic en Create > Dashboard.
Selecciona Add new panel.
##### Configura el panel:
Selecciona el datasource de Prometheus.
Escribe una consulta PromQL en el campo Query.

#### Ejemplos de Paneles
Uso de CPU por Nodo:
##### Consulta PromQL:
sum(rate(container_cpu_usage_seconds_total[5m])) by (node)
Visualización: Gráfico de líneas.
Uso de Memoria por Namespace:
##### Consulta PromQL:
sum(container_memory_usage_bytes) by (namespace)
Visualización: Gráfico de barras.
Número de Pods en Ejecución:
count(kube_pod_status_phase{phase="Running"})
Visualización: Panel de estado.

#### Importar Dashboards Preconfigurados
Grafana ofrece dashboards preconfigurados que puedes importar fácilmente. Estos dashboards están diseñados para visualizar métricas comunes de Kubernetes y Prometheus.
##### Pasos para Importar un Dashboard:
Haz clic en Create > Import.
Ingresa el ID del dashboard que deseas importar (ej: 315 para el dashboard de Kubernetes).
Selecciona el datasource de Prometheus.
Haz clic en Import.
##### Dashboards Recomendados:
Kubernetes Cluster Monitoring: ID 315.
Node Exporter Full: ID 1860.
Kubernetes / Compute Resources / Pods: ID 6417.

##### Configuración de Alertas en Grafana
Grafana permite configurar alertas basadas en métricas visualizadas en los dashboards.
##### Pasos para Configurar una Alerta:
Abre un panel en tu dashboard.
Haz clic en el título del panel y selecciona Edit.
Ve a la pestaña Alert.
Configura la condición de la alerta (ej: avg() OF query(A, 1m, now) IS ABOVE 0.8).
Define los canales de notificación (ej: Email, Slack).
Guarda el panel y el dashboard.
##### Ejemplo de Alerta:
Alerta por Uso de CPU Alto:
Condición: avg() OF query(A, 1m, now) IS ABOVE 0.8.
Notificación: Enviar un mensaje a Slack cuando el uso de CPU supere el 80%.

#### Prácticas Recomendadas para Grafana
##### Organización de Dashboards:
Crea carpetas para organizar dashboards por equipo, proyecto o entorno (ej: Producción, Desarrollo).
##### Uso de Variables:
Define variables para filtrar métricas por namespace, nodo o aplicación.
Ejemplo: Crear una variable namespace para filtrar métricas por namespace.
##### Exportación y Backup:
Exporta dashboards como JSON para respaldarlos o compartirlos.
Usa herramientas como grafana-backup para automatizar backups.
