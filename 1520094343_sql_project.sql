
/* Q1: Some of the facilities charge a fee to members, but some do not.
Please list the names of the facilities that do. */

SELECT * 
FROM `Facilities` 
WHERE `membercost` > 0;


/* Q2: How many facilities do not charge a fee to members? */
SELECT count(*) 
FROM `Facilities` 
WHERE `membercost` = 0

/* Q3: How can you produce a list of facilities that charge a fee to members,
where the fee is less than 20% of the facility's monthly maintenance cost?
Return the facid, facility name, member cost, and monthly maintenance of the
facilities in question. */
SELECT facid, name, membercost, monthlymaintenance 
FROM `Facilities` 
WHERE `membercost` > 0 AND `membercost` < (`monthlymaintenance` * 0.2)

/* Q4: How can you retrieve the details of facilities with ID 1 and 5?
Write the query without using the OR operator. */
SELECT * 
FROM Facilities
WHERE facid IN (1, 5)



/* Q5: How can you produce a list of facilities, with each labelled as
'cheap' or 'expensive', depending on if their monthly maintenance cost is
more than $100? Return the name and monthly maintenance of the facilities
in question. */
SELECT name, monthlymaintenance 
, IF(monthlymaintenance >100 , 'expensive', 'cheap') AS lebel
FROM `Facilities` WHERE 1;

/* Q6: You'd like to get the first and last name of the last member(s)
who signed up. Do not use the LIMIT clause for your solution. */
SELECT firstname, surname
FROM Members
WHERE joindate = (
SELECT MAX(joindate) 
FROM Members)

/* Q7: How can you produce a list of all members who have used a tennis court?
Include in your output the name of the court, and the name of the member
formatted as a single column. Ensure no duplicate data, and order by
the member name. */
SELECT t2.name AS court, CONCAT(t3.firstname, ' ', t3.surname) AS name
FROM Bookings AS t1
INNER JOIN Facilities AS t2 ON t2.facid = t1.facid AND INSTR(t2.name, 'Tennis Court') > 0
INNER JOIN Members AS t3 ON t3.memid = t1.memid
WHERE 1 GROUP BY t3.memid, t2.name
ORDER BY name


/* Q8: How can you produce a list of bookings on the day of 2012-09-14 which
will cost the member (or guest) more than $30? Remember that guests have
different costs to members (the listed costs are per half-hour 'slot'), and
the guest user's ID is always 0. Include in your output the name of the
facility, the name of the member formatted as a single column, and the cost.
Order by descending cost, and do not use any subqueries. */

SELECT t2.name AS facility, CONCAT(t3.firstname, ' ', t3.surname) AS member
, IF(t1.memid > 0, t2.membercost * t1.slots,t2.guestcost * t1.slots) AS cost
FROM `Bookings` AS t1
INNER JOIN Facilities AS t2 ON t2.facid = t1.facid
INNER JOIN Members AS t3 ON t3.memid = t1.memid
WHERE DATE(`starttime`) = '2012-09-14'
HAVING cost > 30
ORDER BY cost DESC


/* Q9: This time, produce the same result as in Q8, but using a subquery. */
SELECT * FROM 
(SELECT t2.name AS facility, CONCAT(t3.firstname, ' ', t3.surname) AS member
, IF(t1.memid > 0, t2.membercost * t1.slots,t2.guestcost * t1.slots) AS cost
FROM `Bookings` AS t1
INNER JOIN Facilities AS t2 ON t2.facid = t1.facid
INNER JOIN Members AS t3 ON t3.memid = t1.memid
WHERE DATE(`starttime`) = '2012-09-14'
) AS sub
WHERE sub.cost > 30
ORDER BY sub.cost DESC

/* Q10: Produce a list of facilities with a total revenue less than 1000.
The output of facility name and total revenue, sorted by revenue. Remember
that there's a different cost for guests and members! */
SELECT t2.name AS facility
, SUM(IF(t1.memid > 0, t2.membercost * t1.slots,t2.guestcost * t1.slots)) AS revenue
FROM `Bookings` AS t1
INNER JOIN Facilities AS t2 ON t2.facid = t1.facid
WHERE 1
GROUP BY t2.facid
HAVING revenue < 1000
ORDER BY revenue
