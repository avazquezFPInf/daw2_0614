<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <!doctype html>
    <html lang="es">

    <head>
        <meta charset="utf-8">
        <meta name="viewport" content="width=device-width,initial-scale=1">
        <title>Servicio de torneos</title>
    </head>

    <body>
        <h1>Servicio de torneos · Punt de Joc</h1>
        <p>Aplicación Java de demostración. Datos independientes de MariaDB en esta etapa.</p>
        <ul>
            <li>Liga de demostración · 4 participantes</li>
            <li>Torneo de damas · Inscripciones abiertas</li>
        </ul>
        <p>Respuesta generada por el servidor: <%= java.time.Instant.now() %>
        </p>
        <p>Java: <%= System.getProperty("java.version") %>
        </p>
        <p>Contexto: <%= request.getContextPath() %>
        </p>
    </body>

    </html>