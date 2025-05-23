#project 
#Task 1: Identifying the Top Branch by Sales Growth Rate (6 Marks)
#Walmart wants to identify which branch has exhibited the highest sales growth over time. 
#Analyze the total sales for each branch and compare the growth rate across months to find the top performer.

#Subquery 1: Total sales by branch with window function

select branch,salesdate , sum(total) over(partition by branch  ) as total  from walmartsales 
 order by Total desc ;  

#Subquery 2: Aggregated sales and count by branch
 
select branch,sum(total) as total, count(*) as number_months from walmartsales 
group by Branch
order by Total desc; 

#Subquery 3: Percentage comparison of sales by branch

select branch,Customer_ID,salesDate,(total-lag(total)over(partition by Branch order by salesdate desc)/lag(total)over(partition by Branch order by salesdate desc)*100) as compare
 from walmartsales order by Branch desc;

#Task 2: Finding the Most Profitable Product Line for Each Branch (6 Marks)
#Walmart needs to determine which product line contributes the highest profit to each branch.
#The profit margin should be calculated based on the difference between the gross income and cost of goods sold.

#Subquery to calculate the profit margin for each branch and product line

select branch, product_line,sum(cogs-gross_income)  as profit_margin 
from walmartsales group by branch,product_line order by profit_margin desc;

#Task 3: Analyzing Customer Segmentation Based on Spending (6 Marks)
#Walmart wants to segment customers based on their average spending behavior. 

#Classify customers into three tiers: High, Medium, and Low spenders based on their total purchase amounts.

#Select all columns from the Walmart sales data and classify customers 
#based on their spending High ,low and medium
 
select *,
case
when total >320 then "Highspender"
when total between 250 and 320 then "Mediumspender"
else "Lowspender"
end as spenders 
from walmartsales;

#Task 4: Detecting Anomalies in Sales Transactions (6 Marks)
#Walmart suspects that some transactions have unusually high or low sales compared to the average for the
#product line. Identify these anomalies.

#Identify anomalies in transactions based on comparison to 
#the average sales for each product line

select product_line, total,  avgtotal as score,
case
when total> avgtotal *1.2 then "High anomaly"
when total< avgtotal *0.8 then "low anomaly"
else "No"
end as anomaly
from  (select product_line, total, avg(total) over(partition by Product_line) as avgtotal
 from walmartsales )as anomalydetection
 order by Product_line,total;


#Task 5: Most Popular Payment Method by City (6 Marks)
#Walmart needs to determine the most popular payment method in each city to tailor marketing strategies
 
 #Select the city and payment method along with the count of how many times each payment was used
select city,max(payment) as most_used_payment,count(Payment) as payment_used_count from walmartsales
group by city,payment
order by payment_used_count desc;


#Task 6: Monthly Sales Distribution by Gender (6 Marks)
#Walmart wants to understand the sales distribution between male and female customers on a monthly basis.

#Total sales for each gender on each date

select Gender,salesdate, sum(total) as gender_based_sales from walmartsales
group by gender,salesdate
order by gender_based_sales desc;
# Count of customers for each gender on each date
select Gender,salesDate,count(Customer_ID)  as gender_count from walmartsales
group by Gender,salesDate;

#Task 7: Best Product Line by Customer Type (6 Marks)
#Walmart wants to know which product lines are preferred by different customer types(Member vs. Normal).

#product lines are preferred by different customer types(Member vs. Normal).
select product_line,customer_type,count(*) as num_customer from walmartsales
group by Product_line,Customer_type
order by num_customer desc;

#Task 8: Identifying Repeat Customers (6 Marks)
#Walmart needs to identify customers who made repeat purchases within a specific time frame (e.g., within 30
#days).

#to identify customers who made repeat purchases within a specific time frame
select customer_id,salesdate,count(*) as repeated_customer from walmartsales 
where salesDate between '01-01-2019'and'02-12-2019'
group by customer_id,salesdate
having count(*)>1
order by repeated_customer desc;

#Task 9: Finding Top 5 Customers by Sales Volume (6 Marks)
#Walmart wants to reward its top 5 customers who have generated the most sales Revenue.

#to reward its top 5 customers who have generated the most sales Revenue.

select Customer_ID,sum(total) as revenue  from walmartsales
group by Customer_ID
order by revenue desc
limit 5;

#Task 10: Analyzing Sales Trends by Day of the Week (6 Marks)
#Walmart wants to analyze the sales patterns to determine which day of the week
#brings the highest sales

select salesDate,sum(total) as sales from walmartsales
group by salesDate 
order by sales desc;

 select extract(day from salesdate) as week_of_day,sum(total) as total_sales
 from walmartsales group by week_of_day;
select *from walmartsales