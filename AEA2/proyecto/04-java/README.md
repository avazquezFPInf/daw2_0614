# Etapa 4 · Punto de Juego en Java

## Artefacto y requisitos
Se proporciona tornejos.war, listo para desplegar en Tomcat 10.1 con Java 17 o 21. Usa Jakarta Servlet 6.0 y el controlador MariaDB Connector/J incluido en WEB-INF/lib. No hay que programar ni reconstruir el código.

Apache HTTP Server y PHP-FPM se mantienen. Tomcat escucha localmente en 8080 y ejecuta Java. MariaDB sigue en 127.0.0.1:3306. Esta entrega no integra Apache con Tomcat ni despliega la API Node.js.

## Qué hace
Consulta torneos no borrador, muestra sus rondas y partidas y registra A, B, E o pendiente en torneos en curso. Utiliza la base puntdejoc y el modelo del encargo 3, sin nuevas tablas. No genera rondas ni emparejamientos. El ranking se consulta en la web PHP del torneo 2.

## Configuración externa del contexto
Debéis proporcionar estas entradas JNDI de tipo java.lang.String desde la configuración de Tomcat, fuera del WAR y de Git:
- jdbcUrl: jdbc:mariadb://127.0.0.1:3306/puntdejoc
- jdbcUser: cuenta propia para Java con SELECT en puntdejoc.* y UPDATE solo de resultat en partides.
- jdbcPassword: contraseña de esa cuenta, propia de cada ordenador.

La cuenta de lectura de PHP permanece intacta. La configuración del pool PHP-FPM no configura el entorno Java. El WAR no contiene credenciales. El nombre tornejos.war determina el contexto /tornejos en el despliegue habitual.

## Comprobaciones
Acceso: http://127.0.0.1:8080/tornejos/. Deben verse Java, contexto, torneos y 6 partidas repartidas en 3 rondas para el torneo 2.
La partida 3 debe estar pendiente al comenzar la prueba de ranking inicial: Aina 3, Cris 1, Dani 1, Biel 0. Si ya la modificaste en el encargo 3, restaura solo ese resultado desde una cuenta autorizada o documenta otro punto de partida. Al pasar la partida 3 a victoria B, Cris debe tener 4 puntos en PHP. Reiniciar Tomcat no borra el resultado de MariaDB.

400 indica parámetros no válidos; 403 acceso no local o token de sesión inválido; 404 torneo/ruta inexistente; 409 partida no modificable; 503 configuración o consulta fallida. Los detalles internos se consultan en logs. Si vuelves a guardar un valor idéntico, el recuento de filas puede depender del controlador: no uses esa operación para demostrar un cambio.

## Alcance local
Es un prototipo docente sin login: rechaza peticiones cuya dirección remota no sea loopback. Configurad además Tomcat en 127.0.0.1. No publicarlo ni colocarlo detrás de un proxy sin añadir autenticación y autorización. El token de formulario evita cambios mediante peticiones ajenas a la sesión, pero no autentica usuarios.

## Contenido
- tornejos.war: entrega que se despliega, sin descomprimir en la raíz de Apache.
- web/: fuente de la misma aplicación por transparencia.
- THIRD-PARTY.md: procedencia y licencia del controlador JDBC.

La configuración y los comandos completos de referencia los conserva el profesorado. El encargo pide tareas y evidencias, no reconstruir el programa.

En el encargo de contenedores, el contexto proporcionado habilita explícitamente labContainerAccess para aceptar la conexión desde la red Docker. Solo debe usarse junto a la publicación del puerto en 127.0.0.1; el WAR nativo conserva su restricción por defecto.
