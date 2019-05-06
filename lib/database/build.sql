create table goods(
	name varchar(20),
	model varchar(20),
	primary key(name, model));

create table replenish(
	name varchar(20),
	model varchar(20),
	num interger,
	price double,
	time date,
	finished boolean,
	primary key(name, model, time),
	foreign key(name, model) references goods(name, model));

create table sell_record(
	name varchar(20),
	model varchar(20),
	num interger,
	price double,
	time date,
	primary key(name, model, time),
	foreign key(name, model) references goods(name, model));

create table storehouse(
	name varchar(20),
	model varchar(20),
	num interger,
	primary key(name, model),
	foreign key(name, model) references goods(name, model));

create table setting(
    single interger,
    darkTheme bool,
    alertNum interger,
	primary key(darkTheme),
);
