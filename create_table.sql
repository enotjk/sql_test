CREATE TABLE uniquesubscribers (
	contractid INT PRIMARY KEY,
	totalqueries INT,
	lastregistrationdate TIMESTAMP,
	lastquerytype VARCHAR(50),
	diffdate INT,
	primaryphone VARCHAR(20),
	totalrevenue FLOAT
)