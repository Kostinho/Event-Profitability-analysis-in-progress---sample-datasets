


--Let's figure out the total profit breakdown and create the table for it.

--Part 1. Preparing the table.

--Step 1 Select every key characteristics from all tables and join them, so all details will be captured


Select c1.id as customer_id,o.id as order_number, c2."desc" as city_name, os."desc" as operation_system, e."desc" as event_name,Gender,age,
Round ((tcktprx/percentage)*100-(negex+devex),2) as rounded_profit 
from customers as c1 
inner join cities as c2 on c1.city=c2.id
inner join os on os.id=c1.os 
inner join Orders as o on o.customer=c1.id 
inner join Events as e on o.event=e.id 

-- Step 2. Create the table for the above

Create table Profitability_breakdown as
Select c1.id as customer_id,o.id as order_number, c2."desc" as city_name, os."desc" as operation_system, e."desc" as event_name,Gender,age,
Round ((tcktprx/percentage)*100-(negex+devex),2) as rounded_profit 
from customers as c1 
inner join cities as c2 on c1.city=c2.id
inner join os on os.id=c1.os 
inner join Orders as o on o.customer=c1.id 
inner join Events as e on o.event=e.id
Group by event_name,city_name,customer_id,order_number,operation_system

--Part 2. Analysis of profitability by each characteristic.

-- Step 1. By city. could be the initial hint to overall engagement rate for social events

Select city_name, AVG(rounded_profit) from Profitability_breakdown
Group by city_name
Order by rounded_profit DESC 

--Step 2. By event and city. Could be the signal, how customers prefer to spend their time in each city

Select event_name,city_name, avg (rounded_profit) from Profitability_breakdown 
Group by event_name, city_name
Order by rounded_profit DESC 

--Looks like the public prefers arts and sportive activities to the food-related events


-- Step 3. Let's seek profit by gender and city
Select gender, city_name , avg (rounded_profit) from Profitability_breakdown 
Group by gender,city_name 
Order by rounded_profit 

--In Montreal, females brought bigger average profits, could be the sign of their higher engagement, 
--In Toronto , males brought average profits, could be the sign of their higher engagement.
--Alternatively, the event price could be the factor.

--Lets add new column to the Profitability table
Alter table Profitability_breakdown 
Add Event_status VARCHAR(255)

UPDATE Profitability_breakdown
SET Event_status =
    CASE
        WHEN rounded_profit > 10000000 THEN 'successful'
        WHEN rounded_profit BETWEEN 2000000 AND 5000000 THEN 'Satisfactory'
        ELSE 'fail'
    END
WHERE rounded_profit > 10000000 OR rounded_profit <10000000; 






