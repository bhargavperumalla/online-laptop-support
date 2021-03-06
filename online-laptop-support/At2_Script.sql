USE [Attendance2]
GO
/****** Object:  Schema [AT2]    Script Date: 5/28/2019 6:15:15 PM ******/
CREATE SCHEMA [AT2]
GO
/****** Object:  Schema [ATT]    Script Date: 5/28/2019 6:15:15 PM ******/
CREATE SCHEMA [ATT]
GO
/****** Object:  Schema [BILL]    Script Date: 5/28/2019 6:15:15 PM ******/
CREATE SCHEMA [BILL]
GO
/****** Object:  UserDefinedFunction [AT2].[GetDuration]    Script Date: 5/28/2019 6:15:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [AT2].[GetDuration]
(
@dtFromDateTime DATETIME =''
,@dtToDateTime DATETIME=''
)
RETURNS VARCHAR(50)
AS
BEGIN
	DECLARE @DurationMin INT=0
	SET @DurationMin=DATEDIFF(MINUTE,@dtFromDateTime,@dtToDateTime)
	RETURN ISNULL(RTRIM(@DurationMin/60) + ':' + RIGHT('0' + RTRIM(@DurationMin%60),2),'00:00')
END

GO
/****** Object:  UserDefinedFunction [dbo].[Split]    Script Date: 5/28/2019 6:15:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[Split]
(
	@RowData NVARCHAR(4000),
	@SplitOn NVARCHAR(5)
)  

RETURNS @RtnValue TABLE 
(
	Id INT IDENTITY(1,1),
	Data NVARCHAR(100)
)
AS  
BEGIN 
	DECLARE @Cnt INT
	SET @Cnt = 1

	WHILE (CHARINDEX(@SplitOn,@RowData)>0)
	BEGIN
		INSERT INTO @RtnValue (data)
		SELECT Data = LTRIM(RTRIM(SUBSTRING(@RowData,1,CHARINDEX(@SplitOn,@RowData)-1)))

		SET @RowData = SUBSTRING(@RowData,CHARINDEX(@SplitOn,@RowData)+1,LEN(@RowData))
		SET @Cnt = @Cnt + 1
	END
	
	INSERT INTO @RtnValue (Data)
	SELECT Data = LTRIM(RTRIM(@RowData))

	RETURN 
END

GO
/****** Object:  Table [AT2].[tblAccessCardData]    Script Date: 5/28/2019 6:15:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [AT2].[tblAccessCardData](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[CardId] [nvarchar](10) NULL,
	[Date] [smalldatetime] NULL,
	[InTime] [datetime] NULL,
	[OutTime] [datetime] NULL,
	[Name] [varchar](60) NULL,
 CONSTRAINT [PK_ATT.tblAccessCardData] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [AT2].[tblAttendance]    Script Date: 5/28/2019 6:15:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [AT2].[tblAttendance](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[Date] [smalldatetime] NOT NULL,
	[EmployeeID] [int] NOT NULL,
	[InTime] [time](5) NULL,
	[OutTime] [time](5) NULL,
	[Leave] [int] NULL,
	[LeaveType] [nchar](2) NULL,
	[PermissionHrs] [time](5) NULL,
	[ExtraHrsWorked] [time](5) NULL,
	[WorkFromHome] [int] NULL,
	[CreatedBy] [nvarchar](50) NOT NULL,
	[CreatedDateTime] [datetime] NOT NULL,
 CONSTRAINT [PK_tblAttendance] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [AT2].[tblDepartments]    Script Date: 5/28/2019 6:15:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [AT2].[tblDepartments](
	[DepartmentId] [int] IDENTITY(1,1) NOT NULL,
	[Department] [nvarchar](100) NOT NULL,
	[IsActive] [bit] NOT NULL CONSTRAINT [DF_tblDepartments_IsActive]  DEFAULT ((0)),
 CONSTRAINT [PK_ATT.tblDepartments] PRIMARY KEY CLUSTERED 
(
	[DepartmentId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [AT2].[tblDesignations]    Script Date: 5/28/2019 6:15:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [AT2].[tblDesignations](
	[DesignationID] [int] IDENTITY(1,1) NOT NULL,
	[Designation] [nvarchar](100) NOT NULL,
	[IsActive] [bit] NOT NULL CONSTRAINT [DF_tblDesignations_IsActive]  DEFAULT ((0)),
 CONSTRAINT [PK_tblDesignations] PRIMARY KEY CLUSTERED 
(
	[DesignationID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [AT2].[tblEmployees]    Script Date: 5/28/2019 6:15:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [AT2].[tblEmployees](
	[EmployeeID] [int] IDENTITY(1,1) NOT NULL,
	[FirstName] [nvarchar](200) NOT NULL,
	[LastName] [nvarchar](200) NULL,
	[DesignationID] [int] NOT NULL,
	[DepartmentID] [int] NOT NULL,
	[Mobile] [nvarchar](10) NULL,
	[WorkEmail] [nvarchar](100) NULL,
	[PersonalEmail] [nvarchar](100) NULL,
	[UserID] [nvarchar](50) NULL,
	[Password] [nvarchar](200) NULL,
	[IsAdmin] [bit] NOT NULL CONSTRAINT [DF_tblEmployees_IsAdmin]  DEFAULT ((0)),
	[IsActive] [bit] NOT NULL CONSTRAINT [DF_tblEmployees_IsActive]  DEFAULT ((1)),
	[ActivatedDate] [datetime] NULL,
	[Order] [int] NULL,
	[BiometricID] [nvarchar](50) NULL,
	[MapleID] [nvarchar](50) NULL,
	[DOB] [date] NULL,
	[DOJ] [date] NULL,
	[Gender] [int] NULL,
	[MaritalStatus] [bit] NULL,
	[DOA] [date] NULL,
	[BloodGroup] [nchar](2) NULL,
	[EmergencyContactPerson] [nvarchar](100) NULL,
	[EmergencyContactNumber] [nvarchar](15) NULL,
	[EmergencyContactRelation] [nvarchar](50) NULL,
	[IsBilling] [bit] NULL,
	[IsProfileUpdated] [bit] NOT NULL CONSTRAINT [IsProfileUpdated_DF]  DEFAULT ((0)),
	[SlackId] [nvarchar](250) NULL,
 CONSTRAINT [PK_tblEmployees] PRIMARY KEY CLUSTERED 
(
	[EmployeeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [AT2].[tblHolidays]    Script Date: 5/28/2019 6:15:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [AT2].[tblHolidays](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[Year] [nvarchar](50) NULL,
	[Date] [nvarchar](50) NULL,
	[Day] [nvarchar](15) NULL,
	[Festival] [nvarchar](1000) NULL,
PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [AT2].[tblTimelog]    Script Date: 5/28/2019 6:15:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [AT2].[tblTimelog](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[EmployeeId] [int] NOT NULL,
	[Date] [datetime] NOT NULL,
	[Type] [varchar](10) NOT NULL,
	[StartTime] [time](5) NOT NULL,
	[EndTime] [time](5) NULL,
 CONSTRAINT [PK_ATT.tblBreaks] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [BILL].[tblBillingType]    Script Date: 5/28/2019 6:15:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [BILL].[tblBillingType](
	[BillingTypeId] [int] IDENTITY(1,1) NOT NULL,
	[BillingType] [nvarchar](250) NULL,
	[IsActive] [bit] NULL,
	[CreatedOn] [datetime] NULL,
	[CreatedBy] [int] NULL,
	[UpdatedOn] [datetime] NULL,
	[UpdatedBy] [int] NULL,
 CONSTRAINT [PK_BILL_tblBillingType] PRIMARY KEY CLUSTERED 
(
	[BillingTypeId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [BILL].[tblClients]    Script Date: 5/28/2019 6:15:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [BILL].[tblClients](
	[ClientId] [int] IDENTITY(1,1) NOT NULL,
	[ClientName] [nvarchar](250) NULL,
	[CountryId] [int] NULL,
	[BillingTypeId] [int] NULL,
	[IsActive] [bit] NULL,
	[CreatedOn] [datetime] NULL,
	[CreatedBy] [int] NULL,
	[UpdatedOn] [datetime] NULL,
	[UpdatedBy] [int] NULL,
 CONSTRAINT [PK_BILL_tblClients] PRIMARY KEY CLUSTERED 
(
	[ClientId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [BILL].[tblCountry]    Script Date: 5/28/2019 6:15:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [BILL].[tblCountry](
	[CountryId] [int] IDENTITY(1,1) NOT NULL,
	[CountryName] [nvarchar](250) NULL,
 CONSTRAINT [PK_BILL_tblCountry] PRIMARY KEY CLUSTERED 
(
	[CountryId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET IDENTITY_INSERT [AT2].[tblAccessCardData] ON 

GO
INSERT [AT2].[tblAccessCardData] ([Id], [CardId], [Date], [InTime], [OutTime], [Name]) VALUES (1, N'01229237', CAST(N'2019-04-22 00:00:00' AS SmallDateTime), CAST(N'1900-01-01 17:06:29.000' AS DateTime), CAST(N'1900-01-01 00:00:00.000' AS DateTime), N'Doddi Janaki')
GO
INSERT [AT2].[tblAccessCardData] ([Id], [CardId], [Date], [InTime], [OutTime], [Name]) VALUES (2, N'01229237', CAST(N'2019-04-23 00:00:00' AS SmallDateTime), CAST(N'1900-01-01 10:08:25.000' AS DateTime), CAST(N'1900-01-01 00:00:00.000' AS DateTime), N'Doddi Janaki')
GO
INSERT [AT2].[tblAccessCardData] ([Id], [CardId], [Date], [InTime], [OutTime], [Name]) VALUES (3, N'01229237', CAST(N'2019-04-24 00:00:00' AS SmallDateTime), CAST(N'1900-01-01 10:10:28.000' AS DateTime), CAST(N'1900-01-01 10:10:28.000' AS DateTime), N'Doddi Janaki')
GO
INSERT [AT2].[tblAccessCardData] ([Id], [CardId], [Date], [InTime], [OutTime], [Name]) VALUES (4, N'01229237', CAST(N'2019-04-25 00:00:00' AS SmallDateTime), CAST(N'1900-01-01 10:13:26.000' AS DateTime), CAST(N'1900-01-01 10:13:26.000' AS DateTime), N'Doddi Janaki')
GO
INSERT [AT2].[tblAccessCardData] ([Id], [CardId], [Date], [InTime], [OutTime], [Name]) VALUES (5, N'01229237', CAST(N'2019-04-30 00:00:00' AS SmallDateTime), CAST(N'1900-01-01 10:37:11.000' AS DateTime), CAST(N'1900-01-01 20:14:14.000' AS DateTime), N'Doddi Janaki')
GO
INSERT [AT2].[tblAccessCardData] ([Id], [CardId], [Date], [InTime], [OutTime], [Name]) VALUES (6, N'01229237', CAST(N'2019-05-01 00:00:00' AS SmallDateTime), CAST(N'1900-01-01 10:11:02.000' AS DateTime), CAST(N'1900-01-01 20:45:49.000' AS DateTime), N'Doddi Janaki')
GO
INSERT [AT2].[tblAccessCardData] ([Id], [CardId], [Date], [InTime], [OutTime], [Name]) VALUES (7, N'01229237', CAST(N'2019-05-02 00:00:00' AS SmallDateTime), CAST(N'1900-01-01 10:06:34.000' AS DateTime), CAST(N'1900-01-01 19:39:05.000' AS DateTime), N'Doddi Janaki')
GO
INSERT [AT2].[tblAccessCardData] ([Id], [CardId], [Date], [InTime], [OutTime], [Name]) VALUES (8, N'01229237', CAST(N'2019-05-03 00:00:00' AS SmallDateTime), CAST(N'1900-01-01 10:20:47.000' AS DateTime), CAST(N'1900-01-01 20:10:09.000' AS DateTime), N'Doddi Janaki')
GO
INSERT [AT2].[tblAccessCardData] ([Id], [CardId], [Date], [InTime], [OutTime], [Name]) VALUES (9, N'01229237', CAST(N'2019-05-06 00:00:00' AS SmallDateTime), CAST(N'1900-01-01 10:12:50.000' AS DateTime), CAST(N'1900-01-01 20:08:16.000' AS DateTime), N'Doddi Janaki')
GO
INSERT [AT2].[tblAccessCardData] ([Id], [CardId], [Date], [InTime], [OutTime], [Name]) VALUES (10, N'01229237', CAST(N'2019-05-07 00:00:00' AS SmallDateTime), CAST(N'1900-01-01 10:13:27.000' AS DateTime), CAST(N'1900-01-01 20:14:52.000' AS DateTime), N'Doddi Janaki')
GO
INSERT [AT2].[tblAccessCardData] ([Id], [CardId], [Date], [InTime], [OutTime], [Name]) VALUES (11, N'01229237', CAST(N'2019-05-08 00:00:00' AS SmallDateTime), CAST(N'1900-01-01 10:10:23.000' AS DateTime), CAST(N'1900-01-01 20:07:02.000' AS DateTime), N'Doddi Janaki')
GO
INSERT [AT2].[tblAccessCardData] ([Id], [CardId], [Date], [InTime], [OutTime], [Name]) VALUES (12, N'01229237', CAST(N'2019-05-09 00:00:00' AS SmallDateTime), CAST(N'1900-01-01 10:38:38.000' AS DateTime), CAST(N'1900-01-01 20:38:08.000' AS DateTime), N'Doddi Janaki')
GO
INSERT [AT2].[tblAccessCardData] ([Id], [CardId], [Date], [InTime], [OutTime], [Name]) VALUES (13, N'01229237', CAST(N'2019-05-10 00:00:00' AS SmallDateTime), CAST(N'1900-01-01 11:43:40.000' AS DateTime), CAST(N'1900-01-01 20:18:08.000' AS DateTime), N'Doddi Janaki')
GO
INSERT [AT2].[tblAccessCardData] ([Id], [CardId], [Date], [InTime], [OutTime], [Name]) VALUES (14, N'01229237', CAST(N'2019-05-13 00:00:00' AS SmallDateTime), CAST(N'1900-01-01 10:26:59.000' AS DateTime), CAST(N'1900-01-01 20:16:42.000' AS DateTime), N'Doddi Janaki')
GO
INSERT [AT2].[tblAccessCardData] ([Id], [CardId], [Date], [InTime], [OutTime], [Name]) VALUES (15, N'01229237', CAST(N'2019-05-14 00:00:00' AS SmallDateTime), CAST(N'1900-01-01 10:01:34.000' AS DateTime), CAST(N'1900-01-01 20:08:31.000' AS DateTime), N'Doddi Janaki')
GO
INSERT [AT2].[tblAccessCardData] ([Id], [CardId], [Date], [InTime], [OutTime], [Name]) VALUES (16, N'01229237', CAST(N'2019-05-15 00:00:00' AS SmallDateTime), CAST(N'1900-01-01 10:34:12.000' AS DateTime), CAST(N'1900-01-01 20:09:21.000' AS DateTime), N'Doddi Janaki')
GO
INSERT [AT2].[tblAccessCardData] ([Id], [CardId], [Date], [InTime], [OutTime], [Name]) VALUES (17, N'01229237', CAST(N'2019-05-16 00:00:00' AS SmallDateTime), CAST(N'1900-01-01 10:15:11.000' AS DateTime), CAST(N'1900-01-01 20:18:47.000' AS DateTime), N'Doddi Janaki')
GO
INSERT [AT2].[tblAccessCardData] ([Id], [CardId], [Date], [InTime], [OutTime], [Name]) VALUES (18, N'01229237', CAST(N'2019-05-17 00:00:00' AS SmallDateTime), CAST(N'1900-01-01 10:00:05.000' AS DateTime), CAST(N'1900-01-01 20:02:26.000' AS DateTime), N'Doddi Janaki')
GO
INSERT [AT2].[tblAccessCardData] ([Id], [CardId], [Date], [InTime], [OutTime], [Name]) VALUES (19, N'01229237', CAST(N'2019-05-20 00:00:00' AS SmallDateTime), CAST(N'1900-01-01 10:06:29.000' AS DateTime), CAST(N'1900-01-01 20:22:01.000' AS DateTime), N'Doddi Janaki')
GO
INSERT [AT2].[tblAccessCardData] ([Id], [CardId], [Date], [InTime], [OutTime], [Name]) VALUES (20, N'01113666', CAST(N'2019-04-22 00:00:00' AS SmallDateTime), CAST(N'1900-01-01 13:18:18.000' AS DateTime), CAST(N'1900-01-01 20:12:12.000' AS DateTime), N'Pukkalla Reshma')
GO
INSERT [AT2].[tblAccessCardData] ([Id], [CardId], [Date], [InTime], [OutTime], [Name]) VALUES (21, N'01113666', CAST(N'2019-04-23 00:00:00' AS SmallDateTime), CAST(N'1900-01-01 10:18:51.000' AS DateTime), CAST(N'1900-01-01 20:15:31.000' AS DateTime), N'Pukkalla Reshma')
GO
INSERT [AT2].[tblAccessCardData] ([Id], [CardId], [Date], [InTime], [OutTime], [Name]) VALUES (22, N'01113666', CAST(N'2019-04-24 00:00:00' AS SmallDateTime), CAST(N'1900-01-01 10:18:40.000' AS DateTime), CAST(N'1900-01-01 20:34:09.000' AS DateTime), N'Pukkalla Reshma')
GO
INSERT [AT2].[tblAccessCardData] ([Id], [CardId], [Date], [InTime], [OutTime], [Name]) VALUES (23, N'01113666', CAST(N'2019-04-25 00:00:00' AS SmallDateTime), CAST(N'1900-01-01 10:20:54.000' AS DateTime), CAST(N'1900-01-01 20:27:48.000' AS DateTime), N'Pukkalla Reshma')
GO
INSERT [AT2].[tblAccessCardData] ([Id], [CardId], [Date], [InTime], [OutTime], [Name]) VALUES (24, N'01113666', CAST(N'2019-04-26 00:00:00' AS SmallDateTime), CAST(N'1900-01-01 10:16:45.000' AS DateTime), CAST(N'1900-01-01 20:05:42.000' AS DateTime), N'Pukkalla Reshma')
GO
INSERT [AT2].[tblAccessCardData] ([Id], [CardId], [Date], [InTime], [OutTime], [Name]) VALUES (25, N'01113666', CAST(N'2019-04-29 00:00:00' AS SmallDateTime), CAST(N'1900-01-01 10:20:54.000' AS DateTime), CAST(N'1900-01-01 20:21:32.000' AS DateTime), N'Pukkalla Reshma')
GO
INSERT [AT2].[tblAccessCardData] ([Id], [CardId], [Date], [InTime], [OutTime], [Name]) VALUES (26, N'01113666', CAST(N'2019-04-30 00:00:00' AS SmallDateTime), CAST(N'1900-01-01 09:38:10.000' AS DateTime), CAST(N'1900-01-01 20:14:41.000' AS DateTime), N'Pukkalla Reshma')
GO
INSERT [AT2].[tblAccessCardData] ([Id], [CardId], [Date], [InTime], [OutTime], [Name]) VALUES (27, N'01113666', CAST(N'2019-05-01 00:00:00' AS SmallDateTime), CAST(N'1900-01-01 10:16:15.000' AS DateTime), CAST(N'1900-01-01 20:41:23.000' AS DateTime), N'Pukkalla Reshma')
GO
INSERT [AT2].[tblAccessCardData] ([Id], [CardId], [Date], [InTime], [OutTime], [Name]) VALUES (28, N'01113666', CAST(N'2019-05-02 00:00:00' AS SmallDateTime), CAST(N'1900-01-01 10:23:27.000' AS DateTime), CAST(N'1900-01-01 20:01:38.000' AS DateTime), N'Pukkalla Reshma')
GO
INSERT [AT2].[tblAccessCardData] ([Id], [CardId], [Date], [InTime], [OutTime], [Name]) VALUES (29, N'01113666', CAST(N'2019-05-03 00:00:00' AS SmallDateTime), CAST(N'1900-01-01 10:18:57.000' AS DateTime), CAST(N'1900-01-01 20:09:56.000' AS DateTime), N'Pukkalla Reshma')
GO
INSERT [AT2].[tblAccessCardData] ([Id], [CardId], [Date], [InTime], [OutTime], [Name]) VALUES (30, N'01113666', CAST(N'2019-05-06 00:00:00' AS SmallDateTime), CAST(N'1900-01-01 10:33:36.000' AS DateTime), CAST(N'1900-01-01 20:10:20.000' AS DateTime), N'Pukkalla Reshma')
GO
INSERT [AT2].[tblAccessCardData] ([Id], [CardId], [Date], [InTime], [OutTime], [Name]) VALUES (31, N'01113666', CAST(N'2019-05-07 00:00:00' AS SmallDateTime), CAST(N'1900-01-01 10:15:32.000' AS DateTime), CAST(N'1900-01-01 20:16:09.000' AS DateTime), N'Pukkalla Reshma')
GO
INSERT [AT2].[tblAccessCardData] ([Id], [CardId], [Date], [InTime], [OutTime], [Name]) VALUES (32, N'01113666', CAST(N'2019-05-08 00:00:00' AS SmallDateTime), CAST(N'1900-01-01 10:23:06.000' AS DateTime), CAST(N'1900-01-01 20:07:51.000' AS DateTime), N'Pukkalla Reshma')
GO
INSERT [AT2].[tblAccessCardData] ([Id], [CardId], [Date], [InTime], [OutTime], [Name]) VALUES (33, N'01113666', CAST(N'2019-05-09 00:00:00' AS SmallDateTime), CAST(N'1900-01-01 10:02:00.000' AS DateTime), CAST(N'1900-01-01 17:33:55.000' AS DateTime), N'Pukkalla Reshma')
GO
INSERT [AT2].[tblAccessCardData] ([Id], [CardId], [Date], [InTime], [OutTime], [Name]) VALUES (34, N'01113666', CAST(N'2019-05-10 00:00:00' AS SmallDateTime), CAST(N'1900-01-01 10:11:39.000' AS DateTime), CAST(N'1900-01-01 20:18:02.000' AS DateTime), N'Pukkalla Reshma')
GO
INSERT [AT2].[tblAccessCardData] ([Id], [CardId], [Date], [InTime], [OutTime], [Name]) VALUES (35, N'01113666', CAST(N'2019-05-13 00:00:00' AS SmallDateTime), CAST(N'1900-01-01 10:15:01.000' AS DateTime), CAST(N'1900-01-01 20:15:05.000' AS DateTime), N'Pukkalla Reshma')
GO
INSERT [AT2].[tblAccessCardData] ([Id], [CardId], [Date], [InTime], [OutTime], [Name]) VALUES (36, N'01113666', CAST(N'2019-05-14 00:00:00' AS SmallDateTime), CAST(N'1900-01-01 10:33:48.000' AS DateTime), CAST(N'1900-01-01 20:07:31.000' AS DateTime), N'Pukkalla Reshma')
GO
INSERT [AT2].[tblAccessCardData] ([Id], [CardId], [Date], [InTime], [OutTime], [Name]) VALUES (37, N'01113666', CAST(N'2019-05-15 00:00:00' AS SmallDateTime), CAST(N'1900-01-01 10:21:43.000' AS DateTime), CAST(N'1900-01-01 20:11:07.000' AS DateTime), N'Pukkalla Reshma')
GO
INSERT [AT2].[tblAccessCardData] ([Id], [CardId], [Date], [InTime], [OutTime], [Name]) VALUES (38, N'01113666', CAST(N'2019-05-16 00:00:00' AS SmallDateTime), CAST(N'1900-01-01 10:18:56.000' AS DateTime), CAST(N'1900-01-01 20:18:54.000' AS DateTime), N'Pukkalla Reshma')
GO
INSERT [AT2].[tblAccessCardData] ([Id], [CardId], [Date], [InTime], [OutTime], [Name]) VALUES (39, N'01113666', CAST(N'2019-05-20 00:00:00' AS SmallDateTime), CAST(N'1900-01-01 10:18:45.000' AS DateTime), CAST(N'1900-01-01 20:24:11.000' AS DateTime), N'Pukkalla Reshma')
GO
INSERT [AT2].[tblAccessCardData] ([Id], [CardId], [Date], [InTime], [OutTime], [Name]) VALUES (40, N'01108157', CAST(N'2019-04-22 00:00:00' AS SmallDateTime), CAST(N'1900-01-01 11:35:34.000' AS DateTime), CAST(N'1900-01-01 20:15:19.000' AS DateTime), N'Chatrathi Sai Subrahmanya Sarma')
GO
INSERT [AT2].[tblAccessCardData] ([Id], [CardId], [Date], [InTime], [OutTime], [Name]) VALUES (41, N'01108157', CAST(N'2019-04-23 00:00:00' AS SmallDateTime), CAST(N'1900-01-01 10:15:19.000' AS DateTime), CAST(N'1900-01-01 20:18:15.000' AS DateTime), N'Chatrathi Sai Subrahmanya Sarma')
GO
INSERT [AT2].[tblAccessCardData] ([Id], [CardId], [Date], [InTime], [OutTime], [Name]) VALUES (42, N'01108157', CAST(N'2019-04-24 00:00:00' AS SmallDateTime), CAST(N'1900-01-01 09:38:22.000' AS DateTime), CAST(N'1900-01-01 20:43:12.000' AS DateTime), N'Chatrathi Sai Subrahmanya Sarma')
GO
INSERT [AT2].[tblAccessCardData] ([Id], [CardId], [Date], [InTime], [OutTime], [Name]) VALUES (43, N'01108157', CAST(N'2019-04-25 00:00:00' AS SmallDateTime), CAST(N'1900-01-01 10:11:01.000' AS DateTime), CAST(N'1900-01-01 20:30:35.000' AS DateTime), N'Chatrathi Sai Subrahmanya Sarma')
GO
INSERT [AT2].[tblAccessCardData] ([Id], [CardId], [Date], [InTime], [OutTime], [Name]) VALUES (44, N'01108157', CAST(N'2019-04-26 00:00:00' AS SmallDateTime), CAST(N'1900-01-01 10:03:20.000' AS DateTime), CAST(N'1900-01-01 20:07:37.000' AS DateTime), N'Chatrathi Sai Subrahmanya Sarma')
GO
INSERT [AT2].[tblAccessCardData] ([Id], [CardId], [Date], [InTime], [OutTime], [Name]) VALUES (45, N'01108157', CAST(N'2019-04-29 00:00:00' AS SmallDateTime), CAST(N'1900-01-01 10:41:12.000' AS DateTime), CAST(N'1900-01-01 20:23:08.000' AS DateTime), N'Chatrathi Sai Subrahmanya Sarma')
GO
INSERT [AT2].[tblAccessCardData] ([Id], [CardId], [Date], [InTime], [OutTime], [Name]) VALUES (46, N'01108157', CAST(N'2019-04-30 00:00:00' AS SmallDateTime), CAST(N'1900-01-01 09:49:40.000' AS DateTime), CAST(N'1900-01-01 20:16:12.000' AS DateTime), N'Chatrathi Sai Subrahmanya Sarma')
GO
INSERT [AT2].[tblAccessCardData] ([Id], [CardId], [Date], [InTime], [OutTime], [Name]) VALUES (47, N'01108157', CAST(N'2019-05-01 00:00:00' AS SmallDateTime), CAST(N'1900-01-01 10:16:19.000' AS DateTime), CAST(N'1900-01-01 20:42:56.000' AS DateTime), N'Chatrathi Sai Subrahmanya Sarma')
GO
INSERT [AT2].[tblAccessCardData] ([Id], [CardId], [Date], [InTime], [OutTime], [Name]) VALUES (48, N'01108157', CAST(N'2019-05-02 00:00:00' AS SmallDateTime), CAST(N'1900-01-01 10:06:42.000' AS DateTime), CAST(N'1900-01-01 20:09:56.000' AS DateTime), N'Chatrathi Sai Subrahmanya Sarma')
GO
INSERT [AT2].[tblAccessCardData] ([Id], [CardId], [Date], [InTime], [OutTime], [Name]) VALUES (49, N'01108157', CAST(N'2019-05-03 00:00:00' AS SmallDateTime), CAST(N'1900-01-01 10:27:24.000' AS DateTime), CAST(N'1900-01-01 20:11:38.000' AS DateTime), N'Chatrathi Sai Subrahmanya Sarma')
GO
INSERT [AT2].[tblAccessCardData] ([Id], [CardId], [Date], [InTime], [OutTime], [Name]) VALUES (50, N'01108157', CAST(N'2019-05-06 00:00:00' AS SmallDateTime), CAST(N'1900-01-01 09:55:58.000' AS DateTime), CAST(N'1900-01-01 00:00:00.000' AS DateTime), N'Chatrathi Sai Subrahmanya Sarma')
GO
INSERT [AT2].[tblAccessCardData] ([Id], [CardId], [Date], [InTime], [OutTime], [Name]) VALUES (51, N'01108157', CAST(N'2019-05-07 00:00:00' AS SmallDateTime), CAST(N'1900-01-01 10:03:02.000' AS DateTime), CAST(N'1900-01-01 20:22:56.000' AS DateTime), N'Chatrathi Sai Subrahmanya Sarma')
GO
INSERT [AT2].[tblAccessCardData] ([Id], [CardId], [Date], [InTime], [OutTime], [Name]) VALUES (52, N'01108157', CAST(N'2019-05-08 00:00:00' AS SmallDateTime), CAST(N'1900-01-01 10:07:53.000' AS DateTime), CAST(N'1900-01-01 20:22:05.000' AS DateTime), N'Chatrathi Sai Subrahmanya Sarma')
GO
INSERT [AT2].[tblAccessCardData] ([Id], [CardId], [Date], [InTime], [OutTime], [Name]) VALUES (53, N'01108157', CAST(N'2019-05-09 00:00:00' AS SmallDateTime), CAST(N'1900-01-01 10:18:24.000' AS DateTime), CAST(N'1900-01-01 20:32:43.000' AS DateTime), N'Chatrathi Sai Subrahmanya Sarma')
GO
INSERT [AT2].[tblAccessCardData] ([Id], [CardId], [Date], [InTime], [OutTime], [Name]) VALUES (54, N'01108157', CAST(N'2019-05-10 00:00:00' AS SmallDateTime), CAST(N'1900-01-01 09:57:37.000' AS DateTime), CAST(N'1900-01-01 20:26:46.000' AS DateTime), N'Chatrathi Sai Subrahmanya Sarma')
GO
INSERT [AT2].[tblAccessCardData] ([Id], [CardId], [Date], [InTime], [OutTime], [Name]) VALUES (55, N'01108157', CAST(N'2019-05-13 00:00:00' AS SmallDateTime), CAST(N'1900-01-01 09:56:39.000' AS DateTime), CAST(N'1900-01-01 20:13:43.000' AS DateTime), N'Chatrathi Sai Subrahmanya Sarma')
GO
INSERT [AT2].[tblAccessCardData] ([Id], [CardId], [Date], [InTime], [OutTime], [Name]) VALUES (56, N'01108157', CAST(N'2019-05-14 00:00:00' AS SmallDateTime), CAST(N'1900-01-01 10:46:25.000' AS DateTime), CAST(N'1900-01-01 20:08:19.000' AS DateTime), N'Chatrathi Sai Subrahmanya Sarma')
GO
INSERT [AT2].[tblAccessCardData] ([Id], [CardId], [Date], [InTime], [OutTime], [Name]) VALUES (57, N'01108157', CAST(N'2019-05-15 00:00:00' AS SmallDateTime), CAST(N'1900-01-01 10:04:33.000' AS DateTime), CAST(N'1900-01-01 20:20:42.000' AS DateTime), N'Chatrathi Sai Subrahmanya Sarma')
GO
INSERT [AT2].[tblAccessCardData] ([Id], [CardId], [Date], [InTime], [OutTime], [Name]) VALUES (58, N'01108157', CAST(N'2019-05-16 00:00:00' AS SmallDateTime), CAST(N'1900-01-01 09:27:42.000' AS DateTime), CAST(N'1900-01-01 20:17:47.000' AS DateTime), N'Chatrathi Sai Subrahmanya Sarma')
GO
INSERT [AT2].[tblAccessCardData] ([Id], [CardId], [Date], [InTime], [OutTime], [Name]) VALUES (59, N'01108157', CAST(N'2019-05-17 00:00:00' AS SmallDateTime), CAST(N'1900-01-01 10:05:57.000' AS DateTime), CAST(N'1900-01-01 20:03:06.000' AS DateTime), N'Chatrathi Sai Subrahmanya Sarma')
GO
INSERT [AT2].[tblAccessCardData] ([Id], [CardId], [Date], [InTime], [OutTime], [Name]) VALUES (60, N'01108157', CAST(N'2019-05-20 00:00:00' AS SmallDateTime), CAST(N'1900-01-01 10:02:48.000' AS DateTime), CAST(N'1900-01-01 20:19:40.000' AS DateTime), N'Chatrathi Sai Subrahmanya Sarma')
GO
INSERT [AT2].[tblAccessCardData] ([Id], [CardId], [Date], [InTime], [OutTime], [Name]) VALUES (61, N'01926797', CAST(N'2019-04-22 00:00:00' AS SmallDateTime), CAST(N'1900-01-01 15:51:04.000' AS DateTime), CAST(N'1900-01-01 21:13:30.000' AS DateTime), N'Srikanth Gupta')
GO
INSERT [AT2].[tblAccessCardData] ([Id], [CardId], [Date], [InTime], [OutTime], [Name]) VALUES (62, N'01926797', CAST(N'2019-04-23 00:00:00' AS SmallDateTime), CAST(N'1900-01-01 12:29:47.000' AS DateTime), CAST(N'1900-01-01 21:30:19.000' AS DateTime), N'Srikanth Gupta')
GO
INSERT [AT2].[tblAccessCardData] ([Id], [CardId], [Date], [InTime], [OutTime], [Name]) VALUES (63, N'01926797', CAST(N'2019-04-24 00:00:00' AS SmallDateTime), CAST(N'1900-01-01 15:01:32.000' AS DateTime), CAST(N'1900-01-01 00:00:00.000' AS DateTime), N'Srikanth Gupta')
GO
INSERT [AT2].[tblAccessCardData] ([Id], [CardId], [Date], [InTime], [OutTime], [Name]) VALUES (64, N'01926797', CAST(N'2019-05-02 00:00:00' AS SmallDateTime), CAST(N'1900-01-01 13:55:11.000' AS DateTime), CAST(N'1900-01-01 18:03:55.000' AS DateTime), N'Srikanth Gupta')
GO
INSERT [AT2].[tblAccessCardData] ([Id], [CardId], [Date], [InTime], [OutTime], [Name]) VALUES (65, N'01926797', CAST(N'2019-05-03 00:00:00' AS SmallDateTime), CAST(N'1900-01-01 12:26:40.000' AS DateTime), CAST(N'1900-01-01 15:58:17.000' AS DateTime), N'Srikanth Gupta')
GO
INSERT [AT2].[tblAccessCardData] ([Id], [CardId], [Date], [InTime], [OutTime], [Name]) VALUES (66, N'01926797', CAST(N'2019-05-06 00:00:00' AS SmallDateTime), CAST(N'1900-01-01 12:07:55.000' AS DateTime), CAST(N'1900-01-01 21:48:59.000' AS DateTime), N'Srikanth Gupta')
GO
INSERT [AT2].[tblAccessCardData] ([Id], [CardId], [Date], [InTime], [OutTime], [Name]) VALUES (67, N'01926797', CAST(N'2019-05-07 00:00:00' AS SmallDateTime), CAST(N'1900-01-01 12:34:44.000' AS DateTime), CAST(N'1900-01-01 15:27:00.000' AS DateTime), N'Srikanth Gupta')
GO
INSERT [AT2].[tblAccessCardData] ([Id], [CardId], [Date], [InTime], [OutTime], [Name]) VALUES (68, N'01926797', CAST(N'2019-05-08 00:00:00' AS SmallDateTime), CAST(N'1900-01-01 12:11:57.000' AS DateTime), CAST(N'1900-01-01 15:27:44.000' AS DateTime), N'Srikanth Gupta')
GO
INSERT [AT2].[tblAccessCardData] ([Id], [CardId], [Date], [InTime], [OutTime], [Name]) VALUES (69, N'01926797', CAST(N'2019-05-09 00:00:00' AS SmallDateTime), CAST(N'1900-01-01 12:43:44.000' AS DateTime), CAST(N'1900-01-01 21:43:05.000' AS DateTime), N'Srikanth Gupta')
GO
INSERT [AT2].[tblAccessCardData] ([Id], [CardId], [Date], [InTime], [OutTime], [Name]) VALUES (70, N'01926797', CAST(N'2019-05-10 00:00:00' AS SmallDateTime), CAST(N'1900-01-01 11:59:07.000' AS DateTime), CAST(N'1900-01-01 21:55:37.000' AS DateTime), N'Srikanth Gupta')
GO
INSERT [AT2].[tblAccessCardData] ([Id], [CardId], [Date], [InTime], [OutTime], [Name]) VALUES (71, N'01926797', CAST(N'2019-05-13 00:00:00' AS SmallDateTime), CAST(N'1900-01-01 10:35:59.000' AS DateTime), CAST(N'1900-01-01 21:27:02.000' AS DateTime), N'Srikanth Gupta')
GO
INSERT [AT2].[tblAccessCardData] ([Id], [CardId], [Date], [InTime], [OutTime], [Name]) VALUES (72, N'01926797', CAST(N'2019-05-14 00:00:00' AS SmallDateTime), CAST(N'1900-01-01 12:22:55.000' AS DateTime), CAST(N'1900-01-01 21:38:38.000' AS DateTime), N'Srikanth Gupta')
GO
INSERT [AT2].[tblAccessCardData] ([Id], [CardId], [Date], [InTime], [OutTime], [Name]) VALUES (73, N'01926797', CAST(N'2019-05-15 00:00:00' AS SmallDateTime), CAST(N'1900-01-01 11:46:50.000' AS DateTime), CAST(N'1900-01-01 21:44:35.000' AS DateTime), N'Srikanth Gupta')
GO
INSERT [AT2].[tblAccessCardData] ([Id], [CardId], [Date], [InTime], [OutTime], [Name]) VALUES (74, N'01926797', CAST(N'2019-05-16 00:00:00' AS SmallDateTime), CAST(N'1900-01-01 12:40:58.000' AS DateTime), CAST(N'1900-01-01 21:20:12.000' AS DateTime), N'Srikanth Gupta')
GO
INSERT [AT2].[tblAccessCardData] ([Id], [CardId], [Date], [InTime], [OutTime], [Name]) VALUES (75, N'01926797', CAST(N'2019-05-17 00:00:00' AS SmallDateTime), CAST(N'1900-01-01 11:49:43.000' AS DateTime), CAST(N'1900-01-01 19:59:38.000' AS DateTime), N'Srikanth Gupta')
GO
INSERT [AT2].[tblAccessCardData] ([Id], [CardId], [Date], [InTime], [OutTime], [Name]) VALUES (76, N'01926797', CAST(N'2019-05-20 00:00:00' AS SmallDateTime), CAST(N'1900-01-01 11:37:07.000' AS DateTime), CAST(N'1900-01-01 21:47:15.000' AS DateTime), N'Srikanth Gupta')
GO
INSERT [AT2].[tblAccessCardData] ([Id], [CardId], [Date], [InTime], [OutTime], [Name]) VALUES (77, N'01310569', CAST(N'2019-04-22 00:00:00' AS SmallDateTime), CAST(N'1900-01-01 14:07:31.000' AS DateTime), CAST(N'1900-01-01 21:12:12.000' AS DateTime), N'Santhosh Mukkamala')
GO
INSERT [AT2].[tblAccessCardData] ([Id], [CardId], [Date], [InTime], [OutTime], [Name]) VALUES (78, N'01310569', CAST(N'2019-04-23 00:00:00' AS SmallDateTime), CAST(N'1900-01-01 11:39:51.000' AS DateTime), CAST(N'1900-01-01 20:57:33.000' AS DateTime), N'Santhosh Mukkamala')
GO
INSERT [AT2].[tblAccessCardData] ([Id], [CardId], [Date], [InTime], [OutTime], [Name]) VALUES (79, N'01310569', CAST(N'2019-04-24 00:00:00' AS SmallDateTime), CAST(N'1900-01-01 10:47:28.000' AS DateTime), CAST(N'1900-01-01 21:23:35.000' AS DateTime), N'Santhosh Mukkamala')
GO
INSERT [AT2].[tblAccessCardData] ([Id], [CardId], [Date], [InTime], [OutTime], [Name]) VALUES (80, N'01310569', CAST(N'2019-04-25 00:00:00' AS SmallDateTime), CAST(N'1900-01-01 11:50:55.000' AS DateTime), CAST(N'1900-01-01 21:55:03.000' AS DateTime), N'Santhosh Mukkamala')
GO
INSERT [AT2].[tblAccessCardData] ([Id], [CardId], [Date], [InTime], [OutTime], [Name]) VALUES (81, N'01310569', CAST(N'2019-04-26 00:00:00' AS SmallDateTime), CAST(N'1900-01-01 12:18:14.000' AS DateTime), CAST(N'1900-01-01 21:58:52.000' AS DateTime), N'Santhosh Mukkamala')
GO
INSERT [AT2].[tblAccessCardData] ([Id], [CardId], [Date], [InTime], [OutTime], [Name]) VALUES (82, N'01310569', CAST(N'2019-04-29 00:00:00' AS SmallDateTime), CAST(N'1900-01-01 11:19:17.000' AS DateTime), CAST(N'1900-01-01 21:39:12.000' AS DateTime), N'Santhosh Mukkamala')
GO
INSERT [AT2].[tblAccessCardData] ([Id], [CardId], [Date], [InTime], [OutTime], [Name]) VALUES (83, N'01310569', CAST(N'2019-04-30 00:00:00' AS SmallDateTime), CAST(N'1900-01-01 11:29:51.000' AS DateTime), CAST(N'1900-01-01 21:46:43.000' AS DateTime), N'Santhosh Mukkamala')
GO
INSERT [AT2].[tblAccessCardData] ([Id], [CardId], [Date], [InTime], [OutTime], [Name]) VALUES (84, N'01310569', CAST(N'2019-05-01 00:00:00' AS SmallDateTime), CAST(N'1900-01-01 11:34:31.000' AS DateTime), CAST(N'1900-01-01 21:17:03.000' AS DateTime), N'Santhosh Mukkamala')
GO
INSERT [AT2].[tblAccessCardData] ([Id], [CardId], [Date], [InTime], [OutTime], [Name]) VALUES (85, N'01310569', CAST(N'2019-05-02 00:00:00' AS SmallDateTime), CAST(N'1900-01-01 11:19:16.000' AS DateTime), CAST(N'1900-01-01 22:39:34.000' AS DateTime), N'Santhosh Mukkamala')
GO
INSERT [AT2].[tblAccessCardData] ([Id], [CardId], [Date], [InTime], [OutTime], [Name]) VALUES (86, N'01310569', CAST(N'2019-05-03 00:00:00' AS SmallDateTime), CAST(N'1900-01-01 12:00:12.000' AS DateTime), CAST(N'1900-01-01 21:55:04.000' AS DateTime), N'Santhosh Mukkamala')
GO
INSERT [AT2].[tblAccessCardData] ([Id], [CardId], [Date], [InTime], [OutTime], [Name]) VALUES (87, N'01310569', CAST(N'2019-05-06 00:00:00' AS SmallDateTime), CAST(N'1900-01-01 11:35:03.000' AS DateTime), CAST(N'1900-01-01 21:43:11.000' AS DateTime), N'Santhosh Mukkamala')
GO
INSERT [AT2].[tblAccessCardData] ([Id], [CardId], [Date], [InTime], [OutTime], [Name]) VALUES (88, N'01310569', CAST(N'2019-05-07 00:00:00' AS SmallDateTime), CAST(N'1900-01-01 11:35:15.000' AS DateTime), CAST(N'1900-01-01 21:55:29.000' AS DateTime), N'Santhosh Mukkamala')
GO
INSERT [AT2].[tblAccessCardData] ([Id], [CardId], [Date], [InTime], [OutTime], [Name]) VALUES (89, N'01310569', CAST(N'2019-05-08 00:00:00' AS SmallDateTime), CAST(N'1900-01-01 11:40:53.000' AS DateTime), CAST(N'1900-01-01 00:00:00.000' AS DateTime), N'Santhosh Mukkamala')
GO
INSERT [AT2].[tblAccessCardData] ([Id], [CardId], [Date], [InTime], [OutTime], [Name]) VALUES (90, N'01310569', CAST(N'2019-05-09 00:00:00' AS SmallDateTime), CAST(N'1900-01-01 11:05:29.000' AS DateTime), CAST(N'1900-01-01 22:23:41.000' AS DateTime), N'Santhosh Mukkamala')
GO
INSERT [AT2].[tblAccessCardData] ([Id], [CardId], [Date], [InTime], [OutTime], [Name]) VALUES (91, N'01310569', CAST(N'2019-05-10 00:00:00' AS SmallDateTime), CAST(N'1900-01-01 10:55:36.000' AS DateTime), CAST(N'1900-01-01 21:57:20.000' AS DateTime), N'Santhosh Mukkamala')
GO
INSERT [AT2].[tblAccessCardData] ([Id], [CardId], [Date], [InTime], [OutTime], [Name]) VALUES (92, N'01310569', CAST(N'2019-05-13 00:00:00' AS SmallDateTime), CAST(N'1900-01-01 11:12:02.000' AS DateTime), CAST(N'1900-01-01 21:24:21.000' AS DateTime), N'Santhosh Mukkamala')
GO
INSERT [AT2].[tblAccessCardData] ([Id], [CardId], [Date], [InTime], [OutTime], [Name]) VALUES (93, N'01310569', CAST(N'2019-05-14 00:00:00' AS SmallDateTime), CAST(N'1900-01-01 11:51:39.000' AS DateTime), CAST(N'1900-01-01 21:40:10.000' AS DateTime), N'Santhosh Mukkamala')
GO
INSERT [AT2].[tblAccessCardData] ([Id], [CardId], [Date], [InTime], [OutTime], [Name]) VALUES (94, N'01310569', CAST(N'2019-05-15 00:00:00' AS SmallDateTime), CAST(N'1900-01-01 11:49:48.000' AS DateTime), CAST(N'1900-01-01 21:36:00.000' AS DateTime), N'Santhosh Mukkamala')
GO
INSERT [AT2].[tblAccessCardData] ([Id], [CardId], [Date], [InTime], [OutTime], [Name]) VALUES (95, N'01310569', CAST(N'2019-05-16 00:00:00' AS SmallDateTime), CAST(N'1900-01-01 11:32:14.000' AS DateTime), CAST(N'1900-01-01 21:22:29.000' AS DateTime), N'Santhosh Mukkamala')
GO
INSERT [AT2].[tblAccessCardData] ([Id], [CardId], [Date], [InTime], [OutTime], [Name]) VALUES (96, N'01310569', CAST(N'2019-05-17 00:00:00' AS SmallDateTime), CAST(N'1900-01-01 11:44:18.000' AS DateTime), CAST(N'1900-01-01 21:16:15.000' AS DateTime), N'Santhosh Mukkamala')
GO
INSERT [AT2].[tblAccessCardData] ([Id], [CardId], [Date], [InTime], [OutTime], [Name]) VALUES (97, N'01310569', CAST(N'2019-05-20 00:00:00' AS SmallDateTime), CAST(N'1900-01-01 11:50:05.000' AS DateTime), CAST(N'1900-01-01 14:12:17.000' AS DateTime), N'Santhosh Mukkamala')
GO
INSERT [AT2].[tblAccessCardData] ([Id], [CardId], [Date], [InTime], [OutTime], [Name]) VALUES (98, N'01323704', CAST(N'2019-04-22 00:00:00' AS SmallDateTime), CAST(N'1900-01-01 12:10:04.000' AS DateTime), CAST(N'1900-01-01 21:45:21.000' AS DateTime), N'Gopi Krishna Srinivasulu')
GO
INSERT [AT2].[tblAccessCardData] ([Id], [CardId], [Date], [InTime], [OutTime], [Name]) VALUES (99, N'01323704', CAST(N'2019-04-23 00:00:00' AS SmallDateTime), CAST(N'1900-01-01 12:01:16.000' AS DateTime), CAST(N'1900-01-01 22:18:34.000' AS DateTime), N'Gopi Krishna Srinivasulu')
GO
INSERT [AT2].[tblAccessCardData] ([Id], [CardId], [Date], [InTime], [OutTime], [Name]) VALUES (100, N'01323704', CAST(N'2019-04-24 00:00:00' AS SmallDateTime), CAST(N'1900-01-01 12:09:40.000' AS DateTime), CAST(N'1900-01-01 21:40:55.000' AS DateTime), N'Gopi Krishna Srinivasulu')
GO
INSERT [AT2].[tblAccessCardData] ([Id], [CardId], [Date], [InTime], [OutTime], [Name]) VALUES (101, N'01323704', CAST(N'2019-04-25 00:00:00' AS SmallDateTime), CAST(N'1900-01-01 12:08:11.000' AS DateTime), CAST(N'1900-01-01 22:58:31.000' AS DateTime), N'Gopi Krishna Srinivasulu')
GO
INSERT [AT2].[tblAccessCardData] ([Id], [CardId], [Date], [InTime], [OutTime], [Name]) VALUES (102, N'01323704', CAST(N'2019-04-26 00:00:00' AS SmallDateTime), CAST(N'1900-01-01 12:20:48.000' AS DateTime), CAST(N'1900-01-01 22:18:50.000' AS DateTime), N'Gopi Krishna Srinivasulu')
GO
INSERT [AT2].[tblAccessCardData] ([Id], [CardId], [Date], [InTime], [OutTime], [Name]) VALUES (103, N'01323704', CAST(N'2019-04-29 00:00:00' AS SmallDateTime), CAST(N'1900-01-01 12:23:31.000' AS DateTime), CAST(N'1900-01-01 22:12:10.000' AS DateTime), N'Gopi Krishna Srinivasulu')
GO
INSERT [AT2].[tblAccessCardData] ([Id], [CardId], [Date], [InTime], [OutTime], [Name]) VALUES (104, N'01323704', CAST(N'2019-04-30 00:00:00' AS SmallDateTime), CAST(N'1900-01-01 11:56:24.000' AS DateTime), CAST(N'1900-01-01 21:47:02.000' AS DateTime), N'Gopi Krishna Srinivasulu')
GO
INSERT [AT2].[tblAccessCardData] ([Id], [CardId], [Date], [InTime], [OutTime], [Name]) VALUES (105, N'01323704', CAST(N'2019-05-01 00:00:00' AS SmallDateTime), CAST(N'1900-01-01 12:08:44.000' AS DateTime), CAST(N'1900-01-01 22:09:50.000' AS DateTime), N'Gopi Krishna Srinivasulu')
GO
INSERT [AT2].[tblAccessCardData] ([Id], [CardId], [Date], [InTime], [OutTime], [Name]) VALUES (106, N'01323704', CAST(N'2019-05-02 00:00:00' AS SmallDateTime), CAST(N'1900-01-01 12:21:13.000' AS DateTime), CAST(N'1900-01-01 21:51:44.000' AS DateTime), N'Gopi Krishna Srinivasulu')
GO
INSERT [AT2].[tblAccessCardData] ([Id], [CardId], [Date], [InTime], [OutTime], [Name]) VALUES (107, N'01323704', CAST(N'2019-05-03 00:00:00' AS SmallDateTime), CAST(N'1900-01-01 11:59:48.000' AS DateTime), CAST(N'1900-01-01 22:35:27.000' AS DateTime), N'Gopi Krishna Srinivasulu')
GO
INSERT [AT2].[tblAccessCardData] ([Id], [CardId], [Date], [InTime], [OutTime], [Name]) VALUES (108, N'01323704', CAST(N'2019-05-06 00:00:00' AS SmallDateTime), CAST(N'1900-01-01 12:15:04.000' AS DateTime), CAST(N'1900-01-01 21:43:08.000' AS DateTime), N'Gopi Krishna Srinivasulu')
GO
INSERT [AT2].[tblAccessCardData] ([Id], [CardId], [Date], [InTime], [OutTime], [Name]) VALUES (109, N'01323704', CAST(N'2019-05-07 00:00:00' AS SmallDateTime), CAST(N'1900-01-01 11:36:25.000' AS DateTime), CAST(N'1900-01-01 21:55:24.000' AS DateTime), N'Gopi Krishna Srinivasulu')
GO
INSERT [AT2].[tblAccessCardData] ([Id], [CardId], [Date], [InTime], [OutTime], [Name]) VALUES (110, N'01323704', CAST(N'2019-05-08 00:00:00' AS SmallDateTime), CAST(N'1900-01-01 11:54:04.000' AS DateTime), CAST(N'1900-01-01 21:32:00.000' AS DateTime), N'Gopi Krishna Srinivasulu')
GO
INSERT [AT2].[tblAccessCardData] ([Id], [CardId], [Date], [InTime], [OutTime], [Name]) VALUES (111, N'01323704', CAST(N'2019-05-09 00:00:00' AS SmallDateTime), CAST(N'1900-01-01 11:19:38.000' AS DateTime), CAST(N'1900-01-01 22:24:38.000' AS DateTime), N'Gopi Krishna Srinivasulu')
GO
INSERT [AT2].[tblAccessCardData] ([Id], [CardId], [Date], [InTime], [OutTime], [Name]) VALUES (112, N'01323704', CAST(N'2019-05-10 00:00:00' AS SmallDateTime), CAST(N'1900-01-01 12:00:08.000' AS DateTime), CAST(N'1900-01-01 22:35:40.000' AS DateTime), N'Gopi Krishna Srinivasulu')
GO
INSERT [AT2].[tblAccessCardData] ([Id], [CardId], [Date], [InTime], [OutTime], [Name]) VALUES (113, N'01323704', CAST(N'2019-05-13 00:00:00' AS SmallDateTime), CAST(N'1900-01-01 11:48:40.000' AS DateTime), CAST(N'1900-01-01 22:28:53.000' AS DateTime), N'Gopi Krishna Srinivasulu')
GO
INSERT [AT2].[tblAccessCardData] ([Id], [CardId], [Date], [InTime], [OutTime], [Name]) VALUES (114, N'01323704', CAST(N'2019-05-14 00:00:00' AS SmallDateTime), CAST(N'1900-01-01 11:28:43.000' AS DateTime), CAST(N'1900-01-01 21:36:43.000' AS DateTime), N'Gopi Krishna Srinivasulu')
GO
INSERT [AT2].[tblAccessCardData] ([Id], [CardId], [Date], [InTime], [OutTime], [Name]) VALUES (115, N'01323704', CAST(N'2019-05-15 00:00:00' AS SmallDateTime), CAST(N'1900-01-01 12:59:08.000' AS DateTime), CAST(N'1900-01-01 22:00:09.000' AS DateTime), N'Gopi Krishna Srinivasulu')
GO
INSERT [AT2].[tblAccessCardData] ([Id], [CardId], [Date], [InTime], [OutTime], [Name]) VALUES (116, N'01323704', CAST(N'2019-05-16 00:00:00' AS SmallDateTime), CAST(N'1900-01-01 11:47:13.000' AS DateTime), CAST(N'1900-01-01 21:25:50.000' AS DateTime), N'Gopi Krishna Srinivasulu')
GO
INSERT [AT2].[tblAccessCardData] ([Id], [CardId], [Date], [InTime], [OutTime], [Name]) VALUES (117, N'01323704', CAST(N'2019-05-17 00:00:00' AS SmallDateTime), CAST(N'1900-01-01 12:14:22.000' AS DateTime), CAST(N'1900-01-01 21:26:41.000' AS DateTime), N'Gopi Krishna Srinivasulu')
GO
INSERT [AT2].[tblAccessCardData] ([Id], [CardId], [Date], [InTime], [OutTime], [Name]) VALUES (118, N'01323704', CAST(N'2019-05-20 00:00:00' AS SmallDateTime), CAST(N'1900-01-01 12:24:43.000' AS DateTime), CAST(N'1900-01-01 21:23:33.000' AS DateTime), N'Gopi Krishna Srinivasulu')
GO
INSERT [AT2].[tblAccessCardData] ([Id], [CardId], [Date], [InTime], [OutTime], [Name]) VALUES (119, N'10122948', CAST(N'2019-04-29 00:00:00' AS SmallDateTime), CAST(N'1900-01-01 12:05:43.000' AS DateTime), CAST(N'1900-01-01 20:32:35.000' AS DateTime), N'Pothu Naidu')
GO
INSERT [AT2].[tblAccessCardData] ([Id], [CardId], [Date], [InTime], [OutTime], [Name]) VALUES (120, N'10122948', CAST(N'2019-04-30 00:00:00' AS SmallDateTime), CAST(N'1900-01-01 11:59:54.000' AS DateTime), CAST(N'1900-01-01 19:43:21.000' AS DateTime), N'Pothu Naidu')
GO
INSERT [AT2].[tblAccessCardData] ([Id], [CardId], [Date], [InTime], [OutTime], [Name]) VALUES (121, N'10122948', CAST(N'2019-05-01 00:00:00' AS SmallDateTime), CAST(N'1900-01-01 11:48:02.000' AS DateTime), CAST(N'1900-01-01 20:47:16.000' AS DateTime), N'Pothu Naidu')
GO
INSERT [AT2].[tblAccessCardData] ([Id], [CardId], [Date], [InTime], [OutTime], [Name]) VALUES (122, N'10122948', CAST(N'2019-05-02 00:00:00' AS SmallDateTime), CAST(N'1900-01-01 12:09:40.000' AS DateTime), CAST(N'1900-01-01 20:02:57.000' AS DateTime), N'Pothu Naidu')
GO
INSERT [AT2].[tblAccessCardData] ([Id], [CardId], [Date], [InTime], [OutTime], [Name]) VALUES (123, N'10122948', CAST(N'2019-05-03 00:00:00' AS SmallDateTime), CAST(N'1900-01-01 11:59:41.000' AS DateTime), CAST(N'1900-01-01 22:22:01.000' AS DateTime), N'Pothu Naidu')
GO
INSERT [AT2].[tblAccessCardData] ([Id], [CardId], [Date], [InTime], [OutTime], [Name]) VALUES (124, N'10122948', CAST(N'2019-05-06 00:00:00' AS SmallDateTime), CAST(N'1900-01-01 11:53:58.000' AS DateTime), CAST(N'1900-01-01 21:28:21.000' AS DateTime), N'Pothu Naidu')
GO
INSERT [AT2].[tblAccessCardData] ([Id], [CardId], [Date], [InTime], [OutTime], [Name]) VALUES (125, N'10122948', CAST(N'2019-05-07 00:00:00' AS SmallDateTime), CAST(N'1900-01-01 11:36:22.000' AS DateTime), CAST(N'1900-01-01 20:39:56.000' AS DateTime), N'Pothu Naidu')
GO
INSERT [AT2].[tblAccessCardData] ([Id], [CardId], [Date], [InTime], [OutTime], [Name]) VALUES (126, N'10122948', CAST(N'2019-05-08 00:00:00' AS SmallDateTime), CAST(N'1900-01-01 12:16:18.000' AS DateTime), CAST(N'1900-01-01 21:29:04.000' AS DateTime), N'Pothu Naidu')
GO
INSERT [AT2].[tblAccessCardData] ([Id], [CardId], [Date], [InTime], [OutTime], [Name]) VALUES (127, N'10122948', CAST(N'2019-05-09 00:00:00' AS SmallDateTime), CAST(N'1900-01-01 11:51:13.000' AS DateTime), CAST(N'1900-01-01 21:35:56.000' AS DateTime), N'Pothu Naidu')
GO
INSERT [AT2].[tblAccessCardData] ([Id], [CardId], [Date], [InTime], [OutTime], [Name]) VALUES (128, N'10122948', CAST(N'2019-05-10 00:00:00' AS SmallDateTime), CAST(N'1900-01-01 10:25:29.000' AS DateTime), CAST(N'1900-01-01 21:14:16.000' AS DateTime), N'Pothu Naidu')
GO
INSERT [AT2].[tblAccessCardData] ([Id], [CardId], [Date], [InTime], [OutTime], [Name]) VALUES (129, N'10122948', CAST(N'2019-05-13 00:00:00' AS SmallDateTime), CAST(N'1900-01-01 13:58:49.000' AS DateTime), CAST(N'1900-01-01 22:08:05.000' AS DateTime), N'Pothu Naidu')
GO
INSERT [AT2].[tblAccessCardData] ([Id], [CardId], [Date], [InTime], [OutTime], [Name]) VALUES (130, N'10122948', CAST(N'2019-05-14 00:00:00' AS SmallDateTime), CAST(N'1900-01-01 11:32:05.000' AS DateTime), CAST(N'1900-01-01 21:15:39.000' AS DateTime), N'Pothu Naidu')
GO
INSERT [AT2].[tblAccessCardData] ([Id], [CardId], [Date], [InTime], [OutTime], [Name]) VALUES (131, N'10122948', CAST(N'2019-05-16 00:00:00' AS SmallDateTime), CAST(N'1900-01-01 12:13:14.000' AS DateTime), CAST(N'1900-01-01 21:14:07.000' AS DateTime), N'Pothu Naidu')
GO
INSERT [AT2].[tblAccessCardData] ([Id], [CardId], [Date], [InTime], [OutTime], [Name]) VALUES (132, N'10122948', CAST(N'2019-05-17 00:00:00' AS SmallDateTime), CAST(N'1900-01-01 11:27:25.000' AS DateTime), CAST(N'1900-01-01 20:32:47.000' AS DateTime), N'Pothu Naidu')
GO
INSERT [AT2].[tblAccessCardData] ([Id], [CardId], [Date], [InTime], [OutTime], [Name]) VALUES (133, N'10122948', CAST(N'2019-05-20 00:00:00' AS SmallDateTime), CAST(N'1900-01-01 12:14:33.000' AS DateTime), CAST(N'1900-01-01 21:08:35.000' AS DateTime), N'Pothu Naidu')
GO
INSERT [AT2].[tblAccessCardData] ([Id], [CardId], [Date], [InTime], [OutTime], [Name]) VALUES (134, N'08510910', CAST(N'2019-04-22 00:00:00' AS SmallDateTime), CAST(N'1900-01-01 11:25:38.000' AS DateTime), CAST(N'1900-01-01 21:22:30.000' AS DateTime), N'P Siva Krishna')
GO
INSERT [AT2].[tblAccessCardData] ([Id], [CardId], [Date], [InTime], [OutTime], [Name]) VALUES (135, N'08510910', CAST(N'2019-04-23 00:00:00' AS SmallDateTime), CAST(N'1900-01-01 11:41:00.000' AS DateTime), CAST(N'1900-01-01 18:30:28.000' AS DateTime), N'P Siva Krishna')
GO
INSERT [AT2].[tblAccessCardData] ([Id], [CardId], [Date], [InTime], [OutTime], [Name]) VALUES (136, N'08510910', CAST(N'2019-04-24 00:00:00' AS SmallDateTime), CAST(N'1900-01-01 21:38:19.000' AS DateTime), CAST(N'1900-01-01 00:00:00.000' AS DateTime), N'P Siva Krishna')
GO
INSERT [AT2].[tblAccessCardData] ([Id], [CardId], [Date], [InTime], [OutTime], [Name]) VALUES (137, N'08510910', CAST(N'2019-04-25 00:00:00' AS SmallDateTime), CAST(N'1900-01-01 11:56:15.000' AS DateTime), CAST(N'1900-01-01 21:32:48.000' AS DateTime), N'P Siva Krishna')
GO
INSERT [AT2].[tblAccessCardData] ([Id], [CardId], [Date], [InTime], [OutTime], [Name]) VALUES (138, N'08510910', CAST(N'2019-04-26 00:00:00' AS SmallDateTime), CAST(N'1900-01-01 11:13:20.000' AS DateTime), CAST(N'1900-01-01 21:10:31.000' AS DateTime), N'P Siva Krishna')
GO
INSERT [AT2].[tblAccessCardData] ([Id], [CardId], [Date], [InTime], [OutTime], [Name]) VALUES (139, N'08510910', CAST(N'2019-04-29 00:00:00' AS SmallDateTime), CAST(N'1900-01-01 19:04:09.000' AS DateTime), CAST(N'1900-01-01 21:27:44.000' AS DateTime), N'P Siva Krishna')
GO
INSERT [AT2].[tblAccessCardData] ([Id], [CardId], [Date], [InTime], [OutTime], [Name]) VALUES (140, N'08510910', CAST(N'2019-04-30 00:00:00' AS SmallDateTime), CAST(N'1900-01-01 11:58:28.000' AS DateTime), CAST(N'1900-01-01 21:28:58.000' AS DateTime), N'P Siva Krishna')
GO
INSERT [AT2].[tblAccessCardData] ([Id], [CardId], [Date], [InTime], [OutTime], [Name]) VALUES (141, N'08510910', CAST(N'2019-05-01 00:00:00' AS SmallDateTime), CAST(N'1900-01-01 12:09:53.000' AS DateTime), CAST(N'1900-01-01 22:02:57.000' AS DateTime), N'P Siva Krishna')
GO
INSERT [AT2].[tblAccessCardData] ([Id], [CardId], [Date], [InTime], [OutTime], [Name]) VALUES (142, N'08510910', CAST(N'2019-05-02 00:00:00' AS SmallDateTime), CAST(N'1900-01-01 11:46:22.000' AS DateTime), CAST(N'1900-01-01 22:40:04.000' AS DateTime), N'P Siva Krishna')
GO
INSERT [AT2].[tblAccessCardData] ([Id], [CardId], [Date], [InTime], [OutTime], [Name]) VALUES (143, N'08510910', CAST(N'2019-05-03 00:00:00' AS SmallDateTime), CAST(N'1900-01-01 11:56:02.000' AS DateTime), CAST(N'1900-01-01 13:11:00.000' AS DateTime), N'P Siva Krishna')
GO
INSERT [AT2].[tblAccessCardData] ([Id], [CardId], [Date], [InTime], [OutTime], [Name]) VALUES (144, N'08510910', CAST(N'2019-05-06 00:00:00' AS SmallDateTime), CAST(N'1900-01-01 12:27:53.000' AS DateTime), CAST(N'1900-01-01 21:35:40.000' AS DateTime), N'P Siva Krishna')
GO
INSERT [AT2].[tblAccessCardData] ([Id], [CardId], [Date], [InTime], [OutTime], [Name]) VALUES (145, N'08510910', CAST(N'2019-05-07 00:00:00' AS SmallDateTime), CAST(N'1900-01-01 11:58:53.000' AS DateTime), CAST(N'1900-01-01 21:50:35.000' AS DateTime), N'P Siva Krishna')
GO
INSERT [AT2].[tblAccessCardData] ([Id], [CardId], [Date], [InTime], [OutTime], [Name]) VALUES (146, N'08510910', CAST(N'2019-05-08 00:00:00' AS SmallDateTime), CAST(N'1900-01-01 11:31:20.000' AS DateTime), CAST(N'1900-01-01 17:43:54.000' AS DateTime), N'P Siva Krishna')
GO
INSERT [AT2].[tblAccessCardData] ([Id], [CardId], [Date], [InTime], [OutTime], [Name]) VALUES (147, N'08510910', CAST(N'2019-05-09 00:00:00' AS SmallDateTime), CAST(N'1900-01-01 11:55:54.000' AS DateTime), CAST(N'1900-01-01 22:26:25.000' AS DateTime), N'P Siva Krishna')
GO
INSERT [AT2].[tblAccessCardData] ([Id], [CardId], [Date], [InTime], [OutTime], [Name]) VALUES (148, N'08510910', CAST(N'2019-05-10 00:00:00' AS SmallDateTime), CAST(N'1900-01-01 12:15:58.000' AS DateTime), CAST(N'1900-01-01 21:56:13.000' AS DateTime), N'P Siva Krishna')
GO
INSERT [AT2].[tblAccessCardData] ([Id], [CardId], [Date], [InTime], [OutTime], [Name]) VALUES (149, N'08510910', CAST(N'2019-05-13 00:00:00' AS SmallDateTime), CAST(N'1900-01-01 12:15:16.000' AS DateTime), CAST(N'1900-01-01 22:01:10.000' AS DateTime), N'P Siva Krishna')
GO
INSERT [AT2].[tblAccessCardData] ([Id], [CardId], [Date], [InTime], [OutTime], [Name]) VALUES (150, N'08510910', CAST(N'2019-05-14 00:00:00' AS SmallDateTime), CAST(N'1900-01-01 12:29:54.000' AS DateTime), CAST(N'1900-01-01 22:00:26.000' AS DateTime), N'P Siva Krishna')
GO
INSERT [AT2].[tblAccessCardData] ([Id], [CardId], [Date], [InTime], [OutTime], [Name]) VALUES (151, N'08510910', CAST(N'2019-05-15 00:00:00' AS SmallDateTime), CAST(N'1900-01-01 12:52:48.000' AS DateTime), CAST(N'1900-01-01 22:06:43.000' AS DateTime), N'P Siva Krishna')
GO
INSERT [AT2].[tblAccessCardData] ([Id], [CardId], [Date], [InTime], [OutTime], [Name]) VALUES (152, N'08510910', CAST(N'2019-05-16 00:00:00' AS SmallDateTime), CAST(N'1900-01-01 12:34:17.000' AS DateTime), CAST(N'1900-01-01 22:11:15.000' AS DateTime), N'P Siva Krishna')
GO
INSERT [AT2].[tblAccessCardData] ([Id], [CardId], [Date], [InTime], [OutTime], [Name]) VALUES (153, N'08510910', CAST(N'2019-05-20 00:00:00' AS SmallDateTime), CAST(N'1900-01-01 12:40:46.000' AS DateTime), CAST(N'1900-01-01 21:59:28.000' AS DateTime), N'P Siva Krishna')
GO
INSERT [AT2].[tblAccessCardData] ([Id], [CardId], [Date], [InTime], [OutTime], [Name]) VALUES (154, N'01269979', CAST(N'2019-04-22 00:00:00' AS SmallDateTime), CAST(N'1900-01-01 11:30:22.000' AS DateTime), CAST(N'1900-01-01 21:36:32.000' AS DateTime), N'Niteesh Chandra N')
GO
INSERT [AT2].[tblAccessCardData] ([Id], [CardId], [Date], [InTime], [OutTime], [Name]) VALUES (155, N'01269979', CAST(N'2019-04-23 00:00:00' AS SmallDateTime), CAST(N'1900-01-01 11:21:21.000' AS DateTime), CAST(N'1900-01-01 21:20:33.000' AS DateTime), N'Niteesh Chandra N')
GO
INSERT [AT2].[tblAccessCardData] ([Id], [CardId], [Date], [InTime], [OutTime], [Name]) VALUES (156, N'01269979', CAST(N'2019-04-24 00:00:00' AS SmallDateTime), CAST(N'1900-01-01 11:32:51.000' AS DateTime), CAST(N'1900-01-01 21:20:16.000' AS DateTime), N'Niteesh Chandra N')
GO
INSERT [AT2].[tblAccessCardData] ([Id], [CardId], [Date], [InTime], [OutTime], [Name]) VALUES (157, N'01269979', CAST(N'2019-04-25 00:00:00' AS SmallDateTime), CAST(N'1900-01-01 11:37:43.000' AS DateTime), CAST(N'1900-01-01 22:16:52.000' AS DateTime), N'Niteesh Chandra N')
GO
INSERT [AT2].[tblAccessCardData] ([Id], [CardId], [Date], [InTime], [OutTime], [Name]) VALUES (158, N'01269979', CAST(N'2019-04-26 00:00:00' AS SmallDateTime), CAST(N'1900-01-01 11:32:05.000' AS DateTime), CAST(N'1900-01-01 21:44:22.000' AS DateTime), N'Niteesh Chandra N')
GO
INSERT [AT2].[tblAccessCardData] ([Id], [CardId], [Date], [InTime], [OutTime], [Name]) VALUES (159, N'01269979', CAST(N'2019-04-29 00:00:00' AS SmallDateTime), CAST(N'1900-01-01 11:27:33.000' AS DateTime), CAST(N'1900-01-01 21:38:58.000' AS DateTime), N'Niteesh Chandra N')
GO
INSERT [AT2].[tblAccessCardData] ([Id], [CardId], [Date], [InTime], [OutTime], [Name]) VALUES (160, N'01269979', CAST(N'2019-04-30 00:00:00' AS SmallDateTime), CAST(N'1900-01-01 11:38:43.000' AS DateTime), CAST(N'1900-01-01 21:46:37.000' AS DateTime), N'Niteesh Chandra N')
GO
INSERT [AT2].[tblAccessCardData] ([Id], [CardId], [Date], [InTime], [OutTime], [Name]) VALUES (161, N'01269979', CAST(N'2019-05-01 00:00:00' AS SmallDateTime), CAST(N'1900-01-01 11:27:04.000' AS DateTime), CAST(N'1900-01-01 21:53:01.000' AS DateTime), N'Niteesh Chandra N')
GO
INSERT [AT2].[tblAccessCardData] ([Id], [CardId], [Date], [InTime], [OutTime], [Name]) VALUES (162, N'01269979', CAST(N'2019-05-02 00:00:00' AS SmallDateTime), CAST(N'1900-01-01 11:39:28.000' AS DateTime), CAST(N'1900-01-01 22:03:56.000' AS DateTime), N'Niteesh Chandra N')
GO
INSERT [AT2].[tblAccessCardData] ([Id], [CardId], [Date], [InTime], [OutTime], [Name]) VALUES (163, N'01269979', CAST(N'2019-05-03 00:00:00' AS SmallDateTime), CAST(N'1900-01-01 11:42:55.000' AS DateTime), CAST(N'1900-01-01 22:00:34.000' AS DateTime), N'Niteesh Chandra N')
GO
INSERT [AT2].[tblAccessCardData] ([Id], [CardId], [Date], [InTime], [OutTime], [Name]) VALUES (164, N'01269979', CAST(N'2019-05-06 00:00:00' AS SmallDateTime), CAST(N'1900-01-01 11:37:01.000' AS DateTime), CAST(N'1900-01-01 21:58:30.000' AS DateTime), N'Niteesh Chandra N')
GO
INSERT [AT2].[tblAccessCardData] ([Id], [CardId], [Date], [InTime], [OutTime], [Name]) VALUES (165, N'01269979', CAST(N'2019-05-07 00:00:00' AS SmallDateTime), CAST(N'1900-01-01 11:38:13.000' AS DateTime), CAST(N'1900-01-01 21:31:15.000' AS DateTime), N'Niteesh Chandra N')
GO
INSERT [AT2].[tblAccessCardData] ([Id], [CardId], [Date], [InTime], [OutTime], [Name]) VALUES (166, N'01269979', CAST(N'2019-05-08 00:00:00' AS SmallDateTime), CAST(N'1900-01-01 11:40:56.000' AS DateTime), CAST(N'1900-01-01 21:27:43.000' AS DateTime), N'Niteesh Chandra N')
GO
INSERT [AT2].[tblAccessCardData] ([Id], [CardId], [Date], [InTime], [OutTime], [Name]) VALUES (167, N'01269979', CAST(N'2019-05-09 00:00:00' AS SmallDateTime), CAST(N'1900-01-01 11:36:10.000' AS DateTime), CAST(N'1900-01-01 22:23:35.000' AS DateTime), N'Niteesh Chandra N')
GO
INSERT [AT2].[tblAccessCardData] ([Id], [CardId], [Date], [InTime], [OutTime], [Name]) VALUES (168, N'01269979', CAST(N'2019-05-10 00:00:00' AS SmallDateTime), CAST(N'1900-01-01 11:27:38.000' AS DateTime), CAST(N'1900-01-01 22:57:58.000' AS DateTime), N'Niteesh Chandra N')
GO
INSERT [AT2].[tblAccessCardData] ([Id], [CardId], [Date], [InTime], [OutTime], [Name]) VALUES (169, N'01269979', CAST(N'2019-05-13 00:00:00' AS SmallDateTime), CAST(N'1900-01-01 11:40:51.000' AS DateTime), CAST(N'1900-01-01 21:57:34.000' AS DateTime), N'Niteesh Chandra N')
GO
INSERT [AT2].[tblAccessCardData] ([Id], [CardId], [Date], [InTime], [OutTime], [Name]) VALUES (170, N'01269979', CAST(N'2019-05-14 00:00:00' AS SmallDateTime), CAST(N'1900-01-01 11:23:47.000' AS DateTime), CAST(N'1900-01-01 22:45:16.000' AS DateTime), N'Niteesh Chandra N')
GO
INSERT [AT2].[tblAccessCardData] ([Id], [CardId], [Date], [InTime], [OutTime], [Name]) VALUES (171, N'01269979', CAST(N'2019-05-15 00:00:00' AS SmallDateTime), CAST(N'1900-01-01 11:25:11.000' AS DateTime), CAST(N'1900-01-01 22:05:40.000' AS DateTime), N'Niteesh Chandra N')
GO
INSERT [AT2].[tblAccessCardData] ([Id], [CardId], [Date], [InTime], [OutTime], [Name]) VALUES (172, N'01269979', CAST(N'2019-05-16 00:00:00' AS SmallDateTime), CAST(N'1900-01-01 11:48:35.000' AS DateTime), CAST(N'1900-01-01 21:33:21.000' AS DateTime), N'Niteesh Chandra N')
GO
INSERT [AT2].[tblAccessCardData] ([Id], [CardId], [Date], [InTime], [OutTime], [Name]) VALUES (173, N'01269979', CAST(N'2019-05-17 00:00:00' AS SmallDateTime), CAST(N'1900-01-01 11:27:31.000' AS DateTime), CAST(N'1900-01-01 21:27:34.000' AS DateTime), N'Niteesh Chandra N')
GO
INSERT [AT2].[tblAccessCardData] ([Id], [CardId], [Date], [InTime], [OutTime], [Name]) VALUES (174, N'01269979', CAST(N'2019-05-20 00:00:00' AS SmallDateTime), CAST(N'1900-01-01 11:27:23.000' AS DateTime), CAST(N'1900-01-01 21:33:55.000' AS DateTime), N'Niteesh Chandra N')
GO
INSERT [AT2].[tblAccessCardData] ([Id], [CardId], [Date], [InTime], [OutTime], [Name]) VALUES (175, N'10127634', CAST(N'2019-04-22 00:00:00' AS SmallDateTime), CAST(N'1900-01-01 11:48:24.000' AS DateTime), CAST(N'1900-01-01 21:47:35.000' AS DateTime), N'K Reena')
GO
INSERT [AT2].[tblAccessCardData] ([Id], [CardId], [Date], [InTime], [OutTime], [Name]) VALUES (176, N'10127634', CAST(N'2019-04-23 00:00:00' AS SmallDateTime), CAST(N'1900-01-01 21:41:33.000' AS DateTime), CAST(N'1900-01-01 00:00:00.000' AS DateTime), N'K Reena')
GO
INSERT [AT2].[tblAccessCardData] ([Id], [CardId], [Date], [InTime], [OutTime], [Name]) VALUES (177, N'10127634', CAST(N'2019-04-24 00:00:00' AS SmallDateTime), CAST(N'1900-01-01 12:14:58.000' AS DateTime), CAST(N'1900-01-01 21:32:57.000' AS DateTime), N'K Reena')
GO
INSERT [AT2].[tblAccessCardData] ([Id], [CardId], [Date], [InTime], [OutTime], [Name]) VALUES (178, N'10127634', CAST(N'2019-04-25 00:00:00' AS SmallDateTime), CAST(N'1900-01-01 11:23:49.000' AS DateTime), CAST(N'1900-01-01 21:37:55.000' AS DateTime), N'K Reena')
GO
INSERT [AT2].[tblAccessCardData] ([Id], [CardId], [Date], [InTime], [OutTime], [Name]) VALUES (179, N'10127634', CAST(N'2019-04-26 00:00:00' AS SmallDateTime), CAST(N'1900-01-01 11:50:02.000' AS DateTime), CAST(N'1900-01-01 22:11:21.000' AS DateTime), N'K Reena')
GO
INSERT [AT2].[tblAccessCardData] ([Id], [CardId], [Date], [InTime], [OutTime], [Name]) VALUES (180, N'10127634', CAST(N'2019-04-29 00:00:00' AS SmallDateTime), CAST(N'1900-01-01 11:44:50.000' AS DateTime), CAST(N'1900-01-01 21:12:12.000' AS DateTime), N'K Reena')
GO
INSERT [AT2].[tblAccessCardData] ([Id], [CardId], [Date], [InTime], [OutTime], [Name]) VALUES (181, N'10127634', CAST(N'2019-04-30 00:00:00' AS SmallDateTime), CAST(N'1900-01-01 12:14:35.000' AS DateTime), CAST(N'1900-01-01 22:00:43.000' AS DateTime), N'K Reena')
GO
INSERT [AT2].[tblAccessCardData] ([Id], [CardId], [Date], [InTime], [OutTime], [Name]) VALUES (182, N'10127634', CAST(N'2019-05-01 00:00:00' AS SmallDateTime), CAST(N'1900-01-01 11:36:46.000' AS DateTime), CAST(N'1900-01-01 21:44:08.000' AS DateTime), N'K Reena')
GO
INSERT [AT2].[tblAccessCardData] ([Id], [CardId], [Date], [InTime], [OutTime], [Name]) VALUES (183, N'10127634', CAST(N'2019-05-02 00:00:00' AS SmallDateTime), CAST(N'1900-01-01 11:59:53.000' AS DateTime), CAST(N'1900-01-01 13:51:08.000' AS DateTime), N'K Reena')
GO
INSERT [AT2].[tblAccessCardData] ([Id], [CardId], [Date], [InTime], [OutTime], [Name]) VALUES (184, N'10127634', CAST(N'2019-05-03 00:00:00' AS SmallDateTime), CAST(N'1900-01-01 11:58:27.000' AS DateTime), CAST(N'1900-01-01 14:47:42.000' AS DateTime), N'K Reena')
GO
INSERT [AT2].[tblAccessCardData] ([Id], [CardId], [Date], [InTime], [OutTime], [Name]) VALUES (185, N'10127634', CAST(N'2019-05-06 00:00:00' AS SmallDateTime), CAST(N'1900-01-01 13:59:07.000' AS DateTime), CAST(N'1900-01-01 21:34:00.000' AS DateTime), N'K Reena')
GO
INSERT [AT2].[tblAccessCardData] ([Id], [CardId], [Date], [InTime], [OutTime], [Name]) VALUES (186, N'10127634', CAST(N'2019-05-07 00:00:00' AS SmallDateTime), CAST(N'1900-01-01 11:55:51.000' AS DateTime), CAST(N'1900-01-01 21:38:25.000' AS DateTime), N'K Reena')
GO
INSERT [AT2].[tblAccessCardData] ([Id], [CardId], [Date], [InTime], [OutTime], [Name]) VALUES (187, N'10127634', CAST(N'2019-05-08 00:00:00' AS SmallDateTime), CAST(N'1900-01-01 12:04:22.000' AS DateTime), CAST(N'1900-01-01 21:44:14.000' AS DateTime), N'K Reena')
GO
INSERT [AT2].[tblAccessCardData] ([Id], [CardId], [Date], [InTime], [OutTime], [Name]) VALUES (188, N'10127634', CAST(N'2019-05-09 00:00:00' AS SmallDateTime), CAST(N'1900-01-01 12:01:19.000' AS DateTime), CAST(N'1900-01-01 22:25:55.000' AS DateTime), N'K Reena')
GO
INSERT [AT2].[tblAccessCardData] ([Id], [CardId], [Date], [InTime], [OutTime], [Name]) VALUES (189, N'10127634', CAST(N'2019-05-10 00:00:00' AS SmallDateTime), CAST(N'1900-01-01 12:06:26.000' AS DateTime), CAST(N'1900-01-01 22:09:21.000' AS DateTime), N'K Reena')
GO
INSERT [AT2].[tblAccessCardData] ([Id], [CardId], [Date], [InTime], [OutTime], [Name]) VALUES (190, N'10127634', CAST(N'2019-05-13 00:00:00' AS SmallDateTime), CAST(N'1900-01-01 17:30:42.000' AS DateTime), CAST(N'1900-01-01 21:46:52.000' AS DateTime), N'K Reena')
GO
INSERT [AT2].[tblAccessCardData] ([Id], [CardId], [Date], [InTime], [OutTime], [Name]) VALUES (191, N'10127634', CAST(N'2019-05-14 00:00:00' AS SmallDateTime), CAST(N'1900-01-01 12:01:12.000' AS DateTime), CAST(N'1900-01-01 22:44:40.000' AS DateTime), N'K Reena')
GO
INSERT [AT2].[tblAccessCardData] ([Id], [CardId], [Date], [InTime], [OutTime], [Name]) VALUES (192, N'10127634', CAST(N'2019-05-15 00:00:00' AS SmallDateTime), CAST(N'1900-01-01 12:10:58.000' AS DateTime), CAST(N'1900-01-01 21:46:52.000' AS DateTime), N'K Reena')
GO
INSERT [AT2].[tblAccessCardData] ([Id], [CardId], [Date], [InTime], [OutTime], [Name]) VALUES (193, N'10127634', CAST(N'2019-05-16 00:00:00' AS SmallDateTime), CAST(N'1900-01-01 13:01:39.000' AS DateTime), CAST(N'1900-01-01 21:38:47.000' AS DateTime), N'K Reena')
GO
INSERT [AT2].[tblAccessCardData] ([Id], [CardId], [Date], [InTime], [OutTime], [Name]) VALUES (194, N'10127634', CAST(N'2019-05-17 00:00:00' AS SmallDateTime), CAST(N'1900-01-01 12:10:20.000' AS DateTime), CAST(N'1900-01-01 21:31:53.000' AS DateTime), N'K Reena')
GO
INSERT [AT2].[tblAccessCardData] ([Id], [CardId], [Date], [InTime], [OutTime], [Name]) VALUES (195, N'10127634', CAST(N'2019-05-20 00:00:00' AS SmallDateTime), CAST(N'1900-01-01 12:29:24.000' AS DateTime), CAST(N'1900-01-01 21:38:27.000' AS DateTime), N'K Reena')
GO
INSERT [AT2].[tblAccessCardData] ([Id], [CardId], [Date], [InTime], [OutTime], [Name]) VALUES (196, N'01778655', CAST(N'2019-04-22 00:00:00' AS SmallDateTime), CAST(N'1900-01-01 11:37:53.000' AS DateTime), CAST(N'1900-01-01 18:26:13.000' AS DateTime), N'Seshagiri Rao B')
GO
INSERT [AT2].[tblAccessCardData] ([Id], [CardId], [Date], [InTime], [OutTime], [Name]) VALUES (197, N'01778655', CAST(N'2019-04-23 00:00:00' AS SmallDateTime), CAST(N'1900-01-01 11:30:11.000' AS DateTime), CAST(N'1900-01-01 17:36:08.000' AS DateTime), N'Seshagiri Rao B')
GO
INSERT [AT2].[tblAccessCardData] ([Id], [CardId], [Date], [InTime], [OutTime], [Name]) VALUES (198, N'01778655', CAST(N'2019-04-24 00:00:00' AS SmallDateTime), CAST(N'1900-01-01 11:21:32.000' AS DateTime), CAST(N'1900-01-01 15:32:54.000' AS DateTime), N'Seshagiri Rao B')
GO
INSERT [AT2].[tblAccessCardData] ([Id], [CardId], [Date], [InTime], [OutTime], [Name]) VALUES (199, N'01778655', CAST(N'2019-04-25 00:00:00' AS SmallDateTime), CAST(N'1900-01-01 11:34:04.000' AS DateTime), CAST(N'1900-01-01 15:20:30.000' AS DateTime), N'Seshagiri Rao B')
GO
INSERT [AT2].[tblAccessCardData] ([Id], [CardId], [Date], [InTime], [OutTime], [Name]) VALUES (200, N'01778655', CAST(N'2019-04-26 00:00:00' AS SmallDateTime), CAST(N'1900-01-01 11:36:07.000' AS DateTime), CAST(N'1900-01-01 21:10:44.000' AS DateTime), N'Seshagiri Rao B')
GO
INSERT [AT2].[tblAccessCardData] ([Id], [CardId], [Date], [InTime], [OutTime], [Name]) VALUES (201, N'01778655', CAST(N'2019-04-30 00:00:00' AS SmallDateTime), CAST(N'1900-01-01 11:26:35.000' AS DateTime), CAST(N'1900-01-01 17:45:35.000' AS DateTime), N'Seshagiri Rao B')
GO
INSERT [AT2].[tblAccessCardData] ([Id], [CardId], [Date], [InTime], [OutTime], [Name]) VALUES (202, N'01778655', CAST(N'2019-05-01 00:00:00' AS SmallDateTime), CAST(N'1900-01-01 12:17:10.000' AS DateTime), CAST(N'1900-01-01 21:21:37.000' AS DateTime), N'Seshagiri Rao B')
GO
INSERT [AT2].[tblAccessCardData] ([Id], [CardId], [Date], [InTime], [OutTime], [Name]) VALUES (203, N'01778655', CAST(N'2019-05-02 00:00:00' AS SmallDateTime), CAST(N'1900-01-01 11:34:59.000' AS DateTime), CAST(N'1900-01-01 21:35:51.000' AS DateTime), N'Seshagiri Rao B')
GO
INSERT [AT2].[tblAccessCardData] ([Id], [CardId], [Date], [InTime], [OutTime], [Name]) VALUES (204, N'01778655', CAST(N'2019-05-03 00:00:00' AS SmallDateTime), CAST(N'1900-01-01 11:36:48.000' AS DateTime), CAST(N'1900-01-01 18:53:30.000' AS DateTime), N'Seshagiri Rao B')
GO
INSERT [AT2].[tblAccessCardData] ([Id], [CardId], [Date], [InTime], [OutTime], [Name]) VALUES (205, N'01778655', CAST(N'2019-05-06 00:00:00' AS SmallDateTime), CAST(N'1900-01-01 12:03:11.000' AS DateTime), CAST(N'1900-01-01 21:05:20.000' AS DateTime), N'Seshagiri Rao B')
GO
INSERT [AT2].[tblAccessCardData] ([Id], [CardId], [Date], [InTime], [OutTime], [Name]) VALUES (206, N'01778655', CAST(N'2019-05-08 00:00:00' AS SmallDateTime), CAST(N'1900-01-01 10:47:44.000' AS DateTime), CAST(N'1900-01-01 21:23:44.000' AS DateTime), N'Seshagiri Rao B')
GO
INSERT [AT2].[tblAccessCardData] ([Id], [CardId], [Date], [InTime], [OutTime], [Name]) VALUES (207, N'01778655', CAST(N'2019-05-09 00:00:00' AS SmallDateTime), CAST(N'1900-01-01 10:54:37.000' AS DateTime), CAST(N'1900-01-01 21:19:02.000' AS DateTime), N'Seshagiri Rao B')
GO
INSERT [AT2].[tblAccessCardData] ([Id], [CardId], [Date], [InTime], [OutTime], [Name]) VALUES (208, N'01778655', CAST(N'2019-05-10 00:00:00' AS SmallDateTime), CAST(N'1900-01-01 11:08:53.000' AS DateTime), CAST(N'1900-01-01 21:33:16.000' AS DateTime), N'Seshagiri Rao B')
GO
INSERT [AT2].[tblAccessCardData] ([Id], [CardId], [Date], [InTime], [OutTime], [Name]) VALUES (209, N'01778655', CAST(N'2019-05-13 00:00:00' AS SmallDateTime), CAST(N'1900-01-01 11:17:29.000' AS DateTime), CAST(N'1900-01-01 21:05:51.000' AS DateTime), N'Seshagiri Rao B')
GO
INSERT [AT2].[tblAccessCardData] ([Id], [CardId], [Date], [InTime], [OutTime], [Name]) VALUES (210, N'01778655', CAST(N'2019-05-14 00:00:00' AS SmallDateTime), CAST(N'1900-01-01 11:10:31.000' AS DateTime), CAST(N'1900-01-01 21:14:40.000' AS DateTime), N'Seshagiri Rao B')
GO
INSERT [AT2].[tblAccessCardData] ([Id], [CardId], [Date], [InTime], [OutTime], [Name]) VALUES (211, N'01778655', CAST(N'2019-05-15 00:00:00' AS SmallDateTime), CAST(N'1900-01-01 11:23:58.000' AS DateTime), CAST(N'1900-01-01 21:09:25.000' AS DateTime), N'Seshagiri Rao B')
GO
INSERT [AT2].[tblAccessCardData] ([Id], [CardId], [Date], [InTime], [OutTime], [Name]) VALUES (212, N'01778655', CAST(N'2019-05-16 00:00:00' AS SmallDateTime), CAST(N'1900-01-01 11:21:23.000' AS DateTime), CAST(N'1900-01-01 21:10:48.000' AS DateTime), N'Seshagiri Rao B')
GO
INSERT [AT2].[tblAccessCardData] ([Id], [CardId], [Date], [InTime], [OutTime], [Name]) VALUES (213, N'01778655', CAST(N'2019-05-17 00:00:00' AS SmallDateTime), CAST(N'1900-01-01 11:21:40.000' AS DateTime), CAST(N'1900-01-01 20:49:24.000' AS DateTime), N'Seshagiri Rao B')
GO
INSERT [AT2].[tblAccessCardData] ([Id], [CardId], [Date], [InTime], [OutTime], [Name]) VALUES (214, N'01778655', CAST(N'2019-05-20 00:00:00' AS SmallDateTime), CAST(N'1900-01-01 11:13:47.000' AS DateTime), CAST(N'1900-01-01 21:10:53.000' AS DateTime), N'Seshagiri Rao B')
GO
INSERT [AT2].[tblAccessCardData] ([Id], [CardId], [Date], [InTime], [OutTime], [Name]) VALUES (215, N'08426768', CAST(N'2019-04-22 00:00:00' AS SmallDateTime), CAST(N'1900-01-01 11:42:11.000' AS DateTime), CAST(N'1900-01-01 20:16:52.000' AS DateTime), N'Vidyanand K')
GO
INSERT [AT2].[tblAccessCardData] ([Id], [CardId], [Date], [InTime], [OutTime], [Name]) VALUES (216, N'08426768', CAST(N'2019-04-23 00:00:00' AS SmallDateTime), CAST(N'1900-01-01 10:28:11.000' AS DateTime), CAST(N'1900-01-01 20:21:56.000' AS DateTime), N'Vidyanand K')
GO
INSERT [AT2].[tblAccessCardData] ([Id], [CardId], [Date], [InTime], [OutTime], [Name]) VALUES (217, N'08426768', CAST(N'2019-04-24 00:00:00' AS SmallDateTime), CAST(N'1900-01-01 10:34:51.000' AS DateTime), CAST(N'1900-01-01 20:59:00.000' AS DateTime), N'Vidyanand K')
GO
INSERT [AT2].[tblAccessCardData] ([Id], [CardId], [Date], [InTime], [OutTime], [Name]) VALUES (218, N'08426768', CAST(N'2019-04-25 00:00:00' AS SmallDateTime), CAST(N'1900-01-01 10:48:59.000' AS DateTime), CAST(N'1900-01-01 20:20:01.000' AS DateTime), N'Vidyanand K')
GO
INSERT [AT2].[tblAccessCardData] ([Id], [CardId], [Date], [InTime], [OutTime], [Name]) VALUES (219, N'08426768', CAST(N'2019-04-26 00:00:00' AS SmallDateTime), CAST(N'1900-01-01 10:53:59.000' AS DateTime), CAST(N'1900-01-01 20:23:39.000' AS DateTime), N'Vidyanand K')
GO
INSERT [AT2].[tblAccessCardData] ([Id], [CardId], [Date], [InTime], [OutTime], [Name]) VALUES (220, N'08426768', CAST(N'2019-04-29 00:00:00' AS SmallDateTime), CAST(N'1900-01-01 10:41:07.000' AS DateTime), CAST(N'1900-01-01 18:00:16.000' AS DateTime), N'Vidyanand K')
GO
INSERT [AT2].[tblAccessCardData] ([Id], [CardId], [Date], [InTime], [OutTime], [Name]) VALUES (221, N'08426768', CAST(N'2019-04-30 00:00:00' AS SmallDateTime), CAST(N'1900-01-01 10:44:49.000' AS DateTime), CAST(N'1900-01-01 20:18:11.000' AS DateTime), N'Vidyanand K')
GO
INSERT [AT2].[tblAccessCardData] ([Id], [CardId], [Date], [InTime], [OutTime], [Name]) VALUES (222, N'08426768', CAST(N'2019-05-01 00:00:00' AS SmallDateTime), CAST(N'1900-01-01 10:49:41.000' AS DateTime), CAST(N'1900-01-01 20:32:21.000' AS DateTime), N'Vidyanand K')
GO
INSERT [AT2].[tblAccessCardData] ([Id], [CardId], [Date], [InTime], [OutTime], [Name]) VALUES (223, N'08426768', CAST(N'2019-05-02 00:00:00' AS SmallDateTime), CAST(N'1900-01-01 10:48:55.000' AS DateTime), CAST(N'1900-01-01 20:21:33.000' AS DateTime), N'Vidyanand K')
GO
INSERT [AT2].[tblAccessCardData] ([Id], [CardId], [Date], [InTime], [OutTime], [Name]) VALUES (224, N'08426768', CAST(N'2019-05-03 00:00:00' AS SmallDateTime), CAST(N'1900-01-01 10:17:46.000' AS DateTime), CAST(N'1900-01-01 20:15:18.000' AS DateTime), N'Vidyanand K')
GO
INSERT [AT2].[tblAccessCardData] ([Id], [CardId], [Date], [InTime], [OutTime], [Name]) VALUES (225, N'08426768', CAST(N'2019-05-06 00:00:00' AS SmallDateTime), CAST(N'1900-01-01 10:34:31.000' AS DateTime), CAST(N'1900-01-01 20:12:55.000' AS DateTime), N'Vidyanand K')
GO
INSERT [AT2].[tblAccessCardData] ([Id], [CardId], [Date], [InTime], [OutTime], [Name]) VALUES (226, N'08426768', CAST(N'2019-05-07 00:00:00' AS SmallDateTime), CAST(N'1900-01-01 10:45:15.000' AS DateTime), CAST(N'1900-01-01 20:24:40.000' AS DateTime), N'Vidyanand K')
GO
INSERT [AT2].[tblAccessCardData] ([Id], [CardId], [Date], [InTime], [OutTime], [Name]) VALUES (227, N'08426768', CAST(N'2019-05-08 00:00:00' AS SmallDateTime), CAST(N'1900-01-01 10:40:13.000' AS DateTime), CAST(N'1900-01-01 19:40:48.000' AS DateTime), N'Vidyanand K')
GO
INSERT [AT2].[tblAccessCardData] ([Id], [CardId], [Date], [InTime], [OutTime], [Name]) VALUES (228, N'08426768', CAST(N'2019-05-09 00:00:00' AS SmallDateTime), CAST(N'1900-01-01 10:22:27.000' AS DateTime), CAST(N'1900-01-01 20:20:49.000' AS DateTime), N'Vidyanand K')
GO
INSERT [AT2].[tblAccessCardData] ([Id], [CardId], [Date], [InTime], [OutTime], [Name]) VALUES (229, N'08426768', CAST(N'2019-05-10 00:00:00' AS SmallDateTime), CAST(N'1900-01-01 10:20:18.000' AS DateTime), CAST(N'1900-01-01 20:10:34.000' AS DateTime), N'Vidyanand K')
GO
INSERT [AT2].[tblAccessCardData] ([Id], [CardId], [Date], [InTime], [OutTime], [Name]) VALUES (230, N'08426768', CAST(N'2019-05-14 00:00:00' AS SmallDateTime), CAST(N'1900-01-01 11:02:47.000' AS DateTime), CAST(N'1900-01-01 20:49:46.000' AS DateTime), N'Vidyanand K')
GO
INSERT [AT2].[tblAccessCardData] ([Id], [CardId], [Date], [InTime], [OutTime], [Name]) VALUES (231, N'08426768', CAST(N'2019-05-15 00:00:00' AS SmallDateTime), CAST(N'1900-01-01 11:27:40.000' AS DateTime), CAST(N'1900-01-01 18:02:13.000' AS DateTime), N'Vidyanand K')
GO
INSERT [AT2].[tblAccessCardData] ([Id], [CardId], [Date], [InTime], [OutTime], [Name]) VALUES (232, N'08426768', CAST(N'2019-05-16 00:00:00' AS SmallDateTime), CAST(N'1900-01-01 10:49:40.000' AS DateTime), CAST(N'1900-01-01 20:41:44.000' AS DateTime), N'Vidyanand K')
GO
INSERT [AT2].[tblAccessCardData] ([Id], [CardId], [Date], [InTime], [OutTime], [Name]) VALUES (233, N'08426768', CAST(N'2019-05-17 00:00:00' AS SmallDateTime), CAST(N'1900-01-01 10:27:28.000' AS DateTime), CAST(N'1900-01-01 19:55:41.000' AS DateTime), N'Vidyanand K')
GO
INSERT [AT2].[tblAccessCardData] ([Id], [CardId], [Date], [InTime], [OutTime], [Name]) VALUES (234, N'08426768', CAST(N'2019-05-20 00:00:00' AS SmallDateTime), CAST(N'1900-01-01 11:42:52.000' AS DateTime), CAST(N'1900-01-01 20:19:46.000' AS DateTime), N'Vidyanand K')
GO
INSERT [AT2].[tblAccessCardData] ([Id], [CardId], [Date], [InTime], [OutTime], [Name]) VALUES (235, N'08512221', CAST(N'2019-04-22 00:00:00' AS SmallDateTime), CAST(N'1900-01-01 13:21:04.000' AS DateTime), CAST(N'1900-01-01 14:37:26.000' AS DateTime), N'Challapalli Rama Aditya')
GO
INSERT [AT2].[tblAccessCardData] ([Id], [CardId], [Date], [InTime], [OutTime], [Name]) VALUES (236, N'08512221', CAST(N'2019-04-23 00:00:00' AS SmallDateTime), CAST(N'1900-01-01 10:55:21.000' AS DateTime), CAST(N'1900-01-01 21:05:57.000' AS DateTime), N'Challapalli Rama Aditya')
GO
INSERT [AT2].[tblAccessCardData] ([Id], [CardId], [Date], [InTime], [OutTime], [Name]) VALUES (237, N'08512221', CAST(N'2019-04-24 00:00:00' AS SmallDateTime), CAST(N'1900-01-01 11:04:33.000' AS DateTime), CAST(N'1900-01-01 21:38:13.000' AS DateTime), N'Challapalli Rama Aditya')
GO
INSERT [AT2].[tblAccessCardData] ([Id], [CardId], [Date], [InTime], [OutTime], [Name]) VALUES (238, N'08512221', CAST(N'2019-04-25 00:00:00' AS SmallDateTime), CAST(N'1900-01-01 11:02:10.000' AS DateTime), CAST(N'1900-01-01 21:32:35.000' AS DateTime), N'Challapalli Rama Aditya')
GO
INSERT [AT2].[tblAccessCardData] ([Id], [CardId], [Date], [InTime], [OutTime], [Name]) VALUES (239, N'08512221', CAST(N'2019-04-26 00:00:00' AS SmallDateTime), CAST(N'1900-01-01 11:04:57.000' AS DateTime), CAST(N'1900-01-01 21:10:25.000' AS DateTime), N'Challapalli Rama Aditya')
GO
INSERT [AT2].[tblAccessCardData] ([Id], [CardId], [Date], [InTime], [OutTime], [Name]) VALUES (240, N'08512221', CAST(N'2019-04-29 00:00:00' AS SmallDateTime), CAST(N'1900-01-01 10:55:45.000' AS DateTime), CAST(N'1900-01-01 21:27:38.000' AS DateTime), N'Challapalli Rama Aditya')
GO
INSERT [AT2].[tblAccessCardData] ([Id], [CardId], [Date], [InTime], [OutTime], [Name]) VALUES (241, N'08512221', CAST(N'2019-04-30 00:00:00' AS SmallDateTime), CAST(N'1900-01-01 10:58:16.000' AS DateTime), CAST(N'1900-01-01 21:28:50.000' AS DateTime), N'Challapalli Rama Aditya')
GO
INSERT [AT2].[tblAccessCardData] ([Id], [CardId], [Date], [InTime], [OutTime], [Name]) VALUES (242, N'08512221', CAST(N'2019-05-01 00:00:00' AS SmallDateTime), CAST(N'1900-01-01 10:54:47.000' AS DateTime), CAST(N'1900-01-01 22:02:48.000' AS DateTime), N'Challapalli Rama Aditya')
GO
INSERT [AT2].[tblAccessCardData] ([Id], [CardId], [Date], [InTime], [OutTime], [Name]) VALUES (243, N'08512221', CAST(N'2019-05-02 00:00:00' AS SmallDateTime), CAST(N'1900-01-01 10:56:07.000' AS DateTime), CAST(N'1900-01-01 22:40:00.000' AS DateTime), N'Challapalli Rama Aditya')
GO
INSERT [AT2].[tblAccessCardData] ([Id], [CardId], [Date], [InTime], [OutTime], [Name]) VALUES (244, N'08512221', CAST(N'2019-05-03 00:00:00' AS SmallDateTime), CAST(N'1900-01-01 10:58:06.000' AS DateTime), CAST(N'1900-01-01 21:59:05.000' AS DateTime), N'Challapalli Rama Aditya')
GO
INSERT [AT2].[tblAccessCardData] ([Id], [CardId], [Date], [InTime], [OutTime], [Name]) VALUES (245, N'08512221', CAST(N'2019-05-06 00:00:00' AS SmallDateTime), CAST(N'1900-01-01 11:01:28.000' AS DateTime), CAST(N'1900-01-01 21:35:34.000' AS DateTime), N'Challapalli Rama Aditya')
GO
INSERT [AT2].[tblAccessCardData] ([Id], [CardId], [Date], [InTime], [OutTime], [Name]) VALUES (246, N'08512221', CAST(N'2019-05-07 00:00:00' AS SmallDateTime), CAST(N'1900-01-01 10:57:44.000' AS DateTime), CAST(N'1900-01-01 21:50:29.000' AS DateTime), N'Challapalli Rama Aditya')
GO
INSERT [AT2].[tblAccessCardData] ([Id], [CardId], [Date], [InTime], [OutTime], [Name]) VALUES (247, N'08512221', CAST(N'2019-05-08 00:00:00' AS SmallDateTime), CAST(N'1900-01-01 10:58:03.000' AS DateTime), CAST(N'1900-01-01 21:26:28.000' AS DateTime), N'Challapalli Rama Aditya')
GO
INSERT [AT2].[tblAccessCardData] ([Id], [CardId], [Date], [InTime], [OutTime], [Name]) VALUES (248, N'08512221', CAST(N'2019-05-09 00:00:00' AS SmallDateTime), CAST(N'1900-01-01 10:31:25.000' AS DateTime), CAST(N'1900-01-01 22:26:21.000' AS DateTime), N'Challapalli Rama Aditya')
GO
INSERT [AT2].[tblAccessCardData] ([Id], [CardId], [Date], [InTime], [OutTime], [Name]) VALUES (249, N'08512221', CAST(N'2019-05-10 00:00:00' AS SmallDateTime), CAST(N'1900-01-01 11:02:18.000' AS DateTime), CAST(N'1900-01-01 21:58:32.000' AS DateTime), N'Challapalli Rama Aditya')
GO
INSERT [AT2].[tblAccessCardData] ([Id], [CardId], [Date], [InTime], [OutTime], [Name]) VALUES (250, N'08512221', CAST(N'2019-05-13 00:00:00' AS SmallDateTime), CAST(N'1900-01-01 10:57:46.000' AS DateTime), CAST(N'1900-01-01 22:00:57.000' AS DateTime), N'Challapalli Rama Aditya')
GO
INSERT [AT2].[tblAccessCardData] ([Id], [CardId], [Date], [InTime], [OutTime], [Name]) VALUES (251, N'08512221', CAST(N'2019-05-14 00:00:00' AS SmallDateTime), CAST(N'1900-01-01 11:05:02.000' AS DateTime), CAST(N'1900-01-01 22:00:16.000' AS DateTime), N'Challapalli Rama Aditya')
GO
INSERT [AT2].[tblAccessCardData] ([Id], [CardId], [Date], [InTime], [OutTime], [Name]) VALUES (252, N'08512221', CAST(N'2019-05-15 00:00:00' AS SmallDateTime), CAST(N'1900-01-01 11:00:04.000' AS DateTime), CAST(N'1900-01-01 22:06:37.000' AS DateTime), N'Challapalli Rama Aditya')
GO
INSERT [AT2].[tblAccessCardData] ([Id], [CardId], [Date], [InTime], [OutTime], [Name]) VALUES (253, N'08512221', CAST(N'2019-05-16 00:00:00' AS SmallDateTime), CAST(N'1900-01-01 10:58:42.000' AS DateTime), CAST(N'1900-01-01 22:11:03.000' AS DateTime), N'Challapalli Rama Aditya')
GO
INSERT [AT2].[tblAccessCardData] ([Id], [CardId], [Date], [InTime], [OutTime], [Name]) VALUES (254, N'08512221', CAST(N'2019-05-17 00:00:00' AS SmallDateTime), CAST(N'1900-01-01 11:01:04.000' AS DateTime), CAST(N'1900-01-01 21:01:04.000' AS DateTime), N'Challapalli Rama Aditya')
GO
INSERT [AT2].[tblAccessCardData] ([Id], [CardId], [Date], [InTime], [OutTime], [Name]) VALUES (255, N'08512221', CAST(N'2019-05-20 00:00:00' AS SmallDateTime), CAST(N'1900-01-01 10:57:34.000' AS DateTime), CAST(N'1900-01-01 21:59:13.000' AS DateTime), N'Challapalli Rama Aditya')
GO
SET IDENTITY_INSERT [AT2].[tblAccessCardData] OFF
GO
SET IDENTITY_INSERT [AT2].[tblAttendance] ON 

GO
INSERT [AT2].[tblAttendance] ([ID], [Date], [EmployeeID], [InTime], [OutTime], [Leave], [LeaveType], [PermissionHrs], [ExtraHrsWorked], [WorkFromHome], [CreatedBy], [CreatedDateTime]) VALUES (3296, CAST(N'2019-04-26 00:00:00' AS SmallDateTime), 52, CAST(N'10:00:00' AS Time), CAST(N'20:20:00' AS Time), -1, N'-1', CAST(N'00:00:00' AS Time), CAST(N'00:00:00' AS Time), -1, N'3', CAST(N'2019-04-29 13:14:51.590' AS DateTime))
GO
INSERT [AT2].[tblAttendance] ([ID], [Date], [EmployeeID], [InTime], [OutTime], [Leave], [LeaveType], [PermissionHrs], [ExtraHrsWorked], [WorkFromHome], [CreatedBy], [CreatedDateTime]) VALUES (3302, CAST(N'2019-04-26 16:18:00' AS SmallDateTime), 54, CAST(N'00:00:00' AS Time), CAST(N'00:00:00' AS Time), 2, N'1 ', CAST(N'00:00:00' AS Time), CAST(N'00:00:00' AS Time), -1, N'3', CAST(N'2019-04-29 13:14:51.590' AS DateTime))
GO
INSERT [AT2].[tblAttendance] ([ID], [Date], [EmployeeID], [InTime], [OutTime], [Leave], [LeaveType], [PermissionHrs], [ExtraHrsWorked], [WorkFromHome], [CreatedBy], [CreatedDateTime]) VALUES (3312, CAST(N'2019-04-26 19:28:00' AS SmallDateTime), 53, CAST(N'10:20:00' AS Time), CAST(N'20:15:00' AS Time), -1, N'-1', CAST(N'00:00:00' AS Time), CAST(N'00:00:00' AS Time), -1, N'3', CAST(N'2019-04-29 13:14:51.590' AS DateTime))
GO
INSERT [AT2].[tblAttendance] ([ID], [Date], [EmployeeID], [InTime], [OutTime], [Leave], [LeaveType], [PermissionHrs], [ExtraHrsWorked], [WorkFromHome], [CreatedBy], [CreatedDateTime]) VALUES (3313, CAST(N'2019-04-29 00:00:00' AS SmallDateTime), 52, CAST(N'10:30:00' AS Time), CAST(N'20:20:00' AS Time), -1, N'-1', CAST(N'00:00:00' AS Time), CAST(N'00:00:00' AS Time), -1, N'3', CAST(N'2019-04-29 19:24:34.110' AS DateTime))
GO
INSERT [AT2].[tblAttendance] ([ID], [Date], [EmployeeID], [InTime], [OutTime], [Leave], [LeaveType], [PermissionHrs], [ExtraHrsWorked], [WorkFromHome], [CreatedBy], [CreatedDateTime]) VALUES (3315, CAST(N'2019-04-29 12:36:00' AS SmallDateTime), 3, CAST(N'12:36:00' AS Time), CAST(N'22:00:00' AS Time), -1, N'-1', CAST(N'00:00:00' AS Time), CAST(N'00:00:00' AS Time), -1, N'3', CAST(N'2019-04-29 19:24:34.110' AS DateTime))
GO
INSERT [AT2].[tblAttendance] ([ID], [Date], [EmployeeID], [InTime], [OutTime], [Leave], [LeaveType], [PermissionHrs], [ExtraHrsWorked], [WorkFromHome], [CreatedBy], [CreatedDateTime]) VALUES (3316, CAST(N'2019-04-26 00:00:00' AS SmallDateTime), 3, CAST(N'12:20:00' AS Time), CAST(N'22:00:00' AS Time), -1, N'-1', CAST(N'00:00:00' AS Time), CAST(N'00:00:00' AS Time), -1, N'3', CAST(N'2019-04-29 13:14:51.590' AS DateTime))
GO
INSERT [AT2].[tblAttendance] ([ID], [Date], [EmployeeID], [InTime], [OutTime], [Leave], [LeaveType], [PermissionHrs], [ExtraHrsWorked], [WorkFromHome], [CreatedBy], [CreatedDateTime]) VALUES (3317, CAST(N'2019-04-29 14:44:00' AS SmallDateTime), 53, CAST(N'14:43:00' AS Time), CAST(N'14:44:00' AS Time), -1, N'-1', CAST(N'00:00:00' AS Time), CAST(N'00:00:00' AS Time), -1, N'3', CAST(N'2019-04-29 19:24:34.110' AS DateTime))
GO
INSERT [AT2].[tblAttendance] ([ID], [Date], [EmployeeID], [InTime], [OutTime], [Leave], [LeaveType], [PermissionHrs], [ExtraHrsWorked], [WorkFromHome], [CreatedBy], [CreatedDateTime]) VALUES (3318, CAST(N'2019-04-29 19:48:00' AS SmallDateTime), 54, CAST(N'12:23:00' AS Time), CAST(N'22:12:00' AS Time), -1, N'-1', CAST(N'00:00:00' AS Time), CAST(N'00:00:00' AS Time), -1, N'3', CAST(N'2019-05-01 15:42:11.070' AS DateTime))
GO
INSERT [AT2].[tblAttendance] ([ID], [Date], [EmployeeID], [InTime], [OutTime], [Leave], [LeaveType], [PermissionHrs], [ExtraHrsWorked], [WorkFromHome], [CreatedBy], [CreatedDateTime]) VALUES (3319, CAST(N'2019-04-30 00:00:00' AS SmallDateTime), 52, CAST(N'09:50:00' AS Time), CAST(N'20:15:00' AS Time), -1, N'-1', CAST(N'00:00:00' AS Time), CAST(N'00:00:00' AS Time), -1, N'3', CAST(N'2019-04-30 15:52:52.193' AS DateTime))
GO
INSERT [AT2].[tblAttendance] ([ID], [Date], [EmployeeID], [InTime], [OutTime], [Leave], [LeaveType], [PermissionHrs], [ExtraHrsWorked], [WorkFromHome], [CreatedBy], [CreatedDateTime]) VALUES (3320, CAST(N'2019-04-30 11:45:00' AS SmallDateTime), 54, CAST(N'11:56:00' AS Time), CAST(N'21:47:00' AS Time), -1, N'-1', CAST(N'00:00:00' AS Time), CAST(N'00:00:00' AS Time), -1, N'3', CAST(N'2019-05-01 15:42:11.070' AS DateTime))
GO
INSERT [AT2].[tblAttendance] ([ID], [Date], [EmployeeID], [InTime], [OutTime], [Leave], [LeaveType], [PermissionHrs], [ExtraHrsWorked], [WorkFromHome], [CreatedBy], [CreatedDateTime]) VALUES (3321, CAST(N'2019-04-30 00:00:00' AS SmallDateTime), 3, CAST(N'12:20:00' AS Time), CAST(N'22:00:00' AS Time), -1, N'-1', CAST(N'00:00:00' AS Time), CAST(N'00:00:00' AS Time), -1, N'3', CAST(N'2019-04-30 15:52:52.193' AS DateTime))
GO
INSERT [AT2].[tblAttendance] ([ID], [Date], [EmployeeID], [InTime], [OutTime], [Leave], [LeaveType], [PermissionHrs], [ExtraHrsWorked], [WorkFromHome], [CreatedBy], [CreatedDateTime]) VALUES (3322, CAST(N'2019-04-30 19:44:00' AS SmallDateTime), 53, CAST(N'19:44:00' AS Time), CAST(N'19:45:00' AS Time), NULL, NULL, NULL, CAST(N'00:00:00' AS Time), NULL, N'reshma', CAST(N'2019-04-30 19:44:28.317' AS DateTime))
GO
INSERT [AT2].[tblAttendance] ([ID], [Date], [EmployeeID], [InTime], [OutTime], [Leave], [LeaveType], [PermissionHrs], [ExtraHrsWorked], [WorkFromHome], [CreatedBy], [CreatedDateTime]) VALUES (3323, CAST(N'2019-05-01 10:32:00' AS SmallDateTime), 54, CAST(N'10:31:00' AS Time), CAST(N'11:41:00' AS Time), -1, N'-1', CAST(N'00:00:00' AS Time), CAST(N'00:00:00' AS Time), -1, N'3', CAST(N'2019-05-10 16:53:04.067' AS DateTime))
GO
INSERT [AT2].[tblAttendance] ([ID], [Date], [EmployeeID], [InTime], [OutTime], [Leave], [LeaveType], [PermissionHrs], [ExtraHrsWorked], [WorkFromHome], [CreatedBy], [CreatedDateTime]) VALUES (3324, CAST(N'2019-05-01 10:56:00' AS SmallDateTime), 53, CAST(N'10:16:00' AS Time), CAST(N'20:41:00' AS Time), -1, N'-1', CAST(N'00:00:00' AS Time), CAST(N'00:00:00' AS Time), -1, N'3', CAST(N'2019-05-10 16:53:04.067' AS DateTime))
GO
INSERT [AT2].[tblAttendance] ([ID], [Date], [EmployeeID], [InTime], [OutTime], [Leave], [LeaveType], [PermissionHrs], [ExtraHrsWorked], [WorkFromHome], [CreatedBy], [CreatedDateTime]) VALUES (3325, CAST(N'2019-05-01 00:00:00' AS SmallDateTime), 52, CAST(N'10:15:00' AS Time), CAST(N'20:12:00' AS Time), -1, N'-1', CAST(N'00:00:00' AS Time), CAST(N'00:00:00' AS Time), -1, N'3', CAST(N'2019-05-10 16:53:04.067' AS DateTime))
GO
INSERT [AT2].[tblAttendance] ([ID], [Date], [EmployeeID], [InTime], [OutTime], [Leave], [LeaveType], [PermissionHrs], [ExtraHrsWorked], [WorkFromHome], [CreatedBy], [CreatedDateTime]) VALUES (3327, CAST(N'2019-05-01 14:31:00' AS SmallDateTime), 3, CAST(N'12:08:00' AS Time), CAST(N'22:09:00' AS Time), -1, N'-1', CAST(N'00:00:00' AS Time), CAST(N'00:00:00' AS Time), -1, N'3', CAST(N'2019-05-10 16:53:04.067' AS DateTime))
GO
INSERT [AT2].[tblAttendance] ([ID], [Date], [EmployeeID], [InTime], [OutTime], [Leave], [LeaveType], [PermissionHrs], [ExtraHrsWorked], [WorkFromHome], [CreatedBy], [CreatedDateTime]) VALUES (3328, CAST(N'2019-04-26 00:00:00' AS SmallDateTime), 50, CAST(N'11:04:00' AS Time), CAST(N'21:10:00' AS Time), -1, N'-1', CAST(N'00:00:00' AS Time), CAST(N'00:00:00' AS Time), -1, N'3', CAST(N'2019-05-01 15:38:12.710' AS DateTime))
GO
INSERT [AT2].[tblAttendance] ([ID], [Date], [EmployeeID], [InTime], [OutTime], [Leave], [LeaveType], [PermissionHrs], [ExtraHrsWorked], [WorkFromHome], [CreatedBy], [CreatedDateTime]) VALUES (3329, CAST(N'2019-04-29 00:00:00' AS SmallDateTime), 50, CAST(N'10:55:00' AS Time), CAST(N'21:27:00' AS Time), -1, N'-1', CAST(N'00:00:00' AS Time), CAST(N'00:00:00' AS Time), -1, N'3', CAST(N'2019-05-01 15:38:12.710' AS DateTime))
GO
INSERT [AT2].[tblAttendance] ([ID], [Date], [EmployeeID], [InTime], [OutTime], [Leave], [LeaveType], [PermissionHrs], [ExtraHrsWorked], [WorkFromHome], [CreatedBy], [CreatedDateTime]) VALUES (3330, CAST(N'2019-04-30 00:00:00' AS SmallDateTime), 50, CAST(N'10:58:00' AS Time), CAST(N'21:28:00' AS Time), -1, N'-1', CAST(N'00:00:00' AS Time), CAST(N'00:00:00' AS Time), -1, N'3', CAST(N'2019-05-01 15:38:12.710' AS DateTime))
GO
INSERT [AT2].[tblAttendance] ([ID], [Date], [EmployeeID], [InTime], [OutTime], [Leave], [LeaveType], [PermissionHrs], [ExtraHrsWorked], [WorkFromHome], [CreatedBy], [CreatedDateTime]) VALUES (3331, CAST(N'2019-04-26 00:00:00' AS SmallDateTime), 1, CAST(N'00:00:00' AS Time), CAST(N'00:00:00' AS Time), 2, N'1 ', CAST(N'00:00:00' AS Time), CAST(N'00:00:00' AS Time), -1, N'3', CAST(N'2019-05-01 15:39:08.103' AS DateTime))
GO
INSERT [AT2].[tblAttendance] ([ID], [Date], [EmployeeID], [InTime], [OutTime], [Leave], [LeaveType], [PermissionHrs], [ExtraHrsWorked], [WorkFromHome], [CreatedBy], [CreatedDateTime]) VALUES (3332, CAST(N'2019-04-29 00:00:00' AS SmallDateTime), 1, CAST(N'00:00:00' AS Time), CAST(N'00:00:00' AS Time), 2, N'1 ', CAST(N'00:00:00' AS Time), CAST(N'00:00:00' AS Time), -1, N'3', CAST(N'2019-05-01 15:39:08.103' AS DateTime))
GO
INSERT [AT2].[tblAttendance] ([ID], [Date], [EmployeeID], [InTime], [OutTime], [Leave], [LeaveType], [PermissionHrs], [ExtraHrsWorked], [WorkFromHome], [CreatedBy], [CreatedDateTime]) VALUES (3333, CAST(N'2019-04-30 00:00:00' AS SmallDateTime), 1, CAST(N'00:00:00' AS Time), CAST(N'00:00:00' AS Time), 2, N'1 ', CAST(N'00:00:00' AS Time), CAST(N'00:00:00' AS Time), -1, N'3', CAST(N'2019-05-01 15:39:08.103' AS DateTime))
GO
INSERT [AT2].[tblAttendance] ([ID], [Date], [EmployeeID], [InTime], [OutTime], [Leave], [LeaveType], [PermissionHrs], [ExtraHrsWorked], [WorkFromHome], [CreatedBy], [CreatedDateTime]) VALUES (3334, CAST(N'2019-05-01 00:00:00' AS SmallDateTime), 1, CAST(N'00:00:00' AS Time), CAST(N'00:00:00' AS Time), 2, N'1 ', CAST(N'00:00:00' AS Time), CAST(N'00:00:00' AS Time), -1, N'3', CAST(N'2019-05-10 16:53:04.067' AS DateTime))
GO
INSERT [AT2].[tblAttendance] ([ID], [Date], [EmployeeID], [InTime], [OutTime], [Leave], [LeaveType], [PermissionHrs], [ExtraHrsWorked], [WorkFromHome], [CreatedBy], [CreatedDateTime]) VALUES (3335, CAST(N'2019-04-29 00:00:00' AS SmallDateTime), 13, CAST(N'12:05:00' AS Time), CAST(N'20:32:00' AS Time), -1, N'-1', CAST(N'00:00:00' AS Time), CAST(N'00:00:00' AS Time), -1, N'3', CAST(N'2019-05-01 15:39:29.040' AS DateTime))
GO
INSERT [AT2].[tblAttendance] ([ID], [Date], [EmployeeID], [InTime], [OutTime], [Leave], [LeaveType], [PermissionHrs], [ExtraHrsWorked], [WorkFromHome], [CreatedBy], [CreatedDateTime]) VALUES (3336, CAST(N'2019-04-30 00:00:00' AS SmallDateTime), 13, CAST(N'11:59:00' AS Time), CAST(N'19:43:00' AS Time), -1, N'-1', CAST(N'00:00:00' AS Time), CAST(N'00:00:00' AS Time), -1, N'3', CAST(N'2019-05-01 15:39:29.040' AS DateTime))
GO
INSERT [AT2].[tblAttendance] ([ID], [Date], [EmployeeID], [InTime], [OutTime], [Leave], [LeaveType], [PermissionHrs], [ExtraHrsWorked], [WorkFromHome], [CreatedBy], [CreatedDateTime]) VALUES (3337, CAST(N'2019-04-26 00:00:00' AS SmallDateTime), 13, CAST(N'00:00:00' AS Time), CAST(N'00:00:00' AS Time), 2, N'1 ', CAST(N'00:00:00' AS Time), CAST(N'00:00:00' AS Time), -1, N'3', CAST(N'2019-05-01 15:39:29.040' AS DateTime))
GO
INSERT [AT2].[tblAttendance] ([ID], [Date], [EmployeeID], [InTime], [OutTime], [Leave], [LeaveType], [PermissionHrs], [ExtraHrsWorked], [WorkFromHome], [CreatedBy], [CreatedDateTime]) VALUES (3338, CAST(N'2019-04-26 00:00:00' AS SmallDateTime), 28, CAST(N'10:53:00' AS Time), CAST(N'20:23:00' AS Time), -1, N'-1', CAST(N'00:00:00' AS Time), CAST(N'00:00:00' AS Time), -1, N'3', CAST(N'2019-05-01 15:39:40.077' AS DateTime))
GO
INSERT [AT2].[tblAttendance] ([ID], [Date], [EmployeeID], [InTime], [OutTime], [Leave], [LeaveType], [PermissionHrs], [ExtraHrsWorked], [WorkFromHome], [CreatedBy], [CreatedDateTime]) VALUES (3339, CAST(N'2019-04-29 00:00:00' AS SmallDateTime), 28, CAST(N'10:41:00' AS Time), CAST(N'18:00:00' AS Time), -1, N'-1', CAST(N'00:00:00' AS Time), CAST(N'00:00:00' AS Time), -1, N'3', CAST(N'2019-05-01 15:39:40.077' AS DateTime))
GO
INSERT [AT2].[tblAttendance] ([ID], [Date], [EmployeeID], [InTime], [OutTime], [Leave], [LeaveType], [PermissionHrs], [ExtraHrsWorked], [WorkFromHome], [CreatedBy], [CreatedDateTime]) VALUES (3340, CAST(N'2019-04-30 00:00:00' AS SmallDateTime), 28, CAST(N'10:44:00' AS Time), CAST(N'20:18:00' AS Time), -1, N'-1', CAST(N'00:00:00' AS Time), CAST(N'00:00:00' AS Time), -1, N'3', CAST(N'2019-05-01 15:39:40.077' AS DateTime))
GO
INSERT [AT2].[tblAttendance] ([ID], [Date], [EmployeeID], [InTime], [OutTime], [Leave], [LeaveType], [PermissionHrs], [ExtraHrsWorked], [WorkFromHome], [CreatedBy], [CreatedDateTime]) VALUES (3341, CAST(N'2019-04-26 00:00:00' AS SmallDateTime), 29, CAST(N'12:18:00' AS Time), CAST(N'21:58:00' AS Time), -1, N'-1', CAST(N'00:00:00' AS Time), CAST(N'00:00:00' AS Time), -1, N'3', CAST(N'2019-05-01 15:39:48.050' AS DateTime))
GO
INSERT [AT2].[tblAttendance] ([ID], [Date], [EmployeeID], [InTime], [OutTime], [Leave], [LeaveType], [PermissionHrs], [ExtraHrsWorked], [WorkFromHome], [CreatedBy], [CreatedDateTime]) VALUES (3342, CAST(N'2019-04-29 00:00:00' AS SmallDateTime), 29, CAST(N'11:19:00' AS Time), CAST(N'21:39:00' AS Time), -1, N'-1', CAST(N'00:00:00' AS Time), CAST(N'00:00:00' AS Time), -1, N'3', CAST(N'2019-05-01 15:39:48.050' AS DateTime))
GO
INSERT [AT2].[tblAttendance] ([ID], [Date], [EmployeeID], [InTime], [OutTime], [Leave], [LeaveType], [PermissionHrs], [ExtraHrsWorked], [WorkFromHome], [CreatedBy], [CreatedDateTime]) VALUES (3343, CAST(N'2019-04-30 00:00:00' AS SmallDateTime), 29, CAST(N'11:29:00' AS Time), CAST(N'21:46:00' AS Time), -1, N'-1', CAST(N'00:00:00' AS Time), CAST(N'00:00:00' AS Time), -1, N'3', CAST(N'2019-05-01 15:39:48.050' AS DateTime))
GO
INSERT [AT2].[tblAttendance] ([ID], [Date], [EmployeeID], [InTime], [OutTime], [Leave], [LeaveType], [PermissionHrs], [ExtraHrsWorked], [WorkFromHome], [CreatedBy], [CreatedDateTime]) VALUES (3344, CAST(N'2019-04-26 00:00:00' AS SmallDateTime), 34, CAST(N'11:13:00' AS Time), CAST(N'21:10:00' AS Time), -1, N'-1', CAST(N'00:00:00' AS Time), CAST(N'00:00:00' AS Time), -1, N'3', CAST(N'2019-05-01 15:39:58.513' AS DateTime))
GO
INSERT [AT2].[tblAttendance] ([ID], [Date], [EmployeeID], [InTime], [OutTime], [Leave], [LeaveType], [PermissionHrs], [ExtraHrsWorked], [WorkFromHome], [CreatedBy], [CreatedDateTime]) VALUES (3345, CAST(N'2019-04-29 00:00:00' AS SmallDateTime), 34, CAST(N'19:04:00' AS Time), CAST(N'21:27:00' AS Time), -1, N'-1', CAST(N'00:00:00' AS Time), CAST(N'00:00:00' AS Time), -1, N'3', CAST(N'2019-05-01 15:39:58.513' AS DateTime))
GO
INSERT [AT2].[tblAttendance] ([ID], [Date], [EmployeeID], [InTime], [OutTime], [Leave], [LeaveType], [PermissionHrs], [ExtraHrsWorked], [WorkFromHome], [CreatedBy], [CreatedDateTime]) VALUES (3346, CAST(N'2019-04-30 00:00:00' AS SmallDateTime), 34, CAST(N'11:58:00' AS Time), CAST(N'21:28:00' AS Time), -1, N'-1', CAST(N'00:00:00' AS Time), CAST(N'00:00:00' AS Time), -1, N'3', CAST(N'2019-05-01 15:39:58.513' AS DateTime))
GO
INSERT [AT2].[tblAttendance] ([ID], [Date], [EmployeeID], [InTime], [OutTime], [Leave], [LeaveType], [PermissionHrs], [ExtraHrsWorked], [WorkFromHome], [CreatedBy], [CreatedDateTime]) VALUES (3347, CAST(N'2019-04-26 00:00:00' AS SmallDateTime), 35, CAST(N'11:32:00' AS Time), CAST(N'21:44:00' AS Time), -1, N'-1', CAST(N'00:00:00' AS Time), CAST(N'00:00:00' AS Time), -1, N'3', CAST(N'2019-05-01 15:40:05.463' AS DateTime))
GO
INSERT [AT2].[tblAttendance] ([ID], [Date], [EmployeeID], [InTime], [OutTime], [Leave], [LeaveType], [PermissionHrs], [ExtraHrsWorked], [WorkFromHome], [CreatedBy], [CreatedDateTime]) VALUES (3348, CAST(N'2019-04-29 00:00:00' AS SmallDateTime), 35, CAST(N'11:27:00' AS Time), CAST(N'21:38:00' AS Time), -1, N'-1', CAST(N'00:00:00' AS Time), CAST(N'00:00:00' AS Time), -1, N'3', CAST(N'2019-05-01 15:40:05.463' AS DateTime))
GO
INSERT [AT2].[tblAttendance] ([ID], [Date], [EmployeeID], [InTime], [OutTime], [Leave], [LeaveType], [PermissionHrs], [ExtraHrsWorked], [WorkFromHome], [CreatedBy], [CreatedDateTime]) VALUES (3349, CAST(N'2019-04-30 00:00:00' AS SmallDateTime), 35, CAST(N'11:38:00' AS Time), CAST(N'21:46:00' AS Time), -1, N'-1', CAST(N'00:00:00' AS Time), CAST(N'00:00:00' AS Time), -1, N'3', CAST(N'2019-05-01 15:40:05.463' AS DateTime))
GO
INSERT [AT2].[tblAttendance] ([ID], [Date], [EmployeeID], [InTime], [OutTime], [Leave], [LeaveType], [PermissionHrs], [ExtraHrsWorked], [WorkFromHome], [CreatedBy], [CreatedDateTime]) VALUES (3350, CAST(N'2019-04-26 00:00:00' AS SmallDateTime), 40, CAST(N'11:50:00' AS Time), CAST(N'22:11:00' AS Time), -1, N'-1', CAST(N'00:00:00' AS Time), CAST(N'00:00:00' AS Time), -1, N'3', CAST(N'2019-05-01 15:40:13.033' AS DateTime))
GO
INSERT [AT2].[tblAttendance] ([ID], [Date], [EmployeeID], [InTime], [OutTime], [Leave], [LeaveType], [PermissionHrs], [ExtraHrsWorked], [WorkFromHome], [CreatedBy], [CreatedDateTime]) VALUES (3351, CAST(N'2019-04-29 00:00:00' AS SmallDateTime), 40, CAST(N'11:44:00' AS Time), CAST(N'21:12:00' AS Time), -1, N'-1', CAST(N'00:00:00' AS Time), CAST(N'00:00:00' AS Time), -1, N'3', CAST(N'2019-05-01 15:40:13.033' AS DateTime))
GO
INSERT [AT2].[tblAttendance] ([ID], [Date], [EmployeeID], [InTime], [OutTime], [Leave], [LeaveType], [PermissionHrs], [ExtraHrsWorked], [WorkFromHome], [CreatedBy], [CreatedDateTime]) VALUES (3352, CAST(N'2019-04-30 00:00:00' AS SmallDateTime), 40, CAST(N'12:14:00' AS Time), CAST(N'22:00:00' AS Time), -1, N'-1', CAST(N'00:00:00' AS Time), CAST(N'00:00:00' AS Time), -1, N'3', CAST(N'2019-05-01 15:40:13.033' AS DateTime))
GO
INSERT [AT2].[tblAttendance] ([ID], [Date], [EmployeeID], [InTime], [OutTime], [Leave], [LeaveType], [PermissionHrs], [ExtraHrsWorked], [WorkFromHome], [CreatedBy], [CreatedDateTime]) VALUES (3353, CAST(N'2019-04-26 00:00:00' AS SmallDateTime), 43, CAST(N'11:36:00' AS Time), CAST(N'21:10:00' AS Time), -1, N'-1', CAST(N'00:00:00' AS Time), CAST(N'00:00:00' AS Time), -1, N'3', CAST(N'2019-05-01 15:40:41.710' AS DateTime))
GO
INSERT [AT2].[tblAttendance] ([ID], [Date], [EmployeeID], [InTime], [OutTime], [Leave], [LeaveType], [PermissionHrs], [ExtraHrsWorked], [WorkFromHome], [CreatedBy], [CreatedDateTime]) VALUES (3354, CAST(N'2019-04-29 00:00:00' AS SmallDateTime), 43, CAST(N'00:00:00' AS Time), CAST(N'00:00:00' AS Time), 2, N'1 ', CAST(N'00:00:00' AS Time), CAST(N'00:00:00' AS Time), -1, N'3', CAST(N'2019-05-01 15:40:41.710' AS DateTime))
GO
INSERT [AT2].[tblAttendance] ([ID], [Date], [EmployeeID], [InTime], [OutTime], [Leave], [LeaveType], [PermissionHrs], [ExtraHrsWorked], [WorkFromHome], [CreatedBy], [CreatedDateTime]) VALUES (3355, CAST(N'2019-04-30 00:00:00' AS SmallDateTime), 43, CAST(N'11:26:00' AS Time), CAST(N'17:45:00' AS Time), -1, N'-1', CAST(N'00:00:00' AS Time), CAST(N'00:00:00' AS Time), -1, N'3', CAST(N'2019-05-01 15:40:41.710' AS DateTime))
GO
INSERT [AT2].[tblAttendance] ([ID], [Date], [EmployeeID], [InTime], [OutTime], [Leave], [LeaveType], [PermissionHrs], [ExtraHrsWorked], [WorkFromHome], [CreatedBy], [CreatedDateTime]) VALUES (3356, CAST(N'2019-04-26 00:00:00' AS SmallDateTime), 51, CAST(N'11:00:00' AS Time), CAST(N'21:30:00' AS Time), -1, N'-1', CAST(N'00:00:00' AS Time), CAST(N'00:00:00' AS Time), 2, N'3', CAST(N'2019-05-01 15:41:55.463' AS DateTime))
GO
INSERT [AT2].[tblAttendance] ([ID], [Date], [EmployeeID], [InTime], [OutTime], [Leave], [LeaveType], [PermissionHrs], [ExtraHrsWorked], [WorkFromHome], [CreatedBy], [CreatedDateTime]) VALUES (3357, CAST(N'2019-04-29 00:00:00' AS SmallDateTime), 51, CAST(N'11:15:00' AS Time), CAST(N'21:00:00' AS Time), -1, N'-1', CAST(N'00:00:00' AS Time), CAST(N'00:00:00' AS Time), 2, N'3', CAST(N'2019-05-01 15:41:55.463' AS DateTime))
GO
INSERT [AT2].[tblAttendance] ([ID], [Date], [EmployeeID], [InTime], [OutTime], [Leave], [LeaveType], [PermissionHrs], [ExtraHrsWorked], [WorkFromHome], [CreatedBy], [CreatedDateTime]) VALUES (3358, CAST(N'2019-04-30 00:00:00' AS SmallDateTime), 51, CAST(N'12:00:00' AS Time), CAST(N'22:00:00' AS Time), -1, N'-1', CAST(N'00:00:00' AS Time), CAST(N'00:00:00' AS Time), 2, N'3', CAST(N'2019-05-01 15:41:55.463' AS DateTime))
GO
INSERT [AT2].[tblAttendance] ([ID], [Date], [EmployeeID], [InTime], [OutTime], [Leave], [LeaveType], [PermissionHrs], [ExtraHrsWorked], [WorkFromHome], [CreatedBy], [CreatedDateTime]) VALUES (3359, CAST(N'2019-05-01 00:00:00' AS SmallDateTime), 51, CAST(N'11:30:00' AS Time), CAST(N'21:30:00' AS Time), -1, N'-1', CAST(N'00:00:00' AS Time), CAST(N'00:00:00' AS Time), 2, N'3', CAST(N'2019-05-13 20:02:38.023' AS DateTime))
GO
INSERT [AT2].[tblAttendance] ([ID], [Date], [EmployeeID], [InTime], [OutTime], [Leave], [LeaveType], [PermissionHrs], [ExtraHrsWorked], [WorkFromHome], [CreatedBy], [CreatedDateTime]) VALUES (3360, CAST(N'2019-05-02 00:00:00' AS SmallDateTime), 52, CAST(N'10:04:00' AS Time), CAST(N'20:10:00' AS Time), -1, N'-1', CAST(N'00:00:00' AS Time), CAST(N'00:00:00' AS Time), -1, N'3', CAST(N'2019-05-10 16:55:40.660' AS DateTime))
GO
INSERT [AT2].[tblAttendance] ([ID], [Date], [EmployeeID], [InTime], [OutTime], [Leave], [LeaveType], [PermissionHrs], [ExtraHrsWorked], [WorkFromHome], [CreatedBy], [CreatedDateTime]) VALUES (3363, CAST(N'2019-05-02 11:53:00' AS SmallDateTime), 3, CAST(N'11:52:00' AS Time), CAST(N'21:51:00' AS Time), -1, N'-1', CAST(N'00:00:00' AS Time), CAST(N'00:00:00' AS Time), -1, N'3', CAST(N'2019-05-10 16:55:40.660' AS DateTime))
GO
INSERT [AT2].[tblAttendance] ([ID], [Date], [EmployeeID], [InTime], [OutTime], [Leave], [LeaveType], [PermissionHrs], [ExtraHrsWorked], [WorkFromHome], [CreatedBy], [CreatedDateTime]) VALUES (3371, CAST(N'2019-05-02 15:53:00' AS SmallDateTime), 54, CAST(N'12:21:00' AS Time), CAST(N'21:51:00' AS Time), -1, N'-1', CAST(N'00:00:00' AS Time), CAST(N'00:00:00' AS Time), -1, N'3', CAST(N'2019-05-10 16:55:40.660' AS DateTime))
GO
INSERT [AT2].[tblAttendance] ([ID], [Date], [EmployeeID], [InTime], [OutTime], [Leave], [LeaveType], [PermissionHrs], [ExtraHrsWorked], [WorkFromHome], [CreatedBy], [CreatedDateTime]) VALUES (3373, CAST(N'2019-05-02 16:34:00' AS SmallDateTime), 53, CAST(N'16:34:00' AS Time), CAST(N'18:25:00' AS Time), -1, N'-1', CAST(N'00:00:00' AS Time), CAST(N'00:01:00' AS Time), -1, N'3', CAST(N'2019-05-10 16:55:40.660' AS DateTime))
GO
INSERT [AT2].[tblAttendance] ([ID], [Date], [EmployeeID], [InTime], [OutTime], [Leave], [LeaveType], [PermissionHrs], [ExtraHrsWorked], [WorkFromHome], [CreatedBy], [CreatedDateTime]) VALUES (3374, CAST(N'2019-05-02 18:14:00' AS SmallDateTime), 1, CAST(N'13:30:00' AS Time), CAST(N'22:30:00' AS Time), -1, N'-1', CAST(N'00:00:00' AS Time), CAST(N'00:00:00' AS Time), -1, N'3', CAST(N'2019-05-10 16:55:40.660' AS DateTime))
GO
INSERT [AT2].[tblAttendance] ([ID], [Date], [EmployeeID], [InTime], [OutTime], [Leave], [LeaveType], [PermissionHrs], [ExtraHrsWorked], [WorkFromHome], [CreatedBy], [CreatedDateTime]) VALUES (4392, CAST(N'2019-05-03 00:00:00' AS SmallDateTime), 52, CAST(N'10:27:00' AS Time), CAST(N'20:20:00' AS Time), -1, N'-1', CAST(N'00:00:00' AS Time), CAST(N'00:00:00' AS Time), -1, N'3', CAST(N'2019-05-03 18:26:18.803' AS DateTime))
GO
INSERT [AT2].[tblAttendance] ([ID], [Date], [EmployeeID], [InTime], [OutTime], [Leave], [LeaveType], [PermissionHrs], [ExtraHrsWorked], [WorkFromHome], [CreatedBy], [CreatedDateTime]) VALUES (4393, CAST(N'2019-05-03 00:00:00' AS SmallDateTime), 1, CAST(N'12:26:00' AS Time), CAST(N'15:58:00' AS Time), -1, N'-1', CAST(N'00:00:00' AS Time), CAST(N'00:00:00' AS Time), -1, N'3', CAST(N'2019-05-10 14:25:10.817' AS DateTime))
GO
INSERT [AT2].[tblAttendance] ([ID], [Date], [EmployeeID], [InTime], [OutTime], [Leave], [LeaveType], [PermissionHrs], [ExtraHrsWorked], [WorkFromHome], [CreatedBy], [CreatedDateTime]) VALUES (4394, CAST(N'2019-05-03 00:00:00' AS SmallDateTime), 3, CAST(N'12:20:00' AS Time), CAST(N'22:00:00' AS Time), -1, N'-1', CAST(N'00:00:00' AS Time), CAST(N'00:00:00' AS Time), -1, N'3', CAST(N'2019-05-03 18:26:18.803' AS DateTime))
GO
INSERT [AT2].[tblAttendance] ([ID], [Date], [EmployeeID], [InTime], [OutTime], [Leave], [LeaveType], [PermissionHrs], [ExtraHrsWorked], [WorkFromHome], [CreatedBy], [CreatedDateTime]) VALUES (4395, CAST(N'2019-05-03 19:06:00' AS SmallDateTime), 54, CAST(N'11:59:00' AS Time), CAST(N'22:35:00' AS Time), -1, N'-1', CAST(N'00:00:00' AS Time), CAST(N'00:01:00' AS Time), -1, N'3', CAST(N'2019-05-10 15:46:24.573' AS DateTime))
GO
INSERT [AT2].[tblAttendance] ([ID], [Date], [EmployeeID], [InTime], [OutTime], [Leave], [LeaveType], [PermissionHrs], [ExtraHrsWorked], [WorkFromHome], [CreatedBy], [CreatedDateTime]) VALUES (4397, CAST(N'2019-05-03 19:52:00' AS SmallDateTime), 53, CAST(N'10:18:00' AS Time), CAST(N'20:09:00' AS Time), -1, N'-1', CAST(N'00:00:00' AS Time), CAST(N'00:00:00' AS Time), 2, N'3', CAST(N'2019-05-10 14:25:10.817' AS DateTime))
GO
INSERT [AT2].[tblAttendance] ([ID], [Date], [EmployeeID], [InTime], [OutTime], [Leave], [LeaveType], [PermissionHrs], [ExtraHrsWorked], [WorkFromHome], [CreatedBy], [CreatedDateTime]) VALUES (5360, CAST(N'2019-05-06 00:00:00' AS SmallDateTime), 52, CAST(N'09:55:00' AS Time), CAST(N'20:15:00' AS Time), -1, N'-1', CAST(N'00:00:00' AS Time), CAST(N'00:00:00' AS Time), -1, N'3', CAST(N'2019-05-10 16:56:13.123' AS DateTime))
GO
INSERT [AT2].[tblAttendance] ([ID], [Date], [EmployeeID], [InTime], [OutTime], [Leave], [LeaveType], [PermissionHrs], [ExtraHrsWorked], [WorkFromHome], [CreatedBy], [CreatedDateTime]) VALUES (5374, CAST(N'2019-05-06 09:52:00' AS SmallDateTime), 3, CAST(N'12:15:00' AS Time), CAST(N'21:52:00' AS Time), -1, N'-1', CAST(N'00:00:00' AS Time), CAST(N'00:00:00' AS Time), -1, N'3', CAST(N'2019-05-10 16:56:13.123' AS DateTime))
GO
INSERT [AT2].[tblAttendance] ([ID], [Date], [EmployeeID], [InTime], [OutTime], [Leave], [LeaveType], [PermissionHrs], [ExtraHrsWorked], [WorkFromHome], [CreatedBy], [CreatedDateTime]) VALUES (5377, CAST(N'2019-05-06 17:02:00' AS SmallDateTime), 54, CAST(N'10:00:00' AS Time), CAST(N'08:00:00' AS Time), -1, N'-1', CAST(N'00:00:00' AS Time), CAST(N'00:00:00' AS Time), -1, N'3', CAST(N'2019-05-10 16:56:13.123' AS DateTime))
GO
INSERT [AT2].[tblAttendance] ([ID], [Date], [EmployeeID], [InTime], [OutTime], [Leave], [LeaveType], [PermissionHrs], [ExtraHrsWorked], [WorkFromHome], [CreatedBy], [CreatedDateTime]) VALUES (5383, CAST(N'2019-05-06 18:54:00' AS SmallDateTime), 53, CAST(N'10:33:00' AS Time), CAST(N'20:10:00' AS Time), -1, N'-1', CAST(N'00:00:00' AS Time), CAST(N'00:01:00' AS Time), -1, N'3', CAST(N'2019-05-10 16:56:13.123' AS DateTime))
GO
INSERT [AT2].[tblAttendance] ([ID], [Date], [EmployeeID], [InTime], [OutTime], [Leave], [LeaveType], [PermissionHrs], [ExtraHrsWorked], [WorkFromHome], [CreatedBy], [CreatedDateTime]) VALUES (5384, CAST(N'2019-05-07 00:00:00' AS SmallDateTime), 52, CAST(N'10:03:00' AS Time), CAST(N'20:18:00' AS Time), -1, N'-1', CAST(N'00:00:00' AS Time), CAST(N'00:00:00' AS Time), -1, N'3', CAST(N'2019-05-10 16:53:50.080' AS DateTime))
GO
INSERT [AT2].[tblAttendance] ([ID], [Date], [EmployeeID], [InTime], [OutTime], [Leave], [LeaveType], [PermissionHrs], [ExtraHrsWorked], [WorkFromHome], [CreatedBy], [CreatedDateTime]) VALUES (5387, CAST(N'2019-05-07 00:00:00' AS SmallDateTime), 1, CAST(N'12:34:00' AS Time), CAST(N'15:27:00' AS Time), -1, N'-1', CAST(N'00:30:00' AS Time), CAST(N'00:00:00' AS Time), -1, N'3', CAST(N'2019-05-10 16:53:50.080' AS DateTime))
GO
INSERT [AT2].[tblAttendance] ([ID], [Date], [EmployeeID], [InTime], [OutTime], [Leave], [LeaveType], [PermissionHrs], [ExtraHrsWorked], [WorkFromHome], [CreatedBy], [CreatedDateTime]) VALUES (5388, CAST(N'2019-05-07 00:00:00' AS SmallDateTime), 13, CAST(N'11:36:00' AS Time), CAST(N'20:39:00' AS Time), -1, N'-1', CAST(N'00:00:00' AS Time), CAST(N'00:00:00' AS Time), -1, N'3', CAST(N'2019-05-10 16:53:50.080' AS DateTime))
GO
INSERT [AT2].[tblAttendance] ([ID], [Date], [EmployeeID], [InTime], [OutTime], [Leave], [LeaveType], [PermissionHrs], [ExtraHrsWorked], [WorkFromHome], [CreatedBy], [CreatedDateTime]) VALUES (5389, CAST(N'2019-05-07 00:00:00' AS SmallDateTime), 28, CAST(N'10:45:00' AS Time), CAST(N'20:24:00' AS Time), -1, N'-1', CAST(N'00:00:00' AS Time), CAST(N'00:00:00' AS Time), -1, N'3', CAST(N'2019-05-10 16:53:50.080' AS DateTime))
GO
INSERT [AT2].[tblAttendance] ([ID], [Date], [EmployeeID], [InTime], [OutTime], [Leave], [LeaveType], [PermissionHrs], [ExtraHrsWorked], [WorkFromHome], [CreatedBy], [CreatedDateTime]) VALUES (5390, CAST(N'2019-05-07 00:00:00' AS SmallDateTime), 29, CAST(N'11:35:00' AS Time), CAST(N'21:55:00' AS Time), -1, N'-1', CAST(N'00:00:00' AS Time), CAST(N'00:00:00' AS Time), -1, N'3', CAST(N'2019-05-10 16:53:50.080' AS DateTime))
GO
INSERT [AT2].[tblAttendance] ([ID], [Date], [EmployeeID], [InTime], [OutTime], [Leave], [LeaveType], [PermissionHrs], [ExtraHrsWorked], [WorkFromHome], [CreatedBy], [CreatedDateTime]) VALUES (5391, CAST(N'2019-05-07 00:00:00' AS SmallDateTime), 34, CAST(N'11:58:00' AS Time), CAST(N'21:50:00' AS Time), -1, N'-1', CAST(N'00:00:00' AS Time), CAST(N'00:00:00' AS Time), -1, N'3', CAST(N'2019-05-10 16:53:50.080' AS DateTime))
GO
INSERT [AT2].[tblAttendance] ([ID], [Date], [EmployeeID], [InTime], [OutTime], [Leave], [LeaveType], [PermissionHrs], [ExtraHrsWorked], [WorkFromHome], [CreatedBy], [CreatedDateTime]) VALUES (5392, CAST(N'2019-05-07 00:00:00' AS SmallDateTime), 35, CAST(N'11:38:00' AS Time), CAST(N'21:31:00' AS Time), -1, N'-1', CAST(N'00:00:00' AS Time), CAST(N'00:00:00' AS Time), -1, N'3', CAST(N'2019-05-10 16:53:50.080' AS DateTime))
GO
INSERT [AT2].[tblAttendance] ([ID], [Date], [EmployeeID], [InTime], [OutTime], [Leave], [LeaveType], [PermissionHrs], [ExtraHrsWorked], [WorkFromHome], [CreatedBy], [CreatedDateTime]) VALUES (5393, CAST(N'2019-05-07 00:00:00' AS SmallDateTime), 40, CAST(N'11:55:00' AS Time), CAST(N'21:38:00' AS Time), -1, N'-1', CAST(N'00:00:00' AS Time), CAST(N'00:00:00' AS Time), -1, N'3', CAST(N'2019-05-10 16:53:50.080' AS DateTime))
GO
INSERT [AT2].[tblAttendance] ([ID], [Date], [EmployeeID], [InTime], [OutTime], [Leave], [LeaveType], [PermissionHrs], [ExtraHrsWorked], [WorkFromHome], [CreatedBy], [CreatedDateTime]) VALUES (5394, CAST(N'2019-05-07 00:00:00' AS SmallDateTime), 42, CAST(N'10:00:00' AS Time), CAST(N'21:30:00' AS Time), -1, N'-1', CAST(N'00:00:00' AS Time), CAST(N'00:00:00' AS Time), -1, N'3', CAST(N'2019-05-10 16:53:50.080' AS DateTime))
GO
INSERT [AT2].[tblAttendance] ([ID], [Date], [EmployeeID], [InTime], [OutTime], [Leave], [LeaveType], [PermissionHrs], [ExtraHrsWorked], [WorkFromHome], [CreatedBy], [CreatedDateTime]) VALUES (5395, CAST(N'2019-05-07 00:00:00' AS SmallDateTime), 43, CAST(N'10:00:00' AS Time), CAST(N'00:00:00' AS Time), -1, N'-1', CAST(N'00:00:00' AS Time), CAST(N'00:00:00' AS Time), -1, N'3', CAST(N'2019-05-13 20:01:44.007' AS DateTime))
GO
INSERT [AT2].[tblAttendance] ([ID], [Date], [EmployeeID], [InTime], [OutTime], [Leave], [LeaveType], [PermissionHrs], [ExtraHrsWorked], [WorkFromHome], [CreatedBy], [CreatedDateTime]) VALUES (5396, CAST(N'2019-05-07 00:00:00' AS SmallDateTime), 50, CAST(N'10:57:00' AS Time), CAST(N'21:50:00' AS Time), -1, N'-1', CAST(N'00:00:00' AS Time), CAST(N'00:00:00' AS Time), -1, N'3', CAST(N'2019-05-10 16:53:50.080' AS DateTime))
GO
INSERT [AT2].[tblAttendance] ([ID], [Date], [EmployeeID], [InTime], [OutTime], [Leave], [LeaveType], [PermissionHrs], [ExtraHrsWorked], [WorkFromHome], [CreatedBy], [CreatedDateTime]) VALUES (5397, CAST(N'2019-05-07 00:00:00' AS SmallDateTime), 51, CAST(N'10:00:00' AS Time), CAST(N'21:00:00' AS Time), -1, N'-1', CAST(N'00:00:00' AS Time), CAST(N'00:00:00' AS Time), -1, N'3', CAST(N'2019-05-13 20:02:38.023' AS DateTime))
GO
INSERT [AT2].[tblAttendance] ([ID], [Date], [EmployeeID], [InTime], [OutTime], [Leave], [LeaveType], [PermissionHrs], [ExtraHrsWorked], [WorkFromHome], [CreatedBy], [CreatedDateTime]) VALUES (5399, CAST(N'2019-05-07 17:49:00' AS SmallDateTime), 3, CAST(N'11:36:00' AS Time), CAST(N'21:54:00' AS Time), -1, N'-1', CAST(N'00:00:00' AS Time), CAST(N'00:00:00' AS Time), -1, N'3', CAST(N'2019-05-10 16:53:50.080' AS DateTime))
GO
INSERT [AT2].[tblAttendance] ([ID], [Date], [EmployeeID], [InTime], [OutTime], [Leave], [LeaveType], [PermissionHrs], [ExtraHrsWorked], [WorkFromHome], [CreatedBy], [CreatedDateTime]) VALUES (5401, CAST(N'2019-05-07 19:31:00' AS SmallDateTime), 53, CAST(N'19:30:00' AS Time), CAST(N'19:55:00' AS Time), -1, N'-1', CAST(N'00:00:00' AS Time), CAST(N'00:01:00' AS Time), 2, N'3', CAST(N'2019-05-10 16:53:50.080' AS DateTime))
GO
INSERT [AT2].[tblAttendance] ([ID], [Date], [EmployeeID], [InTime], [OutTime], [Leave], [LeaveType], [PermissionHrs], [ExtraHrsWorked], [WorkFromHome], [CreatedBy], [CreatedDateTime]) VALUES (5402, CAST(N'2019-05-07 19:52:00' AS SmallDateTime), 54, CAST(N'19:51:00' AS Time), CAST(N'19:53:00' AS Time), -1, N'-1', CAST(N'00:00:00' AS Time), CAST(N'00:00:00' AS Time), -1, N'3', CAST(N'2019-05-10 16:53:50.080' AS DateTime))
GO
INSERT [AT2].[tblAttendance] ([ID], [Date], [EmployeeID], [InTime], [OutTime], [Leave], [LeaveType], [PermissionHrs], [ExtraHrsWorked], [WorkFromHome], [CreatedBy], [CreatedDateTime]) VALUES (5403, CAST(N'2019-05-08 00:00:00' AS SmallDateTime), 52, CAST(N'10:07:00' AS Time), CAST(N'20:30:00' AS Time), -1, N'-1', CAST(N'00:00:00' AS Time), CAST(N'00:00:00' AS Time), -1, N'3', CAST(N'2019-05-10 16:55:13.023' AS DateTime))
GO
INSERT [AT2].[tblAttendance] ([ID], [Date], [EmployeeID], [InTime], [OutTime], [Leave], [LeaveType], [PermissionHrs], [ExtraHrsWorked], [WorkFromHome], [CreatedBy], [CreatedDateTime]) VALUES (5404, CAST(N'2019-05-08 15:45:00' AS SmallDateTime), 3, CAST(N'11:54:00' AS Time), CAST(N'21:32:00' AS Time), -1, N'-1', CAST(N'00:00:00' AS Time), CAST(N'00:00:00' AS Time), -1, N'3', CAST(N'2019-05-10 16:55:13.023' AS DateTime))
GO
INSERT [AT2].[tblAttendance] ([ID], [Date], [EmployeeID], [InTime], [OutTime], [Leave], [LeaveType], [PermissionHrs], [ExtraHrsWorked], [WorkFromHome], [CreatedBy], [CreatedDateTime]) VALUES (5405, CAST(N'2019-05-08 00:00:00' AS SmallDateTime), 1, CAST(N'12:11:00' AS Time), CAST(N'15:27:00' AS Time), -1, N'-1', CAST(N'00:00:00' AS Time), CAST(N'00:00:00' AS Time), -1, N'3', CAST(N'2019-05-10 16:55:13.023' AS DateTime))
GO
INSERT [AT2].[tblAttendance] ([ID], [Date], [EmployeeID], [InTime], [OutTime], [Leave], [LeaveType], [PermissionHrs], [ExtraHrsWorked], [WorkFromHome], [CreatedBy], [CreatedDateTime]) VALUES (5406, CAST(N'2019-05-08 00:00:00' AS SmallDateTime), 13, CAST(N'12:16:00' AS Time), CAST(N'21:29:00' AS Time), -1, N'-1', CAST(N'00:00:00' AS Time), CAST(N'00:00:00' AS Time), -1, N'3', CAST(N'2019-05-10 16:55:13.023' AS DateTime))
GO
INSERT [AT2].[tblAttendance] ([ID], [Date], [EmployeeID], [InTime], [OutTime], [Leave], [LeaveType], [PermissionHrs], [ExtraHrsWorked], [WorkFromHome], [CreatedBy], [CreatedDateTime]) VALUES (5407, CAST(N'2019-05-08 00:00:00' AS SmallDateTime), 28, CAST(N'10:40:00' AS Time), CAST(N'19:40:00' AS Time), -1, N'-1', CAST(N'00:00:00' AS Time), CAST(N'00:00:00' AS Time), -1, N'3', CAST(N'2019-05-10 16:55:13.023' AS DateTime))
GO
INSERT [AT2].[tblAttendance] ([ID], [Date], [EmployeeID], [InTime], [OutTime], [Leave], [LeaveType], [PermissionHrs], [ExtraHrsWorked], [WorkFromHome], [CreatedBy], [CreatedDateTime]) VALUES (5408, CAST(N'2019-05-08 00:00:00' AS SmallDateTime), 29, CAST(N'11:40:00' AS Time), CAST(N'22:30:00' AS Time), -1, N'-1', CAST(N'00:00:00' AS Time), CAST(N'00:00:00' AS Time), -1, N'3', CAST(N'2019-05-10 16:55:13.023' AS DateTime))
GO
INSERT [AT2].[tblAttendance] ([ID], [Date], [EmployeeID], [InTime], [OutTime], [Leave], [LeaveType], [PermissionHrs], [ExtraHrsWorked], [WorkFromHome], [CreatedBy], [CreatedDateTime]) VALUES (5409, CAST(N'2019-05-08 00:00:00' AS SmallDateTime), 34, CAST(N'11:31:00' AS Time), CAST(N'17:43:00' AS Time), -1, N'-1', CAST(N'00:00:00' AS Time), CAST(N'00:00:00' AS Time), -1, N'3', CAST(N'2019-05-10 16:55:13.023' AS DateTime))
GO
INSERT [AT2].[tblAttendance] ([ID], [Date], [EmployeeID], [InTime], [OutTime], [Leave], [LeaveType], [PermissionHrs], [ExtraHrsWorked], [WorkFromHome], [CreatedBy], [CreatedDateTime]) VALUES (5410, CAST(N'2019-05-08 00:00:00' AS SmallDateTime), 35, CAST(N'11:40:00' AS Time), CAST(N'21:27:00' AS Time), -1, N'-1', CAST(N'00:00:00' AS Time), CAST(N'00:00:00' AS Time), -1, N'3', CAST(N'2019-05-10 16:55:13.023' AS DateTime))
GO
INSERT [AT2].[tblAttendance] ([ID], [Date], [EmployeeID], [InTime], [OutTime], [Leave], [LeaveType], [PermissionHrs], [ExtraHrsWorked], [WorkFromHome], [CreatedBy], [CreatedDateTime]) VALUES (5411, CAST(N'2019-05-08 00:00:00' AS SmallDateTime), 40, CAST(N'12:04:00' AS Time), CAST(N'21:44:00' AS Time), -1, N'-1', CAST(N'00:00:00' AS Time), CAST(N'00:00:00' AS Time), -1, N'3', CAST(N'2019-05-10 16:55:13.023' AS DateTime))
GO
INSERT [AT2].[tblAttendance] ([ID], [Date], [EmployeeID], [InTime], [OutTime], [Leave], [LeaveType], [PermissionHrs], [ExtraHrsWorked], [WorkFromHome], [CreatedBy], [CreatedDateTime]) VALUES (5412, CAST(N'2019-05-08 00:00:00' AS SmallDateTime), 42, CAST(N'10:00:00' AS Time), CAST(N'00:00:00' AS Time), -1, N'-1', CAST(N'00:00:00' AS Time), CAST(N'00:00:00' AS Time), -1, N'3', CAST(N'2019-05-13 20:01:44.007' AS DateTime))
GO
INSERT [AT2].[tblAttendance] ([ID], [Date], [EmployeeID], [InTime], [OutTime], [Leave], [LeaveType], [PermissionHrs], [ExtraHrsWorked], [WorkFromHome], [CreatedBy], [CreatedDateTime]) VALUES (5413, CAST(N'2019-05-08 00:00:00' AS SmallDateTime), 43, CAST(N'10:47:00' AS Time), CAST(N'21:23:00' AS Time), -1, N'-1', CAST(N'00:00:00' AS Time), CAST(N'00:00:00' AS Time), -1, N'3', CAST(N'2019-05-10 16:55:13.023' AS DateTime))
GO
INSERT [AT2].[tblAttendance] ([ID], [Date], [EmployeeID], [InTime], [OutTime], [Leave], [LeaveType], [PermissionHrs], [ExtraHrsWorked], [WorkFromHome], [CreatedBy], [CreatedDateTime]) VALUES (5414, CAST(N'2019-05-08 00:00:00' AS SmallDateTime), 50, CAST(N'10:58:00' AS Time), CAST(N'21:26:00' AS Time), -1, N'-1', CAST(N'00:00:00' AS Time), CAST(N'00:00:00' AS Time), -1, N'3', CAST(N'2019-05-10 16:55:13.023' AS DateTime))
GO
INSERT [AT2].[tblAttendance] ([ID], [Date], [EmployeeID], [InTime], [OutTime], [Leave], [LeaveType], [PermissionHrs], [ExtraHrsWorked], [WorkFromHome], [CreatedBy], [CreatedDateTime]) VALUES (5415, CAST(N'2019-05-08 00:00:00' AS SmallDateTime), 51, CAST(N'10:00:00' AS Time), CAST(N'22:00:00' AS Time), -1, N'-1', CAST(N'00:00:00' AS Time), CAST(N'00:00:00' AS Time), -1, N'3', CAST(N'2019-05-13 20:02:38.023' AS DateTime))
GO
INSERT [AT2].[tblAttendance] ([ID], [Date], [EmployeeID], [InTime], [OutTime], [Leave], [LeaveType], [PermissionHrs], [ExtraHrsWorked], [WorkFromHome], [CreatedBy], [CreatedDateTime]) VALUES (5416, CAST(N'2019-04-26 00:00:00' AS SmallDateTime), 42, CAST(N'11:00:00' AS Time), CAST(N'21:00:00' AS Time), -1, N'-1', CAST(N'00:00:00' AS Time), CAST(N'00:00:00' AS Time), -1, N'3', CAST(N'2019-05-08 16:11:00.213' AS DateTime))
GO
INSERT [AT2].[tblAttendance] ([ID], [Date], [EmployeeID], [InTime], [OutTime], [Leave], [LeaveType], [PermissionHrs], [ExtraHrsWorked], [WorkFromHome], [CreatedBy], [CreatedDateTime]) VALUES (5417, CAST(N'2019-04-29 00:00:00' AS SmallDateTime), 42, CAST(N'11:30:00' AS Time), CAST(N'22:00:00' AS Time), -1, N'-1', CAST(N'00:00:00' AS Time), CAST(N'00:00:00' AS Time), -1, N'3', CAST(N'2019-05-08 16:11:00.213' AS DateTime))
GO
INSERT [AT2].[tblAttendance] ([ID], [Date], [EmployeeID], [InTime], [OutTime], [Leave], [LeaveType], [PermissionHrs], [ExtraHrsWorked], [WorkFromHome], [CreatedBy], [CreatedDateTime]) VALUES (5418, CAST(N'2019-04-30 00:00:00' AS SmallDateTime), 42, CAST(N'10:50:00' AS Time), CAST(N'21:55:00' AS Time), -1, N'-1', CAST(N'00:00:00' AS Time), CAST(N'00:00:00' AS Time), -1, N'3', CAST(N'2019-05-08 16:11:00.213' AS DateTime))
GO
INSERT [AT2].[tblAttendance] ([ID], [Date], [EmployeeID], [InTime], [OutTime], [Leave], [LeaveType], [PermissionHrs], [ExtraHrsWorked], [WorkFromHome], [CreatedBy], [CreatedDateTime]) VALUES (5419, CAST(N'2019-05-01 00:00:00' AS SmallDateTime), 42, CAST(N'11:05:00' AS Time), CAST(N'20:00:00' AS Time), -1, N'-1', CAST(N'00:00:00' AS Time), CAST(N'00:00:00' AS Time), -1, N'3', CAST(N'2019-05-10 16:53:04.067' AS DateTime))
GO
INSERT [AT2].[tblAttendance] ([ID], [Date], [EmployeeID], [InTime], [OutTime], [Leave], [LeaveType], [PermissionHrs], [ExtraHrsWorked], [WorkFromHome], [CreatedBy], [CreatedDateTime]) VALUES (5420, CAST(N'2019-05-02 00:00:00' AS SmallDateTime), 42, CAST(N'12:00:00' AS Time), CAST(N'22:30:00' AS Time), -1, N'-1', CAST(N'00:00:00' AS Time), CAST(N'00:00:00' AS Time), -1, N'3', CAST(N'2019-05-10 16:55:40.660' AS DateTime))
GO
INSERT [AT2].[tblAttendance] ([ID], [Date], [EmployeeID], [InTime], [OutTime], [Leave], [LeaveType], [PermissionHrs], [ExtraHrsWorked], [WorkFromHome], [CreatedBy], [CreatedDateTime]) VALUES (5421, CAST(N'2019-05-03 00:00:00' AS SmallDateTime), 42, CAST(N'09:55:00' AS Time), CAST(N'21:00:00' AS Time), -1, N'-1', CAST(N'00:00:00' AS Time), CAST(N'00:00:00' AS Time), -1, N'3', CAST(N'2019-05-08 16:11:00.213' AS DateTime))
GO
INSERT [AT2].[tblAttendance] ([ID], [Date], [EmployeeID], [InTime], [OutTime], [Leave], [LeaveType], [PermissionHrs], [ExtraHrsWorked], [WorkFromHome], [CreatedBy], [CreatedDateTime]) VALUES (5422, CAST(N'2019-05-06 00:00:00' AS SmallDateTime), 42, CAST(N'10:15:00' AS Time), CAST(N'22:00:00' AS Time), -1, N'-1', CAST(N'00:00:00' AS Time), CAST(N'00:00:00' AS Time), -1, N'3', CAST(N'2019-05-10 16:56:13.123' AS DateTime))
GO
INSERT [AT2].[tblAttendance] ([ID], [Date], [EmployeeID], [InTime], [OutTime], [Leave], [LeaveType], [PermissionHrs], [ExtraHrsWorked], [WorkFromHome], [CreatedBy], [CreatedDateTime]) VALUES (6405, CAST(N'2019-05-09 00:00:00' AS SmallDateTime), 52, CAST(N'10:18:00' AS Time), CAST(N'20:30:00' AS Time), -1, N'-1', CAST(N'00:00:00' AS Time), CAST(N'00:00:00' AS Time), -1, N'3', CAST(N'2019-05-09 10:47:25.533' AS DateTime))
GO
INSERT [AT2].[tblAttendance] ([ID], [Date], [EmployeeID], [InTime], [OutTime], [Leave], [LeaveType], [PermissionHrs], [ExtraHrsWorked], [WorkFromHome], [CreatedBy], [CreatedDateTime]) VALUES (6406, CAST(N'2019-05-09 11:30:00' AS SmallDateTime), 3, CAST(N'11:29:00' AS Time), CAST(N'21:15:00' AS Time), NULL, NULL, NULL, NULL, NULL, N'3', CAST(N'2019-05-09 11:29:53.183' AS DateTime))
GO
INSERT [AT2].[tblAttendance] ([ID], [Date], [EmployeeID], [InTime], [OutTime], [Leave], [LeaveType], [PermissionHrs], [ExtraHrsWorked], [WorkFromHome], [CreatedBy], [CreatedDateTime]) VALUES (6408, CAST(N'2019-05-10 00:00:00' AS SmallDateTime), 52, CAST(N'09:57:00' AS Time), CAST(N'20:30:00' AS Time), -1, N'-1', CAST(N'00:00:00' AS Time), CAST(N'00:00:00' AS Time), -1, N'3', CAST(N'2019-05-13 20:01:07.713' AS DateTime))
GO
INSERT [AT2].[tblAttendance] ([ID], [Date], [EmployeeID], [InTime], [OutTime], [Leave], [LeaveType], [PermissionHrs], [ExtraHrsWorked], [WorkFromHome], [CreatedBy], [CreatedDateTime]) VALUES (6409, CAST(N'2019-05-10 14:05:00' AS SmallDateTime), 54, CAST(N'14:05:00' AS Time), CAST(N'00:00:00' AS Time), -1, N'-1', CAST(N'00:00:00' AS Time), CAST(N'00:00:00' AS Time), -1, N'3', CAST(N'2019-05-13 20:01:44.007' AS DateTime))
GO
INSERT [AT2].[tblAttendance] ([ID], [Date], [EmployeeID], [InTime], [OutTime], [Leave], [LeaveType], [PermissionHrs], [ExtraHrsWorked], [WorkFromHome], [CreatedBy], [CreatedDateTime]) VALUES (6410, CAST(N'2019-05-06 00:00:00' AS SmallDateTime), 1, CAST(N'12:07:00' AS Time), CAST(N'21:48:00' AS Time), -1, N'-1', CAST(N'00:00:00' AS Time), CAST(N'00:00:00' AS Time), -1, N'3', CAST(N'2019-05-10 16:56:13.123' AS DateTime))
GO
INSERT [AT2].[tblAttendance] ([ID], [Date], [EmployeeID], [InTime], [OutTime], [Leave], [LeaveType], [PermissionHrs], [ExtraHrsWorked], [WorkFromHome], [CreatedBy], [CreatedDateTime]) VALUES (6411, CAST(N'2019-05-01 00:00:00' AS SmallDateTime), 13, CAST(N'11:48:00' AS Time), CAST(N'20:47:00' AS Time), -1, N'-1', CAST(N'00:00:00' AS Time), CAST(N'00:00:00' AS Time), -1, N'3', CAST(N'2019-05-10 16:53:04.067' AS DateTime))
GO
INSERT [AT2].[tblAttendance] ([ID], [Date], [EmployeeID], [InTime], [OutTime], [Leave], [LeaveType], [PermissionHrs], [ExtraHrsWorked], [WorkFromHome], [CreatedBy], [CreatedDateTime]) VALUES (6412, CAST(N'2019-05-01 00:00:00' AS SmallDateTime), 28, CAST(N'10:49:00' AS Time), CAST(N'20:32:00' AS Time), -1, N'-1', CAST(N'00:00:00' AS Time), CAST(N'00:00:00' AS Time), -1, N'3', CAST(N'2019-05-10 16:53:04.067' AS DateTime))
GO
INSERT [AT2].[tblAttendance] ([ID], [Date], [EmployeeID], [InTime], [OutTime], [Leave], [LeaveType], [PermissionHrs], [ExtraHrsWorked], [WorkFromHome], [CreatedBy], [CreatedDateTime]) VALUES (6413, CAST(N'2019-05-02 00:00:00' AS SmallDateTime), 28, CAST(N'10:48:00' AS Time), CAST(N'20:21:00' AS Time), -1, N'-1', CAST(N'00:00:00' AS Time), CAST(N'00:00:00' AS Time), -1, N'3', CAST(N'2019-05-10 16:55:40.660' AS DateTime))
GO
INSERT [AT2].[tblAttendance] ([ID], [Date], [EmployeeID], [InTime], [OutTime], [Leave], [LeaveType], [PermissionHrs], [ExtraHrsWorked], [WorkFromHome], [CreatedBy], [CreatedDateTime]) VALUES (6414, CAST(N'2019-05-03 00:00:00' AS SmallDateTime), 28, CAST(N'10:17:00' AS Time), CAST(N'20:15:00' AS Time), -1, N'-1', CAST(N'00:00:00' AS Time), CAST(N'00:00:00' AS Time), -1, N'3', CAST(N'2019-05-10 14:25:10.817' AS DateTime))
GO
INSERT [AT2].[tblAttendance] ([ID], [Date], [EmployeeID], [InTime], [OutTime], [Leave], [LeaveType], [PermissionHrs], [ExtraHrsWorked], [WorkFromHome], [CreatedBy], [CreatedDateTime]) VALUES (6415, CAST(N'2019-05-06 00:00:00' AS SmallDateTime), 28, CAST(N'10:34:00' AS Time), CAST(N'20:12:00' AS Time), -1, N'-1', CAST(N'00:00:00' AS Time), CAST(N'00:00:00' AS Time), -1, N'3', CAST(N'2019-05-10 16:56:13.123' AS DateTime))
GO
INSERT [AT2].[tblAttendance] ([ID], [Date], [EmployeeID], [InTime], [OutTime], [Leave], [LeaveType], [PermissionHrs], [ExtraHrsWorked], [WorkFromHome], [CreatedBy], [CreatedDateTime]) VALUES (6416, CAST(N'2019-05-02 00:00:00' AS SmallDateTime), 13, CAST(N'12:09:00' AS Time), CAST(N'20:02:00' AS Time), -1, N'-1', CAST(N'00:00:00' AS Time), CAST(N'00:00:00' AS Time), -1, N'3', CAST(N'2019-05-10 16:55:40.660' AS DateTime))
GO
INSERT [AT2].[tblAttendance] ([ID], [Date], [EmployeeID], [InTime], [OutTime], [Leave], [LeaveType], [PermissionHrs], [ExtraHrsWorked], [WorkFromHome], [CreatedBy], [CreatedDateTime]) VALUES (6417, CAST(N'2019-05-09 00:00:00' AS SmallDateTime), 1, CAST(N'12:43:00' AS Time), CAST(N'21:43:00' AS Time), -1, N'-1', CAST(N'00:00:00' AS Time), CAST(N'00:00:00' AS Time), -1, N'3', CAST(N'2019-05-10 15:46:24.573' AS DateTime))
GO
INSERT [AT2].[tblAttendance] ([ID], [Date], [EmployeeID], [InTime], [OutTime], [Leave], [LeaveType], [PermissionHrs], [ExtraHrsWorked], [WorkFromHome], [CreatedBy], [CreatedDateTime]) VALUES (6418, CAST(N'2019-05-03 00:00:00' AS SmallDateTime), 13, CAST(N'11:59:00' AS Time), CAST(N'22:22:00' AS Time), -1, N'-1', CAST(N'00:00:00' AS Time), CAST(N'00:00:00' AS Time), -1, N'3', CAST(N'2019-05-10 15:46:24.573' AS DateTime))
GO
INSERT [AT2].[tblAttendance] ([ID], [Date], [EmployeeID], [InTime], [OutTime], [Leave], [LeaveType], [PermissionHrs], [ExtraHrsWorked], [WorkFromHome], [CreatedBy], [CreatedDateTime]) VALUES (6419, CAST(N'2019-05-06 00:00:00' AS SmallDateTime), 13, CAST(N'11:53:00' AS Time), CAST(N'21:28:00' AS Time), -1, N'-1', CAST(N'00:00:00' AS Time), CAST(N'00:00:00' AS Time), -1, N'3', CAST(N'2019-05-10 16:56:13.123' AS DateTime))
GO
INSERT [AT2].[tblAttendance] ([ID], [Date], [EmployeeID], [InTime], [OutTime], [Leave], [LeaveType], [PermissionHrs], [ExtraHrsWorked], [WorkFromHome], [CreatedBy], [CreatedDateTime]) VALUES (6420, CAST(N'2019-05-09 00:00:00' AS SmallDateTime), 13, CAST(N'11:51:00' AS Time), CAST(N'21:35:00' AS Time), -1, N'-1', CAST(N'00:00:00' AS Time), CAST(N'00:00:00' AS Time), -1, N'3', CAST(N'2019-05-10 15:46:24.573' AS DateTime))
GO
INSERT [AT2].[tblAttendance] ([ID], [Date], [EmployeeID], [InTime], [OutTime], [Leave], [LeaveType], [PermissionHrs], [ExtraHrsWorked], [WorkFromHome], [CreatedBy], [CreatedDateTime]) VALUES (6421, CAST(N'2019-05-09 00:00:00' AS SmallDateTime), 28, CAST(N'10:22:00' AS Time), CAST(N'20:20:00' AS Time), -1, N'-1', CAST(N'00:00:00' AS Time), CAST(N'00:00:00' AS Time), -1, N'3', CAST(N'2019-05-10 15:46:24.573' AS DateTime))
GO
INSERT [AT2].[tblAttendance] ([ID], [Date], [EmployeeID], [InTime], [OutTime], [Leave], [LeaveType], [PermissionHrs], [ExtraHrsWorked], [WorkFromHome], [CreatedBy], [CreatedDateTime]) VALUES (6422, CAST(N'2019-05-01 00:00:00' AS SmallDateTime), 29, CAST(N'11:34:00' AS Time), CAST(N'21:17:00' AS Time), -1, N'-1', CAST(N'00:00:00' AS Time), CAST(N'00:00:00' AS Time), -1, N'3', CAST(N'2019-05-10 16:53:04.067' AS DateTime))
GO
INSERT [AT2].[tblAttendance] ([ID], [Date], [EmployeeID], [InTime], [OutTime], [Leave], [LeaveType], [PermissionHrs], [ExtraHrsWorked], [WorkFromHome], [CreatedBy], [CreatedDateTime]) VALUES (6423, CAST(N'2019-05-02 00:00:00' AS SmallDateTime), 29, CAST(N'11:19:00' AS Time), CAST(N'22:39:00' AS Time), -1, N'-1', CAST(N'00:00:00' AS Time), CAST(N'00:00:00' AS Time), -1, N'3', CAST(N'2019-05-10 16:55:40.660' AS DateTime))
GO
INSERT [AT2].[tblAttendance] ([ID], [Date], [EmployeeID], [InTime], [OutTime], [Leave], [LeaveType], [PermissionHrs], [ExtraHrsWorked], [WorkFromHome], [CreatedBy], [CreatedDateTime]) VALUES (6424, CAST(N'2019-05-03 00:00:00' AS SmallDateTime), 29, CAST(N'12:00:00' AS Time), CAST(N'21:55:00' AS Time), -1, N'-1', CAST(N'00:00:00' AS Time), CAST(N'00:00:00' AS Time), -1, N'3', CAST(N'2019-05-10 15:46:24.573' AS DateTime))
GO
INSERT [AT2].[tblAttendance] ([ID], [Date], [EmployeeID], [InTime], [OutTime], [Leave], [LeaveType], [PermissionHrs], [ExtraHrsWorked], [WorkFromHome], [CreatedBy], [CreatedDateTime]) VALUES (6425, CAST(N'2019-05-06 00:00:00' AS SmallDateTime), 29, CAST(N'11:35:00' AS Time), CAST(N'21:43:00' AS Time), -1, N'-1', CAST(N'00:00:00' AS Time), CAST(N'00:00:00' AS Time), -1, N'3', CAST(N'2019-05-10 16:56:13.123' AS DateTime))
GO
INSERT [AT2].[tblAttendance] ([ID], [Date], [EmployeeID], [InTime], [OutTime], [Leave], [LeaveType], [PermissionHrs], [ExtraHrsWorked], [WorkFromHome], [CreatedBy], [CreatedDateTime]) VALUES (6426, CAST(N'2019-05-09 00:00:00' AS SmallDateTime), 29, CAST(N'11:05:00' AS Time), CAST(N'22:23:00' AS Time), -1, N'-1', CAST(N'00:00:00' AS Time), CAST(N'00:00:00' AS Time), -1, N'3', CAST(N'2019-05-10 15:46:24.573' AS DateTime))
GO
INSERT [AT2].[tblAttendance] ([ID], [Date], [EmployeeID], [InTime], [OutTime], [Leave], [LeaveType], [PermissionHrs], [ExtraHrsWorked], [WorkFromHome], [CreatedBy], [CreatedDateTime]) VALUES (6427, CAST(N'2019-05-01 00:00:00' AS SmallDateTime), 34, CAST(N'12:09:00' AS Time), CAST(N'22:02:00' AS Time), -1, N'-1', CAST(N'00:00:00' AS Time), CAST(N'00:00:00' AS Time), -1, N'3', CAST(N'2019-05-10 16:53:04.067' AS DateTime))
GO
INSERT [AT2].[tblAttendance] ([ID], [Date], [EmployeeID], [InTime], [OutTime], [Leave], [LeaveType], [PermissionHrs], [ExtraHrsWorked], [WorkFromHome], [CreatedBy], [CreatedDateTime]) VALUES (6428, CAST(N'2019-05-02 00:00:00' AS SmallDateTime), 34, CAST(N'11:46:00' AS Time), CAST(N'22:40:00' AS Time), -1, N'-1', CAST(N'00:00:00' AS Time), CAST(N'00:00:00' AS Time), -1, N'3', CAST(N'2019-05-10 16:55:40.660' AS DateTime))
GO
INSERT [AT2].[tblAttendance] ([ID], [Date], [EmployeeID], [InTime], [OutTime], [Leave], [LeaveType], [PermissionHrs], [ExtraHrsWorked], [WorkFromHome], [CreatedBy], [CreatedDateTime]) VALUES (6429, CAST(N'2019-05-03 00:00:00' AS SmallDateTime), 34, CAST(N'11:56:00' AS Time), CAST(N'13:11:00' AS Time), -1, N'-1', CAST(N'00:00:00' AS Time), CAST(N'00:00:00' AS Time), -1, N'3', CAST(N'2019-05-10 15:46:24.573' AS DateTime))
GO
INSERT [AT2].[tblAttendance] ([ID], [Date], [EmployeeID], [InTime], [OutTime], [Leave], [LeaveType], [PermissionHrs], [ExtraHrsWorked], [WorkFromHome], [CreatedBy], [CreatedDateTime]) VALUES (6430, CAST(N'2019-05-06 00:00:00' AS SmallDateTime), 34, CAST(N'12:27:00' AS Time), CAST(N'21:35:00' AS Time), -1, N'-1', CAST(N'00:00:00' AS Time), CAST(N'00:00:00' AS Time), -1, N'3', CAST(N'2019-05-10 16:56:13.123' AS DateTime))
GO
INSERT [AT2].[tblAttendance] ([ID], [Date], [EmployeeID], [InTime], [OutTime], [Leave], [LeaveType], [PermissionHrs], [ExtraHrsWorked], [WorkFromHome], [CreatedBy], [CreatedDateTime]) VALUES (6431, CAST(N'2019-05-09 00:00:00' AS SmallDateTime), 34, CAST(N'11:55:00' AS Time), CAST(N'22:26:00' AS Time), -1, N'-1', CAST(N'00:00:00' AS Time), CAST(N'00:00:00' AS Time), -1, N'3', CAST(N'2019-05-10 15:46:24.573' AS DateTime))
GO
INSERT [AT2].[tblAttendance] ([ID], [Date], [EmployeeID], [InTime], [OutTime], [Leave], [LeaveType], [PermissionHrs], [ExtraHrsWorked], [WorkFromHome], [CreatedBy], [CreatedDateTime]) VALUES (6432, CAST(N'2019-05-01 00:00:00' AS SmallDateTime), 35, CAST(N'11:27:00' AS Time), CAST(N'21:53:00' AS Time), -1, N'-1', CAST(N'00:00:00' AS Time), CAST(N'00:00:00' AS Time), -1, N'3', CAST(N'2019-05-10 16:53:04.067' AS DateTime))
GO
INSERT [AT2].[tblAttendance] ([ID], [Date], [EmployeeID], [InTime], [OutTime], [Leave], [LeaveType], [PermissionHrs], [ExtraHrsWorked], [WorkFromHome], [CreatedBy], [CreatedDateTime]) VALUES (6433, CAST(N'2019-05-02 00:00:00' AS SmallDateTime), 35, CAST(N'11:39:00' AS Time), CAST(N'22:03:00' AS Time), -1, N'-1', CAST(N'00:00:00' AS Time), CAST(N'00:00:00' AS Time), -1, N'3', CAST(N'2019-05-10 16:55:40.660' AS DateTime))
GO
INSERT [AT2].[tblAttendance] ([ID], [Date], [EmployeeID], [InTime], [OutTime], [Leave], [LeaveType], [PermissionHrs], [ExtraHrsWorked], [WorkFromHome], [CreatedBy], [CreatedDateTime]) VALUES (6434, CAST(N'2019-05-03 00:00:00' AS SmallDateTime), 35, CAST(N'11:42:00' AS Time), CAST(N'22:00:00' AS Time), -1, N'-1', CAST(N'00:00:00' AS Time), CAST(N'00:00:00' AS Time), -1, N'3', CAST(N'2019-05-10 15:46:24.573' AS DateTime))
GO
INSERT [AT2].[tblAttendance] ([ID], [Date], [EmployeeID], [InTime], [OutTime], [Leave], [LeaveType], [PermissionHrs], [ExtraHrsWorked], [WorkFromHome], [CreatedBy], [CreatedDateTime]) VALUES (6435, CAST(N'2019-05-06 00:00:00' AS SmallDateTime), 35, CAST(N'11:37:00' AS Time), CAST(N'21:58:00' AS Time), -1, N'-1', CAST(N'00:00:00' AS Time), CAST(N'00:00:00' AS Time), -1, N'3', CAST(N'2019-05-10 16:56:13.123' AS DateTime))
GO
INSERT [AT2].[tblAttendance] ([ID], [Date], [EmployeeID], [InTime], [OutTime], [Leave], [LeaveType], [PermissionHrs], [ExtraHrsWorked], [WorkFromHome], [CreatedBy], [CreatedDateTime]) VALUES (6436, CAST(N'2019-05-09 00:00:00' AS SmallDateTime), 35, CAST(N'11:36:00' AS Time), CAST(N'22:23:00' AS Time), -1, N'-1', CAST(N'00:00:00' AS Time), CAST(N'00:00:00' AS Time), -1, N'3', CAST(N'2019-05-10 15:46:24.573' AS DateTime))
GO
INSERT [AT2].[tblAttendance] ([ID], [Date], [EmployeeID], [InTime], [OutTime], [Leave], [LeaveType], [PermissionHrs], [ExtraHrsWorked], [WorkFromHome], [CreatedBy], [CreatedDateTime]) VALUES (6437, CAST(N'2019-05-01 00:00:00' AS SmallDateTime), 40, CAST(N'11:36:00' AS Time), CAST(N'21:44:00' AS Time), -1, N'-1', CAST(N'00:00:00' AS Time), CAST(N'00:00:00' AS Time), -1, N'3', CAST(N'2019-05-10 16:53:04.067' AS DateTime))
GO
INSERT [AT2].[tblAttendance] ([ID], [Date], [EmployeeID], [InTime], [OutTime], [Leave], [LeaveType], [PermissionHrs], [ExtraHrsWorked], [WorkFromHome], [CreatedBy], [CreatedDateTime]) VALUES (6438, CAST(N'2019-05-02 00:00:00' AS SmallDateTime), 40, CAST(N'11:59:00' AS Time), CAST(N'13:51:00' AS Time), -1, N'-1', CAST(N'00:00:00' AS Time), CAST(N'00:00:00' AS Time), -1, N'3', CAST(N'2019-05-10 16:55:40.660' AS DateTime))
GO
INSERT [AT2].[tblAttendance] ([ID], [Date], [EmployeeID], [InTime], [OutTime], [Leave], [LeaveType], [PermissionHrs], [ExtraHrsWorked], [WorkFromHome], [CreatedBy], [CreatedDateTime]) VALUES (6439, CAST(N'2019-05-03 00:00:00' AS SmallDateTime), 40, CAST(N'11:58:00' AS Time), CAST(N'14:47:00' AS Time), -1, N'-1', CAST(N'00:00:00' AS Time), CAST(N'00:00:00' AS Time), -1, N'3', CAST(N'2019-05-10 15:46:24.573' AS DateTime))
GO
INSERT [AT2].[tblAttendance] ([ID], [Date], [EmployeeID], [InTime], [OutTime], [Leave], [LeaveType], [PermissionHrs], [ExtraHrsWorked], [WorkFromHome], [CreatedBy], [CreatedDateTime]) VALUES (6440, CAST(N'2019-05-06 00:00:00' AS SmallDateTime), 40, CAST(N'13:59:00' AS Time), CAST(N'21:34:00' AS Time), -1, N'-1', CAST(N'00:00:00' AS Time), CAST(N'00:00:00' AS Time), -1, N'3', CAST(N'2019-05-10 16:56:13.123' AS DateTime))
GO
INSERT [AT2].[tblAttendance] ([ID], [Date], [EmployeeID], [InTime], [OutTime], [Leave], [LeaveType], [PermissionHrs], [ExtraHrsWorked], [WorkFromHome], [CreatedBy], [CreatedDateTime]) VALUES (6441, CAST(N'2019-05-09 00:00:00' AS SmallDateTime), 40, CAST(N'12:01:00' AS Time), CAST(N'22:25:00' AS Time), -1, N'-1', CAST(N'00:00:00' AS Time), CAST(N'00:00:00' AS Time), -1, N'3', CAST(N'2019-05-10 15:46:24.573' AS DateTime))
GO
INSERT [AT2].[tblAttendance] ([ID], [Date], [EmployeeID], [InTime], [OutTime], [Leave], [LeaveType], [PermissionHrs], [ExtraHrsWorked], [WorkFromHome], [CreatedBy], [CreatedDateTime]) VALUES (6442, CAST(N'2019-05-01 00:00:00' AS SmallDateTime), 43, CAST(N'12:17:00' AS Time), CAST(N'21:21:00' AS Time), -1, N'-1', CAST(N'00:00:00' AS Time), CAST(N'00:00:00' AS Time), -1, N'3', CAST(N'2019-05-10 16:53:04.067' AS DateTime))
GO
INSERT [AT2].[tblAttendance] ([ID], [Date], [EmployeeID], [InTime], [OutTime], [Leave], [LeaveType], [PermissionHrs], [ExtraHrsWorked], [WorkFromHome], [CreatedBy], [CreatedDateTime]) VALUES (6443, CAST(N'2019-05-02 00:00:00' AS SmallDateTime), 43, CAST(N'11:34:00' AS Time), CAST(N'21:35:00' AS Time), -1, N'-1', CAST(N'00:00:00' AS Time), CAST(N'00:00:00' AS Time), -1, N'3', CAST(N'2019-05-10 16:55:40.660' AS DateTime))
GO
INSERT [AT2].[tblAttendance] ([ID], [Date], [EmployeeID], [InTime], [OutTime], [Leave], [LeaveType], [PermissionHrs], [ExtraHrsWorked], [WorkFromHome], [CreatedBy], [CreatedDateTime]) VALUES (6444, CAST(N'2019-05-03 00:00:00' AS SmallDateTime), 43, CAST(N'11:36:00' AS Time), CAST(N'18:53:00' AS Time), -1, N'-1', CAST(N'00:00:00' AS Time), CAST(N'00:00:00' AS Time), -1, N'3', CAST(N'2019-05-10 15:46:24.573' AS DateTime))
GO
INSERT [AT2].[tblAttendance] ([ID], [Date], [EmployeeID], [InTime], [OutTime], [Leave], [LeaveType], [PermissionHrs], [ExtraHrsWorked], [WorkFromHome], [CreatedBy], [CreatedDateTime]) VALUES (6445, CAST(N'2019-05-06 00:00:00' AS SmallDateTime), 43, CAST(N'12:03:00' AS Time), CAST(N'21:05:00' AS Time), -1, N'-1', CAST(N'00:00:00' AS Time), CAST(N'00:00:00' AS Time), -1, N'3', CAST(N'2019-05-10 16:56:13.123' AS DateTime))
GO
INSERT [AT2].[tblAttendance] ([ID], [Date], [EmployeeID], [InTime], [OutTime], [Leave], [LeaveType], [PermissionHrs], [ExtraHrsWorked], [WorkFromHome], [CreatedBy], [CreatedDateTime]) VALUES (6446, CAST(N'2019-05-09 00:00:00' AS SmallDateTime), 43, CAST(N'10:54:00' AS Time), CAST(N'21:19:00' AS Time), -1, N'-1', CAST(N'00:00:00' AS Time), CAST(N'00:00:00' AS Time), -1, N'3', CAST(N'2019-05-10 15:46:24.573' AS DateTime))
GO
INSERT [AT2].[tblAttendance] ([ID], [Date], [EmployeeID], [InTime], [OutTime], [Leave], [LeaveType], [PermissionHrs], [ExtraHrsWorked], [WorkFromHome], [CreatedBy], [CreatedDateTime]) VALUES (6447, CAST(N'2019-05-01 00:00:00' AS SmallDateTime), 50, CAST(N'10:54:00' AS Time), CAST(N'22:02:00' AS Time), -1, N'-1', CAST(N'00:00:00' AS Time), CAST(N'00:00:00' AS Time), -1, N'3', CAST(N'2019-05-10 16:53:04.067' AS DateTime))
GO
INSERT [AT2].[tblAttendance] ([ID], [Date], [EmployeeID], [InTime], [OutTime], [Leave], [LeaveType], [PermissionHrs], [ExtraHrsWorked], [WorkFromHome], [CreatedBy], [CreatedDateTime]) VALUES (6448, CAST(N'2019-05-02 00:00:00' AS SmallDateTime), 50, CAST(N'10:56:00' AS Time), CAST(N'22:40:00' AS Time), -1, N'-1', CAST(N'00:00:00' AS Time), CAST(N'00:00:00' AS Time), -1, N'3', CAST(N'2019-05-10 16:55:40.660' AS DateTime))
GO
INSERT [AT2].[tblAttendance] ([ID], [Date], [EmployeeID], [InTime], [OutTime], [Leave], [LeaveType], [PermissionHrs], [ExtraHrsWorked], [WorkFromHome], [CreatedBy], [CreatedDateTime]) VALUES (6449, CAST(N'2019-05-03 00:00:00' AS SmallDateTime), 50, CAST(N'10:58:00' AS Time), CAST(N'21:59:00' AS Time), -1, N'-1', CAST(N'00:00:00' AS Time), CAST(N'00:00:00' AS Time), -1, N'3', CAST(N'2019-05-10 15:46:24.573' AS DateTime))
GO
INSERT [AT2].[tblAttendance] ([ID], [Date], [EmployeeID], [InTime], [OutTime], [Leave], [LeaveType], [PermissionHrs], [ExtraHrsWorked], [WorkFromHome], [CreatedBy], [CreatedDateTime]) VALUES (6450, CAST(N'2019-05-06 00:00:00' AS SmallDateTime), 50, CAST(N'11:01:00' AS Time), CAST(N'21:35:00' AS Time), -1, N'-1', CAST(N'00:00:00' AS Time), CAST(N'00:00:00' AS Time), -1, N'3', CAST(N'2019-05-10 16:56:13.123' AS DateTime))
GO
INSERT [AT2].[tblAttendance] ([ID], [Date], [EmployeeID], [InTime], [OutTime], [Leave], [LeaveType], [PermissionHrs], [ExtraHrsWorked], [WorkFromHome], [CreatedBy], [CreatedDateTime]) VALUES (6451, CAST(N'2019-05-09 00:00:00' AS SmallDateTime), 50, CAST(N'10:31:00' AS Time), CAST(N'22:26:00' AS Time), -1, N'-1', CAST(N'00:00:00' AS Time), CAST(N'00:00:00' AS Time), -1, N'3', CAST(N'2019-05-10 15:46:24.573' AS DateTime))
GO
INSERT [AT2].[tblAttendance] ([ID], [Date], [EmployeeID], [InTime], [OutTime], [Leave], [LeaveType], [PermissionHrs], [ExtraHrsWorked], [WorkFromHome], [CreatedBy], [CreatedDateTime]) VALUES (6452, CAST(N'2019-05-08 00:00:00' AS SmallDateTime), 53, CAST(N'10:23:00' AS Time), CAST(N'20:07:00' AS Time), -1, N'-1', CAST(N'00:00:00' AS Time), CAST(N'00:00:00' AS Time), -1, N'3', CAST(N'2019-05-10 16:55:13.023' AS DateTime))
GO
INSERT [AT2].[tblAttendance] ([ID], [Date], [EmployeeID], [InTime], [OutTime], [Leave], [LeaveType], [PermissionHrs], [ExtraHrsWorked], [WorkFromHome], [CreatedBy], [CreatedDateTime]) VALUES (6453, CAST(N'2019-05-09 00:00:00' AS SmallDateTime), 53, CAST(N'10:02:00' AS Time), CAST(N'17:33:00' AS Time), -1, N'-1', CAST(N'00:00:00' AS Time), CAST(N'00:00:00' AS Time), -1, N'3', CAST(N'2019-05-13 20:01:44.007' AS DateTime))
GO
INSERT [AT2].[tblAttendance] ([ID], [Date], [EmployeeID], [InTime], [OutTime], [Leave], [LeaveType], [PermissionHrs], [ExtraHrsWorked], [WorkFromHome], [CreatedBy], [CreatedDateTime]) VALUES (6454, CAST(N'2019-05-08 00:00:00' AS SmallDateTime), 54, CAST(N'11:54:00' AS Time), CAST(N'21:32:00' AS Time), -1, N'-1', CAST(N'00:00:00' AS Time), CAST(N'00:00:00' AS Time), -1, N'3', CAST(N'2019-05-10 16:55:13.023' AS DateTime))
GO
INSERT [AT2].[tblAttendance] ([ID], [Date], [EmployeeID], [InTime], [OutTime], [Leave], [LeaveType], [PermissionHrs], [ExtraHrsWorked], [WorkFromHome], [CreatedBy], [CreatedDateTime]) VALUES (6455, CAST(N'2019-05-09 00:00:00' AS SmallDateTime), 54, CAST(N'11:19:00' AS Time), CAST(N'22:24:00' AS Time), -1, N'-1', CAST(N'00:00:00' AS Time), CAST(N'00:00:00' AS Time), -1, N'3', CAST(N'2019-05-10 15:46:24.573' AS DateTime))
GO
INSERT [AT2].[tblAttendance] ([ID], [Date], [EmployeeID], [InTime], [OutTime], [Leave], [LeaveType], [PermissionHrs], [ExtraHrsWorked], [WorkFromHome], [CreatedBy], [CreatedDateTime]) VALUES (6459, CAST(N'2019-05-13 00:00:00' AS SmallDateTime), 52, CAST(N'09:58:00' AS Time), CAST(N'20:10:00' AS Time), -1, N'-1', CAST(N'00:00:00' AS Time), CAST(N'00:00:00' AS Time), -1, N'3', CAST(N'2019-05-13 20:01:44.007' AS DateTime))
GO
INSERT [AT2].[tblAttendance] ([ID], [Date], [EmployeeID], [InTime], [OutTime], [Leave], [LeaveType], [PermissionHrs], [ExtraHrsWorked], [WorkFromHome], [CreatedBy], [CreatedDateTime]) VALUES (6460, CAST(N'2019-05-13 11:37:00' AS SmallDateTime), 53, CAST(N'11:36:00' AS Time), CAST(N'20:30:00' AS Time), -1, N'-1', CAST(N'00:00:00' AS Time), CAST(N'00:00:00' AS Time), -1, N'3', CAST(N'2019-05-13 20:01:44.007' AS DateTime))
GO
INSERT [AT2].[tblAttendance] ([ID], [Date], [EmployeeID], [InTime], [OutTime], [Leave], [LeaveType], [PermissionHrs], [ExtraHrsWorked], [WorkFromHome], [CreatedBy], [CreatedDateTime]) VALUES (6461, CAST(N'2019-05-13 14:53:00' AS SmallDateTime), 54, CAST(N'14:52:00' AS Time), CAST(N'00:00:00' AS Time), -1, N'-1', CAST(N'00:00:00' AS Time), CAST(N'00:00:00' AS Time), -1, N'3', CAST(N'2019-05-13 20:01:44.007' AS DateTime))
GO
INSERT [AT2].[tblAttendance] ([ID], [Date], [EmployeeID], [InTime], [OutTime], [Leave], [LeaveType], [PermissionHrs], [ExtraHrsWorked], [WorkFromHome], [CreatedBy], [CreatedDateTime]) VALUES (6462, CAST(N'2019-05-13 15:47:00' AS SmallDateTime), 3, CAST(N'11:50:00' AS Time), CAST(N'22:00:00' AS Time), -1, N'-1', CAST(N'00:00:00' AS Time), CAST(N'00:00:00' AS Time), -1, N'3', CAST(N'2019-05-13 20:01:44.007' AS DateTime))
GO
INSERT [AT2].[tblAttendance] ([ID], [Date], [EmployeeID], [InTime], [OutTime], [Leave], [LeaveType], [PermissionHrs], [ExtraHrsWorked], [WorkFromHome], [CreatedBy], [CreatedDateTime]) VALUES (6463, CAST(N'2019-05-13 00:00:00' AS SmallDateTime), 1, CAST(N'10:30:00' AS Time), CAST(N'22:00:00' AS Time), -1, N'1 ', CAST(N'00:00:00' AS Time), CAST(N'00:00:00' AS Time), -1, N'', CAST(N'2019-05-22 16:51:52.223' AS DateTime))
GO
INSERT [AT2].[tblAttendance] ([ID], [Date], [EmployeeID], [InTime], [OutTime], [Leave], [LeaveType], [PermissionHrs], [ExtraHrsWorked], [WorkFromHome], [CreatedBy], [CreatedDateTime]) VALUES (6464, CAST(N'2019-05-10 00:00:00' AS SmallDateTime), 3, CAST(N'12:00:00' AS Time), CAST(N'22:00:00' AS Time), -1, N'-1', CAST(N'00:00:00' AS Time), CAST(N'00:00:00' AS Time), -1, N'3', CAST(N'2019-05-13 20:01:07.713' AS DateTime))
GO
INSERT [AT2].[tblAttendance] ([ID], [Date], [EmployeeID], [InTime], [OutTime], [Leave], [LeaveType], [PermissionHrs], [ExtraHrsWorked], [WorkFromHome], [CreatedBy], [CreatedDateTime]) VALUES (6465, CAST(N'2019-05-14 10:52:00' AS SmallDateTime), 52, CAST(N'10:52:00' AS Time), CAST(N'20:10:00' AS Time), -1, N'-1', CAST(N'00:00:00' AS Time), CAST(N'00:00:00' AS Time), -1, N'3', CAST(N'2019-05-15 12:40:00.530' AS DateTime))
GO
INSERT [AT2].[tblAttendance] ([ID], [Date], [EmployeeID], [InTime], [OutTime], [Leave], [LeaveType], [PermissionHrs], [ExtraHrsWorked], [WorkFromHome], [CreatedBy], [CreatedDateTime]) VALUES (6466, CAST(N'2019-05-14 11:51:00' AS SmallDateTime), 54, CAST(N'11:51:00' AS Time), CAST(N'00:00:00' AS Time), -1, N'-1', CAST(N'00:00:00' AS Time), CAST(N'00:00:00' AS Time), -1, N'3', CAST(N'2019-05-15 12:40:00.530' AS DateTime))
GO
INSERT [AT2].[tblAttendance] ([ID], [Date], [EmployeeID], [InTime], [OutTime], [Leave], [LeaveType], [PermissionHrs], [ExtraHrsWorked], [WorkFromHome], [CreatedBy], [CreatedDateTime]) VALUES (6467, CAST(N'2019-05-14 11:52:00' AS SmallDateTime), 53, CAST(N'11:52:00' AS Time), CAST(N'20:00:00' AS Time), -1, N'-1', CAST(N'00:00:00' AS Time), CAST(N'00:00:00' AS Time), -1, N'3', CAST(N'2019-05-15 12:40:00.530' AS DateTime))
GO
INSERT [AT2].[tblAttendance] ([ID], [Date], [EmployeeID], [InTime], [OutTime], [Leave], [LeaveType], [PermissionHrs], [ExtraHrsWorked], [WorkFromHome], [CreatedBy], [CreatedDateTime]) VALUES (6468, CAST(N'2019-05-15 00:00:00' AS SmallDateTime), 52, CAST(N'10:04:00' AS Time), CAST(N'20:20:00' AS Time), -1, N'-1', CAST(N'00:00:00' AS Time), CAST(N'00:00:00' AS Time), -1, N'3', CAST(N'2019-05-15 12:39:27.640' AS DateTime))
GO
INSERT [AT2].[tblAttendance] ([ID], [Date], [EmployeeID], [InTime], [OutTime], [Leave], [LeaveType], [PermissionHrs], [ExtraHrsWorked], [WorkFromHome], [CreatedBy], [CreatedDateTime]) VALUES (6469, CAST(N'2019-05-14 00:00:00' AS SmallDateTime), 3, CAST(N'11:30:00' AS Time), CAST(N'21:30:00' AS Time), -1, N'-1', CAST(N'00:00:00' AS Time), CAST(N'00:00:00' AS Time), -1, N'3', CAST(N'2019-05-15 12:40:00.530' AS DateTime))
GO
INSERT [AT2].[tblAttendance] ([ID], [Date], [EmployeeID], [InTime], [OutTime], [Leave], [LeaveType], [PermissionHrs], [ExtraHrsWorked], [WorkFromHome], [CreatedBy], [CreatedDateTime]) VALUES (6470, CAST(N'2019-05-15 16:12:00' AS SmallDateTime), 54, CAST(N'16:12:00' AS Time), CAST(N'00:00:00' AS Time), NULL, NULL, NULL, NULL, NULL, N'54', CAST(N'2019-05-15 16:12:24.060' AS DateTime))
GO
INSERT [AT2].[tblAttendance] ([ID], [Date], [EmployeeID], [InTime], [OutTime], [Leave], [LeaveType], [PermissionHrs], [ExtraHrsWorked], [WorkFromHome], [CreatedBy], [CreatedDateTime]) VALUES (7468, CAST(N'2019-05-16 14:23:00' AS SmallDateTime), 54, CAST(N'14:22:00' AS Time), CAST(N'00:00:00' AS Time), -1, N'-1', CAST(N'00:00:00' AS Time), CAST(N'00:00:00' AS Time), -1, N'3', CAST(N'2019-05-23 16:41:49.873' AS DateTime))
GO
INSERT [AT2].[tblAttendance] ([ID], [Date], [EmployeeID], [InTime], [OutTime], [Leave], [LeaveType], [PermissionHrs], [ExtraHrsWorked], [WorkFromHome], [CreatedBy], [CreatedDateTime]) VALUES (7469, CAST(N'2019-05-16 00:00:00' AS SmallDateTime), 52, CAST(N'09:27:00' AS Time), CAST(N'20:15:00' AS Time), -1, N'-1', CAST(N'00:00:00' AS Time), CAST(N'00:00:00' AS Time), -1, N'3', CAST(N'2019-05-23 16:41:49.873' AS DateTime))
GO
INSERT [AT2].[tblAttendance] ([ID], [Date], [EmployeeID], [InTime], [OutTime], [Leave], [LeaveType], [PermissionHrs], [ExtraHrsWorked], [WorkFromHome], [CreatedBy], [CreatedDateTime]) VALUES (7470, CAST(N'2019-05-17 00:00:00' AS SmallDateTime), 52, CAST(N'10:05:00' AS Time), CAST(N'20:30:00' AS Time), -1, N'-1', CAST(N'00:00:00' AS Time), CAST(N'00:00:00' AS Time), -1, N'3', CAST(N'2019-05-21 10:12:01.567' AS DateTime))
GO
INSERT [AT2].[tblAttendance] ([ID], [Date], [EmployeeID], [InTime], [OutTime], [Leave], [LeaveType], [PermissionHrs], [ExtraHrsWorked], [WorkFromHome], [CreatedBy], [CreatedDateTime]) VALUES (7471, CAST(N'2019-05-20 00:00:00' AS SmallDateTime), 52, CAST(N'10:02:00' AS Time), CAST(N'20:20:00' AS Time), -1, N'-1', CAST(N'00:00:00' AS Time), CAST(N'00:00:00' AS Time), -1, N'3', CAST(N'2019-05-23 16:37:24.547' AS DateTime))
GO
INSERT [AT2].[tblAttendance] ([ID], [Date], [EmployeeID], [InTime], [OutTime], [Leave], [LeaveType], [PermissionHrs], [ExtraHrsWorked], [WorkFromHome], [CreatedBy], [CreatedDateTime]) VALUES (7472, CAST(N'2019-05-20 17:07:00' AS SmallDateTime), 3, CAST(N'17:06:00' AS Time), CAST(N'21:00:00' AS Time), -1, N'-1', CAST(N'00:00:00' AS Time), CAST(N'00:00:00' AS Time), -1, N'3', CAST(N'2019-05-23 16:37:24.547' AS DateTime))
GO
INSERT [AT2].[tblAttendance] ([ID], [Date], [EmployeeID], [InTime], [OutTime], [Leave], [LeaveType], [PermissionHrs], [ExtraHrsWorked], [WorkFromHome], [CreatedBy], [CreatedDateTime]) VALUES (7473, CAST(N'2019-05-21 10:11:00' AS SmallDateTime), 52, CAST(N'10:10:00' AS Time), CAST(N'20:30:00' AS Time), -1, N'-1', CAST(N'00:00:00' AS Time), CAST(N'00:00:00' AS Time), -1, N'3', CAST(N'2019-05-23 16:14:27.863' AS DateTime))
GO
INSERT [AT2].[tblAttendance] ([ID], [Date], [EmployeeID], [InTime], [OutTime], [Leave], [LeaveType], [PermissionHrs], [ExtraHrsWorked], [WorkFromHome], [CreatedBy], [CreatedDateTime]) VALUES (7474, CAST(N'2019-05-17 00:00:00' AS SmallDateTime), 53, CAST(N'00:00:00' AS Time), CAST(N'00:00:00' AS Time), 2, N'1 ', CAST(N'00:00:00' AS Time), CAST(N'00:00:00' AS Time), -1, N'3', CAST(N'2019-05-21 10:12:01.567' AS DateTime))
GO
INSERT [AT2].[tblAttendance] ([ID], [Date], [EmployeeID], [InTime], [OutTime], [Leave], [LeaveType], [PermissionHrs], [ExtraHrsWorked], [WorkFromHome], [CreatedBy], [CreatedDateTime]) VALUES (7475, CAST(N'2019-05-21 12:57:00' AS SmallDateTime), 3, CAST(N'12:57:00' AS Time), CAST(N'20:00:00' AS Time), -1, N'-1', CAST(N'00:00:00' AS Time), CAST(N'00:00:00' AS Time), -1, N'3', CAST(N'2019-05-23 16:14:27.863' AS DateTime))
GO
INSERT [AT2].[tblAttendance] ([ID], [Date], [EmployeeID], [InTime], [OutTime], [Leave], [LeaveType], [PermissionHrs], [ExtraHrsWorked], [WorkFromHome], [CreatedBy], [CreatedDateTime]) VALUES (7476, CAST(N'2019-05-22 10:30:00' AS SmallDateTime), 52, CAST(N'10:30:00' AS Time), CAST(N'20:30:00' AS Time), -1, N'-1', CAST(N'00:00:00' AS Time), CAST(N'00:00:00' AS Time), -1, N'3', CAST(N'2019-05-23 16:42:02.533' AS DateTime))
GO
INSERT [AT2].[tblAttendance] ([ID], [Date], [EmployeeID], [InTime], [OutTime], [Leave], [LeaveType], [PermissionHrs], [ExtraHrsWorked], [WorkFromHome], [CreatedBy], [CreatedDateTime]) VALUES (7477, CAST(N'2019-05-21 00:00:00' AS SmallDateTime), 42, CAST(N'00:00:00' AS Time), CAST(N'00:00:00' AS Time), 1, N'1 ', CAST(N'00:00:00' AS Time), CAST(N'00:00:00' AS Time), -1, N'3', CAST(N'2019-05-23 16:14:27.863' AS DateTime))
GO
INSERT [AT2].[tblAttendance] ([ID], [Date], [EmployeeID], [InTime], [OutTime], [Leave], [LeaveType], [PermissionHrs], [ExtraHrsWorked], [WorkFromHome], [CreatedBy], [CreatedDateTime]) VALUES (7478, CAST(N'2019-05-22 15:11:00' AS SmallDateTime), 3, CAST(N'15:11:00' AS Time), CAST(N'15:13:00' AS Time), -1, N'-1', CAST(N'00:00:00' AS Time), CAST(N'00:00:00' AS Time), -1, N'3', CAST(N'2019-05-23 16:42:02.533' AS DateTime))
GO
INSERT [AT2].[tblAttendance] ([ID], [Date], [EmployeeID], [InTime], [OutTime], [Leave], [LeaveType], [PermissionHrs], [ExtraHrsWorked], [WorkFromHome], [CreatedBy], [CreatedDateTime]) VALUES (7479, CAST(N'2019-05-10 00:00:00' AS SmallDateTime), 1, CAST(N'11:59:00' AS Time), CAST(N'21:55:00' AS Time), -1, N'-1', CAST(N'00:00:00' AS Time), CAST(N'00:00:00' AS Time), -1, N'', CAST(N'2019-05-22 16:54:17.370' AS DateTime))
GO
INSERT [AT2].[tblAttendance] ([ID], [Date], [EmployeeID], [InTime], [OutTime], [Leave], [LeaveType], [PermissionHrs], [ExtraHrsWorked], [WorkFromHome], [CreatedBy], [CreatedDateTime]) VALUES (7480, CAST(N'2019-05-22 17:19:00' AS SmallDateTime), 2139, CAST(N'17:19:00' AS Time), CAST(N'17:19:00' AS Time), -1, N'-1', CAST(N'00:00:00' AS Time), CAST(N'00:00:00' AS Time), -1, N'3', CAST(N'2019-05-23 16:42:02.533' AS DateTime))
GO
INSERT [AT2].[tblAttendance] ([ID], [Date], [EmployeeID], [InTime], [OutTime], [Leave], [LeaveType], [PermissionHrs], [ExtraHrsWorked], [WorkFromHome], [CreatedBy], [CreatedDateTime]) VALUES (7481, CAST(N'2019-05-24 11:12:00' AS SmallDateTime), 53, CAST(N'11:12:00' AS Time), NULL, NULL, NULL, NULL, NULL, NULL, N'53', CAST(N'2019-05-24 11:12:11.550' AS DateTime))
GO
SET IDENTITY_INSERT [AT2].[tblAttendance] OFF
GO
SET IDENTITY_INSERT [AT2].[tblDepartments] ON 

GO
INSERT [AT2].[tblDepartments] ([DepartmentId], [Department], [IsActive]) VALUES (1, N'softwaare123', 0)
GO
INSERT [AT2].[tblDepartments] ([DepartmentId], [Department], [IsActive]) VALUES (2, N'MedicalTranscription', 0)
GO
INSERT [AT2].[tblDepartments] ([DepartmentId], [Department], [IsActive]) VALUES (3, N'Network', 0)
GO
INSERT [AT2].[tblDepartments] ([DepartmentId], [Department], [IsActive]) VALUES (4, N'jr Developer', 0)
GO
INSERT [AT2].[tblDepartments] ([DepartmentId], [Department], [IsActive]) VALUES (1003, N'jrhrfghf', 0)
GO
INSERT [AT2].[tblDepartments] ([DepartmentId], [Department], [IsActive]) VALUES (1004, N'MECS', 0)
GO
INSERT [AT2].[tblDepartments] ([DepartmentId], [Department], [IsActive]) VALUES (1006, N'MECS', 0)
GO
INSERT [AT2].[tblDepartments] ([DepartmentId], [Department], [IsActive]) VALUES (1007, N'MECS', 0)
GO
INSERT [AT2].[tblDepartments] ([DepartmentId], [Department], [IsActive]) VALUES (1008, N'MECS', 0)
GO
INSERT [AT2].[tblDepartments] ([DepartmentId], [Department], [IsActive]) VALUES (1009, N'abcd', 0)
GO
INSERT [AT2].[tblDepartments] ([DepartmentId], [Department], [IsActive]) VALUES (1010, N'dsfdsf', 0)
GO
INSERT [AT2].[tblDepartments] ([DepartmentId], [Department], [IsActive]) VALUES (1011, N'zczczczc', 0)
GO
INSERT [AT2].[tblDepartments] ([DepartmentId], [Department], [IsActive]) VALUES (1012, N'dgdgdgdgg', 0)
GO
INSERT [AT2].[tblDepartments] ([DepartmentId], [Department], [IsActive]) VALUES (1013, N'fhdhdhhhfhfhfh', 0)
GO
INSERT [AT2].[tblDepartments] ([DepartmentId], [Department], [IsActive]) VALUES (1014, N'fhdhdhhhfhfhfhujj', 0)
GO
INSERT [AT2].[tblDepartments] ([DepartmentId], [Department], [IsActive]) VALUES (1015, N'adagdh      gahdgadvg', 0)
GO
INSERT [AT2].[tblDepartments] ([DepartmentId], [Department], [IsActive]) VALUES (1016, N'Test11312313', 0)
GO
INSERT [AT2].[tblDepartments] ([DepartmentId], [Department], [IsActive]) VALUES (1017, N'ZSCsfjakasaf', 0)
GO
INSERT [AT2].[tblDepartments] ([DepartmentId], [Department], [IsActive]) VALUES (1018, N'Electronics', 0)
GO
INSERT [AT2].[tblDepartments] ([DepartmentId], [Department], [IsActive]) VALUES (1019, N'ghfdffsf', 0)
GO
INSERT [AT2].[tblDepartments] ([DepartmentId], [Department], [IsActive]) VALUES (1020, N'dg dgu', 0)
GO
INSERT [AT2].[tblDepartments] ([DepartmentId], [Department], [IsActive]) VALUES (1021, N'gdgdgdgfg', 0)
GO
INSERT [AT2].[tblDepartments] ([DepartmentId], [Department], [IsActive]) VALUES (1022, N'gdgdgdg', 0)
GO
INSERT [AT2].[tblDepartments] ([DepartmentId], [Department], [IsActive]) VALUES (1023, N'janaki', 0)
GO
INSERT [AT2].[tblDepartments] ([DepartmentId], [Department], [IsActive]) VALUES (1024, N'gdgdgdgsdsdsdsdssdsdsd', 0)
GO
INSERT [AT2].[tblDepartments] ([DepartmentId], [Department], [IsActive]) VALUES (1025, N'sdfs', 0)
GO
INSERT [AT2].[tblDepartments] ([DepartmentId], [Department], [IsActive]) VALUES (1026, N'janaki123', 0)
GO
INSERT [AT2].[tblDepartments] ([DepartmentId], [Department], [IsActive]) VALUES (1027, N'aaarba', 0)
GO
INSERT [AT2].[tblDepartments] ([DepartmentId], [Department], [IsActive]) VALUES (1028, N'sss', 0)
GO
INSERT [AT2].[tblDepartments] ([DepartmentId], [Department], [IsActive]) VALUES (1029, N'bbb', 0)
GO
INSERT [AT2].[tblDepartments] ([DepartmentId], [Department], [IsActive]) VALUES (1030, N'bb', 0)
GO
INSERT [AT2].[tblDepartments] ([DepartmentId], [Department], [IsActive]) VALUES (1031, N'softwaare', 0)
GO
INSERT [AT2].[tblDepartments] ([DepartmentId], [Department], [IsActive]) VALUES (1032, N'softwaare1234564', 0)
GO
INSERT [AT2].[tblDepartments] ([DepartmentId], [Department], [IsActive]) VALUES (1033, N'fffhh', 0)
GO
INSERT [AT2].[tblDepartments] ([DepartmentId], [Department], [IsActive]) VALUES (1034, N'ggg', 0)
GO
INSERT [AT2].[tblDepartments] ([DepartmentId], [Department], [IsActive]) VALUES (1035, N'abcd786', 0)
GO
INSERT [AT2].[tblDepartments] ([DepartmentId], [Department], [IsActive]) VALUES (1036, N'gh', 0)
GO
INSERT [AT2].[tblDepartments] ([DepartmentId], [Department], [IsActive]) VALUES (1037, N'yyy', 0)
GO
INSERT [AT2].[tblDepartments] ([DepartmentId], [Department], [IsActive]) VALUES (1038, N'aaa', 1)
GO
INSERT [AT2].[tblDepartments] ([DepartmentId], [Department], [IsActive]) VALUES (1039, N'janaki456', 0)
GO
INSERT [AT2].[tblDepartments] ([DepartmentId], [Department], [IsActive]) VALUES (1040, N'hjk', 0)
GO
INSERT [AT2].[tblDepartments] ([DepartmentId], [Department], [IsActive]) VALUES (1041, N'ghjn', 0)
GO
INSERT [AT2].[tblDepartments] ([DepartmentId], [Department], [IsActive]) VALUES (1042, N'nnn', 0)
GO
INSERT [AT2].[tblDepartments] ([DepartmentId], [Department], [IsActive]) VALUES (1043, N'arf', 0)
GO
INSERT [AT2].[tblDepartments] ([DepartmentId], [Department], [IsActive]) VALUES (1044, N'Accounts', 0)
GO
INSERT [AT2].[tblDepartments] ([DepartmentId], [Department], [IsActive]) VALUES (1045, N'ITES', 0)
GO
INSERT [AT2].[tblDepartments] ([DepartmentId], [Department], [IsActive]) VALUES (1046, N'hhh', 0)
GO
INSERT [AT2].[tblDepartments] ([DepartmentId], [Department], [IsActive]) VALUES (1047, N'asdf', 0)
GO
INSERT [AT2].[tblDepartments] ([DepartmentId], [Department], [IsActive]) VALUES (1048, N'ghfhfh', 0)
GO
INSERT [AT2].[tblDepartments] ([DepartmentId], [Department], [IsActive]) VALUES (1049, N'hgf', 0)
GO
INSERT [AT2].[tblDepartments] ([DepartmentId], [Department], [IsActive]) VALUES (1050, N'lkjh', 0)
GO
INSERT [AT2].[tblDepartments] ([DepartmentId], [Department], [IsActive]) VALUES (1051, N'thn', 0)
GO
INSERT [AT2].[tblDepartments] ([DepartmentId], [Department], [IsActive]) VALUES (1052, N'asdfhj', 0)
GO
INSERT [AT2].[tblDepartments] ([DepartmentId], [Department], [IsActive]) VALUES (1053, N'jkl', 0)
GO
INSERT [AT2].[tblDepartments] ([DepartmentId], [Department], [IsActive]) VALUES (1054, N'fffffffffffff', 0)
GO
INSERT [AT2].[tblDepartments] ([DepartmentId], [Department], [IsActive]) VALUES (1055, N'mjh', 0)
GO
INSERT [AT2].[tblDepartments] ([DepartmentId], [Department], [IsActive]) VALUES (1056, N'subbu', 0)
GO
INSERT [AT2].[tblDepartments] ([DepartmentId], [Department], [IsActive]) VALUES (1057, N'nht', 0)
GO
INSERT [AT2].[tblDepartments] ([DepartmentId], [Department], [IsActive]) VALUES (1058, N'hhhhh', 0)
GO
INSERT [AT2].[tblDepartments] ([DepartmentId], [Department], [IsActive]) VALUES (1059, N'jj', 0)
GO
INSERT [AT2].[tblDepartments] ([DepartmentId], [Department], [IsActive]) VALUES (1060, N'kkkkkk', 0)
GO
INSERT [AT2].[tblDepartments] ([DepartmentId], [Department], [IsActive]) VALUES (1061, N'wert', 0)
GO
INSERT [AT2].[tblDepartments] ([DepartmentId], [Department], [IsActive]) VALUES (1062, N'Mechanical', 0)
GO
INSERT [AT2].[tblDepartments] ([DepartmentId], [Department], [IsActive]) VALUES (1063, N'jjhg', 0)
GO
INSERT [AT2].[tblDepartments] ([DepartmentId], [Department], [IsActive]) VALUES (1064, N'cse ', 0)
GO
INSERT [AT2].[tblDepartments] ([DepartmentId], [Department], [IsActive]) VALUES (1065, N'Sr.Pyton Developer', 0)
GO
INSERT [AT2].[tblDepartments] ([DepartmentId], [Department], [IsActive]) VALUES (1066, N'Sr.mysql Developer', 0)
GO
INSERT [AT2].[tblDepartments] ([DepartmentId], [Department], [IsActive]) VALUES (1067, N'Business analysts ', 0)
GO
INSERT [AT2].[tblDepartments] ([DepartmentId], [Department], [IsActive]) VALUES (1068, N'Software developers', 1)
GO
INSERT [AT2].[tblDepartments] ([DepartmentId], [Department], [IsActive]) VALUES (1069, N'Software testers ', 1)
GO
INSERT [AT2].[tblDepartments] ([DepartmentId], [Department], [IsActive]) VALUES (1070, N'Technical writers ', 1)
GO
INSERT [AT2].[tblDepartments] ([DepartmentId], [Department], [IsActive]) VALUES (1071, N'User experience designers,', 1)
GO
INSERT [AT2].[tblDepartments] ([DepartmentId], [Department], [IsActive]) VALUES (1072, N'Graphic designers', 1)
GO
INSERT [AT2].[tblDepartments] ([DepartmentId], [Department], [IsActive]) VALUES (1073, N'HR', 0)
GO
INSERT [AT2].[tblDepartments] ([DepartmentId], [Department], [IsActive]) VALUES (1074, N'Training', 0)
GO
INSERT [AT2].[tblDepartments] ([DepartmentId], [Department], [IsActive]) VALUES (1075, N'Finance', 1)
GO
INSERT [AT2].[tblDepartments] ([DepartmentId], [Department], [IsActive]) VALUES (1076, N'IT consulting', 0)
GO
INSERT [AT2].[tblDepartments] ([DepartmentId], [Department], [IsActive]) VALUES (1077, N'customer service', 1)
GO
INSERT [AT2].[tblDepartments] ([DepartmentId], [Department], [IsActive]) VALUES (1078, N'software', 0)
GO
INSERT [AT2].[tblDepartments] ([DepartmentId], [Department], [IsActive]) VALUES (1079, N'Testing123', 0)
GO
INSERT [AT2].[tblDepartments] ([DepartmentId], [Department], [IsActive]) VALUES (2065, N'asdfghj', 0)
GO
INSERT [AT2].[tblDepartments] ([DepartmentId], [Department], [IsActive]) VALUES (2066, N'asdfghjki', 0)
GO
INSERT [AT2].[tblDepartments] ([DepartmentId], [Department], [IsActive]) VALUES (2067, N'ECE', 1)
GO
SET IDENTITY_INSERT [AT2].[tblDepartments] OFF
GO
SET IDENTITY_INSERT [AT2].[tblDesignations] ON 

GO
INSERT [AT2].[tblDesignations] ([DesignationID], [Designation], [IsActive]) VALUES (1, N'Project Manager', 0)
GO
INSERT [AT2].[tblDesignations] ([DesignationID], [Designation], [IsActive]) VALUES (2, N'Team Lead', 0)
GO
INSERT [AT2].[tblDesignations] ([DesignationID], [Designation], [IsActive]) VALUES (3, N'Sr. Software Engineer', 0)
GO
INSERT [AT2].[tblDesignations] ([DesignationID], [Designation], [IsActive]) VALUES (4, N'Associate Software Engineer', 1)
GO
INSERT [AT2].[tblDesignations] ([DesignationID], [Designation], [IsActive]) VALUES (5, N'QA', 0)
GO
INSERT [AT2].[tblDesignations] ([DesignationID], [Designation], [IsActive]) VALUES (6, N'IOS1', 0)
GO
INSERT [AT2].[tblDesignations] ([DesignationID], [Designation], [IsActive]) VALUES (7, N'Android Developer1', 1)
GO
INSERT [AT2].[tblDesignations] ([DesignationID], [Designation], [IsActive]) VALUES (8, N'Trainee123', 0)
GO
INSERT [AT2].[tblDesignations] ([DesignationID], [Designation], [IsActive]) VALUES (9, N'Business System Analyst', 0)
GO
INSERT [AT2].[tblDesignations] ([DesignationID], [Designation], [IsActive]) VALUES (10, N'Jr SQL Developer', 0)
GO
INSERT [AT2].[tblDesignations] ([DesignationID], [Designation], [IsActive]) VALUES (17, N'sr SQL developer', 0)
GO
INSERT [AT2].[tblDesignations] ([DesignationID], [Designation], [IsActive]) VALUES (1010, N'ggggSQL developer', 0)
GO
INSERT [AT2].[tblDesignations] ([DesignationID], [Designation], [IsActive]) VALUES (1011, N'Trainee1234', 0)
GO
INSERT [AT2].[tblDesignations] ([DesignationID], [Designation], [IsActive]) VALUES (1012, N'Trainee12344', 0)
GO
INSERT [AT2].[tblDesignations] ([DesignationID], [Designation], [IsActive]) VALUES (1013, N'Trainee1234445', 0)
GO
INSERT [AT2].[tblDesignations] ([DesignationID], [Designation], [IsActive]) VALUES (1014, N'bb', 0)
GO
INSERT [AT2].[tblDesignations] ([DesignationID], [Designation], [IsActive]) VALUES (1015, N'nnn', 0)
GO
INSERT [AT2].[tblDesignations] ([DesignationID], [Designation], [IsActive]) VALUES (1016, N'vvv', 0)
GO
INSERT [AT2].[tblDesignations] ([DesignationID], [Designation], [IsActive]) VALUES (1017, N'nnnnnn', 0)
GO
INSERT [AT2].[tblDesignations] ([DesignationID], [Designation], [IsActive]) VALUES (1018, N'jjj', 0)
GO
INSERT [AT2].[tblDesignations] ([DesignationID], [Designation], [IsActive]) VALUES (1019, N'bgf', 0)
GO
INSERT [AT2].[tblDesignations] ([DesignationID], [Designation], [IsActive]) VALUES (1020, N'hujjkhnjhjhgjhj', 0)
GO
INSERT [AT2].[tblDesignations] ([DesignationID], [Designation], [IsActive]) VALUES (1021, N'dfdfffgg', 0)
GO
INSERT [AT2].[tblDesignations] ([DesignationID], [Designation], [IsActive]) VALUES (1022, N'dfdff456', 0)
GO
INSERT [AT2].[tblDesignations] ([DesignationID], [Designation], [IsActive]) VALUES (1023, N'sss', 0)
GO
INSERT [AT2].[tblDesignations] ([DesignationID], [Designation], [IsActive]) VALUES (1024, N'fff', 0)
GO
INSERT [AT2].[tblDesignations] ([DesignationID], [Designation], [IsActive]) VALUES (1025, N'abcd', 0)
GO
INSERT [AT2].[tblDesignations] ([DesignationID], [Designation], [IsActive]) VALUES (1026, N'dfbddjjklm', 0)
GO
INSERT [AT2].[tblDesignations] ([DesignationID], [Designation], [IsActive]) VALUES (1027, N'ggg', 0)
GO
INSERT [AT2].[tblDesignations] ([DesignationID], [Designation], [IsActive]) VALUES (1028, N'Business System Analyst132', 0)
GO
INSERT [AT2].[tblDesignations] ([DesignationID], [Designation], [IsActive]) VALUES (1029, N'Business System Analystq', 0)
GO
INSERT [AT2].[tblDesignations] ([DesignationID], [Designation], [IsActive]) VALUES (1030, N'gggggh', 0)
GO
INSERT [AT2].[tblDesignations] ([DesignationID], [Designation], [IsActive]) VALUES (1031, N'Business System Analyst12', 0)
GO
INSERT [AT2].[tblDesignations] ([DesignationID], [Designation], [IsActive]) VALUES (1032, N'Business System Analysttjtgjtj', 0)
GO
INSERT [AT2].[tblDesignations] ([DesignationID], [Designation], [IsActive]) VALUES (1033, N'bbrt', 0)
GO
INSERT [AT2].[tblDesignations] ([DesignationID], [Designation], [IsActive]) VALUES (1034, N'fgrr', 0)
GO
INSERT [AT2].[tblDesignations] ([DesignationID], [Designation], [IsActive]) VALUES (1035, N'kk', 0)
GO
INSERT [AT2].[tblDesignations] ([DesignationID], [Designation], [IsActive]) VALUES (1036, N'ghj', 0)
GO
INSERT [AT2].[tblDesignations] ([DesignationID], [Designation], [IsActive]) VALUES (1037, N'ghh', 0)
GO
INSERT [AT2].[tblDesignations] ([DesignationID], [Designation], [IsActive]) VALUES (1038, N'mmm', 0)
GO
INSERT [AT2].[tblDesignations] ([DesignationID], [Designation], [IsActive]) VALUES (1039, N'hhhhhhhh', 0)
GO
INSERT [AT2].[tblDesignations] ([DesignationID], [Designation], [IsActive]) VALUES (1040, N'asdfg', 0)
GO
INSERT [AT2].[tblDesignations] ([DesignationID], [Designation], [IsActive]) VALUES (1041, N'asdfr', 0)
GO
INSERT [AT2].[tblDesignations] ([DesignationID], [Designation], [IsActive]) VALUES (1042, N'Trainee engineer', 1)
GO
INSERT [AT2].[tblDesignations] ([DesignationID], [Designation], [IsActive]) VALUES (1043, N'Software engineer', 1)
GO
INSERT [AT2].[tblDesignations] ([DesignationID], [Designation], [IsActive]) VALUES (1044, N'Senior software engineer', 1)
GO
INSERT [AT2].[tblDesignations] ([DesignationID], [Designation], [IsActive]) VALUES (1045, N'Technical leader', 1)
GO
INSERT [AT2].[tblDesignations] ([DesignationID], [Designation], [IsActive]) VALUES (1046, N'Principal software engineer', 1)
GO
INSERT [AT2].[tblDesignations] ([DesignationID], [Designation], [IsActive]) VALUES (1047, N'Team leader', 1)
GO
INSERT [AT2].[tblDesignations] ([DesignationID], [Designation], [IsActive]) VALUES (1048, N'Project leader', 1)
GO
INSERT [AT2].[tblDesignations] ([DesignationID], [Designation], [IsActive]) VALUES (1049, N'Staff engineer', 1)
GO
INSERT [AT2].[tblDesignations] ([DesignationID], [Designation], [IsActive]) VALUES (1050, N'Associate managers', 0)
GO
INSERT [AT2].[tblDesignations] ([DesignationID], [Designation], [IsActive]) VALUES (1051, N'System engineer', 1)
GO
INSERT [AT2].[tblDesignations] ([DesignationID], [Designation], [IsActive]) VALUES (1052, N'Software architect', 0)
GO
INSERT [AT2].[tblDesignations] ([DesignationID], [Designation], [IsActive]) VALUES (1053, N'Engineering manager', 1)
GO
INSERT [AT2].[tblDesignations] ([DesignationID], [Designation], [IsActive]) VALUES (1054, N'Domain manager', 0)
GO
INSERT [AT2].[tblDesignations] ([DesignationID], [Designation], [IsActive]) VALUES (1055, N'Technical Director', 1)
GO
INSERT [AT2].[tblDesignations] ([DesignationID], [Designation], [IsActive]) VALUES (1056, N'Vice President engineering', 1)
GO
INSERT [AT2].[tblDesignations] ([DesignationID], [Designation], [IsActive]) VALUES (1057, N'General manager Engineering', 1)
GO
INSERT [AT2].[tblDesignations] ([DesignationID], [Designation], [IsActive]) VALUES (1058, N'kjkj', 0)
GO
INSERT [AT2].[tblDesignations] ([DesignationID], [Designation], [IsActive]) VALUES (2042, N'Software Developer Bhargav', 1)
GO
SET IDENTITY_INSERT [AT2].[tblDesignations] OFF
GO
SET IDENTITY_INSERT [AT2].[tblEmployees] ON 

GO
INSERT [AT2].[tblEmployees] ([EmployeeID], [FirstName], [LastName], [DesignationID], [DepartmentID], [Mobile], [WorkEmail], [PersonalEmail], [UserID], [Password], [IsAdmin], [IsActive], [ActivatedDate], [Order], [BiometricID], [MapleID], [DOB], [DOJ], [Gender], [MaritalStatus], [DOA], [BloodGroup], [EmergencyContactPerson], [EmergencyContactNumber], [EmergencyContactRelation], [IsBilling], [IsProfileUpdated], [SlackId]) VALUES (1, N'Srikanth Gupta', N'Lade', 1048, 1068, N'9885969440', N'srikanth.lade@maple-software.com', N'srikanth.lade@maple-software.com', N'Gupta', N'23D42F5F3F66498B2C8FF4C20B8C5AC826E47146', 1, 1, NULL, 1, N'01926797', N'233425677', CAST(N'2018-01-30' AS Date), CAST(N'1900-01-01' AS Date), 1, 0, CAST(N'1900-01-01' AS Date), N'A+', N'test', N'9876543210', N'test', NULL, 1, N'U684EM9C3')
GO
INSERT [AT2].[tblEmployees] ([EmployeeID], [FirstName], [LastName], [DesignationID], [DepartmentID], [Mobile], [WorkEmail], [PersonalEmail], [UserID], [Password], [IsAdmin], [IsActive], [ActivatedDate], [Order], [BiometricID], [MapleID], [DOB], [DOJ], [Gender], [MaritalStatus], [DOA], [BloodGroup], [EmergencyContactPerson], [EmergencyContactNumber], [EmergencyContactRelation], [IsBilling], [IsProfileUpdated], [SlackId]) VALUES (2, N'TataRao', N'Mylipalli', 3, 1, N'9032448682', N'tatarao@maple-software.com', N'tatarao@gmail.com', N'tatarao', N'23D42F5F3F66498B2C8FF4C20B8C5AC826E47146', 0, 0, CAST(N'2018-11-13 11:53:48.663' AS DateTime), 3, N'01295019', NULL, CAST(N'1981-01-06' AS Date), CAST(N'1900-01-01' AS Date), 1, 1, CAST(N'2010-03-03' AS Date), N'B+', N'ssssss', N'9988568698', N'wife', NULL, 1, NULL)
GO
INSERT [AT2].[tblEmployees] ([EmployeeID], [FirstName], [LastName], [DesignationID], [DepartmentID], [Mobile], [WorkEmail], [PersonalEmail], [UserID], [Password], [IsAdmin], [IsActive], [ActivatedDate], [Order], [BiometricID], [MapleID], [DOB], [DOJ], [Gender], [MaritalStatus], [DOA], [BloodGroup], [EmergencyContactPerson], [EmergencyContactNumber], [EmergencyContactRelation], [IsBilling], [IsProfileUpdated], [SlackId]) VALUES (3, N'GopiKrishna', N'Srinivasula', 1044, 1068, N'9876543210', N'gopikrishna.s@maple-software.com', N'gopikrishna.s@maple-software.com', N'gopi', N'23D42F5F3F66498B2C8FF4C20B8C5AC826E47146', 1, 1, NULL, 2, N'01323704', N'78988679', CAST(N'1990-01-01' AS Date), CAST(N'2018-03-01' AS Date), 1, 1, CAST(N'2010-02-02' AS Date), N'A+', N'test', N'9876543210', N'test', NULL, 1, NULL)
GO
INSERT [AT2].[tblEmployees] ([EmployeeID], [FirstName], [LastName], [DesignationID], [DepartmentID], [Mobile], [WorkEmail], [PersonalEmail], [UserID], [Password], [IsAdmin], [IsActive], [ActivatedDate], [Order], [BiometricID], [MapleID], [DOB], [DOJ], [Gender], [MaritalStatus], [DOA], [BloodGroup], [EmergencyContactPerson], [EmergencyContactNumber], [EmergencyContactRelation], [IsBilling], [IsProfileUpdated], [SlackId]) VALUES (4, N'Anil Prasad', N'Allu', 5, 3, N'8686649366', N'anil.prasad@maple-software.com', N'gdjhg@gmail.com', N'Anil', N'23D42F5F3F66498B2C8FF4C20B8C5AC826E47146', 0, 0, CAST(N'2018-12-31 12:20:32.677' AS DateTime), 4, NULL, NULL, CAST(N'1900-01-01' AS Date), CAST(N'1900-01-01' AS Date), 1, 0, CAST(N'1900-01-01' AS Date), N'-1', NULL, NULL, NULL, NULL, 1, NULL)
GO
INSERT [AT2].[tblEmployees] ([EmployeeID], [FirstName], [LastName], [DesignationID], [DepartmentID], [Mobile], [WorkEmail], [PersonalEmail], [UserID], [Password], [IsAdmin], [IsActive], [ActivatedDate], [Order], [BiometricID], [MapleID], [DOB], [DOJ], [Gender], [MaritalStatus], [DOA], [BloodGroup], [EmergencyContactPerson], [EmergencyContactNumber], [EmergencyContactRelation], [IsBilling], [IsProfileUpdated], [SlackId]) VALUES (7, N'Rajesh', N'T', 7, 1, N'7382763325', N'rajesh.t@maple-software.com', NULL, N'Rajesh', N'23D42F5F3F66498B2C8FF4C20B8C5AC826E47146', 0, 0, CAST(N'2016-07-08 18:21:45.297' AS DateTime), 6, NULL, NULL, NULL, NULL, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL)
GO
INSERT [AT2].[tblEmployees] ([EmployeeID], [FirstName], [LastName], [DesignationID], [DepartmentID], [Mobile], [WorkEmail], [PersonalEmail], [UserID], [Password], [IsAdmin], [IsActive], [ActivatedDate], [Order], [BiometricID], [MapleID], [DOB], [DOJ], [Gender], [MaritalStatus], [DOA], [BloodGroup], [EmergencyContactPerson], [EmergencyContactNumber], [EmergencyContactRelation], [IsBilling], [IsProfileUpdated], [SlackId]) VALUES (8, N'Ramarao', N'Sampathirao', 6, 1, N'9491801764', N'ramarao.s@maple-software.com', NULL, NULL, N'23D42F5F3F66498B2C8FF4C20B8C5AC826E47146', 0, 0, CAST(N'2014-09-25 00:00:00.000' AS DateTime), 5, NULL, NULL, NULL, NULL, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL)
GO
INSERT [AT2].[tblEmployees] ([EmployeeID], [FirstName], [LastName], [DesignationID], [DepartmentID], [Mobile], [WorkEmail], [PersonalEmail], [UserID], [Password], [IsAdmin], [IsActive], [ActivatedDate], [Order], [BiometricID], [MapleID], [DOB], [DOJ], [Gender], [MaritalStatus], [DOA], [BloodGroup], [EmergencyContactPerson], [EmergencyContactNumber], [EmergencyContactRelation], [IsBilling], [IsProfileUpdated], [SlackId]) VALUES (9, N'Sravan', N'G', 8, 1, N'9705507102', N'gandepalli.sravan@gmail.com', NULL, NULL, N'23D42F5F3F66498B2C8FF4C20B8C5AC826E47146', 0, 0, CAST(N'2014-10-25 11:33:03.430' AS DateTime), 7, NULL, NULL, NULL, NULL, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL)
GO
INSERT [AT2].[tblEmployees] ([EmployeeID], [FirstName], [LastName], [DesignationID], [DepartmentID], [Mobile], [WorkEmail], [PersonalEmail], [UserID], [Password], [IsAdmin], [IsActive], [ActivatedDate], [Order], [BiometricID], [MapleID], [DOB], [DOJ], [Gender], [MaritalStatus], [DOA], [BloodGroup], [EmergencyContactPerson], [EmergencyContactNumber], [EmergencyContactRelation], [IsBilling], [IsProfileUpdated], [SlackId]) VALUES (10, N'Harish', N'Y', 8, 1, NULL, NULL, NULL, NULL, N'23D42F5F3F66498B2C8FF4C20B8C5AC826E47146', 0, 0, CAST(N'2014-08-25 19:16:33.073' AS DateTime), 8, NULL, NULL, NULL, NULL, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL)
GO
INSERT [AT2].[tblEmployees] ([EmployeeID], [FirstName], [LastName], [DesignationID], [DepartmentID], [Mobile], [WorkEmail], [PersonalEmail], [UserID], [Password], [IsAdmin], [IsActive], [ActivatedDate], [Order], [BiometricID], [MapleID], [DOB], [DOJ], [Gender], [MaritalStatus], [DOA], [BloodGroup], [EmergencyContactPerson], [EmergencyContactNumber], [EmergencyContactRelation], [IsBilling], [IsProfileUpdated], [SlackId]) VALUES (11, N'Siddhardha', N'M', 8, 1, N'7893915157', N'siddartha.molleti@gmail.com', NULL, NULL, N'23D42F5F3F66498B2C8FF4C20B8C5AC826E47146', 0, 0, CAST(N'2016-01-25 12:31:45.553' AS DateTime), 9, NULL, NULL, NULL, NULL, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL)
GO
INSERT [AT2].[tblEmployees] ([EmployeeID], [FirstName], [LastName], [DesignationID], [DepartmentID], [Mobile], [WorkEmail], [PersonalEmail], [UserID], [Password], [IsAdmin], [IsActive], [ActivatedDate], [Order], [BiometricID], [MapleID], [DOB], [DOJ], [Gender], [MaritalStatus], [DOA], [BloodGroup], [EmergencyContactPerson], [EmergencyContactNumber], [EmergencyContactRelation], [IsBilling], [IsProfileUpdated], [SlackId]) VALUES (12, N'Zawad', NULL, 8, 1, NULL, NULL, NULL, NULL, N'23D42F5F3F66498B2C8FF4C20B8C5AC826E47146', 0, 0, CAST(N'2014-07-25 00:00:00.000' AS DateTime), 10, NULL, NULL, NULL, NULL, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL)
GO
INSERT [AT2].[tblEmployees] ([EmployeeID], [FirstName], [LastName], [DesignationID], [DepartmentID], [Mobile], [WorkEmail], [PersonalEmail], [UserID], [Password], [IsAdmin], [IsActive], [ActivatedDate], [Order], [BiometricID], [MapleID], [DOB], [DOJ], [Gender], [MaritalStatus], [DOA], [BloodGroup], [EmergencyContactPerson], [EmergencyContactNumber], [EmergencyContactRelation], [IsBilling], [IsProfileUpdated], [SlackId]) VALUES (13, N'Pothu Naidu', N'Vennela', 1044, 1069, N'8143236026', N'pnaidumaple@gmail.com', N'gdjhg@gmail.com', N'naidu', N'23D42F5F3F66498B2C8FF4C20B8C5AC826E47146', 0, 1, NULL, 11, N'10122948', NULL, CAST(N'2017-03-29' AS Date), CAST(N'2019-03-20' AS Date), 1, 0, CAST(N'1900-01-01' AS Date), N'-1', NULL, NULL, NULL, NULL, 1, N'U684Q2G4T')
GO
INSERT [AT2].[tblEmployees] ([EmployeeID], [FirstName], [LastName], [DesignationID], [DepartmentID], [Mobile], [WorkEmail], [PersonalEmail], [UserID], [Password], [IsAdmin], [IsActive], [ActivatedDate], [Order], [BiometricID], [MapleID], [DOB], [DOJ], [Gender], [MaritalStatus], [DOA], [BloodGroup], [EmergencyContactPerson], [EmergencyContactNumber], [EmergencyContactRelation], [IsBilling], [IsProfileUpdated], [SlackId]) VALUES (28, N'Vidhyanand', N'K', 1044, 1068, N'7702780044', N'vidhyanand10@gmail.com', N'vidhyanand10@gmail.com', N'vanand', N'23D42F5F3F66498B2C8FF4C20B8C5AC826E47146', 0, 1, CAST(N'2017-03-09 12:27:39.387' AS DateTime), 12, N'08426768', NULL, CAST(N'1900-01-01' AS Date), CAST(N'1900-01-01' AS Date), 1, 0, CAST(N'1900-01-01' AS Date), N'-1', NULL, NULL, NULL, NULL, 1, N'U686SB2G2')
GO
INSERT [AT2].[tblEmployees] ([EmployeeID], [FirstName], [LastName], [DesignationID], [DepartmentID], [Mobile], [WorkEmail], [PersonalEmail], [UserID], [Password], [IsAdmin], [IsActive], [ActivatedDate], [Order], [BiometricID], [MapleID], [DOB], [DOJ], [Gender], [MaritalStatus], [DOA], [BloodGroup], [EmergencyContactPerson], [EmergencyContactNumber], [EmergencyContactRelation], [IsBilling], [IsProfileUpdated], [SlackId]) VALUES (29, N'Santhosh', N'Mukkamala', 1044, 1068, N'8019140434', N'santosh.m@maple-software.com', N'santosh@gmail.com', N'santhosh', N'23D42F5F3F66498B2C8FF4C20B8C5AC826E47146', 0, 1, CAST(N'2014-09-26 11:16:57.970' AS DateTime), 13, N'01310569', NULL, CAST(N'1900-01-01' AS Date), CAST(N'1900-01-01' AS Date), 1, 0, CAST(N'1900-01-01' AS Date), N'-1', NULL, NULL, NULL, NULL, 1, N'U8ZGSHLHE')
GO
INSERT [AT2].[tblEmployees] ([EmployeeID], [FirstName], [LastName], [DesignationID], [DepartmentID], [Mobile], [WorkEmail], [PersonalEmail], [UserID], [Password], [IsAdmin], [IsActive], [ActivatedDate], [Order], [BiometricID], [MapleID], [DOB], [DOJ], [Gender], [MaritalStatus], [DOA], [BloodGroup], [EmergencyContactPerson], [EmergencyContactNumber], [EmergencyContactRelation], [IsBilling], [IsProfileUpdated], [SlackId]) VALUES (30, N'Anup Kumar Mishra', NULL, 7, 1, N'8984394507', N'anup.mishra20@gmail.com', NULL, N'anup', N'23D42F5F3F66498B2C8FF4C20B8C5AC826E47146', 0, 0, CAST(N'2015-04-06 15:23:27.617' AS DateTime), 14, NULL, NULL, NULL, NULL, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL)
GO
INSERT [AT2].[tblEmployees] ([EmployeeID], [FirstName], [LastName], [DesignationID], [DepartmentID], [Mobile], [WorkEmail], [PersonalEmail], [UserID], [Password], [IsAdmin], [IsActive], [ActivatedDate], [Order], [BiometricID], [MapleID], [DOB], [DOJ], [Gender], [MaritalStatus], [DOA], [BloodGroup], [EmergencyContactPerson], [EmergencyContactNumber], [EmergencyContactRelation], [IsBilling], [IsProfileUpdated], [SlackId]) VALUES (31, N'Haarika', NULL, 6, 1, N'9885969440', N'srikanth.lade@gmail.com', NULL, N'Harika', N'23D42F5F3F66498B2C8FF4C20B8C5AC826E47146', 0, 0, CAST(N'2015-06-19 09:54:20.727' AS DateTime), 15, NULL, NULL, NULL, NULL, 2, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL)
GO
INSERT [AT2].[tblEmployees] ([EmployeeID], [FirstName], [LastName], [DesignationID], [DepartmentID], [Mobile], [WorkEmail], [PersonalEmail], [UserID], [Password], [IsAdmin], [IsActive], [ActivatedDate], [Order], [BiometricID], [MapleID], [DOB], [DOJ], [Gender], [MaritalStatus], [DOA], [BloodGroup], [EmergencyContactPerson], [EmergencyContactNumber], [EmergencyContactRelation], [IsBilling], [IsProfileUpdated], [SlackId]) VALUES (33, N'Chandra Sekhar', NULL, 6, 1, N'9491722359', N'chandrashekar203@gmail.com', NULL, N'Chandu', N'23D42F5F3F66498B2C8FF4C20B8C5AC826E47146', 0, 0, CAST(N'2017-02-21 12:20:15.247' AS DateTime), 16, NULL, NULL, NULL, NULL, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL)
GO
INSERT [AT2].[tblEmployees] ([EmployeeID], [FirstName], [LastName], [DesignationID], [DepartmentID], [Mobile], [WorkEmail], [PersonalEmail], [UserID], [Password], [IsAdmin], [IsActive], [ActivatedDate], [Order], [BiometricID], [MapleID], [DOB], [DOJ], [Gender], [MaritalStatus], [DOA], [BloodGroup], [EmergencyContactPerson], [EmergencyContactNumber], [EmergencyContactRelation], [IsBilling], [IsProfileUpdated], [SlackId]) VALUES (34, N'Siva Krishna', N'b', 1044, 1068, N'9959192529', N'sivakrishna@maple-software.com', N'sivakrishna@gmail.com', N'Siva', N'23D42F5F3F66498B2C8FF4C20B8C5AC826E47146', 0, 1, CAST(N'2015-06-26 12:37:34.143' AS DateTime), 17, N'08510910', NULL, CAST(N'2019-05-17' AS Date), CAST(N'1900-01-01' AS Date), 1, 0, CAST(N'1900-01-01' AS Date), N'A-', N'ghd dgh ', N'9999999999', N'gfhfgh', NULL, 1, N'U691X2H4P')
GO
INSERT [AT2].[tblEmployees] ([EmployeeID], [FirstName], [LastName], [DesignationID], [DepartmentID], [Mobile], [WorkEmail], [PersonalEmail], [UserID], [Password], [IsAdmin], [IsActive], [ActivatedDate], [Order], [BiometricID], [MapleID], [DOB], [DOJ], [Gender], [MaritalStatus], [DOA], [BloodGroup], [EmergencyContactPerson], [EmergencyContactNumber], [EmergencyContactRelation], [IsBilling], [IsProfileUpdated], [SlackId]) VALUES (35, N'Niteesh', N'Nunna', 1044, 1068, N'9701924982', N'niteesh.324@gmail.com', N'niteesh@gmail.com', N'niteesh', N'23D42F5F3F66498B2C8FF4C20B8C5AC826E47146', 0, 1, CAST(N'2015-12-01 12:45:58.963' AS DateTime), 18, N'01269979', NULL, CAST(N'1990-04-23' AS Date), CAST(N'1900-01-01' AS Date), 1, 0, CAST(N'1900-01-01' AS Date), N'A+', N'tfgy', N'8545623211', N'test', NULL, 1, N'U67GNFVB2')
GO
INSERT [AT2].[tblEmployees] ([EmployeeID], [FirstName], [LastName], [DesignationID], [DepartmentID], [Mobile], [WorkEmail], [PersonalEmail], [UserID], [Password], [IsAdmin], [IsActive], [ActivatedDate], [Order], [BiometricID], [MapleID], [DOB], [DOJ], [Gender], [MaritalStatus], [DOA], [BloodGroup], [EmergencyContactPerson], [EmergencyContactNumber], [EmergencyContactRelation], [IsBilling], [IsProfileUpdated], [SlackId]) VALUES (36, N'Balaraju', N'Polaki', 4, 1, N'8688791067', N'balarajupolaki@gmail.com', NULL, N'balu', N'23D42F5F3F66498B2C8FF4C20B8C5AC826E47146', 0, 0, CAST(N'2018-07-09 12:53:25.193' AS DateTime), 19, N'01295014', NULL, NULL, NULL, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL)
GO
INSERT [AT2].[tblEmployees] ([EmployeeID], [FirstName], [LastName], [DesignationID], [DepartmentID], [Mobile], [WorkEmail], [PersonalEmail], [UserID], [Password], [IsAdmin], [IsActive], [ActivatedDate], [Order], [BiometricID], [MapleID], [DOB], [DOJ], [Gender], [MaritalStatus], [DOA], [BloodGroup], [EmergencyContactPerson], [EmergencyContactNumber], [EmergencyContactRelation], [IsBilling], [IsProfileUpdated], [SlackId]) VALUES (37, N'Priya', NULL, 6, 1, NULL, N'priya@maple-software.com', NULL, N'priya', N'23D42F5F3F66498B2C8FF4C20B8C5AC826E47146', 0, 0, CAST(N'2016-10-25 01:51:56.270' AS DateTime), 20, NULL, NULL, NULL, NULL, 2, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL)
GO
INSERT [AT2].[tblEmployees] ([EmployeeID], [FirstName], [LastName], [DesignationID], [DepartmentID], [Mobile], [WorkEmail], [PersonalEmail], [UserID], [Password], [IsAdmin], [IsActive], [ActivatedDate], [Order], [BiometricID], [MapleID], [DOB], [DOJ], [Gender], [MaritalStatus], [DOA], [BloodGroup], [EmergencyContactPerson], [EmergencyContactNumber], [EmergencyContactRelation], [IsBilling], [IsProfileUpdated], [SlackId]) VALUES (38, N'Shruti', N'Utla', 5, 1, N'1234567890', N'shruti_sw@maple-software.com', NULL, N'Sruthi', N'23D42F5F3F66498B2C8FF4C20B8C5AC826E47146', 0, 0, CAST(N'2018-12-31 12:20:38.410' AS DateTime), 21, N'01896610', NULL, NULL, NULL, 2, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL)
GO
INSERT [AT2].[tblEmployees] ([EmployeeID], [FirstName], [LastName], [DesignationID], [DepartmentID], [Mobile], [WorkEmail], [PersonalEmail], [UserID], [Password], [IsAdmin], [IsActive], [ActivatedDate], [Order], [BiometricID], [MapleID], [DOB], [DOJ], [Gender], [MaritalStatus], [DOA], [BloodGroup], [EmergencyContactPerson], [EmergencyContactNumber], [EmergencyContactRelation], [IsBilling], [IsProfileUpdated], [SlackId]) VALUES (39, N'Karimulla', N'SK', 4, 1, N'9542770570', N'karimulla@maple-software.com', NULL, N'karimulla', N'23D42F5F3F66498B2C8FF4C20B8C5AC826E47146', 0, 0, CAST(N'2017-06-01 11:27:14.877' AS DateTime), 22, NULL, NULL, NULL, NULL, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL)
GO
INSERT [AT2].[tblEmployees] ([EmployeeID], [FirstName], [LastName], [DesignationID], [DepartmentID], [Mobile], [WorkEmail], [PersonalEmail], [UserID], [Password], [IsAdmin], [IsActive], [ActivatedDate], [Order], [BiometricID], [MapleID], [DOB], [DOJ], [Gender], [MaritalStatus], [DOA], [BloodGroup], [EmergencyContactPerson], [EmergencyContactNumber], [EmergencyContactRelation], [IsBilling], [IsProfileUpdated], [SlackId]) VALUES (40, N'Reena Kumari', N'Kuppili', 1044, 1068, N'9908921628', N'reena.sw@maple-software.com', N'reena@gmail.com', N'reena', N'23D42F5F3F66498B2C8FF4C20B8C5AC826E47146', 0, 1, CAST(N'2016-06-03 13:16:20.753' AS DateTime), 23, N'10127634', N'234r4', CAST(N'1900-01-01' AS Date), CAST(N'1900-01-01' AS Date), 2, 1, CAST(N'2010-04-24' AS Date), N'-1', NULL, NULL, NULL, NULL, 1, N'U691HGXV4')
GO
INSERT [AT2].[tblEmployees] ([EmployeeID], [FirstName], [LastName], [DesignationID], [DepartmentID], [Mobile], [WorkEmail], [PersonalEmail], [UserID], [Password], [IsAdmin], [IsActive], [ActivatedDate], [Order], [BiometricID], [MapleID], [DOB], [DOJ], [Gender], [MaritalStatus], [DOA], [BloodGroup], [EmergencyContactPerson], [EmergencyContactNumber], [EmergencyContactRelation], [IsBilling], [IsProfileUpdated], [SlackId]) VALUES (41, N'Siva Raju', NULL, 5, 1, N'9676488563', N'shivaraju.sw@maple-software.com', NULL, N'sivaraju', N'23D42F5F3F66498B2C8FF4C20B8C5AC826E47146', 0, 0, CAST(N'2016-10-25 01:51:56.270' AS DateTime), 24, NULL, NULL, NULL, NULL, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL)
GO
INSERT [AT2].[tblEmployees] ([EmployeeID], [FirstName], [LastName], [DesignationID], [DepartmentID], [Mobile], [WorkEmail], [PersonalEmail], [UserID], [Password], [IsAdmin], [IsActive], [ActivatedDate], [Order], [BiometricID], [MapleID], [DOB], [DOJ], [Gender], [MaritalStatus], [DOA], [BloodGroup], [EmergencyContactPerson], [EmergencyContactNumber], [EmergencyContactRelation], [IsBilling], [IsProfileUpdated], [SlackId]) VALUES (42, N'Srinivas', N'vangala', 1043, 1068, N'9505017599', N'srinuv_sw@maple-software.com', N'test@gmail.com', N'srinivas', N'23D42F5F3F66498B2C8FF4C20B8C5AC826E47146', 0, 1, CAST(N'2016-06-21 20:59:39.333' AS DateTime), 25, N'01246289', N'234r4', CAST(N'1995-06-06' AS Date), CAST(N'1900-01-01' AS Date), 1, 0, CAST(N'1900-01-01' AS Date), N'o-', N'jjjjjjjjjjj', N'9988568698', N'wife', NULL, 1, N'U6BQ7QSA3')
GO
INSERT [AT2].[tblEmployees] ([EmployeeID], [FirstName], [LastName], [DesignationID], [DepartmentID], [Mobile], [WorkEmail], [PersonalEmail], [UserID], [Password], [IsAdmin], [IsActive], [ActivatedDate], [Order], [BiometricID], [MapleID], [DOB], [DOJ], [Gender], [MaritalStatus], [DOA], [BloodGroup], [EmergencyContactPerson], [EmergencyContactNumber], [EmergencyContactRelation], [IsBilling], [IsProfileUpdated], [SlackId]) VALUES (43, N'Sesha giri rao', N'B', 1044, 1068, N'9980877889', N'shivaraju.sw@maple-software.com', N'shivaraju@gmail.com', N'seshu', N'23D42F5F3F66498B2C8FF4C20B8C5AC826E47146', 0, 1, CAST(N'2016-08-25 12:35:12.677' AS DateTime), 26, N'01778655', NULL, CAST(N'1900-01-01' AS Date), CAST(N'2014-04-24' AS Date), 1, 0, CAST(N'1900-01-01' AS Date), N'-1', NULL, NULL, NULL, NULL, 1, N'U67KW9QM7')
GO
INSERT [AT2].[tblEmployees] ([EmployeeID], [FirstName], [LastName], [DesignationID], [DepartmentID], [Mobile], [WorkEmail], [PersonalEmail], [UserID], [Password], [IsAdmin], [IsActive], [ActivatedDate], [Order], [BiometricID], [MapleID], [DOB], [DOJ], [Gender], [MaritalStatus], [DOA], [BloodGroup], [EmergencyContactPerson], [EmergencyContactNumber], [EmergencyContactRelation], [IsBilling], [IsProfileUpdated], [SlackId]) VALUES (44, N'Sudeep', N'Badugu', 9, 1, N'9989858540', N'sudeep.b@maple-software.com', NULL, N'sudeep', N'23D42F5F3F66498B2C8FF4C20B8C5AC826E47146', 0, 0, CAST(N'2018-11-13 11:53:54.197' AS DateTime), 27, N'01323814', NULL, NULL, NULL, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL)
GO
INSERT [AT2].[tblEmployees] ([EmployeeID], [FirstName], [LastName], [DesignationID], [DepartmentID], [Mobile], [WorkEmail], [PersonalEmail], [UserID], [Password], [IsAdmin], [IsActive], [ActivatedDate], [Order], [BiometricID], [MapleID], [DOB], [DOJ], [Gender], [MaritalStatus], [DOA], [BloodGroup], [EmergencyContactPerson], [EmergencyContactNumber], [EmergencyContactRelation], [IsBilling], [IsProfileUpdated], [SlackId]) VALUES (45, N'Sudha Kiranmayee', N'Y', 4, 1, N'7306065888', N'sudha.y@maple-software.com', NULL, N'sudha ', N'23D42F5F3F66498B2C8FF4C20B8C5AC826E47146', 0, 0, CAST(N'2017-10-24 11:06:02.340' AS DateTime), 28, NULL, NULL, NULL, NULL, 2, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL)
GO
INSERT [AT2].[tblEmployees] ([EmployeeID], [FirstName], [LastName], [DesignationID], [DepartmentID], [Mobile], [WorkEmail], [PersonalEmail], [UserID], [Password], [IsAdmin], [IsActive], [ActivatedDate], [Order], [BiometricID], [MapleID], [DOB], [DOJ], [Gender], [MaritalStatus], [DOA], [BloodGroup], [EmergencyContactPerson], [EmergencyContactNumber], [EmergencyContactRelation], [IsBilling], [IsProfileUpdated], [SlackId]) VALUES (46, N'Ranjith', N'Bandela', 4, 1, N'8106440812', N'ranjith.b@maple-software.com', NULL, N'ranjith', N'23D42F5F3F66498B2C8FF4C20B8C5AC826E47146', 0, 0, CAST(N'2017-10-24 11:05:58.357' AS DateTime), 29, NULL, NULL, NULL, NULL, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL)
GO
INSERT [AT2].[tblEmployees] ([EmployeeID], [FirstName], [LastName], [DesignationID], [DepartmentID], [Mobile], [WorkEmail], [PersonalEmail], [UserID], [Password], [IsAdmin], [IsActive], [ActivatedDate], [Order], [BiometricID], [MapleID], [DOB], [DOJ], [Gender], [MaritalStatus], [DOA], [BloodGroup], [EmergencyContactPerson], [EmergencyContactNumber], [EmergencyContactRelation], [IsBilling], [IsProfileUpdated], [SlackId]) VALUES (47, N'Deepika', N'Venegalla', 3, 1, N'9600107606', N'deepika.v@maple-software.com', NULL, N'deepika', N'23D42F5F3F66498B2C8FF4C20B8C5AC826E47146', 0, 0, CAST(N'2018-02-27 20:58:56.647' AS DateTime), 30, N'01110135', NULL, NULL, NULL, 2, NULL, CAST(N'2019-04-22' AS Date), NULL, NULL, NULL, NULL, NULL, 0, NULL)
GO
INSERT [AT2].[tblEmployees] ([EmployeeID], [FirstName], [LastName], [DesignationID], [DepartmentID], [Mobile], [WorkEmail], [PersonalEmail], [UserID], [Password], [IsAdmin], [IsActive], [ActivatedDate], [Order], [BiometricID], [MapleID], [DOB], [DOJ], [Gender], [MaritalStatus], [DOA], [BloodGroup], [EmergencyContactPerson], [EmergencyContactNumber], [EmergencyContactRelation], [IsBilling], [IsProfileUpdated], [SlackId]) VALUES (48, N'Rama Krishna', N'Jataprolu', 4, 1, N'9059078061', N'rk.sw@maple-software.com', NULL, N'ramakrishna', N'23D42F5F3F66498B2C8FF4C20B8C5AC826E47146', 0, 0, CAST(N'2018-12-31 12:20:42.363' AS DateTime), 31, NULL, NULL, NULL, NULL, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL)
GO
INSERT [AT2].[tblEmployees] ([EmployeeID], [FirstName], [LastName], [DesignationID], [DepartmentID], [Mobile], [WorkEmail], [PersonalEmail], [UserID], [Password], [IsAdmin], [IsActive], [ActivatedDate], [Order], [BiometricID], [MapleID], [DOB], [DOJ], [Gender], [MaritalStatus], [DOA], [BloodGroup], [EmergencyContactPerson], [EmergencyContactNumber], [EmergencyContactRelation], [IsBilling], [IsProfileUpdated], [SlackId]) VALUES (49, N'Nagapradeep', N'Naguri', 1012, 1051, N'9381406194', N'nnpradeep_sw@maple-software.com', N'nnpradeep_sw@maple-software.com', N'pradeep', N'23D42F5F3F66498B2C8FF4C20B8C5AC826E47146', 0, 0, CAST(N'2018-08-28 12:35:23.900' AS DateTime), 32, N'08373182', NULL, CAST(N'1900-01-01' AS Date), CAST(N'1900-01-01' AS Date), 1, 0, CAST(N'1900-01-01' AS Date), N'-1', NULL, NULL, NULL, NULL, 1, NULL)
GO
INSERT [AT2].[tblEmployees] ([EmployeeID], [FirstName], [LastName], [DesignationID], [DepartmentID], [Mobile], [WorkEmail], [PersonalEmail], [UserID], [Password], [IsAdmin], [IsActive], [ActivatedDate], [Order], [BiometricID], [MapleID], [DOB], [DOJ], [Gender], [MaritalStatus], [DOA], [BloodGroup], [EmergencyContactPerson], [EmergencyContactNumber], [EmergencyContactRelation], [IsBilling], [IsProfileUpdated], [SlackId]) VALUES (50, N'Rama Aditya', N'Challapalli', 1043, 1068, N'7396017501', N'aditya_sw@maple-software.com', N'aditya_sw@maple-software.com', N'aditya', N'23D42F5F3F66498B2C8FF4C20B8C5AC826E47146', 0, 1, CAST(N'2018-09-03 17:00:16.190' AS DateTime), 33, N'08512221', NULL, CAST(N'1900-01-01' AS Date), CAST(N'2018-03-29' AS Date), 1, 0, CAST(N'1900-01-01' AS Date), N'-1', NULL, NULL, NULL, NULL, 1, N'UCME3NZJA')
GO
INSERT [AT2].[tblEmployees] ([EmployeeID], [FirstName], [LastName], [DesignationID], [DepartmentID], [Mobile], [WorkEmail], [PersonalEmail], [UserID], [Password], [IsAdmin], [IsActive], [ActivatedDate], [Order], [BiometricID], [MapleID], [DOB], [DOJ], [Gender], [MaritalStatus], [DOA], [BloodGroup], [EmergencyContactPerson], [EmergencyContactNumber], [EmergencyContactRelation], [IsBilling], [IsProfileUpdated], [SlackId]) VALUES (51, N'Sandeep', N'Vinnakota', 1043, 1069, N'8790467636', N'sandeep_sw@maple-software.com', N'sandeep@gmail.com', N'sandeep', N'23D42F5F3F66498B2C8FF4C20B8C5AC826E47146', 0, 1, CAST(N'2018-10-16 14:15:06.000' AS DateTime), 34, N'01088689', NULL, CAST(N'1900-01-01' AS Date), CAST(N'2018-03-29' AS Date), 1, 0, CAST(N'1900-01-01' AS Date), N'A+', NULL, NULL, NULL, NULL, 1, N'U901VL0LU')
GO
INSERT [AT2].[tblEmployees] ([EmployeeID], [FirstName], [LastName], [DesignationID], [DepartmentID], [Mobile], [WorkEmail], [PersonalEmail], [UserID], [Password], [IsAdmin], [IsActive], [ActivatedDate], [Order], [BiometricID], [MapleID], [DOB], [DOJ], [Gender], [MaritalStatus], [DOA], [BloodGroup], [EmergencyContactPerson], [EmergencyContactNumber], [EmergencyContactRelation], [IsBilling], [IsProfileUpdated], [SlackId]) VALUES (52, N'Sai Subramanyam ', N'Ch', 4, 1068, N'9491989656', N'subbu.maple@gmail.com', N'subbu@maple-software.com', N'subbu', N'23D42F5F3F66498B2C8FF4C20B8C5AC826E47146', 0, 1, CAST(N'2018-12-31 17:54:13.180' AS DateTime), 35, N'01108157', NULL, CAST(N'1998-07-27' AS Date), CAST(N'2018-07-17' AS Date), 1, 0, CAST(N'1900-01-01' AS Date), N'A+', N'mouni', N'9491989656', N'wife', NULL, 1, N'UF3TM9K8B')
GO
INSERT [AT2].[tblEmployees] ([EmployeeID], [FirstName], [LastName], [DesignationID], [DepartmentID], [Mobile], [WorkEmail], [PersonalEmail], [UserID], [Password], [IsAdmin], [IsActive], [ActivatedDate], [Order], [BiometricID], [MapleID], [DOB], [DOJ], [Gender], [MaritalStatus], [DOA], [BloodGroup], [EmergencyContactPerson], [EmergencyContactNumber], [EmergencyContactRelation], [IsBilling], [IsProfileUpdated], [SlackId]) VALUES (53, N'Reshma', N'P', 1043, 1068, N'8247570164', N'reshma.maple2@gmail.com', N'reshma.maple2@gmail.com', N'reshma', N'23D42F5F3F66498B2C8FF4C20B8C5AC826E47146', 0, 1, CAST(N'2018-12-31 17:55:42.667' AS DateTime), 36, N'01113666', N'2345', CAST(N'1999-05-07' AS Date), CAST(N'2018-04-07' AS Date), 2, 0, CAST(N'1900-01-01' AS Date), N'A+', N'Ravi.P', N'8988655578', N'Father', NULL, 1, N'UF3915QKA')
GO
INSERT [AT2].[tblEmployees] ([EmployeeID], [FirstName], [LastName], [DesignationID], [DepartmentID], [Mobile], [WorkEmail], [PersonalEmail], [UserID], [Password], [IsAdmin], [IsActive], [ActivatedDate], [Order], [BiometricID], [MapleID], [DOB], [DOJ], [Gender], [MaritalStatus], [DOA], [BloodGroup], [EmergencyContactPerson], [EmergencyContactNumber], [EmergencyContactRelation], [IsBilling], [IsProfileUpdated], [SlackId]) VALUES (54, N'Janaki', N'D', 1043, 1068, N'9912896878', N'janaki.maple@gmail.com', N'janaki.d1996@gmail.com', N'janaki', N'23D42F5F3F66498B2C8FF4C20B8C5AC826E47146', 0, 1, CAST(N'2018-12-31 17:56:44.713' AS DateTime), 37, N'01229237', N'1234578', CAST(N'1996-04-24' AS Date), CAST(N'2018-05-07' AS Date), 2, 0, CAST(N'1900-01-01' AS Date), N'B+', N'Ramachandra rao', N'8885209020', N'father', NULL, 1, N'UF41ABR8A')
GO
INSERT [AT2].[tblEmployees] ([EmployeeID], [FirstName], [LastName], [DesignationID], [DepartmentID], [Mobile], [WorkEmail], [PersonalEmail], [UserID], [Password], [IsAdmin], [IsActive], [ActivatedDate], [Order], [BiometricID], [MapleID], [DOB], [DOJ], [Gender], [MaritalStatus], [DOA], [BloodGroup], [EmergencyContactPerson], [EmergencyContactNumber], [EmergencyContactRelation], [IsBilling], [IsProfileUpdated], [SlackId]) VALUES (55, N'Ram Singh', N'KGS', 4, 1, N'8185808415', N'ramsingh.maple@gmail.com', N'ram@gmail.com', N'ramsingh', N'23D42F5F3F66498B2C8FF4C20B8C5AC826E47146', 0, 0, CAST(N'2019-01-21 12:18:01.870' AS DateTime), 38, NULL, NULL, CAST(N'1997-01-01' AS Date), CAST(N'1900-01-01' AS Date), 1, 0, CAST(N'1900-01-01' AS Date), N'o+', N'shivani', N'9911772255', N'mother', NULL, 1, NULL)
GO
INSERT [AT2].[tblEmployees] ([EmployeeID], [FirstName], [LastName], [DesignationID], [DepartmentID], [Mobile], [WorkEmail], [PersonalEmail], [UserID], [Password], [IsAdmin], [IsActive], [ActivatedDate], [Order], [BiometricID], [MapleID], [DOB], [DOJ], [Gender], [MaritalStatus], [DOA], [BloodGroup], [EmergencyContactPerson], [EmergencyContactNumber], [EmergencyContactRelation], [IsBilling], [IsProfileUpdated], [SlackId]) VALUES (60, N'sam', N'tom', 2, 1, N'8278679809', N'Sam@gmail.com', N'Sam@gmail.com', N'gedashfjh', N'23D42F5F3F66498B2C8FF4C20B8C5AC826E47146', 0, 0, CAST(N'1900-01-01 00:00:00.000' AS DateTime), NULL, N'2523450159', NULL, CAST(N'2018-02-02' AS Date), CAST(N'2018-02-02' AS Date), 1, 1, CAST(N'2017-10-27' AS Date), N'-1', NULL, NULL, NULL, NULL, 1, NULL)
GO
INSERT [AT2].[tblEmployees] ([EmployeeID], [FirstName], [LastName], [DesignationID], [DepartmentID], [Mobile], [WorkEmail], [PersonalEmail], [UserID], [Password], [IsAdmin], [IsActive], [ActivatedDate], [Order], [BiometricID], [MapleID], [DOB], [DOJ], [Gender], [MaritalStatus], [DOA], [BloodGroup], [EmergencyContactPerson], [EmergencyContactNumber], [EmergencyContactRelation], [IsBilling], [IsProfileUpdated], [SlackId]) VALUES (61, N'swetha', N'Rani', 3, 1, N'9886798090', N'swetha@gmail.com', N'swetha@gmail.com', N'swetha', N'23D42F5F3F66498B2C8FF4C20B8C5AC826E47146', 0, 0, CAST(N'1900-01-01 00:00:00.000' AS DateTime), NULL, N'2523450159', NULL, CAST(N'1990-01-02' AS Date), CAST(N'2016-06-02' AS Date), 1, 0, CAST(N'2018-02-02' AS Date), NULL, NULL, NULL, NULL, NULL, 0, NULL)
GO
INSERT [AT2].[tblEmployees] ([EmployeeID], [FirstName], [LastName], [DesignationID], [DepartmentID], [Mobile], [WorkEmail], [PersonalEmail], [UserID], [Password], [IsAdmin], [IsActive], [ActivatedDate], [Order], [BiometricID], [MapleID], [DOB], [DOJ], [Gender], [MaritalStatus], [DOA], [BloodGroup], [EmergencyContactPerson], [EmergencyContactNumber], [EmergencyContactRelation], [IsBilling], [IsProfileUpdated], [SlackId]) VALUES (68, N'gdjhg', N'gdjhg', 9, 1, N'9456234170', N'gdjhg@gmail.com', N'gdjhg@gmail.com', N'gdjhg', N'23D42F5F3F66498B2C8FF4C20B8C5AC826E47146', 0, 0, CAST(N'1900-01-01 00:00:00.000' AS DateTime), NULL, N'gdjhg122', N'234r4', CAST(N'1995-03-05' AS Date), CAST(N'2018-12-05' AS Date), 2, 0, CAST(N'1900-01-01' AS Date), N'4 ', N'tfgy', NULL, NULL, NULL, 0, NULL)
GO
INSERT [AT2].[tblEmployees] ([EmployeeID], [FirstName], [LastName], [DesignationID], [DepartmentID], [Mobile], [WorkEmail], [PersonalEmail], [UserID], [Password], [IsAdmin], [IsActive], [ActivatedDate], [Order], [BiometricID], [MapleID], [DOB], [DOJ], [Gender], [MaritalStatus], [DOA], [BloodGroup], [EmergencyContactPerson], [EmergencyContactNumber], [EmergencyContactRelation], [IsBilling], [IsProfileUpdated], [SlackId]) VALUES (69, N'jahnavi', N'jahnavi', 6, 1011, N'8566234170', N'jahnavi@gmail.com', N'jahnavi@gmail.com', N'jahnavi', N'23D42F5F3F66498B2C8FF4C20B8C5AC826E47146', 0, 0, CAST(N'1900-01-01 00:00:00.000' AS DateTime), NULL, N'abcd122', N'8785754645', CAST(N'2000-11-14' AS Date), CAST(N'2019-02-11' AS Date), 2, 0, CAST(N'1900-01-01' AS Date), N'A-', N'swetha', N'8566231548', N'sister', NULL, 1, NULL)
GO
INSERT [AT2].[tblEmployees] ([EmployeeID], [FirstName], [LastName], [DesignationID], [DepartmentID], [Mobile], [WorkEmail], [PersonalEmail], [UserID], [Password], [IsAdmin], [IsActive], [ActivatedDate], [Order], [BiometricID], [MapleID], [DOB], [DOJ], [Gender], [MaritalStatus], [DOA], [BloodGroup], [EmergencyContactPerson], [EmergencyContactNumber], [EmergencyContactRelation], [IsBilling], [IsProfileUpdated], [SlackId]) VALUES (70, N'Ram', N'shetty', 6, 1, N'8766234170', N'Ram@gmail.com', N'Ram@gmail.com', N'Ram', N'23D42F5F3F66498B2C8FF4C20B8C5AC826E47146', 0, 0, CAST(N'1900-01-01 00:00:00.000' AS DateTime), NULL, N'1234aa', N'1234', CAST(N'1992-03-04' AS Date), CAST(N'1999-03-15' AS Date), 2, 0, CAST(N'1900-01-01' AS Date), N'-1', N'tfgy', N'8766234170', N'tfgy', NULL, 1, NULL)
GO
INSERT [AT2].[tblEmployees] ([EmployeeID], [FirstName], [LastName], [DesignationID], [DepartmentID], [Mobile], [WorkEmail], [PersonalEmail], [UserID], [Password], [IsAdmin], [IsActive], [ActivatedDate], [Order], [BiometricID], [MapleID], [DOB], [DOJ], [Gender], [MaritalStatus], [DOA], [BloodGroup], [EmergencyContactPerson], [EmergencyContactNumber], [EmergencyContactRelation], [IsBilling], [IsProfileUpdated], [SlackId]) VALUES (71, N'sample', N'samp', 6, 1006, N'9566234458', N'sample@gmail.com', N'sample@gmail.com', N'sample', N'23D42F5F3F66498B2C8FF4C20B8C5AC826E47146', 0, 0, CAST(N'1900-01-01 00:00:00.000' AS DateTime), NULL, N'sample', N'08987746', CAST(N'1990-03-05' AS Date), CAST(N'2019-02-11' AS Date), 2, 0, CAST(N'1900-01-01' AS Date), N'A+', N'tfgy', N'9998784521', N'fghfhf', NULL, 1, NULL)
GO
INSERT [AT2].[tblEmployees] ([EmployeeID], [FirstName], [LastName], [DesignationID], [DepartmentID], [Mobile], [WorkEmail], [PersonalEmail], [UserID], [Password], [IsAdmin], [IsActive], [ActivatedDate], [Order], [BiometricID], [MapleID], [DOB], [DOJ], [Gender], [MaritalStatus], [DOA], [BloodGroup], [EmergencyContactPerson], [EmergencyContactNumber], [EmergencyContactRelation], [IsBilling], [IsProfileUpdated], [SlackId]) VALUES (72, N'Maple', N'gdjhg', 2, 2, N'9566234170', N'gdjhg@gmail.com', N'sample@gmail.com', N'MapleReshma', N'23D42F5F3F66498B2C8FF4C20B8C5AC826E47146', 0, 0, CAST(N'1900-01-01 00:00:00.000' AS DateTime), NULL, N'sample', N'etyuyh2', CAST(N'1999-03-11' AS Date), CAST(N'2019-02-07' AS Date), 2, 0, CAST(N'1900-01-01' AS Date), N'B+', N'tfgy', NULL, NULL, NULL, 0, NULL)
GO
INSERT [AT2].[tblEmployees] ([EmployeeID], [FirstName], [LastName], [DesignationID], [DepartmentID], [Mobile], [WorkEmail], [PersonalEmail], [UserID], [Password], [IsAdmin], [IsActive], [ActivatedDate], [Order], [BiometricID], [MapleID], [DOB], [DOJ], [Gender], [MaritalStatus], [DOA], [BloodGroup], [EmergencyContactPerson], [EmergencyContactNumber], [EmergencyContactRelation], [IsBilling], [IsProfileUpdated], [SlackId]) VALUES (73, N'sita', N'sri', 3, 1011, N'9966234170', N'sita@gmail.com', N'sita@gmail.com', N'sita', N'23D42F5F3F66498B2C8FF4C20B8C5AC826E47146', 0, 0, CAST(N'1900-01-01 00:00:00.000' AS DateTime), NULL, N'aaa122', N'656577', CAST(N'2011-02-28' AS Date), CAST(N'2019-02-27' AS Date), 1, 1, CAST(N'2011-02-08' AS Date), N'B+', N'madhumathi', N'9966234170', N'sister', NULL, 1, NULL)
GO
INSERT [AT2].[tblEmployees] ([EmployeeID], [FirstName], [LastName], [DesignationID], [DepartmentID], [Mobile], [WorkEmail], [PersonalEmail], [UserID], [Password], [IsAdmin], [IsActive], [ActivatedDate], [Order], [BiometricID], [MapleID], [DOB], [DOJ], [Gender], [MaritalStatus], [DOA], [BloodGroup], [EmergencyContactPerson], [EmergencyContactNumber], [EmergencyContactRelation], [IsBilling], [IsProfileUpdated], [SlackId]) VALUES (74, N'sannaya', N'sannaya', 3, 1, N'9966234170', N'sita@gmail.com', N'sita@gmail.com', N'sannaya', N'23D42F5F3F66498B2C8FF4C20B8C5AC826E47146', 0, 0, CAST(N'1900-01-01 00:00:00.000' AS DateTime), NULL, N'234aa', N'undefined', CAST(N'1990-03-01' AS Date), CAST(N'2018-02-07' AS Date), 1, 1, CAST(N'2010-03-05' AS Date), N'B+', N'tfgy', N'1323244444', N'test', NULL, 1, NULL)
GO
INSERT [AT2].[tblEmployees] ([EmployeeID], [FirstName], [LastName], [DesignationID], [DepartmentID], [Mobile], [WorkEmail], [PersonalEmail], [UserID], [Password], [IsAdmin], [IsActive], [ActivatedDate], [Order], [BiometricID], [MapleID], [DOB], [DOJ], [Gender], [MaritalStatus], [DOA], [BloodGroup], [EmergencyContactPerson], [EmergencyContactNumber], [EmergencyContactRelation], [IsBilling], [IsProfileUpdated], [SlackId]) VALUES (75, N'sidharth', N'sidharth', 3, 1, N'8576234170', N'sidharth@gmail.com', N'sidharth@gmail.com', N'sidharth', N'23D42F5F3F66498B2C8FF4C20B8C5AC826E47146', 0, 0, CAST(N'1900-01-01 00:00:00.000' AS DateTime), NULL, N'15268552255', N'undefined', CAST(N'2018-02-27' AS Date), CAST(N'2011-03-05' AS Date), 1, 1, CAST(N'2019-02-06' AS Date), N'B-', N'khih', N'8766234170', N'aaaa', NULL, 1, NULL)
GO
INSERT [AT2].[tblEmployees] ([EmployeeID], [FirstName], [LastName], [DesignationID], [DepartmentID], [Mobile], [WorkEmail], [PersonalEmail], [UserID], [Password], [IsAdmin], [IsActive], [ActivatedDate], [Order], [BiometricID], [MapleID], [DOB], [DOJ], [Gender], [MaritalStatus], [DOA], [BloodGroup], [EmergencyContactPerson], [EmergencyContactNumber], [EmergencyContactRelation], [IsBilling], [IsProfileUpdated], [SlackId]) VALUES (76, N'test', N'test', 4, 1, N'8576234170', N'test@gmail.com', N'test@gmail.com', N'test', N'23D42F5F3F66498B2C8FF4C20B8C5AC826E47146', 0, 0, CAST(N'1900-01-01 00:00:00.000' AS DateTime), NULL, N'test', N'test', CAST(N'1990-03-01' AS Date), CAST(N'2018-12-05' AS Date), 1, 1, CAST(N'2019-02-05' AS Date), N'A+', NULL, NULL, NULL, NULL, 0, NULL)
GO
INSERT [AT2].[tblEmployees] ([EmployeeID], [FirstName], [LastName], [DesignationID], [DepartmentID], [Mobile], [WorkEmail], [PersonalEmail], [UserID], [Password], [IsAdmin], [IsActive], [ActivatedDate], [Order], [BiometricID], [MapleID], [DOB], [DOJ], [Gender], [MaritalStatus], [DOA], [BloodGroup], [EmergencyContactPerson], [EmergencyContactNumber], [EmergencyContactRelation], [IsBilling], [IsProfileUpdated], [SlackId]) VALUES (77, N'test', N'test', 4, 1, N'8576234170', N'test@gmail.com', N'test@gmail.com', N'test123', N'23D42F5F3F66498B2C8FF4C20B8C5AC826E47146', 0, 0, CAST(N'1900-01-01 00:00:00.000' AS DateTime), NULL, N'test', N'test', CAST(N'1990-03-01' AS Date), CAST(N'2018-12-05' AS Date), 1, 1, CAST(N'2019-02-05' AS Date), N'A+', NULL, NULL, NULL, NULL, 0, NULL)
GO
INSERT [AT2].[tblEmployees] ([EmployeeID], [FirstName], [LastName], [DesignationID], [DepartmentID], [Mobile], [WorkEmail], [PersonalEmail], [UserID], [Password], [IsAdmin], [IsActive], [ActivatedDate], [Order], [BiometricID], [MapleID], [DOB], [DOJ], [Gender], [MaritalStatus], [DOA], [BloodGroup], [EmergencyContactPerson], [EmergencyContactNumber], [EmergencyContactRelation], [IsBilling], [IsProfileUpdated], [SlackId]) VALUES (78, N'janaki123', N'aaa', 1, 3, N'9912896875', N'janaki.d1996@gmail.com', N'Sandhya@gmail.com', N'234abcd', N'23D42F5F3F66498B2C8FF4C20B8C5AC826E47146', 0, 0, CAST(N'1900-01-01 00:00:00.000' AS DateTime), NULL, N'1234', N'34', CAST(N'1990-03-01' AS Date), CAST(N'2018-12-02' AS Date), 1, 0, CAST(N'1900-01-01' AS Date), N'A+', N'tfgy', NULL, NULL, NULL, 0, NULL)
GO
INSERT [AT2].[tblEmployees] ([EmployeeID], [FirstName], [LastName], [DesignationID], [DepartmentID], [Mobile], [WorkEmail], [PersonalEmail], [UserID], [Password], [IsAdmin], [IsActive], [ActivatedDate], [Order], [BiometricID], [MapleID], [DOB], [DOJ], [Gender], [MaritalStatus], [DOA], [BloodGroup], [EmergencyContactPerson], [EmergencyContactNumber], [EmergencyContactRelation], [IsBilling], [IsProfileUpdated], [SlackId]) VALUES (79, N'gdjhg', N'Bose', 4, 1, N'7777777777', N'gdjhg@gmail.com', N'gdjhg@gmail.com', N'ppppp', N'23D42F5F3F66498B2C8FF4C20B8C5AC826E47146', 0, 0, CAST(N'1900-01-01 00:00:00.000' AS DateTime), NULL, N'gdjhg122', N'234r433', CAST(N'2018-02-27' AS Date), CAST(N'2018-12-05' AS Date), 1, 0, CAST(N'2011-02-02' AS Date), N'A+', NULL, NULL, NULL, NULL, 0, NULL)
GO
INSERT [AT2].[tblEmployees] ([EmployeeID], [FirstName], [LastName], [DesignationID], [DepartmentID], [Mobile], [WorkEmail], [PersonalEmail], [UserID], [Password], [IsAdmin], [IsActive], [ActivatedDate], [Order], [BiometricID], [MapleID], [DOB], [DOJ], [Gender], [MaritalStatus], [DOA], [BloodGroup], [EmergencyContactPerson], [EmergencyContactNumber], [EmergencyContactRelation], [IsBilling], [IsProfileUpdated], [SlackId]) VALUES (80, N'Indira', N'Indira', 3, 1003, N'7895644589', N'Indira@gmail.com', N'Indira@gmail.com', N'Indira', N'23D42F5F3F66498B2C8FF4C20B8C5AC826E47146', 0, 0, CAST(N'1900-01-01 00:00:00.000' AS DateTime), NULL, N'0909813333', NULL, CAST(N'2001-03-05' AS Date), CAST(N'2011-02-08' AS Date), 1, 0, CAST(N'2011-02-28' AS Date), N'-1', NULL, NULL, NULL, NULL, 1, NULL)
GO
INSERT [AT2].[tblEmployees] ([EmployeeID], [FirstName], [LastName], [DesignationID], [DepartmentID], [Mobile], [WorkEmail], [PersonalEmail], [UserID], [Password], [IsAdmin], [IsActive], [ActivatedDate], [Order], [BiometricID], [MapleID], [DOB], [DOJ], [Gender], [MaritalStatus], [DOA], [BloodGroup], [EmergencyContactPerson], [EmergencyContactNumber], [EmergencyContactRelation], [IsBilling], [IsProfileUpdated], [SlackId]) VALUES (81, N'Sandhya', N'Rani', 5, 1006, N'9566234170', N'Sandhya@gmail.com', N'Sandhya@gmail.com', N'Sandhya', N'23D42F5F3F66498B2C8FF4C20B8C5AC826E47146', 0, 0, CAST(N'1900-01-01 00:00:00.000' AS DateTime), 38, N'234aa', N'67677', CAST(N'2019-03-08' AS Date), CAST(N'2018-12-05' AS Date), 2, 0, CAST(N'1900-01-01' AS Date), N'A+', N'Sandhya', N'9566234170', N'Sandhya', NULL, 1, NULL)
GO
INSERT [AT2].[tblEmployees] ([EmployeeID], [FirstName], [LastName], [DesignationID], [DepartmentID], [Mobile], [WorkEmail], [PersonalEmail], [UserID], [Password], [IsAdmin], [IsActive], [ActivatedDate], [Order], [BiometricID], [MapleID], [DOB], [DOJ], [Gender], [MaritalStatus], [DOA], [BloodGroup], [EmergencyContactPerson], [EmergencyContactNumber], [EmergencyContactRelation], [IsBilling], [IsProfileUpdated], [SlackId]) VALUES (82, N'Veena', N'madhuri', 4, 1, N'9966234187', N'Veena@gmail.com', N'Veena@gmail.com', N'Veena', N'23D42F5F3F66498B2C8FF4C20B8C5AC826E47146', 0, 0, CAST(N'1900-01-01 00:00:00.000' AS DateTime), 38, N'2211', N'1122', CAST(N'1980-03-05' AS Date), CAST(N'2014-02-07' AS Date), 1, 0, CAST(N'1900-01-01' AS Date), N'AB', N'madhumathi', N'9966234187', NULL, NULL, 0, NULL)
GO
INSERT [AT2].[tblEmployees] ([EmployeeID], [FirstName], [LastName], [DesignationID], [DepartmentID], [Mobile], [WorkEmail], [PersonalEmail], [UserID], [Password], [IsAdmin], [IsActive], [ActivatedDate], [Order], [BiometricID], [MapleID], [DOB], [DOJ], [Gender], [MaritalStatus], [DOA], [BloodGroup], [EmergencyContactPerson], [EmergencyContactNumber], [EmergencyContactRelation], [IsBilling], [IsProfileUpdated], [SlackId]) VALUES (86, N'kavya', N'kavya', 1016, 1009, N'7895644589', N'abcd@gmail.com', N'abcd@gmail.com', N'abcd', N'23D42F5F3F66498B2C8FF4C20B8C5AC826E47146', 0, 0, CAST(N'1900-01-01 00:00:00.000' AS DateTime), 38, NULL, NULL, CAST(N'1994-06-14' AS Date), CAST(N'2019-02-07' AS Date), 1, 0, CAST(N'1900-01-01' AS Date), N'o+', N'madhu', N'8885209020', N'father', NULL, 1, NULL)
GO
INSERT [AT2].[tblEmployees] ([EmployeeID], [FirstName], [LastName], [DesignationID], [DepartmentID], [Mobile], [WorkEmail], [PersonalEmail], [UserID], [Password], [IsAdmin], [IsActive], [ActivatedDate], [Order], [BiometricID], [MapleID], [DOB], [DOJ], [Gender], [MaritalStatus], [DOA], [BloodGroup], [EmergencyContactPerson], [EmergencyContactNumber], [EmergencyContactRelation], [IsBilling], [IsProfileUpdated], [SlackId]) VALUES (87, N'bhavana', N'bhavana', 2, 1011, N'9566234458', N'bhavana@gmail.com', N'bhavana@gmail.com', N'bhavana', N'23D42F5F3F66498B2C8FF4C20B8C5AC826E47146', 0, 0, CAST(N'1900-01-01 00:00:00.000' AS DateTime), 38, NULL, NULL, CAST(N'1995-03-08' AS Date), CAST(N'2018-12-02' AS Date), 1, 0, CAST(N'1900-01-01' AS Date), N'B-', N'tfgy', N'9566234170', N'aaaa', NULL, 1, NULL)
GO
INSERT [AT2].[tblEmployees] ([EmployeeID], [FirstName], [LastName], [DesignationID], [DepartmentID], [Mobile], [WorkEmail], [PersonalEmail], [UserID], [Password], [IsAdmin], [IsActive], [ActivatedDate], [Order], [BiometricID], [MapleID], [DOB], [DOJ], [Gender], [MaritalStatus], [DOA], [BloodGroup], [EmergencyContactPerson], [EmergencyContactNumber], [EmergencyContactRelation], [IsBilling], [IsProfileUpdated], [SlackId]) VALUES (88, N'roopa', N'roopa', 3, 1003, N'9878676767', N'roopa@gmail.com', N'roopa@gmail.com', N'roopa', N'23D42F5F3F66498B2C8FF4C20B8C5AC826E47146', 0, 0, CAST(N'1900-01-01 00:00:00.000' AS DateTime), 38, NULL, N'4545', CAST(N'2019-03-06' AS Date), CAST(N'1900-01-01' AS Date), 1, 1, CAST(N'2019-02-26' AS Date), N'-1', N'abcd', N'9878689088', N'hgsfhgs', NULL, 0, NULL)
GO
INSERT [AT2].[tblEmployees] ([EmployeeID], [FirstName], [LastName], [DesignationID], [DepartmentID], [Mobile], [WorkEmail], [PersonalEmail], [UserID], [Password], [IsAdmin], [IsActive], [ActivatedDate], [Order], [BiometricID], [MapleID], [DOB], [DOJ], [Gender], [MaritalStatus], [DOA], [BloodGroup], [EmergencyContactPerson], [EmergencyContactNumber], [EmergencyContactRelation], [IsBilling], [IsProfileUpdated], [SlackId]) VALUES (89, N'rahul', N'rao', 3, 1, N'9878787878', N'rahul@gmail.com', N'rahul@gmail.com', N'rahul', N'23D42F5F3F66498B2C8FF4C20B8C5AC826E47146', 0, 0, CAST(N'1900-01-01 00:00:00.000' AS DateTime), 38, N'9876', N'undefined', CAST(N'1999-02-02' AS Date), CAST(N'2019-03-06' AS Date), 1, 1, CAST(N'2019-02-25' AS Date), N'A-', N'test', N'8766234170', N'tdrtrd', NULL, 0, NULL)
GO
INSERT [AT2].[tblEmployees] ([EmployeeID], [FirstName], [LastName], [DesignationID], [DepartmentID], [Mobile], [WorkEmail], [PersonalEmail], [UserID], [Password], [IsAdmin], [IsActive], [ActivatedDate], [Order], [BiometricID], [MapleID], [DOB], [DOJ], [Gender], [MaritalStatus], [DOA], [BloodGroup], [EmergencyContactPerson], [EmergencyContactNumber], [EmergencyContactRelation], [IsBilling], [IsProfileUpdated], [SlackId]) VALUES (97, N'sfdfg', N'fdgdf', 5, 1, N'4557555555', N'samp252le@gmail.com', N'Sandhyadsafs@gmail.com', N'siva123', N'23D42F5F3F66498B2C8FF4C20B8C5AC826E47146', 0, 0, CAST(N'1900-01-01 00:00:00.000' AS DateTime), 38, N'fgf', N'fg', CAST(N'1995-03-05' AS Date), CAST(N'1900-01-01' AS Date), 1, 0, CAST(N'1900-01-01' AS Date), N'B+', N'tfgy', N'8766234170', N'test', NULL, 1, NULL)
GO
INSERT [AT2].[tblEmployees] ([EmployeeID], [FirstName], [LastName], [DesignationID], [DepartmentID], [Mobile], [WorkEmail], [PersonalEmail], [UserID], [Password], [IsAdmin], [IsActive], [ActivatedDate], [Order], [BiometricID], [MapleID], [DOB], [DOJ], [Gender], [MaritalStatus], [DOA], [BloodGroup], [EmergencyContactPerson], [EmergencyContactNumber], [EmergencyContactRelation], [IsBilling], [IsProfileUpdated], [SlackId]) VALUES (98, N'example', N'example', 6, 3, N'8656568989', NULL, N'example@gmail.com', N'example', N'23D42F5F3F66498B2C8FF4C20B8C5AC826E47146', 0, 0, CAST(N'1900-01-01 00:00:00.000' AS DateTime), 38, N'65565', NULL, CAST(N'1900-01-01' AS Date), CAST(N'1900-01-01' AS Date), 1, 0, CAST(N'1900-01-01' AS Date), N'-1', NULL, NULL, NULL, NULL, 0, NULL)
GO
INSERT [AT2].[tblEmployees] ([EmployeeID], [FirstName], [LastName], [DesignationID], [DepartmentID], [Mobile], [WorkEmail], [PersonalEmail], [UserID], [Password], [IsAdmin], [IsActive], [ActivatedDate], [Order], [BiometricID], [MapleID], [DOB], [DOJ], [Gender], [MaritalStatus], [DOA], [BloodGroup], [EmergencyContactPerson], [EmergencyContactNumber], [EmergencyContactRelation], [IsBilling], [IsProfileUpdated], [SlackId]) VALUES (99, N'pallavi', N'sai', 5, 1009, N'9876543210', N'janaki.maple@gmail.com', N'janaki.d1996@gmail.com', N'sai', N'23D42F5F3F66498B2C8FF4C20B8C5AC826E47146', 0, 0, CAST(N'1900-01-01 00:00:00.000' AS DateTime), 38, N'01229239', N'12345', CAST(N'2018-12-05' AS Date), CAST(N'2019-01-03' AS Date), 2, 0, CAST(N'1900-01-01' AS Date), N'A-', N'Ramachandra rao', N'(987) 654-3210', N'father', NULL, 0, NULL)
GO
INSERT [AT2].[tblEmployees] ([EmployeeID], [FirstName], [LastName], [DesignationID], [DepartmentID], [Mobile], [WorkEmail], [PersonalEmail], [UserID], [Password], [IsAdmin], [IsActive], [ActivatedDate], [Order], [BiometricID], [MapleID], [DOB], [DOJ], [Gender], [MaritalStatus], [DOA], [BloodGroup], [EmergencyContactPerson], [EmergencyContactNumber], [EmergencyContactRelation], [IsBilling], [IsProfileUpdated], [SlackId]) VALUES (100, N'tgefrusfhi', N'tgefrusfhi', 17, 1011, N'7822293874', NULL, N'gdjhg@gmail.com', N'tgefrusfhi', N'23D42F5F3F66498B2C8FF4C20B8C5AC826E47146', 0, 0, CAST(N'1900-01-01 00:00:00.000' AS DateTime), 38, N'sample4656654654', NULL, CAST(N'1900-01-01' AS Date), CAST(N'1900-01-01' AS Date), 1, 0, CAST(N'1900-01-01' AS Date), N'-1', NULL, NULL, NULL, NULL, 0, NULL)
GO
INSERT [AT2].[tblEmployees] ([EmployeeID], [FirstName], [LastName], [DesignationID], [DepartmentID], [Mobile], [WorkEmail], [PersonalEmail], [UserID], [Password], [IsAdmin], [IsActive], [ActivatedDate], [Order], [BiometricID], [MapleID], [DOB], [DOJ], [Gender], [MaritalStatus], [DOA], [BloodGroup], [EmergencyContactPerson], [EmergencyContactNumber], [EmergencyContactRelation], [IsBilling], [IsProfileUpdated], [SlackId]) VALUES (101, N'geetha', N'geetha', 17, 1003, N'7879333232', N'gdjhg@gmail.com', N'geetha@gmail.com', N'geetha', N'23D42F5F3F66498B2C8FF4C20B8C5AC826E47146', 0, 0, CAST(N'1900-01-01 00:00:00.000' AS DateTime), 38, NULL, N'undefined', CAST(N'1989-03-15' AS Date), CAST(N'1900-01-01' AS Date), 1, 0, CAST(N'1900-01-01' AS Date), N'B+', N'test', N'8247570164', N'dfsrf', NULL, 0, NULL)
GO
INSERT [AT2].[tblEmployees] ([EmployeeID], [FirstName], [LastName], [DesignationID], [DepartmentID], [Mobile], [WorkEmail], [PersonalEmail], [UserID], [Password], [IsAdmin], [IsActive], [ActivatedDate], [Order], [BiometricID], [MapleID], [DOB], [DOJ], [Gender], [MaritalStatus], [DOA], [BloodGroup], [EmergencyContactPerson], [EmergencyContactNumber], [EmergencyContactRelation], [IsBilling], [IsProfileUpdated], [SlackId]) VALUES (102, N'yhyd', N'yhyd', 1012, 1020, N'9898873863', NULL, N'sample@gmail.com', N'yhyd', N'23D42F5F3F66498B2C8FF4C20B8C5AC826E47146', 0, 0, CAST(N'1900-01-01 00:00:00.000' AS DateTime), 38, NULL, NULL, CAST(N'1900-01-01' AS Date), CAST(N'1900-01-01' AS Date), 1, 0, CAST(N'1900-01-01' AS Date), N'-1', NULL, NULL, NULL, NULL, 0, NULL)
GO
INSERT [AT2].[tblEmployees] ([EmployeeID], [FirstName], [LastName], [DesignationID], [DepartmentID], [Mobile], [WorkEmail], [PersonalEmail], [UserID], [Password], [IsAdmin], [IsActive], [ActivatedDate], [Order], [BiometricID], [MapleID], [DOB], [DOJ], [Gender], [MaritalStatus], [DOA], [BloodGroup], [EmergencyContactPerson], [EmergencyContactNumber], [EmergencyContactRelation], [IsBilling], [IsProfileUpdated], [SlackId]) VALUES (103, N'    chaitanya', N'sai', 1017, 1006, N'9090909090', N'gopikrishna.s@maple-software.com', N'dffdg@gmail.com', N'chaitanya', N'23D42F5F3F66498B2C8FF4C20B8C5AC826E47146', 0, 0, CAST(N'1900-01-01 00:00:00.000' AS DateTime), 38, NULL, N'234r4', CAST(N'1995-02-26' AS Date), CAST(N'1900-01-01' AS Date), 1, 0, CAST(N'1900-01-01' AS Date), N'A+', N'test', N'9566234170', N'test', NULL, 1, NULL)
GO
INSERT [AT2].[tblEmployees] ([EmployeeID], [FirstName], [LastName], [DesignationID], [DepartmentID], [Mobile], [WorkEmail], [PersonalEmail], [UserID], [Password], [IsAdmin], [IsActive], [ActivatedDate], [Order], [BiometricID], [MapleID], [DOB], [DOJ], [Gender], [MaritalStatus], [DOA], [BloodGroup], [EmergencyContactPerson], [EmergencyContactNumber], [EmergencyContactRelation], [IsBilling], [IsProfileUpdated], [SlackId]) VALUES (104, N'kumar', N'kumar', 1012, 1011, N'7879983224', N'kumar@gmail.com', N'kumar@gmail.com', N'kumar', N'23D42F5F3F66498B2C8FF4C20B8C5AC826E47146', 0, 0, CAST(N'1900-01-01 00:00:00.000' AS DateTime), 38, NULL, N'35345346', CAST(N'1990-03-01' AS Date), CAST(N'1900-01-01' AS Date), 1, 1, CAST(N'2009-01-05' AS Date), N'B+', N'test', N'9998784521', N'test', NULL, 1, NULL)
GO
INSERT [AT2].[tblEmployees] ([EmployeeID], [FirstName], [LastName], [DesignationID], [DepartmentID], [Mobile], [WorkEmail], [PersonalEmail], [UserID], [Password], [IsAdmin], [IsActive], [ActivatedDate], [Order], [BiometricID], [MapleID], [DOB], [DOJ], [Gender], [MaritalStatus], [DOA], [BloodGroup], [EmergencyContactPerson], [EmergencyContactNumber], [EmergencyContactRelation], [IsBilling], [IsProfileUpdated], [SlackId]) VALUES (105, N'Anandh', N'S', 1023, 3, N'2163545649', N'janaki.maple@gmail.com', N'janaki.d1996@gmail.com', N'Anandh', N'23D42F5F3F66498B2C8FF4C20B8C5AC826E47146', 0, 0, CAST(N'1900-01-01 00:00:00.000' AS DateTime), 38, N'878486546545', N'454', CAST(N'2010-02-02' AS Date), CAST(N'2019-01-01' AS Date), 1, 0, CAST(N'1900-01-01' AS Date), N'B+', N'N T Rama rao', N'8885209020', N'father', NULL, 1, NULL)
GO
INSERT [AT2].[tblEmployees] ([EmployeeID], [FirstName], [LastName], [DesignationID], [DepartmentID], [Mobile], [WorkEmail], [PersonalEmail], [UserID], [Password], [IsAdmin], [IsActive], [ActivatedDate], [Order], [BiometricID], [MapleID], [DOB], [DOJ], [Gender], [MaritalStatus], [DOA], [BloodGroup], [EmergencyContactPerson], [EmergencyContactNumber], [EmergencyContactRelation], [IsBilling], [IsProfileUpdated], [SlackId]) VALUES (106, N'priyanka', N'Srinivasula', 1011, 2, N'9868569856', N'priya@gmail.com', N'priya@gmail.com', N'priyanka', N'23D42F5F3F66498B2C8FF4C20B8C5AC826E47146', 0, 0, CAST(N'1900-01-01 00:00:00.000' AS DateTime), 38, N'65896589', N'8569856', CAST(N'1990-03-01' AS Date), CAST(N'2018-03-01' AS Date), 1, 0, CAST(N'1900-01-01' AS Date), N'B+', N'trty', N'9090101213', N'vffv', NULL, 1, NULL)
GO
INSERT [AT2].[tblEmployees] ([EmployeeID], [FirstName], [LastName], [DesignationID], [DepartmentID], [Mobile], [WorkEmail], [PersonalEmail], [UserID], [Password], [IsAdmin], [IsActive], [ActivatedDate], [Order], [BiometricID], [MapleID], [DOB], [DOJ], [Gender], [MaritalStatus], [DOA], [BloodGroup], [EmergencyContactPerson], [EmergencyContactNumber], [EmergencyContactRelation], [IsBilling], [IsProfileUpdated], [SlackId]) VALUES (107, N'swara', N'swara', 17, 2, N'9765845122', N'swara@gmail.com', N'swara@gmail.com', N'swara', N'23D42F5F3F66498B2C8FF4C20B8C5AC826E47146', 0, 0, CAST(N'1900-01-01 00:00:00.000' AS DateTime), 38, N'8989', N'2323', CAST(N'1990-03-01' AS Date), CAST(N'2011-02-08' AS Date), 1, 0, CAST(N'1900-01-01' AS Date), N'B+', N'tfgy', N'9566234170', N'aaaa', NULL, 1, NULL)
GO
INSERT [AT2].[tblEmployees] ([EmployeeID], [FirstName], [LastName], [DesignationID], [DepartmentID], [Mobile], [WorkEmail], [PersonalEmail], [UserID], [Password], [IsAdmin], [IsActive], [ActivatedDate], [Order], [BiometricID], [MapleID], [DOB], [DOJ], [Gender], [MaritalStatus], [DOA], [BloodGroup], [EmergencyContactPerson], [EmergencyContactNumber], [EmergencyContactRelation], [IsBilling], [IsProfileUpdated], [SlackId]) VALUES (108, N'ytyt', N'ytyt', 17, 2, N'7987965323', NULL, N'gdjhg@gmail.com', N'ytyt', N'23D42F5F3F66498B2C8FF4C20B8C5AC826E47146', 0, 0, CAST(N'1900-01-01 00:00:00.000' AS DateTime), 38, NULL, N'etyuyh2', CAST(N'1900-01-01' AS Date), CAST(N'1900-01-01' AS Date), 1, 0, CAST(N'1900-01-01' AS Date), N'-1', NULL, NULL, NULL, NULL, 1, NULL)
GO
INSERT [AT2].[tblEmployees] ([EmployeeID], [FirstName], [LastName], [DesignationID], [DepartmentID], [Mobile], [WorkEmail], [PersonalEmail], [UserID], [Password], [IsAdmin], [IsActive], [ActivatedDate], [Order], [BiometricID], [MapleID], [DOB], [DOJ], [Gender], [MaritalStatus], [DOA], [BloodGroup], [EmergencyContactPerson], [EmergencyContactNumber], [EmergencyContactRelation], [IsBilling], [IsProfileUpdated], [SlackId]) VALUES (109, N'alekhya', N'alekhya', 1011, 1003, N'7879898778', N'alekhya@gmail.com', N'alekhya@gmail.com', N'alekhya', N'23D42F5F3F66498B2C8FF4C20B8C5AC826E47146', 0, 0, CAST(N'1900-01-01 00:00:00.000' AS DateTime), 38, N'35644545', N'7787889989', CAST(N'1980-02-15' AS Date), CAST(N'1984-01-31' AS Date), 1, 1, CAST(N'2009-01-05' AS Date), N'A-', N'alekhya', N'8786367898', N'alekhya', NULL, 1, NULL)
GO
INSERT [AT2].[tblEmployees] ([EmployeeID], [FirstName], [LastName], [DesignationID], [DepartmentID], [Mobile], [WorkEmail], [PersonalEmail], [UserID], [Password], [IsAdmin], [IsActive], [ActivatedDate], [Order], [BiometricID], [MapleID], [DOB], [DOJ], [Gender], [MaritalStatus], [DOA], [BloodGroup], [EmergencyContactPerson], [EmergencyContactNumber], [EmergencyContactRelation], [IsBilling], [IsProfileUpdated], [SlackId]) VALUES (110, N'Shalini', N'Shalini', 5, 3, N'9898989889', N'shalini.maple@gmail.com', N'Shalini@gmail.com', N'Shalini', N'23D42F5F3F66498B2C8FF4C20B8C5AC826E47146', 0, 0, CAST(N'1900-01-01 00:00:00.000' AS DateTime), 38, NULL, NULL, CAST(N'1995-03-01' AS Date), CAST(N'1900-01-01' AS Date), 2, 0, CAST(N'1900-01-01' AS Date), N'A+', N'4455887744', N'4411772255', N'mother', NULL, 1, NULL)
GO
INSERT [AT2].[tblEmployees] ([EmployeeID], [FirstName], [LastName], [DesignationID], [DepartmentID], [Mobile], [WorkEmail], [PersonalEmail], [UserID], [Password], [IsAdmin], [IsActive], [ActivatedDate], [Order], [BiometricID], [MapleID], [DOB], [DOJ], [Gender], [MaritalStatus], [DOA], [BloodGroup], [EmergencyContactPerson], [EmergencyContactNumber], [EmergencyContactRelation], [IsBilling], [IsProfileUpdated], [SlackId]) VALUES (112, N'dfgdgdg', N'xfgdgdg', 5, 1011, N'9876543210', NULL, N'janaki.d1996@gmail.com', N'shilpa', N'23D42F5F3F66498B2C8FF4C20B8C5AC826E47146', 0, 0, CAST(N'1900-01-01 00:00:00.000' AS DateTime), 38, NULL, N'1234568', CAST(N'1900-01-01' AS Date), CAST(N'1900-01-01' AS Date), 1, 0, CAST(N'1900-01-01' AS Date), N'-1', NULL, NULL, NULL, NULL, 0, NULL)
GO
INSERT [AT2].[tblEmployees] ([EmployeeID], [FirstName], [LastName], [DesignationID], [DepartmentID], [Mobile], [WorkEmail], [PersonalEmail], [UserID], [Password], [IsAdmin], [IsActive], [ActivatedDate], [Order], [BiometricID], [MapleID], [DOB], [DOJ], [Gender], [MaritalStatus], [DOA], [BloodGroup], [EmergencyContactPerson], [EmergencyContactNumber], [EmergencyContactRelation], [IsBilling], [IsProfileUpdated], [SlackId]) VALUES (113, N'bindu', N'bindu', 1012, 2, N'9999999999', NULL, N'bindu@gmail.com', N'bindu', N'23D42F5F3F66498B2C8FF4C20B8C5AC826E47146', 0, 0, CAST(N'1900-01-01 00:00:00.000' AS DateTime), 38, N'98521', N'85685', CAST(N'1900-01-01' AS Date), CAST(N'1900-01-01' AS Date), 1, 0, CAST(N'1900-01-01' AS Date), N'-1', NULL, NULL, NULL, NULL, 1, NULL)
GO
INSERT [AT2].[tblEmployees] ([EmployeeID], [FirstName], [LastName], [DesignationID], [DepartmentID], [Mobile], [WorkEmail], [PersonalEmail], [UserID], [Password], [IsAdmin], [IsActive], [ActivatedDate], [Order], [BiometricID], [MapleID], [DOB], [DOJ], [Gender], [MaritalStatus], [DOA], [BloodGroup], [EmergencyContactPerson], [EmergencyContactNumber], [EmergencyContactRelation], [IsBilling], [IsProfileUpdated], [SlackId]) VALUES (114, N'soumya', N'soumya', 6, 1003, N'8858585858', N'soumya@gmail.com', N'soumya@gmail.com', N'soumya', N'23D42F5F3F66498B2C8FF4C20B8C5AC826E47146', 0, 0, CAST(N'1900-01-01 00:00:00.000' AS DateTime), 38, NULL, N'7854658', CAST(N'1990-03-01' AS Date), CAST(N'1900-01-01' AS Date), 1, 0, CAST(N'1900-01-01' AS Date), N'B+', N'madhu', N'9566234170', N'vffv', NULL, 1, NULL)
GO
INSERT [AT2].[tblEmployees] ([EmployeeID], [FirstName], [LastName], [DesignationID], [DepartmentID], [Mobile], [WorkEmail], [PersonalEmail], [UserID], [Password], [IsAdmin], [IsActive], [ActivatedDate], [Order], [BiometricID], [MapleID], [DOB], [DOJ], [Gender], [MaritalStatus], [DOA], [BloodGroup], [EmergencyContactPerson], [EmergencyContactNumber], [EmergencyContactRelation], [IsBilling], [IsProfileUpdated], [SlackId]) VALUES (115, N'karthik', N'karthik', 3, 3, N'5569898989', NULL, N'gdjhg@gmail.com', N'karthik', N'23D42F5F3F66498B2C8FF4C20B8C5AC826E47146', 0, 0, CAST(N'1900-01-01 00:00:00.000' AS DateTime), 38, NULL, NULL, CAST(N'1900-01-01' AS Date), CAST(N'1900-01-01' AS Date), 1, 0, CAST(N'1900-01-01' AS Date), N'-1', NULL, NULL, NULL, NULL, 0, NULL)
GO
INSERT [AT2].[tblEmployees] ([EmployeeID], [FirstName], [LastName], [DesignationID], [DepartmentID], [Mobile], [WorkEmail], [PersonalEmail], [UserID], [Password], [IsAdmin], [IsActive], [ActivatedDate], [Order], [BiometricID], [MapleID], [DOB], [DOJ], [Gender], [MaritalStatus], [DOA], [BloodGroup], [EmergencyContactPerson], [EmergencyContactNumber], [EmergencyContactRelation], [IsBilling], [IsProfileUpdated], [SlackId]) VALUES (116, N'ravi', N'ravi', 5, 3, N'9898989797', N'ravi.maple@gmail.com', N'test@gmail.com', N'ravi', N'23D42F5F3F66498B2C8FF4C20B8C5AC826E47146', 0, 0, CAST(N'1900-01-01 00:00:00.000' AS DateTime), 38, NULL, NULL, CAST(N'1995-12-02' AS Date), CAST(N'1900-01-01' AS Date), 1, 0, CAST(N'1900-01-01' AS Date), N'A+', N'9955887744', N'9911772255', N'mother', NULL, 1, NULL)
GO
INSERT [AT2].[tblEmployees] ([EmployeeID], [FirstName], [LastName], [DesignationID], [DepartmentID], [Mobile], [WorkEmail], [PersonalEmail], [UserID], [Password], [IsAdmin], [IsActive], [ActivatedDate], [Order], [BiometricID], [MapleID], [DOB], [DOJ], [Gender], [MaritalStatus], [DOA], [BloodGroup], [EmergencyContactPerson], [EmergencyContactNumber], [EmergencyContactRelation], [IsBilling], [IsProfileUpdated], [SlackId]) VALUES (117, N'sowjanya', N'rani', 5, 2, N'9898989898', N'sowjanya@gmail.com', N'sowjanya@gmail.com', N'sowjanya', N'23D42F5F3F66498B2C8FF4C20B8C5AC826E47146', 0, 0, CAST(N'1900-01-01 00:00:00.000' AS DateTime), 38, NULL, NULL, CAST(N'1990-02-27' AS Date), CAST(N'1900-01-01' AS Date), 1, 0, CAST(N'1900-01-01' AS Date), N'A+', N'Sandhya', N'9566234178', N'friend', NULL, 1, NULL)
GO
INSERT [AT2].[tblEmployees] ([EmployeeID], [FirstName], [LastName], [DesignationID], [DepartmentID], [Mobile], [WorkEmail], [PersonalEmail], [UserID], [Password], [IsAdmin], [IsActive], [ActivatedDate], [Order], [BiometricID], [MapleID], [DOB], [DOJ], [Gender], [MaritalStatus], [DOA], [BloodGroup], [EmergencyContactPerson], [EmergencyContactNumber], [EmergencyContactRelation], [IsBilling], [IsProfileUpdated], [SlackId]) VALUES (118, N'Sailaja', N'Sailaja', 5, 2, N'9656565656', N'Sailaja@maple-software.com', N'Sailaja@gmail.com', N'Sailaja', N'23D42F5F3F66498B2C8FF4C20B8C5AC826E47146', 0, 0, CAST(N'1900-01-01 00:00:00.000' AS DateTime), 38, N'898989', N'652356', CAST(N'1989-01-31' AS Date), CAST(N'1900-01-01' AS Date), 2, 0, CAST(N'1900-01-01' AS Date), N'A+', N'rani', N'9898974545', N'sister', NULL, 1, NULL)
GO
INSERT [AT2].[tblEmployees] ([EmployeeID], [FirstName], [LastName], [DesignationID], [DepartmentID], [Mobile], [WorkEmail], [PersonalEmail], [UserID], [Password], [IsAdmin], [IsActive], [ActivatedDate], [Order], [BiometricID], [MapleID], [DOB], [DOJ], [Gender], [MaritalStatus], [DOA], [BloodGroup], [EmergencyContactPerson], [EmergencyContactNumber], [EmergencyContactRelation], [IsBilling], [IsProfileUpdated], [SlackId]) VALUES (119, N'abcdef', N'abcdef', 2, 3, N'9568234175', N'abcdef@gmail.com', N'abcd@gmail.com', N'abcdef', N'23D42F5F3F66498B2C8FF4C20B8C5AC826E47146', 0, 0, CAST(N'1900-01-01 00:00:00.000' AS DateTime), 38, N'98564721', N'74235152', CAST(N'1990-01-30' AS Date), CAST(N'1900-01-01' AS Date), 1, 0, CAST(N'1900-01-01' AS Date), N'A+', N'rajutest', N'9566234784', N'father', NULL, 1, NULL)
GO
INSERT [AT2].[tblEmployees] ([EmployeeID], [FirstName], [LastName], [DesignationID], [DepartmentID], [Mobile], [WorkEmail], [PersonalEmail], [UserID], [Password], [IsAdmin], [IsActive], [ActivatedDate], [Order], [BiometricID], [MapleID], [DOB], [DOJ], [Gender], [MaritalStatus], [DOA], [BloodGroup], [EmergencyContactPerson], [EmergencyContactNumber], [EmergencyContactRelation], [IsBilling], [IsProfileUpdated], [SlackId]) VALUES (120, N'Arya', N'Arya', 3, 1017, N'9654123566', N'Arya@gmail.com', N'Arya@gmail.com', N'Arya', N'23D42F5F3F66498B2C8FF4C20B8C5AC826E47146', 0, 0, CAST(N'1900-01-01 00:00:00.000' AS DateTime), 38, NULL, N'78977787', CAST(N'1995-03-05' AS Date), CAST(N'2018-03-01' AS Date), 1, 0, CAST(N'1900-01-01' AS Date), N'A+', N'test', N'9998784521', N'test', NULL, 1, NULL)
GO
INSERT [AT2].[tblEmployees] ([EmployeeID], [FirstName], [LastName], [DesignationID], [DepartmentID], [Mobile], [WorkEmail], [PersonalEmail], [UserID], [Password], [IsAdmin], [IsActive], [ActivatedDate], [Order], [BiometricID], [MapleID], [DOB], [DOJ], [Gender], [MaritalStatus], [DOA], [BloodGroup], [EmergencyContactPerson], [EmergencyContactNumber], [EmergencyContactRelation], [IsBilling], [IsProfileUpdated], [SlackId]) VALUES (121, N'ramya', N'ramya', 2, 3, N'9989899889', N'ramya@gmail.com', N'ramya@gmail.com', N'ramya', N'23D42F5F3F66498B2C8FF4C20B8C5AC826E47146', 0, 0, CAST(N'1900-01-01 00:00:00.000' AS DateTime), 38, N'0132378', N'252424', CAST(N'1900-02-28' AS Date), CAST(N'1900-01-01' AS Date), 1, 0, CAST(N'1900-01-01' AS Date), N'o+', N'test', N'9566234170', N'test', NULL, 1, NULL)
GO
INSERT [AT2].[tblEmployees] ([EmployeeID], [FirstName], [LastName], [DesignationID], [DepartmentID], [Mobile], [WorkEmail], [PersonalEmail], [UserID], [Password], [IsAdmin], [IsActive], [ActivatedDate], [Order], [BiometricID], [MapleID], [DOB], [DOJ], [Gender], [MaritalStatus], [DOA], [BloodGroup], [EmergencyContactPerson], [EmergencyContactNumber], [EmergencyContactRelation], [IsBilling], [IsProfileUpdated], [SlackId]) VALUES (122, N'varun', N'varun', 5, 3, N'9898984545', NULL, N'varun@gmail.com', N'varun', N'23D42F5F3F66498B2C8FF4C20B8C5AC826E47146', 0, 0, CAST(N'1900-01-01 00:00:00.000' AS DateTime), 38, NULL, NULL, CAST(N'1900-01-01' AS Date), CAST(N'1900-01-01' AS Date), 1, 0, CAST(N'1900-01-01' AS Date), N'-1', NULL, NULL, NULL, NULL, 0, NULL)
GO
INSERT [AT2].[tblEmployees] ([EmployeeID], [FirstName], [LastName], [DesignationID], [DepartmentID], [Mobile], [WorkEmail], [PersonalEmail], [UserID], [Password], [IsAdmin], [IsActive], [ActivatedDate], [Order], [BiometricID], [MapleID], [DOB], [DOJ], [Gender], [MaritalStatus], [DOA], [BloodGroup], [EmergencyContactPerson], [EmergencyContactNumber], [EmergencyContactRelation], [IsBilling], [IsProfileUpdated], [SlackId]) VALUES (123, N'dddf', N'fsdfff', 3, 2, N'9999999999', NULL, N'gdjhg@gmail.com', N'dddf', N'23D42F5F3F66498B2C8FF4C20B8C5AC826E47146', 0, 0, CAST(N'1900-01-01 00:00:00.000' AS DateTime), 38, NULL, NULL, CAST(N'1900-01-01' AS Date), CAST(N'1900-01-01' AS Date), 1, 0, CAST(N'1900-01-01' AS Date), N'-1', NULL, NULL, NULL, NULL, 0, NULL)
GO
INSERT [AT2].[tblEmployees] ([EmployeeID], [FirstName], [LastName], [DesignationID], [DepartmentID], [Mobile], [WorkEmail], [PersonalEmail], [UserID], [Password], [IsAdmin], [IsActive], [ActivatedDate], [Order], [BiometricID], [MapleID], [DOB], [DOJ], [Gender], [MaritalStatus], [DOA], [BloodGroup], [EmergencyContactPerson], [EmergencyContactNumber], [EmergencyContactRelation], [IsBilling], [IsProfileUpdated], [SlackId]) VALUES (124, N'dharma', N'k', 2, 1031, N'6665555555', NULL, N'dharmaK@gmail.com', N'dharma', N'23D42F5F3F66498B2C8FF4C20B8C5AC826E47146', 0, 0, CAST(N'1900-01-01 00:00:00.000' AS DateTime), 38, NULL, NULL, CAST(N'1900-01-01' AS Date), CAST(N'1900-01-01' AS Date), 1, 0, CAST(N'1900-01-01' AS Date), N'A+', NULL, NULL, NULL, NULL, 0, NULL)
GO
INSERT [AT2].[tblEmployees] ([EmployeeID], [FirstName], [LastName], [DesignationID], [DepartmentID], [Mobile], [WorkEmail], [PersonalEmail], [UserID], [Password], [IsAdmin], [IsActive], [ActivatedDate], [Order], [BiometricID], [MapleID], [DOB], [DOJ], [Gender], [MaritalStatus], [DOA], [BloodGroup], [EmergencyContactPerson], [EmergencyContactNumber], [EmergencyContactRelation], [IsBilling], [IsProfileUpdated], [SlackId]) VALUES (125, N'madhu', N'g', 17, 1031, N'5566998822', NULL, N'Madhug@gmail.com', N'madhu', N'23D42F5F3F66498B2C8FF4C20B8C5AC826E47146', 0, 0, CAST(N'1900-01-01 00:00:00.000' AS DateTime), 38, NULL, NULL, CAST(N'1900-01-01' AS Date), CAST(N'1900-01-01' AS Date), 1, 0, CAST(N'1900-01-01' AS Date), N'A+', NULL, NULL, NULL, NULL, 0, NULL)
GO
INSERT [AT2].[tblEmployees] ([EmployeeID], [FirstName], [LastName], [DesignationID], [DepartmentID], [Mobile], [WorkEmail], [PersonalEmail], [UserID], [Password], [IsAdmin], [IsActive], [ActivatedDate], [Order], [BiometricID], [MapleID], [DOB], [DOJ], [Gender], [MaritalStatus], [DOA], [BloodGroup], [EmergencyContactPerson], [EmergencyContactNumber], [EmergencyContactRelation], [IsBilling], [IsProfileUpdated], [SlackId]) VALUES (126, N'krish', N'k', 2, 3, N'9876543210', N'test.maple@gmail.com', N'test@gmail.com', N'krish', N'23D42F5F3F66498B2C8FF4C20B8C5AC826E47146', 0, 0, CAST(N'1900-01-01 00:00:00.000' AS DateTime), 38, N'01229238', N'456', CAST(N'1999-02-02' AS Date), CAST(N'2018-03-21' AS Date), 1, 0, CAST(N'1999-03-20' AS Date), N'A+', N'test', N'9876543210', N'test', NULL, 1, NULL)
GO
INSERT [AT2].[tblEmployees] ([EmployeeID], [FirstName], [LastName], [DesignationID], [DepartmentID], [Mobile], [WorkEmail], [PersonalEmail], [UserID], [Password], [IsAdmin], [IsActive], [ActivatedDate], [Order], [BiometricID], [MapleID], [DOB], [DOJ], [Gender], [MaritalStatus], [DOA], [BloodGroup], [EmergencyContactPerson], [EmergencyContactNumber], [EmergencyContactRelation], [IsBilling], [IsProfileUpdated], [SlackId]) VALUES (127, N'shanthi', N'h', 1023, 1018, N'9876543210', N'test.maple@gmail.com', N'test@gmail.com', N'shanthi', N'23D42F5F3F66498B2C8FF4C20B8C5AC826E47146', 0, 0, CAST(N'1900-01-01 00:00:00.000' AS DateTime), 38, NULL, N'58962`', CAST(N'1996-07-07' AS Date), CAST(N'2019-03-21' AS Date), 1, 0, CAST(N'1900-01-01' AS Date), N'A+', N'test', N'9876543210', N'TEST', NULL, 1, NULL)
GO
INSERT [AT2].[tblEmployees] ([EmployeeID], [FirstName], [LastName], [DesignationID], [DepartmentID], [Mobile], [WorkEmail], [PersonalEmail], [UserID], [Password], [IsAdmin], [IsActive], [ActivatedDate], [Order], [BiometricID], [MapleID], [DOB], [DOJ], [Gender], [MaritalStatus], [DOA], [BloodGroup], [EmergencyContactPerson], [EmergencyContactNumber], [EmergencyContactRelation], [IsBilling], [IsProfileUpdated], [SlackId]) VALUES (128, N'Navya', N'sri', 5, 3, N'9887578465', NULL, N'Navya@gmail.com', N'Navya', N'23D42F5F3F66498B2C8FF4C20B8C5AC826E47146', 0, 0, CAST(N'1900-01-01 00:00:00.000' AS DateTime), 38, N'0003', N'985741201', CAST(N'1900-01-01' AS Date), CAST(N'1900-01-01' AS Date), 1, 1, CAST(N'2009-01-05' AS Date), N'-1', NULL, NULL, NULL, NULL, 1, NULL)
GO
INSERT [AT2].[tblEmployees] ([EmployeeID], [FirstName], [LastName], [DesignationID], [DepartmentID], [Mobile], [WorkEmail], [PersonalEmail], [UserID], [Password], [IsAdmin], [IsActive], [ActivatedDate], [Order], [BiometricID], [MapleID], [DOB], [DOJ], [Gender], [MaritalStatus], [DOA], [BloodGroup], [EmergencyContactPerson], [EmergencyContactNumber], [EmergencyContactRelation], [IsBilling], [IsProfileUpdated], [SlackId]) VALUES (129, N'eg', N'eg', 2, 2, N'5565879999', N'eg@gmail.com', N'eg@gmail.com', N'eg', N'23D42F5F3F66498B2C8FF4C20B8C5AC826E47146', 0, 0, CAST(N'1900-01-01 00:00:00.000' AS DateTime), 38, N'321', N'2123', CAST(N'1989-01-14' AS Date), CAST(N'1900-01-01' AS Date), 1, 0, CAST(N'1900-01-01' AS Date), N'A+', N'tfgy', N'8766234170', N'aaaa', NULL, 1, NULL)
GO
INSERT [AT2].[tblEmployees] ([EmployeeID], [FirstName], [LastName], [DesignationID], [DepartmentID], [Mobile], [WorkEmail], [PersonalEmail], [UserID], [Password], [IsAdmin], [IsActive], [ActivatedDate], [Order], [BiometricID], [MapleID], [DOB], [DOJ], [Gender], [MaritalStatus], [DOA], [BloodGroup], [EmergencyContactPerson], [EmergencyContactNumber], [EmergencyContactRelation], [IsBilling], [IsProfileUpdated], [SlackId]) VALUES (130, N'ff', N'ff', 2, 2, N'9999999999', NULL, N'ff@gmail.com', N'ff', N'23D42F5F3F66498B2C8FF4C20B8C5AC826E47146', 0, 0, CAST(N'1900-01-01 00:00:00.000' AS DateTime), 38, NULL, N'222222222', CAST(N'1900-01-01' AS Date), CAST(N'1900-01-01' AS Date), 1, 0, CAST(N'1900-01-01' AS Date), N'-1', NULL, NULL, NULL, NULL, 1, NULL)
GO
INSERT [AT2].[tblEmployees] ([EmployeeID], [FirstName], [LastName], [DesignationID], [DepartmentID], [Mobile], [WorkEmail], [PersonalEmail], [UserID], [Password], [IsAdmin], [IsActive], [ActivatedDate], [Order], [BiometricID], [MapleID], [DOB], [DOJ], [Gender], [MaritalStatus], [DOA], [BloodGroup], [EmergencyContactPerson], [EmergencyContactNumber], [EmergencyContactRelation], [IsBilling], [IsProfileUpdated], [SlackId]) VALUES (131, N'subhash', N's', 3, 1031, N'9988998888', N'subhash.maple@gmail.com', N'karthik@gmail.com', N'subhash', N'23D42F5F3F66498B2C8FF4C20B8C5AC826E47146', 0, 0, CAST(N'1900-01-01 00:00:00.000' AS DateTime), 38, NULL, NULL, CAST(N'1991-07-21' AS Date), CAST(N'1900-01-01' AS Date), 1, 1, CAST(N'2019-03-21' AS Date), N'o+', N'mouni', N'9966996633', N'wife', NULL, 1, NULL)
GO
INSERT [AT2].[tblEmployees] ([EmployeeID], [FirstName], [LastName], [DesignationID], [DepartmentID], [Mobile], [WorkEmail], [PersonalEmail], [UserID], [Password], [IsAdmin], [IsActive], [ActivatedDate], [Order], [BiometricID], [MapleID], [DOB], [DOJ], [Gender], [MaritalStatus], [DOA], [BloodGroup], [EmergencyContactPerson], [EmergencyContactNumber], [EmergencyContactRelation], [IsBilling], [IsProfileUpdated], [SlackId]) VALUES (132, N'satish', N'k', 1043, 1071, N'7788552266', N'satish.maple@gmail.com', N'satish@gmail.com', N'satish', N'23D42F5F3F66498B2C8FF4C20B8C5AC826E47146', 0, 0, CAST(N'1900-01-01 00:00:00.000' AS DateTime), 38, NULL, N'3453645657', CAST(N'2018-01-31' AS Date), CAST(N'2019-01-29' AS Date), 1, 0, CAST(N'1900-01-01' AS Date), N'A-', N'manisha', N'9911772255', N'mother', NULL, 1, NULL)
GO
INSERT [AT2].[tblEmployees] ([EmployeeID], [FirstName], [LastName], [DesignationID], [DepartmentID], [Mobile], [WorkEmail], [PersonalEmail], [UserID], [Password], [IsAdmin], [IsActive], [ActivatedDate], [Order], [BiometricID], [MapleID], [DOB], [DOJ], [Gender], [MaritalStatus], [DOA], [BloodGroup], [EmergencyContactPerson], [EmergencyContactNumber], [EmergencyContactRelation], [IsBilling], [IsProfileUpdated], [SlackId]) VALUES (133, N'Rakesh', N'v', 1047, 1068, N'9876543210', N'test.maple@gmail.com', N'test@gmail.com', N'Rakesh', N'23D42F5F3F66498B2C8FF4C20B8C5AC826E47146', 0, 0, CAST(N'1900-01-01 00:00:00.000' AS DateTime), 38, N'01229239456', N'7895', CAST(N'1990-07-07' AS Date), CAST(N'2018-03-29' AS Date), 1, 1, CAST(N'2018-03-29' AS Date), N'A+', N'test', N'9876543210', N'testjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjj', NULL, 1, NULL)
GO
INSERT [AT2].[tblEmployees] ([EmployeeID], [FirstName], [LastName], [DesignationID], [DepartmentID], [Mobile], [WorkEmail], [PersonalEmail], [UserID], [Password], [IsAdmin], [IsActive], [ActivatedDate], [Order], [BiometricID], [MapleID], [DOB], [DOJ], [Gender], [MaritalStatus], [DOA], [BloodGroup], [EmergencyContactPerson], [EmergencyContactNumber], [EmergencyContactRelation], [IsBilling], [IsProfileUpdated], [SlackId]) VALUES (134, N'Ishan', N'sharma', 5, 1006, N'9565412378', N'Ishan@gmail.com', N'Ishan@gmail.com', N'Ishan', N'23D42F5F3F66498B2C8FF4C20B8C5AC826E47146', 0, 0, CAST(N'1900-01-01 00:00:00.000' AS DateTime), 38, N'010101', N'54210', CAST(N'1990-02-01' AS Date), CAST(N'1900-01-01' AS Date), 1, 0, CAST(N'1900-01-01' AS Date), N'o-', N'test', N'8541236987', N'test', NULL, 1, NULL)
GO
INSERT [AT2].[tblEmployees] ([EmployeeID], [FirstName], [LastName], [DesignationID], [DepartmentID], [Mobile], [WorkEmail], [PersonalEmail], [UserID], [Password], [IsAdmin], [IsActive], [ActivatedDate], [Order], [BiometricID], [MapleID], [DOB], [DOJ], [Gender], [MaritalStatus], [DOA], [BloodGroup], [EmergencyContactPerson], [EmergencyContactNumber], [EmergencyContactRelation], [IsBilling], [IsProfileUpdated], [SlackId]) VALUES (135, N'Ishitha', N'Ishitha', 6, 1003, N'9867412302', N'Ishitha@maple-software.com', N'Ishitha@gmail.com', N'Ishitha', N'23D42F5F3F66498B2C8FF4C20B8C5AC826E47146', 0, 0, CAST(N'1900-01-01 00:00:00.000' AS DateTime), 38, N'10247', N'85124', CAST(N'1988-12-25' AS Date), CAST(N'2019-03-26' AS Date), 1, 0, CAST(N'1900-01-01' AS Date), N'A+', N'rani', N'8766234170', N'mother', NULL, 1, NULL)
GO
INSERT [AT2].[tblEmployees] ([EmployeeID], [FirstName], [LastName], [DesignationID], [DepartmentID], [Mobile], [WorkEmail], [PersonalEmail], [UserID], [Password], [IsAdmin], [IsActive], [ActivatedDate], [Order], [BiometricID], [MapleID], [DOB], [DOJ], [Gender], [MaritalStatus], [DOA], [BloodGroup], [EmergencyContactPerson], [EmergencyContactNumber], [EmergencyContactRelation], [IsBilling], [IsProfileUpdated], [SlackId]) VALUES (136, N'Keerthi', N's', 1011, 2, N'8756324544', N'Keerthi@gmail.com', N'keerthi@gmail.com', N'Keerthi', N'23D42F5F3F66498B2C8FF4C20B8C5AC826E47146', 0, 0, CAST(N'1900-01-01 00:00:00.000' AS DateTime), 38, N'201', N'8562', CAST(N'1985-07-10' AS Date), CAST(N'1900-01-01' AS Date), 1, 0, CAST(N'1900-01-01' AS Date), N'A+', N'test', N'9777777755', N'test', NULL, 1, NULL)
GO
INSERT [AT2].[tblEmployees] ([EmployeeID], [FirstName], [LastName], [DesignationID], [DepartmentID], [Mobile], [WorkEmail], [PersonalEmail], [UserID], [Password], [IsAdmin], [IsActive], [ActivatedDate], [Order], [BiometricID], [MapleID], [DOB], [DOJ], [Gender], [MaritalStatus], [DOA], [BloodGroup], [EmergencyContactPerson], [EmergencyContactNumber], [EmergencyContactRelation], [IsBilling], [IsProfileUpdated], [SlackId]) VALUES (137, N'Roshan', N'v', 1017, 1006, N'9876543210', N'test.maple@gmail.com', N'test@gmail.com', N'Roshan', N'23D42F5F3F66498B2C8FF4C20B8C5AC826E47146', 0, 0, CAST(N'1900-01-01 00:00:00.000' AS DateTime), 38, N'87848654', N'65489', CAST(N'1996-07-07' AS Date), CAST(N'2019-03-26' AS Date), 1, 0, CAST(N'1900-01-01' AS Date), N'B+', N'test', N'9876543210', N'test', NULL, 1, NULL)
GO
INSERT [AT2].[tblEmployees] ([EmployeeID], [FirstName], [LastName], [DesignationID], [DepartmentID], [Mobile], [WorkEmail], [PersonalEmail], [UserID], [Password], [IsAdmin], [IsActive], [ActivatedDate], [Order], [BiometricID], [MapleID], [DOB], [DOJ], [Gender], [MaritalStatus], [DOA], [BloodGroup], [EmergencyContactPerson], [EmergencyContactNumber], [EmergencyContactRelation], [IsBilling], [IsProfileUpdated], [SlackId]) VALUES (138, N'Lakshmi', N'p', 1042, 1067, N'7589999999', N'Lakshmi@gmail.com', N'Lakshmi@gmail.com', N'Lakshmi', N'23D42F5F3F66498B2C8FF4C20B8C5AC826E47146', 0, 0, CAST(N'1900-01-01 00:00:00.000' AS DateTime), 38, N'1041', N'852', CAST(N'1980-03-05' AS Date), CAST(N'2019-03-29' AS Date), 1, 0, CAST(N'1900-01-01' AS Date), N'-1', N'tfgy', N'9898787865', N'test', NULL, 1, NULL)
GO
INSERT [AT2].[tblEmployees] ([EmployeeID], [FirstName], [LastName], [DesignationID], [DepartmentID], [Mobile], [WorkEmail], [PersonalEmail], [UserID], [Password], [IsAdmin], [IsActive], [ActivatedDate], [Order], [BiometricID], [MapleID], [DOB], [DOJ], [Gender], [MaritalStatus], [DOA], [BloodGroup], [EmergencyContactPerson], [EmergencyContactNumber], [EmergencyContactRelation], [IsBilling], [IsProfileUpdated], [SlackId]) VALUES (139, N' Kavya', N'l', 1044, 1068, N'9876543210', N'test.maple@gmail.com', N'test@gmail.com', N'kavya', N'23D42F5F3F66498B2C8FF4C20B8C5AC826E47146', 0, 0, CAST(N'1900-01-01 00:00:00.000' AS DateTime), 38, N'987654', N'5689', CAST(N'1996-07-07' AS Date), CAST(N'2019-01-01' AS Date), 2, 0, CAST(N'1900-01-01' AS Date), N'A+', NULL, NULL, NULL, NULL, 0, NULL)
GO
INSERT [AT2].[tblEmployees] ([EmployeeID], [FirstName], [LastName], [DesignationID], [DepartmentID], [Mobile], [WorkEmail], [PersonalEmail], [UserID], [Password], [IsAdmin], [IsActive], [ActivatedDate], [Order], [BiometricID], [MapleID], [DOB], [DOJ], [Gender], [MaritalStatus], [DOA], [BloodGroup], [EmergencyContactPerson], [EmergencyContactNumber], [EmergencyContactRelation], [IsBilling], [IsProfileUpdated], [SlackId]) VALUES (1130, N'Radhika', N'K', 1045, 1, N'9555555555', N'Radhika@gmail.com', N'Radhika@gmail.com', N'Radhika', N'23D42F5F3F66498B2C8FF4C20B8C5AC826E47146', 0, 0, CAST(N'1900-01-01 00:00:00.000' AS DateTime), 38, NULL, NULL, CAST(N'1990-04-09' AS Date), CAST(N'1900-01-01' AS Date), 1, 0, CAST(N'1900-01-01' AS Date), N'B+', N'Henry', N'7456444569', N'Friend', NULL, 1, NULL)
GO
INSERT [AT2].[tblEmployees] ([EmployeeID], [FirstName], [LastName], [DesignationID], [DepartmentID], [Mobile], [WorkEmail], [PersonalEmail], [UserID], [Password], [IsAdmin], [IsActive], [ActivatedDate], [Order], [BiometricID], [MapleID], [DOB], [DOJ], [Gender], [MaritalStatus], [DOA], [BloodGroup], [EmergencyContactPerson], [EmergencyContactNumber], [EmergencyContactRelation], [IsBilling], [IsProfileUpdated], [SlackId]) VALUES (1131, N'Sonia', N'p', 1043, 1068, N'9999999988', NULL, N'sonia@gmail.com', N'Sonia', N'23D42F5F3F66498B2C8FF4C20B8C5AC826E47146', 0, 0, CAST(N'1900-01-01 00:00:00.000' AS DateTime), 38, NULL, NULL, CAST(N'1900-01-01' AS Date), CAST(N'1900-01-01' AS Date), 1, 0, CAST(N'1900-01-01' AS Date), N'-1', NULL, NULL, NULL, NULL, 0, NULL)
GO
INSERT [AT2].[tblEmployees] ([EmployeeID], [FirstName], [LastName], [DesignationID], [DepartmentID], [Mobile], [WorkEmail], [PersonalEmail], [UserID], [Password], [IsAdmin], [IsActive], [ActivatedDate], [Order], [BiometricID], [MapleID], [DOB], [DOJ], [Gender], [MaritalStatus], [DOA], [BloodGroup], [EmergencyContactPerson], [EmergencyContactNumber], [EmergencyContactRelation], [IsBilling], [IsProfileUpdated], [SlackId]) VALUES (1132, N'rupa', N'sri', 1042, 1068, N'9876543210', N'test.maple@gmail.com', N'test@gmail.com', N'rupa', N'23D42F5F3F66498B2C8FF4C20B8C5AC826E47146', 0, 0, CAST(N'1900-01-01 00:00:00.000' AS DateTime), 38, N'5469', N'3457', CAST(N'1996-07-07' AS Date), CAST(N'2019-01-01' AS Date), 2, 0, CAST(N'1900-01-01' AS Date), N'A+', N'test', N'9876543210', N'TEST', NULL, 1, NULL)
GO
INSERT [AT2].[tblEmployees] ([EmployeeID], [FirstName], [LastName], [DesignationID], [DepartmentID], [Mobile], [WorkEmail], [PersonalEmail], [UserID], [Password], [IsAdmin], [IsActive], [ActivatedDate], [Order], [BiometricID], [MapleID], [DOB], [DOJ], [Gender], [MaritalStatus], [DOA], [BloodGroup], [EmergencyContactPerson], [EmergencyContactNumber], [EmergencyContactRelation], [IsBilling], [IsProfileUpdated], [SlackId]) VALUES (1133, N'Balu', N'LN', 1043, 1068, N'9876543210', N'fdfdsf@gmail.com', N'fdfdsf@gmail.com', N'balu1', N'23D42F5F3F66498B2C8FF4C20B8C5AC826E47146', 0, 0, CAST(N'1900-01-01 00:00:00.000' AS DateTime), 38, NULL, NULL, CAST(N'1980-07-10' AS Date), CAST(N'2019-01-18' AS Date), 1, 0, CAST(N'1900-01-01' AS Date), N'B-', N'test', N'9866879689', N'Friend', NULL, 1, NULL)
GO
INSERT [AT2].[tblEmployees] ([EmployeeID], [FirstName], [LastName], [DesignationID], [DepartmentID], [Mobile], [WorkEmail], [PersonalEmail], [UserID], [Password], [IsAdmin], [IsActive], [ActivatedDate], [Order], [BiometricID], [MapleID], [DOB], [DOJ], [Gender], [MaritalStatus], [DOA], [BloodGroup], [EmergencyContactPerson], [EmergencyContactNumber], [EmergencyContactRelation], [IsBilling], [IsProfileUpdated], [SlackId]) VALUES (2130, N'vinod', N'k', 4, 1068, N'9491989656', NULL, N'vinodk@gmail.com', N'vinod', N'23D42F5F3F66498B2C8FF4C20B8C5AC826E47146', 0, 0, CAST(N'1900-01-01 00:00:00.000' AS DateTime), 38, NULL, NULL, CAST(N'1900-01-01' AS Date), CAST(N'1900-01-01' AS Date), 1, 0, CAST(N'1900-01-01' AS Date), N'-1', NULL, NULL, NULL, NULL, 1, N'vinodk')
GO
INSERT [AT2].[tblEmployees] ([EmployeeID], [FirstName], [LastName], [DesignationID], [DepartmentID], [Mobile], [WorkEmail], [PersonalEmail], [UserID], [Password], [IsAdmin], [IsActive], [ActivatedDate], [Order], [BiometricID], [MapleID], [DOB], [DOJ], [Gender], [MaritalStatus], [DOA], [BloodGroup], [EmergencyContactPerson], [EmergencyContactNumber], [EmergencyContactRelation], [IsBilling], [IsProfileUpdated], [SlackId]) VALUES (2131, N'Kushi', N'kumari', 1042, 1068, N'9856471233', N'kushikumari@gmail.com', N'kushikumari@gmail.com', N'Kushi', N'23D42F5F3F66498B2C8FF4C20B8C5AC826E47146', 0, 0, CAST(N'1900-01-01 00:00:00.000' AS DateTime), 38, NULL, NULL, CAST(N'1991-02-27' AS Date), CAST(N'2012-12-31' AS Date), 2, 0, CAST(N'1900-01-01' AS Date), N'AB', N'kunal', N'8564123852', N'father', NULL, 1, N'erdftfgh')
GO
INSERT [AT2].[tblEmployees] ([EmployeeID], [FirstName], [LastName], [DesignationID], [DepartmentID], [Mobile], [WorkEmail], [PersonalEmail], [UserID], [Password], [IsAdmin], [IsActive], [ActivatedDate], [Order], [BiometricID], [MapleID], [DOB], [DOJ], [Gender], [MaritalStatus], [DOA], [BloodGroup], [EmergencyContactPerson], [EmergencyContactNumber], [EmergencyContactRelation], [IsBilling], [IsProfileUpdated], [SlackId]) VALUES (2132, N'Mahesh', N'g', 1042, 1068, N'9876543210', N'test@gmail.com', N'test@gmail.com', N'mahesh', N'23D42F5F3F66498B2C8FF4C20B8C5AC826E47146', 0, 0, CAST(N'1900-01-01 00:00:00.000' AS DateTime), 38, NULL, N'5623', CAST(N'1996-07-02' AS Date), CAST(N'1900-01-01' AS Date), 1, 0, CAST(N'1900-01-01' AS Date), N'B+', N'test', N'9876543210', N'test', NULL, 1, NULL)
GO
INSERT [AT2].[tblEmployees] ([EmployeeID], [FirstName], [LastName], [DesignationID], [DepartmentID], [Mobile], [WorkEmail], [PersonalEmail], [UserID], [Password], [IsAdmin], [IsActive], [ActivatedDate], [Order], [BiometricID], [MapleID], [DOB], [DOJ], [Gender], [MaritalStatus], [DOA], [BloodGroup], [EmergencyContactPerson], [EmergencyContactNumber], [EmergencyContactRelation], [IsBilling], [IsProfileUpdated], [SlackId]) VALUES (2133, N'venky', N'ch', 4, 1068, N'9988998899', N'sai@maple-software.com', N'saik@gmail.com', N'venky', N'23D42F5F3F66498B2C8FF4C20B8C5AC826E47146', 0, 0, CAST(N'1900-01-01 00:00:00.000' AS DateTime), 38, NULL, NULL, CAST(N'1997-06-03' AS Date), CAST(N'2018-07-17' AS Date), 1, 0, CAST(N'1900-01-01' AS Date), N'B+', N'mallesh', N'9988998899', N'uncle', NULL, 1, NULL)
GO
INSERT [AT2].[tblEmployees] ([EmployeeID], [FirstName], [LastName], [DesignationID], [DepartmentID], [Mobile], [WorkEmail], [PersonalEmail], [UserID], [Password], [IsAdmin], [IsActive], [ActivatedDate], [Order], [BiometricID], [MapleID], [DOB], [DOJ], [Gender], [MaritalStatus], [DOA], [BloodGroup], [EmergencyContactPerson], [EmergencyContactNumber], [EmergencyContactRelation], [IsBilling], [IsProfileUpdated], [SlackId]) VALUES (2134, N'testing', N'testing', 4, 1068, N'9999999999', N'testing@gmail.com', N'testing@gmail.com', N'testing', N'23D42F5F3F66498B2C8FF4C20B8C5AC826E47146', 0, 0, CAST(N'1900-01-01 00:00:00.000' AS DateTime), 38, NULL, NULL, CAST(N'1991-02-27' AS Date), CAST(N'1900-01-01' AS Date), 1, 0, CAST(N'1900-01-01' AS Date), N'B+', N'kunal', N'8564123852', N'father', NULL, 1, NULL)
GO
INSERT [AT2].[tblEmployees] ([EmployeeID], [FirstName], [LastName], [DesignationID], [DepartmentID], [Mobile], [WorkEmail], [PersonalEmail], [UserID], [Password], [IsAdmin], [IsActive], [ActivatedDate], [Order], [BiometricID], [MapleID], [DOB], [DOJ], [Gender], [MaritalStatus], [DOA], [BloodGroup], [EmergencyContactPerson], [EmergencyContactNumber], [EmergencyContactRelation], [IsBilling], [IsProfileUpdated], [SlackId]) VALUES (2135, N'TEST', N'TEST', 7, 1068, N'9999999999', N'kushikumari@gmail.com', N'testing@gmail.com', N'TEST12345', N'23D42F5F3F66498B2C8FF4C20B8C5AC826E47146', 0, 0, CAST(N'1900-01-01 00:00:00.000' AS DateTime), 38, NULL, NULL, CAST(N'1991-02-27' AS Date), CAST(N'2012-12-31' AS Date), 1, 0, CAST(N'1900-01-01' AS Date), N'B+', N'TEST123', N'8564123852', N'TEST123', NULL, 1, NULL)
GO
INSERT [AT2].[tblEmployees] ([EmployeeID], [FirstName], [LastName], [DesignationID], [DepartmentID], [Mobile], [WorkEmail], [PersonalEmail], [UserID], [Password], [IsAdmin], [IsActive], [ActivatedDate], [Order], [BiometricID], [MapleID], [DOB], [DOJ], [Gender], [MaritalStatus], [DOA], [BloodGroup], [EmergencyContactPerson], [EmergencyContactNumber], [EmergencyContactRelation], [IsBilling], [IsProfileUpdated], [SlackId]) VALUES (2136, N'nani', N'n', 1042, 1069, N'9876543210', N'test@gmail.com', N'test@gmail.com', N'nani', N'23D42F5F3F66498B2C8FF4C20B8C5AC826E47146', 0, 0, CAST(N'1900-01-01 00:00:00.000' AS DateTime), 38, N'321456', N'78965', CAST(N'1996-07-02' AS Date), CAST(N'1900-01-01' AS Date), 1, 0, CAST(N'1900-01-01' AS Date), N'A+', N'rtest', N'9876543210', N'test', NULL, 1, NULL)
GO
INSERT [AT2].[tblEmployees] ([EmployeeID], [FirstName], [LastName], [DesignationID], [DepartmentID], [Mobile], [WorkEmail], [PersonalEmail], [UserID], [Password], [IsAdmin], [IsActive], [ActivatedDate], [Order], [BiometricID], [MapleID], [DOB], [DOJ], [Gender], [MaritalStatus], [DOA], [BloodGroup], [EmergencyContactPerson], [EmergencyContactNumber], [EmergencyContactRelation], [IsBilling], [IsProfileUpdated], [SlackId]) VALUES (2137, N'aaaa', N'ggg', 1042, 1068, N'9876543210', N'test@gmail.com', N'test@gmail.com', N'aaa', N'23D42F5F3F66498B2C8FF4C20B8C5AC826E47146', 0, 0, CAST(N'1900-01-01 00:00:00.000' AS DateTime), 38, NULL, N'56223', CAST(N'1996-07-02' AS Date), CAST(N'2019-05-13' AS Date), 1, 0, CAST(N'1900-01-01' AS Date), N'A-', N'test', N'9876543210', N'test', NULL, 1, NULL)
GO
INSERT [AT2].[tblEmployees] ([EmployeeID], [FirstName], [LastName], [DesignationID], [DepartmentID], [Mobile], [WorkEmail], [PersonalEmail], [UserID], [Password], [IsAdmin], [IsActive], [ActivatedDate], [Order], [BiometricID], [MapleID], [DOB], [DOJ], [Gender], [MaritalStatus], [DOA], [BloodGroup], [EmergencyContactPerson], [EmergencyContactNumber], [EmergencyContactRelation], [IsBilling], [IsProfileUpdated], [SlackId]) VALUES (2138, N'test', N'test', 4, 1068, N'4455885555', N'te@maple-software.com', N't@gmail.com', N'test1', N'23D42F5F3F66498B2C8FF4C20B8C5AC826E47146', 0, 0, CAST(N'1900-01-01 00:00:00.000' AS DateTime), 38, NULL, NULL, CAST(N'1997-06-03' AS Date), CAST(N'1900-01-01' AS Date), 1, 0, CAST(N'1900-01-01' AS Date), N'A+', N'ssssss', N'9988568698', N'wife', NULL, 1, NULL)
GO
INSERT [AT2].[tblEmployees] ([EmployeeID], [FirstName], [LastName], [DesignationID], [DepartmentID], [Mobile], [WorkEmail], [PersonalEmail], [UserID], [Password], [IsAdmin], [IsActive], [ActivatedDate], [Order], [BiometricID], [MapleID], [DOB], [DOJ], [Gender], [MaritalStatus], [DOA], [BloodGroup], [EmergencyContactPerson], [EmergencyContactNumber], [EmergencyContactRelation], [IsBilling], [IsProfileUpdated], [SlackId]) VALUES (2139, N'Kiran', N'J', 10, 1, N'7997895060', N'kiran@gmail.com', N'kk@gmail.com', N'Kiran', N'23D42F5F3F66498B2C8FF4C20B8C5AC826E47146', 0, 0, CAST(N'1900-01-01 00:00:00.000' AS DateTime), 38, NULL, N'undefined', CAST(N'1994-10-19' AS Date), CAST(N'1900-01-01' AS Date), 1, 0, CAST(N'1900-01-01' AS Date), N'o+', N'NNN', N'9493828239', N'gdshdghs', NULL, 1, NULL)
GO
INSERT [AT2].[tblEmployees] ([EmployeeID], [FirstName], [LastName], [DesignationID], [DepartmentID], [Mobile], [WorkEmail], [PersonalEmail], [UserID], [Password], [IsAdmin], [IsActive], [ActivatedDate], [Order], [BiometricID], [MapleID], [DOB], [DOJ], [Gender], [MaritalStatus], [DOA], [BloodGroup], [EmergencyContactPerson], [EmergencyContactNumber], [EmergencyContactRelation], [IsBilling], [IsProfileUpdated], [SlackId]) VALUES (2140, N'Bhargav', N'Kumar', 17, 1, N'9493828239', N'bhargav@gmail.com', N'bk@gmail.com', N'Bhargav', N'23D42F5F3F66498B2C8FF4C20B8C5AC826E47146', 0, 1, CAST(N'1900-01-01 00:00:00.000' AS DateTime), 38, N'1', N'B0007', CAST(N'1995-10-19' AS Date), CAST(N'1900-01-01' AS Date), 1, 0, CAST(N'1900-01-01' AS Date), N'o+', NULL, NULL, NULL, NULL, 0, NULL)
GO
SET IDENTITY_INSERT [AT2].[tblEmployees] OFF
GO
SET IDENTITY_INSERT [AT2].[tblHolidays] ON 

GO
INSERT [AT2].[tblHolidays] ([ID], [Year], [Date], [Day], [Festival]) VALUES (56, N'2020', N'01/02/2020', N' Tuesday', N' New Year Day')
GO
INSERT [AT2].[tblHolidays] ([ID], [Year], [Date], [Day], [Festival]) VALUES (57, N'2020', N'01/14/2020', N' Monday', N' Bhogi')
GO
INSERT [AT2].[tblHolidays] ([ID], [Year], [Date], [Day], [Festival]) VALUES (58, N'2020', N'01/15/2020', N' Tuesday', N' Sankranti')
GO
INSERT [AT2].[tblHolidays] ([ID], [Year], [Date], [Day], [Festival]) VALUES (59, N'2020', N'03/04/2020', N' Monday', N' Maha Shivratri')
GO
INSERT [AT2].[tblHolidays] ([ID], [Year], [Date], [Day], [Festival]) VALUES (60, N'2020', N'08/15/2020', N' Thursday', N' Independence Day')
GO
INSERT [AT2].[tblHolidays] ([ID], [Year], [Date], [Day], [Festival]) VALUES (61, N'2020', N'08/23/2020', N' Friday', N' Krishnastami')
GO
INSERT [AT2].[tblHolidays] ([ID], [Year], [Date], [Day], [Festival]) VALUES (62, N'2020', N'09/02/2020', N' Monday', N' Ganesh Chaturthi')
GO
INSERT [AT2].[tblHolidays] ([ID], [Year], [Date], [Day], [Festival]) VALUES (63, N'2020', N'10/08/2020', N' Tuesday', N' Vijaya Dashami')
GO
INSERT [AT2].[tblHolidays] ([ID], [Year], [Date], [Day], [Festival]) VALUES (64, N'2020', N'12/25/2020', N' Wednesday', N' Christmas')
GO
INSERT [AT2].[tblHolidays] ([ID], [Year], [Date], [Day], [Festival]) VALUES (3273, N'2019', N'01/01/2019', N' Tuesday', N' New Year Day')
GO
INSERT [AT2].[tblHolidays] ([ID], [Year], [Date], [Day], [Festival]) VALUES (3274, N'2019', N'01/14/2019', N' Monday', N' Bhogi')
GO
INSERT [AT2].[tblHolidays] ([ID], [Year], [Date], [Day], [Festival]) VALUES (3275, N'2019', N'01/15/2019', N' Tuesday', N' Sankranti')
GO
INSERT [AT2].[tblHolidays] ([ID], [Year], [Date], [Day], [Festival]) VALUES (3276, N'2019', N'03/04/2019', N' Monday', N' Maha Shivratri')
GO
INSERT [AT2].[tblHolidays] ([ID], [Year], [Date], [Day], [Festival]) VALUES (3277, N'2019', N'08/15/2019', N' Thursday', N' Independence Day')
GO
INSERT [AT2].[tblHolidays] ([ID], [Year], [Date], [Day], [Festival]) VALUES (3278, N'2019', N'08/23/2019', N' Friday', N' Krishnastami')
GO
INSERT [AT2].[tblHolidays] ([ID], [Year], [Date], [Day], [Festival]) VALUES (3279, N'2019', N'09/02/2019', N' Monday', N' Ganesh Chaturthi')
GO
INSERT [AT2].[tblHolidays] ([ID], [Year], [Date], [Day], [Festival]) VALUES (3280, N'2019', N'10/08/2019', N' Tuesday', N' Vijaya Dashami')
GO
INSERT [AT2].[tblHolidays] ([ID], [Year], [Date], [Day], [Festival]) VALUES (3281, N'2019', N'12/25/2019', N' Wednesday', N' Christmas')
GO
SET IDENTITY_INSERT [AT2].[tblHolidays] OFF
GO
SET IDENTITY_INSERT [AT2].[tblTimelog] ON 

GO
INSERT [AT2].[tblTimelog] ([Id], [EmployeeId], [Date], [Type], [StartTime], [EndTime]) VALUES (46, 53, CAST(N'2019-04-30 19:06:19.410' AS DateTime), N'break', CAST(N'19:06:00' AS Time), CAST(N'19:06:00' AS Time))
GO
INSERT [AT2].[tblTimelog] ([Id], [EmployeeId], [Date], [Type], [StartTime], [EndTime]) VALUES (47, 53, CAST(N'2019-04-30 19:06:33.040' AS DateTime), N'break', CAST(N'19:06:00' AS Time), CAST(N'19:29:00' AS Time))
GO
INSERT [AT2].[tblTimelog] ([Id], [EmployeeId], [Date], [Type], [StartTime], [EndTime]) VALUES (51, 3, CAST(N'2019-04-30 19:10:01.440' AS DateTime), N'break', CAST(N'19:10:00' AS Time), CAST(N'03:02:00' AS Time))
GO
INSERT [AT2].[tblTimelog] ([Id], [EmployeeId], [Date], [Type], [StartTime], [EndTime]) VALUES (52, 3, CAST(N'2019-04-30 19:11:17.443' AS DateTime), N'break', CAST(N'19:11:00' AS Time), CAST(N'03:02:00' AS Time))
GO
INSERT [AT2].[tblTimelog] ([Id], [EmployeeId], [Date], [Type], [StartTime], [EndTime]) VALUES (53, 3, CAST(N'2019-04-30 19:12:27.887' AS DateTime), N'lunch', CAST(N'19:12:00' AS Time), CAST(N'03:02:00' AS Time))
GO
INSERT [AT2].[tblTimelog] ([Id], [EmployeeId], [Date], [Type], [StartTime], [EndTime]) VALUES (54, 3, CAST(N'2019-04-30 19:15:53.820' AS DateTime), N'break', CAST(N'19:15:00' AS Time), CAST(N'03:02:00' AS Time))
GO
INSERT [AT2].[tblTimelog] ([Id], [EmployeeId], [Date], [Type], [StartTime], [EndTime]) VALUES (64, 53, CAST(N'2019-05-01 12:28:33.763' AS DateTime), N'break', CAST(N'12:28:00' AS Time), CAST(N'12:28:00' AS Time))
GO
INSERT [AT2].[tblTimelog] ([Id], [EmployeeId], [Date], [Type], [StartTime], [EndTime]) VALUES (65, 53, CAST(N'2019-05-01 12:28:51.490' AS DateTime), N'lunch', CAST(N'12:28:00' AS Time), CAST(N'12:29:00' AS Time))
GO
INSERT [AT2].[tblTimelog] ([Id], [EmployeeId], [Date], [Type], [StartTime], [EndTime]) VALUES (66, 53, CAST(N'2019-05-01 12:29:10.427' AS DateTime), N'break', CAST(N'12:29:00' AS Time), CAST(N'12:29:00' AS Time))
GO
INSERT [AT2].[tblTimelog] ([Id], [EmployeeId], [Date], [Type], [StartTime], [EndTime]) VALUES (67, 53, CAST(N'2019-05-01 12:31:36.327' AS DateTime), N'break', CAST(N'12:31:00' AS Time), NULL)
GO
INSERT [AT2].[tblTimelog] ([Id], [EmployeeId], [Date], [Type], [StartTime], [EndTime]) VALUES (68, 54, CAST(N'2019-05-01 12:36:25.620' AS DateTime), N'break', CAST(N'12:36:00' AS Time), CAST(N'12:44:00' AS Time))
GO
INSERT [AT2].[tblTimelog] ([Id], [EmployeeId], [Date], [Type], [StartTime], [EndTime]) VALUES (69, 3, CAST(N'2019-05-01 12:43:08.060' AS DateTime), N'break', CAST(N'12:43:00' AS Time), CAST(N'03:02:00' AS Time))
GO
INSERT [AT2].[tblTimelog] ([Id], [EmployeeId], [Date], [Type], [StartTime], [EndTime]) VALUES (76, 53, CAST(N'2019-05-02 12:45:42.963' AS DateTime), N'break', CAST(N'12:45:00' AS Time), CAST(N'15:13:00' AS Time))
GO
INSERT [AT2].[tblTimelog] ([Id], [EmployeeId], [Date], [Type], [StartTime], [EndTime]) VALUES (80, 3, CAST(N'2019-05-02 12:59:59.517' AS DateTime), N'break', CAST(N'12:09:00' AS Time), CAST(N'12:30:00' AS Time))
GO
INSERT [AT2].[tblTimelog] ([Id], [EmployeeId], [Date], [Type], [StartTime], [EndTime]) VALUES (81, 3, CAST(N'2019-05-02 13:02:03.663' AS DateTime), N'lunch', CAST(N'12:35:00' AS Time), CAST(N'13:02:00' AS Time))
GO
INSERT [AT2].[tblTimelog] ([Id], [EmployeeId], [Date], [Type], [StartTime], [EndTime]) VALUES (82, 3, CAST(N'2019-05-02 13:03:02.087' AS DateTime), N'break', CAST(N'13:03:00' AS Time), CAST(N'03:02:00' AS Time))
GO
INSERT [AT2].[tblTimelog] ([Id], [EmployeeId], [Date], [Type], [StartTime], [EndTime]) VALUES (83, 54, CAST(N'2019-05-02 14:19:55.603' AS DateTime), N'break', CAST(N'14:19:00' AS Time), CAST(N'14:20:00' AS Time))
GO
INSERT [AT2].[tblTimelog] ([Id], [EmployeeId], [Date], [Type], [StartTime], [EndTime]) VALUES (84, 54, CAST(N'2019-05-02 14:21:26.970' AS DateTime), N'lunch', CAST(N'14:21:00' AS Time), CAST(N'15:30:00' AS Time))
GO
INSERT [AT2].[tblTimelog] ([Id], [EmployeeId], [Date], [Type], [StartTime], [EndTime]) VALUES (85, 53, CAST(N'2019-05-02 15:14:04.780' AS DateTime), N'lunch', CAST(N'15:14:00' AS Time), CAST(N'15:14:00' AS Time))
GO
INSERT [AT2].[tblTimelog] ([Id], [EmployeeId], [Date], [Type], [StartTime], [EndTime]) VALUES (86, 54, CAST(N'2019-05-02 15:31:12.973' AS DateTime), N'break', CAST(N'15:31:00' AS Time), CAST(N'15:31:00' AS Time))
GO
INSERT [AT2].[tblTimelog] ([Id], [EmployeeId], [Date], [Type], [StartTime], [EndTime]) VALUES (87, 53, CAST(N'2019-05-02 15:53:07.460' AS DateTime), N'break', CAST(N'15:53:00' AS Time), CAST(N'16:32:00' AS Time))
GO
INSERT [AT2].[tblTimelog] ([Id], [EmployeeId], [Date], [Type], [StartTime], [EndTime]) VALUES (88, 54, CAST(N'2019-05-02 15:53:07.543' AS DateTime), N'break', CAST(N'15:53:00' AS Time), CAST(N'15:53:00' AS Time))
GO
INSERT [AT2].[tblTimelog] ([Id], [EmployeeId], [Date], [Type], [StartTime], [EndTime]) VALUES (89, 53, CAST(N'2019-05-02 16:35:44.197' AS DateTime), N'break', CAST(N'16:35:00' AS Time), CAST(N'16:37:00' AS Time))
GO
INSERT [AT2].[tblTimelog] ([Id], [EmployeeId], [Date], [Type], [StartTime], [EndTime]) VALUES (90, 53, CAST(N'2019-05-02 16:37:13.763' AS DateTime), N'break', CAST(N'16:37:00' AS Time), CAST(N'19:00:00' AS Time))
GO
INSERT [AT2].[tblTimelog] ([Id], [EmployeeId], [Date], [Type], [StartTime], [EndTime]) VALUES (91, 54, CAST(N'2019-05-02 17:52:32.413' AS DateTime), N'break', CAST(N'17:52:00' AS Time), CAST(N'17:52:00' AS Time))
GO
INSERT [AT2].[tblTimelog] ([Id], [EmployeeId], [Date], [Type], [StartTime], [EndTime]) VALUES (92, 54, CAST(N'2019-05-02 17:53:46.953' AS DateTime), N'break', CAST(N'17:53:00' AS Time), CAST(N'17:53:00' AS Time))
GO
INSERT [AT2].[tblTimelog] ([Id], [EmployeeId], [Date], [Type], [StartTime], [EndTime]) VALUES (93, 54, CAST(N'2019-05-02 18:00:32.377' AS DateTime), N'break', CAST(N'18:00:00' AS Time), CAST(N'18:00:00' AS Time))
GO
INSERT [AT2].[tblTimelog] ([Id], [EmployeeId], [Date], [Type], [StartTime], [EndTime]) VALUES (94, 1, CAST(N'2019-05-02 18:13:54.927' AS DateTime), N'break', CAST(N'18:13:00' AS Time), CAST(N'18:14:00' AS Time))
GO
INSERT [AT2].[tblTimelog] ([Id], [EmployeeId], [Date], [Type], [StartTime], [EndTime]) VALUES (95, 53, CAST(N'2019-05-02 19:00:36.203' AS DateTime), N'break', CAST(N'19:00:00' AS Time), CAST(N'19:54:00' AS Time))
GO
INSERT [AT2].[tblTimelog] ([Id], [EmployeeId], [Date], [Type], [StartTime], [EndTime]) VALUES (96, 53, CAST(N'2019-05-02 19:55:46.370' AS DateTime), N'break', CAST(N'19:55:00' AS Time), NULL)
GO
INSERT [AT2].[tblTimelog] ([Id], [EmployeeId], [Date], [Type], [StartTime], [EndTime]) VALUES (1095, 54, CAST(N'2019-05-03 11:45:44.673' AS DateTime), N'break', CAST(N'11:45:00' AS Time), CAST(N'12:00:00' AS Time))
GO
INSERT [AT2].[tblTimelog] ([Id], [EmployeeId], [Date], [Type], [StartTime], [EndTime]) VALUES (1096, 54, CAST(N'2019-05-03 11:45:52.907' AS DateTime), N'lunch', CAST(N'01:00:00' AS Time), CAST(N'01:40:00' AS Time))
GO
INSERT [AT2].[tblTimelog] ([Id], [EmployeeId], [Date], [Type], [StartTime], [EndTime]) VALUES (1097, 54, CAST(N'2019-05-03 11:46:02.810' AS DateTime), N'break', CAST(N'05:00:00' AS Time), CAST(N'05:40:00' AS Time))
GO
INSERT [AT2].[tblTimelog] ([Id], [EmployeeId], [Date], [Type], [StartTime], [EndTime]) VALUES (1098, 53, CAST(N'2019-05-03 15:05:51.250' AS DateTime), N'break', CAST(N'15:05:00' AS Time), CAST(N'16:31:00' AS Time))
GO
INSERT [AT2].[tblTimelog] ([Id], [EmployeeId], [Date], [Type], [StartTime], [EndTime]) VALUES (1099, 53, CAST(N'2019-05-03 16:53:50.487' AS DateTime), N'break', CAST(N'16:53:00' AS Time), CAST(N'16:58:00' AS Time))
GO
INSERT [AT2].[tblTimelog] ([Id], [EmployeeId], [Date], [Type], [StartTime], [EndTime]) VALUES (1100, 54, CAST(N'2019-05-03 18:26:31.200' AS DateTime), N'break', CAST(N'18:26:00' AS Time), CAST(N'19:06:00' AS Time))
GO
INSERT [AT2].[tblTimelog] ([Id], [EmployeeId], [Date], [Type], [StartTime], [EndTime]) VALUES (1104, 53, CAST(N'2019-05-03 19:41:47.337' AS DateTime), N'EH', CAST(N'19:41:00' AS Time), CAST(N'19:42:00' AS Time))
GO
INSERT [AT2].[tblTimelog] ([Id], [EmployeeId], [Date], [Type], [StartTime], [EndTime]) VALUES (1105, 54, CAST(N'2019-05-03 19:49:22.597' AS DateTime), N'EH', CAST(N'19:49:00' AS Time), CAST(N'19:50:00' AS Time))
GO
INSERT [AT2].[tblTimelog] ([Id], [EmployeeId], [Date], [Type], [StartTime], [EndTime]) VALUES (2096, 54, CAST(N'2019-05-06 10:59:32.697' AS DateTime), N'break', CAST(N'10:59:00' AS Time), CAST(N'11:00:00' AS Time))
GO
INSERT [AT2].[tblTimelog] ([Id], [EmployeeId], [Date], [Type], [StartTime], [EndTime]) VALUES (2098, 54, CAST(N'2019-05-06 11:00:54.383' AS DateTime), N'lunch', CAST(N'11:00:00' AS Time), CAST(N'11:01:00' AS Time))
GO
INSERT [AT2].[tblTimelog] ([Id], [EmployeeId], [Date], [Type], [StartTime], [EndTime]) VALUES (2100, 54, CAST(N'2019-05-06 12:13:46.580' AS DateTime), N'break', CAST(N'12:13:00' AS Time), CAST(N'12:18:00' AS Time))
GO
INSERT [AT2].[tblTimelog] ([Id], [EmployeeId], [Date], [Type], [StartTime], [EndTime]) VALUES (2102, 54, CAST(N'2019-05-06 12:26:56.223' AS DateTime), N'break', CAST(N'12:26:00' AS Time), CAST(N'12:27:00' AS Time))
GO
INSERT [AT2].[tblTimelog] ([Id], [EmployeeId], [Date], [Type], [StartTime], [EndTime]) VALUES (2103, 54, CAST(N'2019-05-06 12:28:08.890' AS DateTime), N'break', CAST(N'12:28:00' AS Time), CAST(N'14:11:00' AS Time))
GO
INSERT [AT2].[tblTimelog] ([Id], [EmployeeId], [Date], [Type], [StartTime], [EndTime]) VALUES (2117, 3, CAST(N'2019-05-05 22:05:21.233' AS DateTime), N'eh', CAST(N'22:05:00' AS Time), CAST(N'15:13:00' AS Time))
GO
INSERT [AT2].[tblTimelog] ([Id], [EmployeeId], [Date], [Type], [StartTime], [EndTime]) VALUES (2119, 3, CAST(N'2019-05-06 11:00:11.017' AS DateTime), N'break', CAST(N'11:00:00' AS Time), CAST(N'11:25:00' AS Time))
GO
INSERT [AT2].[tblTimelog] ([Id], [EmployeeId], [Date], [Type], [StartTime], [EndTime]) VALUES (2120, 3, CAST(N'2019-05-06 13:01:11.017' AS DateTime), N'lunch', CAST(N'13:01:00' AS Time), CAST(N'14:05:00' AS Time))
GO
INSERT [AT2].[tblTimelog] ([Id], [EmployeeId], [Date], [Type], [StartTime], [EndTime]) VALUES (2121, 3, CAST(N'2019-05-06 17:05:11.017' AS DateTime), N'break', CAST(N'17:05:00' AS Time), CAST(N'17:25:00' AS Time))
GO
INSERT [AT2].[tblTimelog] ([Id], [EmployeeId], [Date], [Type], [StartTime], [EndTime]) VALUES (2122, 3, CAST(N'2019-05-06 17:50:11.017' AS DateTime), N'break', CAST(N'17:50:00' AS Time), CAST(N'18:20:00' AS Time))
GO
INSERT [AT2].[tblTimelog] ([Id], [EmployeeId], [Date], [Type], [StartTime], [EndTime]) VALUES (2124, 54, CAST(N'2019-05-06 17:04:14.757' AS DateTime), N'eh', CAST(N'17:04:00' AS Time), CAST(N'17:05:00' AS Time))
GO
INSERT [AT2].[tblTimelog] ([Id], [EmployeeId], [Date], [Type], [StartTime], [EndTime]) VALUES (2125, 53, CAST(N'2019-05-06 17:46:27.297' AS DateTime), N'break', CAST(N'17:46:00' AS Time), CAST(N'17:47:00' AS Time))
GO
INSERT [AT2].[tblTimelog] ([Id], [EmployeeId], [Date], [Type], [StartTime], [EndTime]) VALUES (2126, 53, CAST(N'2019-05-06 17:47:25.363' AS DateTime), N'lunch', CAST(N'17:47:00' AS Time), CAST(N'17:47:00' AS Time))
GO
INSERT [AT2].[tblTimelog] ([Id], [EmployeeId], [Date], [Type], [StartTime], [EndTime]) VALUES (2127, 53, CAST(N'2019-05-06 17:47:55.810' AS DateTime), N'break', CAST(N'17:47:00' AS Time), CAST(N'00:00:00' AS Time))
GO
INSERT [AT2].[tblTimelog] ([Id], [EmployeeId], [Date], [Type], [StartTime], [EndTime]) VALUES (2129, 53, CAST(N'2019-05-06 18:28:30.013' AS DateTime), N'eh', CAST(N'18:28:00' AS Time), CAST(N'18:28:00' AS Time))
GO
INSERT [AT2].[tblTimelog] ([Id], [EmployeeId], [Date], [Type], [StartTime], [EndTime]) VALUES (2130, 53, CAST(N'2019-05-07 10:52:25.127' AS DateTime), N'break', CAST(N'10:52:00' AS Time), CAST(N'10:52:00' AS Time))
GO
INSERT [AT2].[tblTimelog] ([Id], [EmployeeId], [Date], [Type], [StartTime], [EndTime]) VALUES (2131, 53, CAST(N'2019-05-07 10:52:58.030' AS DateTime), N'lunch', CAST(N'10:52:00' AS Time), CAST(N'10:56:00' AS Time))
GO
INSERT [AT2].[tblTimelog] ([Id], [EmployeeId], [Date], [Type], [StartTime], [EndTime]) VALUES (2132, 53, CAST(N'2019-05-07 16:00:05.023' AS DateTime), N'break', CAST(N'16:00:00' AS Time), CAST(N'19:48:00' AS Time))
GO
INSERT [AT2].[tblTimelog] ([Id], [EmployeeId], [Date], [Type], [StartTime], [EndTime]) VALUES (2133, 54, CAST(N'2019-05-07 19:52:32.827' AS DateTime), N'break', CAST(N'19:52:00' AS Time), CAST(N'19:52:00' AS Time))
GO
INSERT [AT2].[tblTimelog] ([Id], [EmployeeId], [Date], [Type], [StartTime], [EndTime]) VALUES (2134, 54, CAST(N'2019-05-07 19:52:50.363' AS DateTime), N'break', CAST(N'19:52:00' AS Time), NULL)
GO
INSERT [AT2].[tblTimelog] ([Id], [EmployeeId], [Date], [Type], [StartTime], [EndTime]) VALUES (2135, 53, CAST(N'2019-05-07 19:56:15.127' AS DateTime), N'eh', CAST(N'19:56:00' AS Time), CAST(N'19:57:00' AS Time))
GO
INSERT [AT2].[tblTimelog] ([Id], [EmployeeId], [Date], [Type], [StartTime], [EndTime]) VALUES (2136, 53, CAST(N'2019-05-08 16:52:29.553' AS DateTime), N'break', CAST(N'16:52:00' AS Time), NULL)
GO
INSERT [AT2].[tblTimelog] ([Id], [EmployeeId], [Date], [Type], [StartTime], [EndTime]) VALUES (2137, 3, CAST(N'2019-05-09 11:30:12.140' AS DateTime), N'break', CAST(N'11:30:00' AS Time), CAST(N'11:30:00' AS Time))
GO
INSERT [AT2].[tblTimelog] ([Id], [EmployeeId], [Date], [Type], [StartTime], [EndTime]) VALUES (2138, 53, CAST(N'2019-05-10 11:56:33.337' AS DateTime), N'break', CAST(N'11:56:00' AS Time), CAST(N'11:56:00' AS Time))
GO
INSERT [AT2].[tblTimelog] ([Id], [EmployeeId], [Date], [Type], [StartTime], [EndTime]) VALUES (2139, 54, CAST(N'2019-05-10 14:05:34.283' AS DateTime), N'break', CAST(N'14:05:00' AS Time), CAST(N'14:05:00' AS Time))
GO
INSERT [AT2].[tblTimelog] ([Id], [EmployeeId], [Date], [Type], [StartTime], [EndTime]) VALUES (2140, 54, CAST(N'2019-05-10 14:54:10.197' AS DateTime), N'lunch', CAST(N'14:54:00' AS Time), CAST(N'16:28:00' AS Time))
GO
INSERT [AT2].[tblTimelog] ([Id], [EmployeeId], [Date], [Type], [StartTime], [EndTime]) VALUES (2147, 53, CAST(N'2019-05-13 11:40:11.813' AS DateTime), N'break', CAST(N'11:40:00' AS Time), NULL)
GO
INSERT [AT2].[tblTimelog] ([Id], [EmployeeId], [Date], [Type], [StartTime], [EndTime]) VALUES (2148, 54, CAST(N'2019-05-15 16:12:49.343' AS DateTime), N'break', CAST(N'16:12:00' AS Time), CAST(N'16:12:00' AS Time))
GO
INSERT [AT2].[tblTimelog] ([Id], [EmployeeId], [Date], [Type], [StartTime], [EndTime]) VALUES (2149, 54, CAST(N'2019-05-15 18:38:50.963' AS DateTime), N'lunch', CAST(N'18:38:00' AS Time), NULL)
GO
SET IDENTITY_INSERT [AT2].[tblTimelog] OFF
GO
SET IDENTITY_INSERT [BILL].[tblBillingType] ON 

GO
INSERT [BILL].[tblBillingType] ([BillingTypeId], [BillingType], [IsActive], [CreatedOn], [CreatedBy], [UpdatedOn], [UpdatedBy]) VALUES (1, N'Hourly', 1, NULL, NULL, NULL, NULL)
GO
SET IDENTITY_INSERT [BILL].[tblBillingType] OFF
GO
SET IDENTITY_INSERT [BILL].[tblClients] ON 

GO
INSERT [BILL].[tblClients] ([ClientId], [ClientName], [CountryId], [BillingTypeId], [IsActive], [CreatedOn], [CreatedBy], [UpdatedOn], [UpdatedBy]) VALUES (1, N'SUBBU', 1, 1, 0, CAST(N'2018-12-31 12:20:32.677' AS DateTime), 1, CAST(N'2019-03-15 13:19:35.637' AS DateTime), 1)
GO
INSERT [BILL].[tblClients] ([ClientId], [ClientName], [CountryId], [BillingTypeId], [IsActive], [CreatedOn], [CreatedBy], [UpdatedOn], [UpdatedBy]) VALUES (2, N'OldClient', 1, 1, 0, CAST(N'2019-03-15 12:19:18.967' AS DateTime), 1, CAST(N'2019-03-15 12:19:18.967' AS DateTime), 1)
GO
INSERT [BILL].[tblClients] ([ClientId], [ClientName], [CountryId], [BillingTypeId], [IsActive], [CreatedOn], [CreatedBy], [UpdatedOn], [UpdatedBy]) VALUES (3, N'RamSingh', 1, 1, 1, CAST(N'2019-03-15 15:25:21.053' AS DateTime), 1, CAST(N'2019-03-15 15:25:21.053' AS DateTime), 1)
GO
INSERT [BILL].[tblClients] ([ClientId], [ClientName], [CountryId], [BillingTypeId], [IsActive], [CreatedOn], [CreatedBy], [UpdatedOn], [UpdatedBy]) VALUES (4, N'RaSingh', 1, 1, 0, CAST(N'2019-03-15 15:27:25.320' AS DateTime), 1, CAST(N'2019-03-15 15:27:25.320' AS DateTime), 1)
GO
INSERT [BILL].[tblClients] ([ClientId], [ClientName], [CountryId], [BillingTypeId], [IsActive], [CreatedOn], [CreatedBy], [UpdatedOn], [UpdatedBy]) VALUES (5, N'RSingh', 1, 1, 1, CAST(N'2019-03-15 15:28:02.070' AS DateTime), 1, CAST(N'2019-03-15 15:28:02.070' AS DateTime), 1)
GO
INSERT [BILL].[tblClients] ([ClientId], [ClientName], [CountryId], [BillingTypeId], [IsActive], [CreatedOn], [CreatedBy], [UpdatedOn], [UpdatedBy]) VALUES (6, N'Singh', 1, 1, 1, CAST(N'2019-03-15 15:30:35.767' AS DateTime), 3, CAST(N'2019-03-18 11:12:09.143' AS DateTime), 3)
GO
INSERT [BILL].[tblClients] ([ClientId], [ClientName], [CountryId], [BillingTypeId], [IsActive], [CreatedOn], [CreatedBy], [UpdatedOn], [UpdatedBy]) VALUES (7, N'Ram', 1, 1, 1, CAST(N'2019-03-22 12:22:01.483' AS DateTime), 1, CAST(N'2019-03-22 12:22:01.483' AS DateTime), 1)
GO
SET IDENTITY_INSERT [BILL].[tblClients] OFF
GO
SET IDENTITY_INSERT [BILL].[tblCountry] ON 

GO
INSERT [BILL].[tblCountry] ([CountryId], [CountryName]) VALUES (1, N'Canada')
GO
SET IDENTITY_INSERT [BILL].[tblCountry] OFF
GO
ALTER TABLE [AT2].[tblEmployees]  WITH CHECK ADD  CONSTRAINT [FK_tblEmployees_tblDepartments] FOREIGN KEY([DepartmentID])
REFERENCES [AT2].[tblDepartments] ([DepartmentId])
GO
ALTER TABLE [AT2].[tblEmployees] CHECK CONSTRAINT [FK_tblEmployees_tblDepartments]
GO
ALTER TABLE [AT2].[tblEmployees]  WITH CHECK ADD  CONSTRAINT [FK_tblEmployees_tblDesignations] FOREIGN KEY([DesignationID])
REFERENCES [AT2].[tblDesignations] ([DesignationID])
GO
ALTER TABLE [AT2].[tblEmployees] CHECK CONSTRAINT [FK_tblEmployees_tblDesignations]
GO
ALTER TABLE [BILL].[tblClients]  WITH CHECK ADD  CONSTRAINT [FK_tblClients_tblBillingType] FOREIGN KEY([BillingTypeId])
REFERENCES [BILL].[tblBillingType] ([BillingTypeId])
GO
ALTER TABLE [BILL].[tblClients] CHECK CONSTRAINT [FK_tblClients_tblBillingType]
GO
ALTER TABLE [BILL].[tblClients]  WITH CHECK ADD  CONSTRAINT [FK_tblClients_tblCountry] FOREIGN KEY([CountryId])
REFERENCES [BILL].[tblCountry] ([CountryId])
GO
ALTER TABLE [BILL].[tblClients] CHECK CONSTRAINT [FK_tblClients_tblCountry]
GO
/****** Object:  StoredProcedure [AT2].[USP_BiometricReport]    Script Date: 5/28/2019 6:15:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- AT2.USP_GetReport 102,'08/26/2014','09/25/2014'
CREATE PROC [AT2].[USP_BiometricReport]
(
@name nvarchar(100)='',
@cardid nvarchar(10)='',
@date datetime='01/01/1900',
@intime datetime='01/01/1900',
@outtime datetime='01/01/1900',
@dtFromDate DATETIME='01/01/1900'
,@dtToDate DATETIME='01/01/1900'
,@vEmployeeIDs VARCHAR(100)='-1',
@iRetVal INT=-1 OUTPUT
,@Mode int = -1
)
AS
BEGIN

if(@Mode = 100)
begin
declare @NewLine char(2) 
set @NewLine=char(13)+char(10)

select convert(varchar(10), a.Date, 101) [Date]
,convert(char(5), A.InTime, 108) [InTime]
,convert(char(5), A.OutTime, 108) [OutTime]
,A.Name,A.CardId,convert(char(5),dateadd(second,-datediff(second,outtime,intime),'00:00:00'), 108) Duration 
from AT2.tblAccessCardData A 
inner join AT2.tblEmployees E on REPLACE(A.CardId,@NewLine,'')=REPLACE(E.BiometricID,@NewLine,'') 
WHERE [DATE] BETWEEN CAST(CONVERT(VARCHAR,@dtFromDate,101) AS DATETIME) 
	AND CAST(CONVERT(VARCHAR,@dtToDate,101) AS DATETIME)
	AND (@vEmployeeIDs='' OR (@vEmployeeIDs!='' AND E.EmployeeID IN (SELECT ISNULL(DATA,0) FROM DBO.SPLIT(@vEmployeeIDs,','))))
ORDER BY A.[Date], E.EmployeeID
end

else If(@Mode = 101)
begin
select top 1 [Date] from AT2.tblAccessCardData order by [Date] desc
end

else if(@Mode = 102)
begin
--select CardId from AT2.tblAccessCardData A join AT2.tblEmployees E on A.CardId = E.BiometricID

--select distinct BiometricID CardId from AT2.tblEmployees E
--left join AT2.tblAccessCardData A ON A.CardId = E.BiometricID
--where IsActive=1

SELECT DISTINCT BiometricID AS CardId FROM AT2.tblEmployees E WHERE IsActive=1

end

else if(@Mode = 103)
begin
insert into AT2.tblAccessCardData(CardId,[Date],InTime,OutTime,[Name]) values(@cardid,@date,@intime
,@outtime,@name)
SET @iRetVal = SCOPE_IDENTITY();
end
--DECLARE @List VARCHAR(8000)

--SELECT @List = COALESCE(@List + ',', '') + CAST(cardid AS VARCHAR)
--FROM   AT2.tblAccessCardData


--SELECT @List 
END



GO
/****** Object:  StoredProcedure [AT2].[USP_Bot_Attendance]    Script Date: 5/28/2019 6:15:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- [ATT].[USP_GetAttendance] @iMode=104, @iEmployeeID=3,@dtCurrentDateTime='05/28/2018'
CREATE PROCEDURE [AT2].[USP_Bot_Attendance](
@iMode INT=-1,
@iID INT=-1,
@iEmployeeID INT=-1,
@dtCurrentDateTime DATETIME='01/01/1900',
@dtPreviousDateTime DATETIME='01/01/1900',
@tInTime TIME='00:00',
@tOutTime time='00:00',
@iLeave INT=-1,
@vLeaveType  NVARCHAR(2)='-1',
@vWFH INT=-1,
@vCreatedBy NVARCHAR(50)='',
@vCallQuality NVARCHAR(100)='',
@vComment NVARCHAR(1000)='',
@dtCreatedDateTime DATETIME='01/01/1900',
@tPermission time=null,
@ExtraHrsWorked  time=null,
@val Int=-1,
@iSlackId NVARCHAR(250)=-1,	
@retVal int=-1 OUTPUT
)
AS 
BEGIN
 IF(@iMode=101)
		BEGIN				
		set @val=(select EmployeeID from AT2.tblEmployees where SlackId=@iSlackId)	
			IF NOT EXISTS(SELECT * FROM AT2.tblAttendance A WHERE A.EmployeeID=@val AND CONVERT(VARCHAR,CONVERT(DATE,A.Date,101))=CONVERT(VARCHAR,CONVERT(DATE,@dtCurrentDateTime,101)))
			BEGIN
					IF(@tInTime!='00:00:00.00000')
					BEGIN
					INSERT INTO AT2.tblAttendance ([Date],EmployeeID,InTime,Leave,LeaveType,PermissionHrs,CreatedBy,CreatedDateTime) 
								VALUES (@dtCurrentDateTime,@val,@tInTime,NULL,NULL,NULL,@val,getdate())					
						 set @retVal=2	
					END
			END			
			ELSE 
			BEGIN		
				declare @wfhval int=(SELECT WorkFromHome FROM AT2.tblAttendance A WHERE A.EmployeeID=@val
			 AND CONVERT(VARCHAR,CONVERT(DATE,A.Date,101))=CONVERT(VARCHAR,CONVERT(DATE,@dtCurrentDateTime,101)))	

			IF NOT EXISTS(SELECT OutTime FROM AT2.tblAttendance A WHERE A.EmployeeID=@val and OutTime!= '00:00:00.00000'and OutTime is not null
			AND CONVERT(VARCHAR,CONVERT(DATE,A.Date,101))=CONVERT(VARCHAR,CONVERT(DATE,@dtCurrentDateTime,101)))
			BEGIN
				 IF(@wfhval IS NULL or @wfhval!=2)
					 BEGIN					
						UPDATE AT2.tblAttendance SET OutTime=@tOutTime
		 					WHERE EmployeeID=@val AND CONVERT(VARCHAR,CONVERT(DATE,Date,101))=CONVERT(VARCHAR,CONVERT(DATE,@dtCurrentDateTime,101))
							DECLARE @Res INT=((SELECT   CONVERT(INT, REPLACE(
													convert(char(5),dateadd(second,-datediff(second,outtime,intime),'00:00:00'), 108),
													':',
													''
												)
											) AS [IntVersion] 
											from AT2.tblAttendance
							where EmployeeID=@val AND CONVERT(VARCHAR,CONVERT(DATE,Date,101))=CONVERT(VARCHAR,CONVERT(DATE,@dtCurrentDateTime,101))))
							if(@Res!=0)
							Begin							
								set @retVal=@Res
							end
							else
							Begin							
								set @retVal=-2
							end
					END			
					ELSE
					BEGIN
						set @retVal=-3	
					END
				END
				ELSE
				BEGIN
					IF EXISTS(SELECT * FROM AT2.tblAttendance WHERE EmployeeID=@val AND
							ISNULL(InTime,'00:00:00.00000')!= '00:00:00.00000' AND ISNULL(OutTime,'00:00:00.00000')!= '00:00:00.00000'
							AND (CONVERT(VARCHAR,CONVERT(DATE,[Date],101))=CONVERT(VARCHAR,CONVERT(DATE,@dtCurrentDateTime,101))))
								set @retVal=-4
					ELSE
								set @retVal=-1
				END
			END
					

			END
				
	END
		


GO
/****** Object:  StoredProcedure [AT2].[USP_Bot_Breaks]    Script Date: 5/28/2019 6:15:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- [ATT].[USP_GetAttendance] @iMode=101, @iEmployeeID=3,@dtCurrentDateTime='05/28/2018'
CREATE PROCEDURE [AT2].[USP_Bot_Breaks](
@iMode INT=-1,
@iID INT=-1,
@iEmployeeID INT=-1,
@dtCurrentDateTime DATETIME='01/01/1900',
@dtPreviousDateTime DATETIME='01/01/1900',
@tInTime TIME='00:00',
@tOutTime time='00:00',
@dtCreatedDateTime DATETIME='01/01/1900',
@iSlackId NVARCHAR(250)=-1,	
@type NVARCHAR(10)=-1,	
@Res INT=-1,
@val INT=-1,
@status varchar(50)=null
)
AS 
BEGIN
	DECLARE @retVal int=-1;
	DECLARE @type1 varchar(10)='';
	set @iEmployeeID=(select EmployeeID from AT2.tblEmployees where SlackId=@iSlackId)	
	IF(@iMode=101)
		BEGIN		
		IF EXISTS(SELECT * FROM AT2.tblAttendance WHERE EmployeeID=@iEmployeeID AND
		ISNULL(InTime,'00:00:00.00000')!= '00:00:00.00000' AND ISNULL(OutTime,'00:00:00.00000')= '00:00:00.00000'
		AND CONVERT(VARCHAR,CONVERT(DATE,Date,101))=CONVERT(VARCHAR,CONVERT(DATE,@dtCurrentDateTime,101)))			
			BEGIN	
				IF NOT EXISTS(SELECT * FROM AT2.tblTimelog A WHERE A.EmployeeID=@iEmployeeID AND A.type='lunch' 
					AND CONVERT(VARCHAR,CONVERT(DATE,A.Date,101))=CONVERT(VARCHAR,CONVERT(DATE,@dtCurrentDateTime,101)))
				BEGIN							
					IF EXISTS(select EndTime FROM AT2.tblTimelog WHERE EmployeeID=@iEmployeeID AND [type]='break'
					 AND EndTime IS NULL AND CONVERT(VARCHAR,CONVERT(DATE,[Date],101))=CONVERT(VARCHAR,CONVERT(DATE,@dtCurrentDateTime,101)))
					BEGIN
						SET @retVal=-2
						SET @type1='break';
					END
					ELSE 
					BEGIN					
						INSERT INTO AT2.tblTimelog ([Date],EmployeeID,StartTime,type) 
						VALUES (@dtCurrentDateTime,@iEmployeeID,@tInTime,@type)					
						set @retVal=@iEmployeeID							
					END
				END
			ELSE
			BEGIN
				IF EXISTS(select EndTime FROM AT2.tblTimelog WHERE EmployeeID=@iEmployeeID AND ([type]='break')
				AND EndTime IS NULL AND CONVERT(VARCHAR,CONVERT(DATE,[Date],101))=CONVERT(VARCHAR,CONVERT(DATE,@dtCurrentDateTime,101)))
					BEGIN
						set @retVal=-2
						SET @type1='break';
					END
				ELSE IF EXISTS(select EndTime FROM AT2.tblTimelog WHERE EmployeeID=@iEmployeeID AND ([type]='lunch')
				AND EndTime IS NULL AND CONVERT(VARCHAR,CONVERT(DATE,[Date],101))=CONVERT(VARCHAR,CONVERT(DATE,@dtCurrentDateTime,101)))
					BEGIN
						set @retVal=-2
						SET @type1='lunch';
					END
				ELSE
						set @retVal=-1
				END
			END
			ELSE
			BEGIN
				IF EXISTS(SELECT * FROM AT2.tblAttendance WHERE EmployeeID=@iEmployeeID AND
				ISNULL(InTime,'00:00:00.00000')!= '00:00:00.00000' AND ISNULL(OutTime,'00:00:00.00000')!= '00:00:00.00000'
				AND CONVERT(VARCHAR,CONVERT(DATE,Date,101))=CONVERT(VARCHAR,CONVERT(DATE,@dtCurrentDateTime,101)))		
						set @retVal=-4	
				ELSE
						set @retVal=-3
			END	
		END	
								
		ELSE  IF(@iMode=102)
		BEGIN
			IF EXISTS(SELECT * FROM AT2.tblAttendance WHERE EmployeeID=@iEmployeeID AND
			ISNULL(InTime,'00:00:00.00000')!= '00:00:00.00000' AND ISNULL(OutTime,'00:00:00.00000')= '00:00:00.00000'
			AND CONVERT(VARCHAR,CONVERT(DATE,Date,101))=CONVERT(VARCHAR,CONVERT(DATE,@dtCurrentDateTime,101)))			
			BEGIN			
				IF EXISTS(select EndTime FROM AT2.tblTimelog  WHERE EmployeeID=@iEmployeeID AND ([type]='break' or [type]='lunch')
				 AND EndTime is null AND CONVERT(VARCHAR,CONVERT(DATE,[Date],101))=CONVERT(VARCHAR,CONVERT(DATE,@dtCurrentDateTime,101)))
				BEGIN	
					SET @status=(select Type FROM AT2.tblTimelog  WHERE EmployeeID=@iEmployeeID AND ([type]='break' or [type]='lunch')
					AND EndTime is null AND CONVERT(VARCHAR,CONVERT(DATE,[Date],101))=CONVERT(VARCHAR,CONVERT(DATE,@dtCurrentDateTime,101)))
							if(@status='lunch')
								BEGIN
									set @retVal=-2
								END
							else
								BEGIN
									set @retVal=-3
								END					
				END
				ELSE
				BEGIN
						INSERT INTO AT2.tblTimelog ([Date],EmployeeID,StartTime,type) 
						VALUES (@dtCurrentDateTime,@iEmployeeID,@tInTime,@type)					
						set @retVal=@iEmployeeID
				END
		END
		ELSE
			BEGIN
				IF EXISTS(SELECT * FROM AT2.tblAttendance WHERE EmployeeID=@iEmployeeID AND
				ISNULL(InTime,'00:00:00.00000')!= '00:00:00.00000' AND ISNULL(OutTime,'00:00:00.00000')!= '00:00:00.00000'
				AND CONVERT(VARCHAR,CONVERT(DATE,Date,101))=CONVERT(VARCHAR,CONVERT(DATE,@dtCurrentDateTime,101)))		
						set @retVal=-5	
				ELSE
						set @retVal=-4
			END		

		END

		ELSE IF(@iMode=103)
		BEGIN
		--set @val=(SELECT TOP 1 id FROM AT2.tblBreaks ORDER BY Id DESC)
		IF EXISTS(SELECT * FROM AT2.tblAttendance WHERE EmployeeID=@iEmployeeID AND
			ISNULL(InTime,'00:00:00.00000')!= '00:00:00.00000' AND ISNULL(OutTime,'00:00:00.00000')= '00:00:00.00000'
			AND CONVERT(VARCHAR,CONVERT(DATE,Date,101))=CONVERT(VARCHAR,CONVERT(DATE,@dtCurrentDateTime,101)))			
			BEGIN
			IF EXISTS(select EndTime FROM AT2.tblTimelog WHERE EmployeeID=@iEmployeeID AND ([type]='break' or [type]='lunch') 
			AND EndTime IS NULL AND CONVERT(VARCHAR,CONVERT(DATE,[Date],101))=CONVERT(VARCHAR,CONVERT(DATE,@dtCurrentDateTime,101)))
					BEGIN	
						set @type1=(select Type FROM AT2.tblTimelog WHERE EmployeeID=@iEmployeeID AND ([type]='break' or [type]='lunch') 
						AND EndTime IS NULL AND CONVERT(VARCHAR,CONVERT(DATE,[Date],101))=CONVERT(VARCHAR,CONVERT(DATE,@dtCurrentDateTime,101)))

						update  AT2.tblTimelog set EndTime=@tInTime where EmployeeID=@iEmployeeID  AND ([type]='break' or [type]='lunch') 
						AND EndTime IS NULL AND CONVERT(VARCHAR,CONVERT(DATE,[Date],101))=CONVERT(VARCHAR,CONVERT(DATE,@dtCurrentDateTime,101))

						set @Res =(SELECT  TOP 1 CONVERT(INT, REPLACE(
									convert(char(5),dateadd(second,-datediff(second,EndTime,StartTime),'00:00:00'), 108),
									':','')) AS [IntVersion] from AT2.tblTimelog WHERE EmployeeId=@iEmployeeID  ORDER BY ID DESC)

							if(@Res!=0)
								BEGIN							
									set @retVal=@Res
								END
							else
								BEGIN							
									set @retVal=-3
								END									
					END
				ELSE
				BEGIN
					set @retVal=-1
				END
			END
			ELSE
			BEGIN
				IF EXISTS(SELECT * FROM AT2.tblAttendance WHERE EmployeeID=@iEmployeeID AND
				ISNULL(InTime,'00:00:00.00000')!= '00:00:00.00000' AND ISNULL(OutTime,'00:00:00.00000')!= '00:00:00.00000'
				AND CONVERT(VARCHAR,CONVERT(DATE,Date,101))=CONVERT(VARCHAR,CONVERT(DATE,@dtCurrentDateTime,101)))		
						set @retVal=-4	
				ELSE
						set @retVal=-5
			END
		END
	SELECT @retVal, @type1

	END
	

	

GO
/****** Object:  StoredProcedure [AT2].[USP_Bot_EH]    Script Date: 5/28/2019 6:15:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- [ATT].[USP_Bot_EF] @iMode=101, @iEmployeeID=3,@dtCurrentDateTime='05/28/2018'
CREATE PROCEDURE [AT2].[USP_Bot_EH](
@iMode INT=-1,
@iID INT=-1,
@iEmployeeID INT=-1,
@dtCurrentDateTime DATETIME='01/01/1900',
@dtPreviousDateTime DATETIME='01/01/1900',
@tInTime TIME='00:00',
@tOutTime time='00:00',
@dtCreatedDateTime DATETIME='01/01/1900',
@iSlackId NVARCHAR(250)=-1,	
@type NVARCHAR(10)=-1,	
@Res INT=-1,
@val INT=-1,
@status varchar(50)=null,
@retVal int=-1 output
)
AS 
BEGIN
	
	DECLARE @type1 varchar(10)='';	
	set @iEmployeeID=(select EmployeeID from AT2.tblEmployees where SlackId=@iSlackId)	
	IF(@iMode=101)
		BEGIN	
			
			IF EXISTS(SELECT * FROM AT2.tblAttendance WHERE EmployeeID=@iEmployeeID
		    AND ISNULL(InTime,'00:00:00.00000')!= '00:00:00.00000'
			AND((CONVERT(VARCHAR,CONVERT(DATE,[Date],101))=CONVERT(VARCHAR,CONVERT(DATE,@dtCurrentDateTime,101)))))
				BEGIN		
				IF EXISTS(SELECT * FROM AT2.tblAttendance WHERE EmployeeID=@iEmployeeID AND
				ISNULL(InTime,'00:00:00.00000')!= '00:00:00.00000' AND ISNULL(OutTime,'00:00:00.00000')!= '00:00:00.00000'
				AND((CONVERT(VARCHAR,CONVERT(DATE,[Date],101))=CONVERT(VARCHAR,CONVERT(DATE,@dtCurrentDateTime,101)))))
					BEGIN	
						IF NOT EXISTS(SELECT * FROM AT2.tblTimelog A WHERE A.EmployeeID=@iEmployeeID AND A.type='eh' 
							AND ((CONVERT(VARCHAR,CONVERT(DATE,[Date],101))=CONVERT(VARCHAR,CONVERT(DATE,@dtCurrentDateTime,101)))))
				
						BEGIN		
								INSERT INTO AT2.tblTimelog ([Date],EmployeeID,StartTime,type) 
								VALUES (@dtCurrentDateTime,@iEmployeeID,@tInTime,'eh')					
								set @retVal=@iEmployeeID
						END
						ELSE
						BEGIN				
								set @retVal=-1
						END
					ENd
				ELSE
					BEGIN
								set @retVal=-2
					END	
				END
			ELSE IF EXISTS(SELECT * FROM AT2.tblAttendance WHERE EmployeeID=@iEmployeeID AND
			ISNULL(InTime,'00:00:00.00000')!= '00:00:00.00000' AND ISNULL(OutTime,'00:00:00.00000')!= '00:00:00.00000'
			AND CONVERT(VARCHAR,CONVERT(DATE,[Date],101))=CONVERT(VARCHAR,CONVERT(DATE,@dtCurrentDateTime-1,101)))
				BEGIN	
					IF NOT EXISTS(SELECT * FROM AT2.tblTimelog A WHERE A.EmployeeID=@iEmployeeID AND A.type='eh' 
						AND ((CONVERT(VARCHAR,CONVERT(DATE,[Date],101))=CONVERT(VARCHAR,CONVERT(DATE,@dtCurrentDateTime,101)))))
				
					BEGIN		
							INSERT INTO AT2.tblTimelog ([Date],EmployeeID,StartTime,type) 
							VALUES (@dtCurrentDateTime,@iEmployeeID,@tInTime,'eh')					
							set @retVal=@iEmployeeID
					END
					ELSE
					BEGIN				
							set @retVal=-1
					END
				END
			ELSE
				BEGIN
							set @retVal=-2
				END	
		END	
								
		ELSE IF(@iMode=102)
		BEGIN
			IF EXISTS(select EndTime FROM AT2.tblTimelog WHERE EmployeeID=@iEmployeeID AND ([type]='eh') 
			AND EndTime IS NULL AND ((CONVERT(VARCHAR,CONVERT(DATE,[Date],101))=CONVERT(VARCHAR,CONVERT(DATE,@dtCurrentDateTime,101)))
			or CONVERT(VARCHAR,CONVERT(DATE,[Date],101))=CONVERT(VARCHAR,CONVERT(DATE,@dtCurrentDateTime-1,101))))
					BEGIN	
						set @val=(select id FROM AT2.tblTimelog WHERE EmployeeID=@iEmployeeID AND ([type]='eh') 
							AND EndTime IS NULL AND ((CONVERT(VARCHAR,CONVERT(DATE,[Date],101))=CONVERT(VARCHAR,CONVERT(DATE,@dtCurrentDateTime,101)))
							or CONVERT(VARCHAR,CONVERT(DATE,[Date],101))=CONVERT(VARCHAR,CONVERT(DATE,@dtCurrentDateTime-1,101))))
						
						update  AT2.tblTimelog set EndTime=@tInTime where id=@val
	
						set @Res =(SELECT   CONVERT(INT, REPLACE(
									convert(char(5),dateadd(second,-datediff(second,EndTime,StartTime),'00:00:00'), 108),
									':','')) AS [IntVersion] from AT2.tblTimelog WHERE id=@val)
						
						declare @EH time=(SELECT   convert(char(5),dateadd(second,-datediff(second,EndTime,StartTime),'00:00:00'), 108)
									 AS [IntVersion] from AT2.tblTimelog WHERE id=@val)
						
						update  AT2.tblAttendance set ExtraHrsWorked=@EH where EmployeeID=@iEmployeeID  and
						ISNULL(InTime,'00:00:00.00000')!= '00:00:00.00000' AND ISNULL(OutTime,'00:00:00.00000')!= '00:00:00.00000' and
						((CONVERT(VARCHAR,CONVERT(DATE,[Date],101))=CONVERT(VARCHAR,CONVERT(DATE,@dtCurrentDateTime,101)))
						or CONVERT(VARCHAR,CONVERT(DATE,[Date],101))=CONVERT(VARCHAR,CONVERT(DATE,@dtCurrentDateTime-1,101)))
							if(@Res!=0)
								BEGIN							
									set @retVal=@Res
								END
							else
								BEGIN							
									set @retVal=-3
								END									
					END
				ELSE
					BEGIN							
						IF EXISTS(select * FROM AT2.tblTimelog WHERE EmployeeID=@iEmployeeID AND ([type]='eh') AND
							ISNULL(StartTime,'00:00:00.00000')!= '00:00:00.00000' AND ISNULL(EndTime,'00:00:00.00000')!= '00:00:00.00000'
							 AND ((CONVERT(VARCHAR,CONVERT(DATE,[Date],101))=CONVERT(VARCHAR,CONVERT(DATE,getdate(),101)))
									or CONVERT(VARCHAR,CONVERT(DATE,[Date],101))=CONVERT(VARCHAR,CONVERT(DATE,getdate()-1,101))))
													set @retVal=-1
												else
													set @retVal=-4
					END
		END
			
	--SELECT @retVal, @type1

	END
	

	

GO
/****** Object:  StoredProcedure [AT2].[USP_Bot_PunchCard]    Script Date: 5/28/2019 6:15:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- [ATT].[USP_Bot_PunchCard] @dtCurrentDateTime='05/02/2019'
CREATE PROCEDURE [AT2].[USP_Bot_PunchCard](
@dtCurrentDateTime DATETIME='01/01/1900'
)
AS 
BEGIN
	DECLARE @CheckIns TABLE (Id INT, SlackId VARCHAR(50))
	DECLARE @CheckOuts TABLE (Id INT, SlackId VARCHAR(50))
	DECLARE @Breaks TABLE (Id INT, SlackId VARCHAR(50))

	INSERT INTO @CheckIns(Id, SlackId)
	SELECT DISTINCT C.EmployeeID, ISNULL(C.SlackId, C.FirstName)
	FROM AT2.tblAttendance A 
		INNER JOIN AT2.tblEmployees C ON A.EmployeeID=c.EmployeeId
			AND	ISNULL(A.InTime,'00:00:00.00000')!= '00:00:00.00000' 
			AND ISNULL(A.OutTime,'00:00:00.00000')= '00:00:00.00000'
			AND CONVERT(VARCHAR,CONVERT(DATE,A.Date,101))=CONVERT(VARCHAR,CONVERT(DATE,@dtCurrentDateTime,101))
		LEFT OUTER JOIN AT2.tblTimelog B ON C.EmployeeID=B.EmployeeId 
			AND CONVERT(VARCHAR,CONVERT(DATE,B.Date,101))=CONVERT(VARCHAR,CONVERT(DATE,@dtCurrentDateTime,101))
			AND ISNULL(B.StartTime,'00:00:00.00000')!= '00:00:00.00000' 
			AND ISNULL(B.EndTime,'00:00:00.00000')= '00:00:00.00000'
	WHERE B.Id IS NULL

	INSERT INTO @CheckOuts(Id, SlackId)
	SELECT DISTINCT C.EmployeeID, ISNULL(C.SlackId, C.FirstName)
	FROM AT2.tblAttendance A 
		INNER JOIN AT2.tblEmployees C ON A.EmployeeID=c.EmployeeId
	WHERE ISNULL(A.InTime,'00:00:00.00000')!= '00:00:00.00000' 
		AND ISNULL(A.OutTime,'00:00:00.00000')!= '00:00:00.00000'
		AND CONVERT(VARCHAR,CONVERT(DATE,A.Date,101))=CONVERT(VARCHAR,CONVERT(DATE,@dtCurrentDateTime,101))
	
	INSERT INTO @Breaks(Id, SlackId)
	SELECT DISTINCT C.EmployeeID, ISNULL(C.SlackId, C.FirstName)
	FROM AT2.tblTimelog A 
		INNER JOIN AT2.tblEmployees C ON A.EmployeeID=c.EmployeeId
		LEFT OUTER JOIN @CheckOuts B ON A.EmployeeId=B.Id
	WHERE ISNULL(A.StartTime,'00:00:00.00000')!= '00:00:00.00000' 
		AND ISNULL(A.EndTime,'00:00:00.00000')= '00:00:00.00000'
		AND CONVERT(VARCHAR,CONVERT(DATE,A.Date,101))=CONVERT(VARCHAR,CONVERT(DATE,@dtCurrentDateTime,101))
		AND B.Id IS NULL

	DECLARE @Ins VARCHAR(1000), @Outs VARCHAR(1000), @Break VARCHAR(1000)
	SET @Ins= (SELECT SlackId+',' FROM @CheckIns FOR XML PATH (''))
	SET @Outs=(SELECT SlackId+',' FROM @CheckOuts FOR XML PATH (''))
	SET @Break=(SELECT SlackId+',' FROM @Breaks FOR XML PATH (''))

	SELECT @Ins as ins, @Outs as outs, @Break as breaks
END


	

		

GO
/****** Object:  StoredProcedure [AT2].[USP_Bot_Timesheet]    Script Date: 5/28/2019 6:15:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- [ATT].[USP_Bot_Timesheet] @iMode=101, @iEmployeeID=54,@dtCurrentDateTime='05/02/2019'
CREATE PROCEDURE [AT2].[USP_Bot_Timesheet](
@iMode INT=-1,

@iEmployeeID INT=-1,
@dtCurrentDateTime DATETIME='01/01/1900',
@iSlackId NVARCHAR(250)=-1
)
AS 
BEGIN

	set @iEmployeeID=(select EmployeeID from AT2.tblEmployees where SlackId=@iSlackId)	
	IF(@iMode=101)
		BEGIN	
			select a.EmployeeID,b.Type,a.InTime ,a.OutTime,b.StartTime as [Out], b.EndTime as [In] 
			from AT2.tblAttendance a 
				left OUTER JOIN AT2.tblTimelog b on a.EmployeeID=b.EmployeeId
					and CONVERT(VARCHAR,CONVERT(DATE,b.[Date],101))=CONVERT(VARCHAR,CONVERT(DATE,@dtCurrentDateTime,101))
			where  CONVERT(VARCHAR,CONVERT(DATE,a.[Date],101))=CONVERT(VARCHAR,CONVERT(DATE,@dtCurrentDateTime,101))
				and A.EmployeeId=@iEmployeeID 
			Order by b.[StartTime] ASC
	end

	--IF(@iMode=102)
	--	BEGIN
	--	declare @dur int ;
	--	Declare @tot time;

	--		 if exists(select * from AT2.tblTimelog where ISNULL(StartTime,'00:00:00.00000')!= '00:00:00.00000'  and 
	--		  ISNULL(EndTIme,'00:00:00.00000')!= '00:00:00.00000'  and EmployeeId=@iEmployeeID and 
	--		  CONVERT(VARCHAR,CONVERT(DATE,[Date],101))=CONVERT(VARCHAR,CONVERT(DATE,getdate(),101)) )
	--		 begin 
	--			set  @dur= (select
	--			SUM(DATEDIFF(MINUTE, '00:00:00',
	--			CAST(DATEADD(SECOND, - DATEDIFF(SECOND, b.EndTime, b.StartTime), '00:00:00') AS Time)))
	--			from AT2.tblAttendance a
	--			left OUTER JOIN AT2.tblTimelog b on a.EmployeeID=b.EmployeeId
	--			and CONVERT(VARCHAR,CONVERT(DATE,b.[Date],101))=CONVERT(VARCHAR,CONVERT(DATE,@dtCurrentDateTime,101))
	--			where  CONVERT(VARCHAR,CONVERT(DATE,a.[Date],101))=CONVERT(VARCHAR,CONVERT(DATE,@dtCurrentDateTime,101))
	--			and A.EmployeeId=@iEmployeeID)
	--		end 

	--	if exists(select *  from AT2.tblAttendance where ISNULL(InTime,'00:00:00.00000')!= '00:00:00.00000' and  
	--		ISNULL(OutTime,'00:00:00.00000')!= '00:00:00.00000'and EmployeeID=@iEmployeeID and 
	--		CONVERT(VARCHAR,CONVERT(DATE,[Date],101))=CONVERT(VARCHAR,CONVERT(DATE,getdate(),101)))
	--		begin
	--			set @tot =(select distinct 
	--			convert(char(12),dateadd(second,-datediff(second,A.OutTime,A.InTime),'00:00:00'), 108)
	--			from AT2.tblAttendance a 
	--			left OUTER JOIN AT2.tblTimelog b on a.EmployeeID=b.EmployeeId
	--			and CONVERT(VARCHAR,CONVERT(DATE,b.[Date],101))=CONVERT(VARCHAR,CONVERT(DATE,@dtCurrentDateTime,101))
	--			where  CONVERT(VARCHAR,CONVERT(DATE,a.[Date],101))=CONVERT(VARCHAR,CONVERT(DATE,@dtCurrentDateTime,101))
	--			and A.EmployeeId=@iEmployeeID )
	--		end

	--		declare @t time = (select CASE WHEN
	--		@dur=0 THEN '0' ELSE ISNULL(RTRIM(@dur/60) + ':' +
	--		RIGHT('0' + RTRIM(@dur%60),2),'00:00:00') END )
		
	--		select (DATEADD(SECOND,  DATEDIFF(SECOND, @t, @tot), '00:00:00') ) 

	--	END
		
END
	




GO
/****** Object:  StoredProcedure [AT2].[USP_Bot_WFH]    Script Date: 5/28/2019 6:15:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- [ATT].[USP_GetAttendance] @iMode=104, @iEmployeeID=3,@dtCurrentDateTime='05/28/2018'
CREATE PROCEDURE [AT2].[USP_Bot_WFH](
@iMode INT=-1,
@iID INT=-1,
@iEmployeeID INT=-1,
@dtCurrentDateTime DATETIME='01/01/1900',
@dtPreviousDateTime DATETIME='01/01/1900',
@tInTime TIME='00:00',
@tOutTime time='00:00',
@iLeave INT=-1,
@vLeaveType  NVARCHAR(2)='-1',
@vWFH INT=-1,
@vCreatedBy NVARCHAR(50)='',
@dtCreatedDateTime DATETIME='01/01/1900',
@tPermission time=null,
@ExtraHrsWorked  time=null,
@val Int=-1,
@iSlackId NVARCHAR(250)=-1,	
@retVal int=-1 OUTPUT
)
AS 
BEGIN
 IF(@iMode=101)
		BEGIN				
		set @val=(select EmployeeID from AT2.tblEmployees where SlackId=@iSlackId)	
			IF NOT EXISTS(SELECT * FROM AT2.tblAttendance A WHERE A.EmployeeID=@val AND CONVERT(VARCHAR,CONVERT(DATE,A.Date,101))=CONVERT(VARCHAR,CONVERT(DATE,@dtCurrentDateTime,101)))
			BEGIN
					IF(@tInTime!='00:00:00.00000')
					BEGIN
					INSERT INTO AT2.tblAttendance ([Date],EmployeeID,InTime,Leave,LeaveType,PermissionHrs,WorkFromHome,CreatedBy,CreatedDateTime) 
								VALUES (@dtCurrentDateTime,@val,@tInTime,NULL,NULL,NULL,2,@val,getdate())					
						 set @retVal=2	
					END
			END			
			ELSE 	
			BEGIN
			declare @wfhval int=(SELECT WorkFromHome FROM AT2.tblAttendance A WHERE A.EmployeeID=@val
			 AND CONVERT(VARCHAR,CONVERT(DATE,A.Date,101))=CONVERT(VARCHAR,CONVERT(DATE,@dtCurrentDateTime,101)))	
			 IF(@wfhval=2)
			 BEGIN		
					IF EXISTS(SELECT OutTime FROM AT2.tblAttendance A WHERE A.EmployeeID=@val and ( OutTime= '00:00:00.00000' or OutTime is null)
					 AND CONVERT(VARCHAR,CONVERT(DATE,A.Date,101))=CONVERT(VARCHAR,CONVERT(DATE,@dtCurrentDateTime,101)) )
						BEGIN
							UPDATE AT2.tblAttendance SET OutTime=@tOutTime
		 						WHERE EmployeeID=@val AND CONVERT(VARCHAR,CONVERT(DATE,Date,101))=CONVERT(VARCHAR,CONVERT(DATE,@dtCurrentDateTime,101))
								DECLARE @Res INT=((SELECT   CONVERT(INT, REPLACE(
														convert(char(5),dateadd(second,-datediff(second,outtime,intime),'00:00:00'), 108),
														':',
														''
													)
												) AS [IntVersion] 
												from AT2.tblAttendance
								where EmployeeID=@val AND CONVERT(VARCHAR,CONVERT(DATE,Date,101))=CONVERT(VARCHAR,CONVERT(DATE,@dtCurrentDateTime,101))))
								if(@Res!=0)
								Begin							
									set @retVal=@Res
								end
								else
								Begin							
									set @retVal=-2
								end

						END
					  ELSE
						BEGIN
							IF EXISTS(SELECT * FROM AT2.tblAttendance WHERE EmployeeID=@val AND
							ISNULL(InTime,'00:00:00.00000')!= '00:00:00.00000' AND ISNULL(OutTime,'00:00:00.00000')!= '00:00:00.00000'
							AND (CONVERT(VARCHAR,CONVERT(DATE,[Date],101))=CONVERT(VARCHAR,CONVERT(DATE,@dtCurrentDateTime,101))))
										set @retVal=-4
							ELSE
										set @retVal=-1
						END
					END
					ELSE
						BEGIN
							set @retVal=-3
						END

			END

			END
		
 END


GO
/****** Object:  StoredProcedure [AT2].[USP_GetAnniversary]    Script Date: 5/28/2019 6:15:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [AT2].[USP_GetAnniversary]
(
	@iMode INT = -1	,
	@Date date='01/01/1900',
	@vEmployeeIDs VARCHAR(100)='-1'
)
AS
BEGIN
	IF(@iMode = 100)
	BEGIN	
		select FirstName,SlackId,
			CASE 
				WHEN
					((DATEPART(m,DOB)=DATEPART(m, @Date)and DATEPART(d, DOB) = DATEPART(d, @Date))   and (DATEPART(YYYY ,DOB)<DATEPART(YYYY, @Date)))
					THEN 1 
					ELSE 0 
					END AS ISDOB
					,
					CASE
					WHEN 
					((DATEPART(m, DOA)=DATEPART(m, @Date)and DATEPART(d, DOA) = DATEPART(d, @Date))  and (DATEPART(YYYY ,DOA)<DATEPART(YYYY, @Date))) 
					 THEN 1 
					 ELSE 0
					END AS ISDOA
					,
					CASE
					WHEN 
					((DATEPART(m, DOJ)=DATEPART(m, @Date)and DATEPART(d, DOJ) = DATEPART(d, @Date)) and (DATEPART(YYYY ,DOJ)<DATEPART(YYYY, @Date))) 
					THEN 1 
					ELSE 0
			END	AS ISDOJ
	from AT2.tblEmployees 
	where 
	 	(DATEPART(m, DOB)=DATEPART(m, @Date)and DATEPART(d, DOB) = DATEPART(d, @Date) and (DATEPART(YYYY ,DOB)<DATEPART(YYYY, @Date))) 
		 or (DATEPART(m, DOA)=DATEPART(m, @Date)and DATEPART(d, DOA) = DATEPART(d, @Date)  and (DATEPART(YYYY ,DOA)<DATEPART(YYYY, @Date))) 
		 or (DATEPART(m, DOJ)=DATEPART(m, @Date)and DATEPART(d, DOJ) = DATEPART(d, @Date) and (DATEPART(YYYY ,DOJ)<DATEPART(YYYY, @Date))) and IsActive=1
		 order by FirstName
	END
	ELSE IF(@iMode = 101)
	BEGIN	
	
	SET @Date=DATEADD(dd,-1,GETDATE())
				(SELECT E.EmployeeID,E.FirstName+' '+ E.LastName AS EmployeeName,1 as type,SlackId
					FROM AT2.tblEmployees E LEFT OUTER JOIN AT2.tblAttendance A ON E.EmployeeID=A.EmployeeID  AND CAST(CONVERT(VARCHAR,A.[DATE],101) AS DATETIME) = CAST(CONVERT(VARCHAR,getdate(),101) AS DATETIME) 
					WHERE (A.ID IS NULL OR ( A.ID IS NOT NULL
					 AND				
						(CAST(ISNULL(A.InTime,'00:00:00') AS TIME) ='00:00:00')))
						AND (''='' OR (''!='' AND E.EmployeeID IN (SELECT ISNULL(DATA,0) FROM DBO.SPLIT('',','))))
						AND EXISTS (SELECT TOP 1 Id FROM AT2.tblAttendance C WHERE CAST(CONVERT(VARCHAR,C.[DATE],101) AS DATETIME) = CAST(CONVERT(VARCHAR,getdate(),101) AS DATETIME))
						 AND  DATENAME(DW,GETDATE()) NOT IN ('Saturday','Sunday') AND E.IsActive=1 
					)

				UNION ALL
				(SELECT E.EmployeeID,E.FirstName+' '+ E.LastName AS EmployeeName,2 as type,SlackId
					FROM AT2.tblEmployees E LEFT OUTER JOIN AT2.tblAttendance A ON E.EmployeeID=A.EmployeeID  AND CAST(CONVERT(VARCHAR,A.[DATE],101) AS DATETIME) = CAST(CONVERT(VARCHAR,@Date,101) AS DATETIME) 
					WHERE (A.ID IS NULL OR ( A.ID IS NOT NULL
					 AND				
						(CAST(ISNULL(A.OutTime,'00:00:00') AS TIME) ='00:00:00')))
						AND (''='' OR (''!='' AND E.EmployeeID IN (SELECT ISNULL(DATA,0) FROM DBO.SPLIT('',','))))
						AND EXISTS (SELECT TOP 1 Id FROM AT2.tblAttendance C WHERE CAST(CONVERT(VARCHAR,C.[DATE],101) AS DATETIME) = CAST(CONVERT(VARCHAR,@Date,101) AS DATETIME))
						 AND  DATENAME(DW,@Date) NOT IN ('Saturday','Sunday') AND E.IsActive=1 
				)order by type

	END
END



	

GO
/****** Object:  StoredProcedure [AT2].[USP_GetAttendance]    Script Date: 5/28/2019 6:15:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- [ATT].[USP_GetAttendance] @iMode=104, @iEmployeeID=3,@dtCurrentDateTime='05/28/2018'
CREATE PROCEDURE [AT2].[USP_GetAttendance](
@iMode INT=-1,
@iID INT=-1,
@iEmployeeID INT=-1,
@dtCurrentDateTime DATETIME='01/01/1900',
@dtPreviousDateTime DATETIME='01/01/1900',
@tInTime TIME='00:00',
@tOutTime time='00:00',
@iLeave INT=-1,
@vLeaveType  NVARCHAR(2)='-1',
@vWFH INT=-1,
@vCreatedBy NVARCHAR(50)='',
@vCallQuality NVARCHAR(100)='',
@vComment NVARCHAR(1000)='',
@dtCreatedDateTime DATETIME='01/01/1900',
@tPermission time=null,
@ExtraHrsWorked  time=null,
@val Int=-1,
@iSlackId NVARCHAR(250)=-1,	
@retVal int=-1 output
)
AS 
BEGIN
IF(@iMode=101)
	BEGIN
		SELECT E.EmployeeID,ISNULL(E.FirstName,'') +' '+ E.LastName AS EmployeeName,D.Designation,ISNULL(A.ID,-1) AS [ID]
			,CONVERT(VARCHAR(15),CAST(ISNULL(A.InTime,'00:00:00') AS Time),100) AS [InTime]
			,CONVERT(VARCHAR(15),CAST(ISNULL(A.OutTime,'00:00:00') AS Time),100) AS [OutTime]
			,ISNULL(A.Leave,-1) as [Leave],ISNULL(A.LeaveType,-1) as [LeaveType]
			,CONVERT(VARCHAR(5),CAST(ISNULL(A.PermissionHrs,'00:00')AS TIME))AS [PermissionHrs]
			,CONVERT(VARCHAR(5),CAST(ISNULL(A.ExtraHrsWorked,'00:00')AS TIME))AS [ExtraHrsWorked]
			--,FORMAT(CAST(ISNULL(A.PermissionHrs,'00:00') AS DATETIME), 'hh:mm') AS [PermissionHrs]
			--,FORMAT(CAST(ISNULL(A.ExtraHrsWorked,'00:00') AS DATETIME), 'hh:mm') AS [ExtraHrsWorked]
			,ISNULL(A.WorkFromHome,-1) as WFH, ExtraHrsWorked
		FROM AT2.tblEmployees E 
			INNER JOIN AT2.tblDesignations D ON E.DesignationID=D.DesignationID
			LEFT OUTER JOIN AT2.tblAttendance A ON E.EmployeeID=A.EmployeeID 
				AND CONVERT(VARCHAR,CONVERT(DATE,A.Date,101))=CONVERT(VARCHAR,CONVERT(DATE,@dtCurrentDateTime,101))
		WHERE ISNULL(E.IsActive,0)=1
		ORDER BY E.[Order] ASC
		
	END 
ELSE IF(@iMode=102)
	BEGIN
	  IF NOT EXISTS (SELECT * FROM AT2.tblAttendance A WHERE A.EmployeeID=@iEmployeeID  AND CONVERT(VARCHAR,CONVERT(DATE,A.Date,101))=CONVERT(VARCHAR,CONVERT(DATE,@dtCurrentDateTime,101)))
		BEGIN
			INSERT INTO AT2.tblAttendance (Date,EmployeeID,InTime,OutTime,Leave,LeaveType,PermissionHrs,CreatedBy,CreatedDateTime,WorkFromHome,ExtraHrsWorked) 
			VALUES (@dtCurrentDateTime,@iEmployeeID,@tInTime,@tOutTime,@iLeave,@vLeaveType,@tPermission,@vCreatedBy,@dtCreatedDateTime,@vWFH,@ExtraHrsWorked)
			
			 				
		END
	ELSE  IF EXISTS (SELECT * FROM AT2.tblAttendance A WHERE A.EmployeeID=@iEmployeeID  AND CONVERT(VARCHAR,CONVERT(DATE,A.Date,101))=CONVERT(VARCHAR,CONVERT(DATE,@dtCurrentDateTime,101)))	
		BEGIN
			UPDATE AT2.tblAttendance SET InTime=@tInTime,OutTime=@tOutTime,WorkFromHome=@vWFH,ExtraHrsWorked=@ExtraHrsWorked,
									Leave=@iLeave,LeaveType=@vLeaveType, PermissionHrs=@tPermission,CreatedBy=@vCreatedBy,CreatedDateTime=@dtCreatedDateTime				
				WHERE EmployeeID=@iEmployeeID 
				AND CONVERT(VARCHAR,CONVERT(DATE,Date,101))=CONVERT(VARCHAR,CONVERT(DATE,@dtCurrentDateTime,101))
		
		END
		
	END
ELSE IF(@iMode=103)
	BEGIN
		UPDATE AT2.tblAttendance SET Date=@dtCurrentDateTime,InTime=@tInTime,OutTime=@tOutTime,
									Leave=@iLeave,LeaveType=@vLeaveType,CreatedBy=@vCreatedBy,CreatedDateTime=@dtCreatedDateTime				
				WHERE ID=@iID AND EmployeeID=@iEmployeeID
	END
ELSE IF(@iMode=104)
	BEGIN
	  SELECT ID
      ,[Date]
      ,EmployeeID
	,FORMAT(CAST(InTime AS DATETIME), 'hh:mm tt') InTime
           ,FORMAT(CAST(OutTime AS DATETIME), 'hh:mm tt') OutTime
    --  ,InTime
      --,OutTime
      ,Leave
      ,LeaveType
	  ,FORMAT(CAST(PermissionHrs AS DATETIME), 'hh:mm:ss') PermissionHrs
      --,PermissionHrs
      ,[CreatedBy]
      ,[CreatedDateTime] 
      FROM AT2.tblAttendance 
      WHERE EmployeeID=@iEmployeeID AND DATEPART(d, Date)=DATEPART(d, @dtCurrentDateTime) 
			AND DATEPART(m, Date)=DATEPART(m, @dtCurrentDateTime) AND DATEPART(yy, Date)=DATEPART(yy, @dtCurrentDateTime)
	  ORDER BY [Date] DESC
     
	  


	END

	ELSE IF(@iMode=105)
	BEGIN
	  IF NOT EXISTS(SELECT * FROM AT2.tblAttendance A WHERE A.EmployeeID=@iEmployeeID AND CONVERT(VARCHAR,CONVERT(DATE,A.Date,101))=CONVERT(VARCHAR,CONVERT(DATE,@dtCurrentDateTime,101)))
		BEGIN
			INSERT INTO AT2.tblAttendance ([Date],EmployeeID,InTime,OutTime,Leave,LeaveType,PermissionHrs,CreatedBy,CreatedDateTime) 
					VALUES (@dtCurrentDateTime,@iEmployeeID,@tInTime,NULL,NULL,NULL,NULL,@vCreatedBy,@dtCreatedDateTime)
		END
		ELSE IF EXISTS (SELECT * FROM AT2.tblAttendance A WHERE A.EmployeeID=@iEmployeeID  AND CONVERT(VARCHAR,CONVERT(DATE,A.Date,101))=CONVERT(VARCHAR,CONVERT(DATE,@dtCurrentDateTime,101)) AND (InTime is null or InTime='00:00:00.00000'))	
		BEGIN
			UPDATE AT2.tblAttendance SET InTime=@tInTime
		 	 WHERE EmployeeID=@iEmployeeID AND CONVERT(VARCHAR,CONVERT(DATE,Date,101))=CONVERT(VARCHAR,CONVERT(DATE,@dtCurrentDateTime,101))
		END
		ELSE IF EXISTS (SELECT * FROM AT2.tblAttendance A WHERE A.EmployeeID=@iEmployeeID  AND CONVERT(VARCHAR,CONVERT(DATE,A.Date,101))=CONVERT(VARCHAR,CONVERT(DATE,@dtCurrentDateTime,101)) AND (OutTime is null or OutTime='00:00:00.00000'))	
		BEGIN

			UPDATE AT2.tblAttendance SET OutTime=@tInTime
		 	 WHERE EmployeeID=@iEmployeeID AND CONVERT(VARCHAR,CONVERT(DATE,Date,101))=CONVERT(VARCHAR,CONVERT(DATE,@dtCurrentDateTime,101))
		END
			set @retVal=@iEmployeeID
	END

	ELSE IF(@iMode=106)
	BEGIN
	 IF EXISTS (SELECT * FROM AT2.tblAttendance A WHERE A.EmployeeID=@iEmployeeID  AND CONVERT(VARCHAR,CONVERT(DATE,A.Date,101))=CONVERT(VARCHAR,CONVERT(DATE,@dtPreviousDateTime,101)))	
	 BEGIN
	   UPDATE AT2.tblAttendance SET OutTime=@tInTime
		 	 WHERE EmployeeID=@iEmployeeID AND CONVERT(VARCHAR,CONVERT(DATE,Date,101))=CONVERT(VARCHAR,CONVERT(DATE,@dtPreviousDateTime,101))
			 
	 END
	 set @retVal=1	  
	END

	ELSE IF(@iMode=107)
	BEGIN
	print ''
	--   IF NOT EXISTS (SELECT * FROM AT2.tblCallQuality A WHERE A.EmployeeID=@iEmployeeID AND CONVERT(VARCHAR,CONVERT(DATE,A.Date,101))=CONVERT(VARCHAR,CONVERT(DATE,@dtCurrentDateTime,101)))
	--	BEGIN
	--		INSERT INTO AT2.tblCallQuality (EmployeeID,[Date],CallQuality,Comment) 
	--				VALUES (@iEmployeeID,@dtCurrentDateTime,@vCallQuality,@vComment)
	--	END
	--ELSE  IF EXISTS (SELECT * FROM AT2.tblCallQuality A WHERE A.EmployeeID=@iEmployeeID AND CONVERT(VARCHAR,CONVERT(DATE,A.Date,101))=CONVERT(VARCHAR,CONVERT(DATE,@dtCurrentDateTime,101)))	
	--	BEGIN
	--		UPDATE AT2.tblCallQuality SET [Date]=@dtCurrentDateTime,CallQuality=@vCallQuality,Comment=@vComment
	--	 	 WHERE EmployeeID=@iEmployeeID AND CONVERT(VARCHAR,CONVERT(DATE,Date,101))=CONVERT(VARCHAR,CONVERT(DATE,@dtCurrentDateTime,101))
	--	END
	END

	else if(@iMode=108)
	begin
		select e.EmployeeID, E.firstName+' '+LastName as EmployeeName 
			,CONVERT(VARCHAR(15),CAST(ISNULL(A.InTime,'00:00:00') AS TIME),100) AS [InTime]
			,CONVERT(VARCHAR(15),CAST(ISNULL(A.OutTime,'00:00:00') AS TIME),100) AS [OutTime]
			,ISNULL(A.Leave,-1) as [Leave],ISNULL(A.LeaveType,'-1') as [LeaveType]
			,CONVERT(VARCHAR(5),CAST(ISNULL(A.PermissionHrs,'00:00')AS TIME),100)AS [PermissionHrs]
				,ISNULL(A.WorkFromHome,-1) as WFH
		FROM AT2.tblEmployees E 
			INNER JOIN AT2.tblDesignations D ON E.DesignationID=D.DesignationID
			LEFT OUTER JOIN AT2.tblAttendance A ON E.EmployeeID=A.EmployeeID 
			AND CONVERT(VARCHAR,CONVERT(DATE,A.Date,101))=CONVERT(VARCHAR,CONVERT(DATE,@dtCurrentDateTime,101))
		WHERE ISNULL(E.IsActive,0)=1
		ORDER BY E.[Order] ASC
	end

	else if(@iMode=109)
	begin
	SELECT  ID
      ,[Date] as CurrentDateTime
      ,EmployeeID
	  ,FORMAT(CAST(InTime AS DATETIME), 'hh:mm tt') InTime  
	 , FORMAT(CAST(OutTime AS DATETIME), 'hh:mm tt') OutTime    
      --,InTime
     -- ,OutTime
      ,Leave
      ,LeaveType
	  ,FORMAT(CAST(PermissionHrs AS DATETIME), 'hh:mm:ss') PermissionHrs
      --,PermissionHrs
      ,[CreatedBy]
      ,[CreatedDateTime] 
      FROM AT2.tblAttendance 
      WHERE EmployeeID=@iEmployeeID 
		AND (DATEPART(d, [DATE])<DATEPART(d, @dtCurrentDateTime) 
				OR DATEPART(m, [DATE])<DATEPART(m, @dtCurrentDateTime) 
				OR DATEPART(yy, [DATE])<DATEPART(yy, @dtCurrentDateTime))
		AND [DATE]>=DATEADD(d,-90,@dtCurrentDateTime)  -- Will check only for last 90 days
		AND (OutTime IS NULL or OutTime='12:00 AM' )
	  ORDER BY [Date] DESC
	  end	 
	 -- 	ELSE IF(@iMode=110)
		--BEGIN				
		--set @val=(select EmployeeID from AT2.tblEmployees where SlackId=@iSlackId)	
		--IF NOT EXISTS(SELECT * FROM AT2.tblAttendance A WHERE A.EmployeeID=@val AND CONVERT(VARCHAR,CONVERT(DATE,A.Date,101))=CONVERT(VARCHAR,CONVERT(DATE,@dtCurrentDateTime,101)))
		--BEGIN
		--		IF(@tInTime!='00:00:00.00000')
		--		BEGIN
		--		INSERT INTO AT2.tblAttendance ([Date],EmployeeID,InTime,OutTime,Leave,LeaveType,PermissionHrs,CreatedBy,CreatedDateTime) 
		--					VALUES (@dtCurrentDateTime,@val,@tInTime,NULL,NULL,NULL,NULL,@val,getdate())					
		--			 set @retVal=@val	
		--		END
		--	END			
		--	ELSE 			
		--		IF NOT EXISTS(SELECT OutTime FROM AT2.tblAttendance A WHERE A.EmployeeID=@val and OutTime not in ('00:00:00.00000') AND CONVERT(VARCHAR,CONVERT(DATE,A.Date,101))=CONVERT(VARCHAR,CONVERT(DATE,@dtCurrentDateTime,101)))
		--			BEGIN
		--				UPDATE AT2.tblAttendance SET OutTime=@tOutTime
		-- 				 WHERE EmployeeID=@val AND CONVERT(VARCHAR,CONVERT(DATE,Date,101))=CONVERT(VARCHAR,CONVERT(DATE,@dtCurrentDateTime,101))
		--				 if((SELECT   CONVERT(INT, REPLACE(
		--											convert(char(5),dateadd(second,-datediff(second,outtime,intime),'00:00:00'), 108),
		--										   ':',
		--										   ''
		--										)
		--								  ) AS [IntVersion] 
		--								  from AT2.tblAttendance
		--					where EmployeeID=53 AND CONVERT(VARCHAR,CONVERT(DATE,Date,101))=CONVERT(VARCHAR,CONVERT(DATE,GETDATE(),101)))!=0)
		--					Begin							
		--				set @retVal=(SELECT   CONVERT(INT, REPLACE(
		--											convert(char(5),dateadd(second,-datediff(second,outtime,intime),'00:00:00'), 108),
		--										   ':',
		--										   ''
		--										)
		--								  ) AS [IntVersion] 
		--								  from AT2.tblAttendance
		--					where EmployeeID=53 AND CONVERT(VARCHAR,CONVERT(DATE,Date,101))=CONVERT(VARCHAR,CONVERT(DATE,GETDATE(),101)))
		--					end
		--					else
		--					Begin							
		--						set @retVal=-2
		--					end

		--			END
		--		ELSE
		--		BEGIN
		--			set @retVal=-1	
		--		END
		--END
			ELSE IF(@iMode=110)
		BEGIN				
				
	
	declare  @Date datetime=DATEADD(dd,-1,GETDATE())
				SELECT E.EmployeeID,E.FirstName+' '+ E.LastName AS EmployeeName,SlackId
					FROM AT2.tblEmployees E 
						LEFT OUTER JOIN AT2.tblAttendance A ON E.EmployeeID=A.EmployeeID  
							AND CAST(CONVERT(VARCHAR,A.[DATE],101) AS DATETIME) = CAST(CONVERT(VARCHAR,getdate(),101) AS DATETIME) 
					WHERE (A.ID IS NULL OR ( A.ID IS NOT NULL
					 AND				
						(CAST(ISNULL(A.InTime,'00:00:00') AS TIME) ='00:00:00')))
						--AND (''='' OR (''!='' AND E.EmployeeID IN (SELECT ISNULL(DATA,0) FROM DBO.SPLIT('',','))))
						AND E.EmployeeID IN (50,53,54)
						AND EXISTS (SELECT TOP 1 Id FROM AT2.tblAttendance C WHERE CAST(CONVERT(VARCHAR,C.[DATE],101) AS DATETIME) = CAST(CONVERT(VARCHAR,getdate(),101) AS DATETIME))
						 AND  DATENAME(DW,@dtCurrentDateTime) NOT IN ('Saturday','Sunday') AND E.IsActive=1 
					
		end
 END


GO
/****** Object:  StoredProcedure [AT2].[USP_GetDailyReport]    Script Date: 5/28/2019 6:15:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--[ATT].[USP_GetDailyReport] '03/26/2019','04/17/2019'
CREATE PROC [AT2].[USP_GetDailyReport]
(
@dtFromDate DATETIME='01/01/1900'
,@dtToDate DATETIME='01/01/1900'
,@vEmployeeIDs VARCHAR(100)=''
)
AS
BEGIN
	DECLARE @DailyReport TABLE
	(
	--EmpID INT
	[Date] Varchar(20)
	,EmployeeName Varchar(2000)
	,InTime Varchar(20)
	,OutTime Varchar(20)	
	,PermissionHrs Varchar(20)
	,ExtraHrsWorked Varchar(20)
	,Duration int	
	,Permission int
	,LeaveType Varchar(20)
	,Leave Varchar(20)
	,WorkFromHome Varchar(20)
	
	)
		
	INSERT INTO @DailyReport([Date],EmployeeName,InTime,OutTime,PermissionHrs,ExtraHrsWorked,Duration,Permission,LeaveType,Leave,WorkFromHome)
	SELECT CONVERT(VARCHAR,A.[Date],101) AS [Date]
	,ISNULL(E.FirstName,'')+' '+ISNULL(E.LastName,'') AS EmployeeName 
	,LEFT(ISNULL(A.InTime,''),5) AS InTime
	,LEFT(ISNULL(A.OutTime,''),5) AS OutTime
	,LEFT(ISNULL(A.PermissionHrs,''),5) AS PermissionHrs 
	,LEFT(ISNULL(A.ExtraHrsWorked,''),5) ExtraHrsWorked
	,-(DATEDIFF(SECOND, OutTime, InTime)) + DATEDIFF(SECOND, '00:00:00', ISNULL(ExtraHrsWorked,'00:00:00')) Duration
    ,DATEDIFF(SECOND, '00:00:00', ISNULL(PermissionHrs,'00:00:00')) Permission
	,CASE WHEN A.LeaveType=1 THEN 'Paid Leave'
		WHEN A.LeaveType=2 THEN 'Sick Leave'
		WHEN A.LeaveType=3 THEN 'Marriage Leave'
		WHEN A.LeaveType=4 THEN 'COFF'
		ELSE '' END AS LeaveType
	,CASE WHEN A.Leave=1 THEN 'Half Day' 
		WHEN A.Leave=2 THEN 'Full Day'
		ELSE '' END AS Leave
	,CASE WHEN A.WorkFromHome=1 THEN 'Half Day' 
		WHEN A.WorkFromHome=2 THEN 'Full Day'
		ELSE '' END AS WorkFromHome	
	FROM AT2.tblAttendance A
		INNER JOIN AT2.tblEmployees E ON A.EmployeeID=E.EmployeeID
	WHERE CAST(CONVERT(VARCHAR,[DATE],101) AS DATETIME) BETWEEN CAST(CONVERT(VARCHAR,@dtFromDate,101) AS DATETIME) 
			AND CAST(CONVERT(VARCHAR,@dtToDate,101) AS DATETIME)
		AND (@vEmployeeIDs='' OR (@vEmployeeIDs!='' AND A.EmployeeID IN (SELECT ISNULL(DATA,0) FROM DBO.SPLIT(@vEmployeeIDs,','))))
		--And E.IsActive=1
	
		--=CASE WHEN @iEmployeeID=-1 THEN A.EmployeeID ELSE @iEmployeeID END	 
		--AND ISNULL(E.IsActive,0)=1
	

	select [Date],EmployeeName,InTime,OutTime
	--, Permission
	--, Duration
	,CASE WHEN OutTime='00:00' or OutTime IS NULL THEN '00:00'
		  WHEN Permission=0 THEN CONVERT(VARCHAR(5),DATEADD(SECOND, Duration, '00:00:00'),108)
		  WHEN (Permission>Duration) THEN '-'+CONVERT(VARCHAR(5),DATEADD(SECOND, Permission- Duration, '00:00:00'),108)
		  ELSE CONVERT(VARCHAR(5),DATEADD(SECOND, Duration -Permission, '00:00:00'),108)
	 END  Duration ,PermissionHrs,ExtraHrsWorked,LeaveType,Leave,WorkFromHome 
	FROM @DailyReport
	ORDER BY [Date]

END


GO
/****** Object:  StoredProcedure [AT2].[USP_GetEmployees]    Script Date: 5/28/2019 6:15:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROC [AT2].[USP_GetEmployees]
(
@iMode INT=-1,
@iEmpID INT=NULL,
@nFirstName NVARCHAR(200)=NULL,
@nEmpDig NVARCHAR(50)=NULL,
@iMapleID  NVARCHAR(50)=NULL,
@nEmpMob NVARCHAR(10)=NULL,
@nEmpMail NVARCHAR(50)=NULL,
@IsAdmin BIT=0,
@IsActive BIT=1,
@dtActiveDate DATETIME='01/01/1900',
@nUserid NVARCHAR(50)=NULL,
@nPassword NVARCHAR(200)=NULL,
@vOldPassword NVARCHAR(200)=NULL,
@iRetVal INT=-1 OUTPUT,
@iEmpDigID INT=NULL,
@nLastName NVARCHAR(50)=NULL,
@iEmpBiometricID NVARCHAR(50)=NULL,
@iEmpDepartmentID INT=NULL,
@nEmpPersonalEmail NVARCHAR(50)=NULL,
@nEmpGender INT=0,
@nEmpDOB date='01/01/1900',
@nEmpDOJ date='01/01/1900',
@nEmpMaritalStatus bit=0,
@nEmpDOA date='01/01/1900',
@nEmpBloodGroup NVARCHAR(2)=NULL,
@nEmpEmergencyContactPerson  NVARCHAR(100)=NULL,
@nEmpEmergencyContactRelation  NVARCHAR(50)=NULL,
@nEmpEmergencyContactNumber  NVARCHAR(50)=NULL,
@nSlackId  NVARCHAR(250)=NULL
)
AS
BEGIN

IF(@iMode=101)
BEGIN
	SELECT EmployeeID, FirstName AS Name,DesignationID,Mobile,WorkEmail AS Email,IsActive,IsAdmin
		FROM AT2.tblEmployees   WHERE ISNULL(IsActive,0)=1
	ORDER BY [Order] ASC
END
ELSE IF(@iMode=102)
BEGIN

	SELECT  FirstName,LastName,BiometricID,E.DepartmentID,Dept.Department,E.DesignationID,D.Designation,WorkEmail AS Email,PersonalEmail,MapleID,
SlackId,Mobile,Gender,DOB,
CONVERT(DATE,DOJ,101) as DOJ,MaritalStatus,DOA,BloodGroup,EmergencyContactPerson,EmergencyContactRelation,
EmergencyContactNumber,E.IsActive,IsAdmin,UserID FROM AT2.tblEmployees E INNER JOIN AT2.tblDesignations D ON E.DesignationID=D.DesignationID 
INNER JOIN AT2.tblDepartments Dept ON E.DepartmentID=Dept.DepartmentId
 WHERE EmployeeID=@iEmpID ORDER BY [Order] ASC

	--SELECT FirstName AS Name,DesignationID,Mobile,WorkEmail AS Email,IsAdmin,UserID
	-- FROM AT2.tblEmployees WHERE EmployeeID=@iEmpID
END
ELSE IF(@iMode=103)
BEGIN
	UPDATE AT2.tblEmployees SET IsActive=(1^IsActive),ActivatedDate=@dtActiveDate
	WHERE EmployeeID=@iEmpID 
END
ELSE IF(@iMode=104)
BEGIN
	UPDATE AT2.tblEmployees SET FirstName=@nFirstName,LastName=@nLastName,BiometricID=@iEmpBiometricID,DOJ=@nEmpDOJ,DesignationID=@iEmpDigID,DepartmentID=@iEmpDepartmentID,MapleID=@iMapleID,
	Mobile=@nEmpMob,WorkEmail=@nEmpMail,PersonalEmail=@nEmpPersonalEmail,DOB=@nEmpDOB,Gender=@nEmpGender,MaritalStatus=@nEmpMaritalStatus,
	DOA=@nEmpDOA,BloodGroup=@nEmpBloodGroup,EmergencyContactPerson=@nEmpEmergencyContactPerson,EmergencyContactRelation=@nEmpEmergencyContactRelation,
	EmergencyContactNumber=@nEmpEmergencyContactNumber,IsProfileUpdated=1,SlackId=@nSlackId
	WHERE EmployeeID=@iEmpID
	SET @iRetVal = 104;

END
ELSE IF(@iMode=105)
BEGIN
	--IF NOT EXISTS(SELECT UserID FROM AT2.tblEmployees WHERE UserID = @nUserid)
	--BEGIN
		--DECLARE  @iOrder INT
		--SELECT @iOrder=MAX([Order])+1 FROM AT2.tblEmployees 
		--INSERT INTO AT2.tblEmployees (FirstName,DesignationID,Mobile,WorkEmail,UserID,[Password]
		--	,IsAdmin,IsActive,ActivatedDate,[Order])
			IF  EXISTS(SELECT UserID FROM AT2.tblEmployees WHERE MapleID = @iMapleID )
			BEGIN
			 SET @iRetVal = 2;
			END
			ELSE IF  EXISTS(SELECT UserID FROM AT2.tblEmployees WHERE BiometricID = @iEmpBiometricID )
			BEGIN
			 SET @iRetVal = 3;
			END
			ELSE IF NOT EXISTS(SELECT UserID FROM AT2.tblEmployees WHERE UserID = @nUserid)
			BEGIN
				DECLARE @order INT=0;

				SELECT @order=MAX([Order]) FROM AT2.tblEmployees

				INSERT INTO AT2.tblEmployees (FirstName,LastName,MapleID,BiometricID,DepartmentID,DesignationID,WorkEmail,PersonalEmail,Mobile
				,Gender,DOB,DOJ,MaritalStatus,DOA,BloodGroup,EmergencyContactPerson,EmergencyContactRelation,EmergencyContactNumber,UserID,[Password]
				,IsAdmin,IsActive,ActivatedDate, [Order],SlackId)
				VALUES(@nFirstName,@nLastName,@iMapleID,@iEmpBiometricID,@iEmpDepartmentID,@iEmpDigID,@nEmpMail,@nEmpPersonalEmail,@nEmpMob,
				@nEmpGender,@nEmpDOB,@nEmpDOJ,@nEmpMaritalStatus,@nEmpDOA,@nEmpBloodGroup,@nEmpEmergencyContactPerson,@nEmpEmergencyContactRelation
				,@nEmpEmergencyContactNumber,@nUserid,@nPassword,0,1,@dtActiveDate, @order,@nSlackId)
		
				SET @iRetVal = SCOPE_IDENTITY();
	END
	ELSE SET @iRetVal = -1;
END

ELSE IF(@iMode = 106)
BEGIN
	SELECT E.FirstName,E.LastName,E.EmployeeID,E.BiometricID,E.DepartmentID,D.Designation,E.WorkEmail,E.PersonalEmail,E.Mobile
	,E.Gender,E.DOB,E.DOJ,E.MaritalStatus,E.DOA,E.BloodGroup,E.EmergencyContactPerson,E.EmergencyContactRelation,E.EmergencyContactNumber
	,E.IsAdmin,E.IsActive, E.[Order]
	FROM AT2.tblEmployees E 
		INNER JOIN AT2.tblDesignations D ON E.DesignationID=D.DesignationID where e.IsActive=1 
	ORDER BY [IsActive] DESC, [Order] ASC
	
	--SELECT E.EmployeeID, E.FirstName AS Name,D.Designation,E.Mobile,E.WorkEmail AS Email,E.IsActive,E.IsAdmin
	--	FROM AT2.tblEmployees E INNER JOIN AT2.tblDesignations D ON E.DesignationID=D.DesignationID 
	--ORDER BY [Order] ASC
END

ELSE IF(@iMode=107)
BEGIN
	-- Checks whether the old password is correct or not
	IF EXISTS(SELECT EmployeeID FROM AT2.tblEmployees WHERE EmployeeID=@iEmpID AND [Password]=@vOldPassword AND ISNULL(IsActive,1)=1)
	BEGIN
		UPDATE AT2.tblEmployees
			SET [Password]=@nPassword
		WHERE EmployeeID=@iEmpID	

		SET @iRetVal = @iEmpID
	END
	ELSE
	BEGIN
		SET @iRetVal = -1
	END
END

ELSE IF(@iMode=108)
BEGIN
SELECT * FROM AT2.tblDesignations
END
ELSE IF(@iMode=109)
BEGIN
SELECT E.EmployeeID, E.FirstName,E.LastName,E.BiometricID,E.DepartmentID,E.DesignationID,E.WorkEmail AS Email,E.PersonalEmail,
E.Mobile,E.Gender,E.DOB,E.DOJ,E.MaritalStatus,E.DOA,E.BloodGroup,E.EmergencyContactPerson,E.EmergencyContactRelation,D.Designation
,E.EmergencyContactNumber,E.IsActive,E.IsAdmin FROM AT2.tblEmployees E INNER JOIN AT2.tblDesignations D 
ON E.DesignationID=D.DesignationID WHERE E.IsActive=@IsActive ORDER BY [Order] ASC

--SELECT E.EmployeeID, E.FirstName,E.LastName,E.BiometricID AS Name,D.Designation,E.Mobile,E.WorkEmail AS Email,E.IsActive,E.IsAdmin
--		FROM AT2.tblEmployees E INNER JOIN AT2.tblDesignations D ON E.DesignationID=D.DesignationID WHERE E.IsActive=@IsActive
--	ORDER BY [Order] ASC
END

---deactivate
if(@iMode=110)
begin
update AT2.tblEmployees set IsActive=1^IsActive WHERE EmployeeID=@iEmpID 
set @iRetVal=1
end


END





GO
/****** Object:  StoredProcedure [AT2].[USP_GetHolidays]    Script Date: 5/28/2019 6:15:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [AT2].[USP_GetHolidays]
(
	@iMode INT = -1,
	@Year NVARCHAR(50) = NULL,
	@Date NVARCHAR(50) = NULL,
	@Day NVARCHAR(50) = NULL,
	@Festival NVARCHAR(50) = NULL,
	@iRetVal INT = -1 OUTPUT
)
AS
BEGIN
	IF(@iMode = 100)
	BEGIN
		DELETE FROM AT2.tblHolidays WHERE [Year] = @Year
	END

	ELSE IF(@iMode = 101)
	BEGIN
		--IF NOT EXISTS(SELECT YEAR FROM AT2.tblHolidays WHERE YEAR = @Year)
		--BEGIN	
		INSERT INTO AT2.tblHolidays
		(
			[year]
			,[Date]
			,[Day]
			,Festival
		)
		VALUES
		(
			@Year
			,@Date
			,@Day
			,@Festival
		)

		SET @iRetVal = SCOPE_IDENTITY()
		--END

		--ELSE If EXISTS(SELECT YEAR FROM AT2.tblHolidays WHERE YEAR = @Year)
		--BEGIN
		--Delete from AT2.tblHolidays  WHERE YEAR = @Year
		--INSERT INTO AT2.tblHolidays([year],[Date],[Day],Festival)
		--	VALUES(@Year,@Date,@Day,@Festival)		
		--	SET @iRetVal = SCOPE_IDENTITY();	
		--END
		--ELSE SET @iRetVal = -1	
	END

	else If(@iMode=102)
	begin
	select * from AT2.tblHolidays where [Year]=@Year
	end
END

GO
/****** Object:  StoredProcedure [AT2].[USP_GetMissingEntries]    Script Date: 5/28/2019 6:15:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


--[ATT].[USP_GetMissingEntries] '01/01/2019','01/31/2019','3'
CREATE PROCEDURE [AT2].[USP_GetMissingEntries](
@dtFromDate DATETIME='01/01/1900'
,@dtToDate DATETIME='01/01/1900'
,@vEmployeeIDs VARCHAR(100)='-1'
)
AS 
BEGIN

	--SELECT E.EmployeeID,E.FirstName+', '+ E.LastName AS EmployeeName,D.Designation,ISNULL(A.ID,-1) AS [ID]
	--	,CONVERT(VARCHAR,[DATE],101) AS [Date]
	--	,CONVERT(VARCHAR(15),CAST(ISNULL(A.InTime,'00:00:00') AS TIME),100) AS [InTime]
	--	,CONVERT(VARCHAR(15),CAST(ISNULL(A.OutTime,'00:00:00') AS TIME),100) AS [OutTime]
	--	,ISNULL(A.Leave,-1) as [Leave],ISNULL(A.LeaveType,'-1') as [LeaveType]
	--	,CONVERT(VARCHAR(5),CAST(ISNULL(A.PermissionHrs,'00:00')AS TIME),100)AS [PermissionHrs]
	--FROM AT2.tblEmployees E 
	--	INNER JOIN AT2.tblDesignations D ON E.DesignationID=D.DesignationID
	--	LEFT OUTER JOIN AT2.tblAttendance A ON E.EmployeeID=A.EmployeeID 
	--		AND CAST(CONVERT(VARCHAR,[DATE],101) AS DATETIME) BETWEEN CAST(CONVERT(VARCHAR,@dtFromDate,101) AS DATETIME) 
	--			AND CAST(CONVERT(VARCHAR,@dtToDate,101) AS DATETIME)
	--WHERE ISNULL(E.IsActive,0)=1
	--	AND ((CAST(ISNULL(A.InTime,'00:00:00') AS TIME) >'00:00:00' AND CAST(ISNULL(A.OutTime,'00:00:00') AS TIME) ='00:00:00')
	--		OR (CAST(ISNULL(A.InTime,'00:00:00') AS TIME) ='00:00:00' AND CAST(ISNULL(A.OutTime,'00:00:00') AS TIME) >'00:00:00')
	--		OR ((CAST(ISNULL(A.InTime,'00:00:00') AS TIME) >'00:00:00' AND CAST(ISNULL(A.OutTime,'00:00:00') AS TIME) >'00:00:00')
	--			AND (CAST(ISNULL(A.InTime,'00:00:00') AS TIME) =CAST(ISNULL(A.OutTime,'00:00:00') AS TIME))))
	--	AND (@vEmployeeIDs='' OR (@vEmployeeIDs!='' AND A.EmployeeID IN (SELECT ISNULL(DATA,0) FROM DBO.SPLIT(@vEmployeeIDs,','))))
	--ORDER BY  E.[Order] ASC,[Date] ASC
SET @dtToDate=DATEADD(dd,-1,@dtToDate);
;WITH B(DATE) AS (
  SELECT CAST(@dtFromDate AS DATETIME)
  UNION ALL
  SELECT DATE+1
  FROM B
  WHERE DATE BETWEEN CAST(CONVERT(VARCHAR,@dtFromDate,101) AS DATETIME) 
				AND CAST(CONVERT(VARCHAR,@dtToDate,101) AS DATETIME)
  )
SELECT E.EmployeeID,E.FirstName+' '+ E.LastName AS EmployeeName,E.WorkEmail	
	,CONVERT(VARCHAR,B.[DATE],101) AS [Date]
	,CONVERT(VARCHAR(15),CAST(ISNULL(A.InTime,'00:00:00') AS TIME),100) AS [InTime]
	,CONVERT(VARCHAR(15),CAST(ISNULL(A.OutTime,'00:00:00') AS TIME),100) AS [OutTime]
	,ISNULL(A.Leave,-1) as [Leave],ISNULL(A.LeaveType,'-1') as [LeaveType]
	--,FORMAT(CAST(ISNULL(A.PermissionHrs,'00:00') AS DATETIME), 'hh:mm') AS [PermissionHrs]
	--,FORMAT(CAST(ISNULL(A.ExtraHrsWorked,'00:00') AS DATETIME), 'hh:mm') AS [ExtraHrsWorked]
	,CONVERT(VARCHAR(5),CAST(ISNULL(A.PermissionHrs,'00:00')AS TIME))AS [PermissionHrs]
	,CONVERT(VARCHAR(5),CAST(ISNULL(A.ExtraHrsWorked,'00:00')AS TIME))AS [ExtraHrsWorked]
	,ISNULL(A.WorkFromHome,-1) as WFH
	,CONVERT(VARCHAR(8),CAST(ISNULL(F.InTime,'00:00:00') AS TIME),100) AS CheckIn
	,CONVERT(VARCHAR(8),CAST(ISNULL(F.OutTime,'00:00:00') AS TIME),100) AS CheckOut
	,DOj as DOJ
	
	FROM B
		INNER JOIN AT2.tblEmployees E ON ISNULL(E.IsActive,0)=1 AND DATENAME(DW,B.[Date]) NOT IN ('Saturday','Sunday')
		INNER JOIN AT2.tblDesignations D ON E.DesignationID=D.DesignationID
		LEFT OUTER JOIN AT2.tblAttendance A ON E.EmployeeID=A.EmployeeID  AND CAST(CONVERT(VARCHAR,A.[DATE],101) AS DATETIME) = CAST(CONVERT(VARCHAR,B.Date,101) AS DATETIME) 
		LEFT OUTER JOIN AT2.tblAccessCardData F on F.CardId=E.BiometricID AND CAST(CONVERT(VARCHAR,F.Date,101) AS DATETIME) =CAST(CONVERT(VARCHAR,B.Date,101) AS DATETIME)
	WHERE (A.ID IS NULL OR ( A.ID IS NOT NULL AND ((CAST(ISNULL(A.InTime,'00:00:00') AS TIME) >'00:00:00' AND CAST(ISNULL(A.OutTime,'00:00:00') AS TIME) ='00:00:00')
			OR (CAST(ISNULL(A.InTime,'00:00:00') AS TIME) ='00:00:00' AND CAST(ISNULL(A.OutTime,'00:00:00') AS TIME) >'00:00:00')
			OR ((CAST(ISNULL(A.InTime,'00:00:00') AS TIME) >'00:00:00' AND CAST(ISNULL(A.OutTime,'00:00:00') AS TIME) >'00:00:00')
				AND (CAST(ISNULL(A.InTime,'00:00:00') AS TIME) =CAST(ISNULL(A.OutTime,'00:00:00') AS TIME))))))
		AND (@vEmployeeIDs='' OR (@vEmployeeIDs!='' AND E.EmployeeID IN (SELECT ISNULL(DATA,0) FROM DBO.SPLIT(@vEmployeeIDs,','))))
		AND EXISTS (SELECT TOP 1 Id FROM AT2.tblAttendance C WHERE CAST(CONVERT(VARCHAR,C.[DATE],101) AS DATETIME) = CAST(CONVERT(VARCHAR,B.Date,101) AS DATETIME))
		AND doj <  =CAST(CONVERT(VARCHAR,B.Date,101) AS DATETIME) 
	ORDER BY  E.[Order] ASC,[Date] ASC

OPTION (MAXRECURSION 0)
		
END 


GO
/****** Object:  StoredProcedure [AT2].[USP_GetMonthlyReport]    Script Date: 5/28/2019 6:15:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- AT2.USP_GetMonthlyReport '03/26/2019','04/26/2019'
CREATE PROC [AT2].[USP_GetMonthlyReport]
(
@dtFromDate DATETIME='01/01/1900'
,@dtToDate DATETIME='01/01/1900'
)
AS
BEGIN
	DECLARE @MonthReport TABLE
	(
	EmpID INT
	,Name VARCHAR(100)
	,Gender INT
	,EmployeeFullName Varchar(2000)
	,FirstName VARCHAR(100)
	,LastName VARCHAR(100)
	--,FullName Varchar(2000)
	,DurationMIN INT
	--,ExtraHrsWorked TIME(5)
	,Leaves DECIMAL(18,1)
	,SL DECIMAL(18,1)
	,PL DECIMAL(18,1)
	,ML DECIMAL(18,1)
	,COFF DECIMAL(18,1) 
	,WorkFromHome DECIMAL(18,1)
	,PermissionMin INT
	,ExtrahrsMin int
	,TotalDaysPresent DECIMAL(18,1)
	,[Order] INT
	
	)
	
	--IF(@dtToDate>=GETDATE())
	--	SET @dtTodate=GETDATE()
	
	INSERT INTO @MonthReport(EmpID,Name,Gender,FirstName,LastName,--FullName,
	DurationMIN,Leaves,PL,SL,ML,COFF,PermissionMin,ExtrahrsMin,TotalDaysPresent,[Order],WorkFromHome)
	SELECT E.EmployeeID, E.FirstName AS EmployeeName,E.Gender,E.FirstName AS FirstName,E.LastName as LastName --,'<img src="../images/profilepics/'+CONVERT(VARCHAR,E.EmployeeID)+'.jpg" width="20" class="profile-image img-circle"/>&nbsp;'+ E.FirstName as FullName 

	--,SUM(DATEDIFF(MINUTE, '00:00:00',CASE WHEN OutTime='00:00'  THEN '00:00' else CAST(DATEADD(SECOND, - DATEDIFF(SECOND, OutTime, InTime), '00:00:00') AS Time)end))
	--	-SUM(ISNULL((DATEPART(HOUR,PermissionHrs)*60) +DATEPART(MINUTE,PermissionHrs),0))
	--	+SUM(ISNULL((DATEPART(HOUR,ExtraHrsWorked)*60) +DATEPART(MINUTE,ExtraHrsWorked),0))
	,SUM(DATEDIFF(MINUTE, '00:00:00',CASE WHEN OutTime='00:00'  THEN '00:00' else CAST(DATEADD(SECOND, - DATEDIFF(SECOND, OutTime, InTime), '00:00:00') AS Time)end))
        - SUM(CASE WHEN OutTime='00:00'  THEN 0 else ISNULL((DATEPART(HOUR,PermissionHrs)*60) +DATEPART(MINUTE,PermissionHrs),0)end)
        +SUM(CASE WHEN OutTime='00:00'  THEN 0 else ISNULL((DATEPART(HOUR,ExtraHrsWorked)*60) +DATEPART(MINUTE,ExtraHrsWorked),0)end)

	,SUM(CASE  WHEN ISNULL(Leave,0)=1 AND ISNULL(LeaveType,0) IN (1,2,3) THEN 0.5 
		WHEN ISNULL(Leave,0)=2 AND ISNULL(LeaveType,0) IN (1,2,3) THEN 1 ELSE 0 END ) AS Leaves
	,SUM(CASE WHEN ISNULL(Leave,0)=1 AND ISNULL(LeaveType,0)=1 THEN 0.5
			WHEN ISNULL(Leave,0)=2 AND ISNULL(LeaveType,0)=1 THEN 1 
		ELSE 0 END ) AS PL	
	,SUM(CASE WHEN ISNULL(Leave,0)=1 AND ISNULL(LeaveType,0)=2 THEN 0.5
			WHEN ISNULL(Leave,0)=2 AND ISNULL(LeaveType,0)=2 THEN 1
		ELSE 0 END ) AS SL	
	,SUM(CASE WHEN ISNULL(Leave,0)=1 AND ISNULL(LeaveType,0)=3 THEN 0.5
			WHEN ISNULL(Leave,0)=2 AND ISNULL(LeaveType,0)=3 THEN 1
		ELSE 0 END ) AS ML	
	,SUM(CASE WHEN ISNULL(Leave,0)=1 AND ISNULL(LeaveType,0)=4 THEN 0.5
			WHEN ISNULL(Leave,0)=2 AND ISNULL(LeaveType,0)=4 THEN 1
		ELSE 0 END ) AS COFF	
	,SUM(ISNULL((DATEPART(HOUR,PermissionHrs)*60) +DATEPART(MINUTE,PermissionHrs),0)) AS PermissionMin
	,SUM(ISNULL((DATEPART(HOUR,ExtraHrsWorked)*60) +DATEPART(MINUTE,ExtraHrsWorked),0)) AS ExtrahrsMin
	,SUM(CASE	WHEN A.ID IS NULL THEN 0
				WHEN ISNULL(Leave,0)=1 THEN 0.5 -- Leave or COFF
				WHEN LeaveType IN(1,2,3) AND ISNULL(Leave,0)=2 THEN 0 -- Leaves
			ELSE 1 END ) AS TotalDaysPresent	
	,MAX(E.[Order]) AS [Order]
	,SUM(CASE  WHEN ISNULL(WorkFromHome,0)=1 THEN 0.5 
		WHEN ISNULL(WorkFromHome,0)=2 THEN 1 ELSE 0 END ) AS WorkFromHome
	FROM AT2.tblEmployees E
		LEFT OUTER JOIN AT2.tblAttendance A ON A.EmployeeID=E.EmployeeID
		AND CAST(CONVERT(VARCHAR,[Date],101) AS DATETIME) BETWEEN CAST(CONVERT(VARCHAR,@dtFromDate,101) AS DATETIME) 
			AND CAST(CONVERT(VARCHAR,@dtToDate,101) AS DATETIME)
		--AND CAST(CONVERT(VARCHAR,[Date],101) AS DATETIME) >= CAST(CONVERT(VARCHAR,@dtFromDate,101) AS DATETIME) 
		--AND CAST(CONVERT(VARCHAR,[Date],101) AS DATETIME) <=CAST(CONVERT(VARCHAR,@dtToDate,101) AS DATETIME)
	WHERE (ISNULL(E.IsActive,0)=1
			OR (ISNULL(E.IsActive,0)=0 AND (E.ActivatedDate>= CAST(CONVERT(VARCHAR,@dtFromDate,101) AS DATETIME))))
	GROUP BY E.FirstName, E.EmployeeID,E.LastName,E.Gender
		
	SELECT EmpID,  Gender, FirstName+' '+LastName   as Name, --FullName,
	FirstName,Left(LastName,1) as cLastName,LastName
		,Duration = CASE WHEN DurationMIN=0 THEN '0' ELSE ISNULL(RTRIM(DurationMIN/60) + ':' + RIGHT('0' + RTRIM(DurationMIN%60),2),'00:00') END
		--,Duration=LTRIM(STR(CAST(LEFT(CASE WHEN DurationMIN=0 THEN '0' ELSE ISNULL(RTRIM(DurationMIN/60) + ':' + RIGHT('0' + RTRIM(DurationMIN%60),2),'00:00') END, ISNULL(NULLIF(CHARINDEX(':', CASE WHEN DurationMIN=0 THEN '0' ELSE ISNULL(RTRIM(DurationMIN/60) + ':' + RIGHT('0' + RTRIM(DurationMIN%60),2),'00:00') END) - 1, -1), LEN(CASE WHEN DurationMIN=0 THEN '0' ELSE ISNULL(RTRIM(DurationMIN/60) + ':' + RIGHT('0' + RTRIM(DurationMIN%60),2),'00:00') END))) AS INT) +
		-- CAST(LEFT(CONVERT(VARCHAR(5), ISNULL(ExtraHrsWorked, '0:00'), 108), ISNULL(NULLIF(CHARINDEX(':', CONVERT(VARCHAR(5), ISNULL(ExtraHrsWorked, '0:00'), 108)) - 1, -1), LEN(CONVERT(VARCHAR(5), ISNULL(ExtraHrsWorked, '0:00'), 108)))) AS INT)))+':'+
		-- ltrim(str(CAST(RIGHT(CASE WHEN DurationMIN=0 THEN '0' ELSE ISNULL(RTRIM(DurationMIN/60) + ':' + RIGHT('0' + RTRIM(DurationMIN%60),2),'00:00') END,LEN(CASE WHEN DurationMIN=0 THEN '0' ELSE ISNULL(RTRIM(DurationMIN/60) + ':' + RIGHT('0' + RTRIM(DurationMIN%60),2),'00:00') END)-CHARINDEX(':',CASE WHEN DurationMIN=0 THEN '0' ELSE ISNULL(RTRIM(DurationMIN/60) + ':' + RIGHT('0' + RTRIM(DurationMIN%60),2),'00:00') END)) AS INT) +
		--  CAST(RIGHT(CONVERT(VARCHAR(5), ISNULL(ExtraHrsWorked, '0:00'), 108),LEN(CONVERT(VARCHAR(5), ISNULL(ExtraHrsWorked, '0:00'), 108))-CHARINDEX(':',CONVERT(VARCHAR(5), ISNULL(ExtraHrsWorked, '0:00'), 108))) AS INT)))
		,Leaves,SL,PL,ML,COFF
		,Permission = CASE WHEN PermissionMin=0 THEN '' ELSE RTRIM(PermissionMin/60) + ':' + RIGHT('0' + RTRIM(PermissionMin%60),2) END
		,ExtraHrsWorked = CASE WHEN ExtrahrsMin=0 THEN '' ELSE RTRIM(ExtrahrsMin/60) + ':' + RIGHT('0' + RTRIM(ExtrahrsMin%60),2) END
		--,DurationMIN =TotalDaysPresent
		,DurationMIN= CASE WHEN DurationMIN=0 OR TotalDaysPresent=0 THEN '0' ELSE CAST(((CAST(ISNULL(RTRIM(DurationMIN/60) + '.' + RIGHT('0' + RTRIM(DurationMIN%60),2),'0.0') AS DECIMAL(5,2))/TotalDaysPresent)) AS DECIMAL(18,2)) END
		,TotalDaysPresent
		,[Order],WorkFromHome
	FROM @MonthReport
	ORDER BY DurationMIN DESC
END
GO
/****** Object:  StoredProcedure [AT2].[USP_GetTime]    Script Date: 5/28/2019 6:15:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [AT2].[USP_GetTime]
(
@mode int=-1,
@fromdate datetime='01/01/1990',
@todate datetime='01/01/1990',
@employeeid int=-1
)
as
begin
select employeeid,left(convert(nvarchar(20),intime,108),5) as InTime,
left(convert(nvarchar(20),outtime,108),5) as OutTime,convert(date,Date,103) as [Date] from AT2.tblAttendance
where CAST(CONVERT(nVARCHAR(10),[Date],101) AS DATETIME) BETWEEN CAST(CONVERT(nVARCHAR(20),@fromdate,101) AS DATE) 
			AND CAST(CONVERT(nVARCHAR(20),@todate,101) AS DATE) and EmployeeID=@employeeid
end

GO
/****** Object:  StoredProcedure [AT2].[USP_GetTimeReport]    Script Date: 5/28/2019 6:15:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [AT2].[USP_GetTimeReport]
(
@mode int=-1,
@fromdate datetime='01/01/1990',
@todate datetime='01/01/1990',
@employeeid int=-1
)
as
begin
select a.EmployeeID,e.FirstName,replace(left(convert(nvarchar(20),intime,108),5),':','.') as InTime,
case 
when replace(left(convert(nvarchar(20),intime),5),':','.')='00.00' and replace(left(convert(nvarchar(20),outtime),5),':','.')='00.00' 
then '00.00'
when replace(left(convert(nvarchar(20),intime),5),':','.')=replace(left(convert(nvarchar(20),outtime),5),':','.')
then replace(left(convert(nvarchar(20),outtime),5),':','.')
when replace(left(convert(nvarchar(20),outtime),5),':','.') between '00.01' and '12.00'
then '23.59'
else replace(left(convert(nvarchar(20),outtime),5),':','.') end as OutTime,
convert(nvarchar(20),Date,101) as [Date] from AT2.tblAttendance a
join AT2.tblEmployees e on a.EmployeeID=e.EmployeeID
where CAST(CONVERT(nVARCHAR(20),[Date],101) AS DATETIME) BETWEEN CAST(CONVERT(nVARCHAR(20),@fromdate,101) AS DATE) 
			AND CAST(CONVERT(nVARCHAR(20),@todate,101) AS DATE) and e.EmployeeID=@employeeid order by [date] 
end




GO
/****** Object:  StoredProcedure [AT2].[USP_GetUsers]    Script Date: 5/28/2019 6:15:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [AT2].[USP_GetUsers]
(
	@iMode INT = -1
	,@vUserID NVARCHAR(50) = ''
	,@vPassword NVARCHAR(200) = ''
)
AS
BEGIN
	IF(@iMode = 101)
	BEGIN
		SELECT
			A.*
			,D.Designation,a.IsActive
		FROM AT2.tblEmployees A
		INNER JOIN AT2.tblDesignations D ON A.DesignationID = D.DesignationID
		WHERE ISNULL(A.IsActive, 0) = 1 AND UserID = @vUserID AND [Password] = @vPassword
	END

	ELSE IF(@iMode = 102)
	BEGIN
		SELECT
			A.*
			,D.Designation
		FROM AT2.tblEmployees A
		INNER JOIN AT2.tblDesignations D ON A.DesignationID = D.DesignationID
		WHERE ISNULL(A.IsActive, 0) = 1 AND ISNULL(IsBilling, 0) = 1 AND UserID = @vUserID AND [Password] = @vPassword
	END
END

GO
/****** Object:  StoredProcedure [AT2].[USP_IUD_Departments]    Script Date: 5/28/2019 6:15:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [AT2].[USP_IUD_Departments]
(
@Mode int=-1,
@departmentId int=-1,
@departmentName nvarchar(100)='',
@active bit=0,
@iRetVal int=-1 output
)
as
begin

--insert
if(@Mode=100)
begin
if not exists(select * from AT2.tblDepartments where Department=@departmentName)
begin
insert into AT2.tblDepartments(Department,IsActive) values(@departmentName,1)
set @iRetVal=SCOPE_IDENTITY()	
end
else
 set @iRetVal=-1
end

--update
else if(@Mode=101)
begin
if not exists(select * from AT2.tblDepartments where Department=@departmentName)
begin
update AT2.tblDepartments set Department=@departmentName  where DepartmentId=@departmentId
set @iRetVal=1
end
end

--getDetails
else if(@Mode=102)
begin
select * from AT2.tblDepartments where IsActive=@active
end

--GetDetailsById
else if(@Mode=103)
begin
select * from AT2.tblDepartments where DepartmentId=@departmentId
end

--Delete
else if(@Mode=104)
begin
if not exists(select EmployeeID from AT2.tblEmployees where DepartmentID=@departmentId and IsActive=1)
begin
update AT2.tblDepartments set IsActive=1^IsActive where DepartmentId=@departmentId
set @iRetVal=1
end
else 
begin
set @iRetVal=-1
end

end


--Active
else if(@Mode=105)
begin
select * from AT2.tblDepartments where IsActive=@active
end

end

GO
/****** Object:  StoredProcedure [AT2].[USP_IUD_Designation]    Script Date: 5/28/2019 6:15:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [AT2].[USP_IUD_Designation]
(
@Mode int=-1,
@designationId int=-1,
@designationName nvarchar(100)='',
@active bit=1,
@iRetVal int=-1 output
)
as
begin

--insert
if(@Mode=100)
begin
if not exists(select * from AT2.tblDesignations where Designation=@designationName)
begin
insert into AT2.tblDesignations(Designation,IsActive) values(@designationName,1)
set @iRetVal=SCOPE_IDENTITY()
end
else
set @iRetVal=-1
end

--update
else if(@Mode=101)
begin
if not exists(select * from AT2.tblDesignations where Designation=@designationName)
begin
update AT2.tblDesignations set Designation=@designationName  where DesignationID=@designationId
set @iRetVal=1
end
end

--getDetails
else if(@Mode=102)
begin
select * from AT2.tblDesignations where IsActive=@active
end

--GetDetailsById
else if(@Mode=103)
begin
select * from AT2.tblDesignations where DesignationID=@designationId
end

--Delete
else if(@Mode=104)
begin
if not exists(select * from AT2.tblEmployees where DesignationID=@designationId and IsActive=1)
begin
update AT2.tblDesignations set IsActive=1^IsActive where DesignationID=@designationId
set @iRetVal=1
end 
else 
begin
set @iRetVal=-1
end
end

--Active
else if(@Mode=105)
begin
select * from AT2.tblDesignations where IsActive=@active
end

end

GO
/****** Object:  StoredProcedure [AT2].[USP_ResetPassword]    Script Date: 5/28/2019 6:15:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO






CREATE proc [AT2].[USP_ResetPassword]
(
@iMode INT=-1,
@iEmpID INT=NULL,
@IsAdmin BIT=0,
@IsActive BIT=1,
@nPassword NVARCHAR(200)=NULL,
@nUserid NVARCHAR(50)=NULL,
@iRetVal INT=-1 OUTPUT

)
AS
BEGIN
if(@iMode=101)
begin
-- Password: Maple@123
update AT2.tblEmployees set Password='f8fd8848f8fcc2922342d768e3abc067b326cfaf' WHERE EmployeeID=@iEmpID and IsActive=1
set @iRetVal=101
end

END





GO
/****** Object:  StoredProcedure [BILL].[USP_Clients]    Script Date: 5/28/2019 6:15:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [BILL].[USP_Clients]  
(
    @Mode int = -1,
	@clientid int = -1,
	@clientname nvarchar(250) = '',
	@countryid int = -1,
	@BillingTypeId int = -1,
	@active bit = 0,
	@createdby int = -1,
	--@updatedby int = -1,
    @iRetVal int = -1 output
)

AS
BEGIN
	/*Get All Clients*/
 IF(@Mode=100)
	BEGIN
		   /*SELECT * FROM BILL.tblClients*/
		   SELECT ClientId,a.CountryId,a.BillingTypeId, ClientName, CountryName, BillingType, a.IsActive FROM BILL.tblClients a JOIN BILL.tblCountry b ON a.CountryId = b.CountryId
	       JOIN BILL.tblBillingType c ON a.BillingTypeId = c.BillingTypeId
	END

	/*Get Clientdetails by ClientID*/
	ELSE IF (@Mode=101)
	BEGIN
	        SELECT ClientId,a.CountryId,a.BillingTypeId, ClientName, CountryName, BillingType, a.IsActive FROM BILL.tblClients a JOIN BILL.tblCountry b ON a.CountryId = b.CountryId
	       JOIN BILL.tblBillingType c ON a.BillingTypeId = c.BillingTypeId
	        WHERE ClientId = @clientid
    END

	/*Insert Clients*/
    ELSE IF(@Mode=102)
    BEGIN
	IF NOT EXISTS(SELECT ClientId FROM BILL.tblClients WHERE ClientName = @clientname)
	BEGIN
	      INSERT INTO BILL.tblClients
			 (
			   ClientName,
			   CountryId,
			   BillingTypeId,
			   IsActive,
			   CreatedOn,
			   CreatedBy,
			   UpdatedOn,
			   UpdatedBy
		     )
			 VALUES 
			 (
			    @clientname,
				@countryid,
				@BillingTypeId,
				1,
				GETDATE(),
				1,
				GETDATE(),
				1
              )

			  	SET @iRetVal = SCOPE_IDENTITY()
		END
		ELSE SET @iRetVal = -1
	END

	/*Update by Clientid*/
    ELSE IF(@Mode=103)
	BEGIN 
		IF NOT EXISTS(SELECT ClientId FROM BILL.tblClients WHERE ClientName =  @clientname AND ClientId <> @clientid)
		BEGIN
			UPDATE BILL.tblClients
			SET ClientName = @clientname,CountryId = @countryid,BillingTypeId = @BillingTypeId,UpdatedOn = GETDATE(),UpdatedBy = @createdby
			WHERE ClientId = @clientid 
		END
		SET @iRetVal = @clientid
	END

	/*Active*/
	ELSE IF (@Mode=104)
	BEGIN
		UPDATE BILL.tblClients
		SET IsActive = ~IsActive
		WHERE ClientId = @clientid	
		SET @iRetVal = @clientid
	END
END

GO
