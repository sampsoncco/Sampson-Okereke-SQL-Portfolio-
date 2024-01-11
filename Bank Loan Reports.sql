-- Report 1A




SELECT a.[BorrowerID], 
       [Borrower full name] = CONCAT_WS(' ', a.[BorrowerFirstName], a.[BorrowerMiddleInitial], a.[BorrowerLastName]), 
       [SSN] = concat('*****', RIGHT(a.[TaxPayerID_SSN], 4)), 
       Year_of_purchase = YEAR(b.[PurchaseDate]), 
       [purchase amount in thousand] = format(b.[PurchaseAmount] / 1000, 'C0') + 'k'
FROM [dbo].[Borrower] AS a
     INNER JOIN [dbo].[LoanSetupInformation] AS b ON a.BorrowerID = b.BorrowerID;
	
	--order by [PurchaseAmount] asc
	 --order by [PurchaseAmount] desc


	
	 

-- Report 1B

SELECT a.[BorrowerID], 
       [Borrower full name] = CONCAT_WS(' ', a.[BorrowerFirstName], a.[BorrowerMiddleInitial], a.[BorrowerLastName]), 
       [SSN] = concat('*****', RIGHT(a.[TaxPayerID_SSN], 4)), 
       Year_of_purchase = YEAR(b.[PurchaseDate]), 
       [purchase amount in thousand] = format(b.[PurchaseAmount] / 1000, 'C0') + 'k'
FROM [dbo].[Borrower] AS a
 full outer join [dbo].[LoanSetupInformation] AS b ON a.BorrowerID = b.BorrowerID
	--order by [PurchaseAmount] desc
	--order by [PurchaseAmount] asc



	--report 2A

SELECT A.[Citizenship], 
       [Total Purchase Amount] = format(SUM(B.[PurchaseAmount]), 'C0'), 
       [Average Purchase Amount] = format(AVG(B.[PurchaseAmount]), 'C0'), 
       [No. OF Borrower] = COUNT(A.[BorrowerID]), 
       [AVG AGE OF BORROWER] = AVG(DATEDIFF(year, [DoB], GETDATE())), 
       [AVG LTV] = format(AVG(B.[LTV]), 'P'), 
       [MIN LTV] = format(MIN(B.[LTV]), 'P'), 
       [MAX LTV] = format(MAX(B.[LTV]), 'p')
FROM [dbo].[Borrower] AS A
     INNER JOIN [dbo].[LoanSetupInformation] AS B ON A.BorrowerID = B.BorrowerID
GROUP BY [Citizenship]
ORDER BY [Total Purchase Amount] desc;
--ORDER BY   [No. OF Borrower] asc



 
 
 ---report 2B

 WITH cte_loan
     AS (SELECT CASE [Gender]
                    WHEN 'f'
                    THEN 'F'
                    WHEN 'm'
                    THEN 'M'
                    ELSE 'X'
                END AS new_gender, 
                [Gender], 
                [BorrowerID], 
                [DoB]
         FROM [dbo].[Borrower])
     SELECT new_gender, 
            [Total Purchase Amount] = format(SUM(B.[PurchaseAmount]), 'C0'), 
            [Average Purchase Amount] = format(AVG(B.[PurchaseAmount]), 'C0'), 
            [No. OF Borrower] = COUNT(A.[BorrowerID]), 
            [AVG AGE OF BORROWER] = AVG(DATEDIFF(year, [DoB], GETDATE())), 
            [AVG LTV] = format(AVG(B.[LTV]), 'p'), 
            [MIN LTV] = format(MIN(B.[LTV]), 'P'), 
            [MAX LTV] = format(MAX(B.[LTV]), 'p')
     FROM cte_loan AS a
          INNER JOIN [dbo].[LoanSetupInformation] AS B ON A.BorrowerID = B.BorrowerID
     GROUP BY new_gender
	 order by  [Total Purchase Amount] desc;



	 --report 2c part 1

