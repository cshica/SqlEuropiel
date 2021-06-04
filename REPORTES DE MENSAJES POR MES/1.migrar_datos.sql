
DROP TABLE IF EXISTS dbo.Paso2_Mayo;
GO
CREATE TABLE dbo.Paso2_Mayo (
	AccountSid char(34) NULL,
	ApiVersion char(10) NULL,
	Body nvarchar(max) NULL,
	DateCreated datetime NULL,
	DateSent datetime NULL,
	DateUpdated datetime NULL,
	Direction varchar(32) NULL,
	ErrorCode int NULL,
	ErrorMessage varchar(64) NULL,
	From_ varchar(50) NULL,
	MessagingServiceSid varchar(64) NULL,
	NumMedia bit NULL,
	NumSegments tinyint NULL,
	Price money NULL,
	PriceUnit char(3) NULL,
	Sid_ char(34) NULL,
	Status_ varchar(16) NULL,
	SubresourceUris char(68) NULL,
	To_ nvarchar(50) NULL,
	Uri char(104) NULL,
	id int not null IDENTITY
);
GO



SELECT COUNT(*) FROM dbo.Paso2 (NOLOCK);
TRUNCATE TABLE dbo.Paso2;
SELECT COUNT(*) FROM dbo.Paso2 (NOLOCK);

INSERT INTO dbo.Paso2_Mayo (
    AccountSid, ApiVersion, Body, DateCreated, DateSent, DateUpdated, Direction, ErrorCode, ErrorMessage, From_, MessagingServiceSid, NumMedia, NumSegments, Price, PriceUnit, Sid_, Status_, SubresourceUris, To_, Uri
)
SELECT
    AccountSid, ApiVersion, Body, 
	convert(datetime,left(replace(DateCreated,'/','-'),19),103) DateCreated
	, convert(datetime,left(replace(DateSent,'/','-'),19) ,103) DateSent
	, convert(datetime,left(replace(DateUpdated,'/','-'),19),103) DateUpdated, Direction, ErrorCode, ErrorMessage, From_, MessagingServiceSid, NumMedia, NumSegments, Price, PriceUnit, Sid_, Status_, SubresourceUris, To_, Uri
FROM
    dbo.Paso1
;
SELECT * FROM dbo.Paso2_Mayo	 (NOLOCK);

