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
GO

CREATE TABLE Months
(
	MonthId INT PRIMARY KEY,
	Name NVARCHAR(50) UNIQUE NOT NULL
);
GO

CREATE VIEW VSalaryPaymentDetail 
AS
		SELECT 
				sp.SalaryPaymentId,
				e.EmployeeId, 
				CONCAT(e.FirstName, ' ', e.LastName) EmployeeName, 
				sp.Date,
				sp.BaseSalary,
				dbo.fnGetBenefitSalary(sp.SalaryPaymentId) Benefit,
				dbo.fnGetDeductionSalary(sp.SalaryPaymentId) Deduction,
				(sp.BaseSalary + dbo.fnGetBenefitSalary(sp.SalaryPaymentId) - dbo.fnGetDeductionSalary(sp.SalaryPaymentId)) Salary,
				sp.Month, 
				sp.Year, 
				ps.Name AS Status, 
				sp.PaymentDate
		FROM SalaryPayments sp JOIN Employees e
		ON sp.EmployeeId = e.EmployeeId
		JOIN PaymentStates ps
		ON sp.PaymentStateId = ps.PaymentStateId;
GO

SELECT * FROM VSalaryPaymentDetail; 
GO

-- create function
CREATE FUNCTION fnGetBenefitSalary (@SalaryPaymentId INT)
RETURNS DECIMAL AS 
BEGIN 
        DECLARE @total DECIMAL; 
		SELECT @total = SUM(spg.Amount)
		FROM SalaryPaymentGross spg JOIN GrossSalaries gs
		ON spg.GrossSalaryId = gs.GrossSalaryId
		WHERE gs.GrossTypeId = 1 AND spg.SalaryPaymentId = @SalaryPaymentId; 

		IF @total IS NULL RETURN 0;
		RETURN @total;
END
GO

SELECT dbo.fnGetBenefitSalary(1000);
GO

CREATE FUNCTION fnGetDeductionSalary (@SalaryPaymentId INT)
RETURNS DECIMAL AS 
BEGIN 
        DECLARE @total DECIMAL; 
		SELECT @total = SUM(spg.Amount)
		FROM SalaryPaymentGross spg JOIN GrossSalaries gs
		ON spg.GrossSalaryId = gs.GrossSalaryId
		WHERE gs.GrossTypeId = 2 AND spg.SalaryPaymentId = @SalaryPaymentId; 

		IF @total IS NULL RETURN 0;
		RETURN @total;
END
GO

SELECT dbo.fnGetDeductionSalary(1000); 
GO