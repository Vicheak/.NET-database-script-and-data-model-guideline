CREATE VIEW VSalaryBenefit
AS 
	SELECT * FROM GrossSalaries 
	WHERE GrossTypeId = 1
GO

CREATE VIEW VSalaryDeduction
AS 
	SELECT * FROM GrossSalaries 
	WHERE GrossTypeId = 2
GO

SELECT * FROM VSalaryBenefit; 
SELECT * FROM VSalaryDeduction; 