SELECT [Citizenship],CASE [Gender]
           WHEN 'f'
           THEN 'F'
           WHEN 'm'
           THEN 'M'
           END AS gender, 
       [year of purchase] = YEAR([PurchaseDate]), 
       [Total Purchase Amount] = format(SUM(B.[PurchaseAmount]), 'C0'), 
       [Average Purchase Amount] = format(AVG(B.[PurchaseAmount]), 'C0'), 
       [No. OF Borrower] = COUNT(A.[BorrowerID]), 
       [AVG AGE OF BORROWER] = AVG(DATEDIFF(year, [DoB], GETDATE())), 
       [AVG LTV] = format(AVG(B.[LTV]), 'p'), 
       [MIN LTV] = format(MIN(B.[LTV]), 'P'), 
       [MAX LTV] = format(MAX(B.[LTV]), 'p')
FROM [dbo].[Borrower] AS A
     INNER JOIN [dbo].[LoanSetupInformation] AS B ON A.BorrowerID = B.BorrowerID
WHERE gender = 'F'
      OR gender = 'M'
GROUP BY[Citizenship] ,gender, 
         YEAR([PurchaseDate])
ORDER BY[Citizenship], gender, 
         YEAR([PurchaseDate]) DESC;

  

 -- report 2c part 2
  
  select [Citizenship], gender, 
       [year of purchase] = YEAR([PurchaseDate]), 
       [Total Purchase Amount] = format(SUM(B.[PurchaseAmount]), 'C0'), 
       [Average Purchase Amount] = format(AVG(B.[PurchaseAmount]), 'C0'), 
       [No. OF Borrower] = COUNT(A.[BorrowerID]), 
       [AVG AGE OF BORROWER] = AVG(DATEDIFF(year, [DoB], GETDATE())), 
       [AVG LTV] = format(AVG(B.[LTV]), 'p'), 
       [MIN LTV] = format(MIN(B.[LTV]), 'P'), 
       [MAX LTV] = format(MAX(B.[LTV]), 'p')
FROM [dbo].[Borrower] AS A
     INNER JOIN [dbo].[LoanSetupInformation] AS B ON A.BorrowerID = B.BorrowerID
WHERE gender = 'F'
      OR gender = 'M'
GROUP BY [Citizenship],gender, 
         YEAR([PurchaseDate])
ORDER BY [Citizenship],gender, 
         YEAR([PurchaseDate]) DESC;



--report 3

WITH CTE
     AS (SELECT [LoanNumber] AS LOAN_NUM,
                CASE
                    WHEN YEAR(MaturityDate) - YEAR(GETDATE()) <= 5
                    THEN '00-5 years'
                    WHEN YEAR(MaturityDate) - YEAR(GETDATE()) <= 10
                    THEN '06-10 years'
                    WHEN YEAR(MaturityDate) - YEAR(GETDATE()) <= 15
                    THEN '11-15 years'
                    WHEN YEAR(MaturityDate) - YEAR(GETDATE()) <= 20
                    THEN '16-20 years'
                    WHEN YEAR(MaturityDate) - YEAR(GETDATE()) <= 25
                    THEN '21-25 years'
                    WHEN YEAR(MaturityDate) - YEAR(GETDATE()) <= 30
                    THEN '26-30 years'
                    WHEN YEAR(MaturityDate) - YEAR(GETDATE()) > 30
                    THEN '>30 years'
                END AS [Year Left to Maturity]
         FROM [LoanSetupInformation]
         WHERE maturitydate > GETDATE())
     SELECT [Year Left to Maturity], 
            COUNT(LOAN_NUM) AS Number_Of_Loans, 
            [Total Purchase Amount] = FORMAT(SUM(PurchaseAmount / 1000000000), 'c4', 'en-us') + 'B'
     FROM CTE
          INNER JOIN [dbo].[LoanSetupInformation] B ON CTE.LOAN_NUM = B.[LoanNumber]
     GROUP BY CTE.[Year Left to Maturity]
	 order by 1




--	report 4

	 select [Year of Purchase]=datepart(year,[PurchaseDate]),
	 [PaymentFrequency_Description],
	 [No. of loan]=count([LoanNumber])
	 from [dbo].[LoanSetupInformation] as a
	 inner join [dbo].[LU_PaymentFrequency] as  b
	 on a.[PaymentFrequency] = b.[PaymentFrequency]
	 group by [PaymentFrequency_Description],datepart(year,[PurchaseDate])
	 order by datepart(year,[PurchaseDate]) desc;















---report 1 insight
---out of 20000 borrower we only have 4881 customers.
--- wethin 4881 customers, we have customers with multiple loans.
---  Jennie  Garrison obtain  the highest  loan  and that was  2005
---julia T hart obtain the lowest loan in 2004

