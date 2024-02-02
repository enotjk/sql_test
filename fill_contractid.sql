WITH maintable AS (
	SELECT
		e.contractid,
		p.phone AS primaryphone,
		COUNT(e.inquiryid) AS totalqueries,
		MAX(e.regdate) AS lastregistrationdate
	FROM
		enquiries e
		JOIN phones p ON e.contractid = p.contractid
		AND e.regdate >= CURRENT_DATE - INTERVAL '30 days'
		AND p.status <> 'notactual'
	GROUP BY
		e.contractid,
		p.phone,
		p.status
) 

INSERT INTO uniquesubscribers (contractid)
SELECT
	contractid
FROM
	maintable;