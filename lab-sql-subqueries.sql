/*Write SQL queries to perform the following tasks using the Sakila database:*/

/* 1. Determine the number of copies of the film "Hunchback Impossible" that exist in the inventory system.*/


use sakila;
select * from film_list fl ;


SELECT count(*) as Copies_number
from inventory i 
left join film f 
on i.film_id = f.film_id
where title = "Hunchback Impossible"
;

-- CTEs -- 

with inventory as (
	select count(*) as Copies_number
	from inventory i
	left join film f 
	on i.film_id = f.film_id
	where title = "Hunchback Impossible"
	)
select Copies_number
from inventory;


/* 2. List all films whose length is longer than the average length of all the films in the Sakila database.*/

SELECT title 
from film 
where length > (
select avg(length)
from film);

-- CTEs --

with avg_film_length as(
select avg(LENGTH) as avg_length
from sakila.film
),
second_cte as (
select avg_length as avg_run_time
from avg_film_length)



/* 3. Use a subquery to display all actors who appear in the film "Alone Trip".*/

select concat(first_name, " ", last_name) as Actor
from film f 
left join film_actor fa 
on f.film_id = fa.film_id 
left join actor a 
on fa.actor_id = a.actor_id
where title = "Alone Trip";

-- Subquery --

select *
from actor
where actor_id in (select actor_id 
                   from film_actor
				   where film_id in (select film_id
                                     from film
									 where title = 'Alone Trip'));
									

-- CTEs --
									
with actors as (
select actor_id 
from film_actor
where film_id in (select film_id
                  from film
				  where title = 'Alone Trip'
))
select *
from actor
where actor_id in (select actor_id from actors);

-- CTEs another solution --

with alone_trip as(
	select film_id
	from film where title = 'Alone Trip')
, actors_in_alone_trip as(
	select actor_id
	from film_actor fa 
	inner join alone_trip a
	on fa.film_id = a.film_id
)
select first_name, last_name
from actor
where actor_id in (select * from actors_in_alone_trip);

-- Bonus: --

/* 4. Sales have been lagging among young families, and you want to target family movies for a promotion.
Identify all movies categorized as family films.*/

select title
from film 
where film_id in (select film_id 
					  from film_category
					  where category_id in (select category_id
					  					from category 
					  					where name = 'Family' 
					  					));

/* 5. Retrieve the name and email of customers from Canada using both subqueries and joins.
 To use joins, you will need to identify the relevant tables and their primary and foreign keys.*/
 

select concat(first_name," ",last_name) as Name, email as Email, address_id 
from customer c 
where address_id in (select address_id 
				  from address a 
				  left join city c2 
				  on a.city_id = c2.city_id
				  left join country c3 
				  on c2.country_id = c3.country_id
				  where country = 'Canada');

				 
/* 6. Determine which films were starred by the most prolific actor in the Sakila database.
 A prolific actor is defined as the actor who has acted in the most number of films.
 First, you will need to find the most prolific actor and then use that actor_id to find the different 
 films that he or she starred in.*/

SELECT f.title
FROM film f
join film_actor fa 
on f.film_id = fa.film_id 
where fa.actor_id in (
	SELECT actor_id
	from film_actor fa2 
	group by actor_id
	having count(*) = (
		select count(*)
		from film_actor fa3
		group by actor_id
		order by count(*) desc
		limit 1
		)
	);

/* 7. Find the films rented by the most profitable customer in the Sakila database.
 You can use the customer and payment tables to find the most profitable customer, i.e., 
 the customer who has made the largest sum of payments.*/
 


/* 8. Retrieve the client_id and the total_amount_spent of those clients who spent more than the average 
 of the total_amount spent by each client. You can use subqueries to accomplish this.*/