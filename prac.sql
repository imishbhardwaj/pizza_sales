select * from pizza_sales

SET SQL_SAFE_UPDATES = 0;

UPDATE pizza_sales
SET order_date = CASE
    WHEN order_date LIKE '%/%/%' THEN STR_TO_DATE(order_date, '%d/%m/%Y')
    WHEN order_date LIKE '%-%-%' THEN STR_TO_DATE(order_date, '%d-%m-%Y')
    ELSE NULL
END;

alter table pizza_sales
modify column order_date date;

SET SQL_SAFE_UPDATES = 1;

describe pizza_sales
SET SQL_SAFE_UPDATES = 0;

update pizza_sales
set order_time =str_to_date(order_time,'%H:%i:%s')

alter table pizza_sales
modify column order_time time;

describe pizza_sales

SET SQL_SAFE_UPDATES = 1;

select round(sum(quantity*unit_price),0) as t_sales
from pizza_sales

select sum(quantity) from pizza_sales
select count(*) from pizza_sales

select round(sum(total_price)) as total_sales from pizza_sales 

-- Total sales analysis
select 
  month(order_date) as month,
  round(sum(total_price)) as total_sales,
  (sum(total_price)-lag(sum(total_price),1)
  over(order by month(order_date)))/lag(sum(total_price),1)
  over(order by month(order_date))*100 as mom_increase_percentage
from pizza_sales
where month(order_date) in (4,5)
group by month(order_date)
order by month(order_date)

-- Total order analysis
select count(order_id) from pizza_sales

select 
  month(order_date) as month,
  count(order_id) as total_orders,
  (count(order_id)-lag(count(order_id),1)
  over(order by month(order_date)))/lag(count(order_id),1)
  over(order by month(order_date))*100 as mom_increase_percentage
from pizza_sales
where month(order_date) in (4,5)
group by month(order_date)
order by month(order_date)

-- total quantity sold
select sum(quantity) from pizza_sales

select 
  month(order_date) as month,
  sum(quantity) as total_quantity,
  (sum(quantity)-lag(sum(quantity),1)
  over(order by month(order_date)))/lag(sum(quantity),1)
  over(order by month(order_date))*100 as mom_increase_percentage
from pizza_sales
where month(order_date) in (4,5)
group by month(order_date)
order by month(order_date)

-- calendar heat map
select round(sum(unit_price*quantity),0) as Totalsales,
	   sum(quantity) as TotalQuantity,
       count(order_id) as Totalorders
       from pizza_sales;
-- Sales for weekday and wekend
select 
      case when dayofweek(order_date) in (1,7) then 'weekends'
      else 'weekdays'
      end as daytype,
      round(sum(unit_price*quantity),0) as totalsales
      from pizza_sales
      where month(order_date)=5
      group by daytype;

-- sales by pizza category
select
      pizza_category,
      concat(round(sum(unit_price*quantity)/1000,0),'K') as totalsales
      from pizza_sales
      where month(order_date)=5
      group by pizza_category
      order by totalsales desc
      
-- Avg sales over period

select      
      avg(totalsales) as avg_sales
      from 
      (select sum(quantity*unit_price) as totalsales
      from pizza_sales
      where month(order_date)=5
      group by order_date) as iq

-- everyday sales
select
      day(order_date) as dayofmonth,
      sum(unit_price*quantity) as totalsales
      from pizza_sales
      where month(order_date)=5
      group by day(order_date)
      order by day(order_date)

-- sales as per average line
select 
	  day_of_month,
      case
      when totalsales>avgsales then 'Above avgsales'
      when totalsales<avgsales then 'Below avgsales'
      else 'average'
      end as sales_status,totalsales
      from(
      select
      day(order_date) as day_of_month,
      sum(unit_price*quantity) as totalsales,
      avg( sum(unit_price*quantity)) over() as avgsales
      from pizza_sales
      where month(order_date)=5
      group by day(order_date)) as salesdata
      order by day_of_month;

-- Top 10 pizza
select pizza_name,
sum(quantity*unit_price) as totalsales
from pizza_sales
where month(order_date)=5
group by pizza_name
order by totalsales desc
limit 10

-- sales by hour and day
select 
sum(quantity*unit_price) as totalsales,sum(quantity) as totalquantity,count(order_id) as totalorders
from pizza_sales
where month(order_date)=5
and dayofweek(order_date)=2
and hour(order_time)=20



