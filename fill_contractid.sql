WITH maintable AS (
	SELECT
		e.contractid
	FROM
		enquiries e
		JOIN phones p ON e.contractid = p.contractid
		AND e.regdate >= CURRENT_DATE - INTERVAL '30 days'
		AND p.status <> 'notactual'
	GROUP BY
		e.contractid,
) 

INSERT INTO uniquesubscribers (contractid)
SELECT
	contractid
FROM
	maintable;