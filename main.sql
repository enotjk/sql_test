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
),
lasttypename AS (
	SELECT
		inqtypename AS lastquerytype,
		contractid
	FROM
		enquiries
	WHERE
		regdate IN (
			SELECT
				MAX(regdate) AS lastregistrationdate
			FROM
				enquiries
			GROUP BY
				contractid
		)
),
diffdate AS (
	SELECT
		e.contractid,
		DATEDIFF(DAY, MAX(e.regdate) - MIN(e.regdate)) AS diffdate
	FROM
		enquiries e
		JOIN phones p ON e.contractid = p.contractid
		AND e.regdate >= CURRENT_DATE - INTERVAL '30 days'
		AND p.status <> 'notactual'
	GROUP BY
		e.contractid
),
totalrev AS (
	SELECT
		contractid,
		SUM(rev) AS totalrevenue
	FROM
		revenue
	WHERE
		CONVERT(DATE, CAST(period AS INT), 112) >= DATEADD(DAY, -30, GETDATE())
	GROUP BY
		contractid
)
UPDATE
	uniquesubscribers us
SET
	totalqueries = m.totalqueries,
	primaryphone = m.primaryphone,
	lastregistrationdate = m.lastregistrationdate,
	lastquerytype = lt.lastquerytype,
	diffdate = df.diffdate,
	totalrevenue = tr.totalrevenue
FROM
	maintable m
	JOIN lasttypename lt ON m.contractid = lt.contractid
	JOIN diffdate df ON m.contractid = df.contractid
	LEFT JOIN totalrev tr ON m.contractid = tr.contractid
WHERE
	us.contractid = m.contractid