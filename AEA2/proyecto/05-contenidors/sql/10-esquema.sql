CREATE TABLE jocs (
    id INT PRIMARY KEY,
    nom VARCHAR(100) NOT NULL UNIQUE
) ENGINE=InnoDB;

CREATE TABLE activitats (
    id INT PRIMARY KEY,
    joc_id INT NOT NULL,
    titol VARCHAR(150) NOT NULL,
    tipus ENUM('trobada', 'torneig') NOT NULL,
    estat ENUM('borrador', 'oberta', 'en_curs', 'finalitzada') NOT NULL,
    data DATE NOT NULL,
    lloc VARCHAR(150) NOT NULL,
    places INT NOT NULL,
    CHECK (places > 0),
    FOREIGN KEY (joc_id) REFERENCES jocs(id)
) ENGINE=InnoDB;

CREATE TABLE inscripcions (
    id INT PRIMARY KEY,
    activitat_id INT NOT NULL,
    alias VARCHAR(60) NOT NULL,
    UNIQUE (activitat_id, alias),
    FOREIGN KEY (activitat_id) REFERENCES activitats(id)
) ENGINE=InnoDB;

CREATE TABLE rondes (
    id INT PRIMARY KEY,
    activitat_id INT NOT NULL,
    numero INT NOT NULL,
    CHECK (numero > 0),
    UNIQUE (activitat_id, numero),
    FOREIGN KEY (activitat_id) REFERENCES activitats(id)
) ENGINE=InnoDB;

CREATE TABLE partides (
    id INT PRIMARY KEY,
    ronda_id INT NOT NULL,
    participant_a INT NOT NULL,
    participant_b INT NOT NULL,
    resultat ENUM('A', 'B', 'E') NULL,
    CHECK (participant_a <> participant_b),
    FOREIGN KEY (ronda_id) REFERENCES rondes(id),
    FOREIGN KEY (participant_a) REFERENCES inscripcions(id),
    FOREIGN KEY (participant_b) REFERENCES inscripcions(id)
) ENGINE=InnoDB;

