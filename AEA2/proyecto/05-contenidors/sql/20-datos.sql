USE puntdejoc;

INSERT INTO jocs (id, nom) VALUES
    (1, 'Ajedrez'),
    (2, 'Damas'),
    (3, 'Juego de cartas');

INSERT INTO activitats
    (id, joc_id, titol, tipus, estat, data, lloc, places)
VALUES
    (1, 3, 'Tarde de juegos', 'trobada', 'oberta',
     '2026-11-12', 'Local de la asociación', 16),
    (2, 1, 'Liga de demostración', 'torneig', 'en_curs',
     '2026-11-19', 'Local de la asociación', 4),
    (3, 2, 'Torneo de damas', 'torneig', 'oberta',
     '2026-11-26', 'Biblioteca', 8);

INSERT INTO inscripcions (id, activitat_id, alias) VALUES
    (1, 2, 'Aina'),
    (2, 2, 'Biel'),
    (3, 2, 'Cris'),
    (4, 2, 'Dani');

INSERT INTO rondes (id, activitat_id, numero) VALUES
    (1, 2, 1),
    (2, 2, 2),
    (3, 2, 3);

INSERT INTO partides
    (id, ronda_id, participant_a, participant_b, resultat)
VALUES
    (1, 1, 1, 2, 'A'),
    (2, 1, 3, 4, 'E'),
    (3, 2, 1, 3, NULL),
    (4, 2, 2, 4, NULL),
    (5, 3, 1, 4, NULL),
    (6, 3, 2, 3, NULL);

