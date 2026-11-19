<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" trimDirectiveWhitespaces="true" %>
<%@ page import="java.sql.*,java.util.*,java.nio.charset.StandardCharsets,java.security.MessageDigest,javax.naming.InitialContext,javax.naming.NamingException" %>
<%!
    // Configuración externa al WAR: Tomcat la proporciona mediante JNDI.
    private String setting(String name) throws NamingException {
        Object value = new InitialContext().lookup("java:comp/env/" + name);
        if (!(value instanceof String) || ((String) value).isBlank()) {
            throw new NamingException("Falta el parámetro " + name);
        }
        return (String) value;
    }
    private Connection database() throws Exception {
        Class.forName("org.mariadb.jdbc.Driver");
        return DriverManager.getConnection(setting("jdbcUrl"), setting("jdbcUser"), setting("jdbcPassword"));
    }
    private String h(Object value) {
        if (value == null) return "";
        return value.toString().replace("&", "&amp;").replace("<", "&lt;")
            .replace(">", "&gt;").replace("\"", "&quot;").replace("'", "&#39;");
    }
    private List<Map<String,Object>> rows(ResultSet result) throws SQLException {
        List<Map<String,Object>> rows = new ArrayList<>();
        ResultSetMetaData meta = result.getMetaData();
        while (result.next()) {
            Map<String,Object> row = new LinkedHashMap<>();
            for (int i = 1; i <= meta.getColumnCount(); i++) {
                row.put(meta.getColumnLabel(i), result.getObject(i));
            }
            rows.add(row);
        }
        return rows;
    }
    private int positiveId(String value) {
        int number = Integer.parseInt(value);
        if (number <= 0) throw new IllegalArgumentException("ID no válido");
        return number;
    }
%>
<%
    request.setCharacterEncoding("UTF-8");
    response.setHeader("Cache-Control", "no-store");
    response.setHeader("X-Content-Type-Options", "nosniff");
    response.setHeader("Content-Security-Policy", "default-src 'self'; form-action 'self'; frame-ancestors 'none'");
    // Prototipo de aula sin login: solo se admite acceso desde el propio equipo.
    String remote = request.getRemoteAddr();
    boolean containerLab = false;
    try {
        containerLab = Boolean.TRUE.equals(new InitialContext().lookup("java:comp/env/labContainerAccess"));
    } catch (NamingException ignored) { /* La instalación nativa mantiene acceso solo por loopback. */ }
    if (!containerLab && !Set.of("127.0.0.1", "::1", "0:0:0:0:0:0:0:1").contains(remote)) {
        response.sendError(403, "Aplicación disponible únicamente en el laboratorio local."); return;
    }
    if (!Set.of("GET", "POST").contains(request.getMethod())) {
        response.setHeader("Allow", "GET, POST"); response.sendError(405); return;
    }
    int tournament;
    try {
        tournament = positiveId(Optional.ofNullable(request.getParameter("torneo")).orElse("2"));
    } catch (IllegalArgumentException error) {
        response.sendError(400, "Identificador de torneo no válido."); return;
    }
    String token = (String) session.getAttribute("csrf");
    if (token == null) { token = UUID.randomUUID().toString(); session.setAttribute("csrf", token); }
    String result = null;
    int matchId = 0;
    if (request.getMethod().equals("POST")) {
        String supplied = request.getParameter("csrf");
        if (supplied == null || !MessageDigest.isEqual(token.getBytes(StandardCharsets.UTF_8), supplied.getBytes(StandardCharsets.UTF_8))) {
            response.sendError(403, "Sesión no válida. Recarga el formulario."); return;
        }
        result = request.getParameter("resultado");
        try {
            matchId = positiveId(request.getParameter("partida"));
            if (result == null || !Set.of("A", "B", "E", "pendiente").contains(result)) {
                throw new IllegalArgumentException("Resultado no válido");
            }
        } catch (IllegalArgumentException error) {
            response.sendError(400, "Partida o resultado no válido."); return;
        }
    }
    List<Map<String,Object>> tournaments;
    List<Map<String,Object>> matches;
    Map<String,Object> selected;
    try (Connection connection = database()) {
        if (request.getMethod().equals("POST")) {
            // El servidor comprueba torneo, estado e inscripción; no confía en el formulario.
            String sql = "UPDATE partides p JOIN rondes r ON r.id=p.ronda_id "
                + "JOIN activitats a ON a.id=r.activitat_id "
                + "JOIN inscripcions ia ON ia.id=p.participant_a JOIN inscripcions ib ON ib.id=p.participant_b "
                + "SET p.resultat=? WHERE p.id=? AND r.activitat_id=? AND a.tipus='torneig' "
                + "AND a.estat='en_curs' AND ia.activitat_id=r.activitat_id AND ib.activitat_id=r.activitat_id";
            try (PreparedStatement statement = connection.prepareStatement(sql)) {
                if (result.equals("pendiente")) statement.setNull(1, Types.VARCHAR); else statement.setString(1, result);
                statement.setInt(2, matchId); statement.setInt(3, tournament);
                if (statement.executeUpdate() == 0) {
                    response.sendError(409, "No se pudo modificar la partida. Comprueba torneo, estado e inscripciones."); return;
                }
            }
            response.setStatus(303);
            response.setHeader("Location", request.getContextPath() + "/?torneo=" + tournament + "&guardado=1"); return;
        }
        try (PreparedStatement statement = connection.prepareStatement(
                "SELECT id,titol,estat FROM activitats WHERE tipus='torneig' AND estat<>'borrador' ORDER BY id")) {
            try (ResultSet rs = statement.executeQuery()) { tournaments = rows(rs); }
        }
        try (PreparedStatement statement = connection.prepareStatement(
                "SELECT id,titol,estat FROM activitats WHERE id=? AND tipus='torneig' AND estat<>'borrador'")) {
            statement.setInt(1, tournament);
            try (ResultSet rs = statement.executeQuery()) {
                List<Map<String,Object>> selection = rows(rs);
                if (selection.isEmpty()) { response.sendError(404, "Torneo no encontrado."); return; }
                selected = selection.get(0);
            }
        }
        try (PreparedStatement statement = connection.prepareStatement(
                "SELECT p.id,r.numero,ia.alias AS alias_a,ib.alias AS alias_b,p.resultat "
                + "FROM partides p JOIN rondes r ON r.id=p.ronda_id "
                + "JOIN inscripcions ia ON ia.id=p.participant_a JOIN inscripcions ib ON ib.id=p.participant_b "
                + "WHERE r.activitat_id=? ORDER BY r.numero,p.id")) {
            statement.setInt(1, tournament);
            try (ResultSet rs = statement.executeQuery()) { matches = rows(rs); }
        }
    } catch (Exception error) {
        application.log("No se puede completar la operación de torneos", error);
        response.sendError(503, "No se puede acceder a los datos. Revisa la configuración y los registros de Tomcat."); return;
    }
