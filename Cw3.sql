--Zad1
select t9.polygon_id, t9.name, t9.geom
from t2018_kar_buildings t8, t2019_kar_buildings t9 
where t9.polygon_id = t8.polygon_id and ST_Equals(t9.geom, t8.geom) = false

--Zad2
select count(*), tp9.type from t2018_kar_buildings tb8, t2019_kar_buildings tb9, t2019_kar_poi_table tp9
where tb9.polygon_id = tb8.polygon_id and ST_Equals(tb9.geom, tb8.geom) = false and st_distancesphere(tb9.geom, tp9.geom) <= 500
group by tp9.type;

--Zad3
create table streets_reprojected (
	gid serial4 NOT NULL,
	link_id float8 NULL,
	st_name varchar(254) NULL,
	ref_in_id float8 NULL,
	nref_in_id float8 NULL,
	func_class varchar(1) NULL,
	speed_cat varchar(1) NULL,
	fr_speed_l float8 NULL,
	to_speed_l float8 NULL,
	dir_travel varchar(1) NULL,
	geom geometry NULL,
	CONSTRAINT streets_reprojected_pkey PRIMARY KEY (gid)
);

insert into streets_reprojected (link_id, st_name, ref_in_id, nref_in_id, func_class, speed_cat, fr_speed_l, to_speed_l, dir_travel, geom)
select link_id, st_name, ref_in_id, nref_in_id, func_class, speed_cat, fr_speed_l, to_speed_l, dir_travel, st_transform(st_setsrid(geom, 4326), 3068) from t2019_kar_streets

--Zad4
create table input_points (
	gid serial4 NOT NULL,
	geom geometry NULL,
	CONSTRAINT input_points_pkey PRIMARY KEY (gid)
);

INSERT INTO public.input_points
(geom)
VALUES(ST_Point(8.36093, 49.03174));
INSERT INTO public.input_points
(geom)
VALUES(ST_Point(8.39876, 49.00644));


--Zad5
UPDATE input_points
SET geom = st_transform(st_setsrid(geom, 4326), 3068);

--Zad6
UPDATE t2019_kar_street_node
SET geom = st_transform(st_setsrid(geom, 4326), 3068);

with inputline (line) as(
	select st_makeline(p1.geom, p2.geom)
    from input_points p1, input_points p2
    where p1.gid = 1 and p2.gid = 2
)
select * 
from t2019_kar_street_node t, inputline i
where st_distance(t.geom, i.line) <= 200;
   
--Zad7
select count(p.poi_name) from t2019_kar_land_use_a l, t2019_kar_poi_table p
where l.type = 'Park (City/County)' and p.type = 'Sporting Goods Store' and st_distancesphere(l.geom, p.geom) <= 300
   
--Zad8
create table T2019_KAR_BRIDGES (
	gid serial4 NOT NULL,
	geom geometry NULL,
	CONSTRAINT t2019_kar_bridges_pkey PRIMARY KEY (gid)
);

insert into T2019_KAR_BRIDGES (geom)
select st_intersection(w.geom, r.geom) from t2019_kar_water_lines w, t2019_kar_railways r
where st_intersects(w.geom, r.geom) = true;

