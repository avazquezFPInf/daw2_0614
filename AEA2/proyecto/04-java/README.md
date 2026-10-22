# Etapa 4 · Java cerrado
Se proporciona tornejos.war. No hay que programar Java. Una JSP genera la hora, la versión Java y el contexto. Tomcat la traduce y compila al desplegar. En esta etapa no consulta MariaDB.

Objetivo: Tomcat 10.1 y JDK 17. Copia el WAR a webapps de tu instalación y visita http://127.0.0.1:8080/tornejos/. Comprueba logs y cambio de hora al recargar. No expongas la interfaz de administración.

El fuente se incluye por transparencia. Para reconstruir desde web con JDK: `jar --create --file ../tornejos.war .`.