%>
<!doctype html>
<html lang="es">
<head><meta charset="utf-8"><meta name="viewport" content="width=device-width,initial-scale=1">
<title>Punto de Juego · Torneos</title><link rel="stylesheet" href="style.css"></head>
<body>
<h1>Punto de Juego · Gestión de torneos</h1>
<p>Laboratorio local: consulta las rondas y registra los resultados de las partidas presenciales.</p>
<form method="get"><label>Torneo <select name="torneo">
<% for (Map<String,Object> item : tournaments) { %>
<option value="<%= h(item.get("id")) %>" <%= ((Number)item.get("id")).intValue() == tournament ? "selected" : "" %>><%= h(item.get("titol")) %></option>
<% } %>
</select></label> <button type="submit">Consultar</button></form>
<h2><%= h(selected.get("titol")) %></h2>
<p>Estado: <%= h(selected.get("estat")) %>. Solo se modifican torneos en curso.</p>
<% if ("1".equals(request.getParameter("guardado"))) { %><p role="status">Resultado guardado. Comprueba ahora la clasificación en el portal PHP.</p><% } %>
<% if (matches.isEmpty()) { %><p>Este torneo todavía no tiene partidas preparadas.</p><% } %>
<% for (Map<String,Object> match : matches) { %>
<article><h3>Ronda <%= h(match.get("numero")) %> · <%= h(match.get("alias_a")) %> / <%= h(match.get("alias_b")) %></h3>
<p>Resultado: <%= match.get("resultat") == null ? "Pendiente" : h(match.get("resultat")) %> (A: primero; B: segundo; E: empate).</p>
<% if ("en_curs".equals(selected.get("estat"))) { %>
<form method="post">
<input type="hidden" name="csrf" value="<%= h(token) %>">
<input type="hidden" name="torneo" value="<%= tournament %>">
<input type="hidden" name="partida" value="<%= h(match.get("id")) %>">
<label>Nuevo resultado <select name="resultado" required>
<option value="" selected disabled>Selecciona</option>
<option value="A">Victoria del primero</option><option value="B">Victoria del segundo</option>
<option value="E">Empate</option><option value="pendiente">Pendiente</option>
</select></label> <button type="submit">Guardar</button>
</form><% } %></article><% } %>
<footer><p>Java <%= h(System.getProperty("java.version")) %> · Contexto <%= h(request.getContextPath()) %></p>
<p>Respuesta generada: <%= h(java.time.Instant.now()) %></p></footer>
</body></html>
