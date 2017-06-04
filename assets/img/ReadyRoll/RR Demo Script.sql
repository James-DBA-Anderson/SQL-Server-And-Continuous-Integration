CREATE TABLE Customers 
(
	CustomerID INT IDENTITY(1,1) NOT NULL,
	Title NVARCHAR(25) NOT NULL,
	FirstName NVARCHAR(100) NOT NULL,
	LastName NVARCHAR(100) NOT NULL,
	DOB DATE NOT NULL,
	CONSTRAINT [PK_CustomerID] PRIMARY KEY CLUSTERED  
	(
		[CustomerID] ASC
	) WITH (PAD_INDEX = ON) ON [PRIMARY]
) ON [PRIMARY];
GO

CREATE TABLE Config
(
	Setting			NVARCHAR(250) NOT NULL,
	[Description]	NVARCHAR(1000) NOT NULL,
	[Value]			NVARCHAR(100) NULL,
	CONSTRAINT PK_Config_Setting PRIMARY KEY (Setting)
);
GO

CREATE PROCEDURE ConfigSettings 
AS
BEGIN
	SELECT	Setting,
			[Value]
	FROM	dbo.Config;
END
GO

---------------------------------------------------
-- Second round of changes
---------------------------------------------------

ALTER TABLE Config ALTER COLUMN [Value] NVARCHAR(MAX);
GO

ALTER PROCEDURE ConfigSettings 
				@Setting NVARCHAR(250) = N'All'
AS
BEGIN
	SELECT	c.Setting,
			c.[Value]
	FROM	dbo.Config c
	WHERE	(
				(@Setting = N'All')
				OR
				(@Setting = c.Value)
			);
END
GO

---------------------------------------------------
-- Final round of changes
---------------------------------------------------

INSERT dbo.Config(Setting, Description, Value)
VALUES	('Active', 'Is the appllication active', 'Y'),
		('Client', 'The name of the client for this instance', 'The SQL People Ltd'),
		('Client Email', 'Email address to send reports to', 'James@TheSQLPeople.com'); 
GO