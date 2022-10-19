--Zad2
create database cw2;

--Zad3
CREATE EXTENSION postgis;

--Zad4
create table buildings (
	id int primary key,
	geometry geometry,
	name varchar
);
create table roads (
	id int primary key,
	geometry geometry,
	name varchar
);
create table poi (
	id int primary key,
	geometry geometry,
	name varchar
);

--Zad5
insert into buildings(id, geometry, name)
values (1, 'POLYGON((8 4, 10.5 4, 10.5 1.5, 8 1.5, 8 4))', 'BuildingA'),
	   (2, 'POLYGON((4 7, 6 7, 6 5, 4 5, 4 7))', 'BuildingB'),
	   (3, 'POLYGON((3 8, 5 8, 5 6, 3 6, 3 8))', 'BuildingC'),
	   (4, 'POLYGON((9 9, 10 9, 10 8, 9 8, 9 9))', 'BuildingD'),
	   (5, 'POLYGON((1 1, 1 2, 2 2, 2 1, 1 1))', 'BuildingF');
	   
	  
insert into roads(id, geometry, name)
VALUES (1, 'LINESTRING(0 4.5, 12 4.5)', 'RoadX'),
       (2, 'LINESTRING(7.5 0, 7.5 10.5)', 'RoadY');
       

insert into poi(id, geometry, name)
VALUES (1, 'POINT(1 3.5)', 'G'),
       (2, 'POINT(5.5 1.5)', 'H'),
       (3, 'POINT(9.5 6)', 'I'),
       (4, 'POINT(6.5 6)', 'J'),
       (5, 'POINT(6 9.5)', 'K');
       
--Zad6    
--a
select sum(st_length(geometry)) 
from roads;
      
--b
select geometry, st_area(geometry), st_perimeter(geometry)
from buildings
where name = 'BuildingA';

--c
select name, st_area(geometry)
from buildings
order by name;

--d
select name, st_perimeter(geometry) as obwod
from buildings
order by obwod desc
limit 2;

--e
select st_distance(p.geometry, b.geometry) from poi p, buildings b
where p.name = 'K' and b.name = 'BuildingC'

--f
select st_area(st_difference(a.geometry, st_buffer(b.geometry, 0.5))) from buildings a, buildings b
where a.name = 'BuildingC' and b.name = 'BuildingB'

--g
select b.name from buildings b, roads r
where r.name = 'RoadX' and st_y(st_centroid(b.geometry)) > st_y(st_centroid(r.geometry));

--h
select st_area(st_symdifference(geometry,  st_geomfromtext('POLYGON((4 7, 6 7, 6 8, 4 8, 4 7))'))) from buildings
where name = 'BuildingC';