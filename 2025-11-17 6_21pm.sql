use test ;

select * from ratings ;


create schema tableSchema;


alter table ratings 
rename column  MOVIEID TO NEW_MOVIEID;


select * from ratings ; 


select userid , new_movieid , rating, to_timestamp(timestamp) from ratings;


create table ratings2(id int , mid int);

insert into ratings2(id, mid) values(99,100);

select * from ratings2 ;















































