-- CREATE the database

CREATE database OCPIZZA;

-- USE the database to modify

use OCPIZZA;

-- CREATE all tables 

CREATE TABLE adresse (
	id INTEGER AUTO_INCREMENT PRIMARY KEY,    
    numero_rue INTEGER,
    complement VARCHAR(255),
    rue VARCHAR(100) NOT NULL,
    code_postal VARCHAR(5) NOT NULL,
    ville VARCHAR(155) NOT NULL,
    etage INTEGER
);

CREATE TABLE utilisateur_action(
	id INTEGER AUTO_INCREMENT PRIMARY KEY,
    nom VARCHAR(255),
    email VARCHAR(255)                        
);

CREATE TABLE pizzeria(
	id INTEGER AUTO_INCREMENT PRIMARY KEY,
	nom VARCHAR(255),
    numero_telephone VARCHAR(10)
);

CREATE TABLE utilisateur (
	id INTEGER AUTO_INCREMENT PRIMARY KEY,
    id_pizzeria INTEGER,
	nom VARCHAR(100) NOT NULL,
    prenom VARCHAR(100) NOT NULL,
    identifiant VARCHAR(100) NOT NULL,
    email VARCHAR(255) NOT NULL,
    role VARCHAR(255) NOT NULL,
    actif BOOLEAN DEFAULT TRUE,
    FOREIGN KEY (id_pizzeria) REFERENCES pizzeria(id) 
);

CREATE TABLE employe(
	id_utilisateur INTEGER,
    matricule VARCHAR(255) NOT NULL,
    PRIMARY KEY (id_utilisateur),
    FOREIGN KEY (id_utilisateur) REFERENCES utilisateur(id)
);

CREATE TABLE commande (
	reference INTEGER AUTO_INCREMENT PRIMARY KEY, 
    id_utilisateur INTEGER,
    id_adresse INTEGER,
    id_employe INTEGER,
    date DATE NOT NULL,
    date_livraison DATE NOT NULL,
    etat VARCHAR(50) NOT NULL,
    FOREIGN KEY (id_utilisateur) REFERENCES utilisateur(id),
    FOREIGN KEY (id_adresse) REFERENCES adresse(id),
    FOREIGN KEY (id_employe) REFERENCES employe(id_utilisateur)
);

CREATE TABLE notification (
	id_utilisateur INTEGER,
    id_adresse INTEGER,
    id_commande INTEGER,
    message VARCHAR(255) NOT NULL,
    date DATE NOT NULL,
    etat_commande VARCHAR(50) NOT NULL,
    PRIMARY KEY (id_utilisateur, id_adresse, id_commande),
    FOREIGN KEY (id_utilisateur) REFERENCES utilisateur(id),
    FOREIGN KEY (id_adresse) REFERENCES adresse(id),
    FOREIGN KEY (id_commande) REFERENCES commande(reference)
);

CREATE TABLE paiement(
    id_commande INTEGER,
    statut BOOLEAN DEFAULT FALSE,
    date DATE NOT NULL,
    moyen VARCHAR(50),
    PRIMARY KEY(id_commande),
    FOREIGN KEY (id_commande) REFERENCES commande(reference)
);

CREATE TABLE client(
	id_utilisateur INTEGER,
    id_adresse INTEGER,
    numero_telephone VARCHAR(10),
    autorisation_notification BOOLEAN DEFAULT FALSE,
    PRIMARY KEY (id_utilisateur, id_adresse),
    FOREIGN KEY (id_utilisateur) REFERENCES utilisateur(id),
    FOREIGN KEY (id_adresse) REFERENCES adresse(id)
);

CREATE TABLE pizza(
	id INTEGER AUTO_INCREMENT PRIMARY KEY,
    nom VARCHAR(50) NOT NULL,
    prix FLOAT NOT NULL,
    photo LONGTEXT NOT NULL
);

CREATE TABLE ingredient(
	id INTEGER AUTO_INCREMENT PRIMARY KEY,
    nom VARCHAR(150) NOT NULL
);

CREATE TABLE stock(
	id INTEGER AUTO_INCREMENT PRIMARY KEY,
    id_pizzeria INTEGER,
    id_ingredient INTEGER,
	quantite INTEGER NOT NULL,
    unite_de_mesure VARCHAR(15) NOT NULL,
    FOREIGN KEY (id_pizzeria) REFERENCES pizzeria(id),
    FOREIGN KEY (id_ingredient) REFERENCES ingredient(id)
);

CREATE TABLE recette(
	id INTEGER AUTO_INCREMENT PRIMARY KEY,
    id_pizza INTEGER,
    id_ingredient INTEGER,
    quantite INTEGER NOT NULL,
    unite_de_mesure VARCHAR(15) NOT NULL,
    FOREIGN KEY (id_pizza) REFERENCES pizza(id),
    FOREIGN KEY (id_ingredient) REFERENCES ingredient(id)
);

CREATE TABLE ligne_commande(
    id_commande INTEGER,
    id_pizza INTEGER,
    quantite INTEGER NOT NULL,
	PRIMARY KEY (id_commande, id_pizza),
    FOREIGN KEY (id_commande) REFERENCES commande(reference),
    FOREIGN KEY (id_pizza) REFERENCES pizza(id)
);