--report 1b  insight
-- Roberta u clarke has the highest purchase amount in 2016
--out of  20700 customers  we have 700 customers with null value which implies that they dont  have a  loan or made a purchase
--
 


 --report 2 A insight 
 --Vietnam and Niger were the countries with the highest number of  borrowers
 --while Mozambique had  the lowest number of  borrowers.
 --Kiribati had the highest total purchase amount 
 --while united state had the lowest total purchase amount.



 --report 2B insight 
 --
































 
--report 3

--WITH Cte_A
--     AS (SELECT count([LoanNumber]) as [no. of loan], 
--              sum([PurchaseAmount]) as [total  purchase amount] , 
--                DATEDIFF(year,[MaturityDate],getdate())as [Year to maturity] 
               
--         FROM [dbo].[LoanSetupInformation]
--		 group by  DATEDIFF(year,[MaturityDate],getdate())),
--   Cte_B as   
--     ( SELECT [no. of loan] , 
--                [total  purchase amount] , 
--				case when [Year to maturity] <= 5 then '0-5'
--                      when [Year to maturity] > 5 and [Year to maturity] <= 10 then '6-10'
--					  when [Year to maturity] > 10 and [Year to maturity] <= 15 then '11-15'
--					  when [Year to maturity] >15 and [Year to maturity] <= 20 then '16-20'
--					  when [Year to maturity] >20 and [Year to maturity] <= 25 then '21-25'
--					  when  [Year to maturity] >25 and [Year to maturity] <= 30  then '26-30'
--					  when [Year to maturity] >30 then '>30'
--					  else 'invalid' end as  bins
                
--         FROM Cte_A)
--		 select sum([no. of loan]) as [Num. of loan], format(sum( [total  purchase amount]), 'C0')+ 'B',bins
--		 from Cte_B
--         group by bins
		 
     
	 
--	 SELECT  DATEDIFF(year,[MaturityDate],getdate())as [Year to maturity] from [dbo].[LoanSetupInformation]
--	 order by  DATEDIFF(year,[MaturityDate],getdate()) desc;







---report 2B


--SELECT CASE [Gender]
--       WHEN 'f'THEN 'F'
--       WHEN 'm'THEN 'M'
--       ELSE 'X' 
--       END AS gender, 
--       [Total Purchase Amount] = format(SUM(B.[PurchaseAmount]), 'C0'), 
--       [Average Purchase Amount] = format(AVG(B.[PurchaseAmount]), 'C0'), 
--       [No. OF Borrower] = COUNT(A.[BorrowerID]), 
--       [AVG AGE OF BORROWER] = AVG(DATEDIFF(year, [DoB], GETDATE())), 
--       [AVG LTV] = format(AVG(B.[LTV]), 'p'), 
--       [MIN LTV] = format(MIN(B.[LTV]), 'P'), 
--       [MAX LTV] = format(MAX(B.[LTV]), 'p')
--FROM [dbo].[Borrower] AS A
--     INNER JOIN [dbo].[LoanSetupInformation] AS B ON A.BorrowerID = B.BorrowerID
--GROUP BY gender
--ORDER BY [Total Purchase Amount] DESC;

       


--select new_gender,count(a.[BorrowerID]),
-- [Total Purchase Amount] = format(SUM(B.[PurchaseAmount]), 'C0'), 
--       [Average Purchase Amount] = format(AVG(B.[PurchaseAmount]), 'C0'), 
--       [No. OF Borrower] = COUNT(A.[BorrowerID]), 
--       [AVG AGE OF BORROWER] = AVG(DATEDIFF(year, [DoB], GETDATE())), 
--       [AVG LTV] = format(AVG(B.[LTV]), 'p'), 
--       [MIN LTV] = format(MIN(B.[LTV]), 'P'), 
--       [MAX LTV] = format(MAX(B.[LTV]), 'p')

--from(

--	   SELECT CASE [Gender]
--       WHEN 'f'THEN 'F'
--       WHEN 'm'THEN 'M'
--       ELSE 'X' 
--       END AS new_gender, [Gender],
--       [BorrowerID],[DoB]
	   
--	   from [dbo].[Borrower]) a
	  
--     INNER JOIN [dbo].[LoanSetupInformation] AS B ON A.BorrowerID = B.BorrowerID
--	   group by new_gender
  