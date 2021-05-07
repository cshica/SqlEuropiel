DROP TABLE IF EXISTS dbo.Paso2;
GO

DROP TABLE IF EXISTS dbo.Paso2;
GO
CREATE TABLE dbo.Paso2 (
	AccountSid char(34) NULL,
	ApiVersion char(10) NULL,
	Body varchar(1600) NULL,
	DateCreated datetime NULL,
	DateSent datetime NULL,
	DateUpdated datetime NULL,
	Direction varchar(32) NULL,
	ErrorCode int NULL,
	ErrorMessage varchar(64) NULL,
	From_ varchar(32) NULL,
	MessagingServiceSid varchar(64) NULL,
	NumMedia bit NULL,
	NumSegments tinyint NULL,
	Price money NULL,
	PriceUnit char(3) NULL,
	Sid_ char(34) NULL,
	Status_ varchar(16) NULL,
	SubresourceUris char(68) NULL,
	To_ varchar(32) NULL,
	Uri char(104) NULL,
	id int not null IDENTITY
);
GO



SELECT COUNT(*) FROM dbo.Paso2 (NOLOCK);
TRUNCATE TABLE dbo.Paso2;
SELECT COUNT(*) FROM dbo.Paso2 (NOLOCK);

INSERT INTO dbo.Paso2 (
    AccountSid, ApiVersion, Body, DateCreated, DateSent, DateUpdated, Direction, ErrorCode, ErrorMessage, From_, MessagingServiceSid, NumMedia, NumSegments, Price, PriceUnit, Sid_, Status_, SubresourceUris, To_, Uri
)
SELECT
    AccountSid, ApiVersion, Body, cast(left(DateCreated,19) as datetime) DateCreated, cast(left(DateSent,19) as datetime) DateSent, cast(left(DateUpdated,19) as datetime) DateUpdated, Direction, ErrorCode, ErrorMessage, From_, MessagingServiceSid, NumMedia, NumSegments, Price, PriceUnit, Sid_, Status_, SubresourceUris, To_, Uri
FROM
    dbo.Paso1
;
SELECT * FROM dbo.Paso2 (NOLOCK);

