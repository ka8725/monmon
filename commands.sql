create database monmon;
create table accounts(Type character varying(15),Name character varying(25),Currency character varying(4),Amount integer);
insert into accounts(Type,Name,Currency,Amount)
  values ('CC','Alfa-bank CC','BYN',500),
  ('CC','MyBank CC','USD',600),
  ('Cash','In the car','EUR',200),
  ('Cash','At home','RUB',1000),
  ('Cash','At home','UAH',1000),
  ('Bank account','Paritet Bank','BYN',2000),
  ('Deposit account','Priorbank','BYN',4000);