CREATE TABLE pizza_disponible(
	id INTEGER AUTO_INCREMENT PRIMARY KEY,
    id_stock INTEGER,
    id_pizza INTEGER,
    quantite INTEGER DEFAULT 0,
    FOREIGN KEY (id_stock) REFERENCES stock(id),
    FOREIGN KEY (id_pizza) REFERENCES pizza(id)
);

CREATE TABLE action(
	id INTEGER AUTO_INCREMENT PRIMARY KEY,
    id_utilisateur INTEGER,
    id_utilisateur_action INTEGER,
    necessite_pouvoir VARCHAR(20),
    FOREIGN KEY (id_utilisateur) REFERENCES utilisateur(id),
    FOREIGN KEY (id_utilisateur_action) REFERENCES utilisateur_action(id)
);

-- Insert values into the database in each table with the FK(s)

INSERT INTO adresse (numero_rue, complement, rue, code_postal, ville, etage)
VALUES
(15, "entrée à l'arrière", "rue des jardins", "67450", "Mundolsheim", 1),
(2, "", "avenue des Lilas", "75019", "Paris", 3),
(1, "", "rue du Général de Gaulle", "59000", "Lille", 2);

INSERT INTO utilisateur_action (nom, email)
VALUES
('Deniro Robert', 'robertdeniro@gmail.com'),
('Dujardin Jean', 'jeandujardin@gmail.com'),
('Dupont Alice', 'alicedupont@gmail.com'),
('Martin Julien', 'julienmartin@gmail.com'),
('Meyer Lola', 'lolameyer@gmail.com'),
('Meyer Franck', 'franckmeyer@gmail.com');

INSERT INTO pizzeria (nom, numero_telephone)
VALUES
('Chez Franck', '0323456789');

INSERT INTO utilisateur (id_pizzeria, nom, prenom, identifiant, email, role, actif)
VALUES 
(1, 'Deniro', 'Robert', 'Roro', 'robertdeniro@gmail.com', 'CLIENT', true),
(1, 'Dujardin', 'Jean', 'Jd', 'jeandujardin@gmail.com', 'CLIENT', true),
(1, 'Pitt', 'Brad', 'Bratt', 'bradpitt@gmail.com', 'CLIENT', true),
(1, 'Dupont', 'Alice', 'Aly', 'alicedupont@gmail.com', 'PIZZAIOLO', true),
(1, 'Martin', 'Julien', 'Juju', 'julienmartin@gmail.com', 'LIVREUR', true),
(1, 'Meyer', 'Lola', 'Lolo', 'lolameyer@gmail.com', 'ADMIN', true),
(1, 'Meyer', 'Franck', 'Fran', 'franckmeyer@gmail.com', 'ADMIN', true);

INSERT INTO employe (matricule, id_utilisateur)
VALUES
('PCF1',4),
('LCF1',5);

INSERT INTO commande (id_utilisateur, id_adresse, id_employe, date, date_livraison, etat)
VALUES 
(1,1,4,'2023-03-09', '2023-03-09', 'Commande non traitée'),
(1,1,4,'2023-03-09', '2023-03-09', 'Commande en cours de preparation'),
(1,1,5,'2023-03-09', '2023-03-09', 'Commande en cours de livraison');

INSERT INTO notification (id_utilisateur, id_adresse, id_commande, message, date, etat_commande)
VALUES
(1,1,1,'La situation de votre commande est : ', '2023-03-09', 'Commande non traitée'),
(1,1,2,'La situation de votre commande est : ', '2023-03-09', 'Commande en cours de preparation'),
(1,1,3,'La situation de votre commande est : ', '2023-03-09', 'Commande en cours de livraison');

INSERT INTO paiement (id_commande, statut, date, moyen)
VALUES
(1, true, '2023-03-09', 'Carte bancaire');

INSERT INTO client(id_utilisateur, id_adresse, numero_telephone, autorisation_notification)
VALUES
(1, 1, '0303030303', true),
(2, 2, '0404040404', false),
(3, 3, '0505050505', true);

INSERT INTO pizza (nom, prix, photo)
VALUES
('Margherita', 6.50, 'https://www.istockphoto.com/fr/photos/pizza'),
('Végétarienne', 9.50, 'https://www.istockphoto.com/fr/photos/pizza');

INSERT INTO ingredient (nom)
VALUES
('pâte à pizza'),
('sauce tomate'),
('origan');

INSERT INTO stock (id_pizzeria, id_ingredient, quantite, unite_de_mesure)
VALUES
(1, 1, 100, 'g'),
(1, 2, 500, 'ml'),
(1, 3, 50, 'g');

INSERT INTO recette (id_pizza, id_ingredient, quantite, unite_de_mesure)
VALUES 
(1, 1, 2, 'g'),
(2, 2, 1, 'ml'),
(1, 3, 5, 'g');

INSERT INTO ligne_commande (id_commande, id_pizza, quantite)
VALUES
(1, 1, 2),
(1, 2, 3);

INSERT INTO pizza_disponible (id_stock, id_pizza, quantite) 
VALUES
(1, 1, 5),
(2, 2, 5);

INSERT INTO action ( id_utilisateur, id_utilisateur_action, necessite_pouvoir)
VALUES
(4, 3, 'EMPLOYE'),
(5, 4, 'EMPLOYE'),
(6, 5, 'ADMIN');

