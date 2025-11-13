create database supplier;
use supplier;
CREATE TABLE Supplier (
sid INT PRIMARY KEY,
sname VARCHAR(50),
city VARCHAR(50)
);


CREATE TABLE Parts (
pid INT PRIMARY KEY,
pname VARCHAR(50),
color VARCHAR(20)
);

CREATE TABLE Catalog (
sid INT,
pid INT,
cost DECIMAL(10, 2),
PRIMARY KEY (sid, pid),
FOREIGN KEY (sid) REFERENCES Supplier(sid),
FOREIGN KEY (pid) REFERENCES Parts(pid)
);

INSERT INTO Supplier VALUES (10001, 'Acme Widget', 'Bangalore');
INSERT INTO Supplier VALUES (10002, 'Johns', 'Kolkata');
INSERT INTO Supplier VALUES (10003, 'Vimal', 'Mumbai');
INSERT INTO Supplier VALUES (10004, 'Reliance', 'Delhi');
INSERT INTO Supplier VALUES (10005, 'Mahindra', 'Mumbai');

select * from SUPPLIER;

INSERT INTO Parts VALUES (20001, 'Book', 'Red');
INSERT INTO Parts VALUES (20002, 'Pen', 'Red');
INSERT INTO Parts VALUES (20003, 'Pencil', 'Green');
INSERT INTO Parts VALUES (20004, 'Mobile', 'Green');
INSERT INTO Parts VALUES (20005, 'Charger', 'Black');
select * from parts;

INSERT INTO Catalog VALUES (10001, 20001, 10);
INSERT INTO Catalog VALUES (10001, 20002, 10);
INSERT INTO Catalog VALUES (10001, 20003, 30);
INSERT INTO Catalog VALUES (10001, 20004, 10);
INSERT INTO Catalog VALUES (10001, 20005, 10);
INSERT INTO Catalog VALUES (10002, 20001, 10);
INSERT INTO Catalog VALUES (10002, 20002, 20);
INSERT INTO Catalog VALUES (10003, 20003, 30);
INSERT INTO Catalog VALUES (10004, 20003, 40);
select * from catalog;

select distinct pname from parts
where pid in (select pid from catalog);

select sname from supplier
where not exists (select pid from parts
where pid not in (select pid from catalog
where catalog.sid = supplier.sid));

select sname from supplier
where not exists (select pid from parts
where color = 'red' and pid not in (select pid from catalog
where catalog.sid = supplier.sid));

select pname from parts
where pid in ( select pid from catalog
where sid = (select sid from supplier
where sname = 'acme widget'))
and pid not in (select pid from catalog
where sid != (select sid from supplier where sname = 'acme widget'));	


select distinct c.sid from catalog c
join (select pid, avg(cost) as avg_cost from catalog
group by pid) avg_table on c.pid = avg_table.pid
where c.cost > avg_table.avg_cost;

select p.pname,p.pid, s.sname from parts p
join catalog c on p.pid = c.pid
join supplier s on c.sid = s.sid
where (p.pid, c.cost) in (select pid, max(cost) from catalog
group by pid);


