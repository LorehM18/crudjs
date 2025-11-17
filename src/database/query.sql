create DATABASE Prueba01;

USE Prueba01;

create table personas(
    id INT AUTO_INCREMENT primary key,
    name VARCHAR(50) NOT NULL,
    lastname VARCHAR(50) NOT NULL,
    age int

);

select * from personas;