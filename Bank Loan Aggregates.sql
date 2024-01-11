--Report 1: Report of all borrowers who have taken a loan with the bank
SELECT 
BORROWER.[BorrowerID],
CONCAT_WS(' ', BORROWER.[BorrowerFirstName], BORROWER.[BorrowerMiddleInitial], BORROWER.[BorrowerLastName]) AS 'BORROWER FULL NAME',
concat('*****', RIGHT(BORROWER.TaxPayerID_SSN,4)) AS 'SSN',
DATEPART(YEAR, BORROWER.CreateDate) AS 'YEAR OF PURCHASE',
[PURCHASE AMOUNT IN THOUSANDS] = FORMAT(LOAN.PurchaseAmount / 1000, 'CO') + 'K'
FROM DBO.Borrower AS BORROWER
INNER JOIN DBO.LoanSetupInformation AS LOAN 
ON BORROWER.BorrowerID = LOAN.BorrowerID

--Report 1B: Generate a list that also includes those without loans
SELECT 
BORROWER.[BorrowerID],
CONCAT_WS(' ', [BorrowerFirstName],[BorrowerMiddleInitial], [BorrowerLastName]) AS 'BORROWER FULL NAME',
RIGHT(BORROWER.TaxPayerID_SSN,4) AS 'SSN',
DATEPART(YEAR, BORROWER.CreateDate) AS 'YEAR OF PURCHASE',
[PURCHASE AMOUNT IN THOUSANDS] = FORMAT(LOAN.PurchaseAmount / 1000, 'CO') + 'K'
FROM DBO.Borrower AS BORROWER
FULL OUTER JOIN DBO.LoanSetupInformation AS LOAN 
ON BORROWER.BorrowerID = LOAN.BorrowerID
------------------------------------------------------------------------------------------------------

-- Report 2: Aggregate the borrowers by country
SELECT 
BORROWER.Citizenship, 
SUM(loan.PurchaseAmount) AS 'TOTAL PURCHASE AMOUNT',
AVG(loan.PurchaseAmount) AS 'AVG PURCHASE AMOUNT',
COUNT(BORROWER.BorrowerID) AS 'No. OF BORROWERS',
[AVG AGE OF BORROWER] = AVG(FLOOR(DATEDIFF(DAY, BORROWER.DoB, GETDATE()))/ 365),
AVG(LOAN.LTV) AS 'AVG LTV',
MIN(LOAN.LTV) AS 'MIN LTV',
MAX(LOAN.LTV) AS 'MAX LTV'
FROM DBO.Borrower AS BORROWER
INNER JOIN DBO.LoanSetupInformation AS LOAN
ON BORROWER.BorrowerID = LOAN.BorrowerID
GROUP BY Citizenship
ORDER BY [TOTAL PURCHASE AMOUNT] DESC;


--Report 2B: Aggregate the borrowers by gender
SELECT 
CASE BORROWER.Gender 
                    WHEN 'F' THEN 'F'
                    WHEN 'M' THEN 'M'
                    WHEN ' ' THEN 'X'
                    ELSE 'X'
END AS 'GENDER',
SUM(loan.PurchaseAmount) AS 'TOTAL PURCHASE AMOUNT',
AVG(loan.PurchaseAmount) AS 'AVG PURCHASE AMOUNT',
COUNT(BORROWER.BorrowerID) AS 'No. OF BORROWERS',
[AVG AGE OF BORROWER] = AVG(FLOOR(DATEDIFF(DAY, BORROWER.DoB, GETDATE()))/ 365),
[AVG LTV] = FORMAT(AVG(loan.LTV), 'p'),
[MIN LTV] = FORMAT(MIN(loan.LTV), 'p'),
[MAX LTV] = FORMAT(MAX(loan.LTV), 'p')
FROM DBO.Borrower AS BORROWER
INNER JOIN DBO.LoanSetupInformation AS LOAN
ON BORROWER.BorrowerID = LOAN.BorrowerID
GROUP BY Gender
ORDER BY [TOTAL PURCHASE AMOUNT] DESC;

--Report 2C:
SELECT 
CASE BORROWER.Gender 
                    WHEN 'F' THEN 'F'
                    WHEN 'M' THEN 'M'
                    ELSE 'X'
END AS 'GENDER',
SUM(loan.PurchaseAmount) AS 'TOTAL PURCHASE AMOUNT',
AVG(loan.PurchaseAmount) AS 'AVG PURCHASE AMOUNT',
COUNT(BORROWER.BorrowerID) AS 'No. OF BORROWERS',
[AVG AGE OF BORROWER] = AVG(FLOOR(DATEDIFF(DAY, BORROWER.DoB, GETDATE()))/ 365),
[AVG LTV] = FORMAT(AVG(loan.LTV), 'p'),
[MIN LTV] = FORMAT(MIN(loan.LTV), 'p'),
[MAX LTV] = FORMAT(MAX(loan.LTV), 'p')
FROM DBO.Borrower AS BORROWER
INNER JOIN DBO.LoanSetupInformation AS LOAN
ON BORROWER.BorrowerID = LOAN.BorrowerID
GROUP BY Gender, DATEPART(YEAR, PurchaseDate) 
ORDER BY DATEPART(YEAR, PurchaseDate), Gender DESC;
----------------------------------------------------------------------------------------------------------

--Report 3C: Calculate maturity of each loan

--FOORMAT TO MONEY 'CO' 
--FORMAT TO PERCENT 'P'
