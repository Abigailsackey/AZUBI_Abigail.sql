QUESTION 1.

SELECT COUNT(u_id) FROM users;

QUESTION 2.

SELECT COUNT(*) FROM users WHERE 'send_amount_currency' ='cfa';

QUESTION 3.

SELECT COUNT (DISTINCT (u_id)) FROM view.transfers WHERE send_amount_currency='cfa ';

QUESTION 4.

SELECT COUNT(atx_id)
   FROM agent_transactions
   WHERE when_created BETWEEN '2018-01-31’ AND '2018-12-31' ;

QUESTION 5
	 WITH  mywithdrawers AS
	(SELECT COUNT(agent_id) netwithdrawers FROM agent_transactions HAVING COUNT(amount) IN
	(SELECT COUNT(amount) FROM agent_transactions WHERE amount >-1 AND amount!=0 HAVING
	COUNT(amount)>  (SELECT COUNT(amount) FROM agent_transactions WHERE amount <1 AND amount!=0)))
	SELECT netwithdrawers FROM mywithdrawers;
	WITH mydepositors AS
	(SELECT COUNT(agent_id) netdepositors FROM agent_transactions HAVING COUNT(amount) IN
	(SELECT COUNT(amount) FROM agent_transactions WHERE amount <1 AND amount!=0 HAVING COUNT(amount)>
	(SELECT COUNT(amount) FROM agent_transactions WHERE amount >-1 AND amount!=0)))
	SELECT netdepositors FROM mydepositors;

QUESTION 6.

SELECT City, Volume INTO atx_volume_city_summary FROM 
   (SELECT agents.city AS City, count(agent_transactions.atx_id) AS Volume FROM agents 
   INNER JOIN agent_transactions 
   ON agents.agent_id = agent_transactions.agent_id 
   WHERE (agent_transactions.when_created > (NOW() - INTERVAL '1 week')) 
  GROUP BY agents.city) as atx_volume_summary;
 
  SELECT * FROM atx_volume_city_summary;


QUESTION 7.
SELECT COUNT(agent_transactions.atx_id) AS "atx volume city summary",
	agents.city, agents.country FROM agent_transactions
	LEFT JOIN agents ON agent_transactions.agent_id=agents.agent_id
	WHERE
	agent_transactions.when_created >=NOW()-INTERVAL'1 week'
	GROUP BY agents.city,agents.country;

	QUESTION 8.

SELECT transfers.kind AS kind, wallets.ledger_location AS country,
	SUM(transfers.send_amount_scalar) AS volume FROM transfers
	INNER JOIN wallets ON transfers.source_wallet_id=wallets.wallet_id
	WHERE (transfers.when_created>(NOW()-INTERVAL '1 week'))
	GROUP BY wallets.ledger_location, transfers.kind;
QUESTION 9.

SELECT COUNT(transfers.source_wallet_id)
	AS Unique_Senders, COUNT (transfer_id) AS Transaction_Count, transfers.kind
	AS Transfer_Kind, wallets.ledger_location AS Country,
	SUM (transfers.send_amount_scalar) AS Volume FROM transfers
	INNER JOIN wallets ON transfers.source_wallet_id = wallets.wallet_id
	WHERE (transfers.when_created > (NOW() - INTERVAL '1 week'))
	GROUP BY wallets.ledger_location, transfers.kind;

QUESTION 10.

SELECT source_wallet_id, send_amount_scalar FROM
	transfers WHERE send_amount_currency = 'CFA' AND (send_amount_scalar>10000000) AND
	(transfers.when_created > (NOW() - INTERVAL '1 month'));
